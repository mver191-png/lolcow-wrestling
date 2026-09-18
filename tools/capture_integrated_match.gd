extends SceneTree
## Scripted visual demonstration. Real input drives strikes/grapple/pin; the one
## escape is explicitly forced for visibility. No performance or human-play claim.
var scene:Node3D
var output:="res://evidence/integrated-match"
var index:=0
func _init()->void:call_deferred("run")
func draw(name:String)->void:
    await process_frame
    RenderingServer.force_sync();RenderingServer.force_draw(false)
    var result:=root.get_texture().get_image().save_png(output.path_join(name+".png"))
    if result!=OK:push_error("Capture failed: "+name)
func step(count:int)->void:
    for i in range(count):
        await physics_frame
        if i%2==0:
            await draw("frames/%04d"%index);index+=1
func run()->void:
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output.path_join("frames")))
    root.size=Vector2i(960,540)
    MatchConfig.set_match("tophiachu","cyraxx",false)
    scene=load("res://scenes/main.tscn").instantiate()
    var audio:=scene.get_node("AudioManager");scene.remove_child(audio);audio.free();AudioManager.instance=null
    root.add_child(scene)
    var a:Fighter=scene.get_node("Tophiachu")
    var b:Fighter=scene.get_node("Cyraxx")
    scene.get_node("CPUController_P2").set_physics_process(false)
    a.use_external_input=true;b.use_external_input=true
    a.position=Vector3(-.46,0,0);b.position=Vector3(.46,0,0)
    var camera:Camera3D=scene.get_node("BroadcastCamera")
    camera.set_physics_process(false);camera.position=Vector3(3.5,2.7,4.5);camera.look_at(Vector3(0,.8,0))
    await step(30)
    a.apply_command({"strike":true})
    await step(44)
    await draw("after-clothesline")
    b.apply_command({"strike":true})
    await step(44)
    await draw("after-flurry")
    a.apply_command({"grapple":true})
    await step(36)
    await draw("cradle")
    await step(56)
    a.apply_command({"pin":true})
    await step(66)
    await draw("pin-count")
    b.pin_escape_progress=101.0
    await step(16)
    await draw("recovery")
    await step(54)
    await draw("ready")
    print("INTEGRATED CAPTURE: ",index," frames; one scripted kickout")
    scene.queue_free();await physics_frame;await physics_frame
    quit()
