extends SceneTree

## End-to-end scene regressions for the asset/input/presentation migration.
## Engine schedules physics; commands deliberately declare their provider.
var total := 0
var failed := 0
const FIGHTER_SCENE = preload("res://scenes/fighter/fighter.tscn")

func _init() -> void:
	call_deferred("run")

func check(ok: bool, label: String) -> void:
	total += 1
	if not ok:
		failed += 1
		printerr("[FAIL] ", label)
	else:
		print("[PASS] ", label)

func tick(n: int = 1) -> void:
	# The next physics_frame begins after the preceding step completed.
	for i in range(n):
		await physics_frame

func pair(a_id := "tophiachu", b_id := "cyraxx", inverse := false) -> Dictionary:
	var world := Node3D.new()
	root.add_child(world)
	var a: Fighter = FIGHTER_SCENE.instantiate()
	var b: Fighter = FIGHTER_SCENE.instantiate()
	a.character_id = a_id
	b.character_id = b_id
	a.player_index = 1
	b.player_index = 2
	a.use_external_input = true
	b.use_external_input = true
	a.position = Vector3(-.6, 0, 0)
	b.position = Vector3(.6, 0, 0)
	world.add_child(b if inverse else a)
	world.add_child(a if inverse else b)
	a.opponent = b
	b.opponent = a
	return {"world": world, "a": a, "b": b}

func cleanup(ctx: Dictionary) -> void:
	for action in ["p1_right", "p1_block", "p1_pin", "p2_pin"]:
		Input.action_release(action)
	ctx.world.queue_free()
	await tick(2)

func run() -> void:
	await tick(2)
	await test_hardware_release()
	await test_asset_loading_and_instance_isolation()
	await test_complete_pair_matrix()
	await test_readable_recovery_and_travel()
	print("OVERHAUL RESULTS: %d passed, %d failed, %d total" % [total-failed, failed, total])
	quit(1 if failed else 0)

func test_hardware_release() -> void:
	var ctx := pair()
	var a: Fighter = ctx.a
	var b: Fighter = ctx.b
	b.position = Vector3(-2, 0, -2)
	a.use_external_input = false
	Input.action_press("p1_right")
	await tick(5)
	check(a.input_dir.x > .9, "Hardware move press reaches fighter")
	Input.action_release("p1_right")
	await tick(3)
	var stopped := a.global_position
	check(a.input_dir.is_zero_approx(), "Hardware release replaces movement with zero")
	await tick(5)
	check(a.global_position.distance_to(stopped) < .005, "Released movement stays stopped through subsequent physics")
	Input.action_press("p1_block")
	await tick(3)
	check(a.current_state == Fighter.State.BLOCKING, "Hardware held block enters guard")
	Input.action_release("p1_block")
	await tick(3)
	check(not a.input_block and a.current_state == Fighter.State.IDLE, "Hardware block release exits guard")
	Input.action_press("p1_pin")
	await tick(3)
	check(a.input_hold_pin, "Held resistance is sampled")
	Input.action_release("p1_pin")
	await tick(3)
	check(not a.input_hold_pin, "Held resistance clears on release")
	a.use_external_input = true
	a.apply_command({"move": Vector2(1, 1), "block": true, "hold_pin": true})
	check(a.input_dir.length() <= 1.001, "External diagonal command normalized")
	a.apply_command({})
	check(a.input_dir.is_zero_approx() and not a.input_block and not a.input_hold_pin, "Neutral external snapshot clears continuous commands")
	a.apply_command({"move": Vector2.ONE, "block": true})
	a.clear_inputs()
	check(a.input_dir.is_zero_approx() and not a.input_block, "Focus/provider-reset clears previous commands")
	await cleanup(ctx)

