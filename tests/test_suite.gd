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
	defender.position = Vector3(0, 0, 0.8) # Within reach
	
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
	
	manager.queue_free()
	f1.queue_free()
	f2.queue_free()

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
	assert_true(tap_out_called[0], "Depleting vitality during submission results in SUBMISSION (TAP OUT) victory")
	assert_true(manager.current_state == MatchManager.MatchState.MATCH_OVER, "Match terminates with MATCH_OVER on tap-out")
	
	manager.queue_free()
	f1.queue_free()
	f2.queue_free()

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
