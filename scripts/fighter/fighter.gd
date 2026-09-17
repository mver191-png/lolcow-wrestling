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
@export var body_mesh: MeshInstance3D
@export var left_arm: Node3D
@export var right_arm: Node3D
var anim_player: AnimationPlayer = null

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
var state_timer: float = 0.0
var active_frame_start: float = 0.0
var active_frame_end: float = 0.0
var attack_total_time: float = 0.0

# Synchronized grapple parameters
var throw_duration: float = 1.0
var throw_impact_time: float = 0.55
var throw_has_impacted: bool = false
var synchronized_partner: Fighter = null
var initial_defender_local_pos: Vector3 = Vector3.ZERO

# Pin escape tracking
var pin_escape_progress: float = 0.0
var knockdown_duration: float = 2.5

# Input buffer
var input_dir: Vector2 = Vector2.ZERO
var input_strike: bool = false
var input_grapple: bool = false
var input_block: bool = false
var input_reversal: bool = false
var input_pin: bool = false
var input_finisher: bool = false
var input_hold_pin: bool = false

func _ready() -> void:
	load_character_data()

func load_character_data() -> void:
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
		for child in visual_root.get_children():
			child.queue_free()
		anim_player = null
		var model_path: String = "res://assets/models/" + character_id + ".glb"
		if ResourceLoader.exists(model_path):
			var model_res = load(model_path)
			if model_res is PackedScene:
				var inst: Node = model_res.instantiate()
				visual_root.add_child(inst)
				anim_player = inst.find_child("AnimationPlayer", true, false) as AnimationPlayer
				_play_state_animation(current_state)
	
	character_loaded.emit(self)

func _physics_process(delta: float) -> void:
	if not is_cpu:
		_gather_player_inputs()
	
	_tick_stamina(delta)
	_update_state_machine(delta)
	_clamp_within_ring()
	_clear_consumed_pulse_inputs()

func _gather_player_inputs() -> void:
	var prefix: String = "p" + str(player_index) + "_"
	
	input_dir = Vector2.ZERO
	if Input.is_action_pressed(prefix + "up"):
		input_dir.y -= 1.0
	if Input.is_action_pressed(prefix + "down"):
		input_dir.y += 1.0
	if Input.is_action_pressed(prefix + "left"):
		input_dir.x -= 1.0
	if Input.is_action_pressed(prefix + "right"):
		input_dir.x += 1.0
	input_dir = input_dir.normalized()
	
	input_strike = Input.is_action_just_pressed(prefix + "strike")
	input_grapple = Input.is_action_just_pressed(prefix + "grapple")
	input_block = Input.is_action_pressed(prefix + "block")
	input_reversal = Input.is_action_just_pressed(prefix + "reversal")
	input_pin = Input.is_action_just_pressed(prefix + "pin")
	input_finisher = Input.is_action_just_pressed(prefix + "finisher")
	input_hold_pin = Input.is_action_pressed(prefix + "pin")

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
			if state_timer >= 0.25:
				_set_state(State.IDLE) # Missed grapple recovery
				
		State.GRAPPLING_ATTACKER:
			velocity = Vector3.ZERO
			_process_synchronized_attacker()
			
		State.GRAPPLING_DEFENDER:
			velocity = Vector3.ZERO
			# Movement owned authoritatively by attacker
			
		State.KNOCKED_DOWN:
			velocity = Vector3.ZERO
			if visual_root:
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.15
			if state_timer >= knockdown_duration:
				_set_state(State.GETTING_UP)
				
		State.GETTING_UP:
			velocity = Vector3.ZERO
			if visual_root:
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
			if visual_root:
				visual_root.position.y = -0.3
				
		State.PINNED:
			velocity = Vector3.ZERO
			if visual_root:
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.1
			_process_pin_escape(delta)
			
		State.SUBMISSION_ATTACKER:
			velocity = Vector3.ZERO
			if visual_root:
				visual_root.position.y = -0.25
			_process_submission_attacker(delta)
			
		State.SUBMISSION_DEFENDER:
			velocity = Vector3.ZERO
			if visual_root:
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
			if visual_root:
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
	active_frame_start = 0.12
	active_frame_end = 0.32
	attack_total_time = 0.45
	_set_state(State.STRIKING)
	
	# Arm punch animation
	if right_arm:
		var tween: Tween = create_tween()
		tween.tween_property(right_arm, "position:z", -0.8, 0.15)
		tween.tween_property(right_arm, "position:z", 0.0, 0.25)

