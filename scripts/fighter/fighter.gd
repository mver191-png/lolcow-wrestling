class_name Fighter
extends CharacterBody3D

## Core Fighter controller for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Enforces rigid state machine, single movement ownership, single-hit damage,
## and synchronized grapple/throw locking.

signal vitality_changed(current: float, maximum: float)
signal stamina_changed(current: float, maximum: float)
signal hype_changed(current: float, maximum: float)
signal state_changed(old_state: int, new_state: int)
signal hit_landed(attacker: Fighter, target: Fighter, damage: float, was_blocked: bool)
signal throw_impact(attacker: Fighter, defender: Fighter)
signal pin_initiated(pinner: Fighter, pinned: Fighter)
signal kick_out_succeeded(fighter: Fighter)
signal submission_initiated(attacker: Fighter, defender: Fighter)
signal submission_escaped(fighter: Fighter)
signal tap_out_submitted(fighter: Fighter)
signal character_loaded(fighter: Fighter)

enum State {
	IDLE,
	MOVING,
	STRIKING,
	BLOCKING,
	REVERSAL_STANCE,
	GRAPPLE_STARTUP,
	GRAPPLING_ATTACKER,
	GRAPPLING_DEFENDER,
	KNOCKED_DOWN,
	GETTING_UP,
	PINNING,
	PINNED,
	SUBMISSION_ATTACKER,
	SUBMISSION_DEFENDER,
	VICTORY,
	DEFEATED
}

@export var character_id: String = "tophiachu"
@export var player_index: int = 1 # 1 = P1, 2 = P2
@export var is_cpu: bool = false

# Visual nodes
@export var visual_root: Node3D
@export var left_arm: Node3D
@export var right_arm: Node3D
const FighterPresentationScript = preload("res://scripts/fighter/fighter_presentation.gd")
var anim_player: AnimationPlayer = null
var presentation = null

func is_rigged() -> bool:
	return presentation != null and presentation.has_skeletal_rig

# Internal attributes scaled from RosterData
var char_name: String = "Fighter"
var char_title: String = "Wrestler"
var max_vitality: float = 1000.0
var vitality: float = 1000.0
var max_stamina: float = 100.0
var stamina: float = 100.0
var hype: float = 0.0

# Stats (1-10)
var stat_power: int = 5
var stat_mobility: int = 5
var stat_grappling: int = 5
var stat_stamina: int = 5
var stat_durability: int = 5
var stat_reversal: int = 5
var stat_showmanship: int = 5
var reach_distance: float = 1.2

# State machine
var current_state: State = State.IDLE
var opponent: Fighter = null

# Attack & Grapple tracking
var current_attack_id: int = 0
var attack_has_damaged: bool = false
var strike_move: Dictionary = {}
var strike_resolved_hits: Dictionary = {}
var state_timer: float = 0.0
var active_frame_start: float = 0.0
var active_frame_end: float = 0.0
var attack_total_time: float = 0.0

# Synchronized grapple parameters
var throw_duration: float = 1.1
var throw_impact_time: float = 0.6
var throw_has_impacted: bool = false
var synchronized_partner: Fighter = null
var initial_defender_local_pos: Vector3 = Vector3.ZERO

# Pin escape tracking
var pin_escape_progress: float = 0.0
var knockdown_duration: float = 2.5
var recent_finisher_impact_timer: float = 0.0
var recent_heavy_impact_timer: float = 0.0

# Input buffer
var input_dir: Vector2 = Vector2.ZERO
var input_strike: bool = false
var input_grapple: bool = false
var input_block: bool = false
var input_reversal: bool = false
var input_pin: bool = false
var input_finisher: bool = false
var input_hold_pin: bool = false
var prev_pin_held: bool = false
# Replay/test providers opt in explicitly. Hardware must never retain old commands.
var use_external_input: bool = false

func _init() -> void:
	# Priority 0 ensures fighters update movement, mechanics, and input processing
	# before MatchManager (priority 10) resolves match rules and terminal outcomes.
	process_physics_priority = 0

func _ready() -> void:
	load_character_data()

func load_character_data(p_character_id: String = "") -> void:
	if p_character_id != "":
		character_id = p_character_id
	var data: Dictionary = RosterData.get_character(character_id)
	if data.is_empty():
		return
	
	char_name = data.get("name", "Fighter")
	char_title = data.get("title", "")
	var stats: Dictionary = data.get("stats", {})
	stat_power = stats.get("power", 5)
	stat_mobility = stats.get("mobility", 5)
	stat_grappling = stats.get("grappling", 5)
	stat_stamina = stats.get("stamina", 5)
	stat_durability = stats.get("durability", 5)
	stat_reversal = stats.get("reversal", 5)
	stat_showmanship = stats.get("showmanship", 5)
	
	var visual: Dictionary = data.get("visual", {})
	reach_distance = visual.get("reach", 1.2)
	
	# Compute derived stats
	max_vitality = 700.0 + (stat_durability * 50.0)
	vitality = max_vitality
	max_stamina = 60.0 + (stat_stamina * 8.0)
	stamina = max_stamina
	hype = 0.0
	
	vitality_changed.emit(vitality, max_vitality)
	stamina_changed.emit(stamina, max_stamina)
	hype_changed.emit(hype, MatchRules.MAX_HYPE)

	if visual_root:
		if presentation == null:
			presentation = FighterPresentationScript.new()
			presentation.name = "FighterPresentation"
			add_child(presentation)
			presentation.setup(self, visual_root)
		presentation.load_model(character_id)
		anim_player = presentation.anim_player
	
	character_loaded.emit(self)

