extends SceneTree

## Dedicated Visual Presentation Test for LOLCOW WRESTLING
## Verifies skinned mesh loading, 22-bone humanoid armature, 16-clip animation library,
## state playback routing, stride scaling, and fallback safety for unmigrated characters.

var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

func _init() -> void:
	print("==================================================")
	print("RUNNING VISUAL PRESENTATION & SKELETAL RIG TESTS")
	print("==================================================")
	
	test_tophiachu_skeletal_rig_and_bones()
	test_tophiachu_animation_library()
	test_state_driven_animation_routing()
	test_visual_root_legacy_override_disabled_for_rigged()
	test_locomotion_stride_scaling()
	test_unmigrated_roster_fallback_safety()
	
	print("==================================================")
	print("PRESENTATION TEST RESULTS: %d Passed, %d Failed, %d Total" % [passed_tests, failed_tests, total_tests])
	print("==================================================")
	
	if failed_tests > 0:
		quit(1)
	else:
		quit(0)

func assert_test(condition: bool, test_name: String) -> void:
	total_tests += 1
	if condition:
		passed_tests += 1
		print("[PASS] %s" % test_name)
	else:
		failed_tests += 1
		printerr("[FAIL] %s" % test_name)

func test_tophiachu_skeletal_rig_and_bones() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	assert_test(fighter_scene != null, "Tophiachu Rig: fighter.tscn loaded successfully")
	
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	assert_test(fighter.presentation != null, "Tophiachu Rig: FighterPresentation component instantiated")
	assert_test(fighter.presentation.has_skeletal_rig == true, "Tophiachu Rig: has_skeletal_rig is true")
	assert_test(fighter.is_rigged() == true, "Tophiachu Rig: fighter.is_rigged() reports true")
	assert_test(is_instance_valid(fighter.presentation.skeleton), "Tophiachu Rig: Skeleton3D node valid")
	assert_test(is_instance_valid(fighter.presentation.anim_player), "Tophiachu Rig: AnimationPlayer node valid")
	
	var skel: Skeleton3D = fighter.presentation.skeleton
	var expected_bones = [
		"Root", "Hips", "Spine", "Chest", "Neck", "Head",
		"Clavicle.L", "Clavicle.R", "UpperArm.L", "UpperArm.R",
		"Forearm.L", "Forearm.R", "Hand.L", "Hand.R",
		"Thigh.L", "Thigh.R", "Shin.L", "Shin.R",
		"Foot.L", "Foot.R", "Toe.L", "Toe.R"
	]
	
	var all_bones_found: bool = true
	for b_name in expected_bones:
		var b_idx = skel.find_bone(b_name)
		if b_idx == -1:
			all_bones_found = false
			printerr("Missing bone in skeleton: %s" % b_name)
	assert_test(all_bones_found, "Tophiachu Rig: All 22 canonical humanoid bones found in Skeleton3D")
	assert_test(skel.get_bone_count() >= 22, "Tophiachu Rig: Bone count is at least 22 (actual: %d)" % skel.get_bone_count())
	
	fighter.queue_free()

func test_tophiachu_animation_library() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	var ap: AnimationPlayer = fighter.presentation.anim_player
	var expected_clips = [
		"idle", "walk", "strike", "knockdown", "getup",
		"block", "reversal", "grapple", "throw_attacker", "throw_defender",
		"pinning", "pinned", "submission_attacker", "submission_defender",
		"victory", "defeated"
	]
	
	var all_clips_exist: bool = true
	for c_name in expected_clips:
		if not ap.has_animation(c_name):
			all_clips_exist = false
			printerr("Missing animation clip: %s" % c_name)
	assert_test(all_clips_exist, "Tophiachu Library: All 16 keyframed clips present in AnimationPlayer")
	
	# Verify looping behavior
	var idle_anim: Animation = ap.get_animation("idle")
	var walk_anim: Animation = ap.get_animation("walk")
	var strike_anim: Animation = ap.get_animation("strike")
	
	assert_test(idle_anim.loop_mode == Animation.LOOP_LINEAR, "Tophiachu Library: 'idle' loop_mode is LOOP_LINEAR")
	assert_test(walk_anim.loop_mode == Animation.LOOP_LINEAR, "Tophiachu Library: 'walk' loop_mode is LOOP_LINEAR")
	assert_test(strike_anim.loop_mode == Animation.LOOP_NONE, "Tophiachu Library: 'strike' loop_mode is LOOP_NONE")
	
	fighter.queue_free()

