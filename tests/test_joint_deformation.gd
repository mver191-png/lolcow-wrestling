extends SceneTree
## Tests the SKINNED crease ring, not a bone name/polycount proxy.
const FIGHTER = preload("res://scenes/fighter/fighter.tscn")
const SKIN = preload("res://scripts/fighter/skinned_surface.gd")
const IK = preload("res://scripts/fighter/contact_ik.gd")
const DEFORM = preload("res://scripts/fighter/joint_deformation.gd")
var passed := 0
var failed := 0
var measurements: Array[Dictionary] = []

func _init() -> void: call_deferred("run")
func check(ok: bool, label: String) -> void:
    if ok: passed += 1
    else:
        failed += 1
        printerr("[FAIL] ",label)
func tick(count := 1) -> void:
    for i in range(count): await physics_frame

func crease_vertices(surface: SkinnedSurface, helper: int) -> Array[Dictionary]:
    var selected: Array[Dictionary] = []
    var global_index := 0
    for data in surface._surfaces:
        for v in range(data.v.size()):
            var influence := 0.0
            for k in range(data.stride):
                var index: int = data.j[v*data.stride+k]
                if data.bones[index] == helper:
                    influence += data.w[v*data.stride+k]
            var on_plane := absf(data.v[v].y - surface.skeleton.get_bone_global_rest(helper).origin.y) < .000001
            if influence > .99999 and on_plane and data.material in ["skin","gear"]:
                # Each selected vertex uses only the skin helper transform.
                selected.append({"bind": data.v[v], "index":global_index+v})
        global_index += data.v.size()
    return selected

func polygon_area(points: Array[Vector3]) -> float:
    points.sort_custom(func(a,b): return atan2(a.z,a.x)<atan2(b.z,b.x))
    var area := 0.0
    for i in range(points.size()):
        var j := (i+1)%points.size()
        area += points[i].x*points[j].z-points[j].x*points[i].z
    return absf(area)*.5

func run() -> void:
    await tick(2)
    for id in RosterData.get_all_ids():
        await verify_character(id)
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://evidence"))
    var out := FileAccess.open("res://evidence/joint-deformation.json",FileAccess.WRITE)
    out.store_string(JSON.stringify(measurements,"  "))
    print("JOINT DEFORMATION: %d passed, %d failed"%[passed,failed])
    quit(1 if failed else 0)

func verify_character(id: String) -> void:
    var f: Fighter = FIGHTER.instantiate()
    f.character_id=id
    f.use_external_input=true
    root.add_child(f)
    await tick(3)
    var s: Skeleton3D=f.presentation.skeleton
    check(s.get_bone_count()==46,"Original humanoid plus four helper siblings")
    # Verify active engine scheduling BEFORE isolating deformation measurements.
    for state in [Fighter.State.BLOCKING,Fighter.State.STRIKING,Fighter.State.GETTING_UP]:
        f._set_state(state)
        await tick(5)
        for h in DEFORM.DRIVERS:
            var helper:=s.find_bone(h)
            var driver:=s.find_bone(DEFORM.DRIVERS[h])
            var wanted:=Quaternion.IDENTITY.slerp(s.get_bone_pose_rotation(driver),.5)
            check(absf(s.get_bone_pose_rotation(helper).dot(wanted))>.99999,"Helper follows final physics pose")
    f.set_physics_process(false)
    f.presentation.set_physics_process(false)
    f.presentation.contact.enabled=false
    f.presentation.polish.set_physics_process(false)
    f.presentation.clearance.enabled=false
    f.presentation.deformation.set_physics_process(false)
    f.presentation.model.transform=Transform3D.IDENTITY
    f.global_transform=Transform3D.IDENTITY
    var skin:=SKIN.new()
    skin.setup(f.presentation.model,s)
    for name in DEFORM.DRIVERS:
        var helper:=s.find_bone(name)
        var driver:=s.find_bone(DEFORM.DRIVERS[name])
        var parent:=s.get_bone_parent(driver)
        check(s.get_bone_parent(helper)==parent,"Helper does not reparent the IK chain")
        check(s.get_bone_rest(helper).origin.is_equal_approx(s.get_bone_rest(driver).origin),"Helper coincides with original joint")
        var vertices:=crease_vertices(skin,helper)
        check(vertices.size()==33,"Exactly one 32-segment crease ring is driven")
        var inverse_rest:=s.get_bone_global_rest(helper).affine_inverse()
        var reference: Array[Vector3]=[]
        for v in vertices: reference.append(inverse_rest*v.bind)
        var reference_area:=polygon_area(reference)
        check(reference_area>.001,"Measured crease has nonzero cross-section")
        for degrees in [0.0,45.0,90.0,135.0]:
            s.reset_bone_poses()
            s.set_bone_pose_rotation(driver,Quaternion(Vector3.RIGHT,deg_to_rad(degrees)))
            var positions: Array[Vector3]=[]
            for i in range(s.get_bone_count()): positions.append(s.get_bone_pose_position(i))
            f.presentation.deformation._physics_process(1.0/60)
            var unchanged:=true
            for i in range(s.get_bone_count()):
                unchanged=unchanged and positions[i].is_equal_approx(s.get_bone_pose_position(i))
            check(unchanged,"Deformation never changes bone translations")
            var posed:=IK.world_pose(s,helper)
            var helper_skin:=posed*inverse_rest
            var parent_skin:=IK.world_pose(s,parent)*s.get_bone_global_rest(parent).affine_inverse()
            var lower_skin:=IK.world_pose(s,driver)*s.get_bone_global_rest(driver).affine_inverse()
            var corrected: Array[Vector3]=[]
            var legacy: Array[Vector3]=[]
            # Original v3 classifier at the crease: smooth(0.08 / 0.17).
            var t:=.08/.17
            var w:=t*t*(3-2*t)
            var inverse_pose:=posed.affine_inverse()
            var actual_vertices := skin.world_vertices()
            for vertex in vertices:
                corrected.append(inverse_pose*actual_vertices[vertex.index])
                legacy.append(inverse_pose*((parent_skin*vertex.bind)*(1-w)+(lower_skin*vertex.bind)*w))
            var ratio:=polygon_area(corrected)/reference_area
            var legacy_ratio:=polygon_area(legacy)/reference_area
            check(absf(ratio-1.0)<.002,"Crease retains its bind cross-sectional area")
            if degrees>=90: check(ratio>legacy_ratio+.20,"Large bend improves over actual legacy blend weights")
            measurements.append({"character":id,"joint":name,"bend_degrees":degrees,"ring_vertices":vertices.size(),"area_ratio":ratio,"legacy_area_ratio":legacy_ratio})
    f.queue_free()
    await tick(2)
