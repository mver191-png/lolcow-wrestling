class_name ContactIK
extends RefCounted
## Two-bone positional IK. Rotations only: never changes bone translations/scales.
## Targets are world-space; Skeleton3D global poses are skeleton-space.

static func world_pose(skeleton: Skeleton3D, bone: int) -> Transform3D:
	return skeleton.global_transform * skeleton.get_bone_global_pose(bone)

static func point(skeleton: Skeleton3D, bone: int, local := Vector3.ZERO) -> Vector3:
	return world_pose(skeleton, bone) * local

static func _world_rotation(skeleton: Skeleton3D, bone: int, rotation: Quaternion) -> void:
	var parent := skeleton.get_bone_parent(bone)
	var parent_basis := skeleton.global_basis
	if parent >= 0:
		parent_basis = world_pose(skeleton, parent).basis
	var local := parent_basis.orthonormalized().get_rotation_quaternion().inverse() * rotation
	skeleton.set_bone_pose_rotation(bone, local.normalized())
	skeleton.force_update_all_bone_transforms()

static func _aim(skeleton: Skeleton3D, bone: int, from: Vector3, to: Vector3) -> void:
	if from.length_squared() < 0.000001 or to.length_squared() < 0.000001:
		return
	var before := world_pose(skeleton, bone).basis.orthonormalized().get_rotation_quaternion()
	_world_rotation(skeleton, bone, Quaternion(from.normalized(), to.normalized()) * before)

static func solve(skeleton: Skeleton3D, upper: int, middle: int, end: int,
		target: Vector3, pole: Vector3, weight := 1.0) -> Dictionary:
	if skeleton == null or min(upper, min(middle, end)) < 0 or not target.is_finite():
		return {"valid": false}
	skeleton.force_update_all_bone_transforms()
	var start := point(skeleton, upper)
	var elbow := point(skeleton, middle)
	var endpoint := point(skeleton, end)
	var l1 := start.distance_to(elbow)
	var l2 := elbow.distance_to(endpoint)
	if minf(l1, l2) < 0.0001:
		return {"valid": false}
	var requested := target
	target = endpoint.lerp(target, clampf(weight, 0.0, 1.0))
	var offset := target - start
	var raw_distance := offset.length()
	var direction := offset.normalized() if raw_distance > 0.00001 else Vector3.DOWN
	# Keep a slight elbow bend. Unreachable requests are reported, not stretched.
	var distance := clampf(raw_distance, absf(l1 - l2) + 0.001, l1 + l2 - 0.002)
	var bend := pole - start
	bend -= direction * bend.dot(direction)
	if bend.length_squared() < 0.000001:
		bend = direction.cross(Vector3.RIGHT if absf(direction.x) < 0.9 else Vector3.FORWARD)
	bend = bend.normalized()
	var along := (l1*l1 + distance*distance - l2*l2) / (2.0*distance)
	var height := sqrt(maxf(0.0, l1*l1 - along*along))
	var wanted_elbow := start + direction*along + bend*height
	_aim(skeleton, upper, elbow - start, wanted_elbow - start)
	elbow = point(skeleton, middle)
	endpoint = point(skeleton, end)
	var reachable := start + direction*distance
	_aim(skeleton, middle, endpoint - elbow, reachable - elbow)
	return {"valid": true, "error": point(skeleton, end).distance_to(requested),
		"unreachable": maxf(0.0, raw_distance - (l1 + l2 - 0.002)),
		"upper_length": l1, "lower_length": l2}

static func hand_basis(finger_direction: Vector3, palm_direction: Vector3) -> Basis:
	var y := -finger_direction.normalized()
	var z := -palm_direction.normalized()
	var x := y.cross(z).normalized()
	if x.length_squared() < 0.01:
		x = y.cross(Vector3.RIGHT if absf(y.x) < 0.9 else Vector3.FORWARD).normalized()
	z = x.cross(y).normalized()
	return Basis(x, y, z).orthonormalized()
