extends SceneTree
## Reproducible model-level bend study. Identical script works with the preceding
## v3 GLBs (42 joints) and the integrated 46-joint assets. No generated artwork.
const IDS := ["tophiachu","cyraxx","novaonline","candy_rooks","andy_ditch","jupiter_the_hybrid","anacondasin","daniel_larson"]
const DRIVERS := {"DeformElbow.L":"Forearm.L","DeformElbow.R":"Forearm.R","DeformKnee.L":"Shin.L","DeformKnee.R":"Shin.R"}
var world: Node3D
var camera: Camera3D
var rig: Skeleton3D
var model: Node3D
var output := "res://evidence/deformation-renders"
var entries: Array[Dictionary] = []

func _init() -> void: call_deferred("run")
func find_rig(node: Node) -> Skeleton3D:
    if node is Skeleton3D: return node
    for child in node.get_children():
        var result:=find_rig(child)
        if result!=null: return result
    return null
func rotate(name: String, angles: Vector3) -> void:
    var i:=rig.find_bone(name)
    if i>=0: rig.set_bone_pose_rotation(i,Quaternion.from_euler(angles))
func pose(kind: String) -> void:
    rig.reset_bone_poses()
    if kind=="arm":
        rotate("UpperArm.L",Vector3(.28,0,1.24))
        rotate("Forearm.L",Vector3(0,0,-deg_to_rad(125.0)))
        rotate("UpperArm.R",Vector3(.2,0,-.16))
        rotate("Forearm.R",Vector3(1.45,0,0))
    else:
        var hips:=rig.find_bone("Hips")
        var p:=rig.get_bone_pose_position(hips)
        p.y-=.39
        rig.set_bone_pose_position(hips,p)
        for side in ["L","R"]:
            rotate("Thigh."+side,Vector3(1.04,0,0))
            rotate("Shin."+side,Vector3(-1.95,0,0))
            rotate("Foot."+side,Vector3(.91,0,0))
            rotate("UpperArm."+side,Vector3(.7,0,.2 if side=="L" else -.2))
            rotate("Forearm."+side,Vector3(1.3,0,0))
    for h in DRIVERS:
        var helper:=rig.find_bone(h)
        if helper>=0: rig.set_bone_pose_rotation(helper,Quaternion.IDENTITY.slerp(rig.get_bone_pose_rotation(rig.find_bone(DRIVERS[h])),.5))
    rig.force_update_all_bone_transforms()
func shoot(id: String, name: String, eye: Vector3, target: Vector3) -> void:
    camera.position=eye
    camera.look_at(target)
    camera.force_update_transform()
    await process_frame
    await process_frame
    RenderingServer.force_sync()
    RenderingServer.force_draw(false)
    var image:=root.get_texture().get_image()
    var path:=output.path_join(id+"-"+name+".png")
    if image.save_png(path)!=OK:
        push_error("Capture write failed: "+path)
        quit(1)
    entries.append({"character":id,"pose":name,"joints":rig.get_bone_count(),"file":path})
func run() -> void:
    root.content_scale_size=Vector2i.ZERO
    root.content_scale_mode=Window.CONTENT_SCALE_MODE_DISABLED
    root.size=Vector2i(960,720)
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
    world=Node3D.new();root.add_child(world)
    var e:=WorldEnvironment.new();e.environment=Environment.new()
    e.environment.background_mode=Environment.BG_COLOR
    e.environment.background_color=Color(.075,.09,.12)
    e.environment.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
    e.environment.ambient_light_color=Color(.78,.82,.87)
    e.environment.ambient_light_energy=.38
    e.environment.tonemap_mode=Environment.TONE_MAPPER_FILMIC
    world.add_child(e)
    for spec in [[Vector3(-30,-35,0),.8],[Vector3(-20,130,0),.35]]:
        var l:=DirectionalLight3D.new();l.rotation_degrees=spec[0];l.light_energy=spec[1];world.add_child(l)
    camera=Camera3D.new();camera.fov=32;world.add_child(camera);camera.make_current()
    var selected: Array = ["tophiachu"] if "--quick" in OS.get_cmdline_user_args() else IDS
    for id in selected:
        model=load("res://assets/models/"+id+".glb").instantiate();world.add_child(model)
        rig=find_rig(model)
        var scale:float=rig.get_bone_global_rest(rig.find_bone("Hips")).origin.y/.89
        pose("arm")
        var elbow:Vector3=rig.global_transform*rig.get_bone_global_pose(rig.find_bone("Forearm.L")).origin
        await shoot(id,"elbow",elbow+Vector3(.42,.27,-.85)*scale,elbow)
        await shoot(id,"upper_body",Vector3(.25,1.35,-3.1)*scale,Vector3(0,1.30,0)*scale)
        pose("knee")
        var knee:Vector3=rig.global_transform*rig.get_bone_global_pose(rig.find_bone("Shin.L")).origin
        await shoot(id,"knee",knee+Vector3(.85,.12,-.35)*scale,knee)
        model.queue_free();await process_frame;await process_frame
    var out:=FileAccess.open(output.path_join("manifest.json"),FileAccess.WRITE)
    out.store_string(JSON.stringify(entries,"  "))
    print("DEFORMATION CAPTURES: ",entries.size())
    quit()
