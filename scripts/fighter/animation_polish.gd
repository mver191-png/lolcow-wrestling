class_name AnimationPolish
extends Node
## Cosmetic post-process. Styles are fictional ring identities, not claims about
## the real people represented by the roster.
const IK=preload("res://scripts/fighter/contact_ik.gd")
const STYLE={"tophiachu":{"stance":.85,"tempo":.82,"twist":.72,"guard":.82},"novaonline":{"stance":.92,"tempo":.90,"twist":.88,"guard":.70},"cyraxx":{"stance":.48,"tempo":1.34,"twist":1.18,"guard":.92},"candy_rooks":{"stance":.78,"tempo":.94,"twist":.84,"guard":.78},"andy_ditch":{"stance":1.,"tempo":.72,"twist":.58,"guard":.90},"jupiter_the_hybrid":{"stance":.60,"tempo":1.12,"twist":1.12,"guard":.86},"anacondasin":{"stance":.58,"tempo":1.02,"twist":1.04,"guard":.96},"daniel_larson":{"stance":.44,"tempo":1.24,"twist":1.08,"guard":.72}}
var presentation:Node;var fighter:Fighter;var skeleton:Skeleton3D;var bones:Dictionary={};var body_scale:=1.;var time:=0.;var last_state:=-1;var state_age:=0.;var diagnostics:Array[Dictionary]=[]
func setup(presentation_node:Node)->void:presentation=presentation_node;fighter=presentation.fighter;process_physics_priority=35
func reset()->void:
 bones.clear();skeleton=presentation.skeleton
 if skeleton==null:return
 for i in range(skeleton.get_bone_count()):bones[skeleton.get_bone_name(i)]=i
 var hips:=bone("Hips")
 if hips>=0:body_scale=maxf(skeleton.get_bone_global_rest(hips).origin.y/.89,.5)
func bone(name:String)->int:return int(bones.get(name,-1))
func rotate(name:String,euler:Vector3,weight:=1.)->void:
 var i:=bone(name)
 if i<0:return
 var base:=skeleton.get_bone_pose_rotation(i);skeleton.set_bone_pose_rotation(i,base.slerp(base*Quaternion.from_euler(euler),clampf(weight,0,1)))
func curl_hand(side:String,amount:float,spread:=0.)->void:
 amount=clampf(amount,0,1)
 for j in range(5):
  var thumb:=j==4;rotate("Finger%d.%s"%[j,side],Vector3((.78 if thumb else 1.05)*amount,0,(spread*(j-1.5)) if not thumb else -.42*amount));rotate("Finger%dTip.%s"%[j,side],Vector3((.68 if thumb else .92)*amount,0,0))
func _support_arm(side:String,target:Vector3,pole:Vector3,weight:float,kind:String)->void:
 var result:=IK.solve(skeleton,bone("UpperArm."+side),bone("Forearm."+side),bone("Hand."+side),target,pole,weight)
 if result.get("valid",false):result.merge({"kind":kind,"side":side,"target":target,"actual":IK.point(skeleton,bone("Hand."+side)),"weight":weight},true);diagnostics.append(result)
func _support_leg(side:String,target:Vector3,pole:Vector3,weight:float,kind:String)->void:
 var result:=IK.solve(skeleton,bone("Thigh."+side),bone("Shin."+side),bone("Foot."+side),target,pole,weight)
 if result.get("valid",false):result.merge({"kind":kind,"side":side,"target":target,"actual":IK.point(skeleton,bone("Foot."+side)),"weight":weight},true);diagnostics.append(result)
func _signature(style:Dictionary,power:float)->void:
 var stance:float=style.stance;var tempo:float=style.tempo;var twist:float=style.twist
 if fighter.current_state in [Fighter.State.IDLE,Fighter.State.MOVING]:
  rotate("Thigh.L",Vector3(0,0,.035*stance));rotate("Thigh.R",Vector3(0,0,-.035*stance));rotate("UpperArm.L",Vector3(0,0,.045*(style.guard-.7)));rotate("UpperArm.R",Vector3(0,0,-.045*(style.guard-.7)));var sway:=sin(time*(1.7*tempo));rotate("Spine",Vector3(0,.012*sway*twist,0));rotate("Head",Vector3(0,-.008*sway,0))
 if fighter.current_state==Fighter.State.STRIKING:
  var p:=clampf(fighter.state_timer/maxf(fighter.attack_total_time,.01),0,1);var impulse:=sin(PI*p);rotate("Hips",Vector3(0,.065*impulse*twist,0));rotate("Chest",Vector3(-.025*power*impulse,.07*impulse*twist,0));rotate("Thigh.L",Vector3(-.025*impulse*(1-stance),0,0));rotate("Thigh.R",Vector3(.035*impulse*(1-stance),0,0))
 if fighter.current_state==Fighter.State.GRAPPLE_STARTUP:
  var reach:=smoothstep(0,.18,fighter.state_timer);rotate("Chest",Vector3(-.08*reach,.025*sin(time*tempo),0));rotate("Head",Vector3(.035*reach,0,0))
