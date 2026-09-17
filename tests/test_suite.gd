extends SceneTree

## Automated Headless Test Suite for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Verifies roster data, character models, state machines, movement locking,
## single-hit damage, synchronized throws, pin counts, submissions, audio synthesis,
## character select interface, and all 64 matchups.

var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

func _init() -> void:
	print("==================================================")
	print("RUNNING LOLCOW WRESTLING AUTOMATED TEST SUITE (M2/M3)")
	print("==================================================")
	
	test_roster_stats_and_points()
	test_character_models_exist_and_load()
	test_fighter_movement_lock()
	test_damage_occurs_only_once()
	test_synchronized_grapple_lock_and_release()
	test_leverage_throw_routing()
	test_pin_count_and_rope_break_priority()
	test_submission_and_tap_out()
	test_audio_and_trauma_shake()
	test_match_config_and_character_select()
	test_roster_pair_matrix_compatibility()
	test_pass_a_cpu_escape_mechanisms()
	test_pass_a_throw_height_and_ownership()
	test_pass_a_slot_inversions_and_facing_vectors()
	test_pass_a_resource_aware_pinfall_balance()
	test_explicit_impact_classification()
	test_pass_a_boundary_safe_paired_throws()
	test_pass_a_strike_directional_cone()
	test_pass_a_grapple_startup_and_interruption()
	test_pass_a_simultaneous_submission_ordering()
	test_pass_a_callback_state_overwrite_resilience()
	test_pass_a_final_count_escape_crossing()
	test_visual_presentation_and_skeletal_rig()
	
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

func test_character_models_exist_and_load() -> void:
	var ids: Array = RosterData.get_all_ids()
	for id in ids:
		var path: String = "res://assets/models/" + id + ".glb"
		assert_true(ResourceLoader.exists(path), "3D Model exists for character '%s'" % id)
		var res = load(path)
		assert_true(res is PackedScene, "Character '%s' model loads as PackedScene" % id)
		if res is PackedScene:
			var node = res.instantiate()
			assert_true(node != null and node.get_child_count() > 0, "Character '%s' instantiates with geometry nodes" % id)
			node.free()
			
	# Test arena and referee
	assert_true(ResourceLoader.exists("res://assets/models/ring_arena.glb"), "Arena model exists")
	assert_true(ResourceLoader.exists("res://assets/models/referee_cobra.glb"), "KingCobraJFS referee model exists")

func test_fighter_movement_lock() -> void:
	var fighter: Fighter = Fighter.new()
	fighter.character_id = "tophiachu"
	fighter.load_character_data()
	
	# 1. Idle state accepts movement
	fighter.current_state = Fighter.State.IDLE
	fighter.input_dir = Vector2(1.0, 0.0)
	fighter._handle_locomotion(0.016)
	assert_true(fighter.velocity.length() > 0.0, "Fighter moves in IDLE state when receiving input")
	
	# 2. Strict movement ownership locks
	fighter.input_dir = Vector2(1.0, 0.0)
	fighter._set_state(Fighter.State.KNOCKED_DOWN)
	fighter._update_state_machine(0.016)
	assert_true(fighter.velocity == Vector3.ZERO, "Fighter movement is strictly locked during KNOCKED_DOWN")
	
	fighter._set_state(Fighter.State.GRAPPLING_DEFENDER)
	fighter._update_state_machine(0.016)
	assert_true(fighter.velocity == Vector3.ZERO, "Fighter movement is strictly locked during GRAPPLING_DEFENDER")
	
	fighter._set_state(Fighter.State.PINNED)
	fighter._update_state_machine(0.016)
	assert_true(fighter.velocity == Vector3.ZERO, "Fighter movement is strictly locked during PINNED")
	
	fighter.free()

func test_damage_occurs_only_once() -> void:
	var attacker: Fighter = Fighter.new()
	var defender: Fighter = Fighter.new()
	attacker.character_id = "tophiachu"
	defender.character_id = "cyraxx"
	attacker.load_character_data()
	defender.load_character_data()
	
	attacker.opponent = defender
	attacker.position = Vector3(0, 0, 0)
	defender.position = Vector3(0, 0, -0.8) # Within reach and forward cone
	
	attacker.input_strike = true
	attacker._start_strike()
	assert_true(attacker.current_state == Fighter.State.STRIKING, "Fighter enters STRIKING state")
	
	var initial_hp: float = defender.vitality
	attacker.state_timer = 0.15 # Inside [0.12, 0.32] window
	attacker._handle_strike_active_window()
	
	assert_true(defender.vitality < initial_hp, "First contact applies damage")
	var hp_after_hit: float = defender.vitality
	
	# Tick again inside same active window
	attacker.state_timer = 0.20
	attacker._handle_strike_active_window()
	assert_true(defender.vitality == hp_after_hit, "Subsequent active frames do NOT apply duplicate damage")
	
	attacker.free()
	defender.free()

func test_synchronized_grapple_lock_and_release() -> void:
	var attacker: Fighter = Fighter.new()
	var defender: Fighter = Fighter.new()
	attacker.character_id = "tophiachu"
	defender.character_id = "cyraxx"
	attacker.load_character_data()
	defender.load_character_data()
	
	attacker.opponent = defender
	attacker.position = Vector3(0, 0, 0)
	defender.position = Vector3(0, 0, 1.0)
	
	attacker._start_synchronized_throw(defender)
	assert_true(attacker.current_state == Fighter.State.GRAPPLING_ATTACKER, "Attacker enters GRAPPLING_ATTACKER")
	assert_true(defender.current_state == Fighter.State.GRAPPLING_DEFENDER, "Defender enters GRAPPLING_DEFENDER")
	
	# Tick to impact
	attacker.state_timer = 0.65
	attacker._process_synchronized_attacker()
	assert_true(attacker.throw_has_impacted, "Throw registers impact at keyframe")
	
	# Tick to throw release
	attacker.state_timer = 1.15
	attacker._process_synchronized_attacker()
	assert_true(attacker.current_state == Fighter.State.IDLE, "Attacker cleanly returns to IDLE after throw")
	assert_true(defender.current_state == Fighter.State.KNOCKED_DOWN, "Defender transitions to KNOCKED_DOWN after throw")
	
	attacker.free()
	defender.free()

func test_pin_count_and_rope_break_priority() -> void:
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
	
	# 1. Test Rope Break detection
	var near_rope_pos: Vector3 = Vector3(3.5, 0, 0) # Mat edge is 4.0, within 0.85
	var center_pos: Vector3 = Vector3(0, 0, 0)
	assert_true(MatchRules.is_near_ropes(near_rope_pos), "Position near ropes detected correctly")
	assert_true(not MatchRules.is_near_ropes(center_pos), "Center ring is clear of ropes")
	
	# 2. Rope Break cancels pin immediately
	f2.position = near_rope_pos
	f1.position = near_rope_pos
	var rope_break_called: Array[bool] = [false]
	manager.rope_break_called.connect(func(): rope_break_called[0] = true)
	manager._on_fighter_pin_initiated(f1, f2)
	assert_true(rope_break_called[0], "Rope break immediately triggered when pin initiated near ropes")
	assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Match returns to IN_PROGRESS on rope break")
	
	# 3. Clean Pin in center
	f1.position = center_pos
	f2.position = center_pos
	manager._on_fighter_pin_initiated(f1, f2)
	assert_true(manager.current_state == MatchManager.MatchState.PIN_ATTEMPT, "Pin attempt successfully started in center")
	
	# Tick pin countdown
	manager._process_pin_countdown(1.2)
	assert_true(manager.current_count == 1, "Referee counts 1 at first interval")
	manager._process_pin_countdown(1.2)
	assert_true(manager.current_count == 2, "Referee counts 2 at second interval")
	
	# Kickout before count 3
	var pin_broken_called: Array[bool] = [false]
	manager.pin_broken.connect(func(_reason): pin_broken_called[0] = true)
	manager._on_kick_out_succeeded(f2)
	assert_true(pin_broken_called[0], "Kick-out breaks pin before count 3")
	assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Match returns to IN_PROGRESS on kickout")
	
	manager.free()
	f1.free()
	f2.free()

func test_roster_pair_matrix_compatibility() -> void:
	var ids: Array = RosterData.get_all_ids()
	var total_pairs: int = 0
	var success_pairs: int = 0
	
	for atk_id in ids:
		for def_id in ids:
			total_pairs += 1
			var atk: Fighter = Fighter.new()
			var def: Fighter = Fighter.new()
			atk.character_id = atk_id
			def.character_id = def_id
			atk.load_character_data()
			def.load_character_data()
			
			atk.opponent = def
			atk._start_synchronized_throw(def)
			
			if atk.current_state == Fighter.State.GRAPPLING_ATTACKER and def.current_state == Fighter.State.GRAPPLING_DEFENDER:
				success_pairs += 1
				
			atk.free()
			def.free()
			
	assert_true(total_pairs == 64, "Total roster pairings equal 64 (8x8 matrix)")
	assert_true(success_pairs == 64, "All 64 attacker-defender pairings initialize throws without error")

