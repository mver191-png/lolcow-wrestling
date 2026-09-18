class_name JointDeformation
extends Node
## Skin-only driver joints. Original movement/IK chains are never changed.
## Runs after authored poses, contact fitting and hand polish; before mesh bounds.
const DRIVERS := {
    "DeformElbow.L": "Forearm.L", "DeformElbow.R": "Forearm.R",
    "DeformKnee.L": "Shin.L", "DeformKnee.R": "Shin.R"
}
var presentation: Node
var enabled := true
var _skeleton: Skeleton3D
var _pairs: Array[Vector2i] = []

func setup(owner_presentation: Node) -> void:
    presentation = owner_presentation
    process_physics_priority = 38

func reset() -> void:
    _pairs.clear()
    _skeleton = presentation.skeleton
    if not is_instance_valid(_skeleton): return
    for helper in DRIVERS:
        var h := _skeleton.find_bone(helper)
        var d := _skeleton.find_bone(DRIVERS[helper])
        if h >= 0 and d >= 0:
            # Helpers must remain siblings, coincident with the lower joint.
            if _skeleton.get_bone_parent(h) != _skeleton.get_bone_parent(d):
                push_error("Invalid deformation helper parent: " + helper)
                continue
            _pairs.append(Vector2i(h,d))

func _physics_process(_delta: float) -> void:
    if not is_instance_valid(presentation) or not presentation.has_skeletal_rig: return
    if _skeleton != presentation.skeleton: reset()
    if not is_instance_valid(_skeleton): return
    for pair in _pairs:
        var driver := _skeleton.get_bone_pose_rotation(pair.y).normalized()
        # Shortest-arc half rotation. This is a radial skin ring driver, NOT a
        # shoulder/joint-limit solver. Skin offsets/translations are unchanged.
        var rotation := Quaternion.IDENTITY.slerp(driver,0.5) if enabled else Quaternion.IDENTITY
        _skeleton.set_bone_pose_rotation(pair.x,rotation)
    _skeleton.force_update_all_bone_transforms()
