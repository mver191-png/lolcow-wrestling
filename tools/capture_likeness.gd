extends "res://tools/capture_model_quality.gd"
## Original mesh inspection only. No reference photographs are loaded or shipped.
func run() -> void:
	output = "res://evidence/likeness"
	root.content_scale_size = Vector2i.ZERO
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.size = Vector2i(960,800)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
	seed(7331)
	make_stage()
	# Neutral face study uses broad unshadowed fill; existing match-lighting checks remain separate.
	for lamp in stage.get_children():
		if lamp is DirectionalLight3D:
			lamp.shadow_enabled = false
			lamp.light_energy *= .82
	var quick := "--quick" in OS.get_cmdline_user_args()
	for id in IDS:
		if id == "referee_cobra":
			character = load("res://scenes/referee/referee.tscn").instantiate()
			stage.add_child(character)
			await tick(4)
			character.set_physics_process(false)
		else:
			var fighter: Fighter = load("res://scenes/fighter/fighter.tscn").instantiate()
			fighter.character_id = id
			fighter.use_external_input = true
			character = fighter
			stage.add_child(character)
			await tick(12)
		character.rotation.y = 0.0
		await shot(id,"face_front",true)
		if not quick:
			await shot(id,"body_front")
			character.rotation.y = -.45
			await shot(id,"face_three_quarter",true)
			character.rotation.y = -1.28
			await shot(id,"face_profile",true)
		character.queue_free()
		await tick(2)
	var file := FileAccess.open(output.path_join("capture-manifest.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify(inspection,"  "))
	print("LIKENESS CAPTURES: ",inspection.size()," rendered frames; aesthetic approval not inferred")
	quit()
