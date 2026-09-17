class_name PairedContact
extends Node
## Cosmetic contact pass, AFTER every actor has sampled its animation (priority 20).
## Does not modify Fighter transforms, collision shapes, clocks, resources or rules.
const IK = preload("res://scripts/fighter/contact_ik.gd")
const HAND_LOCAL := Vector3(0.0, -0.045, -0.012)
const RECOVERY = preload("res://scripts/fighter/recovery_contact.gd")
var recovery := RECOVERY.new()
var recovery_enabled := true
var presentation: Node
var enabled := true
var diagnostics: Array[Dictionary] = []
var _bones: Dictionary = {}
var _scale := 1.0
var _width := 0.3
var _depth := 0.22
var _last_state := -1
var _last_model := Transform3D.IDENTITY
var _exit_model := Transform3D.IDENTITY
var _exit_remaining := 0.0
var ground_correction := 0.0

func setup(owner_presentation: Node) -> void:
	presentation = owner_presentation
	process_physics_priority = 30

func reset() -> void:
	recovery.reset()
	_bones.clear()
	_last_state = -1
	_last_model = Transform3D.IDENTITY
	_exit_model = Transform3D.IDENTITY
	_exit_remaining = 0.0
	diagnostics.clear()
	if presentation.skeleton == null:
		return
	var s: Skeleton3D = presentation.skeleton
	for i in range(s.get_bone_count()):
		_bones[s.get_bone_name(i)] = i
	_scale = maxf(s.get_bone_global_rest(_bone("Hips")).origin.y / 0.89, 0.1)
	_width = absf(s.get_bone_global_rest(_bone("UpperArm.L")).origin.x) / _scale - 0.055
	# Infer a bounded silhouette envelope from the canonical rig; not a physics hull.
	_depth = clampf(_width * 0.72, 0.17, 0.32)

func begin_pose(delta: float) -> void:
	# Authoring playback always starts from a clean model transform. Corrections
	# cannot accumulate. Exit offsets ease out without writing the gameplay root.
	presentation.model.transform = Transform3D.IDENTITY
	if not enabled:
		recovery.reset()
		_exit_remaining = 0.0
		_last_model = Transform3D.IDENTITY
		_last_state = presentation.fighter.current_state
		return
	var st: int = presentation.fighter.current_state
	var active := st in [Fighter.State.GRAPPLING_ATTACKER, Fighter.State.PINNING, Fighter.State.SUBMISSION_ATTACKER]
	var previous_active := _last_state in [Fighter.State.GRAPPLING_ATTACKER, Fighter.State.PINNING, Fighter.State.SUBMISSION_ATTACKER]
	if not active and previous_active and st != _last_state:
		_exit_model = _last_model
		_exit_remaining = .16
	if not active and _exit_remaining > 0.0:
		_exit_remaining = maxf(0.0, _exit_remaining - delta)
		presentation.model.transform = Transform3D.IDENTITY.interpolate_with(_exit_model,smoothstep(0.0,.16,_exit_remaining))
	elif active:
		_exit_remaining = 0.0

func ground_pose() -> void:
	ground_correction = 0.0
	if not enabled or not presentation.has_skeletal_rig:
		return
	var f: Fighter = presentation.fighter
	var grounded := f.current_state in [Fighter.State.PINNED,Fighter.State.SUBMISSION_DEFENDER,Fighter.State.DEFEATED]
	grounded = grounded or (f.current_state == Fighter.State.KNOCKED_DOWN and presentation.current_anim == "downed")
	if not grounded:
		return
	var s: Skeleton3D = presentation.skeleton
	# Anatomical support envelopes: not a promise of whole-mesh collision.
	var minimum := INF
	for spec in [["Hips",Vector3(0,.02,0),Vector3(_width*.85,.13,_depth*.90)],
		["Chest",Vector3(0,-.08,0),Vector3(_width*.90,.14,_depth)]]:
		var pose := IK.world_pose(s,_bone(spec[0]))
		var radius: Vector3 = spec[2]*_scale
		var center: Vector3 = pose * (spec[1]*_scale)
		var extent := Vector3(pose.basis.x.y*radius.x,pose.basis.y.y*radius.y,pose.basis.z.y*radius.z).length()
		minimum = minf(minimum,center.y-extent)
	ground_correction = clampf(f.global_position.y + .008 - minimum,-.10*_scale,.10*_scale)
	presentation.model.position.y += ground_correction
	s.force_update_all_bone_transforms()

