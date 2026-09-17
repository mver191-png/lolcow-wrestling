extends SceneTree

## Automated Headless Test Suite for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Verifies roster data, state machines, movement locking, single-hit damage,
## synchronized throws, pin counts, and rope break priority.

var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

func _init() -> void:
	print("==================================================")
	print("RUNNING LOLCOW WRESTLING M1 AUTOMATED TEST SUITE")
	print("==================================================")
	
	test_roster_stats_and_points()
	test_fighter_movement_lock()
	test_damage_occurs_only_once()
	test_synchronized_grapple_lock_and_release()
	test_pin_count_and_rope_break_priority()
	test_roster_pair_matrix_compatibility()
	
	print("==================================================")
	print("TEST RESULTS: %d Passed, %d Failed, %d Total" % [passed_tests, failed_tests, total_tests])
	print("==================================================")
	
	quit(1 if failed_tests > 0 else 0)

func assert_true(condition: bool, test_name: String) -> void:
	total_tests += 1
	if condition:
		passed_tests += 1
		print("[PASS] " + test_name)
	else:
		failed_tests += 1
		printerr("[FAIL] " + test_name)

func test_roster_stats_and_points() -> void:
	var ids: Array = RosterData.get_all_ids()
	assert_true(ids.size() == 8, "Roster contains all 8 required characters")
	
	for id in ids:
		var char_data: Dictionary = RosterData.get_character(id)
		var stats: Dictionary = char_data.get("stats", {})
		var sum_points: int = 0
		var within_range: bool = true
		for stat_name in ["power", "mobility", "grappling", "stamina", "durability", "reversal", "showmanship"]:
			var val: int = stats.get(stat_name, 0)
			sum_points += val
			if val < 1 or val > 10:
				within_range = false
		
		assert_true(sum_points == 42, "Character '%s' has exact 42-point allocation (Got %d)" % [id, sum_points])
		assert_true(within_range, "Character '%s' stats all in 1-10 range" % id)
		
		var moves: Dictionary = char_data.get("moves", {})
		assert_true(moves.has("finisher"), "Character '%s' defines a finisher" % id)
		assert_true(moves.has("trait"), "Character '%s' defines a personality trait" % id)

func test_fighter_movement_lock() -> void:
	var f: Fighter = Fighter.new()
	f.character_id = "tophiachu"
	f.load_character_data()
	
	# Normal state allows movement
	f.current_state = Fighter.State.IDLE
	f.input_dir = Vector2(1.0, 0.0)
	f._handle_locomotion(0.016)
	assert_true(f.velocity.x > 0.0, "Fighter moves in IDLE state when receiving input")
	
	# Knocked down state must NEVER move
	f.current_state = Fighter.State.KNOCKED_DOWN
	f.input_dir = Vector2(1.0, 0.0)
	f._update_state_machine(0.016)
	assert_true(f.velocity == Vector3.ZERO, "Fighter movement is strictly locked during KNOCKED_DOWN")
	
	# Grappling defender must NEVER move independently
	f.current_state = Fighter.State.GRAPPLING_DEFENDER
	f.input_dir = Vector2(1.0, 0.0)
	f._update_state_machine(0.016)
	assert_true(f.velocity == Vector3.ZERO, "Fighter movement is strictly locked during GRAPPLING_DEFENDER")
	
	# Pinned state must NEVER move
	f.current_state = Fighter.State.PINNED
	f.input_dir = Vector2(1.0, 0.0)
	f._update_state_machine(0.016)
	assert_true(f.velocity == Vector3.ZERO, "Fighter movement is strictly locked during PINNED")
	
	f.free()

func test_damage_occurs_only_once() -> void:
	var f1: Fighter = Fighter.new()
	f1.character_id = "tophiachu"
	f1.load_character_data()
	
	var f2: Fighter = Fighter.new()
	f2.character_id = "cyraxx"
	f2.load_character_data()
	
	f1.opponent = f2
	f2.opponent = f1
	
	# Place within striking distance
	f1.position = Vector3(0, 0, 0)
	f2.position = Vector3(0, 0, 1.0)
	
	var initial_vitality: float = f2.vitality
	f1._start_strike()
	assert_true(f1.current_state == Fighter.State.STRIKING, "Fighter enters STRIKING state")
	
	# Advance through active frames across multiple physics frames
	f1.state_timer = 0.15 # Inside active window [0.12, 0.32]
	f1._handle_strike_active_window()
	var hp_after_hit1: float = f2.vitality
	assert_true(hp_after_hit1 < initial_vitality, "First contact applies damage")
	
	# Tick again while still in active window
	f1.state_timer = 0.20
	f1._handle_strike_active_window()
	var hp_after_hit2: float = f2.vitality
	assert_true(hp_after_hit2 == hp_after_hit1, "Subsequent active frames do NOT apply duplicate damage")
	
	f1.free()
	f2.free()