func _physics_process(delta:float)->void:
 diagnostics.clear()
 if presentation==null or not presentation.has_skeletal_rig or not is_instance_valid(fighter):return
 if skeleton!=presentation.skeleton or bones.is_empty():reset()
 if skeleton==null:return
 time+=delta
 if fighter.current_state!=last_state:last_state=fighter.current_state;state_age=0.
 else:state_age+=delta
 var mobility:=float(fighter.stat_mobility)/10.;var power:=float(fighter.stat_power)/10.;var stamina_ratio:=fighter.stamina/maxf(fighter.max_stamina,1.);var style:Dictionary=STYLE.get(fighter.character_id,{"stance":.65,"tempo":1.,"twist":.9,"guard":.8})
 if fighter.current_state in [Fighter.State.IDLE,Fighter.State.MOVING]:
  var breath:=sin(time*(2.+mobility*.7)*float(style.tempo));rotate("Chest",Vector3(.010*breath,0,.006*sin(time*1.3)));rotate("Head",Vector3(-.006*breath,.012*sin(time*.8),0))
  if fighter.current_state==Fighter.State.MOVING:rotate("Chest",Vector3(0,.025*sin(time*(6.+mobility*4.)*float(style.tempo)),0))
 _signature(style,power)
 if fighter.current_state==Fighter.State.STRIKING:
  var hit_phase:=clampf(fighter.state_timer/maxf(fighter.attack_total_time,.01),0,1);var brace:=sin(PI*hit_phase);rotate("Chest",Vector3(-.035*power*brace,.04*power*brace,0));curl_hand("R",.92,.03);curl_hand("L",.55,.06)
 elif fighter.current_state in [Fighter.State.BLOCKING,Fighter.State.REVERSAL_STANCE]:curl_hand("L",.64,.08);curl_hand("R",.64,.08)
 elif fighter.current_state in [Fighter.State.GRAPPLING_ATTACKER,Fighter.State.PINNING,Fighter.State.SUBMISSION_ATTACKER]:curl_hand("L",.88,.025);curl_hand("R",.88,.025)
 elif fighter.current_state in [Fighter.State.PINNED,Fighter.State.SUBMISSION_DEFENDER]:curl_hand("L",.38,.13);curl_hand("R",.38,.13)
 else:curl_hand("L",.28,.12);curl_hand("R",.28,.12)
 if fighter.current_state==Fighter.State.GETTING_UP:
  var p:=clampf(fighter.state_timer/.60,0,1);var hand_w:=1.-smoothstep(.48,.82,p);var foot_w:=smoothstep(.08,.30,p)*(1.-smoothstep(.72,.96,p))
  # Thigh-braced recovery. The boot sole, not the ankle center, meets the mat.
  var thigh_target:=IK.point(skeleton,bone("Thigh.L"))+fighter.global_basis.z*(-.045*body_scale)+Vector3.UP*(.035*body_scale);var hand_pole:=thigh_target-fighter.global_basis.z*.30+fighter.global_basis.x*(-.22)+Vector3.UP*.18;_support_arm("L",thigh_target,hand_pole,hand_w,"getup_hand")
  var foot_target:=fighter.global_position+fighter.global_basis.x*(.20*body_scale)-fighter.global_basis.z*(.24*body_scale)+Vector3.UP*(.137*body_scale);var knee_pole:=fighter.global_position-fighter.global_basis.z*(.42*body_scale)+Vector3.UP*.26;_support_leg("R",foot_target,knee_pole,foot_w,"getup_foot");IK._world_rotation(skeleton,bone("Foot.R"),IK.world_pose(skeleton,bone("Foot.R")).basis.orthonormalized().get_rotation_quaternion().slerp(fighter.global_basis.orthonormalized().get_rotation_quaternion(),foot_w));rotate("Head",Vector3(-.16*(1-p),0,0))
 if stamina_ratio<.25 and fighter.current_state in [Fighter.State.IDLE,Fighter.State.MOVING]:
  var fatigue:=(.25-stamina_ratio)/.25;rotate("Chest",Vector3(.06*fatigue,0,0));rotate("Head",Vector3(-.035*fatigue,0,0))