func test_asset_loading_and_instance_isolation() -> void:
	var ctx := pair("tophiachu", "tophiachu")
	var a: Fighter = ctx.a
	var b: Fighter = ctx.b
	await tick(2)
	var ap: AnimationPlayer = a.presentation.anim_player
	var bp: AnimationPlayer = b.presentation.anim_player
	check(ap.get_animation("idle") != bp.get_animation("idle"), "Mirror match has independently mutable animation resources")
	a._start_strike()
	await tick(3)
	check(a.presentation.current_anim == "strike" and b.presentation.current_anim == "idle", "Mirror players play independent actions")
	for id in RosterData.get_all_ids():
		a.load_character_data(id)
		await tick(2)
		check(a.is_rigged() and a.presentation.skeleton.get_bone_count() == 46, "%s: 42 core bones plus four deformation helpers" % id)
		check(a.presentation.anim_player.get_animation_list().size() >= 25, "%s: full animation vocabulary" % id)
		check(a.visual_root.get_child_count() == 1, "%s: no duplicate models after reload" % id)
		check(absf(a.presentation.anim_player.get_animation("throw_attacker").length - a.throw_duration) < .001, "%s: actual throw duration matches exported clip" % id)
	await cleanup(ctx)

func test_complete_pair_matrix() -> void:
	for a_id in RosterData.get_all_ids():
		for b_id in RosterData.get_all_ids():
			var inverse: bool = (total % 2) == 0
			var ctx := pair(a_id, b_id, inverse)
			var a: Fighter = ctx.a
			var b: Fighter = ctx.b
			await tick(2)
			var hp := b.vitality
			var impacts := [0]
			a.throw_impact.connect(func(_a, _b): impacts[0] += 1)
			a._attempt_grapple(false)
			var valid_roots := true
			var synchronized := true
			var saw_throw := false
			var last_y := 0.0
			for frame in range(85):
				await tick()
				valid_roots = valid_roots and a.visual_root.rotation.is_zero_approx() and b.visual_root.rotation.is_zero_approx()
				if b.current_state == Fighter.State.GRAPPLING_DEFENDER:
					saw_throw = true
					last_y = maxf(last_y, b.global_position.y)
					var diff := absf(a.presentation.anim_player.current_animation_position - b.presentation.anim_player.current_animation_position)
					synchronized = synchronized and diff < .025
			var label: String = "%s -> %s" % [a_id, b_id]
			check(saw_throw and impacts[0] == 1 and b.vitality < hp, label + ": full grapple and single impact")
			check(valid_roots and synchronized and last_y > .20, label + ": shared clock and no legacy root tilt")
			check(a.synchronized_partner == null and b.synchronized_partner == null and b.current_state == Fighter.State.KNOCKED_DOWN, label + ": complete release cleanup")
			check(b.presentation.current_anim == "downed", label + ": does not replay standing collapse after slam")
			await cleanup(ctx)

func test_readable_recovery_and_travel() -> void:
	var ctx := pair()
	var a: Fighter = ctx.a
	ctx.b.position = Vector3(-3, 0, -3)
	await tick(2)
	a.apply_command({"move": Vector2(1, 0)})
	await tick(8)
	check(a.presentation.actual_speed > 1, "Gait samples actual post-simulation travel")
	a.apply_command({})
	await tick(4)
	check(a.presentation.actual_speed < .01, "Gait travel measurement returns to zero on stop")
	a._set_state(Fighter.State.KNOCKED_DOWN)
	a.knockdown_duration = .65
	await tick(42)
	check(a.current_state == Fighter.State.GETTING_UP, "Ground state advances into supported recovery clip")
	await tick(38)
	check(a.current_state == Fighter.State.IDLE and a.visual_root.transform.is_equal_approx(Transform3D.IDENTITY), "Recovery ends upright with an identity visual root")
	var pose: Vector3 = a.presentation.skeleton.get_bone_pose_position(a.presentation.skeleton.find_bone("Hips"))
	check(pose.y > .8, "Recovery does not retain the downed pelvis translation")
	await cleanup(ctx)
