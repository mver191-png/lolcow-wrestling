extends SubViewportContainer
## Selection preview uses the same imported model as the match.
var viewport: SubViewport
var world_root: Node3D
var camera: Camera3D
var model: Node3D
var animation: AnimationPlayer
var current_id := ""
var clock := 0.0

func _ready() -> void:
	custom_minimum_size = Vector2(220, 340)
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
	camera = Camera3D.new()
	world_root.add_child(camera)
	camera.position = Vector3(.35, 1.45, -2.55)
	camera.look_at(Vector3(0, 1.26, 0), Vector3.UP)
	camera.fov = 32
	camera.current = true
	var environment := WorldEnvironment.new()
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color(.65, .72, .82)
	environment.environment.ambient_light_energy = .5
	world_root.add_child(environment)
	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-25, 150, 0)
	key.light_color = Color(1, .96, .91)
	key.light_energy = .85
	world_root.add_child(key)
	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(-30, -25, 0)
	fill.light_color = Color(.83, .90, 1.0)
	fill.light_energy = .40
	world_root.add_child(fill)

func _find_animation(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer: return node
	for child in node.get_children():
		var found := _find_animation(child)
		if found: return found
	return null

func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var result := _find_skeleton(child)
		if result:
			return result
	return null

func show_character(id: String) -> void:
	if id == current_id or world_root == null: return
	if is_instance_valid(model):
		world_root.remove_child(model)
		model.queue_free()
	animation = null
	current_id = id
	clock = 0.0
	var path := "res://assets/models/%s.glb" % id
	if not ResourceLoader.exists(path):
		current_id = ""
		return
	var packed := load(path) as PackedScene
	if packed == null: return
	model = packed.instantiate() as Node3D
	world_root.add_child(model)
	# A readable upper-body view, scaled from the same imported rig used in play.
	# It does not alter the model, rig or animation; full-body render tests remain.
	var rig := _find_skeleton(model)
	var body_scale := 1.0
	if rig:
		var hips := rig.find_bone("Hips")
		if hips >= 0:
			body_scale = maxf(.5, rig.get_bone_global_rest(hips).origin.y / .89)
	camera.position = Vector3(.35, 1.45, -2.55) * body_scale
	camera.look_at(Vector3(0, 1.26, 0) * body_scale, Vector3.UP)
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
