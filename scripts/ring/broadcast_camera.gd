class_name BroadcastCamera
extends Camera3D

## Elevated broadcast camera that tracks both wrestlers smoothly.

@export var target_1: Node3D
@export var target_2: Node3D
@export var base_elevation: float = 4.8
@export var base_distance: float = 9.0
@export var smooth_speed: float = 5.0

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target_1) or not is_instance_valid(target_2):
		return
		
	var pos1: Vector3 = target_1.global_position
	var pos2: Vector3 = target_2.global_position
	var midpoint: Vector3 = (pos1 + pos2) * 0.5
	var fighters_dist: float = pos1.distance_to(pos2)
	
	var desired_dist: float = clamp(base_distance + fighters_dist * 0.45, 8.5, 14.0)
	var desired_pos: Vector3 = Vector3(
		midpoint.x * 0.35, # Slight panning
		base_elevation + fighters_dist * 0.15,
		midpoint.z * 0.2 + desired_dist
	)
	
	global_position = global_position.lerp(desired_pos, smooth_speed * delta)
	
	var look_target: Vector3 = Vector3(midpoint.x, 0.9, midpoint.z)
	look_at(look_target, Vector3.UP)