func _physics_process(delta: float) -> void:
	if recent_finisher_impact_timer > 0.0:
		recent_finisher_impact_timer = max(0.0, recent_finisher_impact_timer - delta)
	if recent_heavy_impact_timer > 0.0:
		recent_heavy_impact_timer = max(0.0, recent_heavy_impact_timer - delta)
		
	if not is_cpu and not use_external_input:
		_gather_player_inputs()
	
	_tick_stamina(delta)
	_update_state_machine(delta)
	if presentation:
		presentation.update_locomotion_stride()
	_clamp_within_ring()
	_clear_consumed_pulse_inputs()

func _gather_player_inputs() -> void:
	var prefix: String = "p" + str(player_index) + "_"
	input_dir = Input.get_vector(prefix + "left", prefix + "right", prefix + "up", prefix + "down")
	input_strike = Input.is_action_just_pressed(prefix + "strike")
	input_grapple = Input.is_action_just_pressed(prefix + "grapple")
	input_block = Input.is_action_pressed(prefix + "block")
	input_reversal = Input.is_action_just_pressed(prefix + "reversal")
	var pin_down: bool = Input.is_action_pressed(prefix + "pin")
	input_pin = pin_down and not prev_pin_held
	input_hold_pin = pin_down
	prev_pin_held = pin_down
	input_finisher = Input.is_action_just_pressed(prefix + "finisher")

func clear_inputs() -> void:
	input_dir = Vector2.ZERO
	input_block = false
	input_hold_pin = false
	prev_pin_held = false
	_clear_consumed_pulse_inputs()

func apply_command(command: Dictionary) -> void:
	# Complete snapshot; omitted continuous fields intentionally become neutral.
	var movement: Vector2 = command.get("move", Vector2.ZERO)
	input_dir = movement.limit_length(1.0)
	input_block = command.get("block", false)
	input_hold_pin = command.get("hold_pin", false)
	input_strike = command.get("strike", false)
	input_grapple = command.get("grapple", false)
	input_reversal = command.get("reversal", false)
	input_pin = command.get("pin", false)
	input_finisher = command.get("finisher", false)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		clear_inputs()

func _clear_consumed_pulse_inputs() -> void:
	input_strike = false
	input_grapple = false
	input_reversal = false
	input_pin = false
	input_finisher = false

func _tick_stamina(delta: float) -> void:
	if current_state == State.BLOCKING:
		stamina = max(0.0, stamina - MatchRules.BLOCK_STAMINA_DRAIN * delta)
		if stamina <= 0.0:
			_set_state(State.IDLE) # Guard break
		stamina_changed.emit(stamina, max_stamina)
	elif current_state in [State.IDLE, State.MOVING]:
		if stamina < max_stamina:
			stamina = min(max_stamina, stamina + MatchRules.STAMINA_REGEN_RATE * delta)
			stamina_changed.emit(stamina, max_stamina)

func _update_state_machine(delta: float) -> void:
	state_timer += delta
	
	match current_state:
		State.IDLE, State.MOVING:
			_handle_locomotion(delta)
			_check_standing_actions()
			
		State.STRIKING:
			velocity = Vector3.ZERO
			_handle_strike_active_window()
			if state_timer >= attack_total_time:
				_set_state(State.IDLE)
				
		State.BLOCKING:
			velocity = Vector3.ZERO
			if not input_block:
				_set_state(State.IDLE)
				
		State.REVERSAL_STANCE:
			velocity = Vector3.ZERO
			if state_timer >= 0.35: # Reversal window ends
				_set_state(State.IDLE)
				
		State.GRAPPLE_STARTUP:
			velocity = Vector3.ZERO
			_process_grapple_startup(delta)
				
		State.GRAPPLING_ATTACKER:
			velocity = Vector3.ZERO
			_process_synchronized_attacker()
			
		State.GRAPPLING_DEFENDER:
			velocity = Vector3.ZERO
			# Movement owned authoritatively by attacker
			
		State.KNOCKED_DOWN:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.15
			if state_timer >= knockdown_duration:
				_set_state(State.GETTING_UP)
				
		State.GETTING_UP:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				var t: float = clamp(state_timer / 0.6, 0.0, 1.0)
				visual_root.rotation.x = lerp(deg_to_rad(-90.0), 0.0, t)
				visual_root.position.y = lerp(0.15, 0.0, t)
			if state_timer >= 0.6:
				if visual_root:
					visual_root.rotation = Vector3.ZERO
					visual_root.position = Vector3.ZERO
				_set_state(State.IDLE)
				
		State.PINNING:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.position.y = -0.3
				
		State.PINNED:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.1
			_process_pin_escape(delta)
			
		State.SUBMISSION_ATTACKER:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.position.y = -0.25
			_process_submission_attacker(delta)
			
		State.SUBMISSION_DEFENDER:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.1
			_process_submission_defender(delta)
			
		State.VICTORY:
			velocity = Vector3.ZERO
			if visual_root:
				visual_root.rotation = Vector3.ZERO
				visual_root.position = Vector3.ZERO
				
		State.DEFEATED:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.1