func _handle_strike_active_window() -> void:
	if state_timer >= active_frame_start and state_timer <= active_frame_end and not attack_has_damaged:
		if is_instance_valid(opponent):
			var my_p: Vector3 = global_position if is_inside_tree() else position
			var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
			var dist: float = my_p.distance_to(opp_p)
			if dist <= reach_distance:
				# Check defender state
				if opponent.current_state == State.REVERSAL_STANCE:
					# Countered!
					attack_has_damaged = true
					_apply_countered_by(opponent)
					return
				
				var is_blocked: bool = (opponent.current_state == State.BLOCKING)
				var base_dmg: float = 30.0 + (stat_power * 6.0)
				var final_dmg: float = base_dmg * (0.25 if is_blocked else 1.0)
				
				attack_has_damaged = true
				opponent.receive_damage(final_dmg, self, is_blocked)
				
				if not is_blocked:
					gain_hype(MatchRules.HYPE_GAIN_ON_HIT)
					hit_landed.emit(self, opponent, final_dmg, false)
					if AudioManager.instance:
						AudioManager.instance.play_strike(false)
				else:
					hit_landed.emit(self, opponent, final_dmg, true)
					if AudioManager.instance:
						AudioManager.instance.play_strike(true)

var is_finisher_attack: bool = false
var submission_tick_timer: float = 0.0

func _attempt_grapple(is_finisher: bool = false) -> void:
	_set_state(State.GRAPPLE_STARTUP)
	if not is_instance_valid(opponent):
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
	var dist: float = my_p.distance_to(opp_p)
	if dist <= (reach_distance + 0.35):
		# Validate defender state
		if opponent.current_state in [State.IDLE, State.MOVING, State.BLOCKING]:
			# Successful grapple! (Grapple breaks guard)
			_start_synchronized_throw(opponent)
		elif opponent.current_state == State.REVERSAL_STANCE:
			# Defender counters the grapple!
			_apply_countered_by(opponent)

func _start_synchronized_throw(target: Fighter) -> void:
	synchronized_partner = target
	throw_has_impacted = false
	state_timer = 0.0
	throw_duration = 1.1
	throw_impact_time = 0.6
	
	_set_state(State.GRAPPLING_ATTACKER)
	target.on_locked_by_throw(self)
	
	# Face each other using standard Godot -Z forward convention
	var p1: Vector3 = global_position if is_inside_tree() else position
	var p2: Vector3 = target.global_position if target.is_inside_tree() else target.position
	var forward_dir: Vector3 = Vector3(p2.x - p1.x, 0.0, p2.z - p1.z).normalized()
	if not forward_dir.is_zero_approx():
		rotation.y = atan2(-forward_dir.x, -forward_dir.z)
		target.rotation.y = atan2(forward_dir.x, forward_dir.z)

func on_locked_by_throw(attacker: Fighter) -> void:
	synchronized_partner = attacker
	_set_state(State.GRAPPLING_DEFENDER)

func _process_synchronized_attacker() -> void:
	if not is_instance_valid(synchronized_partner):
		_set_state(State.IDLE)
		return
	
	# Check if attacker should use leverage/trip instead of overhead lift
	var is_leverage: bool = (stat_power < synchronized_partner.stat_power or reach_distance < synchronized_partner.reach_distance)
	
	var forward: Vector3 = -global_transform.basis.z.normalized() if is_inside_tree() else -transform.basis.z.normalized()
	var my_pos: Vector3 = global_position if is_inside_tree() else position
	
	if state_timer < throw_impact_time:
		# Lift phase (leverage throws stay close to canvas)
		var lift_t: float = state_timer / throw_impact_time
		var peak_height: float = 0.38 if is_leverage else 1.55
		var lift_height: float = sin(lift_t * PI) * peak_height
		var hold_pos: Vector3 = my_pos + forward * (0.65 if is_leverage else 0.75) + Vector3(0.0, lift_height, 0.0)
		if synchronized_partner.is_inside_tree():
			synchronized_partner.global_position = hold_pos
		else:
			synchronized_partner.position = hold_pos
		
		# Tilt defender
		if synchronized_partner.visual_root:
			var tilt_angle: float = -45.0 if is_leverage else -80.0
			synchronized_partner.visual_root.rotation.x = deg_to_rad(tilt_angle * lift_t)
	else:
		# Post-impact phase
		if not throw_has_impacted:
			throw_has_impacted = true
			# Apply damage exactly once
			var throw_damage: float = 0.0
			if is_leverage:
				throw_damage = 50.0 + (stat_grappling * 10.0) + (stat_mobility * 4.0)
			else:
				throw_damage = 65.0 + (stat_power * 10.0) + (stat_grappling * 6.0)
			if is_finisher_attack:
				throw_damage *= 1.6
				
			synchronized_partner.receive_damage(throw_damage, self, false)
			gain_hype(MatchRules.HYPE_GAIN_ON_HIT * 1.8)
			throw_impact.emit(self, synchronized_partner)
			
			if AudioManager.instance:
				AudioManager.instance.play_mat_slam(not is_leverage)
				if is_finisher_attack:
					AudioManager.instance.play_crowd_cheer()
			if BroadcastCamera.instance:
				BroadcastCamera.instance.add_trauma(0.35 if is_leverage else 0.55)
			
			# Slam position on canvas
			var slam_pos: Vector3 = my_pos + forward * (0.9 if is_leverage else 1.1)
			slam_pos.y = 0.0
			if synchronized_partner.is_inside_tree():
				synchronized_partner.global_position = slam_pos
			else:
				synchronized_partner.position = slam_pos
		
	if state_timer >= throw_duration:
		# Release mutual lock
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
	if is_inside_tree():
		global_position.y = 0.0
	else:
		position.y = 0.0
	knockdown_duration = 3.0 + clamp((1.0 - (vitality / max_vitality)) * 2.0, 0.0, 2.5)
	_set_state(State.KNOCKED_DOWN)

