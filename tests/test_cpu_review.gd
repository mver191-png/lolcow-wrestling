extends SceneTree
## Regression tests for actual controller resource use, command ownership,
## presentation-independent randomness and invalid hold cleanup.
const FIGHTER_SCENE := preload("res://scenes/fighter/fighter.tscn")
var passed := 0
var failed := 0

func _init() -> void: call_deferred("run")
func tick(count := 1) -> void:
	for i in range(count): await physics_frame
func check(ok: bool, label: String) -> void:
	if ok: passed+=1
	else: failed+=1;printerr("[FAIL] ",label)

func pair(add_cpu := true) -> Dictionary:
	var world:=Node3D.new();root.add_child(world)
	var a: Fighter=FIGHTER_SCENE.instantiate();var b: Fighter=FIGHTER_SCENE.instantiate()
	a.character_id="cyraxx";b.character_id="tophiachu"
	a.player_index=1;b.player_index=2
	a.use_external_input=true;b.use_external_input=true
	a.position=Vector3(-.55,0,0);b.position=Vector3(.55,0,0)
	world.add_child(a);world.add_child(b)
	a.presentation.process_mode=Node.PROCESS_MODE_DISABLED
	b.presentation.process_mode=Node.PROCESS_MODE_DISABLED
	var mm:=MatchManager.new();mm.fighter_1=a;mm.fighter_2=b;world.add_child(mm)
	var cpu:=CPUController.new();cpu.fighter=a
	if cpu.has_method("set_decision_seed"): cpu.call("set_decision_seed",71429)
	if add_cpu: world.add_child(cpu)
	else: cpu.free();cpu=null
	return {"world":world,"a":a,"b":b,"manager":mm,"cpu":cpu}

func cleanup(ctx: Dictionary) -> void:
	ctx.world.queue_free();await tick(2)

func run() -> void:
	await tick(2)
	await stamina_recovery()
	await commands_do_not_survive_commitment()
	await presentation_rng_does_not_change_gameplay()
	audio_does_not_consume_gameplay_rng()
	for submission in [false,true]:
		for remove_attacker in [false,true]: await invalid_hold_cleanup(submission,remove_attacker)
	print("CPU REVIEW: %d passed, %d failed"%[passed,failed])
	quit(1 if failed else 0)

func stamina_recovery() -> void:
	var ctx:=pair();var a: Fighter=ctx.a;var b: Fighter=ctx.b
	a.stamina=10.0
	b.position=Vector3(2.0,0,0)
	var max_stamina:=a.stamina
	var previous:=a.stamina
	var guards:=0
	var valid_gain:=true
	for i in range(210):
		await tick()
		max_stamina=maxf(max_stamina,a.stamina)
		valid_gain=valid_gain and a.stamina-previous<=MatchRules.STAMINA_REGEN_RATE/60.0+.0001
		previous=a.stamina
		if a.current_state==Fighter.State.BLOCKING: guards+=1
	check(max_stamina>=a.max_stamina*.40,"Exhausted CPU actually regains a reserve instead of guard-looping")
	check(guards==0,"Unthreatened exhausted CPU does not spend recovery on guard")
	check(valid_gain,"Recovery uses normal per-tick stamina regeneration, no grants")
	check(ctx.cpu.process_physics_priority<a.process_physics_priority,"CPU commands arrive before fighter updates")
	await cleanup(ctx)

func commands_do_not_survive_commitment() -> void:
	var ctx:=pair();var a: Fighter=ctx.a
	a.apply_command({"move":Vector2.RIGHT,"block":true,"finisher":true,"hold_pin":true})
	a._set_state(Fighter.State.GETTING_UP)
	await tick(3)
	check(a.input_dir==Vector2.ZERO and not a.input_block and not a.input_hold_pin,"Busy CPU receives a neutral continuous snapshot")
	check(not a.input_finisher,"Busy CPU never queues a stale finisher")
	if ctx.cpu.has_method("reset_commands"): ctx.cpu.call("reset_commands")
	check(a.input_dir==Vector2.ZERO and not a.input_block,"CPU ownership reset is neutral")
	await cleanup(ctx)

func simulation_trace(with_noise: bool, reverse_controllers: bool) -> Array:
	seed(381)
	var ctx:=pair(false)
	ctx.a.position=Vector3(-1.8,0,0);ctx.b.position=Vector3(1.8,0,0)
	var a_cpu:=CPUController.new();var b_cpu:=CPUController.new()
	a_cpu.fighter=ctx.a;b_cpu.fighter=ctx.b
	if a_cpu.has_method("set_decision_seed"):
		a_cpu.call("set_decision_seed",9331);b_cpu.call("set_decision_seed",19331)
	ctx.world.add_child(b_cpu if reverse_controllers else a_cpu)
	ctx.world.add_child(a_cpu if reverse_controllers else b_cpu)
	var trace: Array=[]
	for frame in range(600):
		if with_noise:
			for i in range(7): randf()
		await tick()
		trace.append([ctx.a.position,ctx.b.position,ctx.a.current_state,ctx.b.current_state,
			ctx.a.vitality,ctx.b.vitality,ctx.a.stamina,ctx.b.stamina,
			ctx.a.hype,ctx.b.hype,ctx.manager.current_state,ctx.manager.current_count])
	await cleanup(ctx)
	return trace

func presentation_rng_does_not_change_gameplay() -> void:
	var base:=await simulation_trace(false,false)
	var noise:=await simulation_trace(true,false)
	var order:=await simulation_trace(false,true)
	check(base==noise,"600-tick state/resource trace is unchanged by 4200 unrelated random draws")
	check(base==order,"Controller sibling ordering does not change that trace")
	check(base[0]!=base[-1],"Determinism fixture actually exercises moving/fighting actors")

func audio_does_not_consume_gameplay_rng() -> void:
	seed(4269)
	var expected:=randf()
	seed(4269)
	var audio:=AudioManager.new()
	audio._create_audio_streams()
	var actual:=randf()
	check(actual==expected,"Synthesizing audio does not advance global random state")
	audio.free()

func invalid_hold_cleanup(submission: bool, remove_attacker: bool) -> void:
	var ctx:=pair(false);var a: Fighter=ctx.a;var b: Fighter=ctx.b;var mm: MatchManager=ctx.manager
	b._set_state(Fighter.State.KNOCKED_DOWN)
	if submission: a._attempt_submission(false)
	else: a._start_pin(b)
	await tick(3)
	var survivor: Fighter=b if remove_attacker else a
	var notifications: Array[String]=[]
	mm.pin_broken.connect(func(reason):notifications.append(reason))
	if remove_attacker: a.queue_free()
	else: b.queue_free()
	await tick(5)
	check(mm.current_state==MatchManager.MatchState.IN_PROGRESS,"Invalid hold aborts match-state lock")
	check(mm.current_pinner==null and mm.current_pinned==null,"Invalid hold clears coordinator references")
	check(survivor.current_state in [Fighter.State.IDLE,Fighter.State.GETTING_UP],"Surviving wrestler is not left pinned or holding nobody")
	check(not is_instance_valid(survivor.synchronized_partner),"Surviving wrestler releases paired pointer")
	check(notifications.count("INVALID_PARTICIPANTS")==1,"Invalid hold emits one abort notification")
	await tick(50)
	check(survivor.current_state==Fighter.State.IDLE,"Surviving wrestler completes recovery normally")
	await cleanup(ctx)