func test_leverage_throw_routing() -> void:
	var cyraxx: Fighter = Fighter.new()
	var tophiachu: Fighter = Fighter.new()
	cyraxx.character_id = "cyraxx"
	tophiachu.character_id = "tophiachu"
	cyraxx.load_character_data()
	tophiachu.load_character_data()
	
	# Cyraxx (Power 4, reach 0.95) vs Tophiachu (Power 8, reach 1.25)
	var cyraxx_is_leverage: bool = (cyraxx.stat_power < tophiachu.stat_power or cyraxx.reach_distance < tophiachu.reach_distance)
	assert_true(cyraxx_is_leverage, "Lightweight Cyraxx correctly routes to low leverage trip against heavyweight Tophiachu")
	
	# Tophiachu vs Cyraxx
	var tophiachu_is_leverage: bool = (tophiachu.stat_power < cyraxx.stat_power or tophiachu.reach_distance < cyraxx.reach_distance)
	assert_true(not tophiachu_is_leverage, "Heavyweight Tophiachu correctly routes to high overhead powerslam against Cyraxx")
	
	cyraxx.free()
	tophiachu.free()

func test_submission_and_tap_out() -> void:
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
	
	# Knock down opponent to allow submission
	f2.current_state = Fighter.State.KNOCKED_DOWN
	f1.position = Vector3(0, 0, 0)
	f2.position = Vector3(0, 0, 0.5)
	
	# 1. Attempt submission
	f1._attempt_submission(false)
	assert_true(f1.current_state == Fighter.State.SUBMISSION_ATTACKER, "Attacker enters SUBMISSION_ATTACKER")
	assert_true(f2.current_state == Fighter.State.SUBMISSION_DEFENDER, "Defender enters SUBMISSION_DEFENDER")
	
	# 2. Process submission hold pressure
	var hp_before: float = f2.vitality
	var sta_before: float = f2.stamina
	f1._process_submission_attacker(0.6)
	assert_true(f2.vitality < hp_before, "Submission hold applies continuous pressure damage")
	assert_true(f2.stamina < sta_before, "Submission hold drains defender stamina")
	
	# 3. Test escape
	f2.pin_escape_progress = 100.0
	var escaped_flag: Array[bool] = [false]
	manager.submission_escaped.connect(func(): escaped_flag[0] = true)
	f2._execute_submission_escape()
	assert_true(escaped_flag[0], "Defender escape breaks submission hold")
	assert_true(f2.current_state == Fighter.State.GETTING_UP, "Defender transitions to GETTING_UP on escape")
	assert_true(f1.current_state == Fighter.State.IDLE, "Attacker returns to IDLE on submission escape")
	
	# 4. Test Tap-Out Victory
	f2.current_state = Fighter.State.KNOCKED_DOWN
	f2.vitality = 5.0 # Low health
	f1.position = Vector3(0, 0, 0)
	f2.position = Vector3(0, 0, 0.5)
	f1._attempt_submission(false)
	
	var tap_out_called: Array[bool] = [false]
	manager.match_ended.connect(func(_winner, method):
		if method == "SUBMISSION (TAP OUT)":
			tap_out_called[0] = true
	)
	f1._process_submission_attacker(0.6) # Depletes remaining 5.0 HP
	manager._physics_process(1.0 / 60.0) # Authoritative manager evaluates submission outcome
	assert_true(tap_out_called[0], "Depleting vitality during submission results in SUBMISSION (TAP OUT) victory")
	assert_true(manager.current_state == MatchManager.MatchState.MATCH_OVER, "Match terminates with MATCH_OVER on tap-out")
	
	manager.free()
	f1.free()
	f2.free()

func test_audio_and_trauma_shake() -> void:
	# 1. Test AudioManager synthesis
	var audio: AudioManager = AudioManager.new()
	audio._create_audio_streams()
	assert_true(audio.snd_bell != null, "Bell audio stream synthesized successfully")
	assert_true(audio.snd_mat_slam != null, "Mat slam audio stream synthesized successfully")
	assert_true(audio.snd_strike_clean != null, "Strike audio stream synthesized successfully")
	assert_true(audio.snd_ref_slap != null, "Referee slap audio stream synthesized successfully")
	assert_true(audio.snd_crowd_cheer != null, "Crowd cheer audio stream synthesized successfully")
	assert_true(audio.snd_finisher_stinger != null, "Finisher stinger audio stream synthesized successfully")
	assert_true(audio.snd_victory_fanfare != null, "Victory fanfare audio stream synthesized successfully")
	assert_true(audio.snd_rope_break != null, "Rope break buzzer audio stream synthesized successfully")
	assert_true(audio.snd_counts.size() == 3, "Count tones synthesized for counts 1, 2, and 3")
	audio.free()
	
	# 2. Test BroadcastCamera trauma shake
	var cam: BroadcastCamera = BroadcastCamera.new()
	var t1: Node3D = Node3D.new()
	var t2: Node3D = Node3D.new()
	cam.target_1 = t1
	cam.target_2 = t2
	cam.add_trauma(0.6)
	assert_true(cam.trauma == 0.6, "Camera trauma added correctly")
	cam._physics_process(0.1)
	assert_true(cam.trauma < 0.6, "Camera trauma decays smoothly over time")
	
	cam.free()
	t1.free()
	t2.free()

func test_match_config_and_character_select() -> void:
	# 1. MatchConfig persistence
	MatchConfig.set_match("novaonline", "daniel_larson", false)
	assert_true(MatchConfig.p1_character_id == "novaonline", "MatchConfig stores P1 selection")
	assert_true(MatchConfig.p2_character_id == "daniel_larson", "MatchConfig stores P2 selection")
	assert_true(MatchConfig.p2_is_cpu == false, "MatchConfig stores CPU toggle")
	
	# 2. CharacterSelect UI instantiation
	var select_scene_res = load("res://scenes/ui/character_select.tscn")
	assert_true(select_scene_res is PackedScene, "CharacterSelect scene resource exists and loads")
	if select_scene_res is PackedScene:
		var select_ui: CharacterSelect = select_scene_res.instantiate() as CharacterSelect
		root.add_child(select_ui)
		select_ui._ready()
		assert_true(select_ui.roster_buttons.size() == 8, "CharacterSelect creates 8 buttons in roster grid")
		assert_true(select_ui.p1_index == select_ui.character_ids.find("novaonline"), "CharacterSelect reflects initial MatchConfig P1")
		assert_true(select_ui.p2_index == select_ui.character_ids.find("daniel_larson"), "CharacterSelect reflects initial MatchConfig P2")
		
		# Test CPU toggle
		var cpu_before: bool = select_ui.p2_is_cpu
		select_ui._on_cpu_toggle_pressed()
		assert_true(select_ui.p2_is_cpu != cpu_before, "CharacterSelect toggles P2 CPU mode")
		
		select_ui.queue_free()
	
	# Reset MatchConfig to defaults
	MatchConfig.reset_defaults()

func test_pass_a_cpu_escape_mechanisms() -> void:
	# 1. Test CPU Pin Escape without keyboard input
	var cpu_fighter: Fighter = Fighter.new()
	var opponent: Fighter = Fighter.new()
	var cpu_ctrl: CPUController = CPUController.new()
	
	root.add_child(cpu_fighter)
	root.add_child(opponent)
	root.add_child(cpu_ctrl)
	
	cpu_fighter.character_id = "cyraxx"
	opponent.character_id = "tophiachu"
	cpu_fighter.load_character_data()
	opponent.load_character_data()
	
	cpu_fighter.opponent = opponent
	opponent.opponent = cpu_fighter
	cpu_fighter.is_cpu = true
	cpu_ctrl.fighter = cpu_fighter
	
	# Lock into pin
	opponent.current_state = Fighter.State.PINNING
	cpu_fighter.on_pinned(opponent)
	assert_true(cpu_fighter.current_state == Fighter.State.PINNED, "Pass A: Defender enters PINNED state")
	assert_true(cpu_fighter.pin_escape_progress == 0.0, "Pass A: Pin escape progress starts at 0")
	
	# Simulate in-tree physics processing
	var kicked_out: Array[bool] = [false]
	cpu_fighter.kick_out_succeeded.connect(func(_f): kicked_out[0] = true)
	
	# Tick through physics updates until kickout or max frames
	for frame in range(90):
		cpu_ctrl._physics_process(1.0 / 60.0)
		cpu_fighter._physics_process(1.0 / 60.0)
		if kicked_out[0]:
			break
			
	assert_true(cpu_fighter.pin_escape_progress > 20.0, "Pass A: CPU defender accumulates pin escape progress without keyboard input")
	assert_true(kicked_out[0] and cpu_fighter.current_state == Fighter.State.GETTING_UP, "Pass A: CPU defender successfully kicks out via command interface")
	
	# 2. Test CPU Submission Escape without keyboard input
	opponent.current_state = Fighter.State.SUBMISSION_ATTACKER
	opponent.synchronized_partner = cpu_fighter
	cpu_fighter.on_locked_by_submission(opponent)
	assert_true(cpu_fighter.current_state == Fighter.State.SUBMISSION_DEFENDER, "Pass A: Defender enters SUBMISSION_DEFENDER state")
	
	var submission_escaped: Array[bool] = [false]
	cpu_fighter.submission_escaped.connect(func(_f): submission_escaped[0] = true)
	
	for frame in range(90):
		cpu_ctrl._physics_process(1.0 / 60.0)
		cpu_fighter._physics_process(1.0 / 60.0)
		if submission_escaped[0]:
			break
			
	assert_true(submission_escaped[0] and cpu_fighter.current_state == Fighter.State.GETTING_UP, "Pass A: CPU defender successfully escapes submission via command interface")
	
	cpu_ctrl.free()
	cpu_fighter.free()
	opponent.free()

