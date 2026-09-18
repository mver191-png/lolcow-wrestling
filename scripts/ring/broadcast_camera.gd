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
@export var action_framing: bool = true
@export var minimum_action_distance: float = 5.6
@export_range(0.05, 0.25) var screen_margin: float = 0.14
var _focus := Vector3.ZERO
var _frame_distance := 5.6
var _framing_initialized := false

static var instance: BroadcastCamera

var trauma: float = 0.0
var trauma_decay: float = 2.8
var shake_time: float = 0.0

func _ready() -> void:
	instance = self
	process_physics_priority = 50 # After pose, contact and full-mesh clearance.

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
		
	if action_framing and target_1 is Fighter and target_2 is Fighter:
		_frame_action(delta)
		return
	_framing_initialized = false
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

func _actor_bounds(actor: Fighter) -> AABB:
	if actor.presentation != null and actor.presentation.clearance != null:
		var bounds: AABB = actor.presentation.clearance.after
		if bounds.size.length_squared() > .01 and bounds.position.is_finite():
			return bounds
	# Conservative startup fallback before the first skinned-bound pass.
	return AABB(actor.global_position+Vector3(-.7,0,-.6),Vector3(1.4,2.1,1.2))

func _frame_action(delta: float) -> void:
	var bounds := _actor_bounds(target_1).merge(_actor_bounds(target_2))
	var center := bounds.get_center()
	var smoothing := 1.0-exp(-maxf(0.0,smooth_speed)*maxf(0.0,delta))
	if not _framing_initialized:
		_focus = center
		_frame_distance = minimum_action_distance
		_framing_initialized = true
	else:
		_focus = _focus.lerp(center,smoothing)
	# Fixed broadcast side: no orbit/cut during a reversal or paired action.
	var view_axis := Vector3(.80,.60,1.0).normalized()
	var orientation := Basis.looking_at(-view_axis,Vector3.UP)
	var rect := get_viewport().get_visible_rect()
	var aspect := maxf(.1,rect.size.x/maxf(rect.size.y,1.0))
	var tangent := tan(deg_to_rad(fov)*.5)
	var tan_x := tangent*aspect if keep_aspect==Camera3D.KEEP_HEIGHT else tangent
	var tan_y := tangent if keep_aspect==Camera3D.KEEP_HEIGHT else tangent/aspect
	var safe := 1.0-2.0*screen_margin
	var required := minimum_action_distance
	# Fit all eight corners against the *smoothed* focus. This prevents tracking
	# lag from cutting off a lifted head, a downed body or a separated wrestler.
	for i in range(8):
		var offset := bounds.get_endpoint(i)-_focus
		var depth := offset.dot(view_axis)
		required=maxf(required,depth+absf(offset.dot(orientation.x))/maxf(tan_x*safe,.01))
		required=maxf(required,depth+absf(offset.dot(orientation.y))/maxf(tan_y*safe,.01))
	# Pull back immediately when safety needs it; close in gradually to avoid
	# zoom pumping with every individual strike or body-contact correction.
	if required>_frame_distance:
		_frame_distance=required
	else:
		_frame_distance=lerpf(_frame_distance,required,1.0-exp(-1.8*maxf(0.0,delta)))
	global_position=_focus+view_axis*_frame_distance
	if not enable_shake:
		trauma=0.0
	elif trauma>0.0:
		trauma=maxf(0.0,trauma-trauma_decay*delta)
		shake_time+=delta*30.0
		global_position+=orientation.x*(sin(shake_time*1.3)*.12*trauma*trauma)
		global_position+=orientation.y*(cos(shake_time*1.7)*.08*trauma*trauma)
	look_at(_focus,Vector3.UP)
