class_name AuthoredMotion
extends RefCounted
## Authored key poses in metres/Y-up. Runtime fitting rotates limbs to support
## anchors; this never changes the fighter root, recovery duration or match rules.
const IK = preload("res://scripts/fighter/contact_ik.gd")
const SUPPORTED := ["tophiachu", "cyraxx"]

static func supported(id: String) -> bool:
	return id in SUPPORTED

static func rotate(s: Skeleton3D, name: String, angles: Vector3) -> void:
	var i := s.find_bone(name)
	if i >= 0:
		s.set_bone_pose_rotation(i, Quaternion.from_euler(angles))

static func sample(keys: Array, phase: float) -> Vector3:
	for i in range(1, keys.size()):
		if phase <= float(keys[i][0]):
			var t := smoothstep(float(keys[i-1][0]), float(keys[i][0]), phase)
			return (keys[i-1][1] as Vector3).lerp(keys[i][1], t)
	return keys[-1][1]

static func recovery(s: Skeleton3D, f: Fighter, phase: float, scale: float) -> Array[Dictionary]:
	var diagnostics: Array[Dictionary] = []
	var p := clampf(phase, 0.0, 1.0)
	var hips := s.find_bone("Hips")
	var pelvis := sample([[0.0, Vector3(0,.29,0)], [.16, Vector3(0,.32,0)],
		[.36, Vector3(0,.46,.04)], [.60, Vector3(0,.59,.05)],
		[.82, Vector3(0,.75,.02)], [1.0, Vector3(0,.89,0)]], p)
	s.set_bone_pose_position(hips, pelvis * scale)
	rotate(s, "Hips", sample([[0.0,Vector3(PI/2,0,0)],[.16,Vector3(1.25,0,.16)],
		[.36,Vector3(.30,0,.08)],[.60,Vector3(-.18,0,0)],
		[.82,Vector3(-.12,0,0)],[1.0,Vector3.ZERO]],p))
	rotate(s,"Spine",Vector3.ZERO)
	rotate(s,"Chest",sample([[0.0,Vector3.ZERO],[.36,Vector3(-.15,0,0)],
		[.6,Vector3(-.15,0,0)],[1.0,Vector3(.045,0,0)]],p))
	rotate(s,"Head",Vector3(-.035,0,0))
	for side in ["L","R"]:
		var sign := 1.0 if side == "L" else -1.0
		rotate(s,"UpperArm."+side,sample([[0.0,Vector3(0,0,.6*sign)],
			[.36,Vector3(.3,0,.14*sign)],[1.0,Vector3(.15,0,.12*sign)]],p))
		rotate(s,"Forearm."+side,Vector3(1.5,0,0))
	s.force_update_all_bone_transforms()
	# The initial foot lies along the mat; each foot is brought under the body
	# before standing. Right foot takes load first; left trails into the stance.
	for side in ["L","R"]:
		var bone := s.find_bone("Foot."+side)
		var x := s.get_bone_global_rest(bone).origin.x
		var end_z := -.23 if side == "R" else .10
		var z := lerpf(-.775, end_z, smoothstep(.02,.58,p))
		z = lerpf(z,0.0,smoothstep(.62,1.0,p))
		var y := lerpf(.29,.137,smoothstep(0.0,.26,p))
		var target := f.global_transform * Vector3(x,y*scale,z*scale)
		var knee := f.global_transform * Vector3(x,.48*scale,-.65*scale)
		var result := IK.solve(s,s.find_bone("Thigh."+side),s.find_bone("Shin."+side),bone,target,knee,1.0,155.0)
		if result.get("valid", false):
			var from := IK.world_pose(s,bone).basis.orthonormalized().get_rotation_quaternion()
			IK._world_rotation(s,bone,from.slerp(f.global_basis.orthonormalized().get_rotation_quaternion(),smoothstep(.02,.32,p)))
			result.merge({"kind":"getup_foot", "side":side,"weight":1.0,
				"target":target,"actual":IK.point(s,bone),"authored":true},true)
			diagnostics.append(result)
	# Reachable thigh brace during the loading phase. Do not invent a floor-hand
	# contact from a shoulder whose arm chain cannot physically reach the floor.
	var brace := smoothstep(.04,.20,p) * (1.0-smoothstep(.64,.90,p))
	if brace > .001:
		var target := IK.point(s,s.find_bone("Thigh.L")) - f.global_basis.z*.045*scale + Vector3.UP*.035*scale
		var pole := target + f.global_basis.x*.25 - f.global_basis.z*.20 + Vector3.UP*.12
		var result := IK.solve(s,s.find_bone("UpperArm.L"),s.find_bone("Forearm.L"),s.find_bone("Hand.L"),target,pole,brace,155.0)
		if result.get("valid", false):
			result.merge({"kind":"getup_hand","side":"L","weight":brace,
				"target":target,"actual":IK.point(s,s.find_bone("Hand.L")),"authored":true},true)
			diagnostics.append(result)
	return diagnostics

static func strike(s: Skeleton3D, move: Dictionary, time: float) -> void:
	var id: String = move.get("id", "standard_strike")
	if id == "comment_section_clothesline":
		# Right-arm sweep: wind-up, committed clothesline, follow-through, guard.
		rotate(s,"Chest",sample([[0.0,Vector3(.04,.13,0)],[.095,Vector3(.04,.36,0)],
			[.145,Vector3(-.06,-.52,0)],[.31,Vector3(-.04,-.30,0)],
			[.45,Vector3(.045,0,0)]],time))
		rotate(s,"UpperArm.R",sample([[0.0,Vector3(.15,0,-.12)],
			[.095,Vector3(.15,0,-1.1)],[.145,Vector3(1.48,0,-.24)],
			[.31,Vector3(1.10,-.25,.40)],[.45,Vector3(.15,0,-.12)]],time))
		rotate(s,"Forearm.R",sample([[0.0,Vector3(1.5,0,0)],[.10,Vector3(.20,0,0)],
			[.25,Vector3(.20,0,0)],[.45,Vector3(1.5,0,0)]],time))
	elif id == "feedback_flurry":
		# Three actual hit windows: left jab, right straight, left forearm.
		for side in ["L","R"]:
			var peaks: Array = []
			for hit in move.get("hits", []):
				if hit.hand == side:
					peaks.append((float(hit.start)+float(hit.end))*.5)
			var pulse := 0.0
			for peak in peaks:
				var rise := smoothstep(float(peak)-.075,float(peak)-.012,time)
				var fall := 1.0-smoothstep(float(peak)+.012,float(peak)+.065,time)
				pulse=maxf(pulse,rise*fall)
			var sign:=1.0 if side=="L" else -1.0
			rotate(s,"UpperArm."+side,Vector3(lerpf(.20,1.45,pulse),0,sign*lerpf(.10,-.14,pulse)))
			rotate(s,"Forearm."+side,Vector3(lerpf(1.50,.15,pulse),0,0))
		var twist := .13*sin(time/.45*TAU*1.5)
		rotate(s,"Chest",Vector3(-.07,twist,0))
