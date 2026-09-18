class_name PresentationClearance
extends Node
## Final cosmetic pass. Influence-group bounds enclose the CPU-skinned mesh.
## Held actors receive ONE shared translation so grips cannot be torn apart.
## This is a canvas/rope-envelope guard, not opponent collision or rope physics.
const SURFACE = preload("res://scripts/fighter/skinned_surface.gd")
const ROPE_ENVELOPE := 3.75 # Ropes at +/-3.8 m; leave a 5 cm safety margin.
const FLOOR_MARGIN := .008
const MAX_LIFT := .30
const MAX_HORIZONTAL := 1.20
const RELEASE_SPEED := 1.50
var presentation: Node
var surface: RefCounted
var enabled := true
var correction := Vector3.ZERO
var before := AABB()
var after := AABB()
var residual_floor := 0.0
var residual_rope := 0.0
var limited := false
var _configured_model: Node3D

func setup(owner_presentation: Node) -> void:
 presentation = owner_presentation
 process_physics_priority = 40

func reset() -> void:
 correction = Vector3.ZERO
 residual_floor = 0.0
 residual_rope = 0.0
 limited = false
 surface = null
 _configured_model = presentation.model
 if presentation.has_skeletal_rig:
  surface = SURFACE.new()
  surface.setup(presentation.model, presentation.skeleton)
  surface.prepare_bounds()

func _partner(f: Fighter) -> Fighter:
 if f.current_state in [Fighter.State.GRAPPLING_ATTACKER, Fighter.State.GRAPPLING_DEFENDER,
   Fighter.State.SUBMISSION_ATTACKER, Fighter.State.SUBMISSION_DEFENDER]:
  return f.synchronized_partner
 if f.current_state in [Fighter.State.PINNING, Fighter.State.PINNED]: return f.opponent
 return null

func _paired(a: Fighter, b: Fighter) -> bool:
 if not is_instance_valid(b) or not b.is_inside_tree() or b.presentation == null: return false
 if not b.presentation.has_skeletal_rig or b.presentation.clearance == null: return false
 if not b.presentation.clearance.enabled: return false
 return (a.current_state == Fighter.State.GRAPPLING_ATTACKER and b.current_state == Fighter.State.GRAPPLING_DEFENDER) \
  or (a.current_state == Fighter.State.SUBMISSION_ATTACKER and b.current_state == Fighter.State.SUBMISSION_DEFENDER) \
  or (a.current_state == Fighter.State.PINNING and b.current_state == Fighter.State.PINNED)

func _physics_process(delta: float) -> void:
 if not enabled or not presentation.has_skeletal_rig: return
 if surface == null or _configured_model != presentation.model: reset()
 if surface == null or surface.vertex_count == 0: return
 var f: Fighter = presentation.fighter
 if not is_instance_valid(f) or not f.is_inside_tree(): return
 var other := _partner(f)
 # The active attacker coordinates the pair regardless of slot/insertion order.
 if is_instance_valid(other) and _paired(other, f): return
 var stages: Array[Node] = [self]
 if _paired(f, other):
  var stage: Node = other.presentation.clearance
  if stage.surface == null: stage.reset()
  if stage.surface != null: stages.append(stage)
 var merged: AABB = surface.conservative_bounds()
 before = merged
 for i in range(1, stages.size()):
  var stage: Node = stages[i]
  stage.before = stage.surface.conservative_bounds()
  merged = merged.merge(stage.before)
 # Plane bounds are evaluated in world space, not from fighter-origin clamps.
 var min_shift := Vector3(-ROPE_ENVELOPE-merged.position.x, maxf(0.0,FLOOR_MARGIN-merged.position.y), -ROPE_ENVELOPE-merged.position.z)
 var max_shift := Vector3(ROPE_ENVELOPE-merged.end.x, MAX_LIFT, ROPE_ENVELOPE-merged.end.z)
 var previous := correction
 # Releasing an offset is eased, but safety constraints take priority over easing.
 var wanted := previous.move_toward(Vector3.ZERO, RELEASE_SPEED*delta)
 wanted.x = _interval(wanted.x, min_shift.x, max_shift.x)
 wanted.z = _interval(wanted.z, min_shift.z, max_shift.z)
 wanted.y = maxf(wanted.y, min_shift.y)
 var applied := Vector3(clampf(wanted.x,-MAX_HORIZONTAL,MAX_HORIZONTAL),clampf(wanted.y,0.0,MAX_LIFT),clampf(wanted.z,-MAX_HORIZONTAL,MAX_HORIZONTAL))
 for stage in stages:
  stage._apply(applied, not applied.is_equal_approx(wanted))

static func _interval(value: float, low: float, high: float) -> float:
 # An action too large to fit is centered and explicitly reported, never scaled.
 return clampf(value,low,high) if low <= high else (low+high)*.5

func _apply(offset: Vector3, clipped: bool) -> void:
 correction = offset
 limited = clipped
 presentation.model.global_position += offset
 after = AABB(before.position+offset, before.size)
 residual_floor = maxf(0.0, FLOOR_MARGIN-after.position.y)
 residual_rope = maxf(0.0,maxf(maxf(absf(after.position.x),absf(after.end.x)),maxf(absf(after.position.z),absf(after.end.z)))-ROPE_ENVELOPE)
 limited = limited or residual_floor > .0001 or residual_rope > .0001
 # Keep diagnostics honest: partner-attached targets move with the pair, static
 # floor targets do not. These values describe the final, rendered pose.
 for d in presentation.contact.diagnostics:
  if d.has("actual"):
   d.actual += offset
   if d.kind in ["throw_cradle","pin_cover","wrist_control"]: d.target += offset
   d.error = d.actual.distance_to(d.target)
   d.clearance_offset = offset
 for d in presentation.polish.diagnostics:
  if d.has("actual"):
   d.actual += offset
   if d.kind == "getup_hand": d.target += offset # Target is the actor's thigh.
   d.error = d.actual.distance_to(d.target)
   d.clearance_offset = offset
