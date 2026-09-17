extends SceneTree

## Dedicated Scene Integration Test Suite for Pin-Balance Acceptance
## Executes actual PackedScenes (Fighter, Referee, MatchManager, CPUController)
## within real engine physics frames (await physics_frame).

var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

var fighter_scene: PackedScene = preload("res://scenes/fighter/fighter.tscn")
var referee_scene: PackedScene = preload("res://scenes/referee/referee.tscn")

func _init() -> void:
	print("==================================================")
	print("RUNNING PIN-BALANCE SCENE INTEGRATION SUITE (GODOT 4.7.2)")
	print("==================================================")
	_run_suite()

func assert_true(condition: bool, test_name: String) -> void:
	total_tests += 1
	if condition:
		passed_tests += 1
		print("[PASS] " + test_name)
	else:
		failed_tests += 1
		printerr("[FAIL] " + test_name)

func _run_suite() -> void:
	await physics_frame
	await physics_frame
	
	print("\n--- TEST GROUP 1: EMPIRICAL ORDINARY THROW -> PIN (FRESH CYRAXX) ---")
	await test_ordinary_throw_to_pin_cpu()
	await test_ordinary_throw_to_pin_mash()
	await test_ordinary_throw_to_pin_hold_entry()
	await test_ordinary_throw_to_pin_hold_preheld()
	
	print("\n--- TEST GROUP 2: GENUINE FINISHER -> PIN (WEAKENED CYRAXX) ---")
	await test_finisher_throw_to_pin_cpu_weakened()
	await test_finisher_throw_to_pin_mash_weakened()
	await test_finisher_throw_to_pin_hold_entry_weakened()
	await test_finisher_throw_to_pin_hold_preheld_weakened()
	
	print("\n--- TEST GROUP 3: FINAL-TICK (TICK 198 / 3.30s) PRIORITY RESOLUTION ---")
	await test_final_tick_kickout_priority(false, false) # P1 pinner, P2 pinned, Normal order
	await test_final_tick_kickout_priority(true, false)  # P2 pinner, P1 pinned, Normal order
	await test_final_tick_kickout_priority(false, true)  # P1 pinner, P2 pinned, Inverted tree order
	await test_final_tick_kickout_priority(true, true)   # P2 pinner, P1 pinned, Inverted tree order
	await test_final_tick_rope_break_priority(false, false)
	await test_final_tick_rope_break_priority(true, false)
	await test_final_tick_rope_break_priority(false, true)
	await test_final_tick_rope_break_priority(true, true)
	await test_duplicate_match_end_guard()
	
	print("\n==================================================")
	print("SCENE INTEGRATION RESULTS: %d Passed, %d Failed, %d Total" % [passed_tests, failed_tests, total_tests])
	print("==================================================")
	
	quit(1 if failed_tests > 0 else 0)

# ==============================================================================
# Helper Setup
# ==============================================================================

func _setup_test_scene(p1_char: String = "tophiachu", p2_char: String = "cyraxx", invert_tree: bool = false) -> Dictionary:
	var container: Node3D = Node3D.new()
	container.name = "TestSceneContainer"
	root.add_child(container)
	
	var mm: MatchManager = MatchManager.new()
	var p1: Fighter = fighter_scene.instantiate() as Fighter
	var p2: Fighter = fighter_scene.instantiate() as Fighter
	var ref: Referee = referee_scene.instantiate() as Referee
	var cpu: CPUController = CPUController.new()
	
	p1.character_id = p1_char
	p1.player_index = 1
	p1.is_cpu = false
	p1.position = Vector3(-0.6, 0, 0)
	
	p2.character_id = p2_char
	p2.player_index = 2
	p2.is_cpu = false
	p2.position = Vector3(0.6, 0, 0)
	
	ref.position = Vector3(0, 0, -2.0)
	
	mm.fighter_1 = p1
	mm.fighter_2 = p2
	mm.referee = ref
	
	if invert_tree:
		container.add_child(mm)
		container.add_child(p2)
		container.add_child(p1)
		container.add_child(ref)
		container.add_child(cpu)
	else:
		container.add_child(p1)
		container.add_child(p2)
		container.add_child(ref)
		container.add_child(cpu)
		container.add_child(mm)
		
	p1.opponent = p2
	p2.opponent = p1
	cpu.fighter = p2
	
	mm._setup_match()
	
	return {
		"container": container,
		"mm": mm,
		"p1": p1,
		"p2": p2,
		"ref": ref,
		"cpu": cpu
	}