func _handle_locomotion(delta: float) -> void:
	if input_dir.length_squared() > 0.01:
		var speed: float = 3.0 + (stat_mobility * 0.4)
		var move_v3: Vector3 = Vector3(input_dir.x, 0.0, input_dir.y) * speed
		velocity = move_v3
		if is_inside_tree():
			move_and_slide()
		
		# Rotate towards movement direction using standard Godot -Z forward convention
		var target_angle: float = atan2(-input_dir.x, -input_dir.y)
		rotation.y = lerp_angle(rotation.y, target_angle, 10.0 * delta)
		
		if current_state != State.MOVING:
			_set_state(State.MOVING)
	else:
		velocity = Vector3.ZERO
		if is_inside_tree():
			move_and_slide()
		if current_state != State.IDLE:
			_set_state(State.IDLE)
		
		# Face opponent when standing still using standard Godot -Z forward convention
		if is_instance_valid(opponent):
			var my_pos: Vector3 = global_position if is_inside_tree() else position
			var opp_pos: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
			var look_dir: Vector3 = Vector3(opp_pos.x - my_pos.x, 0.0, opp_pos.z - my_pos.z)
			if look_dir.length_squared() > 0.001:
				var look_norm: Vector3 = look_dir.normalized()
				var target_rot: float = atan2(-look_norm.x, -look_norm.z)
				rotation.y = lerp_angle(rotation.y, target_rot, 6.0 * delta)

func _check_standing_actions() -> void:
	if input_reversal and stamina >= MatchRules.REVERSAL_STAMINA_COST:
		stamina -= MatchRules.REVERSAL_STAMINA_COST
		stamina_changed.emit(stamina, max_stamina)
		_set_state(State.REVERSAL_STANCE)
		return
		
	if input_block and stamina > 10.0:
		_set_state(State.BLOCKING)
		return
		
	if input_strike and stamina >= MatchRules.STRIKE_STAMINA_COST:
		stamina -= MatchRules.STRIKE_STAMINA_COST
		stamina_changed.emit(stamina, max_stamina)
		_start_strike()
		return
		
	if input_finisher and is_instance_valid(opponent):
		if opponent.current_state == State.KNOCKED_DOWN and hype >= MatchRules.FINISHER_HYPE_COST:
			_attempt_submission(true)
			return
		elif opponent.current_state in [State.IDLE, State.MOVING] and hype >= MatchRules.FINISHER_HYPE_COST:
			_attempt_grapple(true)
			return

	if input_grapple:
		if is_instance_valid(opponent) and opponent.current_state == State.KNOCKED_DOWN:
			_attempt_submission(false)
			return
		elif stamina >= MatchRules.GRAPPLE_STAMINA_COST:
			stamina -= MatchRules.GRAPPLE_STAMINA_COST
			stamina_changed.emit(stamina, max_stamina)
			_attempt_grapple(false)
			return
		
	if input_pin:
		_attempt_pin()
		return

func _start_strike() -> void:
	current_attack_id += 1
	attack_has_damaged = false
	strike_resolved_hits.clear()
	strike_move = StrikeMoves.definition(character_id)
	active_frame_start = strike_move.hits[0].start
	active_frame_end = strike_move.hits[-1].end
	attack_total_time = strike_move.duration
	_set_state(State.STRIKING)
	if right_arm and not is_rigged():
		var tween: Tween = create_tween()
		tween.tween_property(right_arm, "position:z", -0.8, 0.15)
		tween.tween_property(right_arm, "position:z", 0.0, 0.25)

