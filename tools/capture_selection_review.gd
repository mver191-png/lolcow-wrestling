extends SceneTree
func _init(): call_deferred("run")
func run():
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://evidence/self-review/renders"))
 root.content_scale_size=Vector2i(1920,1080)
 root.content_scale_mode=Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
 root.size=Vector2i(1280,720)
 var menu:CharacterSelect=load("res://scenes/ui/character_select.tscn").instantiate()
 var audio=menu.get_node("AudioManager");menu.remove_child(audio);audio.free();AudioManager.instance=null
 root.add_child(menu)
 for i in range(20):await process_frame
 print('P1 viewport=',menu.preview_p1.viewport.size,' container=',menu.preview_p1.size,' visible=',menu.preview_p1.is_visible_in_tree(),' current=',menu.preview_p1.viewport.get_camera_3d(),' model=',menu.preview_p1.model)
 for preview in [menu.preview_p1,menu.preview_p2]:
  var image=preview.viewport.get_texture().get_image()
  var colors={}
  var covered=0
  for y in range(0,image.get_height(),2):
   for x in range(0,image.get_width(),2):
    var c=image.get_pixel(x,y)
    if c.a>.5:
     covered+=1
     colors[c.to_rgba32()]=true
  if covered<1000 or colors.size()<32:
   push_error('Empty or unreadable live model preview')
   quit(1)
   return
  print('VERIFIED PREVIEW ',preview.current_id,' covered samples=',covered,' colors=',colors.size())
 await RenderingServer.frame_post_draw
 var result=root.get_texture().get_image().save_png('res://evidence/self-review/renders/selection-normal-loop.png')
 if result!=OK:
  push_error('Could not save selection review frame')
  quit(1)
  return
 result=menu.preview_p1.viewport.get_texture().get_image().save_png('res://evidence/self-review/renders/p1-viewport.png')
 if result!=OK:
  push_error('Could not save preview review frame')
  quit(1)
  return
 menu.queue_free();await process_frame;quit()
