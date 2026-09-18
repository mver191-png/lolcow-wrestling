extends SceneTree
## Import/render contract, NOT an automated identity or realism score.
const IDS = ["tophiachu","novaonline","cyraxx","candy_rooks","andy_ditch","daniel_larson","referee_cobra","jupiter_the_hybrid","anacondasin"]
var passed := 0
var failed := 0
func _init() -> void:
	call_deferred("run")
func check(ok: bool, label: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		printerr("[FAIL] ",label)
func inspect(node: Node, results: Dictionary) -> void:
	if node is Skeleton3D:
		results["bones"] = node.get_bone_count()
	if node is AnimationPlayer:
		results["clips"] = node.get_animation_list().size()
	if node is MeshInstance3D and node.mesh:
		for i in range(node.mesh.get_surface_count()):
			var m := node.get_active_material(i) as StandardMaterial3D
			if m == null: continue
			if m.resource_name == "portrait_skin":
				results["portrait"] = true
				check(m.albedo_texture != null,"Head uses original embedded albedo")
				if m.albedo_texture:
					check(m.albedo_texture.get_width() == 512,"Expected procedural portrait texture")
				check(m.normal_enabled and m.normal_texture != null,"Original skin micro-normal imports")
				check(m.roughness_texture != null,"Original skin roughness imports")
				var tangents: PackedFloat32Array = node.mesh.surface_get_arrays(i)[Mesh.ARRAY_TANGENT]
				check(not tangents.is_empty(),"Normal mapped face has exported tangents")
			if m.resource_name == "portrait_eye":
				results["eyes"] = true
				check(m.albedo_texture != null,"Fitted sclera/iris uses original texture")
			if m.resource_name == "skin" or m.resource_name == "beard_surface":
				var colors: PackedColorArray = node.mesh.surface_get_arrays(i)[Mesh.ARRAY_COLOR]
				check(not colors.is_empty(),"Skin tint is present in imported geometry")
				check(m.vertex_color_use_as_albedo,"Imported material actually consumes tint")
			if m.resource_name == "halo": results["halos"] += 1
	for child in node.get_children(): inspect(child,results)
func run() -> void:
	for id in IDS:
		var model: Node3D=load("res://assets/models/%s.glb"%id).instantiate()
		root.add_child(model)
		await process_frame
		var results: Dictionary={"portrait":false,"bones":0,"clips":0,"halos":0,"eyes":false}
		inspect(model,results)
		check(results.bones == 46,id+" main/deformation rig retained")
		check(results.clips >= 25,id+" complete animation library retained")
		check(results.portrait == true,id+" reference coverage matches source manifest")
		check(results.eyes,id+" fitted iris aperture exists")
		check(results.halos == (1 if id=="referee_cobra" else 0),id+" correct halo count")
		model.queue_free()
		await process_frame
	print("LIKENESS IMPORT: %d passed, %d failed"%[passed,failed])
	quit(1 if failed else 0)