func _handle_strike_active_window() -> void:
	if current_state != State.STRIKING or not is_instance_valid(opponent):
		return
	if strike_move.is_empty():
		strike_move = StrikeMoves.definition(character_id)
	# Preserve the existing forward/range envelope. Precision limb hurtboxes are
	# a separate change; a cosmetic skeleton or clearance offset cannot award hits.
	if opponent.current_state not in [State.IDLE, State.MOVING, State.STRIKING,
			State.BLOCKING, State.REVERSAL_STANCE, State.GRAPPLE_STARTUP]:
		return
	var my_p: Vector3 = global_position if is_inside_tree() else position
	var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
	var to_opp := Vector3(opp_p.x - my_p.x, 0.0, opp_p.z - my_p.z)
	if to_opp.length() > reach_distance or absf(opp_p.y - my_p.y) > 0.65:
		return
	var forward: Vector3 = -global_transform.basis.z if is_inside_tree() else -transform.basis.z
	forward.y = 0.0
	if not to_opp.is_zero_approx() and forward.normalized().dot(to_opp.normalized()) < MatchRules.STRIKE_CONE_MIN_DOT:
		return
	for hit in strike_move.hits:
		if strike_resolved_hits.has(hit.id) or state_timer < hit.start or state_timer > hit.end:
			continue
		# An authored hit may resolve once; whiffed earlier windows never catch up.
		strike_resolved_hits[hit.id] = true
		attack_has_damaged = true
		if opponent.current_state == State.REVERSAL_STANCE:
			_apply_countered_by(opponent)
			return
		var blocked: bool = opponent.current_state == State.BLOCKING
		var share: float = hit.share
		var damage := (30.0 + stat_power * 6.0) * share * (0.25 if blocked else 1.0)
		opponent.receive_damage(damage, self, blocked)
		if not blocked:
			gain_hype(MatchRules.HYPE_GAIN_ON_HIT * share)
		hit_landed.emit(self, opponent, damage, blocked)
		if AudioManager.instance:
			AudioManager.instance.play_strike(blocked)

var is_finisher_attack: bool = false
var submission_tick_timer: float = 0.0
var grapple_target: Fighter = null

func _attempt_grapple(is_finisher: bool = false) -> void:
	if not is_instance_valid(opponent):
		grapple_target = null
		_set_state(State.GRAPPLE_STARTUP)
		return
		
	if is_finisher:
		is_finisher_attack = true
		hype = max(0.0, hype - MatchRules.FINISHER_HYPE_COST)
		hype_changed.emit(hype, MatchRules.MAX_HYPE)
		if AudioManager.instance:
			AudioManager.instance.play_finisher_stinger()
	else:
		is_finisher_attack = false
	
	var my_p: Vector3 = global_position if is_inside_tree() else position
	var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
	
	# Turn to face opponent when initiating grapple
	var to_opp: Vector3 = Vector3(opp_p.x - my_p.x, 0.0, opp_p.z - my_p.z)
	if not to_opp.is_zero_approx():
		rotation.y = atan2(-to_opp.x, -to_opp.z)
		
	var dist: float = to_opp.length()
	if dist <= (reach_distance + 0.35) and opponent.current_state in [State.IDLE, State.MOVING, State.BLOCKING, State.REVERSAL_STANCE, State.GRAPPLE_STARTUP]:
		grapple_target = opponent
	else:
		grapple_target = null
	
	_set_state(State.GRAPPLE_STARTUP)
	
	# Procedural reaching visual feedback
	if left_arm and right_arm and not is_rigged():
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(left_arm, "position:z", -0.5, 0.12)
		tween.tween_property(right_arm, "position:z", -0.5, 0.12)

func _process_grapple_startup(_delta: float) -> void:
	if state_timer >= MatchRules.GRAPPLE_STARTUP_DURATION:
		if is_instance_valid(grapple_target):
			var my_p: Vector3 = global_position if is_inside_tree() else position
			var opp_p: Vector3 = grapple_target.global_position if grapple_target.is_inside_tree() else grapple_target.position
			var dist: float = my_p.distance_to(opp_p)
			
			if dist <= (reach_distance + 0.35):
				var target: Fighter = grapple_target
				grapple_target = null
				
				if left_arm and right_arm and not is_rigged():
					left_arm.position.z = 0.0
					right_arm.position.z = 0.0
				
				if target.current_state == State.REVERSAL_STANCE:
					_apply_countered_by(target)
					return
				elif target.current_state in [State.IDLE, State.MOVING, State.BLOCKING, State.GRAPPLE_STARTUP]:
					_start_synchronized_throw(target)
					return
		
		grapple_target = null
		if state_timer >= MatchRules.GRAPPLE_WHIFF_DURATION:
			if left_arm and right_arm and not is_rigged():
				left_arm.position.z = 0.0
				right_arm.position.z = 0.0
			_set_state(State.IDLE)

func _start_synchronized_throw(target: Fighter) -> void:
	synchronized_partner = target
	throw_has_impacted = false
	state_timer = 0.0
	throw_duration = 1.1
	throw_impact_time = 0.6
	
	var is_leverage: bool = (stat_power < target.stat_power or reach_distance < target.reach_distance)
	var slam_dist: float = 0.9 if is_leverage else 1.1
	_validate_and_adjust_throw_boundaries(target, slam_dist)
	_set_state(State.GRAPPLING_ATTACKER)
	target.on_locked_by_throw(self)
	
	var p1: Vector3 = global_position if is_inside_tree() else position
	var p2: Vector3 = target.global_position if target.is_inside_tree() else target.position
	var forward_dir: Vector3 = Vector3(p2.x - p1.x, 0.0, p2.z - p1.z).normalized()
	if not forward_dir.is_zero_approx():
		rotation.y = atan2(-forward_dir.x, -forward_dir.z)
		target.rotation.y = atan2(forward_dir.x, forward_dir.z)

