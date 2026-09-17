class_name FighterPresentation
extends Node

## Cosmetic pose ownership. Simulation owns roots; MatchManager owns outcomes.
## Manual sampling uses the simulation clock after fighters and match resolution.
const CONTACT = preload("res://scripts/fighter/paired_contact.gd")
var contact: Node
const LOOPING := ["idle", "walk", "run", "downed", "pinned", "submission_attacker", "submission_defender"]
const CORE := ["idle", "walk", "strike", "knockdown", "getup", "throw_attacker", "throw_defender", "pinning", "pinned", "submission_attacker", "submission_defender", "victory", "defeated"]
var fighter: CharacterBody3D
var visual_root: Node3D
var anim_player: AnimationPlayer
var skeleton: Skeleton3D
var has_skeletal_rig := false
var current_anim := ""
var model: Node3D
var gait_clock := 0.0
var actual_speed := 0.0
var _previous_position := Vector3.ZERO
var _previous_valid := false
var _fall_already_played := false
var _blend_elapsed := 1.0
var _blend_duration := 0.10
var _from_positions: Array[Vector3] = []
var _from_rotations: Array[Quaternion] = []
var _impact_time := 0.0
var _chest := -1
var _body_scale := 1.0

func setup(p_fighter: Fighter, p_visual_root: Node3D) -> void:
	fighter = p_fighter
	visual_root = p_visual_root
	process_physics_priority = 20
	contact = CONTACT.new()
	contact.name = "PairedContact"
	add_child(contact)
	contact.setup(self)

func _find_type(node: Node, wanted: StringName) -> Node:
	if node.is_class(wanted):
		return node
	for child in node.get_children():
		var found := _find_type(child, wanted)
		if found != null:
			return found
	return null

func load_model(character_id: String) -> void:
	if not is_instance_valid(visual_root):
		return
	# Immediate detachment prevents duplicate meshes on same-frame reloads.
	for child in visual_root.get_children():
		visual_root.remove_child(child)
		child.queue_free()
	anim_player = null
	skeleton = null
	model = null
	has_skeletal_rig = false
	current_anim = ""
	_previous_valid = false
	_fall_already_played = false
	gait_clock = 0.0
	actual_speed = 0.0
	_from_positions.clear()
	_from_rotations.clear()
	visual_root.transform = Transform3D.IDENTITY
	var path := "res://assets/models/%s.glb" % character_id
	if not ResourceLoader.exists(path):
		push_warning("Missing character asset: " + path)
		return
	var packed := load(path) as PackedScene
	if packed == null:
		return
	model = packed.instantiate() as Node3D
	visual_root.add_child(model)
	anim_player = _find_type(model, &"AnimationPlayer") as AnimationPlayer
	skeleton = _find_type(model, &"Skeleton3D") as Skeleton3D
	if skeleton == null or anim_player == null:
		return
	has_skeletal_rig = true
	for clip in CORE:
		if not anim_player.has_animation(clip):
			push_warning("Missing required clip %s on %s" % [clip, character_id])
			has_skeletal_rig = false
	if not has_skeletal_rig:
		return
	# Mirror-match players must not share mutable animation-library state.
	for library_name in anim_player.get_animation_library_list():
		var library := anim_player.get_animation_library(library_name).duplicate(true) as AnimationLibrary
		anim_player.remove_animation_library(library_name)
		anim_player.add_animation_library(library_name, library)
	for clip in LOOPING:
		if anim_player.has_animation(clip):
			anim_player.get_animation(clip).loop_mode = Animation.LOOP_LINEAR
	anim_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	_chest = skeleton.find_bone("Chest")
	var hips := skeleton.find_bone("Hips")
	if hips >= 0:
		_body_scale = maxf(skeleton.get_bone_global_rest(hips).origin.y / 0.89, 0.5)
	contact.reset()
	play_state_animation(fighter.current_state)

func _capture_pose() -> void:
	_from_positions.clear()
	_from_rotations.clear()
	if skeleton == null:
		return
	for bone in range(skeleton.get_bone_count()):
		_from_positions.append(skeleton.get_bone_pose_position(bone))
		_from_rotations.append(skeleton.get_bone_pose_rotation(bone))

func _play(clip: String, blend: float = 0.10) -> void:
	if anim_player == null or not anim_player.has_animation(clip) or clip == current_anim:
		return
	_capture_pose()
	_blend_elapsed = 0.0
	_blend_duration = blend
	current_anim = clip
	anim_player.play(clip, 0.0)
	anim_player.advance(0.0)

