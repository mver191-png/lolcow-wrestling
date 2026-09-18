extends SceneTree
## Unforced spectator fixture: both normal CPU controllers, fresh resources,
## official counts/outcomes. Silent software-rendered capture, not an FPS test.
var output := "res://evidence/cpu-review"
var frames: Array[Dictionary] = []
var result: Dictionary = {}

func _init() -> void: call_deferred("run")
func tick() -> void: await physics_frame

func draw(name: String) -> void:
	RenderingServer.force_sync()
	RenderingServer.force_draw(false)
	var error:=root.get_texture().get_image().save_png(output.path_join(name+".png"))
	if error!=OK: push_error("Failed to save CPU capture: "+name)

func run() -> void:
	if "--overview" in OS.get_cmdline_user_args():
		output += "-overview"
	root.size=Vector2i(1280,720)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output.path_join("frames")))
	MatchConfig.set_match("tophiachu","cyraxx",true,1931)
	var scene: Node3D=load("res://scenes/main.tscn").instantiate()
	var audio:=scene.get_node("AudioManager")
	scene.remove_child(audio);audio.free();AudioManager.instance=null
	root.add_child(scene)
	if "--overview" in OS.get_cmdline_user_args():
		scene.get_node("BroadcastCamera").action_framing=false
	var a: Fighter=scene.get_node("Tophiachu")
	var b: Fighter=scene.get_node("Cyraxx")
	var manager: MatchManager=scene.get_node("MatchManager")
	var cpu:=CPUController.new();cpu.fighter=a;scene.add_child(cpu)
	manager.match_ended.connect(func(winner,method):result.merge({"winner":winner.character_id,"method":method}))
	var counts: Array[int]=[]
	manager.pin_count_ticked.connect(func(count):counts.append(count))
	var saved:=0
	var terminal_tick:=-1
	for frame in range(3600):
		await tick()
		if frame%4==0:
			await process_frame
			draw("frames/%05d"%saved);saved+=1
			frames.append({"physics_tick":frame,"a_state":a.current_state,"b_state":b.current_state,"a_stamina":a.stamina,"b_stamina":b.stamina,"cpu_intent":cpu.think_state})
		if frame==240: draw("mid_match")
		if not result.is_empty() and terminal_tick<0:
			terminal_tick=frame
			draw("result")
		if terminal_tick>=0 and frame-terminal_tick>60: break
	var manifest:=FileAccess.open(output.path_join("capture.json"),FileAccess.WRITE)
	manifest.store_string(JSON.stringify({"match_seed":1931,"physics_hz":60,"capture_fps":15,"result":result,
		"terminal_tick":terminal_tick,"counts":counts,"forced_hp_hits_or_escape":false,
		"frames":frames},"  "))
	print("UNFORCED CAPTURE: ",saved," frames, ",JSON.stringify(result))
	scene.queue_free();await tick();await tick()
	quit(1 if result.is_empty() else 0)