func _validate_and_adjust_throw_boundaries(target: Fighter, slam_dist: float) -> void:
	var p1: Vector3 = global_position if is_inside_tree() else position
	var p2: Vector3 = target.global_position if target.is_inside_tree() else target.position
	var forward_dir: Vector3 = Vector3(p2.x - p1.x, 0.0, p2.z - p1.z).normalized()
	if forward_dir.is_zero_approx():
		forward_dir = -global_transform.basis.z.normalized() if is_inside_tree() else -transform.basis.z.normalized()
	var slam_pos: Vector3 = p1 + forward_dir * slam_dist
	var safe_bound: float = MatchRules.THROW_SAFE_RING_BOUND
	var shift_x: float = 0.0
	var shift_z: float = 0.0
	if slam_pos.x > safe_bound:
		shift_x = slam_pos.x - safe_bound
	elif slam_pos.x < -safe_bound:
		shift_x = slam_pos.x - (-safe_bound)
	if slam_pos.z > safe_bound:
		shift_z = slam_pos.z - safe_bound
	elif slam_pos.z < -safe_bound:
		shift_z = slam_pos.z - (-safe_bound)
	var post_shift_p2_x: float = p2.x - shift_x
	var post_shift_p2_z: float = p2.z - shift_z
	if post_shift_p2_x > safe_bound:
		shift_x += (post_shift_p2_x - safe_bound)
	elif post_shift_p2_x < -safe_bound:
		shift_x += (post_shift_p2_x - (-safe_bound))
	if post_shift_p2_z > safe_bound:
		shift_z += (post_shift_p2_z - safe_bound)
	elif post_shift_p2_z < -safe_bound:
		shift_z += (post_shift_p2_z - (-safe_bound))
	if abs(shift_x) > 0.001 or abs(shift_z) > 0.001:
		var adjustment: Vector3 = Vector3(shift_x, 0.0, shift_z)
		if is_inside_tree():
			global_position -= adjustment
		else:
			position -= adjustment
		if target.is_inside_tree():
			target.global_position -= adjustment
		else:
			target.position -= adjustment

func on_locked_by_throw(attacker: Fighter) -> void:
	synchronized_partner = attacker
	_set_state(State.GRAPPLING_DEFENDER)

func _process_synchronized_attacker() -> void:
	if not is_instance_valid(synchronized_partner):
		_set_state(State.IDLE)
		return
	var is_leverage: bool = (stat_power < synchronized_partner.stat_power or reach_distance < synchronized_partner.reach_distance)
	var forward: Vector3 = -global_transform.basis.z.normalized() if is_inside_tree() else -transform.basis.z.normalized()
	var my_pos: Vector3 = global_position if is_inside_tree() else position
	if state_timer < throw_impact_time:
		var lift_t: float = state_timer / throw_impact_time
		var peak_height: float = 0.38 if is_leverage else 1.55
		var lift_height: float = sin(lift_t * PI) * peak_height
		var hold_pos: Vector3 = my_pos + forward * (0.65 if is_leverage else 0.75) + Vector3(0.0, lift_height, 0.0)
		hold_pos.x = clamp(hold_pos.x, -MatchRules.THROW_SAFE_RING_BOUND, MatchRules.THROW_SAFE_RING_BOUND)
		hold_pos.z = clamp(hold_pos.z, -MatchRules.THROW_SAFE_RING_BOUND, MatchRules.THROW_SAFE_RING_BOUND)
		if synchronized_partner.is_inside_tree():
			synchronized_partner.global_position = hold_pos
		else:
			synchronized_partner.position = hold_pos
		if synchronized_partner.visual_root and not synchronized_partner.is_rigged():
			var tilt_angle: float = -45.0 if is_leverage else -80.0
			synchronized_partner.visual_root.rotation.x = deg_to_rad(tilt_angle * lift_t)
	else:
		if not throw_has_impacted:
			throw_has_impacted = true
			var throw_damage: float = 0.0
			if is_leverage:
				throw_damage = 50.0 + (stat_grappling * 10.0) + (stat_mobility * 4.0)
			else:
				throw_damage = 65.0 + (stat_power * 10.0) + (stat_grappling * 6.0)
			if is_finisher_attack:
				throw_damage *= 1.6
			synchronized_partner.receive_damage(throw_damage, self, false, is_finisher_attack)
			gain_hype(MatchRules.HYPE_GAIN_ON_HIT * 1.8)
			throw_impact.emit(self, synchronized_partner)
			if AudioManager.instance:
				AudioManager.instance.play_mat_slam(not is_leverage)
				if is_finisher_attack:
					AudioManager.instance.play_crowd_cheer()
			if BroadcastCamera.instance:
				BroadcastCamera.instance.add_trauma(0.35 if is_leverage else 0.55)
			var slam_pos: Vector3 = my_pos + forward * (0.9 if is_leverage else 1.1)
			slam_pos.y = 0.0
			slam_pos.x = clamp(slam_pos.x, -MatchRules.THROW_SAFE_RING_BOUND, MatchRules.THROW_SAFE_RING_BOUND)
			slam_pos.z = clamp(slam_pos.z, -MatchRules.THROW_SAFE_RING_BOUND, MatchRules.THROW_SAFE_RING_BOUND)
			if synchronized_partner.is_inside_tree():
				synchronized_partner.global_position = slam_pos
			else:
				synchronized_partner.position = slam_pos
	if state_timer >= throw_duration:
		var partner: Fighter = synchronized_partner
		synchronized_partner = null
		_set_state(State.IDLE)
		if is_instance_valid(partner):
			if partner.is_inside_tree():
				partner.global_position.y = 0.0
			else:
				partner.position.y = 0.0
			partner.on_throw_released()

