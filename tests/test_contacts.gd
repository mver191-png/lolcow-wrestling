extends SceneTree
## Contact is measured at named palm/ankle markers, not inferred from clip names.
const SCENE = preload("res://scenes/fighter/fighter.tscn")
const IK = preload("res://scripts/fighter/contact_ik.gd")
var total := 0
var failed := 0
var samples: Array = []
func _init() -> void: call_deferred("run")
func check(ok: bool, label: String) -> void:
	total += 1
	if not ok:
		failed += 1
		printerr("[FAIL] ",label)
func tick(n := 1) -> void:
	for i in range(n): await physics_frame
func pair(a_id: String, b_id: String, inverse: bool) -> Dictionary:
	var world := Node3D.new()
	root.add_child(world)
	var a: Fighter = SCENE.instantiate()
	var b: Fighter = SCENE.instantiate()
	a.character_id=a_id
	b.character_id=b_id
	a.use_external_input=true
	b.use_external_input=true
	a.player_index=2 if inverse else 1
	b.player_index=1 if inverse else 2
	a.position=Vector3(-.55,0,0)
	b.position=Vector3(.55,0,0)
	world.add_child(b if inverse else a)
	world.add_child(a if inverse else b)
	a.opponent=b
	b.opponent=a
	return {"world":world,"a":a,"b":b}
func cleanup(ctx: Dictionary) -> void:
	ctx.world.queue_free()
	await tick(2)
func lengths(s: Skeleton3D) -> Array[float]:
	var result: Array[float] = []
	for i in range(s.get_bone_count()):
		result.append(s.get_bone_pose_position(i).length())
	return result
func rigid_limbs(s: Skeleton3D, before: Array[float]) -> bool:
	for name in ["Forearm.L","Forearm.R","Hand.L","Hand.R","Shin.L","Shin.R","Foot.L","Foot.R"]:
		var index:=s.find_bone(name)
		if absf(s.get_bone_pose_position(index).length()-before[index])>.00002: return false
	return true
func run() -> void:
	await tick(2)
	await test_solver_unreachable()
	await test_matrix(false)
	await test_matrix(true)
	await test_gameplay_neutrality()
	await test_referee_contacts()
	var out:=FileAccess.open("res://evidence/contact-test-samples.json",FileAccess.WRITE)
	if out: out.store_string(JSON.stringify(samples,"  "))
	print("CONTACT RESULTS: %d passed, %d failed, %d total"%[total-failed,failed,total])
	quit(1 if failed else 0)
func test_solver_unreachable() -> void:
	var ctx:=pair("tophiachu","cyraxx",false)
	await tick(2)
	var s: Skeleton3D=ctx.a.presentation.skeleton
	var initial:=lengths(s)
	var result:=IK.solve(s,s.find_bone("UpperArm.L"),s.find_bone("Forearm.L"),s.find_bone("Hand.L"),Vector3(30,30,30),Vector3.LEFT)
	check(result.valid and result.unreachable>10,"Unreachable target is reported")
	check(rigid_limbs(s,initial),"Solver never stretches limbs to fake contact")
	check(not IK.solve(s,-1,-1,-1,Vector3.ZERO,Vector3.UP).valid,"Missing chain safely rejects")
	await cleanup(ctx)
