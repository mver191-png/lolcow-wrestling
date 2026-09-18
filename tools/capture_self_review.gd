extends "res://tools/capture_model_quality.gd"
## Source-review evidence: exact current meshes, no image retouching or generated
## photo substitutes. UI capture runs the real selection scene with its previews.
func render_file(path: String) -> void:
 await process_frame
 await process_frame
 RenderingServer.force_sync()
 RenderingServer.force_draw(false)
 var err:=root.get_texture().get_image().save_png(path)
 if err!=OK:
  push_error("Capture save failed: "+path)
  quit(1)

func run() -> void:
 output="res://evidence/self-review/renders"
 root.content_scale_size=Vector2i.ZERO
 root.content_scale_mode=Window.CONTENT_SCALE_MODE_DISABLED
 root.size=Vector2i(960,800)
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
 make_stage()
 for lamp in stage.get_children():
  if lamp is DirectionalLight3D:
   lamp.shadow_enabled=false
   lamp.light_energy*=.82
 for id in ["cyraxx","referee_cobra","andy_ditch"]:
  if id=="referee_cobra":
   character=load("res://scenes/referee/referee.tscn").instantiate()
   stage.add_child(character)
   await tick(4)
   character.set_physics_process(false)
  else:
   var f:Fighter=load("res://scenes/fighter/fighter.tscn").instantiate()
   f.character_id=id
   f.use_external_input=true
   character=f
   stage.add_child(character)
   await tick(12)
  character.rotation.y=0.0
  await shot(id,"face_front",true)
  character.rotation.y=-.45
  await shot(id,"face_three_quarter",true)
  character.rotation.y=-1.28
  await shot(id,"face_profile",true)
  character.queue_free()
  await tick(2)
 stage.queue_free()
 root.get_node("FrameLabel").queue_free()
 await tick(3)
 root.content_scale_size=Vector2i(1920,1080)
 root.content_scale_mode=Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 root.size=Vector2i(1280,720)
 var menu:CharacterSelect=load("res://scenes/ui/character_select.tscn").instantiate()
 var audio:=menu.get_node("AudioManager")
 menu.remove_child(audio)
 audio.free()
 AudioManager.instance=null
 root.add_child(menu)
 await tick(12)
 menu.preview_p1.viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
 menu.preview_p2.viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
 RenderingServer.force_draw(false)
 await render_file(output.path_join("selection-1280.png"))
 menu.queue_free()
 await tick(3)
 print("REVIEW CAPTURES: 9 portraits and real selection screen")
 quit()
