# Blender 5.0 Skinned Character & Animation Generator for Tophiachu
# Specialized production script for LOLCOW WRESTLING: OFFLINE MAYHEM
import bpy
import bmesh
import math
from mathutils import Vector, Euler

def clear_scene():
    bpy.ops.wm.read_factory_settings(use_empty=True)

def create_material(name, diffuse_color, roughness=0.5, metallic=0.0):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    bsdf = nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs['Base Color'].default_value = diffuse_color
        bsdf.inputs['Roughness'].default_value = roughness
        bsdf.inputs['Metallic'].default_value = metallic
    return mat

def build_humanoid_armature():
    arm_data = bpy.data.armatures.new("TophiachuArmature")
    arm_obj = bpy.data.objects.new("TophiachuArmature", arm_data)
    bpy.context.collection.objects.link(arm_obj)
    bpy.context.view_layer.objects.active = arm_obj
    
    bpy.ops.object.mode_set(mode='EDIT')
    eb = arm_data.edit_bones
    
    # Floor Root
    root = eb.new("Root")
    root.head = (0, 0, 0)
    root.tail = (0, 0, 0.1)
    
    # Pelvis / Hips
    hips = eb.new("Hips")
    hips.head = (0, 0, 0.88)
    hips.tail = (0, 0, 1.04)
    hips.parent = root
    
    # Spine & Torso
    spine = eb.new("Spine")
    spine.head = (0, 0, 1.04)
    spine.tail = (0, 0, 1.24)
    spine.parent = hips
    
    chest = eb.new("Chest")
    chest.head = (0, 0, 1.24)
    chest.tail = (0, 0, 1.46)
    chest.parent = spine
    
    # Neck & Head
    neck = eb.new("Neck")
    neck.head = (0, 0, 1.46)
    neck.tail = (0, 0, 1.56)
    neck.parent = chest
    
    head = eb.new("Head")
    head.head = (0, 0, 1.56)
    head.tail = (0, 0, 1.82)
    head.parent = neck
    
    # Shoulders & Arms
    for side, sign in [("L", 1.0), ("R", -1.0)]:
        clav = eb.new(f"Clavicle.{side}")
        clav.head = (sign * 0.05, 0, 1.42)
        clav.tail = (sign * 0.22, 0, 1.40)
        clav.parent = chest
        
        upper_arm = eb.new(f"UpperArm.{side}")
        upper_arm.head = (sign * 0.24, 0, 1.38)
        upper_arm.tail = (sign * 0.44, 0, 1.14)
        upper_arm.parent = clav
        
        forearm = eb.new(f"Forearm.{side}")
        forearm.head = (sign * 0.44, 0, 1.14)
        forearm.tail = (sign * 0.54, 0, 0.88)
        forearm.parent = upper_arm
        
        hand = eb.new(f"Hand.{side}")
        hand.head = (sign * 0.54, 0, 0.88)
        hand.tail = (sign * 0.58, 0, 0.74)
        hand.parent = forearm
        
    # Legs & Feet
    for side, sign in [("L", 1.0), ("R", -1.0)]:
        thigh = eb.new(f"Thigh.{side}")
        thigh.head = (sign * 0.18, 0, 0.88)
        thigh.tail = (sign * 0.18, 0, 0.50)
        thigh.parent = hips
        
        shin = eb.new(f"Shin.{side}")
        shin.head = (sign * 0.18, 0, 0.50)
        shin.tail = (sign * 0.18, 0, 0.12)
        shin.parent = thigh
        
        foot = eb.new(f"Foot.{side}")
        foot.head = (sign * 0.18, 0, 0.12)
        foot.tail = (sign * 0.18, -0.16, 0.03)
        foot.parent = shin
        
        toe = eb.new(f"Toe.{side}")
        toe.head = (sign * 0.18, -0.16, 0.03)
        toe.tail = (sign * 0.18, -0.24, 0.01)
        toe.parent = foot

    bpy.ops.object.mode_set(mode='OBJECT')
    return arm_obj

