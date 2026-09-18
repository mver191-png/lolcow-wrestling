class_name BroadcastCamera
extends Camera3D

## Elevated broadcast camera that tracks both wrestlers smoothly
## with accessibility options and dynamic impact trauma shake.

@export var target_1: Node3D
@export var target_2: Node3D
@export var base_elevation: float = 4.8
@export var base_distance: float = 9.0
@export var smooth_speed: float = 5.0
@export var enable_shake: bool = true # Accessibility toggle

static var instance: BroadcastCamera

var trauma: float = 0.0
var trauma_decay: float = 2.8
var shake_time: float = 0.0

func _ready() -> void:
	instance = self

func add_trauma(amount: float) -> void:
	if enable_shake:
		trauma = clamp(trauma + amount, 0.0, 1.0)

func _physics_process(delta: float) -> void:
	if not is_inside_tree():
		if trauma > 0.0:
			trauma = max(0.0, trauma - trauma_decay * delta)
		return
		
	if not is_instance_valid(target_1) or not is_instance_valid(target_2):
		return
		
	var pos1: Vector3 = target_1.global_position
	var pos2: Vector3 = target_2.global_position
	var midpoint: Vector3 = (pos1 + pos2) * 0.5
	var fighters_dist: float = pos1.distance_to(pos2)
	
	var desired_dist: float = clamp(base_distance + fighters_dist * 0.45, 8.5, 14.0)
	var desired_pos: Vector3 = Vector3(
		midpoint.x * 0.35,
		base_elevation + fighters_dist * 0.15,
		midpoint.z * 0.2 + desired_dist
	)
	
	# Disabling accessibility shake takes effect immediately, including residual trauma.
	if not enable_shake:
		trauma = 0.0
	# Trauma shake calculation
	if enable_shake and trauma > 0.0:
		trauma = max(0.0, trauma - trauma_decay * delta)
		shake_time += delta * 30.0
		var shake_intensity: float = trauma * trauma # Quadratic curve
		var offset_x: float = sin(shake_time * 1.3) * 0.28 * shake_intensity
		var offset_y: float = cos(shake_time * 1.7) * 0.22 * shake_intensity
		desired_pos += Vector3(offset_x, offset_y, 0.0)
		
	global_position = global_position.lerp(desired_pos, 1.0 - exp(-maxf(0.0, smooth_speed) * maxf(0.0, delta)))
	
	var look_target: Vector3 = Vector3(midpoint.x, 0.9, midpoint.z)
	look_at(look_target, Vector3.UP)