func on_throw_released() -> void:
	synchronized_partner = null
	if visual_root and is_rigged():
		visual_root.transform = Transform3D.IDENTITY
	if is_inside_tree():
		global_position.y = 0.0
	else:
		position.y = 0.0
	knockdown_duration = 3.0 + clamp((1.0 - (vitality / max_vitality)) * 2.0, 0.0, 2.5)
	_set_state(State.KNOCKED_DOWN)

func _attempt_submission(is_finisher: bool = false) -> void:
	if not is_instance_valid(opponent):
		return
	if opponent.current_state != State.KNOCKED_DOWN:
		return
	var my_p: Vector3 = global_position if is_inside_tree() else position
	var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
	var dist: float = my_p.distance_to(opp_p)
	if dist > 1.8:
		return
	if is_finisher:
		is_finisher_attack = true
		hype = max(0.0, hype - MatchRules.FINISHER_HYPE_COST)
		hype_changed.emit(hype, MatchRules.MAX_HYPE)
		if AudioManager.instance:
			AudioManager.instance.play_finisher_stinger()
	else:
		is_finisher_attack = false
	synchronized_partner = opponent
	submission_tick_timer = 0.0
	_set_state(State.SUBMISSION_ATTACKER)
	opponent.on_locked_by_submission(self)
	var lock_pos: Vector3 = opp_p + Vector3(0.0, 0.1, 0.25)
	if is_inside_tree():
		global_position = lock_pos
	else:
		position = lock_pos
	submission_initiated.emit(self, opponent)

func on_locked_by_submission(attacker: Fighter) -> void:
	synchronized_partner = attacker
	pin_escape_progress = 0.0
	_set_state(State.SUBMISSION_DEFENDER)

func _process_submission_attacker(delta: float) -> void:
	if not is_instance_valid(synchronized_partner):
		_set_state(State.IDLE)
		return
	submission_tick_timer += delta
	if submission_tick_timer >= 0.5:
		submission_tick_timer = 0.0
		var tick_dmg: float = 12.0 + (stat_grappling * 2.5)
		if is_finisher_attack:
			tick_dmg *= 1.5
		synchronized_partner.receive_damage(tick_dmg, self, false)
		gain_hype(MatchRules.HYPE_GAIN_ON_HIT * 0.3)
		synchronized_partner.stamina = max(0.0, synchronized_partner.stamina - 15.0)
		synchronized_partner.stamina_changed.emit(synchronized_partner.stamina, synchronized_partner.max_stamina)
		# Active matches are resolved exclusively by MatchManager.
		if MatchManager.instance == null or MatchManager.instance.current_state != MatchManager.MatchState.SUBMISSION_ATTEMPT:
			if synchronized_partner.vitality <= 0.0:
				var defender: Fighter = synchronized_partner
				synchronized_partner = null
				_set_state(State.VICTORY)
				defender.on_tap_out()

func _process_submission_defender(delta: float) -> void:
	var escape_gain: float = 0.0
	if input_pin or input_strike or input_grapple:
		escape_gain += 15.0
	elif input_hold_pin or input_block:
		escape_gain += MatchRules.PIN_ESCAPE_BASE_RATE * delta
	var stamina_factor: float = 0.4 + 0.6 * (stamina / max_stamina)
	pin_escape_progress += escape_gain * stamina_factor
	if MatchManager.instance == null or MatchManager.instance.current_state != MatchManager.MatchState.SUBMISSION_ATTEMPT:
		if pin_escape_progress >= 100.0:
			_execute_submission_escape()

func _execute_submission_escape() -> void:
	if current_state in [State.DEFEATED, State.VICTORY]:
		return
	submission_escaped.emit(self)
	if current_state in [State.DEFEATED, State.VICTORY, State.GETTING_UP, State.IDLE]:
		return
	if visual_root:
		visual_root.rotation = Vector3.ZERO
		visual_root.position = Vector3.ZERO
	_set_state(State.GETTING_UP)
	var partner: Fighter = synchronized_partner
	synchronized_partner = null
	if is_instance_valid(partner) and partner.current_state == State.SUBMISSION_ATTACKER:
		partner.on_submission_broken_by_escape()
	elif is_instance_valid(opponent) and opponent.current_state == State.SUBMISSION_ATTACKER:
		opponent.on_submission_broken_by_escape()