func _bone(name: String) -> int:
	return int(_bones.get(name, -1))

func _set_rotation(name: String, euler: Vector3) -> void:
	var index := _bone(name)
	if index >= 0:
		presentation.skeleton.set_bone_pose_rotation(index, Quaternion.from_euler(euler))

func _physics_process(_delta: float) -> void:
	diagnostics.clear()
	if not enabled or presentation == null or not presentation.has_skeletal_rig:
		return
	var f: Fighter = presentation.fighter
	var s: Skeleton3D = presentation.skeleton
	if not is_instance_valid(f) or not f.is_inside_tree():
		return
	if _bones.is_empty():
		reset()
	var st := f.current_state
	if st == Fighter.State.GRAPPLING_ATTACKER:
		_throw_contact(f, s)
	elif st == Fighter.State.PINNING and _partner_ready(f.opponent, Fighter.State.PINNED):
		_cover_contact(f, s, f.opponent)
	elif st == Fighter.State.SUBMISSION_ATTACKER and _partner_ready(f.synchronized_partner, Fighter.State.SUBMISSION_DEFENDER):
		_submission_contact(f, s, f.synchronized_partner)
	if recovery_enabled:
		recovery.apply(presentation, diagnostics)
	else:
		recovery.reset()
	_last_state = st
	_last_model = presentation.model.transform

func _partner_ready(other: Fighter, state: int) -> bool:
	return is_instance_valid(other) and other.is_inside_tree() and other.current_state == state and other.presentation != null and other.presentation.has_skeletal_rig

func _arm(side: String, surface: Vector3, outward: Vector3, fingers: Vector3,
		weight: float, kind: String) -> void:
	var s: Skeleton3D = presentation.skeleton
	var f: Fighter = presentation.fighter
	var hand := _bone("Hand." + side)
	var basis := IK.hand_basis(fingers, -outward)
	var wrist := surface - basis * (HAND_LOCAL * _scale)
	var shoulder := IK.point(s, _bone("UpperArm." + side))
	var lateral := f.global_basis.x * (1.0 if side == "L" else -1.0)
	var pole := shoulder + lateral*0.45 + Vector3.DOWN*0.2
	var before_error := IK.point(s, hand, HAND_LOCAL * _scale).distance_to(surface)
	var before := IK.world_pose(s, hand).basis.orthonormalized().get_rotation_quaternion()
	var result := IK.solve(s, _bone("UpperArm."+side), _bone("Forearm."+side), hand,
		wrist, pole, weight)
	if not result.get("valid", false):
		return
	IK._world_rotation(s, hand, before.slerp(basis.get_rotation_quaternion(), weight))
	var actual := IK.point(s, hand, HAND_LOCAL * _scale)
	result.merge({"kind": kind, "side": side, "weight": weight,
		"target": surface, "actual": actual, "error": actual.distance_to(surface), "before_error": before_error}, true)
	diagnostics.append(result)

func _plant_feet(f: Fighter, s: Skeleton3D, weight: float) -> void:
	for side in ["L", "R"]:
		var rest := s.get_bone_global_rest(_bone("Foot."+side)).origin
		var local := Vector3(rest.x, rest.y + .022*_scale, .045*_scale)
		var target := f.global_transform * local
		var pole := target - f.global_basis.z * .7 + Vector3.UP * .20
		var result := IK.solve(s, _bone("Thigh."+side), _bone("Shin."+side), _bone("Foot."+side), target, pole, weight)
		if result.get("valid", false):
			IK._world_rotation(s, _bone("Foot."+side), f.global_basis.orthonormalized().get_rotation_quaternion())
			result.merge({"kind": "planted_ankle", "side": side, "weight": weight,
				"target": target, "actual": IK.point(s, _bone("Foot."+side))}, true)
			diagnostics.append(result)