func test_matrix(inverse: bool) -> void:
	for a_id in RosterData.get_all_ids():
		for b_id in RosterData.get_all_ids():
			var ctx:=pair(a_id,b_id,inverse)
			var a: Fighter=ctx.a
			var b: Fighter=ctx.b
			await tick(2)
			var initial:=lengths(a.presentation.skeleton)
			var impacts: Array[int]=[0]
			a.throw_impact.connect(func(_a,_b): impacts[0]+=1)
			a._attempt_grapple(false)
			var max_error:=0.0
			var observed:=0
			var no_stretch:=true
			for frame in range(87):
				await tick()
				no_stretch=no_stretch and rigid_limbs(a.presentation.skeleton,initial)
				for d in a.presentation.contact.diagnostics:
					if d.kind=="throw_cradle" and d.weight>.999:
						max_error=maxf(max_error,d.error)
						observed+=1
			check(observed>0 and max_error<.030,"Full acquisition throw palms <=3cm: %s/%s/%s"%[a_id,b_id,inverse])
			check(no_stretch,"Constant segment lengths in paired throw")
			check(impacts[0]==1 and b.current_state==Fighter.State.KNOCKED_DOWN,"Contact does not alter throw result")
			check(a.visual_root.transform.is_equal_approx(Transform3D.IDENTITY) and b.visual_root.transform.is_equal_approx(Transform3D.IDENTITY),"Gameplay visual roots unchanged")
			samples.append({"a":a_id,"b":b_id,"inverse":inverse,"kind":"throw_cradle","max_error":max_error,"samples":observed})
			a._start_pin(b)
			await tick(22)
			var palms:=0
			var ankles:=0
			for d in a.presentation.contact.diagnostics:
				if d.kind=="pin_cover":
					palms+=1
					check(d.error<.015,"Cover palm <=1.5cm")
				if d.kind=="cover_ankle":
					ankles+=1
					check(d.error<.065,"Cover ankle within bounded reach")
			check(palms==2 and ankles==2,"Cover includes hands and lower-body support")
			check(rigid_limbs(a.presentation.skeleton,initial),"No limb stretching in cover")
			a.break_pin_rope_break()
			b.break_pin_rope_break()
			await tick(14)
			check(a.presentation.model.transform.is_equal_approx(Transform3D.IDENTITY),"Cover exit offset completely clears")
			a.position=Vector3(-.5,0,0)
			b.position=Vector3(.5,0,0)
			b._set_state(Fighter.State.KNOCKED_DOWN)
			await tick(40)
			a._attempt_submission(false)
			await tick(22)
			palms=0
			max_error=0.0
			for d in a.presentation.contact.diagnostics:
				if d.kind=="wrist_control":
					palms+=1
					max_error=maxf(max_error,d.error)
			check(palms==2 and max_error<.065,"Wrist-control targets within 6.5cm, no stretching")
			samples.append({"a":a_id,"b":b_id,"inverse":inverse,"kind":"wrist_control","max_error":max_error})
			check(rigid_limbs(a.presentation.skeleton,initial),"Submission preserves segment lengths")
			a.break_submission_rope_break()
			b.break_submission_rope_break()
			await tick(14)
			check(a.presentation.contact.diagnostics.is_empty(),"Release clears contact diagnostics")
			check(a.presentation.model.transform.is_equal_approx(Transform3D.IDENTITY),"Submission exit offset clears")
			await cleanup(ctx)
func test_gameplay_neutrality() -> void:
	var traces: Array=[]
	for enabled in [false,true]:
		var ctx:=pair("tophiachu","cyraxx",false)
		ctx.a.presentation.contact.enabled=enabled
		ctx.b.presentation.contact.enabled=enabled
		await tick(2)
		ctx.a._attempt_grapple(false)
		var trace: Array=[]
		for frame in range(90):
			await tick()
			trace.append([ctx.a.position,ctx.b.position,ctx.a.current_state,ctx.b.current_state,ctx.a.stamina,ctx.b.vitality])
		traces.append(trace)
		await cleanup(ctx)
	check(traces[0]==traces[1],"Enabled/disabled contact has identical 90-frame gameplay trace")
func test_referee_contacts() -> void:
	var ref: Referee=load("res://scenes/referee/referee.tscn").instantiate()
	root.add_child(ref)
	await tick(2)
	ref.set_physics_process(false)
	ref._ap.play("ref_count",0)
	ref._ap.advance(0)
	for phase in [0.0,.25,.5,.75,.999]:
		ref._ap.seek(phase*1.1,true)
		ref.hand_contacts.clear()
		ref._count_contacts(phase)
		check(ref.hand_contacts.size()==2,"Referee has two resolved hand targets")
		for d in ref.hand_contacts:
			check(d.error<.015,"Referee palm target <=1.5cm")
			if d.side=="R" and phase in [0.0,.999]:
				check(d.actual.y<.05,"Count hand reaches mat at count boundary")
	ref.queue_free()
	await tick(2)
