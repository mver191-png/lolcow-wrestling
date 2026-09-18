extends SceneTree
## Load scripts and scene dependencies without instantiating the game or playing
## audio. Import alone does not guarantee that non-class scripts were compiled.
var failures: Array[String] = []
func _init() -> void: call_deferred("run")
func walk(folder: String) -> Array[String]:
	var result: Array[String] = []
	var directory := DirAccess.open(folder)
	if directory == null: return result
	for filename in directory.get_files():
		if filename.ends_with(".gd") or filename.ends_with(".tscn"):
			result.append(folder.path_join(filename))
	for child in directory.get_directories():
		if not child.begins_with("."): result.append_array(walk(folder.path_join(child)))
	return result
func check_resource(path: String) -> void:
	var resource := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	if resource == null:
		failures.append("Cannot load: " + path)
	elif resource is Script and not resource.can_instantiate():
		failures.append("Invalid runtime script: " + path)
	elif resource is PackedScene:
		var state: SceneState = resource.get_state()
		for node in range(state.get_node_count()):
			for property in range(state.get_node_property_count(node)):
				var value: Variant = state.get_node_property_value(node, property)
				if value is Script and not value.can_instantiate():
					failures.append("Invalid scene script: " + path)
func run() -> void:
	var paths := walk("res://scripts")
	paths.append_array(walk("res://scenes"))
	var main_scene: String = ProjectSettings.get_setting("application/run/main_scene", "")
	if main_scene.is_empty(): failures.append("No main scene configured.")
	elif not paths.has(main_scene): paths.append(main_scene)
	for path in paths: check_resource(path)
	for message in failures: push_error(message)
	print("INSTALLATION VALIDATION: %d resources, %d failures; gameplay NOT started." % [paths.size(), failures.size()])
	quit(1 if not failures.is_empty() else 0)