func play_state_animation(st: Fighter.State) -> void:
	if not has_skeletal_rig:
		return
	var clips := {
		Fighter.State.IDLE: "idle", Fighter.State.MOVING: "walk",
		Fighter.State.STRIKING: "strike", Fighter.State.BLOCKING: "block",
		Fighter.State.REVERSAL_STANCE: "reversal", Fighter.State.GRAPPLE_STARTUP: "grapple",
		Fighter.State.GRAPPLING_ATTACKER: "throw_attacker", Fighter.State.GRAPPLING_DEFENDER: "throw_defender",
		Fighter.State.KNOCKED_DOWN: "knockdown", Fighter.State.GETTING_UP: "getup",
		Fighter.State.PINNING: "pinning", Fighter.State.PINNED: "pinned",
		Fighter.State.SUBMISSION_ATTACKER: "submission_attacker", Fighter.State.SUBMISSION_DEFENDER: "submission_defender",
		Fighter.State.VICTORY: "victory", Fighter.State.DEFEATED: "defeated"
	}
	if st == Fighter.State.KNOCKED_DOWN:
		_fall_already_played = current_anim in ["throw_defender", "throw_leverage_defender", "pinned", "submission_defender"]
		if _fall_already_played and anim_player.has_animation("downed"):
			clips[st] = "downed"
	var blend := 0.08
	if st in [Fighter.State.GRAPPLING_ATTACKER, Fighter.State.GRAPPLING_DEFENDER]:
		blend = 0.035
	_play(clips.get(st, "idle"), blend)

func notify_hit(damage: float) -> void:
	if damage > 0.0:
		_impact_time = 0.16

func update_locomotion_stride() -> void:
	# Compatibility hook. The actual travel sample is collected after simulation.
	if not has_skeletal_rig or fighter == null:
		return
	var reference := (4.2 if current_anim == "run" else 1.5) * _body_scale
	anim_player.speed_scale = clampf(actual_speed / reference, 0.0, 1.65) if fighter.current_state == Fighter.State.MOVING else 1.0

func _physics_process(delta: float) -> void:
	if not has_skeletal_rig or not is_instance_valid(fighter) or not fighter.is_inside_tree():
		return
	contact.begin_pose(delta)
	var position_now := fighter.global_position
	if _previous_valid:
		var displacement := position_now - _previous_position
		displacement.y = 0.0
		actual_speed = displacement.length() / maxf(delta, 0.0001)
	_previous_position = position_now
	_previous_valid = true
	var state: int = fighter.current_state
	var t: float = fighter.state_timer
	if state == Fighter.State.MOVING:
		var gait := "run" if actual_speed > 2.5 * _body_scale and anim_player.has_animation("run") else "walk"
		_play(gait, 0.12)
		update_locomotion_stride()
		gait_clock += delta * anim_player.speed_scale
		t = gait_clock
	elif state == Fighter.State.IDLE:
		gait_clock += delta
		t = gait_clock
	elif state in [Fighter.State.GRAPPLING_ATTACKER, Fighter.State.GRAPPLING_DEFENDER]:
		var owner: Fighter = fighter if state == Fighter.State.GRAPPLING_ATTACKER else fighter.synchronized_partner
		if is_instance_valid(owner):
			t = owner.state_timer
			var partner: Fighter = owner.synchronized_partner
			if is_instance_valid(partner):
				var leverage := owner.stat_power < partner.stat_power or owner.reach_distance < partner.reach_distance
				var clip := "throw_leverage_" if leverage else "throw_"
				clip += "attacker" if state == Fighter.State.GRAPPLING_ATTACKER else "defender"
				_play(clip, 0.035)
			# Shared phase mapping preserves impact and release even after move tuning.
			if t <= owner.throw_impact_time:
				t *= 0.60 / maxf(owner.throw_impact_time, 0.001)
			else:
				t = 0.60 + (t - owner.throw_impact_time) * 0.50 / maxf(owner.throw_duration - owner.throw_impact_time, 0.001)
	elif state == Fighter.State.KNOCKED_DOWN and (_fall_already_played or t > 0.60):
		_play("downed", 0.04)
	var animation := anim_player.get_animation(current_anim)
	if animation == null:
		return
	var length := maxf(animation.length, 0.001)
	var sample_time := fposmod(t, length) if current_anim in LOOPING else clampf(t, 0.0, length)
	anim_player.seek(sample_time, true)
	_blend_elapsed += delta
	var alpha := smoothstep(0.0, maxf(_blend_duration, 0.001), _blend_elapsed)
	if alpha < 1.0 and _from_positions.size() == skeleton.get_bone_count():
		for bone in range(skeleton.get_bone_count()):
			skeleton.set_bone_pose_position(bone, _from_positions[bone].lerp(skeleton.get_bone_pose_position(bone), alpha))
			skeleton.set_bone_pose_rotation(bone, _from_rotations[bone].slerp(skeleton.get_bone_pose_rotation(bone), alpha))
	if _impact_time > 0.0 and _chest >= 0 and state in [Fighter.State.IDLE, Fighter.State.MOVING, Fighter.State.STRIKING, Fighter.State.BLOCKING]:
		_impact_time = maxf(0.0, _impact_time - delta)
		var recoil := Quaternion(Vector3.RIGHT, -0.12 * sin(PI * _impact_time / 0.16))
		skeleton.set_bone_pose_rotation(_chest, skeleton.get_bone_pose_rotation(_chest) * recoil)

	contact.ground_pose()
