class_name MainScene
extends Node3D

## Main scene controller for match initialization and mode toggles.

@export var fighter_1: Fighter
@export var fighter_2: Fighter
@export var cpu_controller_p2: CPUController
@export var match_manager: MatchManager

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_cpu"):
		if cpu_controller_p2 and fighter_2:
			fighter_2.is_cpu = not fighter_2.is_cpu
			cpu_controller_p2.set_physics_process(fighter_2.is_cpu)
			print("CPU P2 Toggled: ", fighter_2.is_cpu)