func on_submission_broken_by_escape() -> void:
	if current_state in [State.DEFEATED, State.VICTORY]:
		return
	if visual_root:
		visual_root.position = Vector3.ZERO
	var push_back: Vector3 = global_transform.basis.z.normalized() if is_inside_tree() else transform.basis.z.normalized()
	if is_inside_tree():
		global_position += push_back * 1.2
	else:
		position += push_back * 1.2
	_set_state(State.IDLE)
	synchronized_partner = null
	if AudioManager.instance:
		AudioManager.instance.play_crowd_gasp()

func on_tap_out() -> void:
	if current_state in [State.DEFEATED, State.VICTORY]:
		return
	tap_out_submitted.emit(self)
	if current_state in [State.GETTING_UP, State.IDLE, State.DEFEATED, State.VICTORY]:
		return
	if visual_root:
		visual_root.rotation.x = deg_to_rad(-90.0)
		visual_root.position.y = 0.1
	_set_state(State.DEFEATED)
	synchronized_partner = null
	if AudioManager.instance:
		AudioManager.instance.play_crowd_cheer()

func break_submission_rope_break() -> void:
	if current_state in [State.SUBMISSION_ATTACKER, State.SUBMISSION_DEFENDER]:
		if visual_root:
			visual_root.rotation = Vector3.ZERO
			visual_root.position = Vector3.ZERO
		_set_state(State.IDLE)
		synchronized_partner = null

func _apply_countered_by(counterer: Fighter) -> void:
	counterer.gain_hype(MatchRules.HYPE_GAIN_ON_COUNTER)
	receive_damage(35.0, counterer, false)
	_set_state(State.KNOCKED_DOWN)

func _attempt_pin() -> void:
	if not is_instance_valid(opponent):
		return
	if opponent.current_state == State.KNOCKED_DOWN:
		var my_p: Vector3 = global_position if is_inside_tree() else position
		var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
		var dist: float = my_p.distance_to(opp_p)
		if dist <= 1.8:
			_start_pin(opponent)

func _start_pin(target: Fighter) -> void:
	_set_state(State.PINNING)
	target.on_pinned(self)
	var target_pos: Vector3 = target.global_position if target.is_inside_tree() else target.position
	if is_inside_tree():
		global_position = target_pos + Vector3(0.0, 0.2, 0.0)
	else:
		position = target_pos + Vector3(0.0, 0.2, 0.0)
	pin_initiated.emit(self, target)

func on_pinned(attacker: Fighter) -> void:
	pin_escape_progress = 0.0
	_set_state(State.PINNED)

func _process_pin_escape(delta: float) -> void:
	var has_mash_input: bool = (input_pin or input_strike or input_grapple)
	var has_hold_input: bool = input_hold_pin
	var vit_ratio: float = clamp(vitality / max_vitality, 0.0, 1.0)
	var stam_ratio: float = clamp(stamina / max_stamina, 0.0, 1.0)
	var rev_ratio: float = clamp(stat_reversal / 10.0, 0.1, 1.0)
	var health_factor: float = 0.06 + 0.64 * (vit_ratio * vit_ratio) + 0.30 * stam_ratio
	var rev_mult: float = 0.85 + 0.30 * rev_ratio
	var finisher_mult: float = MatchRules.PIN_ESCAPE_FINISHER_PENALTY if recent_finisher_impact_timer > 0.0 else 1.0
	var heavy_mult: float = MatchRules.PIN_ESCAPE_HEAVY_IMPACT_PENALTY if recent_heavy_impact_timer > 0.0 else 1.0
	var total_mult: float = health_factor * rev_mult * finisher_mult * heavy_mult
	if has_mash_input:
		var mash_gain: float = MatchRules.PIN_ESCAPE_MASH_BASE * total_mult
		pin_escape_progress += mash_gain
		stamina = max(0.0, stamina - MatchRules.PIN_ESCAPE_MASH_STAMINA_COST)
		stamina_changed.emit(stamina, max_stamina)
	elif has_hold_input:
		var hold_gain: float = MatchRules.PIN_ESCAPE_BASE_RATE * total_mult * delta
		pin_escape_progress += hold_gain
		stamina = max(0.0, stamina - MatchRules.PIN_ESCAPE_HOLD_STAMINA_DRAIN * delta)
		stamina_changed.emit(stamina, max_stamina)
	else:
		pin_escape_progress = max(0.0, pin_escape_progress - MatchRules.PIN_ESCAPE_DECAY_RATE * delta)
	if MatchManager.instance == null or MatchManager.instance.current_state != MatchManager.MatchState.PIN_ATTEMPT:
		if pin_escape_progress >= 100.0:
			_execute_kick_out()

