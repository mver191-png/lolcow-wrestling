class_name FighterPresentation
extends Node

## Presentation component for wrestling fighters.
## Manages 3D character instantiation, skeletal armature detection,
## animation blending, and visual locomotion synchronization.

var fighter: CharacterBody3D = null
var visual_root: Node3D = null
var anim_player: AnimationPlayer = null
var skeleton: Skeleton3D = null
var has_skeletal_rig: bool = false
var current_anim: String = ""

func setup(p_fighter: Fighter, p_visual_root: Node3D) -> void:
	fighter = p_fighter
	visual_root = p_visual_root

func load_model(character_id: String) -> void:
	if not visual_root:
		return
		
	for child in visual_root.get_children():
		child.queue_free()
		
	anim_player = null
	skeleton = null
	has_skeletal_rig = false
	current_anim = ""
	
	var model_path: String = "res://assets/models/" + character_id + ".glb"
	if ResourceLoader.exists(model_path):
		var model_res = load(model_path)
		if model_res is PackedScene:
			var inst: Node = model_res.instantiate()
			visual_root.add_child(inst)
			
			anim_player = inst.find_child("AnimationPlayer", true, false) as AnimationPlayer
			skeleton = inst.find_child("Skeleton3D", true, false) as Skeleton3D
			
			if is_instance_valid(skeleton) and is_instance_valid(anim_player):
				# Validate core animation set
				var anims: PackedStringArray = anim_player.get_animation_list()
				if anims.has("idle") and anims.has("walk") and anims.has("strike") and anims.has("knockdown") and anims.has("getup"):
					has_skeletal_rig = true
					_configure_animation_loops()
					
			if has_skeletal_rig:
				visual_root.rotation = Vector3.ZERO
				visual_root.position = Vector3.ZERO
				
			play_state_animation(fighter.current_state if fighter else Fighter.State.IDLE)

func _configure_animation_loops() -> void:
	if not is_instance_valid(anim_player):
		return
	for loop_anim in ["idle", "walk"]:
		if anim_player.has_animation(loop_anim):
			var a: Animation = anim_player.get_animation(loop_anim)
			a.loop_mode = Animation.LOOP_LINEAR

func play_state_animation(st: Fighter.State) -> void:
	if not is_instance_valid(anim_player):
		return
		
	var anim_name: String = ""
	match st:
		Fighter.State.IDLE: anim_name = "idle"
		Fighter.State.MOVING: anim_name = "walk"
		Fighter.State.STRIKING: anim_name = "strike"
		Fighter.State.BLOCKING: anim_name = "block"
		Fighter.State.REVERSAL_STANCE: anim_name = "reversal"
		Fighter.State.GRAPPLE_STARTUP: anim_name = "grapple"
		Fighter.State.GRAPPLING_ATTACKER: anim_name = "throw_attacker"
		Fighter.State.GRAPPLING_DEFENDER: anim_name = "throw_defender"
		Fighter.State.KNOCKED_DOWN: anim_name = "knockdown"
		Fighter.State.GETTING_UP: anim_name = "getup"
		Fighter.State.PINNING: anim_name = "pinning"
		Fighter.State.PINNED: anim_name = "pinned"
		Fighter.State.SUBMISSION_ATTACKER: anim_name = "submission_attacker"
		Fighter.State.SUBMISSION_DEFENDER: anim_name = "submission_defender"
		Fighter.State.VICTORY: anim_name = "victory"
		Fighter.State.DEFEATED: anim_name = "defeated"
		
	if anim_name != "" and anim_player.has_animation(anim_name):
		current_anim = anim_name
		# Blend smoothly into looping / locomotion states, instant-cut into impacts
		var blend_time: float = 0.12
		if st in [Fighter.State.KNOCKED_DOWN, Fighter.State.STRIKING]:
			blend_time = 0.05
		anim_player.play(anim_name, blend_time)

func update_locomotion_stride() -> void:
	if not has_skeletal_rig or not is_instance_valid(anim_player) or not is_instance_valid(fighter):
		return
		
	if fighter.current_state == Fighter.State.MOVING:
		var nominal_speed: float = 3.0 + (fighter.stat_mobility * 0.4)
		var actual_speed: float = fighter.velocity.length()
		if nominal_speed > 0.1:
			var stride_ratio: float = actual_speed / nominal_speed
			anim_player.speed_scale = clamp(stride_ratio, 0.4, 1.8)
		else:
			anim_player.speed_scale = 1.0
	else:
		anim_player.speed_scale = 1.0