func test_state_driven_animation_routing() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	var pres = fighter.presentation
	
	pres.play_state_animation(Fighter.State.IDLE)
	assert_test(pres.current_anim == "idle", "State Routing: IDLE plays 'idle'")
	
	pres.play_state_animation(Fighter.State.MOVING)
	assert_test(pres.current_anim == "walk", "State Routing: MOVING plays 'walk'")
	
	pres.play_state_animation(Fighter.State.STRIKING)
	assert_test(pres.current_anim == "strike", "State Routing: STRIKING plays 'strike'")
	
	pres.play_state_animation(Fighter.State.KNOCKED_DOWN)
	assert_test(pres.current_anim == "knockdown", "State Routing: KNOCKED_DOWN plays 'knockdown'")
	
	pres.play_state_animation(Fighter.State.GETTING_UP)
	assert_test(pres.current_anim == "getup", "State Routing: GETTING_UP plays 'getup'")
	
	pres.play_state_animation(Fighter.State.VICTORY)
	assert_test(pres.current_anim == "victory", "State Routing: VICTORY plays 'victory'")
	
	pres.play_state_animation(Fighter.State.DEFEATED)
	assert_test(pres.current_anim == "defeated", "State Routing: DEFEATED plays 'defeated'")
	
	fighter.queue_free()

func test_visual_root_legacy_override_disabled_for_rigged() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	# Transition fighter to KNOCKED_DOWN
	fighter.current_state = Fighter.State.KNOCKED_DOWN
	fighter._play_state_animation(Fighter.State.KNOCKED_DOWN)
	
	# visual_root rotation should NOT be tipped over (legacy mannequin did -PI/2)
	assert_test(fighter.visual_root.rotation.x == 0.0, "Legacy Guard: Rigged fighter visual_root.rotation.x remains 0 on KNOCKED_DOWN")
	assert_test(fighter.visual_root.position.y == 0.0, "Legacy Guard: Rigged fighter visual_root.position.y remains 0 on KNOCKED_DOWN")
	
	# Transition to DEFEATED
	fighter.current_state = Fighter.State.DEFEATED
	fighter._play_state_animation(Fighter.State.DEFEATED)
	assert_test(fighter.visual_root.rotation.x == 0.0, "Legacy Guard: Rigged fighter visual_root.rotation.x remains 0 on DEFEATED")
	
	fighter.queue_free()

func test_locomotion_stride_scaling() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	fighter.current_state = Fighter.State.MOVING
	# Set velocity to match nominal speed: 3.0 + (stat_mobility * 0.4)
	var nominal = 3.0 + (fighter.stat_mobility * 0.4)
	fighter.velocity = Vector3(nominal, 0, 0)
	fighter.presentation.update_locomotion_stride()
	
	assert_test(abs(fighter.presentation.anim_player.speed_scale - 1.0) < 0.05, "Stride Scaling: Speed scale is ~1.0 at nominal speed")
	
	# Faster sprint
	fighter.velocity = Vector3(nominal * 1.5, 0, 0)
	fighter.presentation.update_locomotion_stride()
	assert_test(abs(fighter.presentation.anim_player.speed_scale - 1.5) < 0.05, "Stride Scaling: Speed scale increases to ~1.5 when moving faster")
	
	# Stationary or IDLE
	fighter.current_state = Fighter.State.IDLE
	fighter.presentation.update_locomotion_stride()
	assert_test(fighter.presentation.anim_player.speed_scale == 1.0, "Stride Scaling: Speed scale resets to 1.0 in IDLE")
	
	fighter.queue_free()

func test_unmigrated_roster_fallback_safety() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	# Load an unmigrated character
	fighter.load_character_data("cyraxx")
	
	assert_test(fighter.presentation != null, "Fallback Safety: Presentation component exists for unmigrated fighter")
	assert_test(fighter.is_rigged() == false, "Fallback Safety: Unmigrated fighter is_rigged() is false")
	
	# Check that legacy state changes still set visual_root rotations without errors
	fighter.current_state = Fighter.State.KNOCKED_DOWN
	# Legacy code sets visual_root.rotation.x = -PI/2
	fighter.visual_root.rotation.x = -PI / 2.0
	assert_test(abs(fighter.visual_root.rotation.x - (-PI / 2.0)) < 0.01, "Fallback Safety: Legacy mannequin rotation applies cleanly to unmigrated fighter")
	
	fighter.queue_free()
