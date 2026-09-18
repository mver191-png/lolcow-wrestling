extends SceneTree
## Actual Godot model inspection. Uses real Fighter scenes and deterministic
## simulation steps; posed tests are labelled and are not human-match footage.
const IDS := ["tophiachu", "cyraxx", "novaonline", "candy_rooks", "andy_ditch", "jupiter_the_hybrid", "anacondasin", "daniel_larson", "referee_cobra"]
var output := "res://evidence/model-quality"
var stage: Node3D
var camera: Camera3D
var character: Node3D
var inspection: Array[Dictionary] = []

func _init() -> void:
	call_deferred("run")

func tick(n: int) -> void:
	for i in range(n):
		await physics_frame

func light(rotation_degrees_value: Vector3, energy: float) -> void:
	var node := DirectionalLight3D.new()
	node.rotation_degrees = rotation_degrees_value
	node.light_energy = energy
	node.shadow_enabled = true
	node.directional_shadow_max_distance = 12.0
	stage.add_child(node)

func make_stage() -> void:
	stage = Node3D.new()
	root.add_child(stage)
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(.105,.122,.148)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(.75,.80,.87)
	env.ambient_light_energy = .25
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	world.environment = env
	stage.add_child(world)
	light(Vector3(-37,-35,0), .65)
	light(Vector3(-24,145,0), .30)
	light(Vector3(-65,70,0), .25)
	var floor_mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(10,10)
	floor_mesh.mesh = plane
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(.19,.22,.26)
	material.roughness = .88
	floor_mesh.material_override = material
	stage.add_child(floor_mesh)
	camera = Camera3D.new()
	camera.fov = 32.0
	camera.near = .03
	stage.add_child(camera)
	camera.make_current()
	var label := Label.new()
	label.name = "FrameLabel"
	label.position = Vector2(26,22)
	label.add_theme_font_size_override("font_size",20)
	label.modulate = Color(.91,.94,.98)
	root.add_child(label)

func shot(id: String, name: String, close := false) -> void:
	var scale: float = 1.0
	if character is Fighter:
		scale = character.presentation._body_scale
	if close:
		camera.position = Vector3(.38,1.75,-1.54)*scale
		camera.look_at(Vector3(0,1.67,0)*scale,Vector3.UP)
	else:
		camera.position = Vector3(.35,1.29,-4.45)
		camera.look_at(Vector3(0,.98,0),Vector3.UP)
	root.get_node("FrameLabel").text = "%s  /  %s\nNeutral-light engine inspection" % [id.to_upper(),name.replace("_"," ")]
	camera.force_update_transform()
	character.force_update_transform()
	await process_frame
	await process_frame
	RenderingServer.force_sync()
	RenderingServer.force_draw(false)
	var image := root.get_texture().get_image()
	# A rendered image must contain more than a background/empty viewport. This
	# guards the initial-frame regression; it does not certify artistic quality.
	var colors: Dictionary = {}
	for y in range(image.get_height()/4,image.get_height()*3/4,16):
		for x in range(image.get_width()/4,image.get_width()*3/4,16):
			colors[image.get_pixel(x,y).to_rgba32()] = true
	if colors.size() < 16:
		push_error("Blank model capture: "+id+"/"+name)
		quit(1)
		return
	var path := output.path_join(id+"-"+name+".png")
	var result := image.save_png(path)
	if result != OK:
		push_error("Could not save "+path)
		quit(1)
	var entry := {"character":id,"pose":name,"file":path,"width":image.get_width(),"height":image.get_height()}
	if character is Fighter:
		var fighter := character as Fighter
		entry["state"] = fighter.current_state
		entry["state_time"] = fighter.state_timer
		entry["clip"] = fighter.presentation.current_anim
		if name == "strike":
			var valid_action: bool = fighter.current_state == Fighter.State.STRIKING and not fighter.strike_move.is_empty() and fighter.presentation.current_anim == "strike"
			entry["active_strike_verified"] = valid_action
			if not valid_action:
				push_error("Strike capture is not an initialized gameplay action: " + id)
				quit(1)
	inspection.append(entry)

func run() -> void:
	root.content_scale_size = Vector2i(0,0)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.size = Vector2i(960,800)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
	seed(7331)
	make_stage()
	for id in IDS:
		if id == "referee_cobra":
			character = load("res://scenes/referee/referee.tscn").instantiate()
			stage.add_child(character)
			await tick(3)
			character.set_physics_process(false)
		else:
			var fighter: Fighter = load("res://scenes/fighter/fighter.tscn").instantiate()
			fighter.character_id = id
			fighter.use_external_input = true
			character = fighter
			stage.add_child(character)
			await tick(12)
		await shot(id,"front")
		character.rotation.y = -.60
		await shot(id,"three_quarter")
		await shot(id,"portrait",true)
		if character is Fighter:
			var fighter := character as Fighter
			fighter.apply_command({"strike": true})
			await tick(8)
			await shot(id,"strike")
			fighter._set_state(Fighter.State.KNOCKED_DOWN)
			await tick(42)
			fighter._set_state(Fighter.State.GETTING_UP)
			await tick(8)
			await shot(id,"supported_recovery")
			await tick(38)
			await shot(id,"recovered")
		character.queue_free()
		await tick(2)
	var manifest := FileAccess.open(output.path_join("capture-manifest.json"),FileAccess.WRITE)
	manifest.store_string(JSON.stringify(inspection,"  "))
	print("MODEL CAPTURES: ",inspection.size()," files")
	quit()