func _throw_contact(f: Fighter, s: Skeleton3D) -> void:
	var other: Fighter = f.synchronized_partner
	if not _partner_ready(other, Fighter.State.GRAPPLING_DEFENDER):
		return
	var t := f.state_timer / maxf(f.throw_impact_time, .001) * .60
	# Acquisition and release are explicit. Never force an airborne grip after release.
	var weight := smoothstep(.02, .12, t) * (1.0 - smoothstep(.40, .53, t))
	if weight < .001:
		return
	var leverage := f.stat_power < other.stat_power or f.reach_distance < other.reach_distance
	var contact: Node = other.presentation.contact
	var os: Skeleton3D = other.presentation.skeleton
	var hips := os.find_bone("Hips")
	var other_scale: float = contact._scale
	var other_width: float = contact._width
	var other_depth: float = contact._depth
	var hip_world := IK.world_pose(os, hips)
	var anchors: Array[Vector3] = []
	for sign in [-1.0, 1.0]:
		anchors.append(hip_world * (Vector3(sign*other_width*.48, -.26, other_depth*.56)*other_scale))
	var midpoint := (anchors[0]+anchors[1])*.5
	var shoulder_center := (IK.point(s,_bone("UpperArm.L"))+IK.point(s,_bone("UpperArm.R")))*.5
	var base_hips := s.get_bone_pose_position(_bone("Hips"))
	# Fit the loading pose to the actual partner, within authored body limits.
	var desired_height := midpoint.y + (.18 if leverage else -.14)*_scale
	var height_shift := clampf(desired_height-shoulder_center.y,-.56*_scale,.10*_scale)
	base_hips.y += height_shift*weight
	s.set_bone_pose_position(_bone("Hips"), base_hips)
	var forward := -f.global_basis.z
	var approach := clampf((midpoint-shoulder_center).dot(forward)-.24*_scale,0,.40*_scale)
	presentation.model.position += Vector3(0,0,-approach*weight)
	_set_rotation("Chest", Vector3(-.22*weight,0,0))
	s.force_update_all_bone_transforms()
	_plant_feet(f, s, weight)
	var near_left := IK.point(s, _bone("UpperArm.L")).distance_squared_to(anchors[0]) < IK.point(s, _bone("UpperArm.L")).distance_squared_to(anchors[1])
	for index in range(2):
		var side: String = "L" if index == 0 else "R"
		var target_index := index if near_left else 1-index
		_arm(side, anchors[target_index], hip_world.basis.z, hip_world.basis.y, weight, "throw_cradle")