func _cleanup_scene(ctx: Dictionary) -> void:
	Input.action_release("p1_pin")
	Input.action_release("p2_pin")
	if ctx.has("container") and is_instance_valid(ctx["container"]):
		ctx["container"].queue_free()
	await physics_frame
	await physics_frame

# ==============================================================================
# Group 1: Ordinary Tophiachu Throw -> Center Pin on Fresh Cyraxx
# ==============================================================================

func test_ordinary_throw_to_pin_cpu() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p1._start_synchronized_throw(p2)
	assert_true(p1.current_state == Fighter.State.GRAPPLING_ATTACKER, "Ordinary Throw: Tophiachu enters GRAPPLING_ATTACKER")
	assert_true(p2.current_state == Fighter.State.GRAPPLING_DEFENDER, "Ordinary Throw: Cyraxx enters GRAPPLING_DEFENDER")
	
	for i in range(70):
		await physics_frame
		
	assert_true(p1.current_state == Fighter.State.IDLE, "Ordinary Throw: Tophiachu returns to IDLE after throw")
	assert_true(p2.current_state == Fighter.State.KNOCKED_DOWN, "Ordinary Throw: Cyraxx knocked down on canvas")
	
	assert_true(p2.vitality < 850.0 and p2.vitality >= 660.0, "Ordinary Throw: Cyraxx HP reduced by ~177 damage (Observed HP: %.1f/850)" % p2.vitality)
	assert_true(p2.recent_finisher_impact_timer == 0.0, "Ordinary Throw: Move metadata ensures finisher disorientation is strictly 0.0")
	assert_true(p2.recent_heavy_impact_timer > 0.0, "Ordinary Throw: Ordinary heavy impact timer active for 1.5s")
	
	p2.is_cpu = true
	var pin_outcome: Array = ["NONE"]
	var recorded_count: Array = [0]
	mm.pin_broken.connect(func(r): pin_outcome[0] = r)
	mm.pin_count_ticked.connect(func(c): recorded_count[0] = c)
	
	p1._start_pin(p2)
	assert_true(mm.current_state == MatchManager.MatchState.PIN_ATTEMPT, "Ordinary Throw -> Pin: Match state is PIN_ATTEMPT")
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
		
	assert_true(pin_outcome[0] == "KICKOUT", "Ordinary Throw -> Pin [Mode 1 CPU]: Fresh Cyraxx kicks out via CPU commands")
	assert_true(recorded_count[0] <= 1, "Ordinary Throw -> Pin [Mode 1 CPU]: Kickout occurs before Count 2 (Count reached: %d, time: %.2fs)" % [recorded_count[0], frame_count / 60.0])
	
	await _cleanup_scene(ctx)

func test_ordinary_throw_to_pin_mash() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p1._start_synchronized_throw(p2)
	for i in range(70):
		await physics_frame
		
	p2.is_cpu = false
	var pin_outcome: Array = ["NONE"]
	var recorded_count: Array = [0]
	mm.pin_broken.connect(func(r): pin_outcome[0] = r)
	mm.pin_count_ticked.connect(func(c): recorded_count[0] = c)
	
	p1._start_pin(p2)
	
	# Simulate human 10 Hz mashing via Godot input action system
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		if frame_count % 6 == 0:
			Input.action_press("p2_pin")
		else:
			Input.action_release("p2_pin")
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(pin_outcome[0] == "KICKOUT", "Ordinary Throw -> Pin [Mode 2 Mash]: Fresh Cyraxx kicks out via 10 Hz mashing")
	assert_true(recorded_count[0] <= 1, "Ordinary Throw -> Pin [Mode 2 Mash]: Kickout occurs before Count 2 (Count reached: %d, time: %.2fs)" % [recorded_count[0], frame_count / 60.0])
	
	await _cleanup_scene(ctx)

func test_ordinary_throw_to_pin_hold_entry() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p1._start_synchronized_throw(p2)
	for i in range(70):
		await physics_frame
		
	p2.is_cpu = false
	var pin_outcome: Array = ["NONE"]
	var recorded_count: Array = [0]
	mm.pin_broken.connect(func(r): pin_outcome[0] = r)
	mm.pin_count_ticked.connect(func(c): recorded_count[0] = c)
	
	p1._start_pin(p2)
	
	# Hold-to-resist pressed right on pin entry
	Input.action_press("p2_pin")
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(pin_outcome[0] == "KICKOUT", "Ordinary Throw -> Pin [Mode 3 Hold On Entry]: Fresh Cyraxx kicks out via hold-to-resist")
	assert_true(recorded_count[0] <= 1, "Ordinary Throw -> Pin [Mode 3 Hold On Entry]: Kickout occurs before Count 2 (Count reached: %d, time: %.2fs)" % [recorded_count[0], frame_count / 60.0])
	
	await _cleanup_scene(ctx)

