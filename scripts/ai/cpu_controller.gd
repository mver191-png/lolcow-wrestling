class_name CPUController
extends Node

## Commands only: no direct damage, resource grants, outcome overrides or input
## peeking. Decision randomness is private, never shared with sound or rendering.
@export var fighter: Fighter
@export var reaction_interval: float = 0.22
@export var escape_mash_interval: float = 0.10

# Hysteresis keeps an exhausted wrestler from guarding away every regenerated
# stamina point. These are AI choices, not changes to gameplay resource rules.
const REST_ENTER_RATIO := 0.25
const REST_EXIT_RATIO := 0.55
const REST_SPACING := 1.85
const REST_MOVE_STRENGTH := 0.38
const STANDING_STATES := [Fighter.State.IDLE, Fighter.State.MOVING, Fighter.State.BLOCKING]
var timer := 0.0
var escape_timer := 0.0
var think_state := "approach"
var recovering_stamina := false
var _rng := RandomNumberGenerator.new()
var _seed_configured := false
var _continuous: Dictionary = {}
var _previous_state := -1

func _init() -> void:
	# Deliver all commands before Fighter priority 0, regardless of tree order.
	process_physics_priority = -10

func set_decision_seed(value: int) -> void:
	_rng.seed = value
	_seed_configured = true

func _ready() -> void:
	if not is_instance_valid(fighter):
		return
	fighter.is_cpu = true
	if not _seed_configured:
		set_decision_seed(MatchConfig.match_seed + fighter.player_index * 104729)

func reset_commands() -> void:
	timer = 0.0
	escape_timer = 0.0
	_continuous.clear()
	recovering_stamina = false
	_previous_state = -1
	if is_instance_valid(fighter):
		fighter.clear_inputs()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(fighter):
		return
	var state := fighter.current_state
	if state != _previous_state:
		# Preserve current movement/guard across locomotion transitions, but never
		# queue standing commands across a knockdown, hold or recovery.
		if state not in STANDING_STATES or _previous_state not in STANDING_STATES:
			_continuous.clear()
		_previous_state = state
	if state in [Fighter.State.PINNED, Fighter.State.SUBMISSION_DEFENDER]:
		escape_timer += delta
		var vitality_ratio := clampf(fighter.vitality / fighter.max_vitality, 0.0, 1.0)
		var stamina_ratio := clampf(fighter.stamina / fighter.max_stamina, 0.0, 1.0)
		var fatigue := 1.0 - (0.6 * vitality_ratio + 0.4 * stamina_ratio)
		var interval := (escape_mash_interval + 0.04 * fatigue) * (1.2 - fighter.stat_reversal * 0.04)
		var pulse := escape_timer >= maxf(interval, 0.001)
		if pulse:
			escape_timer = 0.0
		fighter.apply_command({"pin":pulse, "strike":pulse})
		think_state = "escape"
		return
	escape_timer = 0.0
	if state not in STANDING_STATES or not is_instance_valid(fighter.opponent):
		fighter.apply_command({})
		_continuous.clear()
		think_state = "committed" if state not in [Fighter.State.VICTORY,Fighter.State.DEFEATED] else "finished"
		return
	timer += delta
	if timer >= maxf(reaction_interval, 0.001):
		timer = 0.0
		_think()
	else:
		# Only movement and guard persist between thoughts; pulses are not replayed.
		fighter.apply_command(_continuous)

func _send(command: Dictionary, intent: String) -> void:
	fighter.apply_command(command)
	_continuous = {"move":command.get("move",Vector2.ZERO),"block":command.get("block",false)}
	think_state = intent

func _think() -> void:
	if not is_instance_valid(fighter) or not is_instance_valid(fighter.opponent):
		return
	if fighter.current_state not in STANDING_STATES:
		_send({},"committed")
		return
	var opponent := fighter.opponent
	var my_position: Vector3 = fighter.global_position if fighter.is_inside_tree() else fighter.position
	var opponent_position: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
	var to_opponent := Vector2(opponent_position.x-my_position.x,opponent_position.z-my_position.z)
	var distance := to_opponent.length()
	var direction := to_opponent.normalized()
	var stamina_ratio := fighter.stamina / maxf(fighter.max_stamina,1.0)
	if stamina_ratio <= REST_ENTER_RATIO:
		recovering_stamina = true
	elif stamina_ratio >= REST_EXIT_RATIO:
		recovering_stamina = false

	# Finishing a viable pin need not spend additional stamina. Do not otherwise
	# chase a healthy downed target while exhausted instead of taking a breather.
	if opponent.current_state == Fighter.State.KNOCKED_DOWN and not recovering_stamina:
		_send({"pin":true} if distance<=1.6 else {"move":direction},"pin_setup")
		return
	if recovering_stamina:
		var retreat := Vector2.ZERO
		if distance < REST_SPACING:
			retreat = -direction
			# Stay off the ropes. Move toward center when already at an edge, rather
			# than continuously asking the clamp to cancel an outward retreat.
			var radial := Vector2(my_position.x,my_position.z)
			if maxf(absf(radial.x),absf(radial.y)) > 2.65:
				retreat = (-radial).normalized()
			retreat *= REST_MOVE_STRENGTH
		_send({"move":retreat},"recover_stamina")
		return

	if opponent.current_state == Fighter.State.STRIKING and distance<=fighter.reach_distance+0.2:
		if _rng.randf() < fighter.stat_reversal*0.08 and fighter.stamina>=MatchRules.REVERSAL_STAMINA_COST:
			_send({"reversal":true},"reverse_strike")
			return
		if _rng.randf() < 0.6:
			_send({"block":true},"guard")
			return
	if opponent.current_state == Fighter.State.GRAPPLE_STARTUP and distance<=fighter.reach_distance+0.2:
		if _rng.randf() < fighter.stat_reversal*0.10 and fighter.stamina>=MatchRules.REVERSAL_STAMINA_COST:
			_send({"reversal":true},"reverse_grapple")
			return
		if _rng.randf() < 0.7 and fighter.stamina>=MatchRules.STRIKE_STAMINA_COST:
			_send({"strike":true},"interrupt")
			return
	if opponent.current_state in [Fighter.State.VICTORY,Fighter.State.DEFEATED]:
		_send({},"finished")
	elif distance > fighter.reach_distance:
		_send({"move":direction},"approach")
	elif opponent.current_state==Fighter.State.BLOCKING and fighter.stamina>=MatchRules.GRAPPLE_STAMINA_COST:
		_send({"grapple":true},"break_guard")
	else:
		var preference := float(fighter.stat_grappling) / float(fighter.stat_grappling+fighter.stat_power)
		if _rng.randf()<preference and fighter.stamina>=MatchRules.GRAPPLE_STAMINA_COST:
			_send({"grapple":true},"grapple")
		elif fighter.stamina>=MatchRules.STRIKE_STAMINA_COST:
			_send({"strike":true},"strike")
		else:
			# A neutral command allows normal regeneration. Guard is not rest.
			_send({},"recover_stamina")
