extends SceneTree
## Read-only batch study, not a balance pass/fail test. Normal Fighter scenes,
## normal CPU inputs and MatchManager rules; no injected hits, HP or escapes.
## -- --limit=16 --seed-count=1 --output=res://evidence/pacing.json
## --noise=7 consumes unrelated global random draws per tick to expose coupling.
## --visuals retains normal animation/clearance; default skips cosmetic updates.
var records: Array[Dictionary] = []
var output := "res://evidence/pacing.json"
var limit := 128
var seed_count := 2
var noise := 0
var visuals := false
const SEEDS := [1931,4019]
const SCENE := preload("res://scenes/fighter/fighter.tscn")

func _init() -> void: call_deferred("run")
func tick(count := 1) -> void:
	for i in range(count): await physics_frame

func run() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--output="): output=arg.trim_prefix("--output=")
		elif arg.begins_with("--limit="): limit=int(arg.trim_prefix("--limit="))
		elif arg.begins_with("--seed-count="): seed_count=clampi(int(arg.trim_prefix("--seed-count=")),1,2)
		elif arg.begins_with("--noise="): noise=int(arg.trim_prefix("--noise="))
		elif arg=="--visuals": visuals=true
	await tick(2)
	var ids: Array=RosterData.get_all_ids()
	# Round-robin opponent offsets keep small prefixes representative of all slots.
	for seed_index in range(seed_count):
		for offset in range(ids.size()):
			for i in range(ids.size()):
				if records.size()>=limit: break
				await study(ids[i],ids[(i+offset)%ids.size()],SEEDS[seed_index])
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output.get_base_dir()))
	var f:=FileAccess.open(output,FileAccess.WRITE)
	if f==null:
		push_error("Cannot save pacing study: "+output);quit(1);return
	f.store_string(JSON.stringify({"physics_hz":Engine.physics_ticks_per_second,
		"visuals":visuals,"unrelated_random_draws_per_tick":noise,"timeout_seconds":120,
		"note":"Batch outcomes are observations, not balance acceptance.","matches":records},"  "))
	print("PACING STUDY: ",records.size()," matches -> ",output)
	quit()

func study(a_id: String,b_id: String,match_seed: int) -> void:
	seed(match_seed)
	var world:=Node3D.new();root.add_child(world)
	var a: Fighter=SCENE.instantiate();var b: Fighter=SCENE.instantiate()
	a.character_id=a_id;b.character_id=b_id;a.player_index=1;b.player_index=2
	a.is_cpu=true;b.is_cpu=true
	a.position=Vector3(-1.8,0,0);b.position=Vector3(1.8,0,0)
	world.add_child(a);world.add_child(b)
	if not visuals:
		a.presentation.process_mode=Node.PROCESS_MODE_DISABLED
		b.presentation.process_mode=Node.PROCESS_MODE_DISABLED
	var manager:=MatchManager.new();manager.fighter_1=a;manager.fighter_2=b;world.add_child(manager)
	var c1:=CPUController.new();var c2:=CPUController.new();c1.fighter=a;c2.fighter=b
	if c1.has_method("set_decision_seed"):
		c1.set_decision_seed(match_seed*2+1);c2.set_decision_seed(match_seed*2+2)
	world.add_child(c1);world.add_child(c2)
	var events: Array[Dictionary]=[]
	var pins: Array[Dictionary]=[]
	var counters: Dictionary={"strikes":0,"throws":0,"breaks":0,"rope_breaks":0}
	var result: Dictionary={}
	var clock: Array[int]=[0]
	var resources: Array[Dictionary]=[]
	for f in [a,b]:
		f.hit_landed.connect(func(attacker,target,damage,blocked):
			counters.strikes+=1;events.append({"tick":clock[0],"type":"hit","slot":attacker.player_index,"damage":damage,"blocked":blocked}))
		f.throw_impact.connect(func(attacker,target):
			counters.throws+=1;events.append({"tick":clock[0],"type":"throw","slot":attacker.player_index}))
	manager.pin_started.connect(func(pinner,pinned):
		pins.append({"tick":clock[0],"slot":pinner.player_index,"defender_vitality":pinned.vitality/pinned.max_vitality,"defender_stamina":pinned.stamina/pinned.max_stamina}))
	manager.pin_broken.connect(func(reason):counters.breaks+=1)
	manager.rope_break_called.connect(func():counters.rope_breaks+=1)
	manager.match_ended.connect(func(winner,method):
		result.merge({"winner_slot":winner.player_index,"winner":winner.character_id,"method":method,"loser_vitality":winner.opponent.vitality/winner.opponent.max_vitality,"loser_stamina":winner.opponent.stamina/winner.opponent.max_stamina}))
	while clock[0]<7200 and result.is_empty():
		for n in range(noise): randf()
		await tick();clock[0]+=1
		if clock[0]%60==0:
			resources.append({"tick":clock[0],"stamina":[a.stamina/a.max_stamina,b.stamina/b.max_stamina],"states":[a.current_state,b.current_state]})
	var record: Dictionary={"a":a_id,"b":b_id,"seed":match_seed,"ticks":clock[0],"seconds":clock[0]/60.0,
		"timeout":result.is_empty(),"result":result,"counters":counters,"pins":pins,"resources":resources,
		"events":events,"event_digest":JSON.stringify(events).sha256_text()}
	records.append(record)
	print("PACING ",records.size()," ",a_id,"/",b_id," ",record.seconds,"s ",JSON.stringify(result))
	world.queue_free();await tick(2)
