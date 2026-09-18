extends SceneTree
## Exercises physical key events, focused UI, scene initialization and camera
## accessibility. Unlike action-only fixtures, this catches invalid InputMap codes.
const MENU = preload("res://scenes/ui/character_select.tscn")
const MAIN = preload("res://scenes/main.tscn")
const P2 = {
 "strike": [KEY_KP_1, KEY_1], "grapple": [KEY_KP_2, KEY_2],
 "block": [KEY_KP_3, KEY_3], "reversal": [KEY_KP_4, KEY_4],
 "pin": [KEY_KP_0, KEY_0], "finisher": [KEY_KP_5, KEY_5]
}
var passed := 0
var failed := 0
var records: Array[Dictionary] = []

func _init() -> void:
 call_deferred("run")

func check(ok: bool, label: String) -> void:
 if ok:
  passed += 1
 else:
  failed += 1
  printerr("[FAIL] ", label)

func tick(n := 2) -> void:
 for i in range(n):
  await physics_frame

func key(code: int, pressed: bool) -> InputEventKey:
 var event := InputEventKey.new()
 event.keycode = code
 event.pressed = pressed
 return event

func silent(node: Node) -> void:
 var audio := node.get_node_or_null("AudioManager")
 if audio:
  node.remove_child(audio)
  audio.free()
 AudioManager.instance = null

func run() -> void:
 await tick()
 await key_contract()
 await input_drives_fighters()
 await selection_contract()
 await loading_contract()
 camera_contract()
 var folder := "res://evidence/self-review"
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(folder))
 var out := FileAccess.open(folder.path_join("interaction-checks.json"), FileAccess.WRITE)
 out.store_string(JSON.stringify({"passed":passed,"failed":failed,"records":records},"  "))
 print("REVIEW REGRESSIONS: %d passed, %d failed" % [passed,failed])
 quit(1 if failed else 0)

func key_contract() -> void:
 for action in P2:
  for code in P2[action]:
   var event := key(code,true)
   check(InputMap.action_has_event("p2_"+action,event),"Real key bound: %s/%d"%[action,code])
   Input.parse_input_event(event)
   Input.flush_buffered_events()
   check(Input.is_action_pressed("p2_"+action),"Raw key activates P2 "+action)
   check(not Input.is_action_pressed("p1_"+action),"P2 key does not operate P1 "+action)
   Input.parse_input_event(key(code,false))
   Input.flush_buffered_events()
   check(not Input.is_action_pressed("p2_"+action),"Release clears P2 "+action)
   records.append({"action":action,"key":code,"label":event.as_text()})
   await tick()
 for code in [KEY_KP_MULTIPLY,KEY_KP_DIVIDE,KEY_KP_SUBTRACT,KEY_KP_ADD,KEY_KP_PERIOD]:
  for action in P2:
   check(not InputMap.action_has_event("p2_"+action,key(code,true)),"No accidental arithmetic binding")

func input_drives_fighters() -> void:
 # Real scene physics consumes the same raw events as hardware, not apply_command.
 var world := Node3D.new()
 root.add_child(world)
 var f := Fighter.new()
 f.player_index=2
 var opponent := Fighter.new()
 opponent.player_index=1
 opponent.use_external_input=true
 world.add_child(f)
 world.add_child(opponent)
 f.opponent=opponent
 opponent.opponent=f
 f.position=Vector3(-1.5,0,0)
 opponent.position=Vector3(1.5,0,0)
 await tick()
 Input.parse_input_event(key(KEY_KP_1,true))
 await tick()
 check(f.current_state==Fighter.State.STRIKING,"Numpad 1 starts actual strike")
 check(opponent.current_state==Fighter.State.IDLE,"Other fighter stays idle")
 Input.parse_input_event(key(KEY_KP_1,false))
 await tick(32)
 Input.parse_input_event(key(KEY_KP_3,true))
 await tick()
 check(f.current_state==Fighter.State.BLOCKING,"Numpad 3 holds actual guard")
 Input.parse_input_event(key(KEY_KP_3,false))
 await tick()
 check(f.current_state==Fighter.State.IDLE and not f.input_block,"Guard releases in physics")
 f._set_state(Fighter.State.PINNED)
 Input.parse_input_event(key(KEY_KP_0,true))
 await tick(12)
 check(f.pin_escape_progress>0 and f.input_hold_pin,"Numpad 0 builds resistance")
 Input.parse_input_event(key(KEY_KP_0,false))
 await tick()
 check(not f.input_hold_pin and not f.prev_pin_held,"Resistance release is consumed")
 world.queue_free()
 await tick()

