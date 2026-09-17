extends SceneTree
const IK=preload("res://scripts/fighter/contact_ik.gd")
const SCENE=preload("res://scenes/fighter/fighter.tscn")
var total:=0;var failed:=0
func _init()->void:call_deferred("run")
func check(ok:bool,label:String)->void:
	total+=1
	if not ok:failed+=1;printerr("[FAIL] ",label)
func tick(n:=1)->void:
	for i in range(n):await physics_frame
func run()->void:
	await tick(2)
	for id in RosterData.get_all_ids():await test_character(id)
	print("ANIMATION POLISH: %d passed, %d failed, %d total"%[total-failed,failed,total]);quit(1 if failed else 0)
func test_character(id:String)->void:
	var f:Fighter=SCENE.instantiate();f.character_id=id;f.use_external_input=true;root.add_child(f);await tick(3)
	check(f.presentation.polish!=null,"%s polish layer exists"%id)
	var s:Skeleton3D=f.presentation.skeleton;var before:Array[Vector3]=[]
	for i in range(s.get_bone_count()):before.append(s.get_bone_pose_position(i))
	f._set_state(Fighter.State.STRIKING);await tick(5)
	var finger:=s.find_bone("Finger1.R");check(finger>=0 and s.get_bone_pose_rotation(finger).get_angle()>0.20,"%s strike closes hand"%id)
	var unchanged:=true
	for i in range(s.get_bone_count()):
		if s.get_bone_name(i).begins_with("Finger") and s.get_bone_pose_position(i).distance_to(before[i])>.00002:unchanged=false
	check(unchanged,"%s polish never stretches finger segments"%id)
	f._set_state(Fighter.State.GETTING_UP);f.state_timer=.22;await tick(2)
	var support:=false
	# Dedicated recovery owns these limbs; the secondary layer must not solve
	# them again or re-close the loaded palm after contact correction.
	check(f.presentation.polish.diagnostics.is_empty(),"%s recovery has one IK owner"%id)
	for d in f.presentation.contact.diagnostics:
		if d.kind in ["recovery_palm","recovery_ankle"] and d.weight>=.999:
			support=true
			var bone_name: String = "Hand.L" if d.kind=="recovery_palm" else "Foot."+d.side
			var local_point: Vector3 = Vector3(0,-.045,-.012)*float(f.presentation.contact._scale) if d.kind=="recovery_palm" else Vector3.ZERO
			var visible: Vector3 = IK.point(s,s.find_bone(bone_name),local_point)
			check(d.error<.025 and d.unreachable<.08 and visible.distance_to(d.target)<.025,"%s final loaded pose reaches its support within 2.5cm"%id)
	check(support,"%s recovery has measured support"%id)
	f._set_state(Fighter.State.IDLE);f.stamina=0;await tick(3)
	check(f.visual_root.transform.is_equal_approx(Transform3D.IDENTITY),"%s secondary motion leaves gameplay visual root unchanged"%id)
	f.queue_free();await tick(2)
