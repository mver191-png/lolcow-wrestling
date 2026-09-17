class_name Referee
extends Node3D
const CONTACT_IK = preload("res://scripts/fighter/contact_ik.gd")
var hand_contacts: Array[Dictionary] = []
var _skeleton: Skeleton3D
## Non-colliding official. Animated signals never govern the match result.
signal count_pulse(count_number: int)
enum RefereeState {IDLE, OBSERVING, RUNNING_TO_PIN, COUNTING_PIN, SIGNAL_ROPE_BREAK, VICTORY}
@export var halo_node: Node3D
@export var mesh_instance: Node3D
@export var count_label_3d: Label3D
var current_state := RefereeState.OBSERVING
var target_fighter_1: Node3D
var target_fighter_2: Node3D
var current_count := 0
var halo_pulse_timer := 0.0
var _ap: AnimationPlayer
var _halo_material: StandardMaterial3D
var _goal := Vector3.ZERO
var _look := Vector3.ZERO
var _clock := 0.0
var _signal_time := 0.0
var _clip := ""
var _count_contact_remaining := 0.0
var _transition_elapsed := .16
var _from_positions: Array[Vector3] = []
var _from_rotations: Array[Quaternion] = []

func _inspect(node: Node) -> void:
	if node is Skeleton3D:
		_skeleton = node
	if node is AnimationPlayer:
		_ap = node
	if node is MeshInstance3D and node.mesh:
		for index in range(node.mesh.get_surface_count()):
			var material := node.get_active_material(index) as StandardMaterial3D
			if material and material.resource_name == "halo":
				_halo_material = material.duplicate() as StandardMaterial3D
				node.set_surface_override_material(index, _halo_material)
	for child in node.get_children():
		_inspect(child)

func _ready() -> void:
	_inspect(self)
	process_physics_priority = 25
	if _ap:
		_ap.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	if count_label_3d:
		count_label_3d.visible = false
	_goal = global_position

func setup_targets(f1: Node3D, f2: Node3D) -> void:
	target_fighter_1 = f1
	target_fighter_2 = f2

func _physics_process(delta: float) -> void:
	hand_contacts.clear()
	var show_count_contact := _count_contact_remaining > 0.0
	_count_contact_remaining = maxf(0.0, _count_contact_remaining-delta)
	_clock += delta
	halo_pulse_timer = maxf(0.0, halo_pulse_timer-delta)
	_signal_time = maxf(0.0, _signal_time-delta)
	if _halo_material:
		_halo_material.emission_energy_multiplier = 1.0+halo_pulse_timer*2.0
	if current_state == RefereeState.SIGNAL_ROPE_BREAK and _signal_time <= 0.0:
		current_state = RefereeState.OBSERVING
		if count_label_3d: count_label_3d.hide()
	if current_state == RefereeState.OBSERVING and is_instance_valid(target_fighter_1) and is_instance_valid(target_fighter_2):
		_look = (target_fighter_1.global_position+target_fighter_2.global_position)*.5
		var side := (target_fighter_2.global_position-target_fighter_1.global_position).cross(Vector3.UP).normalized()
		if side.is_zero_approx(): side=Vector3.FORWARD
		_goal = _look+side*2.1
	_goal.x = clampf(_goal.x,-3.0,3.0)
	_goal.z = clampf(_goal.z,-3.0,3.0)
	_goal.y = 0
	var moving := global_position.distance_to(_goal)>.08
	global_position = global_position.move_toward(_goal,4.4*delta)
	var direction := Vector3(_look.x-global_position.x,0,_look.z-global_position.z)
	if direction.length_squared()>.01:
		rotation.y = lerp_angle(rotation.y,atan2(-direction.x,-direction.z),1.0-exp(-10.0*delta))
	var clip: String = "run" if moving else "idle"
	var sample := _clock
	if current_state==RefereeState.COUNTING_PIN and not moving:
		clip = "ref_count"
		if is_instance_valid(MatchManager.instance):
			if MatchManager.instance.current_state == MatchManager.MatchState.SUBMISSION_ATTEMPT:
				clip = "submission_attacker"
			else:
				sample = fposmod(MatchManager.instance.pin_timer,MatchRules.PIN_COUNT_INTERVAL)
	elif current_state==RefereeState.SIGNAL_ROPE_BREAK:
		clip = "ref_wave"
		sample = .7-_signal_time
	elif current_state==RefereeState.VICTORY:
		clip = "victory"
		sample = _clock
	# Keep the official final slap visible even when MatchManager enters MATCH_OVER
	# on this tick. This cosmetic hold cannot postpone or change the outcome.
	if show_count_contact and not moving and current_state in [RefereeState.COUNTING_PIN, RefereeState.VICTORY]:
		clip = "ref_count"
		sample = 0.0
	if _ap and _ap.has_animation(clip):
		if clip!=_clip:
			_capture_transition()
			_clip = clip
			_ap.play(clip,0.0)
			_ap.advance(0.0)
		var length := maxf(_ap.get_animation(clip).length,.001)
		_ap.seek(fposmod(sample,length) if clip in ["run","idle","ref_count"] else clampf(sample,0,length),true)
		if clip == "ref_count" and _skeleton != null:
			_count_contacts(fposmod(sample,length)/length)
		_blend_transition(delta, show_count_contact and not moving)