func test_synchronized_grapple_lock_and_release() -> void:
	var attacker: Fighter = Fighter.new()
	attacker.character_id = "tophiachu"
	attacker.load_character_data()
	
	var defender: Fighter = Fighter.new()
	defender.character_id = "cyraxx"
	defender.load_character_data()
	
	attacker.opponent = defender
	defender.opponent = attacker
	attacker.position = Vector3(0, 0, 0)
	defender.position = Vector3(0, 0, 1.0)
	
	# Attacker initiates throw
	attacker._start_synchronized_throw(defender)
	assert_true(attacker.current_state == Fighter.State.GRAPPLING_ATTACKER, "Attacker enters GRAPPLING_ATTACKER")
	assert_true(defender.current_state == Fighter.State.GRAPPLING_DEFENDER, "Defender enters GRAPPLING_DEFENDER")
	
	# Simulate through throw duration
	attacker.state_timer = 0.65 # Past impact time (0.6s)
	attacker._process_synchronized_attacker()
	assert_true(attacker.throw_has_impacted, "Throw registers impact at keyframe")
	
	# End of throw -> release
	attacker.state_timer = 1.15
	attacker._process_synchronized_attacker()
	assert_true(attacker.current_state == Fighter.State.IDLE, "Attacker cleanly returns to IDLE after throw")
	assert_true(defender.current_state == Fighter.State.KNOCKED_DOWN, "Defender transitions to KNOCKED_DOWN after throw")
	
	attacker.free()
	defender.free()

func test_pin_count_and_rope_break_priority() -> void:
	# 1. Test Rope Break geometric priority
	var near_rope_pos: Vector3 = Vector3(3.5, 0.0, 0.0) # > (4.0 - 0.85 = 3.15)
	var center_pos: Vector3 = Vector3(0.5, 0.0, 0.5)
	assert_true(MatchRules.is_near_ropes(near_rope_pos), "Position near ropes detected correctly")
	assert_true(not MatchRules.is_near_ropes(center_pos), "Center ring is clear of ropes")
	
	var manager: MatchManager = MatchManager.new()
	var f1: Fighter = Fighter.new()
	var f2: Fighter = Fighter.new()
	root.add_child(f1)
	root.add_child(f2)
	root.add_child(manager)
	f1.character_id = "tophiachu"
	f2.character_id = "cyraxx"
	f1.load_character_data()
	f2.load_character_data()
	
	manager.fighter_1 = f1
	manager.fighter_2 = f2
	manager._setup_match()
	
	# Test pin initiated near ropes
	f1.position = near_rope_pos
	f2.position = near_rope_pos
	var rope_break_flag: Array[bool] = [false]
	manager.rope_break_called.connect(func(): rope_break_flag[0] = true)
	
	manager._on_fighter_pin_initiated(f1, f2)
	assert_true(rope_break_flag[0], "Rope break immediately triggered when pin initiated near ropes")
	assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Match returns to IN_PROGRESS on rope break")
	
	# Test valid pin in center ring
	f1.position = center_pos
	f2.position = center_pos
	manager._on_fighter_pin_initiated(f1, f2)
	assert_true(manager.current_state == MatchManager.MatchState.PIN_ATTEMPT, "Pin attempt successfully started in center")
	
	# Advance count to 1
	manager._process_pin_countdown(1.2)
	assert_true(manager.current_count == 1, "Referee counts 1 at first interval")
	
	# Advance count to 2
	manager._process_pin_countdown(1.2)
	assert_true(manager.current_count == 2, "Referee counts 2 at second interval")
	
	# Test kick out before 3
	f2.pin_escape_progress = 100.0
	var pin_broken_reason: Array[String] = [""]
	manager.pin_broken.connect(func(r): pin_broken_reason[0] = r)
	f2._execute_kick_out()
	assert_true(pin_broken_reason[0] == "KICKOUT", "Kick-out breaks pin before count 3")
	assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Match returns to IN_PROGRESS on kickout")
	
	manager.queue_free()
	f1.queue_free()
	f2.queue_free()

func test_roster_pair_matrix_compatibility() -> void:
	var ids: Array = RosterData.get_all_ids()
	var total_pairs: int = 0
	var success_pairs: int = 0
	
	for a_id in ids:
		for d_id in ids:
			total_pairs += 1
			var a: Fighter = Fighter.new()
			var d: Fighter = Fighter.new()
			a.character_id = a_id
			d.character_id = d_id
			a.load_character_data()
			d.load_character_data()
			a.opponent = d
			d.opponent = a
			
			a._start_synchronized_throw(d)
			if a.current_state == Fighter.State.GRAPPLING_ATTACKER and d.current_state == Fighter.State.GRAPPLING_DEFENDER:
				success_pairs += 1
			a.free()
			d.free()
			
	assert_true(total_pairs == 64, "Total roster pairings equal 64 (8x8 matrix)")
	assert_true(success_pairs == 64, "All 64 attacker-defender pairings initialize throws without error")