def build_character_mesh(arm_obj):
    # Materials
    mat_skin = create_material("SkinTophiachu", (0.58, 0.40, 0.30, 1.0), roughness=0.65)
    mat_hair = create_material("HairTophiachu", (0.14, 0.09, 0.06, 1.0), roughness=0.85)
    mat_outfit = create_material("OutfitTophiachu", (0.38, 0.16, 0.48, 1.0), roughness=0.45)
    mat_trim = create_material("TrimTophiachu", (0.08, 0.08, 0.10, 1.0), roughness=0.50)
    mat_boots = create_material("BootsTophiachu", (0.08, 0.08, 0.09, 1.0), roughness=0.35)
    mat_wraps = create_material("WrapsTophiachu", (0.88, 0.88, 0.90, 1.0), roughness=0.80)
    mat_eyes = create_material("EyesTophiachu", (0.95, 0.95, 0.95, 1.0), roughness=0.20)
    
    mesh_data = bpy.data.meshes.new("TophiachuMesh")
    mesh_obj = bpy.data.objects.new("TophiachuMesh", mesh_data)
    bpy.context.collection.objects.link(mesh_obj)
    
    mesh_obj.data.materials.append(mat_skin)    # 0
    mesh_obj.data.materials.append(mat_outfit)  # 1
    mesh_obj.data.materials.append(mat_trim)    # 2
    mesh_obj.data.materials.append(mat_hair)    # 3
    mesh_obj.data.materials.append(mat_boots)   # 4
    mesh_obj.data.materials.append(mat_wraps)   # 5
    mesh_obj.data.materials.append(mat_eyes)    # 6
    
    bm = bmesh.new()
    
    # 1. Heavyweight Torso (Hips to Shoulders)
    torso_slices = [
        (0.86, 0.36, 0.28, 1), # lower hips
        (0.96, 0.40, 0.30, 1), # hips peak
        (1.08, 0.38, 0.29, 1), # lower waist
        (1.18, 0.36, 0.28, 1), # mid waist
        (1.28, 0.39, 0.30, 1), # lower chest
        (1.38, 0.42, 0.31, 1), # chest peak
        (1.46, 0.35, 0.25, 2), # upper chest / neckline trim
    ]
    num_seg = 16
    torso_rings = []
    prev_ring = None
    
    for z, rx, ry, m_idx in torso_slices:
        current_ring = []
        for i in range(num_seg):
            angle = 2.0 * math.pi * i / num_seg
            vx = math.cos(angle) * rx
            vy = math.sin(angle) * ry
            vert = bm.verts.new((vx, vy, z))
            current_ring.append(vert)
        if prev_ring:
            for i in range(num_seg):
                ni = (i + 1) % num_seg
                f = bm.faces.new([prev_ring[i], prev_ring[ni], current_ring[ni], current_ring[i]])
                f.material_index = m_idx
        prev_ring = current_ring
        torso_rings.append(current_ring)
        
    # Cap bottom of hips
    bottom_center = bm.verts.new((0, 0, 0.86))
    first_ring = torso_rings[0]
    for i in range(num_seg):
        ni = (i + 1) % num_seg
        f = bm.faces.new([bottom_center, first_ring[ni], first_ring[i]])
        f.material_index = 1
        
    # 2. Neck
    neck_slices = [
        (1.46, 0.16, 0.15, 0),
        (1.52, 0.14, 0.13, 0),
        (1.58, 0.15, 0.14, 0),
    ]
    prev_neck = None
    for z, rx, ry, m_idx in neck_slices:
        current_ring = []
        for i in range(12):
            angle = 2.0 * math.pi * i / 12
            vx = math.cos(angle) * rx
            vy = math.sin(angle) * ry
            vert = bm.verts.new((vx, vy, z))
            current_ring.append(vert)
        if prev_neck:
            for i in range(12):
                ni = (i + 1) % 12
                f = bm.faces.new([prev_neck[i], prev_neck[ni], current_ring[ni], current_ring[i]])
                f.material_index = m_idx
        prev_neck = current_ring
        
    # 3. Head with Facial Structure
    head_slices = [
        (1.58, 0.17, 0.16, 0), # Jawline / Chin
        (1.64, 0.22, 0.21, 0), # Mouth & Cheeks
        (1.70, 0.23, 0.22, 0), # Nose bridge & Eyes
        (1.76, 0.22, 0.21, 0), # Brow & Forehead
        (1.82, 0.18, 0.18, 0), # Cranium top
        (1.86, 0.08, 0.08, 0), # Crown
    ]
    prev_head = None
    head_rings = []
    for z, rx, ry, m_idx in head_slices:
        current_ring = []
        for i in range(16):
            angle = 2.0 * math.pi * i / 16
            vx = math.cos(angle) * rx
            vy = math.sin(angle) * ry
            # Forward protrusion for nose / chin at front (negative Y)
            if angle > math.pi * 1.25 and angle < math.pi * 1.75:
                if 1.62 <= z <= 1.72:
                    vy -= 0.04 # Nose protrusion
                elif z < 1.62:
                    vy -= 0.025 # Chin protrusion
            vert = bm.verts.new((vx, vy, z))
            current_ring.append(vert)
        if prev_head:
            for i in range(16):
                ni = (i + 1) % 16
                f = bm.faces.new([prev_head[i], prev_head[ni], current_ring[ni], current_ring[i]])
                f.material_index = m_idx
        prev_head = current_ring
        head_rings.append(current_ring)
        
    # Top head cap
    top_center = bm.verts.new((0, 0, 1.88))
    last_head_ring = head_rings[-1]
    for i in range(len(last_head_ring)):
        ni = (i + 1) % len(last_head_ring)
        f = bm.faces.new([last_head_ring[i], last_head_ring[ni], top_center])
        f.material_index = 0
        
    # 4. Voluminous Curly Hair Mass
    hair_slices = [
        (1.72, 0.26, 0.25, 3),
        (1.78, 0.29, 0.28, 3),
        (1.84, 0.30, 0.29, 3),
        (1.90, 0.26, 0.25, 3),
        (1.94, 0.14, 0.14, 3),
    ]
    prev_hair = None
    hair_rings = []
    for z, rx, ry, m_idx in hair_slices:
        current_ring = []
        for i in range(16):
            angle = 2.0 * math.pi * i / 16
            vx = math.cos(angle) * rx
            vy = math.sin(angle) * ry + 0.05
            if angle < math.pi * 1.2 or angle > math.pi * 1.8:
                vx *= 1.15
                vy *= 1.20
            vert = bm.verts.new((vx, vy, z))
            current_ring.append(vert)
        if prev_hair:
            for i in range(16):
                ni = (i + 1) % 16
                f = bm.faces.new([prev_hair[i], prev_hair[ni], current_ring[ni], current_ring[i]])
                f.material_index = m_idx
        prev_hair = current_ring
        hair_rings.append(current_ring)
        
    hair_top = bm.verts.new((0, 0.05, 1.96))
    last_hair_ring = hair_rings[-1]
    for i in range(len(last_hair_ring)):
        ni = (i + 1) % len(last_hair_ring)
        f = bm.faces.new([last_hair_ring[i], last_hair_ring[ni], hair_top])
        f.material_index = 3
        
    # 5. Arms & Hands
    for side, sign in [("L", 1.0), ("R", -1.0)]:
        arm_segments = [
            (sign * 0.24, 0, 1.38, 0.13, 0), # Shoulder / Clavicle joint
            (sign * 0.34, 0, 1.26, 0.12, 0), # Bicep
            (sign * 0.44, 0, 1.14, 0.10, 0), # Elbow
            (sign * 0.49, 0, 1.01, 0.09, 5), # Forearm / Wrap start
            (sign * 0.54, 0, 0.88, 0.08, 5), # Wrist wrap
            (sign * 0.56, 0, 0.80, 0.07, 0), # Knuckles / Palm
            (sign * 0.58, 0, 0.74, 0.04, 0), # Finger tips
        ]
        prev_arm = None
        arm_rings = []
        for ax, ay, az, rad, m_idx in arm_segments:
            current_ring = []
            for i in range(8):
                angle = 2.0 * math.pi * i / 8
                vx = ax + math.sin(angle) * rad * 0.7
                vy = ay + math.cos(angle) * rad
                vz = az + math.sin(angle) * rad * 0.7
                vert = bm.verts.new((vx, vy, vz))
                current_ring.append(vert)
            if prev_arm:
                for i in range(8):
                    ni = (i + 1) % 8
                    f = bm.faces.new([prev_arm[i], prev_arm[ni], current_ring[ni], current_ring[i]])
                    f.material_index = m_idx
            prev_arm = current_ring
            arm_rings.append(current_ring)
            
        hand_tip = bm.verts.new((sign * 0.58, 0, 0.72))
        last_arm_ring = arm_rings[-1]
        for i in range(len(last_arm_ring)):
            ni = (i + 1) % len(last_arm_ring)
            f = bm.faces.new([last_arm_ring[i], last_arm_ring[ni], hand_tip])
            f.material_index = 0

    # 6. Legs & Boots
    for side, sign in [("L", 1.0), ("R", -1.0)]:
        leg_segments = [
            (sign * 0.18, 0, 0.86, 0.16, 1), # Upper thigh (singlet leg)
            (sign * 0.18, 0, 0.72, 0.15, 1), # Mid thigh
            (sign * 0.18, 0, 0.58, 0.14, 0), # Lower thigh (skin)
            (sign * 0.18, 0, 0.50, 0.13, 0), # Knee
            (sign * 0.18, 0, 0.38, 0.12, 0), # Upper calf (skin)
            (sign * 0.18, 0, 0.30, 0.13, 4), # Boot collar
            (sign * 0.18, 0, 0.16, 0.11, 4), # Ankle
            (sign * 0.18, -0.04, 0.06, 0.11, 4), # Heel / Instep
        ]
        prev_leg = None
        leg_rings = []
        for lx, ly, lz, rad, m_idx in leg_segments:
            current_ring = []
            for i in range(10):
                angle = 2.0 * math.pi * i / 10
                vx = lx + math.cos(angle) * rad
                vy = ly + math.sin(angle) * rad
                vz = lz
                vert = bm.verts.new((vx, vy, vz))
                current_ring.append(vert)
            if prev_leg:
                for i in range(10):
                    ni = (i + 1) % 10
                    f = bm.faces.new([prev_leg[i], prev_leg[ni], current_ring[ni], current_ring[i]])
                    f.material_index = m_idx
            prev_leg = current_ring
            leg_rings.append(current_ring)
            
        # Sole bottom cap
        sole_center = bm.verts.new((sign * 0.18, -0.04, 0.02))
        last_leg_ring = leg_rings[-1]
        for i in range(len(last_leg_ring)):
            ni = (i + 1) % len(last_leg_ring)
            f = bm.faces.new([sole_center, last_leg_ring[ni], last_leg_ring[i]])
            f.material_index = 4

    bm.to_mesh(mesh_data)
    bm.free()
    
    # Setup Vertex Groups & Assign Skin Weights
    vg_map = {}
    for bone_name in [
        "Root", "Hips", "Spine", "Chest", "Neck", "Head",
        "Clavicle.L", "Clavicle.R", "UpperArm.L", "UpperArm.R",
        "Forearm.L", "Forearm.R", "Hand.L", "Hand.R",
        "Thigh.L", "Thigh.R", "Shin.L", "Shin.R",
        "Foot.L", "Foot.R", "Toe.L", "Toe.R"
    ]:
        vg_map[bone_name] = mesh_obj.vertex_groups.new(name=bone_name)
        
    for v in mesh_obj.data.vertices:
        x, y, z = v.co.x, v.co.y, v.co.z
        
        # Head & Neck
        if z >= 1.54:
            vg_map["Head"].add([v.index], 1.0, 'REPLACE')
        elif z >= 1.45:
            t = (z - 1.45) / (1.54 - 1.45)
            vg_map["Neck"].add([v.index], 1.0 - t, 'REPLACE')
            vg_map["Head"].add([v.index], t, 'REPLACE')
        # Arms
        elif abs(x) >= 0.22 and z >= 0.70:
            side = "L" if x > 0 else "R"
            dist_along_arm = (abs(x) - 0.22) / 0.36
            if dist_along_arm < 0.25:
                vg_map[f"Clavicle.{side}"].add([v.index], 0.7, 'REPLACE')
                vg_map[f"UpperArm.{side}"].add([v.index], 0.3, 'REPLACE')
            elif dist_along_arm < 0.60:
                vg_map[f"UpperArm.{side}"].add([v.index], 0.8, 'REPLACE')
                vg_map[f"Forearm.{side}"].add([v.index], 0.2, 'REPLACE')
            elif dist_along_arm < 0.85:
                vg_map[f"Forearm.{side}"].add([v.index], 0.8, 'REPLACE')
                vg_map[f"Hand.{side}"].add([v.index], 0.2, 'REPLACE')
            else:
                vg_map[f"Hand.{side}"].add([v.index], 1.0, 'REPLACE')
        # Torso
        elif z >= 1.24:
            vg_map["Chest"].add([v.index], 1.0, 'REPLACE')
        elif z >= 1.04:
            t = (z - 1.04) / (1.24 - 1.04)
            vg_map["Spine"].add([v.index], 1.0 - t, 'REPLACE')
            vg_map["Chest"].add([v.index], t, 'REPLACE')
        elif z >= 0.86:
            t = (z - 0.86) / (1.04 - 0.86)
            vg_map["Hips"].add([v.index], 1.0 - t, 'REPLACE')
            vg_map["Spine"].add([v.index], t, 'REPLACE')
        # Legs
        else:
            side = "L" if x > 0 else "R"
            if z >= 0.50:
                vg_map[f"Thigh.{side}"].add([v.index], 1.0, 'REPLACE')
            elif z >= 0.16:
                t = (z - 0.16) / (0.50 - 0.16)
                vg_map[f"Shin.{side}"].add([v.index], 1.0 - t, 'REPLACE')
                vg_map[f"Thigh.{side}"].add([v.index], t, 'REPLACE')
            elif z >= 0.05:
                vg_map[f"Foot.{side}"].add([v.index], 1.0, 'REPLACE')
            else:
                vg_map[f"Toe.{side}"].add([v.index], 1.0, 'REPLACE')

    # Armature modifier
    mod = mesh_obj.modifiers.new("Armature", 'ARMATURE')
    mod.object = arm_obj
    mesh_obj.parent = arm_obj
    
    return mesh_obj