func on_pin_started(pin_position: Vector3) -> void:
	current_state = RefereeState.COUNTING_PIN
	current_count = 0
	_count_contact_remaining = 0.0
	_look = pin_position
	_goal = pin_position+Vector3(1.15,0,.35)
	# Count from the free side of the lateral cover, rather than over the heads.
	if is_instance_valid(MatchManager.instance) and is_instance_valid(MatchManager.instance.current_pinned):
		var pinned: Fighter = MatchManager.instance.current_pinned
		var headward := pinned.global_basis.z.normalized()
		var free_side := -pinned.global_basis.x.normalized()
		_look = pin_position + headward*.30
		_goal = pin_position + free_side*1.40 + headward*.35
	if count_label_3d:
		count_label_3d.text = ""
		count_label_3d.show()

func on_pin_count(count_num: int) -> void:
	current_count = count_num
	_count_contact_remaining = .08
	halo_pulse_timer = .20
	if count_label_3d:
		count_label_3d.text = str(count_num)
		count_label_3d.modulate = Color("dac495")
	count_pulse.emit(count_num)

func on_rope_break() -> void:
	_count_contact_remaining = 0.0
	current_state = RefereeState.SIGNAL_ROPE_BREAK
	_signal_time = .70
	if count_label_3d:
		count_label_3d.text = "ROPE BREAK"
		count_label_3d.show()

func on_pin_broken() -> void:
	_count_contact_remaining = 0.0
	if current_state==RefereeState.COUNTING_PIN:
		current_state = RefereeState.OBSERVING
		if count_label_3d: count_label_3d.hide()

func on_match_won(winner_position: Vector3) -> void:
	current_state = RefereeState.VICTORY
	_clock = 0.0
	_look = winner_position
	if count_label_3d:
		count_label_3d.text = "WINNER"
		count_label_3d.show()

func _count_contacts(phase: float) -> void:
	# The official clock determines the cosmetic hand phase, never the inverse.
	var hips := _skeleton.find_bone("Hips")
	var scale := _skeleton.get_bone_global_rest(hips).origin.y / .89
	_skeleton.set_bone_pose_position(hips,Vector3(0,.49*scale,0))
	for entry in [["Hips",Vector3(-1.2,0,0)],["Spine",Vector3(-.35,0,0)],
		["Chest",Vector3(-.1,0,0)],["Thigh.L",Vector3(1.4,0,0)],
		["Thigh.R",Vector3(1.4,0,0)],["Shin.L",Vector3(-PI*.5-.2,0,0)],
		["Shin.R",Vector3(-PI*.5-.2,0,0)]]:
		_skeleton.set_bone_pose_rotation(_skeleton.find_bone(entry[0]),Quaternion.from_euler(entry[1]))
	_skeleton.force_update_all_bone_transforms()
	for side in ["L","R"]:
		var sign := 1.0 if side=="L" else -1.0
		var lift := .28*pow(sin(PI*phase),2.0) if side=="R" else 0.0
		var surface := global_transform * (Vector3(sign*.20,.035+lift,-.46)*scale)
		var basis := CONTACT_IK.hand_basis(-global_basis.z,Vector3.DOWN)
		var hand := _skeleton.find_bone("Hand."+side)
		var wrist := surface - basis*(Vector3(0,-.045,-.012)*scale)
		var pole := surface + global_basis.x*sign*.40 + Vector3.UP*.2
		var result := CONTACT_IK.solve(_skeleton,_skeleton.find_bone("UpperArm."+side),
			_skeleton.find_bone("Forearm."+side),hand,wrist,pole)
		if result.get("valid",false):
			CONTACT_IK._world_rotation(_skeleton,hand,basis.get_rotation_quaternion())
			var actual := CONTACT_IK.point(_skeleton,hand,Vector3(0,-.045,-.012)*scale)
			result.merge({"side":side,"phase":phase,"target":surface,"actual":actual,"error":actual.distance_to(surface)},true)
			hand_contacts.append(result)


func _capture_transition() -> void:
	_from_positions.clear()
	_from_rotations.clear()
	_transition_elapsed = 0.0
	if _skeleton == null: return
	for i in range(_skeleton.get_bone_count()):
		_from_positions.append(_skeleton.get_bone_pose_position(i))
		_from_rotations.append(_skeleton.get_bone_pose_rotation(i))

func _blend_transition(delta: float, official_contact: bool) -> void:
	if _skeleton == null: return
	# Counts are sampled exactly, while ordinary drop/stand/wave transitions blend.
	_transition_elapsed = .16 if official_contact else minf(.16, _transition_elapsed+delta)
	var alpha := smoothstep(0.0,.16,_transition_elapsed)
	if alpha >= 1.0 or _from_positions.size() != _skeleton.get_bone_count(): return
	for i in range(_skeleton.get_bone_count()):
		_skeleton.set_bone_pose_position(i,_from_positions[i].lerp(_skeleton.get_bone_pose_position(i),alpha))
		_skeleton.set_bone_pose_rotation(i,_from_rotations[i].slerp(_skeleton.get_bone_pose_rotation(i),alpha))
	# Diagnostics describe the final visible pose, not the unblended solver result.
	var scale := _skeleton.get_bone_global_rest(_skeleton.find_bone("Hips")).origin.y/.89
	for contact in hand_contacts:
		contact.actual = CONTACT_IK.point(_skeleton,_skeleton.find_bone("Hand."+contact.side),Vector3(0,-.045,-.012)*scale)
		contact.error = contact.actual.distance_to(contact.target)
