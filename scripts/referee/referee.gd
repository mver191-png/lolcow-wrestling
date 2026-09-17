class_name Referee
extends Node3D

## Neutral referee KingCobraJFS (1991-2025).
## Untargetable, non-colliding official featuring a permanent visible glowing halo.
## The match rules govern the authoritative count; the referee communicates it.

signal count_pulse(count_number: int)

enum RefereeState {
	IDLE,
	OBSERVING,
	RUNNING_TO_PIN,
	COUNTING_PIN,
	SIGNAL_ROPE_BREAK,
	VICTORY
}

@export var halo_node: Node3D
@export var mesh_instance: Node3D
@export var count_label_3d: Label3D

var current_state: RefereeState = RefereeState.OBSERVING
var target_fighter_1: Node3D
var target_fighter_2: Node3D
var current_count: int = 0
var halo_base_scale: Vector3 = Vector3.ONE
var halo_pulse_timer: float = 0.0
var halo_material: StandardMaterial3D

func _ready() -> void:
	if halo_node:
		halo_base_scale = halo_node.scale
		# Find halo mesh material if present
		var halo_mesh: MeshInstance3D = halo_node.get_node_or_null("HaloMesh") as MeshInstance3D
		if halo_mesh and halo_mesh.material_override:
			halo_material = halo_mesh.material_override as StandardMaterial3D
	
	if count_label_3d:
		count_label_3d.visible = false

func _process(delta: float) -> void:
	_update_halo_visuals(delta)
	
	match current_state:
		RefereeState.OBSERVING:
			_observe_match(delta)
		RefereeState.RUNNING_TO_PIN:
			pass
		RefereeState.COUNTING_PIN:
			pass
		RefereeState.SIGNAL_ROPE_BREAK:
			pass
		RefereeState.VICTORY:
			pass

func setup_targets(f1: Node3D, f2: Node3D) -> void:
	target_fighter_1 = f1
	target_fighter_2 = f2

func _observe_match(delta: float) -> void:
	if not is_instance_valid(target_fighter_1) or not is_instance_valid(target_fighter_2):
		return
	
	# Position referee on side of the action, keeping ~2.5m distance
	var midpoint: Vector3 = (target_fighter_1.global_position + target_fighter_2.global_position) * 0.5
	var perp_dir: Vector3 = (target_fighter_2.global_position - target_fighter_1.global_position).cross(Vector3.UP).normalized()
	if perp_dir.is_zero_approx():
		perp_dir = Vector3.FORWARD
	
	var desired_pos: Vector3 = midpoint + perp_dir * 2.2
	# Clamp inside ring bounds
	desired_pos.x = clamp(desired_pos.x, -2.8, 2.8)
	desired_pos.z = clamp(desired_pos.z, -2.8, 2.8)
	desired_pos.y = 0.0 # Canvas height
	
	global_position = global_position.lerp(desired_pos, 3.0 * delta)
	
	# Look towards midpoint
	var look_target: Vector3 = Vector3(midpoint.x, global_position.y, midpoint.z)
	if not global_position.is_equal_approx(look_target):
		look_at(look_target, Vector3.UP)

func on_pin_started(pin_position: Vector3) -> void:
	current_state = RefereeState.COUNTING_PIN
	current_count = 0
	
	# Move near the pinned fighters
	var offset: Vector3 = Vector3(1.2, 0.0, 0.0)
	global_position = pin_position + offset
	global_position.x = clamp(global_position.x, -3.2, 3.2)
	global_position.z = clamp(global_position.z, -3.2, 3.2)
	global_position.y = 0.0
	
	look_at(Vector3(pin_position.x, global_position.y, pin_position.z), Vector3.UP)
	
	# Drop to mat pose
	if mesh_instance:
		mesh_instance.position.y = -0.35 # Kneeling down to canvas
	
	if count_label_3d:
		count_label_3d.text = ""
		count_label_3d.visible = true

func on_pin_count(count_num: int) -> void:
	current_count = count_num
	halo_pulse_timer = 0.4
	
	if count_label_3d:
		count_label_3d.text = str(count_num) + "!"
		count_label_3d.modulate = Color(1.0, 0.85, 0.2)
	
	# Canvas slap bounce animation
	if mesh_instance:
		var tween: Tween = create_tween()
		tween.tween_property(mesh_instance, "position:y", -0.45, 0.08)
		tween.tween_property(mesh_instance, "position:y", -0.35, 0.12)
	
	count_pulse.emit(count_num)

func on_rope_break() -> void:
	current_state = RefereeState.SIGNAL_ROPE_BREAK
	if count_label_3d:
		count_label_3d.text = "ROPE BREAK!"
		count_label_3d.modulate = Color(1.0, 0.2, 0.2)
	
	# Stand up and signal
	if mesh_instance:
		mesh_instance.position.y = 0.0
	
	var tween: Tween = create_tween()
	tween.tween_interval(1.2)
	tween.tween_callback(func():
		if count_label_3d:
			count_label_3d.visible = false
		current_state = RefereeState.OBSERVING
	)

func on_pin_broken() -> void:
	if current_state == RefereeState.COUNTING_PIN:
		current_state = RefereeState.OBSERVING
		if count_label_3d:
			count_label_3d.visible = false
		if mesh_instance:
			mesh_instance.position.y = 0.0

func on_match_won(winner_position: Vector3) -> void:
	current_state = RefereeState.VICTORY
	if count_label_3d:
		count_label_3d.text = "WINNER!"
		count_label_3d.modulate = Color(0.2, 1.0, 0.4)
		count_label_3d.visible = true
	if mesh_instance:
		mesh_instance.position.y = 0.0
	look_at(Vector3(winner_position.x, global_position.y, winner_position.z), Vector3.UP)

func _update_halo_visuals(delta: float) -> void:
	if not halo_node:
		return
	
	# Constant gentle rotation
	halo_node.rotate_y(1.5 * delta)
	
	if halo_pulse_timer > 0.0:
		halo_pulse_timer -= delta
		var pulse_strength: float = clamp(halo_pulse_timer / 0.4, 0.0, 1.0)
		halo_node.scale = halo_base_scale * (1.0 + 0.45 * pulse_strength)
		if halo_material:
			halo_material.emission_energy_multiplier = 3.0 + 4.0 * pulse_strength
	else:
		halo_node.scale = halo_base_scale
		if halo_material:
			halo_material.emission_energy_multiplier = 2.5
