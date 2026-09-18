extends SceneTree
## Real final-pose bounds and engine projection, not just camera-distance values.
var passed:=0
var failed:=0
func _init() -> void: call_deferred("run")
func tick(n:=1) -> void:
	for i in range(n): await physics_frame
func check(ok: bool,label: String) -> void:
	if ok: passed+=1
	else: failed+=1;printerr("[FAIL] ",label)
func screen_height(camera: Camera3D,bounds: AABB) -> float:
	var low:=INF;var high:=-INF
	for i in range(8):
		var pt:=camera.unproject_position(bounds.get_endpoint(i))
		low=minf(low,pt.y);high=maxf(high,pt.y)
	return high-low
func fits(camera: Camera3D,bounds: AABB) -> bool:
	var size:=camera.get_viewport().get_visible_rect().size
	for i in range(8):
		var point:=bounds.get_endpoint(i)
		if camera.is_position_behind(point): return false
		var uv:=camera.unproject_position(point)/size
		if uv.x<.08 or uv.x>.92 or uv.y<.08 or uv.y>.92: return false
	return true
func run() -> void:
	root.content_scale_size=Vector2i.ZERO
	root.content_scale_mode=Window.CONTENT_SCALE_MODE_DISABLED
	var world:=Node3D.new();root.add_child(world)
	var a: Fighter=load("res://scenes/fighter/fighter.tscn").instantiate()
	var b: Fighter=load("res://scenes/fighter/fighter.tscn").instantiate()
	a.character_id="tophiachu";b.character_id="cyraxx"
	a.use_external_input=true;b.use_external_input=true
	world.add_child(a);world.add_child(b);a.opponent=b;b.opponent=a
	var camera:=BroadcastCamera.new();camera.target_1=a;camera.target_2=b;camera.enable_shake=false;camera.fov=55
	world.add_child(camera);camera.make_current()
	a.position=Vector3(-.55,0,0);b.position=Vector3(.55,0,0)
	await tick(10)
	check(camera.process_physics_priority>40,"Camera follows final clearance pose")
	for size in [Vector2i(1280,720),Vector2i(1024,768),Vector2i(1680,720)]:
		root.size=size
		await tick(2)
		a.position=Vector3(-.55,0,0);b.position=Vector3(.55,0,0)
		a._set_state(Fighter.State.IDLE);b._set_state(Fighter.State.IDLE)
		camera.action_framing=false
		await tick(150)
		var old_height:=screen_height(camera,b.presentation.clearance.after)
		camera.action_framing=true
		await tick(150)
		var height:=screen_height(camera,b.presentation.clearance.after)
		check(height>old_height*1.35,"Standing actors are materially larger: "+str(size))
		check(fits(camera,a.presentation.clearance.after) and fits(camera,b.presentation.clearance.after),"Close pair keeps head/feet and margins")
		a._start_synchronized_throw(b)
		var safe:=true
		for frame in range(80):
			await tick()
			safe=safe and fits(camera,a.presentation.clearance.after) and fits(camera,b.presentation.clearance.after)
		check(safe,"Entire throw/landing remains framed: "+str(size))
		a.position=Vector3(-3.3,0,-3.3);b.position=Vector3(3.3,0,3.3)
		await tick(2)
		check(fits(camera,a.presentation.clearance.after) and fits(camera,b.presentation.clearance.after),"Opposite corners fit despite focus lag")
	camera.trauma=1.0;camera.enable_shake=false
	await tick(2)
	check(camera.trauma==0.0,"Stable action camera clears existing shake")
	world.queue_free();await tick(2)
	print("ACTION CAMERA: %d passed, %d failed"%[passed,failed])
	quit(1 if failed else 0)