def add_bone_keyframe(arm_obj, bone_name, prop, value, frame):
    pb = arm_obj.pose.bones[bone_name]
    pb.rotation_mode = 'XYZ'
    setattr(pb, prop, value)
    pb.keyframe_insert(data_path=prop, frame=frame)

def author_animations(arm_obj):
    if not arm_obj.animation_data:
        arm_obj.animation_data_create()
        
    def create_clip(name):
        act = bpy.data.actions.new(name=name)
        arm_obj.animation_data.action = act
        return act
        
    def push_to_nla(act, name):
        track = arm_obj.animation_data.nla_tracks.new()
        track.name = name
        track.strips.new(name, 1, act)

    # -------------------------------------------------------------
    # 1. IDLE (60f loop): Heavyweight ready stance with weight shift
    # -------------------------------------------------------------
    act_idle = create_clip("idle")
    for f, hip_rot_y, hip_pos_z, chest_rot_x in [
        (1, 0.0, 0.0, 0.05),
        (15, 0.03, -0.02, 0.02),
        (30, 0.0, 0.0, 0.06),
        (45, -0.03, -0.02, 0.02),
        (60, 0.0, 0.0, 0.05)
    ]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, hip_pos_z), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.05, hip_rot_y, 0), f)
        add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (chest_rot_x, 0, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.5, 0.2, 0.3), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.5, -0.2, -0.3), f)
        add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.9, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.9, 0, 0), f)
        add_bone_keyframe(arm_obj, "Thigh.L", "rotation_euler", (-0.15, 0, 0.05), f)
        add_bone_keyframe(arm_obj, "Thigh.R", "rotation_euler", (-0.15, 0, -0.05), f)
        add_bone_keyframe(arm_obj, "Shin.L", "rotation_euler", (0.25, 0, 0), f)
        add_bone_keyframe(arm_obj, "Shin.R", "rotation_euler", (0.25, 0, 0), f)
    push_to_nla(act_idle, "idle")

    # -------------------------------------------------------------
    # 2. WALK (40f loop): Grounded heavyweight stride
    # -------------------------------------------------------------
    act_walk = create_clip("walk")
    for f, r_leg, l_leg, r_arm, l_arm in [
        (1, -0.35, 0.25, 0.4, -0.4),
        (10, -0.10, -0.10, 0.0, 0.0),
        (20, 0.25, -0.35, -0.4, 0.4),
        (30, -0.10, -0.10, 0.0, 0.0),
        (40, -0.35, 0.25, 0.4, -0.4)
    ]:
        add_bone_keyframe(arm_obj, "Thigh.R", "rotation_euler", (r_leg, 0, 0), f)
        add_bone_keyframe(arm_obj, "Thigh.L", "rotation_euler", (l_leg, 0, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (r_arm, 0, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (l_arm, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.5, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.5, 0, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.05, 0.05 if r_leg > 0 else -0.05, 0), f)
    push_to_nla(act_walk, "walk")

    # -------------------------------------------------------------
    # 3. STRIKE (30f one-shot): Heavy overhand blow with hip commitment
    # -------------------------------------------------------------
    act_strike = create_clip("strike")
    # F1: Stance
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0, 0, 0), 1)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.4, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.8, 0, 0), 1)
    # F6: Windup / Cocking back
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0, -0.25, 0), 6)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0, -0.30, 0), 6)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.7, 0.4, -0.5), 6)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-1.4, 0, 0), 6)
    # F14: Explosive Overhand Delivery (Matches strike active window)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.15, 0.50, 0), 14)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0.20, 0.55, 0), 14)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.3, -0.4, 0.2), 14)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.2, 0, 0), 14)
    # F22: Follow-through
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.10, 0.35, 0), 22)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0.15, 0.40, 0), 22)
    # F30: Recovery
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0, 0, 0), 30)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0, 0, 0), 30)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.5, -0.2, -0.3), 30)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.9, 0, 0), 30)
    push_to_nla(act_strike, "strike")

    # -------------------------------------------------------------
    # 4. KNOCKDOWN (45f): Fall backward and impact canvas flat
    # -------------------------------------------------------------
    act_kd = create_clip("knockdown")
    # F1: Impact reel
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (-0.3, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Head", "rotation_euler", (-0.5, 0, 0), 1)
    # F15: Falling back
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0.4, -0.5), 15)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-0.9, 0, 0), 15)
    # F24: Canvas mat impact
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0.8, -0.80), 24)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), 24)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0, 0, 0), 24)
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0, 0, 1.2), 24)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0, 0, -1.2), 24)
    add_bone_keyframe(arm_obj, "Thigh.L", "rotation_euler", (0.3, 0, 0), 24)
    add_bone_keyframe(arm_obj, "Thigh.R", "rotation_euler", (0.3, 0, 0), 24)
    # F45: Settle flat on canvas
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0.8, -0.80), 45)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), 45)
    push_to_nla(act_kd, "knockdown")

    # -------------------------------------------------------------
    # 5. GETUP (60f): Supported get-up through elbow, hand, knee, foot
    # -------------------------------------------------------------
    act_gu = create_clip("getup")
    # F1: Flat on back
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0.8, -0.80), 1)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), 1)
    # F15: Roll to left hip, plant left elbow & right foot
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0.6, -0.65), 15)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-1.2, 0, 0.6), 15)
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.4, 0, 0.8), 15)
    add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-1.2, 0, 0), 15)
    add_bone_keyframe(arm_obj, "Thigh.R", "rotation_euler", (0.8, 0, 0), 15)
    add_bone_keyframe(arm_obj, "Shin.R", "rotation_euler", (1.2, 0, 0), 15)
    # F30: Push up onto left hand, rise onto left knee, elevate hips
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0.3, -0.35), 30)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-0.5, 0, 0.3), 30)
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.2, 0, 0.4), 30)
    add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.3, 0, 0), 30)
    # F45: Bring right leg forward into lunge/squat, push off thighs
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0.1, -0.15), 45)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-0.2, 0, 0), 45)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0.2, 0, 0), 45)
    # F60: Rise fully to feet, return to ready idle stance
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, 0), 60)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.05, 0, 0), 60)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0.05, 0, 0), 60)
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.5, 0.2, 0.3), 60)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.5, -0.2, -0.3), 60)
    push_to_nla(act_gu, "getup")

    # -------------------------------------------------------------
    # 6. Safety & Baseline Gameplay Clips
    # -------------------------------------------------------------
    # Block
    act_blk = create_clip("block")
    for f in [1, 30]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (1.2, 0.3, -0.3), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.2, -0.3, 0.3), f)
        add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-1.5, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-1.5, 0, 0), f)
    push_to_nla(act_blk, "block")

    # Reversal
    act_rev = create_clip("reversal")
    for f in [1, 30]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.8, 0.5, 0.2), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.8, -0.5, -0.2), f)
    push_to_nla(act_rev, "reversal")

    # Grapple Startup
    act_grp = create_clip("grapple")
    for f in [1, 30]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (1.4, 0.1, 0.1), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.4, -0.1, -0.1), f)
        add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.2, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.2, 0, 0), f)
    push_to_nla(act_grp, "grapple")

    # Throw Attacker
    act_ta = create_clip("throw_attacker")
    for f, arm_x in [(1, 0.5), (20, 1.8), (35, 0.2), (45, 0.5)]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (arm_x, 0.2, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (arm_x, -0.2, 0), f)
    push_to_nla(act_ta, "throw_attacker")

    # Throw Defender
    act_td = create_clip("throw_defender")
    for f, rot_x, loc_z in [(1, 0, 0), (20, -1.5, 0.8), (35, -3.14, 0), (45, -3.14, 0)]:
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (rot_x, 0, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, loc_z), f)
    push_to_nla(act_td, "throw_defender")

    # Pinning (Cover)
    act_pinn = create_clip("pinning")
    for f in [1, 40]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, -0.6), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.8, 0, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.2, 0, 0), f)
    push_to_nla(act_pinn, "pinning")

    # Pinned (Grounded Struggle)
    act_pind = create_clip("pinned")
    for f in [1, 20, 40]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, -0.8), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), f)
        add_bone_keyframe(arm_obj, "Thigh.L", "rotation_euler", (0.4 if f == 20 else 0.1, 0, 0), f)
    push_to_nla(act_pind, "pinned")

    # Submission Attacker
    act_sa = create_clip("submission_attacker")
    for f in [1, 40]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, -0.4), f)
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (1.1, 0.2, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.1, -0.2, 0), f)
    push_to_nla(act_sa, "submission_attacker")

    # Submission Defender
    act_sd = create_clip("submission_defender")
    for f in [1, 40]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, -0.7), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-1.2, 0, 0), f)
    push_to_nla(act_sd, "submission_defender")

    # Victory
    act_vic = create_clip("victory")
    for f, arm_z in [(1, 0.5), (30, 2.2), (60, 2.0)]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (arm_z, 0, 0.6), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (arm_z, 0, -0.6), f)
    push_to_nla(act_vic, "victory")

    # Defeated
    act_def = create_clip("defeated")
    for f in [1, 40]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, 0.8, -0.80), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), f)
    push_to_nla(act_def, "defeated")

def main():
    clear_scene()
    print("Building Tophiachu Armature...")
    arm_obj = build_humanoid_armature()
    print("Building Tophiachu Skinned Mesh...")
    mesh_obj = build_character_mesh(arm_obj)
    print("Authoring Tophiachu Animations...")
    author_animations(arm_obj)
    
    output_path = "assets/models/tophiachu.glb"
    print(f"Exporting Tophiachu to {output_path}...")
    bpy.ops.export_scene.gltf(
        filepath=output_path,
        export_format='GLB',
        export_animations=True,
        export_skins=True,
        export_morph=False
    )
    print("Export Complete!")

if __name__ == "__main__":
    main()
