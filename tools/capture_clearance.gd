extends SceneTree
## Staged real-engine poses at fixed clocks. Not a human match or performance test.
const SURFACE=preload("res://scripts/fighter/skinned_surface.gd")
var output:="res://evidence/clearance-captures"
var metadata:Array=[]
func _init()->void:call_deferred("run")
func settle()->void:
 for i in range(14):await physics_frame
 await RenderingServer.frame_post_draw
func shot(label:String,a:Fighter,b:Fighter)->void:
 await settle()
 var error:=root.get_texture().get_image().save_png(output.path_join(label+".png"))
 if error!=OK:push_error("Capture failed: "+label)
 for f in [a,b]:
  var surface=SURFACE.new();surface.setup(f.presentation.model,f.presentation.skeleton)
  var d=SURFACE.measure(surface.world_vertices());d.character=f.character_id;d.frame=label;d.clock=f.state_timer;metadata.append(d)
func run()->void:
 for arg in OS.get_cmdline_user_args():
  if arg.begins_with("--out="):output=arg.trim_prefix("--out=")
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
 root.size=Vector2i(1280,720)
 MatchConfig.set_match("cyraxx","tophiachu",false)
 seed(704)
 var scene:Node3D=load("res://scenes/main.tscn").instantiate();root.add_child(scene)
 var a:Fighter=scene.get_node("Tophiachu");var b:Fighter=scene.get_node("Cyraxx")
 scene.get_node("CPUController_P2").set_physics_process(false)
 scene.get_node("MatchManager").set_physics_process(false)
 var referee:Referee=scene.get_node("Referee");referee.set_physics_process(false);referee.position=Vector3(-2.5,0,-2.5)
 for f in [a,b]:f.use_external_input=true;f.clear_inputs();f.set_physics_process(false)
 var cam:Camera3D=scene.get_node("BroadcastCamera");cam.set_physics_process(false)
 a.position=Vector3(-.55,0,0);b.position=Vector3(.55,0,0)
 cam.position=Vector3(3.1,1.65,3.2);cam.look_at(Vector3(0,.75,0),Vector3.UP)
 a._start_synchronized_throw(b);a.state_timer=.28;a._process_synchronized_attacker()
 await shot("01-leverage",a,b)
 a._set_state(Fighter.State.IDLE);a.synchronized_partner=null
 b.on_throw_released();b.state_timer=1.0
 a.position=Vector3(-2.5,0,-1.0);a.rotation.y=0
 b.position=Vector3.ZERO;b.rotation.y=0
 b._set_state(Fighter.State.GETTING_UP);b.state_timer=.28
 cam.position=Vector3(2.8,1.8,3.3);cam.look_at(Vector3(0,.75,0),Vector3.UP)
 await shot("02-recovery",a,b)
 a.position=Vector3(2.8,0,2.95);b.position=Vector3(3.35,0,2.95)
 a._start_synchronized_throw(b);a.state_timer=.68;a._process_synchronized_attacker()
 cam.position=Vector3(5.7,2.6,6.0);cam.look_at(Vector3(2.9,.6,2.5),Vector3.UP)
 await shot("03-corner",a,b)
 var file:=FileAccess.open(output.path_join("capture-metadata.json"),FileAccess.WRITE)
 file.store_string(JSON.stringify(metadata,"  "))
 scene.queue_free()
 await physics_frame
 print("CAPTURED ",output)
 quit()