func test_pass_a_throw_height_and_ownership() -> void:
	var atk: Fighter = Fighter.new()
	var def: Fighter = Fighter.new()
	root.add_child(atk)
	root.add_child(def)
	
	atk.character_id = "tophiachu"
	def.character_id = "cyraxx"
	atk.load_character_data()
	def.load_character_data()
	
	atk.position = Vector3(0, 0, -1.0)
	def.position = Vector3(0, 0, 1.0)
	atk.opponent = def
	def.opponent = atk
	
	atk._start_synchronized_throw(def)
	assert_true(atk.current_state == Fighter.State.GRAPPLING_ATTACKER, "Pass A: Attacker in GRAPPLING_ATTACKER")
	assert_true(def.current_state == Fighter.State.GRAPPLING_DEFENDER, "Pass A: Defender in GRAPPLING_DEFENDER")
	
	# Advance physics frames into the mid-lift peak (state_timer ~ 0.3s)
	var peak_height_observed: float = 0.0
	for frame in range(20):
		atk._physics_process(0.016)
		def._physics_process(0.016)
		var def_y: float = def.global_position.y if def.is_inside_tree() else def.position.y
		if def_y > peak_height_observed:
			peak_height_observed = def_y
			
	assert_true(peak_height_observed > 1.2, "Pass A: Defender reaches peak throw height (> 1.2m) without being clamped to 0 by _clamp_within_ring (Observed: %.2fm)" % peak_height_observed)
	
	# Continue to throw completion
	for frame in range(60):
		atk._physics_process(0.016)
		def._physics_process(0.016)
		
	assert_true(atk.current_state == Fighter.State.IDLE, "Pass A: Attacker cleanly transitions to IDLE after throw")
	assert_true(def.current_state == Fighter.State.KNOCKED_DOWN, "Pass A: Defender transitions to KNOCKED_DOWN after throw")
	var final_y: float = def.global_position.y if def.is_inside_tree() else def.position.y
	assert_true(is_equal_approx(final_y, 0.0), "Pass A: Defender cleanly grounded on canvas after throw (Y=%.2f)" % final_y)
	
	atk.free()
	def.free()

func test_pass_a_slot_inversions_and_facing_vectors() -> void:
	var configs = [
		{"atk_id": "tophiachu", "atk_slot": 1, "atk_pos": Vector3(-1.5, 0, 0), "def_id": "cyraxx", "def_slot": 2, "def_pos": Vector3(1.5, 0, 0), "desc": "P1 Attacker (-X) vs P2 Defender (+X)"},
		{"atk_id": "tophiachu", "atk_slot": 2, "atk_pos": Vector3(1.5, 0, 0), "def_id": "cyraxx", "def_slot": 1, "def_pos": Vector3(-1.5, 0, 0), "desc": "P2 Attacker (+X) vs P1 Defender (-X)"},
		{"atk_id": "cyraxx", "atk_slot": 1, "atk_pos": Vector3(0, 0, -1.5), "def_id": "tophiachu", "def_slot": 2, "def_pos": Vector3(0, 0, 1.5), "desc": "P1 Attacker (-Z) vs P2 Defender (+Z)"},
		{"atk_id": "cyraxx", "atk_slot": 2, "atk_pos": Vector3(0, 0, 1.5), "def_id": "tophiachu", "def_slot": 1, "def_pos": Vector3(0, 0, -1.5), "desc": "P2 Attacker (+Z) vs P1 Defender (-Z)"}
	]
	
	for cfg in configs:
		var atk: Fighter = Fighter.new()
		var def: Fighter = Fighter.new()
		root.add_child(atk)
		root.add_child(def)
		
		atk.character_id = cfg["atk_id"]
		atk.player_index = cfg["atk_slot"]
		def.character_id = cfg["def_id"]
		def.player_index = cfg["def_slot"]
		atk.load_character_data()
		def.load_character_data()
		
		atk.position = cfg["atk_pos"]
		def.position = cfg["def_pos"]
		atk.opponent = def
		def.opponent = atk
		
		atk._start_synchronized_throw(def)
		
		var atk_fwd: Vector3 = -atk.transform.basis.z.normalized()
		var def_fwd: Vector3 = -def.transform.basis.z.normalized()
		var expected_atk_dir: Vector3 = (cfg["def_pos"] - cfg["atk_pos"]).normalized()
		var expected_def_dir: Vector3 = (cfg["atk_pos"] - cfg["def_pos"]).normalized()
		
		var atk_facing_dot: float = atk_fwd.dot(expected_atk_dir)
		var def_facing_dot: float = def_fwd.dot(expected_def_dir)
		assert_true(atk_facing_dot > 0.98, "Pass A Facing: Attacker faces defender in %s (dot=%.3f)" % [cfg["desc"], atk_facing_dot])
		assert_true(def_facing_dot > 0.98, "Pass A Facing: Defender faces attacker in %s (dot=%.3f)" % [cfg["desc"], def_facing_dot])
		
		# Advance to post-impact slam
		atk.state_timer = 0.65
		atk._process_synchronized_attacker()
		
		# Slam position must be in front of attacker along attacker forward vector
		var slam_offset: Vector3 = (def.position - atk.position).normalized()
		var slam_in_front: float = slam_offset.dot(atk_fwd)
		assert_true(slam_in_front > 0.95, "Pass A Trajectory: Slam position is in front of attacker in %s (dot=%.3f)" % [cfg["desc"], slam_in_front])
		
		atk.free()
		def.free()