func _execute_kick_out() -> void:
	if current_state != State.PINNED:
		return
	kick_out_succeeded.emit(self)
	if current_state in [State.DEFEATED, State.VICTORY, State.GETTING_UP, State.IDLE]:
		return
	if visual_root:
		visual_root.rotation = Vector3.ZERO
		visual_root.position = Vector3.ZERO
	_set_state(State.GETTING_UP)
	if is_instance_valid(opponent) and opponent.current_state == State.PINNING:
		opponent.on_kick_out_received()

func on_kick_out_received() -> void:
	if current_state in [State.DEFEATED, State.VICTORY]:
		return
	if visual_root:
		visual_root.position = Vector3.ZERO
	var push_back: Vector3 = global_transform.basis.z.normalized() if is_inside_tree() else transform.basis.z.normalized()
	if is_inside_tree():
		global_position += push_back * 1.2
	else:
		position += push_back * 1.2
	_set_state(State.IDLE)

func break_pin_rope_break() -> void:
	if current_state in [State.PINNING, State.PINNED]:
		if visual_root:
			visual_root.rotation = Vector3.ZERO
			visual_root.position = Vector3.ZERO
		_set_state(State.IDLE)

func receive_damage(amount: float, from_fighter: Fighter, was_blocked: bool, is_finisher: bool = false) -> void:
	vitality = max(0.0, vitality - amount)
	if presentation and not was_blocked:
		presentation.notify_hit(amount)
	vitality_changed.emit(vitality, max_vitality)
	if is_finisher:
		recent_finisher_impact_timer = MatchRules.FINISHER_DISORIENTATION_DURATION
		recent_heavy_impact_timer = 0.0
	elif amount >= MatchRules.HEAVY_IMPACT_DAMAGE_THRESHOLD and not was_blocked:
		recent_heavy_impact_timer = MatchRules.HEAVY_IMPACT_DISORIENTATION_DURATION
	if current_state == State.GRAPPLE_STARTUP and not was_blocked:
		grapple_target = null
		if left_arm and right_arm:
			left_arm.position.z = 0.0
			right_arm.position.z = 0.0
		_set_state(State.IDLE)
	if not was_blocked and vitality <= 0.0 and current_state not in [State.KNOCKED_DOWN, State.PINNED, State.SUBMISSION_DEFENDER, State.SUBMISSION_ATTACKER]:
		_set_state(State.KNOCKED_DOWN)

func gain_hype(amount: float) -> void:
	var bonus: float = 1.0 + (stat_showmanship * 0.08)
	hype = min(MatchRules.MAX_HYPE, hype + (amount * bonus))
	hype_changed.emit(hype, MatchRules.MAX_HYPE)

func _set_state(new_state: State) -> void:
	if current_state == new_state:
		return
	if current_state in [State.VICTORY, State.DEFEATED] and new_state not in [State.VICTORY, State.DEFEATED]:
		return
	var old_state: State = current_state
	if old_state == State.GRAPPLE_STARTUP:
		grapple_target = null
		if left_arm and right_arm:
			left_arm.position.z = 0.0
			right_arm.position.z = 0.0
	current_state = new_state
	state_timer = 0.0
	_play_state_animation(new_state)
	state_changed.emit(old_state, new_state)

func _play_state_animation(st: State) -> void:
	if presentation:
		presentation.play_state_animation(st)
	elif is_instance_valid(anim_player):
		var anim_name: String = ""
		match st:
			State.IDLE: anim_name = "idle"
			State.MOVING: anim_name = "walk"
			State.STRIKING: anim_name = "strike"
			State.BLOCKING: anim_name = "block"
			State.REVERSAL_STANCE: anim_name = "reversal"
			State.GRAPPLE_STARTUP: anim_name = "grapple"
			State.GRAPPLING_ATTACKER: anim_name = "throw_attacker"
			State.GRAPPLING_DEFENDER: anim_name = "throw_defender"
			State.KNOCKED_DOWN: anim_name = "knockdown"
			State.GETTING_UP: anim_name = "getup"
			State.PINNING: anim_name = "pinning"
			State.PINNED: anim_name = "pinned"
			State.SUBMISSION_ATTACKER: anim_name = "submission_attacker"
			State.SUBMISSION_DEFENDER: anim_name = "submission_defender"
			State.VICTORY: anim_name = "victory"
			State.DEFEATED: anim_name = "defeated"
		if anim_name != "" and anim_player.has_animation(anim_name):
			anim_player.play(anim_name)

func _clamp_within_ring() -> void:
	if current_state == State.GRAPPLING_DEFENDER:
		return
	var bound: float = MatchRules.RING_MAT_RADIUS - 0.35
	if is_inside_tree():
		global_position.x = clamp(global_position.x, -bound, bound)
		global_position.z = clamp(global_position.z, -bound, bound)
		global_position.y = 0.0
	else:
		position.x = clamp(position.x, -bound, bound)
		position.z = clamp(position.z, -bound, bound)
		position.y = 0.0

func set_victory() -> void:
	synchronized_partner = null
	_set_state(State.VICTORY)

func set_defeated() -> void:
	synchronized_partner = null
	_set_state(State.DEFEATED)
