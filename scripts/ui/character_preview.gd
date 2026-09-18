extends SubViewportContainer
## Selection preview uses the same imported model as the match.
var viewport: SubViewport
var world_root: Node3D
var model: Node3D
var animation: AnimationPlayer
var current_id := ""
var clock := 0.0

func _ready() -> void:
	custom_minimum_size = Vector2(220, 235)
	stretch = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	viewport = SubViewport.new()
	viewport.size = Vector2i(360, 320)
	viewport.own_world_3d = true
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
	add_child(viewport)
	world_root = Node3D.new()
	viewport.add_child(world_root)
	var camera := Camera3D.new()
	world_root.add_child(camera)
	camera.position = Vector3(1.4, 1.20, -3.1)
	camera.look_at(Vector3(0, .96, 0), Vector3.UP)
	camera.fov = 37
	camera.current = true
	var environment := WorldEnvironment.new()
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color(.65, .72, .82)
	environment.environment.ambient_light_energy = .5
	world_root.add_child(environment)
	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-40, -35, 0)
	key.light_color = Color(1, .91, .78)
	key.light_energy = .8
	world_root.add_child(key)

func _find_animation(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer: return node
	for child in node.get_children():
		var found := _find_animation(child)
		if found: return found
	return null

func show_character(id: String) -> void:
	if id == current_id or world_root == null: return
	if is_instance_valid(model):
		world_root.remove_child(model)
		model.queue_free()
	animation = null
	current_id = id
	clock = 0.0
	var packed := load("res://assets/models/%s.glb" % id) as PackedScene
	if packed == null: return
	model = packed.instantiate() as Node3D
	world_root.add_child(model)
	animation = _find_animation(model)
	if animation and animation.has_animation("idle"):
		animation.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
		animation.play("idle")
		animation.advance(0.0)

func _process(delta: float) -> void:
	if not is_visible_in_tree() or not is_instance_valid(animation) or not animation.has_animation("idle"): return
	clock += delta
	animation.seek(fposmod(clock, maxf(animation.get_animation("idle").length, .001)), true)
	model.rotation.y = .10*sin(clock*.35)
