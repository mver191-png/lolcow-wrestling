extends SceneTree
## Runtime geometry checks. Run after import with --headless --fixed-fps 60.
const SCENE = preload("res://scenes/fighter/fighter.tscn")
const IK = preload("res://scripts/fighter/contact_ik.gd")
var passed := 0
var failed := 0
var evidence: Array[Dictionary] = []

func _init() -> void:
	call_deferred("run")

func check(ok: bool, label: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		printerr("[FAIL] ", label)

func tick(n := 1) -> void:
	# At the next signal the preceding physics step, including priority 30
	# contact correction, has completed. Assertions never assume pre-step work.
	for i in range(n): await physics_frame

func setup_fighter(id: String) -> Fighter:
	var f: Fighter = SCENE.instantiate()
	f.character_id = id
	f.use_external_input = true
	root.add_child(f)
	f.presentation.authored_motion_enabled = false
	f.presentation.clearance.enabled = false
	return f

func run() -> void:
	await tick(2)
	await solver_contract()
	for id in RosterData.get_all_ids():
		for yaw in [0.0, 1.1]:
			await recovery_contract(id, yaw)
	await toggle_contract()
	await referee_count_contract()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://evidence"))
	var out := FileAccess.open("res://evidence/recovery-acceptance.json",FileAccess.WRITE)
	if out: out.store_string(JSON.stringify(evidence,"  "))
	print("CONTACT ACCEPTANCE: %d passed, %d failed"%[passed,failed])
	quit(1 if failed else 0)

func solver_contract() -> void:
	var f := setup_fighter("tophiachu")
	await tick(2)
	var s: Skeleton3D = f.presentation.skeleton
	var u := s.find_bone("UpperArm.L")
	var m := s.find_bone("Forearm.L")
	var e := s.find_bone("Hand.L")
	var old_u := s.get_bone_pose_rotation(u)
	var old_m := s.get_bone_pose_rotation(m)
	var result := IK.solve(s,u,m,e,Vector3(3,4,5),Vector3.UP,0.0)
	check(result.valid,"Zero weight accepts a valid chain")
	check(s.get_bone_pose_rotation(u).is_equal_approx(old_u) and s.get_bone_pose_rotation(m).is_equal_approx(old_m),"Zero weight does not move the elbow")
	check(not IK.solve(s,u,m,999,Vector3.ZERO,Vector3.UP).valid,"Out-of-range chain is rejected")
	check(not IK.solve(s,m,u,e,Vector3.ZERO,Vector3.UP).valid,"Non-hierarchical chain is rejected")
	check(not IK.solve(s,u,m,e,Vector3.ZERO,Vector3(NAN,0,0)).valid,"NaN pole is rejected")
	check(not IK.solve(s,u,m,e,Vector3.ZERO,Vector3.UP,NAN).valid,"NaN weight is rejected")
	f.queue_free()
	await tick(2)

func recovery_contract(id: String, yaw: float) -> void:
	var f := setup_fighter(id)
	f.rotation.y = yaw
	await tick(2)
	f._set_state(Fighter.State.KNOCKED_DOWN)
	await tick(40)
	var start := f.global_transform
	var s: Skeleton3D = f.presentation.skeleton
	var lengths: Dictionary = {}
	for name in ["Forearm.L","Forearm.R","Hand.L","Hand.R","Shin.L","Shin.R","Foot.L","Foot.R"]:
		lengths[name] = s.get_bone_pose_position(s.find_bone(name)).length()
	f._set_state(Fighter.State.GETTING_UP)
	var max_palm := 0.0
	var max_foot := 0.0
	var palms := 0
	var feet := 0
	var anchors: Dictionary = {}
	var drift := 0.0
	var intact := true
	var finite := true
	for frame in range(37):
		await tick()
		for name in lengths:
			var index := s.find_bone(name)
			intact = intact and absf(s.get_bone_pose_position(index).length()-lengths[name]) < .00002
		for d in f.presentation.contact.diagnostics:
			finite = finite and d.actual.is_finite() and d.target.is_finite()
			if not d.kind.begins_with("recovery") or d.weight < .999: continue
			var key: String = d.kind+d.side
			if key in anchors: drift = maxf(drift,anchors[key].distance_to(d.target))
			else: anchors[key] = d.target
			if d.kind=="recovery_palm":
				palms += 1
				max_palm = maxf(max_palm,d.error)
			else:
				feet += 1
				max_foot = maxf(max_foot,d.error)
	check(palms>0 and max_palm<.025,"%s loaded recovery palm within 2.5cm (%.4f)"%[id,max_palm])
	check(feet>0 and max_foot<.025,"%s planted recovery ankles within 2.5cm (%.4f)"%[id,max_foot])
	check(drift<.00001,"%s support anchors are fixed in world space"%id)
	check(intact and finite,"%s finite rotations with unchanged limb lengths"%id)
	check(f.global_transform.is_equal_approx(start),"%s recovery does not move gameplay root"%id)
	await tick(3)
	check(f.current_state==Fighter.State.IDLE,"%s original recovery duration is preserved"%id)
	check(f.presentation.contact.recovery.anchors.is_empty(),"%s anchors released in IDLE"%id)
	check(f.presentation.model.transform.is_equal_approx(Transform3D.IDENTITY),"%s no accumulated model correction"%id)
	evidence.append({"id":id,"yaw":yaw,"palm_samples":palms,"ankle_samples":feet,"max_palm_error_m":max_palm,"max_ankle_error_m":max_foot,"max_anchor_drift_m":drift})
	f.queue_free()
	await tick(2)

func toggle_contract() -> void:
	var a := setup_fighter("tophiachu")
	var b := setup_fighter("cyraxx")
	a.opponent=b
	b.opponent=a
	b.position=Vector3(0,0,.5)
	await tick(2)
	b._set_state(Fighter.State.KNOCKED_DOWN)
	await tick(40)
	a._start_pin(b)
	await tick(20)
	a.presentation.contact.enabled=false
	a.break_pin_rope_break()
	b.break_pin_rope_break()
	await tick(16)
	check(a.presentation.model.transform.is_equal_approx(Transform3D.IDENTITY),"Disabling contact during cover cannot retain exit offsets")
	check(a.presentation.contact.diagnostics.is_empty(),"Disabled contact has no stale diagnostics")
	a.queue_free()
	b.queue_free()
	await tick(2)

func referee_count_contract() -> void:
	var world := Node3D.new()
	root.add_child(world)
	var a: Fighter = SCENE.instantiate()
	var b: Fighter = SCENE.instantiate()
	a.use_external_input=true
	b.use_external_input=true
	world.add_child(a)
	world.add_child(b)
	var r: Referee=load("res://scenes/referee/referee.tscn").instantiate()
	world.add_child(r)
	var mm := MatchManager.new()
	mm.fighter_1=a
	mm.fighter_2=b
	mm.referee=r
	world.add_child(mm)
	await tick(2)
	b._set_state(Fighter.State.KNOCKED_DOWN)
	await tick(40)
	a._start_pin(b)
	var ended: Array[int]=[0]
	mm.match_ended.connect(func(_w,_m): ended[0]+=1)
	var last_count:=0
	var count_contacts:=0
	for frame in range(205):
		await tick()
		if mm.current_count>last_count:
			last_count=mm.current_count
			var resolved:=false
			for d in r.hand_contacts:
				if d.side=="R": resolved=d.actual.y<.05 and d.error<.015
			check(resolved,"Official count %d has right-hand mat contact"%last_count)
			count_contacts+=1
	check(count_contacts==3,"All three official counts sampled")
	check(ended[0]==1 and mm.current_state==MatchManager.MatchState.MATCH_OVER,"Referee contact hold leaves terminal outcome unchanged")
	await tick(12)
	check(r.hand_contacts.is_empty(),"Final slap releases to winner gesture")
	world.queue_free()
	await tick(2)
