class_name CPUController
extends Node

## Tactical CPU wrestler controller.
## Drives standard Fighter input interface with realistic reaction intervals
## and profile-tailored tactical choices.

@export var fighter: Fighter
@export var reaction_interval: float = 0.22 # Reaction delay in seconds
@export var escape_mash_interval: float = 0.10 # Cadence for CPU escape mashing

var timer: float = 0.0
var escape_timer: float = 0.0
var think_state: String = "approach"

func _ready() -> void:
	if fighter:
		fighter.is_cpu = true

func _physics_process(delta: float) -> void:
	if not is_instance_valid(fighter):
		return
		
	# Active escape mashing during PINNED or SUBMISSION_DEFENDER
	if fighter.current_state in [Fighter.State.PINNED, Fighter.State.SUBMISSION_DEFENDER]:
		escape_timer += delta
		var vit_ratio: float = clamp(fighter.vitality / fighter.max_vitality, 0.0, 1.0)
		var stam_ratio: float = clamp(fighter.stamina / fighter.max_stamina, 0.0, 1.0)
		var fatigue: float = 1.0 - (0.6 * vit_ratio + 0.4 * stam_ratio)
		# Mashing cadence scales with reversal stat and physical fatigue (exhausted CPU struggles at ~6-7 Hz, fresh at 10 Hz)
		var effective_interval: float = (escape_mash_interval + 0.04 * fatigue) * (1.2 - (fighter.stat_reversal * 0.04))
		if escape_timer >= effective_interval:
			escape_timer = 0.0
			fighter.input_pin = true
			fighter.input_strike = true
		return
	else:
		escape_timer = 0.0
	
	if not is_instance_valid(fighter.opponent):
		return
	
	timer += delta
	if timer >= reaction_interval:
		timer = 0.0
		_think()

func _think() -> void:
	var opp: Fighter = fighter.opponent
	var opp_pos: Vector3 = opp.global_position if opp.is_inside_tree() else opp.position
	var my_pos: Vector3 = fighter.global_position if fighter.is_inside_tree() else fighter.position
	var dist: float = my_pos.distance_to(opp_pos)
	
	# Clear pulse inputs
	fighter.input_strike = false
	fighter.input_grapple = false
	fighter.input_block = false
	fighter.input_reversal = false
	fighter.input_pin = false
	
	# Check if opponent is downed -> attempt pin!
	if opp.current_state == Fighter.State.KNOCKED_DOWN:
		if dist <= 1.6:
			fighter.input_dir = Vector2.ZERO
			fighter.input_pin = true
		else:
			# Approach downed opponent
			var to_opp: Vector3 = (opp_pos - my_pos).normalized()
			fighter.input_dir = Vector2(to_opp.x, to_opp.z)
		return
		
	# Check if I am pinned or in submission -> escape mash!
	if fighter.current_state in [Fighter.State.PINNED, Fighter.State.SUBMISSION_DEFENDER]:
		fighter.input_pin = true
		fighter.input_strike = true
		return
		
	# Tactical in-ring spacing
	var to_opp_2d: Vector2 = Vector2(opp_pos.x - my_pos.x, opp_pos.z - my_pos.z)
	var dir_norm: Vector2 = to_opp_2d.normalized()
	
	# If opponent is striking and within range, test reversal or block
	if opp.current_state == Fighter.State.STRIKING and dist <= fighter.reach_distance + 0.2:
		var rev_chance: float = fighter.stat_reversal * 0.08
		if randf() < rev_chance and fighter.stamina >= MatchRules.REVERSAL_STAMINA_COST:
			fighter.input_reversal = true
			return
		elif randf() < 0.6:
			fighter.input_block = true
			return
			
	# If opponent is in grapple startup and within range, test reversal or strike interrupt
	if opp.current_state == Fighter.State.GRAPPLE_STARTUP and dist <= fighter.reach_distance + 0.2:
		var rev_chance: float = fighter.stat_reversal * 0.10
		if randf() < rev_chance and fighter.stamina >= MatchRules.REVERSAL_STAMINA_COST:
			fighter.input_reversal = true
			return
		elif randf() < 0.7 and fighter.stamina >= MatchRules.STRIKE_STAMINA_COST:
			fighter.input_strike = true
			return

	# Character specific behavior
	if dist <= fighter.reach_distance:
		fighter.input_dir = Vector2.ZERO
		
		# Rock-paper-scissors choices
		if opp.current_state == Fighter.State.BLOCKING:
			# Grapple breaks guard!
			fighter.input_grapple = true
		else:
			var grapple_pref: float = float(fighter.stat_grappling) / float(fighter.stat_grappling + fighter.stat_power)
			if randf() < grapple_pref and fighter.stamina >= MatchRules.GRAPPLE_STAMINA_COST:
				fighter.input_grapple = true
			elif fighter.stamina >= MatchRules.STRIKE_STAMINA_COST:
				fighter.input_strike = true
			else:
				fighter.input_block = true
	else:
		# Approach opponent
		fighter.input_dir = dir_norm
