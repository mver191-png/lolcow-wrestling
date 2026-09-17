class_name AnimationPolish
extends Node
## Cosmetic post-process for skinned wrestlers. This deliberately does not encode
## claims about the real people represented by the roster: differences come from
## fictional in-game archetype/stats and the existing authored rig.
const IK = preload("res://scripts/fighter/contact_ik.gd")
var presentation: Node
var fighter: Fighter
var skeleton: Skeleton3D
var bones: Dictionary = {}
var body_scale := 1.0
var time := 0.0
var last_state := -1
var state_age := 0.0
var diagnostics: Array[Dictionary] = []

func setup(presentation_node: Node) -> void:
	presentation = presentation_node
	fighter = presentation.fighter
	process_physics_priority = 35

func reset() -> void:
	bones.clear()
	skeleton = presentation.skeleton
	if skeleton == null: return
	for i in range(skeleton.get_bone_count()): bones[skeleton.get_bone_name(i)] = i
	var hips := bone("Hips")
	if hips >= 0: body_scale = maxf(skeleton.get_bone_global_rest(hips).origin.y/.89,.5)

func bone(name: String) -> int: return int(bones.get(name,-1))
func rotate(name: String, euler: Vector3, weight := 1.0) -> void:
	var i:=bone(name)
	if i<0:return
	var base:=skeleton.get_bone_pose_rotation(i)
	skeleton.set_bone_pose_rotation(i,base.slerp(base*Quaternion.from_euler(euler),clampf(weight,0,1)))

func curl_hand(side: String, amount: float, spread := 0.0) -> void:
	amount=clampf(amount,0,1)
	for j in range(5):
		var thumb:=j==4
		rotate("Finger%d.%s"%[j,side],Vector3((.78 if thumb else 1.05)*amount,0,(spread*(j-1.5)) if not thumb else -.42*amount))
		rotate("Finger%dTip.%s"%[j,side],Vector3((.68 if thumb else .92)*amount,0,0))

func _ground_target(local: Vector3) -> Vector3:
	return fighter.global_transform*Vector3(local.x,0.018,local.z)

func _support_arm(side: String,target: Vector3,pole: Vector3,weight: float,kind:String) -> void:
	var result:=IK.solve(skeleton,bone("UpperArm."+side),bone("Forearm."+side),bone("Hand."+side),target,pole,weight)
	if result.get("valid",false):
		result.merge({"kind":kind,"side":side,"target":target,"actual":IK.point(skeleton,bone("Hand."+side)),"weight":weight},true)
		diagnostics.append(result)

func _support_leg(side:String,target:Vector3,pole:Vector3,weight:float,kind:String)->void:
	var result:=IK.solve(skeleton,bone("Thigh."+side),bone("Shin."+side),bone("Foot."+side),target,pole,weight)
	if result.get("valid",false):
		result.merge({"kind":kind,"side":side,"target":target,"actual":IK.point(skeleton,bone("Foot."+side)),"weight":weight},true)
		diagnostics.append(result)

func _physics_process(delta:float)->void:
	diagnostics.clear()
	if presentation==null or not presentation.has_skeletal_rig or not is_instance_valid(fighter):return
	if skeleton!=presentation.skeleton or bones.is_empty():reset()
	if skeleton==null:return
	time+=delta
	if fighter.current_state!=last_state:
		last_state=fighter.current_state;state_age=0.0
	else:state_age+=delta
	var mobility:=float(fighter.stat_mobility)/10.0
	var power:=float(fighter.stat_power)/10.0
	var stamina_ratio:=fighter.stamina/maxf(fighter.max_stamina,1.0)
	# Low-amplitude secondary motion keeps silhouettes alive without changing roots.
	if fighter.current_state in [Fighter.State.IDLE,Fighter.State.MOVING]:
		var breath:=sin(time*(2.0+mobility*.7))
		rotate("Chest",Vector3(.010*breath,0,.006*sin(time*1.3)))
		rotate("Head",Vector3(-.006*breath,.012*sin(time*.8),0))
		if fighter.current_state==Fighter.State.MOVING:
			rotate("Chest",Vector3(0,.025*sin(time*(6.0+mobility*4.0)),0))
	# Character stats affect fictional ring-body language, not anatomy.
	if fighter.current_state==Fighter.State.STRIKING:
		var hit_phase:=clampf(fighter.state_timer/maxf(fighter.attack_total_time,.01),0,1)
		var brace:=sin(PI*hit_phase)
		rotate("Chest",Vector3(-.035*power*brace,.04*power*brace,0))
		curl_hand("R",.92,.03);curl_hand("L",.55,.06)
	elif fighter.current_state in [Fighter.State.BLOCKING,Fighter.State.REVERSAL_STANCE]:
		curl_hand("L",.64,.08);curl_hand("R",.64,.08)
	elif fighter.current_state in [Fighter.State.GRAPPLING_ATTACKER,Fighter.State.PINNING,Fighter.State.SUBMISSION_ATTACKER]:
		curl_hand("L",.88,.025);curl_hand("R",.88,.025)
	elif fighter.current_state in [Fighter.State.PINNED,Fighter.State.SUBMISSION_DEFENDER]:
		curl_hand("L",.38,.13);curl_hand("R",.38,.13)
	else:
		curl_hand("L",.28,.12);curl_hand("R",.28,.12)
	# Supported recovery: hand -> knee/foot -> stand. IK is cosmetic and bounded.
	if fighter.current_state==Fighter.State.GETTING_UP:
		var p:=clampf(fighter.state_timer/.60,0,1)
		var hand_w:=1.0-smoothstep(.48,.82,p)
		var knee_w:=smoothstep(.08,.30,p)*(1.0-smoothstep(.72,.96,p))
		var hand_target:=fighter.global_position+fighter.global_basis.x*(-.30*body_scale)+fighter.global_basis.z*(.06*body_scale)+Vector3.UP*.025
		var hand_pole:=hand_target-fighter.global_basis.z*.45+Vector3.UP*.22
		_support_arm("L",hand_target,hand_pole,hand_w,"getup_hand")
		var foot_target:=fighter.global_position+fighter.global_basis.x*(.20*body_scale)-fighter.global_basis.z*(.24*body_scale)+Vector3.UP*.055
		var knee_pole:=fighter.global_position-fighter.global_basis.z*(.42*body_scale)+Vector3.UP*.26
		_support_leg("R",foot_target,knee_pole,knee_w,"getup_foot")
		rotate("Head",Vector3(-.16*(1-p),0,0))
	# Fatigue is presentation-only: a small guarded slump when standing.
	if stamina_ratio<.25 and fighter.current_state in [Fighter.State.IDLE,Fighter.State.MOVING]:
		var fatigue:=(.25-stamina_ratio)/.25
		rotate("Chest",Vector3(.06*fatigue,0,0));rotate("Head",Vector3(-.035*fatigue,0,0))
