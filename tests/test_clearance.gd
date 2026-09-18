extends SceneTree
## Engine-stepped, all-vertex audit plus conservative-bound containment checks.
## Fixtures deliberately stage near-rope holds (normal rules may break those holds).
const SCENE = preload("res://scenes/fighter/fighter.tscn")
const SURFACE = preload("res://scripts/fighter/skinned_surface.gd")
const IK = preload("res://scripts/fighter/contact_ik.gd")
var total := 0
var failed := 0
var rows: Array[Dictionary] = []
var worst_floor := 0.0
var worst_rope := 0.0
var audited_vertices := 0

func _init() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
 total += 1
 if not ok:
  failed += 1
  printerr("[FAIL] ",message)
func tick(count := 1) -> void:
 for i in range(count): await physics_frame
func make_pair(a_id: String, b_id: String, inverse: bool, center: Vector3, angle: float) -> Dictionary:
 var world := Node3D.new()
 root.add_child(world)
 var a: Fighter = SCENE.instantiate()
 var b: Fighter = SCENE.instantiate()
 a.character_id = a_id
 b.character_id = b_id
 a.use_external_input = true
 b.use_external_input = true
 a.player_index = 2 if inverse else 1
 b.player_index = 1 if inverse else 2
 var axis := Basis(Vector3.UP,angle)*Vector3.RIGHT
 a.position = center-axis*.30
 b.position = center+axis*.30
 world.add_child(b if inverse else a)
 world.add_child(a if inverse else b)
 a.opponent = b
 b.opponent = a
 return {"a":a,"b":b,"world":world}
func release(ctx: Dictionary) -> void:
 ctx.world.queue_free()
 await tick(2)
func inspect(f: Fighter, phase: String, inverse: bool) -> void:
 var c: Node = f.presentation.clearance
 var points: PackedVector3Array = c.surface.world_vertices()
 var measured: Dictionary = SURFACE.measure(points)
 var box: AABB = c.surface.conservative_bounds()
 var encloses := true
 var padded := box.grow(.00005)
 for vertex in points:
  if not vertex.is_finite() or not padded.has_point(vertex):
   encloses = false
   break
 check(encloses,"Every skinned vertex is inside computed bound: %s/%s"%[f.character_id,phase])
 check(measured.vertices > 5000,"Auditing complete skinned mesh, not bone centers")
 check(not c.limited,"Correction remains within declared caps: %s/%s"%[f.character_id,phase])
 check(measured.floor_penetration < .0001,"No mesh below canvas: %s/%s, %.3fm"%[f.character_id,phase,measured.floor_penetration])
 check(measured.rope_overhang < .0001,"No mesh outside +/-3.8m envelope: %s/%s, %.3fm"%[f.character_id,phase,measured.rope_overhang])
 check(f.visual_root.transform.is_equal_approx(Transform3D.IDENTITY),"Gameplay visual root unmodified")
 audited_vertices += points.size()
 worst_floor = maxf(worst_floor, measured.floor_penetration)
 worst_rope = maxf(worst_rope, measured.rope_overhang)
 rows.append({"character":f.character_id,"phase":phase,"inverse":inverse,"vertices":points.size(),"floor":measured.floor_penetration,"rope":measured.rope_overhang,"offset":[c.correction.x,c.correction.y,c.correction.z],"groups":c.surface._groups.size()})
