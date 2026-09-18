extends SceneTree
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
 var support:=false;var full_support:=false
 for d in f.presentation.polish.diagnostics:
  if d.kind in ["getup_hand","getup_foot"]:
   support=true
   check(d.unreachable<.08,"%s %s target is within physical chain reach (unreachable %.3f)"%[id,d.kind,d.unreachable])
   if d.weight>.90:
    full_support=true;check(d.error<.12,"%s full-weight %s contact <=12cm (%.3f)"%[id,d.kind,d.error])
 check(support and full_support,"%s recovery has measured full support"%id)
 f._set_state(Fighter.State.IDLE);f.stamina=0;await tick(3)
 check(f.visual_root.transform.is_equal_approx(Transform3D.IDENTITY),"%s secondary motion leaves gameplay visual root unchanged"%id)
 f.queue_free();await tick(2)
