class_name MainScene
extends Node3D

## Main scene controller for match initialization and mode toggles.

@export var fighter_1: Fighter
@export var fighter_2: Fighter
@export var cpu_controller_p2: CPUController
@export var match_manager: MatchManager

func _ready() -> void:
	if fighter_1:
		fighter_1.character_id = MatchConfig.p1_character_id
		fighter_1.load_character_data()
	if fighter_2:
		fighter_2.character_id = MatchConfig.p2_character_id
		fighter_2.is_cpu = MatchConfig.p2_is_cpu
		fighter_2.load_character_data()
		
	if cpu_controller_p2 and fighter_2:
		cpu_controller_p2.set_physics_process(fighter_2.is_cpu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_cpu"):
		if cpu_controller_p2 and fighter_2:
			fighter_2.clear_inputs()
			fighter_2.is_cpu = not fighter_2.is_cpu
			MatchConfig.p2_is_cpu = fighter_2.is_cpu
			cpu_controller_p2.set_physics_process(fighter_2.is_cpu)
			print("CPU P2 Toggled: ", fighter_2.is_cpu)
			
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/ui/character_select.tscn")

func _exit_tree() -> void:
	if is_instance_valid(fighter_1): fighter_1.clear_inputs()
	if is_instance_valid(fighter_2): fighter_2.clear_inputs()