func _cover_contact(f: Fighter, s: Skeleton3D, other: Fighter) -> void:
	var os: Skeleton3D = other.presentation.skeleton
	var oc: Node = other.presentation.contact
	var chest := IK.world_pose(os, os.find_bone("Chest"))
	var alpha := smoothstep(0.0, .20, f.state_timer)
	# Side-on lateral press: chest across chest rather than two parallel body axes.
	var yaw := wrapf(other.global_rotation.y + PI*.5 - f.global_rotation.y, -PI, PI)
	presentation.model.rotation.y = lerp_angle(0.0, yaw, alpha)
	_set_rotation("Hips", Vector3(-1.14,0,0))
	_set_rotation("Chest", Vector3(-.22,0,0))
	s.force_update_all_bone_transforms()
	var wanted := chest.origin - chest.basis.y*.10*float(oc._scale) + Vector3.UP * (float(oc._depth)*float(oc._scale) + _depth*_scale + .015)
	var current := IK.point(s, _bone("Chest"))
	var shift := (wanted-current).limit_length(.80)
	presentation.model.global_position += shift * alpha
	s.force_update_all_bone_transforms()
	var anchors: Array[Vector3] = [
		chest * (Vector3(float(oc._width)*.45,-.33,-float(oc._depth))*float(oc._scale)),
		chest * (Vector3(float(oc._width)*.45,.08,-float(oc._depth))*float(oc._scale))]
	var left_first := IK.point(s,_bone("UpperArm.L")).distance_squared_to(anchors[0]) < IK.point(s,_bone("UpperArm.L")).distance_squared_to(anchors[1])
	for index in range(2):
		var side: String = "L" if index == 0 else "R"
		var target_index := index if left_first else 1-index
		_arm(side, anchors[target_index]+Vector3.UP*.025, Vector3.UP, chest.basis.y, alpha, "pin_cover")
	# Toe/ankle support behind the cover; avoid the old floating straight legs.
	var pelvis := IK.point(s,_bone("Hips"))
	var axis: Basis = presentation.model.global_basis.orthonormalized()
	for side in ["L","R"]:
		var sign := 1.0 if side=="L" else -1.0
		var ankle: Vector3 = pelvis + axis.z*.39*_scale + axis.x*sign*_width*.47*_scale
		ankle.y = f.global_position.y+.137*_scale
		var pole: Vector3 = pelvis + axis.z*.65*_scale + axis.x*sign*.24*_scale
		var result := IK.solve(s,_bone("Thigh."+side),_bone("Shin."+side),_bone("Foot."+side),ankle,pole,alpha)
		if result.get("valid",false):
			IK._world_rotation(s,_bone("Foot."+side),axis.get_rotation_quaternion())
			result.merge({"kind":"cover_ankle","side":side,"weight":alpha,"target":ankle,
				"actual":IK.point(s,_bone("Foot."+side))},true)
			diagnostics.append(result)

func _submission_contact(f: Fighter, s: Skeleton3D, other: Fighter) -> void:
	var os: Skeleton3D = other.presentation.skeleton
	var oc: Node = other.presentation.contact
	var alpha := smoothstep(0.0, .18, f.state_timer)
	# Kneeling wrist control at the defender's side; no neck constraint.
	var target_wrist := IK.point(os, os.find_bone("Hand.R"))
	var target_forearm := IK.point(os, os.find_bone("Forearm.R"))
	var midpoint := (target_wrist + target_forearm)*.5
	var along := target_wrist-target_forearm
	along.y = 0
	along = along.normalized() if along.length_squared()>.001 else other.global_basis.x
	var forward := Vector3.UP.cross(along).normalized()
	var desired := midpoint - forward*.12*_scale + Vector3.UP*.25*_scale
	var yaw := atan2(-forward.x, -forward.z)-f.global_rotation.y
	presentation.model.rotation.y = lerp_angle(0.0,yaw,alpha)
	var hips := _bone("Hips")
	s.set_bone_pose_position(hips, Vector3(0,.49*_scale,0))
	_set_rotation("Hips", Vector3(-1.2,0,0))
	_set_rotation("Spine", Vector3(-.55,0,0))
	_set_rotation("Chest", Vector3(-.1,0,0))
	for side in ["L","R"]:
		_set_rotation("Thigh."+side,Vector3(1.4,0,0))
		_set_rotation("Shin."+side,Vector3(-PI*.5-.20,0,0))
		_set_rotation("Foot."+side,Vector3(PI*.5,0,0))
	s.force_update_all_bone_transforms()
	var center := (IK.point(s,_bone("UpperArm.L"))+IK.point(s,_bone("UpperArm.R")))*.5
	var offset := desired-center
	# Keep kneeling knees on the mat; horizontal adjustment only.
	offset.y=0
	presentation.model.global_position += offset.limit_length(1.05)*alpha
	s.force_update_all_bone_transforms()
	var anchors: Array[Vector3] = [target_forearm, target_wrist]
	var left_first := IK.point(s,_bone("UpperArm.L")).distance_squared_to(anchors[0]) < IK.point(s,_bone("UpperArm.L")).distance_squared_to(anchors[1])
	for index in range(2):
		var side: String = "L" if index==0 else "R"
		_arm(side,anchors[index if left_first else 1-index]+Vector3.UP*.07*float(oc._scale),Vector3.UP,along,alpha,"wrist_control")
