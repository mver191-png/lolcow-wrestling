class_name RecoveryContact
extends RefCounted
## Pose-only support during the existing 0.60 s recovery. Anchors are latched in
## world space, released by phase, and never move the Fighter or extend a limb.
const IK = preload("res://scripts/fighter/contact_ik.gd")
const PALM := Vector3(0.0, -0.045, -0.012)
var active := false
var anchors: Dictionary = {}
var _axis := Basis.IDENTITY
var _scale := 1.0

func reset() -> void:
	active = false
	anchors.clear()

func _window(t: float, enter: Vector2, leave: Vector2) -> float:
	return smoothstep(enter.x, enter.y, t) * (1.0 - smoothstep(leave.x, leave.y, t))

func _latch(f: Fighter, s: Skeleton3D) -> void:
	_scale = maxf(s.get_bone_global_rest(s.find_bone("Hips")).origin.y / .89, .1)
	_axis = f.global_basis.orthonormalized()
	var shoulder_x := s.get_bone_global_rest(s.find_bone("UpperArm.L")).origin.x
	anchors["palm"] = f.global_transform * Vector3(shoulder_x + .06*_scale, .035*_scale, .38*_scale)
	for side in ["L", "R"]:
		var rest := s.get_bone_global_rest(s.find_bone("Foot."+side)).origin
		anchors[side] = f.global_transform * Vector3(rest.x, rest.y, (-.28 if side=="R" else 0.0)*_scale)
	active = true

func apply(presentation: Node, diagnostics: Array[Dictionary]) -> void:
	var f: Fighter = presentation.fighter
	var s: Skeleton3D = presentation.skeleton
	if f.current_state != Fighter.State.GETTING_UP:
		reset()
		return
	for name in ["Hips", "UpperArm.L", "Forearm.L", "Hand.L", "Thigh.L", "Shin.L", "Foot.L", "Thigh.R", "Shin.R", "Foot.R"]:
		if s.find_bone(name) < 0:
			reset()
			return
	if not active:
		_latch(f, s)
	var t: float = clampf(f.state_timer, 0.0, .60)
	var palm_weight := _window(t, Vector2(.02,.06), Vector2(.14,.22))
	# Loading lowers the pelvis slightly before the hand releases. The original
	# complete-pose clip still owns the recovery arc and the final ready pose.
	var hips := s.find_bone("Hips")
	var hip_pose := s.get_bone_pose_position(hips)
	hip_pose.y -= .10*_scale*palm_weight
	s.set_bone_pose_position(hips, hip_pose)
	s.force_update_all_bone_transforms()
	if palm_weight > .001:
		_support_hand(s, palm_weight, diagnostics)
	var right_weight := _window(t, Vector2(.04,.11), Vector2(.43,.59))
	var left_weight := smoothstep(.12,.27,t)
	for side in ["R", "L"]:
		var weight := right_weight if side=="R" else left_weight
		if weight <= .001:
			continue
		var target: Vector3 = anchors[side]
		var hip := IK.point(s,s.find_bone("Thigh."+side))
		var pole := hip - _axis.z*.70*_scale + _axis.x*(.10 if side=="L" else -.10)*_scale
		var foot := s.find_bone("Foot."+side)
		var old := IK.world_pose(s,foot).basis.orthonormalized().get_rotation_quaternion()
		var result := IK.solve(s,s.find_bone("Thigh."+side),s.find_bone("Shin."+side),foot,target,pole,weight)
		if result.get("valid", false):
			IK._world_rotation(s,foot,old.slerp(_axis.get_rotation_quaternion(),weight))
			var actual := IK.point(s,foot)
			result.merge({"kind":"recovery_ankle","side":side,"weight":weight,
				"target":target,"actual":actual,"error":actual.distance_to(target)},true)
			diagnostics.append(result)

func _support_hand(s: Skeleton3D, weight: float, diagnostics: Array[Dictionary]) -> void:
	var surface: Vector3 = anchors.palm
	var basis := IK.hand_basis(_axis.z,Vector3.DOWN)
	var wrist := surface - basis*(PALM*_scale)
	var hand := s.find_bone("Hand.L")
	var old := IK.world_pose(s,hand).basis.orthonormalized().get_rotation_quaternion()
	var pole := IK.point(s,s.find_bone("UpperArm.L")) + _axis.x*.5*_scale
	var result := IK.solve(s,s.find_bone("UpperArm.L"),s.find_bone("Forearm.L"),hand,wrist,pole,weight)
	if not result.get("valid",false):
		return
	IK._world_rotation(s,hand,old.slerp(basis.get_rotation_quaternion(),weight))
	for i in range(5):
		for name in ["Finger%d.L"%i, "Finger%dTip.L"%i]:
			var bone := s.find_bone(name)
			if bone >= 0:
				s.set_bone_pose_rotation(bone,s.get_bone_pose_rotation(bone).slerp(Quaternion.IDENTITY,weight))
	var actual := IK.point(s,hand,PALM*_scale)
	result.merge({"kind":"recovery_palm","side":"L","weight":weight,
		"target":surface,"actual":actual,"error":actual.distance_to(surface)},true)
	diagnostics.append(result)
