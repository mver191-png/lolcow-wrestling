extends SceneTree
## Reproducible real-engine comparison. -- --baseline disables only contact correction.
var output := "res://evidence/contact"
var baseline := false
func _init() -> void: call_deferred("run")
func frames(count: int) -> void:
	for i in range(count):
		await physics_frame
		await process_frame
func shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	var error := image.save_png(output.path_join(name+".png"))
	if error != OK: push_error("Capture failed: "+name)
func run() -> void:
	baseline = "--baseline" in OS.get_cmdline_user_args()
	output += "-before" if baseline else "-after"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
	root.size = Vector2i(1280,720)
	seed(901)
	var match_scene: Node3D = load("res://scenes/main.tscn").instantiate()
	root.add_child(match_scene)
	var a: Fighter = match_scene.get_node("Tophiachu")
	var b: Fighter = match_scene.get_node("Cyraxx")
	var manager: MatchManager = match_scene.get_node("MatchManager")
	var camera: Camera3D = match_scene.get_node("BroadcastCamera")
	var referee: Referee = match_scene.get_node("Referee")
	match_scene.get_node("CPUController_P2").set_physics_process(false)
	a.use_external_input = true
	b.use_external_input = true
	a.clear_inputs()
	b.clear_inputs()
	a.presentation.contact.enabled = not baseline
	b.presentation.contact.enabled = not baseline
	camera.set_physics_process(false)
	camera.global_position = Vector3(3.5,2.8,4.3)
	camera.look_at(Vector3(.25,.9,0),Vector3.UP)
	referee.position = Vector3(-2.3,0,-2.3)
	referee.set_physics_process(false)
	a.position=Vector3(-.55,0,0)
	b.position=Vector3(.55,0,0)
	await frames(20)
	a._start_synchronized_throw(b)
	for i in range(72):
		await frames(1)
		if i in [7,15,24,37,69]: await shot("throw-%02d"%i)
	a._start_pin(b)
	for i in range(30):
		await frames(1)
		if i in [0,6,15,29]: await shot("cover-%02d"%i)
	b.pin_escape_progress=101
	await frames(10)
	await shot("kickout-transition")
	await frames(40)
	a.position=Vector3(-.5,0,0)
	b.position=Vector3(.5,0,0)
	b._set_state(Fighter.State.KNOCKED_DOWN)
	await frames(42)
	a._attempt_submission(false)
	await frames(20)
	await shot("wrist-control")
	b.pin_escape_progress=101
	await frames(45)
	await shot("recovered")
	if not baseline:
		a.position=Vector3(-.55,0,0)
		b.position=Vector3(.55,0,0)
		b._set_state(Fighter.State.KNOCKED_DOWN)
		await frames(42)
		a._start_pin(b)
		referee.set_physics_process(true)
		for i in range(134):
			await frames(1)
			if i in [60,65,88,131]: await shot("referee-%03d"%i)
	print("CAPTURED ",output)
	quit()