func test_pass_a_resource_aware_pinfall_balance() -> void:
	# 1. Fresh CPU escaping an ordinary pin
	var mm_fresh: MatchManager = MatchManager.new()
	var p1_fresh: Fighter = Fighter.new()
	var p2_fresh: Fighter = Fighter.new()
	var cpu_fresh: CPUController = CPUController.new()
	root.add_child(mm_fresh)
	root.add_child(p1_fresh)
	root.add_child(p2_fresh)
	root.add_child(cpu_fresh)
	
	p1_fresh.character_id = "tophiachu"
	p2_fresh.character_id = "cyraxx"
	p1_fresh.load_character_data()
	p2_fresh.load_character_data()
	p2_fresh.is_cpu = true
	cpu_fresh.fighter = p2_fresh
	p2_fresh.vitality = p2_fresh.max_vitality
	p2_fresh.stamina = p2_fresh.max_stamina
	p1_fresh.position = Vector3.ZERO
	p2_fresh.position = Vector3.ZERO
	mm_fresh.fighter_1 = p1_fresh
	mm_fresh.fighter_2 = p2_fresh
	mm_fresh._setup_match()
	
	p1_fresh._start_pin(p2_fresh)
	var fresh_outcome: Array = ["NONE"]
	var fresh_count_at_break: Array = [0]
	mm_fresh.pin_broken.connect(func(reason):
		fresh_outcome[0] = reason
		fresh_count_at_break[0] = mm_fresh.current_count
	)
	
	for frame in range(240):
		cpu_fresh._physics_process(1.0 / 60.0)
		p1_fresh._physics_process(1.0 / 60.0)
		p2_fresh._physics_process(1.0 / 60.0)
		mm_fresh._physics_process(1.0 / 60.0)
		if fresh_outcome[0] != "NONE":
			break
			
	assert_true(fresh_outcome[0] == "KICKOUT", "Pass A Pinfall: Fresh CPU defender kicks out of pin (Reason: %s)" % fresh_outcome[0])
	assert_true(fresh_count_at_break[0] <= 2, "Pass A Pinfall: Fresh CPU kicks out before referee 3-count (Count: %d)" % fresh_count_at_break[0])
	
	mm_fresh.free()
	p1_fresh.free()
	p2_fresh.free()
	cpu_fresh.free()
	
	# 2. Sufficiently weakened CPU losing a valid pin (15% vitality, 10% stamina)
	var mm_weak: MatchManager = MatchManager.new()
	var p1_weak: Fighter = Fighter.new()
	var p2_weak: Fighter = Fighter.new()
	var cpu_weak: CPUController = CPUController.new()
	root.add_child(mm_weak)
	root.add_child(p1_weak)
	root.add_child(p2_weak)
	root.add_child(cpu_weak)
	
	p1_weak.character_id = "tophiachu"
	p2_weak.character_id = "cyraxx"
	p1_weak.load_character_data()
	p2_weak.load_character_data()
	p2_weak.is_cpu = true
	cpu_weak.fighter = p2_weak
	p2_weak.vitality = p2_weak.max_vitality * 0.15
	p2_weak.stamina = p2_weak.max_stamina * 0.10
	p1_weak.position = Vector3.ZERO
	p2_weak.position = Vector3.ZERO
	mm_weak.fighter_1 = p1_weak
	mm_weak.fighter_2 = p2_weak
	mm_weak._setup_match()
	
	p1_weak._start_pin(p2_weak)
	var weak_outcome: Array = ["NONE"]
	var weak_winner: Array = [null]
	mm_weak.match_ended.connect(func(winner, method):
		weak_outcome[0] = method
		weak_winner[0] = winner
	)
	
	for frame in range(240):
		cpu_weak._physics_process(1.0 / 60.0)
		p1_weak._physics_process(1.0 / 60.0)
		p2_weak._physics_process(1.0 / 60.0)
		mm_weak._physics_process(1.0 / 60.0)
		if weak_outcome[0] != "NONE":
			break
			
	assert_true(weak_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Weakened CPU loses by 3-count pinfall (Outcome: %s)" % weak_outcome[0])
	assert_true(weak_winner[0] == p1_weak, "Pass A Pinfall: Attacker P1 declared match winner over weakened CPU")
	
	mm_weak.free()
	p1_weak.free()
	p2_weak.free()
	cpu_weak.free()
	
	# 3. Exhausted CPU losing a valid pin (0% vitality, 0% stamina)
	var mm_exh: MatchManager = MatchManager.new()
	var p1_exh: Fighter = Fighter.new()
	var p2_exh: Fighter = Fighter.new()
	var cpu_exh: CPUController = CPUController.new()
	root.add_child(mm_exh)
	root.add_child(p1_exh)
	root.add_child(p2_exh)
	root.add_child(cpu_exh)
	
	p1_exh.character_id = "tophiachu"
	p2_exh.character_id = "cyraxx"
	p1_exh.load_character_data()
	p2_exh.load_character_data()
	p2_exh.is_cpu = true
	cpu_exh.fighter = p2_exh
	p2_exh.vitality = 0.0
	p2_exh.stamina = 0.0
	p1_exh.position = Vector3.ZERO
	p2_exh.position = Vector3.ZERO
	mm_exh.fighter_1 = p1_exh
	mm_exh.fighter_2 = p2_exh
	mm_exh._setup_match()
	
	p1_exh._start_pin(p2_exh)
	var exh_outcome: Array = ["NONE"]
	mm_exh.match_ended.connect(func(_winner, method):
		exh_outcome[0] = method
	)
	
	for frame in range(240):
		cpu_exh._physics_process(1.0 / 60.0)
		p1_exh._physics_process(1.0 / 60.0)
		p2_exh._physics_process(1.0 / 60.0)
		mm_exh._physics_process(1.0 / 60.0)
		if exh_outcome[0] != "NONE":
			break
			
	assert_true(exh_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Exhausted CPU (0 HP) loses by 3-count pinfall")
	
	mm_exh.free()
	p1_exh.free()
	p2_exh.free()
	cpu_exh.free()
	
	# 4. Human Input Modes: Hold-to-Resist and Active Mash
	# A) Fresh Human Hold-to-Resist
	var mm_hum_fresh: MatchManager = MatchManager.new()
	var p1_hum_atk: Fighter = Fighter.new()
	var p2_hum_def: Fighter = Fighter.new()
	root.add_child(mm_hum_fresh)
	root.add_child(p1_hum_atk)
	root.add_child(p2_hum_def)
	
	p1_hum_atk.character_id = "tophiachu"
	p2_hum_def.character_id = "cyraxx"
	p1_hum_atk.player_index = 1
	p2_hum_def.player_index = 2
	p1_hum_atk.load_character_data()
	p2_hum_def.load_character_data()
	p2_hum_def.is_cpu = false
	p2_hum_def.vitality = p2_hum_def.max_vitality
	p2_hum_def.stamina = p2_hum_def.max_stamina
	mm_hum_fresh.fighter_1 = p1_hum_atk
	mm_hum_fresh.fighter_2 = p2_hum_def
	mm_hum_fresh._setup_match()
	
	p1_hum_atk._start_pin(p2_hum_def)
	
	# Simulate human hold via Input action press
	Input.action_press("p2_pin")
	for frame in range(60):
		p1_hum_atk._physics_process(1.0 / 60.0)
		p2_hum_def._physics_process(1.0 / 60.0)
		mm_hum_fresh._physics_process(1.0 / 60.0)
	Input.action_release("p2_pin")
		
	assert_true(p2_hum_def.pin_escape_progress > 20.0, "Pass A Pinfall: Fresh human hold-to-resist accumulates escape progress (Observed: %.1f)" % p2_hum_def.pin_escape_progress)
	
	mm_hum_fresh.free()
	p1_hum_atk.free()
	p2_hum_def.free()
	
	# B) Exhausted Human Hold-to-Resist suffers 3-count pinfall
	var mm_hum_exh: MatchManager = MatchManager.new()
	var p1_hum_atk2: Fighter = Fighter.new()
	var p2_hum_def2: Fighter = Fighter.new()
	root.add_child(mm_hum_exh)
	root.add_child(p1_hum_atk2)
	root.add_child(p2_hum_def2)
	
	p1_hum_atk2.character_id = "tophiachu"
	p2_hum_def2.character_id = "cyraxx"
	p1_hum_atk2.player_index = 1
	p2_hum_def2.player_index = 2
	p1_hum_atk2.load_character_data()
	p2_hum_def2.load_character_data()
	p2_hum_def2.is_cpu = false
	p2_hum_def2.vitality = 0.0
	p2_hum_def2.stamina = 0.0
	mm_hum_exh.fighter_1 = p1_hum_atk2
	mm_hum_exh.fighter_2 = p2_hum_def2
	mm_hum_exh._setup_match()
	
	p1_hum_atk2._start_pin(p2_hum_def2)
	var hum_exh_outcome: Array = ["NONE"]
	mm_hum_exh.match_ended.connect(func(_w, m): hum_exh_outcome[0] = m)
	
	Input.action_press("p2_pin")
	for frame in range(240):
		p1_hum_atk2._physics_process(1.0 / 60.0)
		p2_hum_def2._physics_process(1.0 / 60.0)
		mm_hum_exh._physics_process(1.0 / 60.0)
		if hum_exh_outcome[0] != "NONE":
			break
	Input.action_release("p2_pin")
			
	assert_true(hum_exh_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Exhausted human holding pin button loses by 3-count pinfall")
	
	mm_hum_exh.free()
	p1_hum_atk2.free()
	p2_hum_def2.free()
	
	# C) Fresh Human Mashing Input kicks out
	var mm_mash_fresh: MatchManager = MatchManager.new()
	var p1_mash_atk: Fighter = Fighter.new()
	var p2_mash_def: Fighter = Fighter.new()
	root.add_child(mm_mash_fresh)
	root.add_child(p1_mash_atk)
	root.add_child(p2_mash_def)
	p1_mash_atk.character_id = "tophiachu"
	p2_mash_def.character_id = "cyraxx"
	p1_mash_atk.player_index = 1
	p2_mash_def.player_index = 2
	p1_mash_atk.load_character_data()
	p2_mash_def.load_character_data()
	p2_mash_def.is_cpu = false
	p2_mash_def.vitality = p2_mash_def.max_vitality
	p2_mash_def.stamina = p2_mash_def.max_stamina
	mm_mash_fresh.fighter_1 = p1_mash_atk
	mm_mash_fresh.fighter_2 = p2_mash_def
	mm_mash_fresh._setup_match()
	p1_mash_atk._start_pin(p2_mash_def)
	var mash_fresh_outcome: Array = ["NONE"]
	mm_mash_fresh.pin_broken.connect(func(r): mash_fresh_outcome[0] = r)
	for frame in range(240):
		if frame % 6 == 0:
			Input.action_press("p2_pin")
		else:
			Input.action_release("p2_pin")
		p1_mash_atk._physics_process(1.0 / 60.0)
		p2_mash_def._physics_process(1.0 / 60.0)
		mm_mash_fresh._physics_process(1.0 / 60.0)
		if mash_fresh_outcome[0] != "NONE":
			break
	Input.action_release("p2_pin")
	assert_true(mash_fresh_outcome[0] == "KICKOUT", "Pass A Pinfall: Fresh human mashing kicks out of pin")
	mm_mash_fresh.free()
	p1_mash_atk.free()
	p2_mash_def.free()
	
	# D) Exhausted Human Mashing Input (0% HP) loses by pinfall despite mashing
	var mm_mash_exh: MatchManager = MatchManager.new()
	var p1_mash_atk2: Fighter = Fighter.new()
	var p2_mash_def2: Fighter = Fighter.new()
	root.add_child(mm_mash_exh)
	root.add_child(p1_mash_atk2)
	root.add_child(p2_mash_def2)
	p1_mash_atk2.character_id = "tophiachu"
	p2_mash_def2.character_id = "cyraxx"
	p1_mash_atk2.player_index = 1
	p2_mash_def2.player_index = 2
	p1_mash_atk2.load_character_data()
	p2_mash_def2.load_character_data()
	p2_mash_def2.is_cpu = false
	p2_mash_def2.vitality = 0.0
	p2_mash_def2.stamina = 0.0
	mm_mash_exh.fighter_1 = p1_mash_atk2
	mm_mash_exh.fighter_2 = p2_mash_def2
	mm_mash_exh._setup_match()
	p1_mash_atk2._start_pin(p2_mash_def2)
	var mash_exh_outcome: Array = ["NONE"]
	mm_mash_exh.match_ended.connect(func(_w, m): mash_exh_outcome[0] = m)
	for frame in range(240):
		if frame % 6 == 0:
			Input.action_press("p2_pin")
		else:
			Input.action_release("p2_pin")
		p1_mash_atk2._physics_process(1.0 / 60.0)
		p2_mash_def2._physics_process(1.0 / 60.0)
		mm_mash_exh._physics_process(1.0 / 60.0)
		if mash_exh_outcome[0] != "NONE":
			break
	Input.action_release("p2_pin")
	assert_true(mash_exh_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Exhausted human mashing at 10 Hz still loses by 3-count pinfall")
	mm_mash_exh.free()
	p1_mash_atk2.free()
	p2_mash_def2.free()
	
	# 5. Slot Inversion (P2 Attacker vs P1 CPU Defender)
	var mm_inv: MatchManager = MatchManager.new()
	var p1_inv: Fighter = Fighter.new()
	var p2_inv: Fighter = Fighter.new()
	var cpu_inv: CPUController = CPUController.new()
	root.add_child(mm_inv)
	root.add_child(p2_inv)
	root.add_child(p1_inv)
	root.add_child(cpu_inv)
	
	p1_inv.character_id = "cyraxx"
	p2_inv.character_id = "tophiachu"
	p1_inv.player_index = 1
	p2_inv.player_index = 2
	p1_inv.load_character_data()
	p2_inv.load_character_data()
	p1_inv.is_cpu = true
	cpu_inv.fighter = p1_inv
	p1_inv.vitality = 0.0
	p1_inv.stamina = 0.0
	mm_inv.fighter_1 = p1_inv
	mm_inv.fighter_2 = p2_inv
	mm_inv._setup_match()
	
	p2_inv._start_pin(p1_inv)
	var inv_winner: Array = [null]
	var inv_outcome: Array = ["NONE"]
	mm_inv.match_ended.connect(func(w, m):
		inv_winner[0] = w
		inv_outcome[0] = m
	)
	
	for frame in range(240):
		cpu_inv._physics_process(1.0 / 60.0)
		p2_inv._physics_process(1.0 / 60.0)
		p1_inv._physics_process(1.0 / 60.0)
		mm_inv._physics_process(1.0 / 60.0)
		if inv_outcome[0] != "NONE":
			break
			
	assert_true(inv_outcome[0] == "PINFALL (3-COUNT)" and inv_winner[0] == p2_inv, "Pass A Pinfall: Slot Inversion (P2 Attacker wins over P1 CPU Defender)")
	
	mm_inv.free()
	p1_inv.free()
	p2_inv.free()
	cpu_inv.free()
	
	# 6. Tree Processing Order Inversion (Defender added before Attacker)
	var mm_order: MatchManager = MatchManager.new()
	var p1_ord: Fighter = Fighter.new()
	var p2_ord: Fighter = Fighter.new()
	var cpu_ord: CPUController = CPUController.new()
	root.add_child(mm_order)
	root.add_child(p2_ord)
	root.add_child(p1_ord)
	root.add_child(cpu_ord)
	
	p1_ord.character_id = "tophiachu"
	p2_ord.character_id = "cyraxx"
	p1_ord.load_character_data()
	p2_ord.load_character_data()
	p2_ord.is_cpu = true
	cpu_ord.fighter = p2_ord
	p2_ord.vitality = 0.0
	p2_ord.stamina = 0.0
	mm_order.fighter_1 = p1_ord
	mm_order.fighter_2 = p2_ord
	mm_order._setup_match()
	
	p1_ord._start_pin(p2_ord)
	var ord_outcome: Array = ["NONE"]
	mm_order.match_ended.connect(func(_w, m): ord_outcome[0] = m)
	
	for frame in range(240):
		p2_ord._physics_process(1.0 / 60.0)
		cpu_ord._physics_process(1.0 / 60.0)
		p1_ord._physics_process(1.0 / 60.0)
		mm_order._physics_process(1.0 / 60.0)
		if ord_outcome[0] != "NONE":
			break
			
	assert_true(ord_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Tree processing order inversion resolves deterministic 3-count pinfall")
	
	mm_order.free()
	p1_ord.free()
	p2_ord.free()
	cpu_ord.free()
	
	# 7. Rope Break Priority competing with Pin Count
	var mm_rope: MatchManager = MatchManager.new()
	var p1_rope: Fighter = Fighter.new()
	var p2_rope: Fighter = Fighter.new()
	root.add_child(mm_rope)
	root.add_child(p1_rope)
	root.add_child(p2_rope)
	
	p1_rope.character_id = "tophiachu"
	p2_rope.character_id = "cyraxx"
	p1_rope.load_character_data()
	p2_rope.load_character_data()
	p2_rope.vitality = 0.0
	p2_rope.stamina = 0.0
	p1_rope.position = Vector3(3.3, 0, 0)
	p2_rope.position = Vector3(3.3, 0, 0)
	mm_rope.fighter_1 = p1_rope
	mm_rope.fighter_2 = p2_rope
	mm_rope._setup_match()
	
	var rope_break_called: Array = [false]
	mm_rope.rope_break_called.connect(func(): rope_break_called[0] = true)
	
	p1_rope._start_pin(p2_rope)
	
	for frame in range(10):
		p1_rope._physics_process(1.0 / 60.0)
		p2_rope._physics_process(1.0 / 60.0)
		mm_rope._physics_process(1.0 / 60.0)
		
	assert_true(rope_break_called[0], "Pass A Pinfall: Pin near ropes immediately triggers rope break alert")
	assert_true(mm_rope.current_state == MatchManager.MatchState.IN_PROGRESS, "Pass A Pinfall: Match state returns to IN_PROGRESS on rope break")
	assert_true(mm_rope.current_count == 0, "Pass A Pinfall: Pin count aborted at 0 on rope break")
	
	mm_rope.free()
	p1_rope.free()
	p2_rope.free()

func test_explicit_impact_classification() -> void:
	var f: Fighter = Fighter.new()
	f.character_id = "cyraxx"
	f.load_character_data()
	
	# 1. Ordinary heavy attack (amount = 177.0, is_finisher = false)
	f.receive_damage(177.0, null, false, false)
	assert_true(f.recent_finisher_impact_timer == 0.0, "Impact Classification: Ordinary heavy throw does not set finisher disorientation")
	assert_true(f.recent_heavy_impact_timer == MatchRules.HEAVY_IMPACT_DISORIENTATION_DURATION, "Impact Classification: Ordinary heavy throw sets 1.5s heavy impact timer")
	
	# 2. Genuine finisher attack (amount = 177.0, is_finisher = true)
	f.receive_damage(177.0, null, false, true)
	assert_true(f.recent_finisher_impact_timer == MatchRules.FINISHER_DISORIENTATION_DURATION, "Impact Classification: Genuine finisher sets 4.5s finisher disorientation")
	assert_true(f.recent_heavy_impact_timer == 0.0, "Impact Classification: Genuine finisher overrides heavy impact disorientation")
	
	f.free()

func test_pass_a_boundary_safe_paired_throws() -> void:
	var boundary_cases = [
		{"name": "East Edge (+X)", "atk": Vector3(2.8, 0, 0), "def": Vector3(3.4, 0, 0)},
		{"name": "West Edge (-X)", "atk": Vector3(-2.8, 0, 0), "def": Vector3(-3.4, 0, 0)},
		{"name": "North Edge (+Z)", "atk": Vector3(0, 0, 2.8), "def": Vector3(0, 0, 3.4)},
		{"name": "South Edge (-Z)", "atk": Vector3(0, 0, -2.8), "def": Vector3(0, 0, -3.4)},
		{"name": "NE Corner (+X, +Z)", "atk": Vector3(2.5, 0, 2.5), "def": Vector3(3.1, 0, 3.1)},
		{"name": "NW Corner (-X, +Z)", "atk": Vector3(-2.5, 0, 2.5), "def": Vector3(-3.1, 0, 3.1)},
		{"name": "SE Corner (+X, -Z)", "atk": Vector3(2.5, 0, -2.5), "def": Vector3(3.1, 0, -3.1)},
		{"name": "SW Corner (-X, -Z)", "atk": Vector3(-2.5, 0, -2.5), "def": Vector3(-3.1, 0, -3.1)}
	]
	
	for tc in boundary_cases:
		for invert_slots in [false, true]:
			for invert_tree in [false, true]:
				var tag = "%s [%s/%s]" % [
					tc["name"],
					"P2Atk" if invert_slots else "P1Atk",
					"TreeInv" if invert_tree else "TreeNorm"
				]
				
				var p1: Fighter = Fighter.new()
				var p2: Fighter = Fighter.new()
				
				if invert_tree:
					root.add_child(p2)
					root.add_child(p1)
				else:
					root.add_child(p1)
					root.add_child(p2)
					
				p1.character_id = "tophiachu" if not invert_slots else "cyraxx"
				p2.character_id = "cyraxx" if not invert_slots else "tophiachu"
				p1.player_index = 1
				p2.player_index = 2
				p1.load_character_data()
				p2.load_character_data()
				
				var atk: Fighter = p2 if invert_slots else p1
				var def: Fighter = p1 if invert_slots else p2
				
				atk.position = tc["atk"]
				def.position = tc["def"]
				
				atk._start_synchronized_throw(def)
				
				var max_defender_radius: float = 0.0
				for frame in range(70):
					p1._physics_process(1.0 / 60.0)
					p2._physics_process(1.0 / 60.0)
					var def_r: float = max(abs(def.position.x), abs(def.position.z))
					max_defender_radius = max(max_defender_radius, def_r)
					
				assert_true(max_defender_radius <= MatchRules.THROW_SAFE_RING_BOUND + 0.01, "Boundary Throw: Defender remains strictly inside ring boundary (%s, max: %.2fm)" % [tag, max_defender_radius])
				assert_true(atk.current_state == Fighter.State.IDLE, "Boundary Throw: Attacker returns to IDLE (%s)" % tag)
				assert_true(def.current_state == Fighter.State.KNOCKED_DOWN, "Boundary Throw: Defender enters KNOCKED_DOWN (%s)" % tag)
				
				# Check for snap-back on subsequent frame when _clamp_within_ring runs on KNOCKED_DOWN
				var pos_at_release: Vector3 = def.position
				for frame in range(5):
					p1._physics_process(1.0 / 60.0)
					p2._physics_process(1.0 / 60.0)
				var pos_after: Vector3 = def.position
				assert_true(pos_at_release.distance_to(pos_after) < 0.01, "Boundary Throw: Zero snap-back on ground release (%s)" % tag)
				
				p1.free()
				p2.free()

func test_pass_a_strike_directional_cone() -> void:
	# Test forward cone validation for strikes (120 degree cone, STRIKE_CONE_MIN_DOT = 0.50)
	var attacker: Fighter = Fighter.new()
	var defender: Fighter = Fighter.new()
	attacker.character_id = "tophiachu"
	defender.character_id = "cyraxx"
	attacker.load_character_data()
	defender.load_character_data()
	attacker.opponent = defender
	defender.opponent = attacker
	
	# Test 1: Defender directly in front at (0, 0, -0.8) (0 deg) -> CONNECTS
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = 0.0 # Facing -Z
	defender.position = Vector3(0, 0, -0.8)
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(attacker.attack_has_damaged, "Strike Cone [0 deg In Front]: Attack marks as damaged")
	assert_true(defender.vitality < defender.max_vitality, "Strike Cone [0 deg In Front]: Defender takes damage")
	
	# Test 2: Defender angled at 45 deg (-0.56, 0, -0.56) (dist = 0.79m, dot = 0.707 >= 0.50) -> CONNECTS
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = 0.0 # Facing -Z
	defender.position = Vector3(-0.56, 0, -0.56)
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(attacker.attack_has_damaged, "Strike Cone [45 deg Angled]: Attack marks as damaged")
	assert_true(defender.vitality < defender.max_vitality, "Strike Cone [45 deg Angled]: Defender takes damage")
	
	# Test 3: Defender directly to the right at (0.8, 0, 0) (90 deg flank, dot = 0.0 < 0.50) -> MISSES
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = 0.0 # Facing -Z
	defender.position = Vector3(0.8, 0, 0)
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(not attacker.attack_has_damaged, "Strike Cone [90 deg Flank]: Attack does NOT mark as damaged")
	assert_true(defender.vitality == defender.max_vitality, "Strike Cone [90 deg Flank]: Defender takes zero damage")
	
	# Test 4: Defender directly behind at (0, 0, 0.8) (180 deg, dot = -1.0 < 0.50) -> MISSES
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = 0.0 # Facing -Z
	defender.position = Vector3(0, 0, 0.8)
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(not attacker.attack_has_damaged, "Strike Cone [180 deg Behind]: Attack does NOT mark as damaged")
	assert_true(defender.vitality == defender.max_vitality, "Strike Cone [180 deg Behind]: Defender takes zero damage")
	
	# Test 5: Attacker rotated to face right (+X, rotation.y = -PI/2)
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = -PI / 2.0 # Facing +X
	defender.position = Vector3(0.8, 0, 0) # Directly in front of rotated attacker!
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(attacker.attack_has_damaged, "Strike Cone [Rotated Attacker Facing +X]: Attack hits defender at +X")
	assert_true(defender.vitality < defender.max_vitality, "Strike Cone [Rotated Attacker Facing +X]: Defender at +X takes damage")
	
	attacker.free()
	defender.free()

func test_pass_a_grapple_startup_and_interruption() -> void:
	# Test 1: Grapple startup initiation and facing alignment
	var atk: Fighter = Fighter.new()
	var def: Fighter = Fighter.new()
	atk.character_id = "tophiachu"
	def.character_id = "cyraxx"
	atk.load_character_data()
	def.load_character_data()
	atk.opponent = def
	def.opponent = atk
	
	atk.position = Vector3(-0.5, 0, 0)
	def.position = Vector3(0.5, 0, 0)
	def._set_state(Fighter.State.IDLE)
	
	atk._attempt_grapple(false)
	assert_true(atk.current_state == Fighter.State.GRAPPLE_STARTUP, "Grapple Startup: Attacker enters GRAPPLE_STARTUP")
	assert_true(atk.grapple_target == def, "Grapple Startup: Attacker locks target reference")
	assert_true(atk.state_timer == 0.0, "Grapple Startup: State timer initialized to 0.0")
	
	# Test 2: Clean uninterrupted grapple transitions to throw at GRAPPLE_STARTUP_DURATION
	for frame in range(12): # ~0.20s > 0.18s
		atk._physics_process(1.0 / 60.0)
		def._physics_process(1.0 / 60.0)
		
	assert_true(atk.current_state == Fighter.State.GRAPPLING_ATTACKER, "Grapple Startup: Clean startup transitions to GRAPPLING_ATTACKER")
	assert_true(def.current_state == Fighter.State.GRAPPLING_DEFENDER, "Grapple Startup: Defender transitions to GRAPPLING_DEFENDER")
	
	atk.free()
	def.free()
	
	# Test 3: Strike interruption during grapple startup
	var atk2: Fighter = Fighter.new()
	var def2: Fighter = Fighter.new()
	atk2.character_id = "tophiachu"
	def2.character_id = "cyraxx"
	atk2.load_character_data()
	def2.load_character_data()
	atk2.opponent = def2
	def2.opponent = atk2
	
	atk2.position = Vector3(-0.5, 0, 0)
	def2.position = Vector3(0.5, 0, 0)
	def2._set_state(Fighter.State.IDLE)
	
	atk2._attempt_grapple(false)
	assert_true(atk2.current_state == Fighter.State.GRAPPLE_STARTUP, "Grapple Interrupt: Attacker starts in GRAPPLE_STARTUP")
	
	# Advance 3 frames into startup (0.05s < 0.18s)
	for frame in range(3):
		atk2._physics_process(1.0 / 60.0)
		def2._physics_process(1.0 / 60.0)
	
	# Defender strikes and interrupts attacker!
	atk2.receive_damage(35.0, def2, false)
	assert_true(atk2.current_state == Fighter.State.IDLE, "Grapple Interrupt: Attacker interrupted out of GRAPPLE_STARTUP back to IDLE")
	assert_true(atk2.grapple_target == null, "Grapple Interrupt: Grapple target cleared on interrupt")
	
	# Advance further past original startup duration: verify throw NEVER occurs
	for frame in range(15):
		atk2._physics_process(1.0 / 60.0)
		def2._physics_process(1.0 / 60.0)
		
	assert_true(atk2.current_state != Fighter.State.GRAPPLING_ATTACKER, "Grapple Interrupt: Attacker does NOT execute throw after interrupt")
	assert_true(def2.current_state != Fighter.State.GRAPPLING_DEFENDER, "Grapple Interrupt: Defender was NOT thrown")
	
	atk2.free()
	def2.free()
	
	# Test 4: Reversal countering grapple startup
	var atk3: Fighter = Fighter.new()
	var def3: Fighter = Fighter.new()
	atk3.character_id = "tophiachu"
	def3.character_id = "cyraxx"
	atk3.load_character_data()
	def3.load_character_data()
	atk3.opponent = def3
	def3.opponent = atk3
	
	atk3.position = Vector3(-0.5, 0, 0)
	def3.position = Vector3(0.5, 0, 0)
	def3._set_state(Fighter.State.IDLE)
	
	atk3._attempt_grapple(false)
	assert_true(atk3.current_state == Fighter.State.GRAPPLE_STARTUP, "Grapple Reversal: Attacker enters GRAPPLE_STARTUP")
	
	# Defender inputs reversal stance during startup
	def3._set_state(Fighter.State.REVERSAL_STANCE)
	
	# Tick past startup duration (0.18s)
	for frame in range(12):
		atk3._physics_process(1.0 / 60.0)
		def3._physics_process(1.0 / 60.0)
		
	assert_true(atk3.current_state == Fighter.State.KNOCKED_DOWN, "Grapple Reversal: Attacker countered and knocked down")
	assert_true(def3.hype > 0.0, "Grapple Reversal: Defender awarded counter hype")
	
	atk3.free()
	def3.free()

func test_pass_a_simultaneous_submission_ordering() -> void:
	# Test simultaneous submission resolution across slot inversions and tree processing orders
	for invert_slots in [false, true]:
		for invert_tree in [false, true]:
			var tag: String = "[Slot%s/Tree%s]" % ["Inv" if invert_slots else "Norm", "Inv" if invert_tree else "Norm"]
			
			var manager: MatchManager = MatchManager.new()
			var p1: Fighter = Fighter.new()
			var p2: Fighter = Fighter.new()
			p1.character_id = "tophiachu"
			p2.character_id = "cyraxx"
			p1.player_index = 1
			p2.player_index = 2
			p1.load_character_data()
			p2.load_character_data()
			
			# Scene tree insertion order
			if invert_tree:
				root.add_child(p2)
				root.add_child(p1)
			else:
				root.add_child(p1)
				root.add_child(p2)
			root.add_child(manager)
			
			manager.fighter_1 = p1
			manager.fighter_2 = p2
			manager._setup_match()
			
			var atk: Fighter = p2 if invert_slots else p1
			var def: Fighter = p1 if invert_slots else p2
			
			def.current_state = Fighter.State.KNOCKED_DOWN
			atk.position = Vector3(0, 0, 0)
			def.position = Vector3(0, 0, 0.5)
			
			atk._attempt_submission(false)
			assert_true(manager.current_state == MatchManager.MatchState.SUBMISSION_ATTEMPT, "Simultaneous Submission: In SUBMISSION_ATTEMPT (%s)" % tag)
			
			# Connect match_ended monitor
			var match_ended_called: Array = [false]
			manager.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
			
			# Seed legitimate below-threshold resources: vitality > 0, escape progress < 100, pressure tick due
			def.vitality = 5.0
			def.pin_escape_progress = 95.0
			atk.submission_tick_timer = 0.49 # Tick occurs at 0.50 (due on 1/60s frame)
			def.input_pin = true # Valid mash input adding 15.0 to escape progress
			
			# Process frame according to tree order
			if invert_tree:
				p2._physics_process(1.0 / 60.0)
				p1._physics_process(1.0 / 60.0)
			else:
				p1._physics_process(1.0 / 60.0)
				p2._physics_process(1.0 / 60.0)
			manager._physics_process(1.0 / 60.0)
			
			# Under ESCAPE_BREAKS policy: escape waives off tap-out, match continues
			assert_true(not match_ended_called[0], "Simultaneous Submission: match_ended NOT emitted on simultaneous escape (%s)" % tag)
			assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Simultaneous Submission: Match returns to IN_PROGRESS (%s)" % tag)
			assert_true(atk.current_state == Fighter.State.IDLE, "Simultaneous Submission: Attacker returns to IDLE (%s)" % tag)
			assert_true(def.current_state == Fighter.State.GETTING_UP, "Simultaneous Submission: Defender enters GETTING_UP (%s)" % tag)
			assert_true(def.vitality == 1.0, "Simultaneous Submission: Defender granted 1.0 HP clutch survival (%s)" % tag)
			assert_true(atk.synchronized_partner == null, "Simultaneous Submission: Attacker synchronized_partner null (%s)" % tag)
			assert_true(def.synchronized_partner == null, "Simultaneous Submission: Defender synchronized_partner null (%s)" % tag)
			
			# Assert post-result stability across subsequent ticks
			for _f in range(10):
				p1._physics_process(1.0 / 60.0)
				p2._physics_process(1.0 / 60.0)
				manager._physics_process(1.0 / 60.0)
			assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Simultaneous Submission: Match remains IN_PROGRESS over later ticks (%s)" % tag)
			assert_true(atk.current_state == Fighter.State.IDLE, "Simultaneous Submission: Attacker remains IDLE (%s)" % tag)
			assert_true(def.current_state in [Fighter.State.GETTING_UP, Fighter.State.IDLE], "Simultaneous Submission: Defender remains in legal state (%s)" % tag)
			assert_true(atk.synchronized_partner == null and def.synchronized_partner == null, "Simultaneous Submission: Pairing remains null over later ticks (%s)" % tag)
			
			manager.free()
			p1.free()
			p2.free()

	# Test alternate policy: TAPOUT_WINS with legitimate below-threshold crossing
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.TAPOUT_WINS
	var man_tap: MatchManager = MatchManager.new()
	var f1: Fighter = Fighter.new()
	var f2: Fighter = Fighter.new()
	f1.character_id = "tophiachu"
	f2.character_id = "cyraxx"
	f1.player_index = 1
	f2.player_index = 2
	f1.load_character_data()
	f2.load_character_data()
	root.add_child(f1)
	root.add_child(f2)
	root.add_child(man_tap)
	man_tap.fighter_1 = f1
	man_tap.fighter_2 = f2
	man_tap._setup_match()
	
	f2.current_state = Fighter.State.KNOCKED_DOWN
	f1.position = Vector3(0, 0, 0)
	f2.position = Vector3(0, 0, 0.5)
	f1._attempt_submission(false)
	
	var tapout_winner: Array = [null]
	man_tap.match_ended.connect(func(w, _m): tapout_winner[0] = w)
	
	f2.vitality = 5.0
	f2.pin_escape_progress = 95.0
	f1.submission_tick_timer = 0.49
	f2.input_pin = true
	
	f1._physics_process(1.0 / 60.0)
	f2._physics_process(1.0 / 60.0)
	man_tap._physics_process(1.0 / 60.0)
	
	assert_true(tapout_winner[0] == f1, "Simultaneous Submission [TAPOUT_WINS]: Attacker declared winner on simultaneous frame")
	assert_true(man_tap.current_state == MatchManager.MatchState.MATCH_OVER, "Simultaneous Submission [TAPOUT_WINS]: Match state is MATCH_OVER")
	assert_true(f1.current_state == Fighter.State.VICTORY, "Simultaneous Submission [TAPOUT_WINS]: Winner in VICTORY state")
	assert_true(f2.current_state == Fighter.State.DEFEATED, "Simultaneous Submission [TAPOUT_WINS]: Loser in DEFEATED state")
	assert_true(f1.synchronized_partner == null and f2.synchronized_partner == null, "Simultaneous Submission [TAPOUT_WINS]: Hold pointers cleared symmetrically")
	
	# Advance 10 ticks: assert winner and loser remain in terminal states and NEVER get up
	for _f in range(10):
		f1._physics_process(1.0 / 60.0)
		f2._physics_process(1.0 / 60.0)
		man_tap._physics_process(1.0 / 60.0)
	assert_true(man_tap.current_state == MatchManager.MatchState.MATCH_OVER, "Simultaneous Submission [TAPOUT_WINS]: Match remains MATCH_OVER over later ticks")
	assert_true(f1.current_state == Fighter.State.VICTORY, "Simultaneous Submission [TAPOUT_WINS]: Winner remains in VICTORY over later ticks")
	assert_true(f2.current_state == Fighter.State.DEFEATED, "Simultaneous Submission [TAPOUT_WINS]: Loser strictly remains in DEFEATED over later ticks (never revives)")
	assert_true(f1.synchronized_partner == null and f2.synchronized_partner == null, "Simultaneous Submission [TAPOUT_WINS]: Pairing remains null over later ticks")
	
	man_tap.free()
	f1.free()
	f2.free()
	
	# Restore default policy
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.ESCAPE_BREAKS

func test_pass_a_callback_state_overwrite_resilience() -> void:
	# Test Case 1: TAPOUT_WINS policy exercised through defender._execute_submission_escape() emission path
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.TAPOUT_WINS
	var m1: MatchManager = MatchManager.new()
	var a1: Fighter = Fighter.new()
	var d1: Fighter = Fighter.new()
	a1.character_id = "tophiachu"
	d1.character_id = "cyraxx"
	a1.load_character_data()
	d1.load_character_data()
	root.add_child(a1)
	root.add_child(d1)
	root.add_child(m1)
	m1.fighter_1 = a1
	m1.fighter_2 = d1
	m1._setup_match()
	
	d1.current_state = Fighter.State.KNOCKED_DOWN
	a1.position = Vector3(0, 0, 0)
	d1.position = Vector3(0, 0, 0.5)
	a1._attempt_submission(false)
	
	# Both conditions met on callback execution
	d1.vitality = 0.0
	d1.pin_escape_progress = 100.0
	
	# Directly invoke defender escape emission
	d1._execute_submission_escape()
	
	# Assert manager and participants immediately after callback returns
	assert_true(m1.current_state == MatchManager.MatchState.MATCH_OVER, "Callback Overwrite [TAPOUT_WINS]: Match is MATCH_OVER")
	assert_true(a1.current_state == Fighter.State.VICTORY, "Callback Overwrite [TAPOUT_WINS]: Attacker is in VICTORY")
	assert_true(d1.current_state == Fighter.State.DEFEATED, "Callback Overwrite [TAPOUT_WINS]: Defender is DEFEATED (not overwritten with GETTING_UP)")
	assert_true(a1.synchronized_partner == null and d1.synchronized_partner == null, "Callback Overwrite [TAPOUT_WINS]: Partners cleared")
	
	# Step 10 ticks: ensure defender NEVER transitions out of DEFEATED
	for _f in range(10):
		a1._physics_process(1.0 / 60.0)
		d1._physics_process(1.0 / 60.0)
		m1._physics_process(1.0 / 60.0)
	assert_true(d1.current_state == Fighter.State.DEFEATED, "Callback Overwrite [TAPOUT_WINS]: Defender remains strictly DEFEATED over later ticks")
	assert_true(m1.current_state == MatchManager.MatchState.MATCH_OVER, "Callback Overwrite [TAPOUT_WINS]: Match state remains MATCH_OVER")
	
	m1.free()
	a1.free()
	d1.free()
	
	# Test Case 2: ESCAPE_BREAKS policy exercised through defender.on_tap_out() emission path
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.ESCAPE_BREAKS
	var m2: MatchManager = MatchManager.new()
	var a2: Fighter = Fighter.new()
	var d2: Fighter = Fighter.new()
	a2.character_id = "tophiachu"
	d2.character_id = "cyraxx"
	a2.load_character_data()
	d2.load_character_data()
	root.add_child(a2)
	root.add_child(d2)
	root.add_child(m2)
	m2.fighter_1 = a2
	m2.fighter_2 = d2
	m2._setup_match()
	
	d2.current_state = Fighter.State.KNOCKED_DOWN
	a2.position = Vector3(0, 0, 0)
	d2.position = Vector3(0, 0, 0.5)
	a2._attempt_submission(false)
	
	# Both conditions met on callback execution
	d2.vitality = 0.0
	d2.pin_escape_progress = 100.0
	
	# Directly invoke defender tap-out emission
	d2.on_tap_out()
	
	# Assert manager and participants immediately after callback returns
	assert_true(m2.current_state == MatchManager.MatchState.IN_PROGRESS, "Callback Overwrite [ESCAPE_BREAKS]: Match remains IN_PROGRESS")
	assert_true(a2.current_state == Fighter.State.IDLE, "Callback Overwrite [ESCAPE_BREAKS]: Attacker is in IDLE")
	assert_true(d2.current_state == Fighter.State.GETTING_UP, "Callback Overwrite [ESCAPE_BREAKS]: Defender is in GETTING_UP (not overwritten with DEFEATED)")
	assert_true(d2.vitality == 1.0, "Callback Overwrite [ESCAPE_BREAKS]: Defender granted 1.0 HP clutch survival")
	assert_true(a2.synchronized_partner == null and d2.synchronized_partner == null, "Callback Overwrite [ESCAPE_BREAKS]: Partners cleared")
	
	# Step 10 ticks: ensure match remains in progress and defender recovers cleanly
	for _f in range(10):
		a2._physics_process(1.0 / 60.0)
		d2._physics_process(1.0 / 60.0)
		m2._physics_process(1.0 / 60.0)
	assert_true(m2.current_state == MatchManager.MatchState.IN_PROGRESS, "Callback Overwrite [ESCAPE_BREAKS]: Match remains IN_PROGRESS over later ticks")
	assert_true(d2.current_state in [Fighter.State.GETTING_UP, Fighter.State.IDLE], "Callback Overwrite [ESCAPE_BREAKS]: Defender in legal recovery state")
	
	m2.free()
	a2.free()
	d2.free()

func test_pass_a_final_count_escape_crossing() -> void:
	# Test real 99 -> 100+ escape threshold crossing on tick 198 (3.30s)
	# Check both manager-first and defender-first scene arrangements
	for manager_first in [true, false]:
		var tag: String = "[%s]" % ["ManagerFirst" if manager_first else "DefenderFirst"]
		
		var manager: MatchManager = MatchManager.new()
		var pinner: Fighter = Fighter.new()
		var pinned: Fighter = Fighter.new()
		pinner.character_id = "tophiachu"
		pinned.character_id = "cyraxx"
		pinner.load_character_data()
		pinned.load_character_data()
		
		if manager_first:
			root.add_child(manager)
			root.add_child(pinner)
			root.add_child(pinned)
		else:
			root.add_child(pinned)
			root.add_child(pinner)
			root.add_child(manager)
			
		manager.fighter_1 = pinner
		manager.fighter_2 = pinned
		manager._setup_match()
		
		pinned.current_state = Fighter.State.KNOCKED_DOWN
		pinner.position = Vector3(0, 0, 0)
		pinned.position = Vector3(0, 0, 0.5)
		pinner._attempt_pin()
		
		# Seed exact state at count 2, timer 3.29s (tick 197 at 60Hz), progress 99.0
		manager.current_count = 2
		manager.pin_timer = 3.29
		pinned.pin_escape_progress = 99.0
		
		var match_ended_called: Array = [false]
		manager.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
		
		# Valid mash command that adds ~10.0 progress across the tick
		pinned.input_pin = true
		
		# Execute tick with priority order (pinned at priority 0 processes before manager at priority 10)
		pinned._physics_process(1.0 / 60.0)
		pinner._physics_process(1.0 / 60.0)
		manager._physics_process(1.0 / 60.0)
		
		assert_true(pinned.pin_escape_progress >= 100.0, "Final-Count Escape Crossing: Progress crossed 100 on tick (%s)" % tag)
		assert_true(not match_ended_called[0], "Final-Count Escape Crossing: match_ended was NOT emitted (%s)" % tag)
		assert_true(manager.current_count == 2, "Final-Count Escape Crossing: Count remained 2 (preempted count 3) (%s)" % tag)
		assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Final-Count Escape Crossing: Match returned to IN_PROGRESS (%s)" % tag)
		assert_true(pinned.current_state == Fighter.State.GETTING_UP, "Final-Count Escape Crossing: Defender entered GETTING_UP (%s)" % tag)
		assert_true(pinner.current_state == Fighter.State.IDLE, "Final-Count Escape Crossing: Pinner entered IDLE (%s)" % tag)
		assert_true(pinned.synchronized_partner == null and pinner.synchronized_partner == null, "Final-Count Escape Crossing: Hold cleared (%s)" % tag)
		
		# Step 10 ticks: ensure match remains in progress
		for _f in range(10):
			pinned._physics_process(1.0 / 60.0)
			pinner._physics_process(1.0 / 60.0)
			manager._physics_process(1.0 / 60.0)
		assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Final-Count Escape Crossing: Match remains IN_PROGRESS (%s)" % tag)
		
		manager.free()
		pinner.free()
		pinned.free()

func test_visual_presentation_and_skeletal_rig() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	assert_true(fighter_scene != null, "Presentation Test: fighter.tscn loaded")
	
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	assert_true(fighter.presentation != null, "Presentation Test: FighterPresentation instantiated")
	assert_true(fighter.presentation.has_skeletal_rig == true, "Presentation Test: Tophiachu has_skeletal_rig is true")
	assert_true(fighter.is_rigged() == true, "Presentation Test: Tophiachu is_rigged() reports true")
	assert_true(is_instance_valid(fighter.presentation.skeleton), "Presentation Test: Skeleton3D valid")
	assert_true(is_instance_valid(fighter.presentation.anim_player), "Presentation Test: AnimationPlayer valid")
	
	var skel: Skeleton3D = fighter.presentation.skeleton
	var expected_bones = [
		"Root", "Hips", "Spine", "Chest", "Neck", "Head",
		"Clavicle.L", "Clavicle.R", "UpperArm.L", "UpperArm.R",
		"Forearm.L", "Forearm.R", "Hand.L", "Hand.R",
		"Thigh.L", "Thigh.R", "Shin.L", "Shin.R",
		"Foot.L", "Foot.R", "Toe.L", "Toe.R"
	]
	var all_bones: bool = true
	for b in expected_bones:
		if skel.find_bone(b) == -1:
			all_bones = false
	assert_true(all_bones, "Presentation Test: All 22 canonical humanoid bones verified")
	
	var ap: AnimationPlayer = fighter.presentation.anim_player
	var expected_anims = [
		"idle", "walk", "strike", "knockdown", "getup",
		"block", "reversal", "grapple", "throw_attacker", "throw_defender",
		"pinning", "pinned", "submission_attacker", "submission_defender",
		"victory", "defeated"
	]
	var all_anims: bool = true
	for a in expected_anims:
		if not ap.has_animation(a):
			all_anims = false
	assert_true(all_anims, "Presentation Test: All 16 keyframed clips present in AnimationPlayer")
	
	# Verify looping
	assert_true(ap.get_animation("idle").loop_mode == Animation.LOOP_LINEAR, "Presentation Test: 'idle' loops linearly")
	assert_true(ap.get_animation("walk").loop_mode == Animation.LOOP_LINEAR, "Presentation Test: 'walk' loops linearly")
	
	# Verify visual_root guard
	fighter.current_state = Fighter.State.KNOCKED_DOWN
	fighter._play_state_animation(Fighter.State.KNOCKED_DOWN)
	assert_true(fighter.visual_root.rotation.x == 0.0, "Presentation Test: visual_root.rotation.x remains 0 on rigged fighter")
	
	# Verify unmigrated fallback
	var unmigrated = fighter_scene.instantiate()
	root.add_child(unmigrated)
	unmigrated.load_character_data("cyraxx")
	assert_true(unmigrated.presentation != null, "Presentation Test: Presentation exists for unmigrated fighter")
	assert_true(unmigrated.is_rigged() == false, "Presentation Test: Unmigrated fighter is_rigged() is false")
	
	fighter.queue_free()
	unmigrated.queue_free()