func test_ordinary_throw_to_pin_hold_preheld() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p1._start_synchronized_throw(p2)
	for i in range(70):
		await physics_frame
		
	p2.is_cpu = false
	var pin_outcome: Array = ["NONE"]
	var recorded_count: Array = [0]
	mm.pin_broken.connect(func(r): pin_outcome[0] = r)
	mm.pin_count_ticked.connect(func(c): recorded_count[0] = c)
	
	# Button already held BEFORE pin begins
	Input.action_press("p2_pin")
	await physics_frame
	
	p1._start_pin(p2)
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(pin_outcome[0] == "KICKOUT", "Ordinary Throw -> Pin [Mode 4 Pre-Held]: Fresh Cyraxx kicks out via pre-held hold-to-resist")
	assert_true(recorded_count[0] <= 1, "Ordinary Throw -> Pin [Mode 4 Pre-Held]: Kickout occurs before Count 2 (Count reached: %d, time: %.2fs)" % [recorded_count[0], frame_count / 60.0])
	
	await _cleanup_scene(ctx)

# ==============================================================================
# Group 2: Genuine Finisher -> Center Pin on Weakened Defender
# ==============================================================================

func test_finisher_throw_to_pin_cpu_weakened() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p2.vitality = 150.0
	p2.stamina = 12.0
	p1.hype = 100.0
	
	p1._attempt_grapple(true)
	assert_true(p1.is_finisher_attack, "Genuine Finisher: is_finisher_attack flag is true")
	
	for i in range(85):
		await physics_frame
		
	assert_true(p2.recent_finisher_impact_timer > 0.0, "Genuine Finisher: Cyraxx has active 4.5s finisher disorientation (%.2fs)" % p2.recent_finisher_impact_timer)
	
	p2.is_cpu = true
	var match_outcome: Array = ["NONE"]
	mm.match_ended.connect(func(_w, m): match_outcome[0] = m)
	
	p1._start_pin(p2)
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
		
	assert_true(match_outcome[0] == "PINFALL (3-COUNT)", "Finisher -> Pin [Mode 1 CPU]: Weakened Cyraxx loses by 3-count pinfall")
	await _cleanup_scene(ctx)

func test_finisher_throw_to_pin_mash_weakened() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p2.vitality = 150.0
	p2.stamina = 12.0
	p1.hype = 100.0
	p1._attempt_grapple(true)
	
	for i in range(85):
		await physics_frame
		
	p2.is_cpu = false
	var match_outcome: Array = ["NONE"]
	mm.match_ended.connect(func(_w, m): match_outcome[0] = m)
	
	p1._start_pin(p2)
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		if frame_count % 6 == 0:
			Input.action_press("p2_pin")
		else:
			Input.action_release("p2_pin")
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(match_outcome[0] == "PINFALL (3-COUNT)", "Finisher -> Pin [Mode 2 Mash]: Weakened Cyraxx loses by 3-count pinfall despite 10 Hz mashing")
	await _cleanup_scene(ctx)

func test_finisher_throw_to_pin_hold_entry_weakened() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p2.vitality = 150.0
	p2.stamina = 12.0
	p1.hype = 100.0
	p1._attempt_grapple(true)
	
	for i in range(85):
		await physics_frame
		
	p2.is_cpu = false
	var match_outcome: Array = ["NONE"]
	mm.match_ended.connect(func(_w, m): match_outcome[0] = m)
	
	p1._start_pin(p2)
	
	Input.action_press("p2_pin")
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(match_outcome[0] == "PINFALL (3-COUNT)", "Finisher -> Pin [Mode 3 Hold Entry]: Weakened Cyraxx loses by 3-count pinfall")
	await _cleanup_scene(ctx)

