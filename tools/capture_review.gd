extends SceneTree

## Deterministic actual-engine captures. Run with a rendering driver, not --headless.
var out := "res://evidence"
func _init() -> void:
	call_deferred("run")

func frames(count: int) -> void:
	for i in range(count):
		await physics_frame
		await process_frame

func shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	var result := image.save_png(out.path_join(name + ".png"))
	print("CAPTURE ", name, " ", result)

func run() -> void:
	seed(1776)
	root.size = Vector2i(960, 540)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out))
	var selection: Node = load("res://scenes/ui/character_select.tscn").instantiate()
	root.add_child(selection)
	await frames(12)
	await shot("character-select")
	root.remove_child(selection)
	selection.queue_free()
	await frames(2)
	var match_scene: Node3D = load("res://scenes/main.tscn").instantiate()
	root.add_child(match_scene)
	var a: Fighter = match_scene.get_node("Tophiachu")
	var b: Fighter = match_scene.get_node("Cyraxx")
	match_scene.get_node("CPUController_P2").set_physics_process(false)
	a.use_external_input = true
	b.use_external_input = true
	a.clear_inputs()
	b.clear_inputs()
	a.position = Vector3(-1.3, 0, 0)
	b.position = Vector3(1.3, 0, 0)
	await frames(30)
	await shot("overhaul-match")
	var camera: Camera3D = match_scene.get_node("BroadcastCamera")
	camera.set_physics_process(false)
	camera.global_position = a.global_position + Vector3(1.4, 1.40, -2.9)
	camera.look_at(a.global_position + Vector3(0, 1.04, 0), Vector3.UP)
	a.rotation.y = 0
	b.position.x = 3.0
	a.set_physics_process(false)
	await frames(4)
	await shot("tophiachu-detail")
	a.set_physics_process(true)
	camera.global_position = Vector3(4.8, 3.5, 6.2)
	camera.look_at(Vector3(0, .8, 0), Vector3.UP)
	a.position = Vector3(-.55, 0, 0)
	b.position = Vector3(.55, 0, 0)
	a._start_synchronized_throw(b)
	for i in range(70):
		await frames(1)
		if i in [0, 15, 30, 36, 48, 67]:
			await shot("throw-%02d" % i)
	quit()