func selection_contract() -> void:
 MatchConfig.reset_defaults()
 root.content_scale_size=Vector2i(1920,1080)
 var menu := MENU.instantiate() as CharacterSelect
 silent(menu)
 root.add_child(menu)
 await tick(4)
 menu.roster_buttons[0].grab_focus()
 var old := menu.p2_index
 Input.parse_input_event(key(KEY_RIGHT,true))
 Input.parse_input_event(key(KEY_RIGHT,false))
 await tick()
 check(menu.p2_index==(old+1)%8,"Arrow changes P2 even with Button focus")
 check(menu.p1_index==0,"P2 navigation does not change P1")
 # Dispatch through the viewport's GUI pipeline, not a direct handler call.
 var target := menu.roster_buttons[5]
 var pos := target.get_global_rect().get_center()
 var mouse := InputEventMouseButton.new()
 mouse.button_index=MOUSE_BUTTON_RIGHT
 mouse.position=pos
 mouse.global_position=pos
 mouse.pressed=true
 root.push_input(mouse,true)
 mouse=mouse.duplicate()
 mouse.pressed=false
 root.push_input(mouse,true)
 await tick()
 check(menu.p2_index==5,"Right-click actually selects P2 via GUI input")
 check(menu.p1_index==0,"Right-click preserves P1 choice")
 # Rapid repeated selection updates must detach old stats before deferred frees.
 menu._update_p1_display()
 menu._update_p1_display()
 check(menu.p1_stats_container.get_child_count()==7,"Stats have 7 rows immediately after repeated updates")
 menu.queue_free()
 await tick(3)

func loading_contract() -> void:
 MatchConfig.set_match("novaonline","andy_ditch",false)
 var scene := MAIN.instantiate()
 silent(scene)
 var first: Fighter = scene.get_node("Tophiachu")
 var second: Fighter = scene.get_node("Cyraxx")
 var counts: Array[int]=[0,0]
 first.character_loaded.connect(func(_f):counts[0]+=1)
 second.character_loaded.connect(func(_f):counts[1]+=1)
 root.add_child(scene)
 await tick(4)
 check(counts==[1,1],"Chosen models initialized once per actor: "+str(counts))
 check(first.character_id=="novaonline" and second.character_id=="andy_ditch","Chosen pair loaded before child readiness")
 check(not second.is_cpu,"Human mode survives CPUController readiness")
 records.append({"initializations":counts,"p1":first.character_id,"p2":second.character_id})
 scene.queue_free()
 await tick(3)
 MatchConfig.reset_defaults()

func camera_contract() -> void:
 var world:=Node3D.new()
 var a:=Node3D.new()
 var b:=Node3D.new()
 var camera:=BroadcastCamera.new()
 root.add_child(world)
 world.add_child(a)
 world.add_child(b)
 world.add_child(camera)
 camera.target_1=a
 camera.target_2=b
 camera.set_physics_process(false)
 a.position=Vector3(-1,0,0)
 b.position=Vector3(1,0,0)
 var target:=Vector3(0,camera.base_elevation+.30,camera.base_distance+.90)
 camera.position=target
 camera.trauma=1.0
 camera.enable_shake=false
 camera._physics_process(1.0/60)
 check(camera.position.is_equal_approx(target) and is_zero_approx(camera.trauma),"Disabling shake immediately cancels residual trauma")
 camera.position=Vector3.ZERO
 camera._physics_process(1.0)
 check(camera.position.distance_to(target)<target.length() and camera.position.length()<=target.length()+.0001,"Camera easing cannot overshoot after a 1s stall")
 world.queue_free()
