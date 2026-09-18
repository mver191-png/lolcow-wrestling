extends SceneTree
## Deterministic in-engine comparison. Staged poses, not a human playtest.
var output:="res://evidence/choreography-after"
var baseline:=false
func _init()->void:call_deferred("run")
func settle()->void:
 for i in range(10):await physics_frame
 await RenderingServer.frame_post_draw
func shot(label:String)->void:
 await settle()
 var result:=root.get_texture().get_image().save_png(output.path_join(label+".png"))
 if result!=OK:push_error("Screenshot failed: "+label)
func run()->void:
 for arg in OS.get_cmdline_user_args():
  if arg=="--baseline":baseline=true
  if arg.begins_with("--out="):output=arg.trim_prefix("--out=")
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
 root.size=Vector2i(1280,720)
 seed(912)
 MatchConfig.set_match("tophiachu","cyraxx",false)
 var scene:Node3D=load("res://scenes/main.tscn").instantiate();root.add_child(scene)
 var a:Fighter=scene.get_node("Tophiachu");var b:Fighter=scene.get_node("Cyraxx")
 scene.get_node("CPUController_P2").set_physics_process(false)
 scene.get_node("MatchManager").set_physics_process(false)
 scene.get_node("Referee").set_physics_process(false)
 scene.get_node("Referee").position=Vector3(-2.5,0,-2.5)
 var camera:Camera3D=scene.get_node("BroadcastCamera");camera.set_physics_process(false)
 for f in [a,b]:
  f.use_external_input=true;f.clear_inputs();f.set_physics_process(false)
  f.presentation.authored_motion_enabled=not baseline
 b.visual_root.hide()
 scene.get_node("Referee").hide()
 a.position=Vector3.ZERO;a.rotation.y=0
 b.position=Vector3(2.3,0,-2.0);b.rotation.y=0
 camera.position=Vector3(2.3,1.55,-3.3);camera.look_at(Vector3(0,.85,0),Vector3.UP)
 a._set_state(Fighter.State.GETTING_UP);a.state_timer=.30
 await shot("recovery-front")
 camera.position=Vector3(3.1,1.5,1.5);camera.look_at(Vector3(0,.80,0),Vector3.UP)
 await shot("recovery-side")
 a._start_strike();a.state_timer=.19
 camera.position=Vector3(2.3,1.9,-3.3);camera.look_at(Vector3(0,1.0,0),Vector3.UP)
 await shot("clothesline")
 a.visual_root.hide();b.visual_root.show()
 a.position=Vector3(2.3,0,-2);a._set_state(Fighter.State.IDLE)
 b.position=Vector3.ZERO;b.rotation.y=0;b._start_strike();b.state_timer=.25
 await shot("flurry-right")
 b.state_timer=.35
 await shot("flurry-left")
 scene.queue_free()
 await physics_frame
 print("CAPTURED ",output)
 quit()
