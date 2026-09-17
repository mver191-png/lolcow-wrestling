extends SceneTree
## Actual rendered game frames. Use --disable-render-loop for inexpensive,
## deterministic offscreen capture: this script explicitly draws each saved frame.
var output := "res://evidence/contact-acceptance"
var video := false
var frame_number := 0
var baseline := false
var scene: Node3D
var a: Fighter
var b: Fighter
var mm: MatchManager
var ref: Referee

func _init() -> void: call_deferred("run")

func draw(name: String) -> void:
	RenderingServer.force_sync()
	RenderingServer.force_draw(false)
	var image := root.get_texture().get_image()
	var result := image.save_png(output.path_join(name+".png"))
	if result != OK: push_error("Capture failed: "+name)

func step(count: int, tag: String = "") -> void:
	for i in range(count):
		await physics_frame
		if video and i%2==0:
			draw("motion/%04d"%frame_number)
			frame_number+=1
		if not tag.is_empty() and i in [0, 7, 12, 18, 25, 34]: draw("%s-%02d"%[tag,i])

func stop_capture_audio(node: Node) -> void:
	# Silent visual fixtures do not leave active mixer playback at shutdown.
	if node is AudioStreamPlayer:
		node.stop()
		node.stream = null
	for child in node.get_children(): stop_capture_audio(child)

func setup_match() -> void:
	scene = load("res://scenes/main.tscn").instantiate()
	# This diagnostic is explicitly silent; avoid starting mixer playback.
	var audio := scene.get_node("AudioManager")
	scene.remove_child(audio)
	audio.free()
	AudioManager.instance = null
	root.add_child(scene)
	a=scene.get_node("Tophiachu")
	b=scene.get_node("Cyraxx")
	mm=scene.get_node("MatchManager")
	ref=scene.get_node("Referee")
	scene.get_node("CPUController_P2").set_physics_process(false)
	a.use_external_input=true
	b.use_external_input=true
	a.clear_inputs()
	b.clear_inputs()
	a.presentation.contact.recovery_enabled=not baseline
	b.presentation.contact.recovery_enabled=not baseline
	a.position=Vector3(-.55,0,0)
	b.position=Vector3(.55,0,0)
	var camera: Camera3D=scene.get_node("BroadcastCamera")
	camera.set_physics_process(false)
	camera.global_position=Vector3(3.4,2.5,3.7)
	camera.look_at(Vector3(.1,.7,0),Vector3.UP)

func run() -> void:
	baseline="--baseline" in OS.get_cmdline_user_args()
	video="--video" in OS.get_cmdline_user_args()
	output+="-before" if baseline else "-after"
	root.size=Vector2i(960,540)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output.path_join("motion")))
	seed(901)
	setup_match()
	await step(24)
	a._attempt_grapple(false)
	await step(22)
	draw("cradle-grip")
	await step(68)
	a._start_pin(b)
	await step(75)
	draw("supported-cover-count")
	b.pin_escape_progress=101
	await step(37,"recovery")
	await step(18)
	draw("ready-again")
	b._set_state(Fighter.State.KNOCKED_DOWN)
	await step(42)
	a._attempt_submission(false)
	await step(25)
	draw("wrist-control")
	b.pin_escape_progress=101
	await step(42)
	# A fresh fixture verifies the count gesture through terminal resolution.
	video=false
	stop_capture_audio(scene)
	scene.queue_free()
	await physics_frame
	await physics_frame
	setup_match()
	await step(20)
	b._set_state(Fighter.State.KNOCKED_DOWN)
	await step(42)
	a._start_pin(b)
	for i in range(202):
		await physics_frame
		if mm.current_count==3:
			draw("official-third-count")
			scene.get_node("CanvasLayer").visible = false
			draw("official-third-count-clean")
			break
	stop_capture_audio(scene)
	scene.queue_free()
	await physics_frame
	await physics_frame
	print("CAPTURED ",output," frames=",frame_number)
	quit()