# ==============================================================================
# Submissions System
# ==============================================================================

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
	
	# Snap attacker near defender
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
		
		# Defender stamina drain
		synchronized_partner.stamina = max(0.0, synchronized_partner.stamina - 15.0)
		synchronized_partner.stamina_changed.emit(synchronized_partner.stamina, synchronized_partner.max_stamina)
		
		if synchronized_partner.vitality <= 0.0:
			var defender: Fighter = synchronized_partner
			synchronized_partner = null
			_set_state(State.VICTORY)
			defender.on_tap_out()

func _process_submission_defender(delta: float) -> void:
	var escape_gain: float = 0.0
	
	# Any mash press (pin, strike, grapple) yields immediate burst escape gain
	if input_pin or input_strike or input_grapple:
		escape_gain += 15.0
	elif input_hold_pin or input_block:
		escape_gain += MatchRules.PIN_ESCAPE_BASE_RATE * delta
		
	var stamina_factor: float = 0.4 + 0.6 * (stamina / max_stamina)
	pin_escape_progress += escape_gain * stamina_factor
	
	if pin_escape_progress >= 100.0:
		_execute_submission_escape()

func _execute_submission_escape() -> void:
	submission_escaped.emit(self)
	if visual_root:
		visual_root.rotation = Vector3.ZERO
		visual_root.position = Vector3.ZERO
	_set_state(State.GETTING_UP)
	
	if is_instance_valid(opponent) and opponent.current_state == State.SUBMISSION_ATTACKER:
		opponent.on_submission_broken_by_escape()

func on_submission_broken_by_escape() -> void:
	if visual_root:
		visual_root.position = Vector3.ZERO
	# Push backward away from opponent
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
	tap_out_submitted.emit(self)
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
	# Counterer gains hype
	counterer.gain_hype(MatchRules.HYPE_GAIN_ON_COUNTER)
	# Attacker stumbles and takes moderate counter damage
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
	# Snap attacker on top of defender
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
	# Accumulate escape progress via button presses or hold using unified fighter command interface
	var escape_gain: float = 0.0
	
	if input_pin or input_strike or input_grapple:
		escape_gain += 16.0
	elif input_hold_pin: # Accessibility hold-to-resist
		escape_gain += MatchRules.PIN_ESCAPE_BASE_RATE * delta
	
	# Scale with remaining stamina & vitality
	var stamina_factor: float = 0.5 + 0.5 * (stamina / max_stamina)
	pin_escape_progress += escape_gain * stamina_factor
	
	if pin_escape_progress >= 100.0:
		_execute_kick_out()

func _execute_kick_out() -> void:
	kick_out_succeeded.emit(self)
	if visual_root:
		visual_root.rotation = Vector3.ZERO
		visual_root.position = Vector3.ZERO
	_set_state(State.GETTING_UP)
	
	# Push pinning opponent away
	if is_instance_valid(opponent) and opponent.current_state == State.PINNING:
		opponent.on_kick_out_received()

func on_kick_out_received() -> void:
	if visual_root:
		visual_root.position = Vector3.ZERO
	# Stumble backward away from opponent
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

func receive_damage(amount: float, from_fighter: Fighter, was_blocked: bool) -> void:
	vitality = max(0.0, vitality - amount)
	vitality_changed.emit(vitality, max_vitality)
	
	# Knockdown on heavy damage or low health
	if not was_blocked and vitality <= 0.0 and current_state != State.KNOCKED_DOWN and current_state != State.PINNED:
		_set_state(State.KNOCKED_DOWN)

func gain_hype(amount: float) -> void:
	var bonus: float = 1.0 + (stat_showmanship * 0.08)
	hype = min(MatchRules.MAX_HYPE, hype + (amount * bonus))
	hype_changed.emit(hype, MatchRules.MAX_HYPE)

func _set_state(new_state: State) -> void:
	if current_state == new_state:
		return
	var old_state: State = current_state
	current_state = new_state
	state_timer = 0.0
	_play_state_animation(new_state)
	state_changed.emit(old_state, new_state)

func _play_state_animation(st: State) -> void:
	if not is_instance_valid(anim_player):
		return
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
	# Single authoritative ownership: attacker solely controls defender's position during throws
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
	_set_state(State.VICTORY)

func set_defeated() -> void:
	_set_state(State.DEFEATED)
