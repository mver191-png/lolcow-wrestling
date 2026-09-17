extends Node3D
## Reproducible venue presentation; the existing arena scene owns collision.
var _crowd_bodies: MultiMeshInstance3D
var _crowd_heads: MultiMeshInstance3D
var _crowd_poses: Array[Transform3D] = []
var _crowd_clock := 0.0
var _crowd_update := 0.0
var _cheer := 0.0

func _material(color: Color, roughness := 0.75, metallic := 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	return material

func _box(label: String, center: Vector3, dimensions: Vector3, material: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = label
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	node.mesh = mesh
	node.material_override = material
	node.position = center
	add_child(node)
	return node

func _beam(a: Vector3, b: Vector3, radius: float, material: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = a.distance_to(b)
	mesh.radial_segments = 12
	node.mesh = mesh
	node.material_override = material
	node.position = (a + b) * 0.5
	node.basis = Basis(Quaternion(Vector3.UP, (b - a).normalized()))
	add_child(node)
	return node

func _label(text: String, position_at: Vector3, size := 80, pixel := 0.004) -> Label3D:
	var label := Label3D.new()
	label.text = text
	label.font_size = size
	label.pixel_size = pixel
	label.outline_size = 0
	label.modulate = Color("cdbd99")
	label.position = position_at
	add_child(label)
	return label

func _ready() -> void:
	var previous := get_node_or_null("Model") as Node3D
	if previous:
		previous.hide()
	var navy := _material(Color("162336"))
	var black := _material(Color("101720"))
	var steel := _material(Color("515963"), 0.35, 0.75)
	var rope := _material(Color("a43b32"), 0.58)
	var gold := _material(Color("bfa26c"), 0.5, 0.2)
	var canvas := _material(Color("99968b"), 0.94)
	var image := Image.create(256, 256, false, Image.FORMAT_RGB8)
	for y in range(256):
		for x in range(256):
			var weave := 0.72 + 0.023 * sin(float(x) * 1.7) * sin(float(y) * 1.7)
			var wear := 0.015 * sin(float(x * 17 + y * 13))
			image.set_pixel(x, y, Color(weave + wear, weave + wear, weave * 0.94 + wear))
	canvas.albedo_texture = ImageTexture.create_from_image(image)
	canvas.uv1_scale = Vector3(5, 5, 1)
	_box("VenueFloor", Vector3(0, -1.06, 0), Vector3(34, .12, 34), black)
	_box("Platform", Vector3(0, -.5, 0), Vector3(8.15, 1, 8.15), navy)
	_box("Canvas", Vector3(0, -.013, 0), Vector3(7.6, .035, 7.6), canvas)
	for side in [-1, 1]:
		for i in range(20):
			_box("ApronPleat", Vector3(-3.8 + float(i)*.4, -.49, side*4.083), Vector3(.035, .84, .025), black)
		var apron := _label("OFFLINE MAYHEM", Vector3(0, -.40, side*4.102), 96, .006)
		apron.rotation.y = 0.0 if side == 1 else PI
	for x in [-3.8, 3.8]:
		for z in [-3.8, 3.8]:
			_beam(Vector3(x, -.94, z), Vector3(x, 1.72, z), .09, steel)
			for height in [.45, .93, 1.40]:
				var pad := _box("Turnbuckle", Vector3(x*.975, height, z*.975), Vector3(.34, .22, .17), navy)
				pad.look_at(Vector3(0, height, 0), Vector3.UP)
	for height in [.45, .93, 1.40]:
		for side in [-1, 1]:
			_beam(Vector3(-3.74, height, side*3.74), Vector3(3.74, height, side*3.74), .029, rope)
			_beam(Vector3(side*3.74, height, -3.74), Vector3(side*3.74, height, 3.74), .029, rope)
	for z in [-3.55, 3.55]:
		_box("CanvasSeam", Vector3(0, .010, z), Vector3(7.1, .002, .012), gold)
	for x in [-3.55, 3.55]:
		_box("CanvasSeam", Vector3(x, .010, 0), Vector3(.012, .002, 7.1), gold)
	var logo := _label("OFFLINE", Vector3(0, .016, -.26), 180, .007)
	logo.rotation.x = -PI/2
	logo.modulate = Color("253a50")
	var sublogo := _label("M A Y H E M", Vector3(0, .018, .48), 85, .006)
	sublogo.rotation.x = -PI/2
	sublogo.modulate = Color("8a4a3c")
	for step in range(3):
		_box("SteelSteps", Vector3(-4.55, -.83+step*.26, 2.3-step*.40), Vector3(1.05, .30, .55), steel)
	_box("TimekeeperDesk", Vector3(5.25, -.40, 2.4), Vector3(1.8, .12, .75), navy)
	for x in [4.5, 6.0]:
		_beam(Vector3(x, -1, 2.4), Vector3(x, -.4, 2.4), .04, steel)
	_box("BackWall", Vector3(0, 2.2, -11.6), Vector3(25, 6.5, .20), black)
	_box("Curtain", Vector3(0, 1.2, -11.35), Vector3(3.4, 4.4, .08), navy)
	for x in [-2.1, 2.1]:
		_box("EntryColumn", Vector3(x, 1.3, -11.1), Vector3(.16, 4.7, .18), gold)
	_box("EntryHeader", Vector3(0, 3.7, -11.1), Vector3(4.4, .16, .18), gold)
	_box("EntranceWalkway", Vector3(0, -.98, -7.7), Vector3(2.4, .12, 6.4), navy)
	_label("OFFLINE  /  MAYHEM", Vector3(0, 3.14, -10.99), 100, .008)
	_label("INTERNET RULES. RING CONSEQUENCES.", Vector3(0, 2.65, -10.98), 34, .006)
	for side in [-1, 1]:
		for z in [-5.7, 0.0, 5.7]:
			_beam(Vector3(side*6.3, -1, z), Vector3(side*6.3, .1, z), .028, steel)
		_beam(Vector3(side*6.3, .05, -5.7), Vector3(side*6.3, .05, 5.7), .04, steel)
	for z in [-4.8, 4.8]:
		_beam(Vector3(-6, 5.0, z), Vector3(6, 5.0, z), .05, steel)
		_beam(Vector3(-6, 5.30, z), Vector3(6, 5.30, z), .05, steel)
		for x in range(-6, 6):
			_beam(Vector3(x, 5.0, z), Vector3(x+1, 5.30, z), .025, steel)
		for x in [-4, 0, 4]:
			_box("LightingCan", Vector3(x, 4.82, z), Vector3(.30, .32, .40), black)
	_build_crowd(navy)
	_connect_match.call_deferred()

func _connect_match() -> void:
	var manager := MatchManager.instance
	if not is_instance_valid(manager):
		return
	manager.pin_count_ticked.connect(func(_count): _cheer = 1.0)
	manager.match_ended.connect(func(_winner, _method): _cheer = 1.0)

func _build_crowd(seat_material: Material) -> void:
	var head_mesh := SphereMesh.new()
	head_mesh.radius = .115
	head_mesh.height = .25
	head_mesh.radial_segments = 8
	head_mesh.rings = 5
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = .18
	body_mesh.height = .55
	body_mesh.radial_segments = 8
	body_mesh.rings = 3
	var bodies := MultiMesh.new()
	bodies.transform_format = MultiMesh.TRANSFORM_3D
	bodies.use_colors = true
	bodies.mesh = body_mesh
	var heads := MultiMesh.new()
	heads.transform_format = MultiMesh.TRANSFORM_3D
	heads.use_colors = true
	heads.mesh = head_mesh
	var positions: Array[Vector3] = []
	for side in [-1, 1]:
		for row in range(3):
			for seat in range(12):
				positions.append(Vector3(side*(7.15+row*.80), -.48+row*.27, -5.0+seat*.82))
	for row in range(3):
		for seat in range(18):
			var x := -7.65+seat*.9
			if absf(x)>2.3:
				positions.append(Vector3(x, -.48+row*.27, -7.25-row*.83))
	bodies.instance_count = positions.size()
	heads.instance_count = positions.size()
	var palette := [Color("324c65"), Color("7a5943"), Color("6b3041"), Color("7d7b61"), Color("252931")]
	for i in range(positions.size()):
		var transform_at := Transform3D(Basis.IDENTITY, positions[i])
		bodies.set_instance_transform(i, transform_at)
		bodies.set_instance_color(i, palette[i%palette.size()])
		_crowd_poses.append(transform_at)
		transform_at.origin.y += .39
		heads.set_instance_transform(i, transform_at)
		heads.set_instance_color(i, Color(.43+.035*(i%5), .28+.028*(i%5), .20+.02*(i%5)))
		_box("Seat", positions[i]+Vector3(0, -.31, 0), Vector3(.43, .10, .43), seat_material)
	var material := _material(Color.WHITE)
	material.vertex_color_use_as_albedo = true
	_crowd_bodies = MultiMeshInstance3D.new()
	_crowd_bodies.multimesh = bodies
	_crowd_bodies.material_override = material
	add_child(_crowd_bodies)
	_crowd_heads = MultiMeshInstance3D.new()
	_crowd_heads.multimesh = heads
	_crowd_heads.material_override = material
	add_child(_crowd_heads)

func _process(delta: float) -> void:
	_crowd_clock += delta
	_crowd_update += delta
	_cheer = maxf(0.0, _cheer-delta*.25)
	if _crowd_update < .1 or not is_instance_valid(_crowd_bodies):
		return
	_crowd_update = 0.0
	for i in range(_crowd_poses.size()):
		var transform_at := _crowd_poses[i]
		transform_at.origin.y += (.005 + .07*_cheer)*sin(_crowd_clock*(2.0+float(i%3)*.3)+float(i)*1.7)
		_crowd_bodies.multimesh.set_instance_transform(i, transform_at)
		transform_at.origin.y += .39
		_crowd_heads.multimesh.set_instance_transform(i, transform_at)