func run() -> void:
 await tick(2)
 await test_solver_safety()
 var ids := RosterData.get_all_ids()
 # 8 characters x 2 slot/order settings x 2 layouts. Each actor is tested as
 # attacker and defender through complete throws, covers, wrist holds and get-ups.
 for index in range(ids.size()):
  for inverse in [false,true]:
   for corner in [false,true]:
    var sign := -1.0 if index%2 == 0 else 1.0
    var center := Vector3(3.0*sign,0,2.8*sign) if corner else Vector3(0,0,3.35*sign)
    var ctx := make_pair(ids[index],ids[(index+3)%ids.size()],inverse,center,0.25 if corner else 1.2)
    var a: Fighter = ctx.a
    var b: Fighter = ctx.b
    await tick(3)
    inspect(a,"standing_edge",inverse)
    a._attempt_grapple(false)
    for frame in range(90):
     await tick()
     if frame in [19,32,50,85]:
      inspect(a,"throw_attacker_%d"%frame,inverse)
      inspect(b,"throw_defender_%d"%frame,inverse)
    check(a.current_state == Fighter.State.IDLE and b.current_state == Fighter.State.KNOCKED_DOWN,"Throw lifecycle unaffected")
    a._start_pin(b)
    await tick(22)
    inspect(a,"cover",inverse)
    inspect(b,"covered",inverse)
    check(a.presentation.clearance.correction.is_equal_approx(b.presentation.clearance.correction),"Pair receives identical correction")
    a.break_pin_rope_break()
    b.break_pin_rope_break()
    await tick(14)
    b._set_state(Fighter.State.KNOCKED_DOWN)
    await tick(42)
    b._set_state(Fighter.State.GETTING_UP)
    for frame in range(37):
     await tick()
     if frame in [1,8,15,22,30,36]: inspect(b,"recovery_%d"%frame,inverse)
    a.position = center-Vector3(.25,0,0)
    b.position = center+Vector3(.25,0,0)
    b._set_state(Fighter.State.KNOCKED_DOWN)
    await tick(42)
    a._attempt_submission(false)
    await tick(22)
    inspect(a,"wrist_control",inverse)
    inspect(b,"held_wrist",inverse)
    a.break_submission_rope_break()
    b.break_submission_rope_break()
    a.position = Vector3(-1,0,0)
    b.position = Vector3(1,0,0)
    await tick(70)
    check(a.presentation.clearance.correction.length()<.001,"Center-ring clearance offset releases without accumulating")
    await release(ctx)
 await test_gameplay_invariance()
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://evidence"))
 var file := FileAccess.open("res://evidence/clearance-samples.json",FileAccess.WRITE)
 if file: file.store_string(JSON.stringify({"samples":rows,"audited_vertices":audited_vertices,"worst_floor":worst_floor,"worst_rope":worst_rope},"  "))
 print("CLEARANCE: %d passed, %d failed, %d total; %d mesh vertex samples"%[total-failed,failed,total,audited_vertices])
 quit(1 if failed else 0)
func test_solver_safety() -> void:
 var ctx := make_pair("tophiachu","cyraxx",false,Vector3.ZERO,0.0)
 await tick(2)
 var s: Skeleton3D = ctx.a.presentation.skeleton
 var upper := s.find_bone("UpperArm.L")
 var middle := s.find_bone("Forearm.L")
 var end := s.find_bone("Hand.L")
 var elbow_translation := s.get_bone_pose_position(middle)
 var wrist_translation := s.get_bone_pose_position(end)
 var result := IK.solve(s,upper,middle,end,IK.point(s,upper),Vector3.UP,1.0,150.0)
 check(result.valid and result.joint_limited,"Excessive fold reports joint limit")
 check(result.flexion_degrees<=150.001,"Configured maximum elbow flexion respected")
 check(s.get_bone_pose_position(middle)==elbow_translation and s.get_bone_pose_position(end)==wrist_translation,"Joint limit never stretches bone offsets")
 check(not IK.solve(s,upper,end,middle,Vector3.ZERO,Vector3.UP).valid,"Reject malformed chain")
 check(not IK.solve(s,upper,middle,999,Vector3.ZERO,Vector3.UP).valid,"Reject out-of-range bone")
 await release(ctx)
func test_gameplay_invariance() -> void:
 var traces: Array = []
 for enabled in [false,true]:
  var ctx := make_pair("cyraxx","tophiachu",false,Vector3(3.0,0,2.8),.25)
  ctx.a.presentation.clearance.enabled=enabled
  ctx.b.presentation.clearance.enabled=enabled
  await tick(2)
  ctx.a._attempt_grapple(false)
  var trace: Array = []
  for frame in range(90):
   await tick()
   trace.append([ctx.a.position,ctx.b.position,ctx.a.vitality,ctx.b.vitality,ctx.a.stamina,ctx.b.stamina,ctx.a.current_state,ctx.b.current_state])
  traces.append(trace)
  await release(ctx)
 check(traces[0]==traces[1],"Clearance on/off yields identical 90-tick gameplay trace at corner")
