class_name CharacterSelect
extends Control

## Character Select screen for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Allows selecting any of the 8 roster characters for P1 and P2 (Human or CPU),
## displaying stats, archetypes, and movesets, before launching the match.

signal character_selected(p1_id: String, p2_id: String, p2_cpu: bool)

@export var grid_container: GridContainer
@export var p1_name_label: Label
@export var p1_title_label: Label
@export var p1_archetype_label: Label
@export var p1_stats_container: VBoxContainer
@export var p1_finisher_label: Label
@export var p1_trait_label: Label

@export var p2_name_label: Label
@export var p2_title_label: Label
@export var p2_archetype_label: Label
@export var p2_stats_container: VBoxContainer
@export var p2_finisher_label: Label
@export var p2_trait_label: Label

@export var cpu_toggle_button: Button
@export var start_match_button: Button

var character_ids: Array = []
var p1_index: int = 0
var p2_index: int = 2 # Default to Cyraxx
var p2_is_cpu: bool = true

var roster_buttons: Array[Button] = []

func _ready() -> void:
	character_ids = RosterData.get_all_ids()
	p2_is_cpu = MatchConfig.p2_is_cpu
	
	# Find current indices from MatchConfig if set
	var p1_found: int = character_ids.find(MatchConfig.p1_character_id)
	if p1_found != -1:
		p1_index = p1_found
	var p2_found: int = character_ids.find(MatchConfig.p2_character_id)
	if p2_found != -1:
		p2_index = p2_found
		
	_setup_grid()
	_update_p1_display()
	_update_p2_display()
	_update_grid_highlights()
	_update_cpu_button_text()
	
	if cpu_toggle_button and not cpu_toggle_button.pressed.is_connected(_on_cpu_toggle_pressed):
		cpu_toggle_button.pressed.connect(_on_cpu_toggle_pressed)
	if start_match_button and not start_match_button.pressed.is_connected(_start_match):
		start_match_button.pressed.connect(_start_match)

func _setup_grid() -> void:
	if not grid_container:
		return
		
	for child in grid_container.get_children():
		child.queue_free()
	roster_buttons.clear()
	
	for i in range(character_ids.size()):
		var id: String = character_ids[i]
		var data: Dictionary = RosterData.get_character(id)
		var btn: Button = Button.new()
		btn.text = data.get("name", id)
		btn.custom_minimum_size = Vector2(160, 60)
		btn.focus_mode = Control.FOCUS_ALL
		
		# Connect click
		var idx: int = i
		btn.pressed.connect(func(): _on_roster_button_clicked(idx))
		grid_container.add_child(btn)
		roster_buttons.append(btn)

func _on_roster_button_clicked(idx: int) -> void:
	# Clicking selects P1, right clicking or clicking when shift pressed selects P2
	if Input.is_key_pressed(KEY_SHIFT):
		p2_index = idx
		_update_p2_display()
	else:
		p1_index = idx
		_update_p1_display()
	_update_grid_highlights()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
		
	var num_chars: int = character_ids.size()
	if num_chars == 0:
		return
		
	# P1 controls: A / D or W / S
	if event.keycode == KEY_A:
		p1_index = (p1_index - 1 + num_chars) % num_chars
		_update_p1_display()
		_update_grid_highlights()
	elif event.keycode == KEY_D:
		p1_index = (p1_index + 1) % num_chars
		_update_p1_display()
		_update_grid_highlights()
	elif event.keycode == KEY_W:
		p1_index = (p1_index - 4 + num_chars) % num_chars
		_update_p1_display()
		_update_grid_highlights()
	elif event.keycode == KEY_S:
		p1_index = (p1_index + 4) % num_chars
		_update_p1_display()
		_update_grid_highlights()
		
	# P2 controls: Left / Right or Up / Down
	elif event.keycode == KEY_LEFT:
		p2_index = (p2_index - 1 + num_chars) % num_chars
		_update_p2_display()
		_update_grid_highlights()
	elif event.keycode == KEY_RIGHT:
		p2_index = (p2_index + 1) % num_chars
		_update_p2_display()
		_update_grid_highlights()
	elif event.keycode == KEY_UP:
		p2_index = (p2_index - 4 + num_chars) % num_chars
		_update_p2_display()
		_update_grid_highlights()
	elif event.keycode == KEY_DOWN:
		p2_index = (p2_index + 4) % num_chars
		_update_p2_display()
		_update_grid_highlights()
		
	# Toggle CPU: C
	elif event.keycode == KEY_C:
		_on_cpu_toggle_pressed()
		
	# Start match: Space or Enter
	elif event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
		_start_match()