func test_finisher_throw_to_pin_hold_preheld_weakened() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p2.vitality = 150.0
	p2.stamina = 12.0
	p1.hype = 100.0
	p1._attempt_grapple(true)
	
	for i in range(85):
		await physics_frame
		
	p2.is_cpu = false
	Input.action_press("p2_pin")
	await physics_frame
	
	var match_outcome: Array = ["NONE"]
	mm.match_ended.connect(func(_w, m): match_outcome[0] = m)
	
	p1._start_pin(p2)
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(match_outcome[0] == "PINFALL (3-COUNT)", "Finisher -> Pin [Mode 4 Pre-Held]: Weakened Cyraxx loses by 3-count pinfall")
	await _cleanup_scene(ctx)

# ==============================================================================
# Group 3: Final-Tick (Tick 198 / 3.30s) Priority Fixtures
# ==============================================================================

func test_final_tick_kickout_priority(invert_slots: bool, invert_tree: bool) -> void:
	var ctx: Dictionary = _setup_test_scene("tophiachu", "cyraxx", invert_tree)
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	var pinner: Fighter = p2 if invert_slots else p1
	var pinned: Fighter = p1 if invert_slots else p2
	var pinned_action: String = "p1_pin" if invert_slots else "p2_pin"
	
	await physics_frame
	
	pinned.vitality = 300.0
	pinned.stamina = 20.0
	pinned.is_cpu = false
	
	pinner._start_pin(pinned)
	
	var broken_reason: Array = ["NONE"]
	var match_ended_called: Array = [false]
	mm.pin_broken.connect(func(r): broken_reason[0] = r)
	mm.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
	
	# Advance precisely to tick 197 (Count is 2)
	for frame in range(197):
		await physics_frame
		
	assert_true(mm.current_count == 2, "Final-Tick Kickout [%s/%s]: Count is 2 before tick 198" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	
	# On tick 198, defender reaches kick-out threshold 100.0 with active input
	pinned.pin_escape_progress = 100.0
	Input.action_press(pinned_action)
	
	# Tick 198 (3.30s)
	await physics_frame
	Input.action_release(pinned_action)
	
	assert_true(broken_reason[0] == "KICKOUT", "Final-Tick Kickout [%s/%s]: Escape takes priority over 3-count" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	assert_true(not match_ended_called[0], "Final-Tick Kickout [%s/%s]: match_ended is NOT emitted" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	assert_true(mm.current_state == MatchManager.MatchState.IN_PROGRESS, "Final-Tick Kickout [%s/%s]: Match returns to IN_PROGRESS" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	
	await _cleanup_scene(ctx)

func test_final_tick_rope_break_priority(invert_slots: bool, invert_tree: bool) -> void:
	var ctx: Dictionary = _setup_test_scene("tophiachu", "cyraxx", invert_tree)
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	var pinner: Fighter = p2 if invert_slots else p1
	var pinned: Fighter = p1 if invert_slots else p2
	
	await physics_frame
	pinned.vitality = 0.0
	pinned.stamina = 0.0
	
	pinner._start_pin(pinned)
	
	var rope_break_called: Array = [false]
	var match_ended_called: Array = [false]
	mm.rope_break_called.connect(func(): rope_break_called[0] = true)
	mm.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
	
	# Advance precisely to tick 197
	for frame in range(197):
		await physics_frame
		
	assert_true(mm.current_count == 2, "Final-Tick RopeBreak [%s/%s]: Count is 2 before tick 198" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	
	# On tick 198, pinned fighter touches rope threshold
	pinned.position = Vector3(3.25, 0, 0)
	
	# Tick 198 (3.30s)
	await physics_frame
	
	assert_true(rope_break_called[0], "Final-Tick RopeBreak [%s/%s]: Rope break takes priority over 3-count" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	assert_true(not match_ended_called[0], "Final-Tick RopeBreak [%s/%s]: match_ended is NOT emitted" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	assert_true(mm.current_state == MatchManager.MatchState.IN_PROGRESS, "Final-Tick RopeBreak [%s/%s]: Match returns to IN_PROGRESS" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	
	await _cleanup_scene(ctx)

func test_duplicate_match_end_guard() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	var call_count: Array = [0]
	mm.match_ended.connect(func(_w, _m): call_count[0] += 1)
	
	mm._end_match(p1, "PINFALL (3-COUNT)")
	mm._end_match(p2, "PINFALL (3-COUNT)")
	
	assert_true(call_count[0] == 1, "Duplicate Guard: match_ended signal emitted strictly once")
	assert_true(mm.current_state == MatchManager.MatchState.MATCH_OVER, "Duplicate Guard: MatchState remains MATCH_OVER")
	
	await _cleanup_scene(ctx)