func _on_cpu_toggle_pressed() -> void:
	p2_is_cpu = not p2_is_cpu
	MatchConfig.p2_is_cpu = p2_is_cpu
	_update_cpu_button_text()

func _update_cpu_button_text() -> void:
	if cpu_toggle_button:
		cpu_toggle_button.text = "P2 MODE: [CPU]" if p2_is_cpu else "P2 MODE: [HUMAN]"

func _update_grid_highlights() -> void:
	for i in range(roster_buttons.size()):
		var btn: Button = roster_buttons[i]
		var id: String = character_ids[i]
		var data: Dictionary = RosterData.get_character(id)
		var base_name: String = data.get("name", id)
		
		var tags: String = ""
		if i == p1_index and i == p2_index:
			tags = " [P1 & P2]"
			btn.modulate = Color(1.0, 0.9, 0.4)
		elif i == p1_index:
			tags = " [P1]"
			btn.modulate = Color(0.4, 0.8, 1.0)
		elif i == p2_index:
			tags = " [P2]"
			btn.modulate = Color(1.0, 0.4, 0.4)
		else:
			btn.modulate = Color(0.85, 0.85, 0.85)
			
		btn.text = base_name + tags

func _update_p1_display() -> void:
	if p1_index < 0 or p1_index >= character_ids.size():
		return
	var id: String = character_ids[p1_index]
	var data: Dictionary = RosterData.get_character(id)
	
	if p1_name_label:
		p1_name_label.text = data.get("name", id).to_upper()
	if p1_title_label:
		p1_title_label.text = '"' + data.get("title", "") + '"'
	if p1_archetype_label:
		p1_archetype_label.text = data.get("archetype", "")
		
	var moves: Dictionary = data.get("moves", {})
	if p1_finisher_label:
		p1_finisher_label.text = "FINISHER: " + moves.get("finisher", "N/A")
	if p1_trait_label:
		p1_trait_label.text = "TRAIT: " + moves.get("trait", "N/A")
		
	_render_stat_bars(p1_stats_container, data.get("stats", {}))

func _update_p2_display() -> void:
	if p2_index < 0 or p2_index >= character_ids.size():
		return
	var id: String = character_ids[p2_index]
	var data: Dictionary = RosterData.get_character(id)
	
	if p2_name_label:
		p2_name_label.text = data.get("name", id).to_upper()
	if p2_title_label:
		p2_title_label.text = '"' + data.get("title", "") + '"'
	if p2_archetype_label:
		p2_archetype_label.text = data.get("archetype", "")
		
	var moves: Dictionary = data.get("moves", {})
	if p2_finisher_label:
		p2_finisher_label.text = "FINISHER: " + moves.get("finisher", "N/A")
	if p2_trait_label:
		p2_trait_label.text = "TRAIT: " + moves.get("trait", "N/A")
		
	_render_stat_bars(p2_stats_container, data.get("stats", {}))

func _render_stat_bars(container: VBoxContainer, stats: Dictionary) -> void:
	if not container:
		return
	for child in container.get_children():
		child.queue_free()
		
	var stat_keys: Array = [
		["Power", "power"],
		["Mobility", "mobility"],
		["Grappling", "grappling"],
		["Stamina", "stamina"],
		["Durability", "durability"],
		["Reversal", "reversal"],
		["Showmanship", "showmanship"]
	]
	
	for pair in stat_keys:
		var stat_title: String = pair[0]
		var stat_key: String = pair[1]
		var val: int = stats.get(stat_key, 5)
		
		var row: HBoxContainer = HBoxContainer.new()
		var lbl: Label = Label.new()
		lbl.text = "%-12s %2d/10" % [stat_title, val]
		lbl.custom_minimum_size = Vector2(130, 20)
		row.add_child(lbl)
		
		var bar: ProgressBar = ProgressBar.new()
		bar.min_value = 0
		bar.max_value = 10
		bar.value = val
		bar.show_percentage = false
		bar.custom_minimum_size = Vector2(120, 16)
		bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(bar)
		
		container.add_child(row)

func _start_match() -> void:
	var p1_id: String = character_ids[p1_index]
	var p2_id: String = character_ids[p2_index]
	MatchConfig.set_match(p1_id, p2_id, p2_is_cpu)
	character_selected.emit(p1_id, p2_id, p2_is_cpu)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
