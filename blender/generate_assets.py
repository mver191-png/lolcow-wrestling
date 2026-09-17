import bpy
import math
import os

def clear_scene():
    bpy.ops.wm.read_factory_settings(use_empty=True)

def create_material(name, diffuse_color, roughness=0.5, metallic=0.0, emission_color=None, emission_strength=0.0):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    bsdf = nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs['Base Color'].default_value = diffuse_color
        bsdf.inputs['Roughness'].default_value = roughness
        bsdf.inputs['Metallic'].default_value = metallic
        if emission_color and 'Emission Color' in bsdf.inputs:
            bsdf.inputs['Emission Color'].default_value = emission_color
            bsdf.inputs['Emission Strength'].default_value = emission_strength
    return mat

def build_ring(output_path):
    clear_scene()
    
    mat_canvas = create_material("MatCanvas", (0.88, 0.85, 0.78, 1.0), roughness=0.9)
    mat_apron = create_material("MatApron", (0.1, 0.1, 0.12, 1.0), roughness=0.7)
    mat_post_red = create_material("MatPostRed", (0.8, 0.1, 0.1, 1.0), roughness=0.3, metallic=0.7)
    mat_post_blue = create_material("MatPostBlue", (0.1, 0.2, 0.8, 1.0), roughness=0.3, metallic=0.7)
    mat_post_white = create_material("MatPostWhite", (0.9, 0.9, 0.9, 1.0), roughness=0.4, metallic=0.5)
    mat_rope = create_material("MatRope", (0.85, 0.05, 0.05, 1.0), roughness=0.6)
    mat_floor = create_material("MatFloor", (0.05, 0.05, 0.06, 1.0), roughness=0.8)
    
    # Arena floor
    bpy.ops.mesh.primitive_plane_add(size=30.0, location=(0, 0, -1.0))
    floor = bpy.context.active_object
    floor.name = "ArenaFloor"
    floor.data.materials.append(mat_floor)
    
    # Canvas platform
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, -0.5))
    canvas_box = bpy.context.active_object
    canvas_box.name = "RingPlatform"
    canvas_box.scale = (8.0, 8.0, 1.0)
    bpy.ops.object.transform_apply(scale=True)
    canvas_box.data.materials.append(mat_apron)
    
    # Canvas top sheet
    bpy.ops.mesh.primitive_plane_add(size=7.6, location=(0, 0, 0.01))
    canvas_sheet = bpy.context.active_object
    canvas_sheet.name = "RingCanvas"
    canvas_sheet.data.materials.append(mat_canvas)
    
    # Corner posts at (+-3.8, +-3.8)
    corners = [
        ("PostRed", 3.8, 3.8, mat_post_red),
        ("PostBlue", -3.8, -3.8, mat_post_blue),
        ("PostWhite1", -3.8, 3.8, mat_post_white),
        ("PostWhite2", 3.8, -3.8, mat_post_white),
    ]
    
    for name, cx, cy, cmat in corners:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.1, depth=2.6, location=(cx, cy, 0.3))
        post = bpy.context.active_object
        post.name = name
        post.data.materials.append(cmat)
        
        for h in [0.5, 1.0, 1.5]:
            bpy.ops.mesh.primitive_cube_add(size=0.18, location=(cx * 0.96, cy * 0.96, h))
            pad = bpy.context.active_object
            pad.name = f"{name}_Pad_{h}"
            pad.data.materials.append(cmat)
            
    # 3-tier Ropes
    for h in [0.5, 1.0, 1.5]:
        for y_pos in [-3.8, 3.8]:
            bpy.ops.mesh.primitive_cylinder_add(radius=0.035, depth=7.6, location=(0, y_pos, h))
            rope = bpy.context.active_object
            rope.rotation_euler = (0, math.radians(90), 0)
            rope.name = f"Rope_NS_{y_pos}_{h}"
            rope.data.materials.append(mat_rope)
        for x_pos in [-3.8, 3.8]:
            bpy.ops.mesh.primitive_cylinder_add(radius=0.035, depth=7.6, location=(x_pos, 0, h))
            rope = bpy.context.active_object
            rope.rotation_euler = (math.radians(90), 0, 0)
            rope.name = f"Rope_EW_{x_pos}_{h}"
            rope.data.materials.append(mat_rope)
            
    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported arena to {output_path}")

def build_tophiachu(output_path):
    clear_scene()
    mat_skin = create_material("SkinTophiachu", (0.55, 0.38, 0.28, 1.0), roughness=0.6)
    mat_hair = create_material("HairTophiachu", (0.12, 0.08, 0.05, 1.0), roughness=0.9)
    mat_outfit = create_material("OutfitTophiachu", (0.45, 0.22, 0.58, 1.0), roughness=0.5)
    mat_boots = create_material("BootsTophiachu", (0.12, 0.12, 0.14, 1.0), roughness=0.4)
    mat_wraps = create_material("WrapsTophiachu", (0.85, 0.85, 0.85, 1.0), roughness=0.8)
    
    root = bpy.data.objects.new("TophiachuRoot", None)
    bpy.context.collection.objects.link(root)
    
    # Heavyweight Torso
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.55, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.scale = (1.35, 0.95, 1.30)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_outfit)
    torso.parent = root
    
    # Head & curly hair
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.32, location=(0, 0, 1.78))
    head = bpy.context.active_object
    head.scale = (1.05, 1.0, 1.05)
    bpy.ops.object.transform_apply(scale=True)
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.40, location=(0, -0.05, 1.92))
    hair = bpy.context.active_object
    hair.scale = (1.3, 1.2, 1.0)
    bpy.ops.object.transform_apply(scale=True)
    hair.name = "Hair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    for side, x in [("L", -0.68), ("R", 0.68)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.72, location=(x, 0, 1.25))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.20, depth=0.22, location=(x, 0, 0.95))
        wrap = bpy.context.active_object
        wrap.name = f"Wrap_{side}"
        wrap.data.materials.append(mat_wraps)
        wrap.parent = root
        
    for side, x in [("L", -0.34), ("R", 0.34)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.24, depth=0.6, location=(x, 0, 0.55))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_outfit)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.32, location=(x, 0.05, 0.16))
        boot = bpy.context.active_object
        boot.scale = (1.0, 1.4, 1.0)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Tophiachu to {output_path}")

def build_novaonline(output_path):
    clear_scene()
    mat_skin = create_material("SkinNova", (0.82, 0.68, 0.58, 1.0), roughness=0.5)
    mat_hair = create_material("HairNova", (0.15, 0.10, 0.08, 1.0), roughness=0.7)
    mat_gear = create_material("GearNova", (0.85, 0.15, 0.15, 1.0), roughness=0.4, metallic=0.3)
    mat_gold = create_material("GoldNova", (0.9, 0.8, 0.2, 1.0), roughness=0.25, metallic=0.7)
    mat_boots = create_material("BootsNova", (0.1, 0.1, 0.1, 1.0), roughness=0.3)
    
    root = bpy.data.objects.new("NovaRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cube_add(size=0.75, location=(0, 0, 1.25))
    torso = bpy.context.active_object
    torso.scale = (1.25, 0.85, 1.20)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_gear)
    torso.parent = root
    
    bpy.ops.mesh.primitive_cube_add(size=0.78, location=(0, 0, 0.95))
    belt = bpy.context.active_object
    belt.scale = (1.28, 0.88, 0.22)
    bpy.ops.object.transform_apply(scale=True)
    belt.name = "Belt"
    belt.data.materials.append(mat_gold)
    belt.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.28, location=(0, 0, 1.85))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.15, depth=0.4, location=(0, -0.22, 1.95))
    hair = bpy.context.active_object
    hair.rotation_euler = (math.radians(-35), 0, 0)
    hair.name = "Hair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    for side, x in [("L", -0.60), ("R", 0.60)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.16, depth=0.75, location=(x, 0, 1.30))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.20, location=(x, 0, 1.0))
        wrist = bpy.context.active_object
        wrist.name = f"Wrist_{side}"
        wrist.data.materials.append(mat_gold)
        wrist.parent = root
        
    for side, x in [("L", -0.28), ("R", 0.28)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.68, location=(x, 0, 0.58))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_gear)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.28, location=(x, 0.06, 0.16))
        boot = bpy.context.active_object
        boot.scale = (0.95, 1.35, 1.1)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported NovaOnline to {output_path}")

def build_cyraxx(output_path):
    clear_scene()
    mat_skin = create_material("SkinCyraxx", (0.75, 0.65, 0.55, 1.0), roughness=0.6)
    mat_beanie = create_material("BeanieCyraxx", (0.15, 0.15, 0.18, 1.0), roughness=0.8)
    mat_gear = create_material("GearCyraxx", (0.15, 0.55, 0.35, 1.0), roughness=0.5)
    mat_boots = create_material("BootsCyraxx", (0.08, 0.08, 0.08, 1.0), roughness=0.3)
    
    root = bpy.data.objects.new("CyraxxRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.28, depth=0.65, location=(0, 0, 1.05))
    torso = bpy.context.active_object
    torso.scale = (0.78, 0.70, 0.88)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_gear)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.22, location=(0, 0, 1.52))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.25, location=(0, -0.02, 1.62))
    beanie = bpy.context.active_object
    beanie.scale = (1.05, 1.1, 0.8)
    bpy.ops.object.transform_apply(scale=True)
    beanie.name = "Beanie"
    beanie.data.materials.append(mat_beanie)
    beanie.parent = root
    
    for side, x in [("L", -0.42), ("R", 0.42)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.09, depth=0.6, location=(x, 0, 1.1))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
    for side, x in [("L", -0.2), ("R", 0.2)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.55, location=(x, 0, 0.55))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_gear)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.22, location=(x, 0.05, 0.14))
        boot = bpy.context.active_object
        boot.scale = (0.8, 1.3, 1.2)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Cyraxx to {output_path}")

def build_candy_rooks(output_path):
    clear_scene()
    mat_skin = create_material("SkinCandy", (0.84, 0.70, 0.60, 1.0), roughness=0.6)
    mat_apron = create_material("ApronCandy", (0.85, 0.45, 0.65, 1.0), roughness=0.5)
    mat_bandana = create_material("BandanaCandy", (0.95, 0.95, 0.95, 1.0), roughness=0.6)
    mat_boots = create_material("BootsCandy", (0.15, 0.12, 0.15, 1.0), roughness=0.4)
    mat_wrap = create_material("WrapCandy", (0.9, 0.9, 0.9, 1.0), roughness=0.7)
    
    root = bpy.data.objects.new("CandyRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.52, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.scale = (1.22, 0.96, 1.20)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_apron)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.30, location=(0, 0, 1.74))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.33, depth=0.25, location=(0, 0, 1.90))
    bandana = bpy.context.active_object
    bandana.name = "Bandana"
    bandana.data.materials.append(mat_bandana)
    bandana.parent = root
    
    for side, x in [("L", -0.62), ("R", 0.62)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.17, depth=0.70, location=(x, 0, 1.22))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.19, depth=0.24, location=(x, 0, 0.95))
        tape = bpy.context.active_object
        tape.name = f"Tape_{side}"
        tape.data.materials.append(mat_wrap)
        tape.parent = root
        
    for side, x in [("L", -0.30), ("R", 0.30)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.21, depth=0.62, location=(x, 0, 0.55))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_apron)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.30, location=(x, 0.05, 0.15))
        boot = bpy.context.active_object
        boot.scale = (1.0, 1.35, 1.0)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Candy Rooks to {output_path}")

def build_andy_ditch(output_path):
    clear_scene()
    mat_skin = create_material("SkinAndy", (0.86, 0.72, 0.62, 1.0), roughness=0.6)
    mat_dungarees = create_material("DungareesAndy", (0.25, 0.35, 0.65, 1.0), roughness=0.7)
    mat_pads = create_material("PadsAndy", (0.6, 0.6, 0.6, 1.0), roughness=0.5)
    mat_boots = create_material("BootsAndy", (0.1, 0.1, 0.1, 1.0), roughness=0.4)
    
    root = bpy.data.objects.new("AndyRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.56, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.scale = (1.30, 0.92, 1.25)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_dungarees)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.31, location=(0, 0, 1.75))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    for side, x in [("L", -0.65), ("R", 0.65)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.17, depth=0.68, location=(x, 0, 1.20))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.20, depth=0.20, location=(x, 0, 1.20))
        pad = bpy.context.active_object
        pad.name = f"Pad_{side}"
        pad.data.materials.append(mat_pads)
        pad.parent = root
        
    for side, x in [("L", -0.32), ("R", 0.32)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.22, depth=0.58, location=(x, 0, 0.54))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_dungarees)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.31, location=(x, 0.05, 0.15))
        boot = bpy.context.active_object
        boot.scale = (1.05, 1.35, 1.0)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Andy Ditch to {output_path}")

def build_jupiter_the_hybrid(output_path):
    clear_scene()
    mat_skin = create_material("SkinJupiter", (0.80, 0.68, 0.58, 1.0), roughness=0.5)
    mat_violet = create_material("VioletJupiter", (0.2, 0.1, 0.35, 1.0), roughness=0.4)
    mat_silver = create_material("SilverJupiter", (0.8, 0.8, 0.9, 1.0), roughness=0.2, metallic=0.6)
    mat_hair = create_material("HairJupiter", (0.1, 0.05, 0.15, 1.0), roughness=0.6)
    mat_boots = create_material("BootsJupiter", (0.15, 0.15, 0.18, 1.0), roughness=0.4)
    
    root = bpy.data.objects.new("JupiterRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.32, depth=0.75, location=(0, 0, 1.25))
    torso = bpy.context.active_object
    torso.scale = (1.05, 0.82, 1.02)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_violet)
    torso.parent = root
    
    bpy.ops.mesh.primitive_torus_add(major_radius=0.36, minor_radius=0.06, location=(0, 0, 1.0))
    sash = bpy.context.active_object
    sash.name = "Sash"
    sash.data.materials.append(mat_silver)
    sash.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.27, location=(0, 0, 1.82))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.5, location=(0, -0.22, 1.90))
    hair = bpy.context.active_object
    hair.rotation_euler = (math.radians(-45), 0, 0)
    hair.name = "Hair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    for side, x in [("L", -0.52), ("R", 0.52)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.72, location=(x, 0, 1.25))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.14, depth=0.20, location=(x, 0, 0.98))
        wrap = bpy.context.active_object
        wrap.name = f"SilverWrap_{side}"
        wrap.data.materials.append(mat_silver)
        wrap.parent = root
        
    for side, x in [("L", -0.24), ("R", 0.24)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.16, depth=0.68, location=(x, 0, 0.58))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_violet)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.26, location=(x, 0.05, 0.15))
        boot = bpy.context.active_object
        boot.scale = (0.9, 1.3, 1.1)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Jupiter the Hybrid to {output_path}")

def build_anacondasin(output_path):
    clear_scene()
    mat_skin = create_material("SkinAnaconda", (0.78, 0.65, 0.54, 1.0), roughness=0.5)
    mat_green = create_material("GreenAnaconda", (0.15, 0.45, 0.25, 1.0), roughness=0.3)
    mat_gold = create_material("GoldAnaconda", (0.85, 0.75, 0.3, 1.0), roughness=0.25, metallic=0.7)
    mat_boots = create_material("BootsAnaconda", (0.1, 0.15, 0.1, 1.0), roughness=0.3)
    
    root = bpy.data.objects.new("AnacondaRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.33, depth=0.70, location=(0, 0, 1.18))
    torso = bpy.context.active_object
    torso.scale = (1.10, 0.85, 1.10)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_green)
    torso.parent = root
    
    bpy.ops.mesh.primitive_torus_add(major_radius=0.36, minor_radius=0.05, location=(0, 0, 0.95))
    belt = bpy.context.active_object
    belt.name = "SerpentBelt"
    belt.data.materials.append(mat_gold)
    belt.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.26, location=(0, 0, 1.70))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    for side, x in [("L", -0.52), ("R", 0.52)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.13, depth=0.68, location=(x, 0, 1.20))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.15, depth=0.18, location=(x, 0, 1.15))
        wrap = bpy.context.active_object
        wrap.name = f"ElbowWrap_{side}"
        wrap.data.materials.append(mat_gold)
        wrap.parent = root
        
    for side, x in [("L", -0.25), ("R", 0.25)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.17, depth=0.64, location=(x, 0, 0.55))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_green)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.27, location=(x, 0.05, 0.14))
        boot = bpy.context.active_object
        boot.scale = (0.9, 1.35, 1.1)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported AnacondaSin to {output_path}")

def build_daniel_larson(output_path):
    clear_scene()
    mat_skin = create_material("SkinDaniel", (0.85, 0.72, 0.62, 1.0), roughness=0.6)
    mat_orange = create_material("OrangeDaniel", (0.85, 0.45, 0.1, 1.0), roughness=0.5)
    mat_slate = create_material("SlateDaniel", (0.2, 0.2, 0.25, 1.0), roughness=0.6)
    mat_hair = create_material("HairDaniel", (0.45, 0.35, 0.25, 1.0), roughness=0.9)
    mat_shoes = create_material("ShoesDaniel", (0.8, 0.8, 0.8, 1.0), roughness=0.4)
    
    root = bpy.data.objects.new("DanielRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.27, depth=0.72, location=(0, 0, 1.25))
    torso = bpy.context.active_object
    torso.scale = (0.82, 0.75, 1.02)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_orange)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.25, location=(0, 0, 1.78))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.28, location=(0, -0.02, 1.90))
    hair = bpy.context.active_object
    hair.scale = (1.1, 1.05, 0.75)
    bpy.ops.object.transform_apply(scale=True)
    hair.name = "MessyHair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    for side, x in [("L", -0.46), ("R", 0.46)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.09, depth=0.74, location=(x, 0, 1.22))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_orange)
        arm.parent = root
        
    for side, x in [("L", -0.22), ("R", 0.22)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.72, location=(x, 0, 0.58))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_slate)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.24, location=(x, 0.06, 0.14))
        shoe = bpy.context.active_object
        shoe.scale = (0.85, 1.4, 0.9)
        bpy.ops.object.transform_apply(scale=True)
        shoe.name = f"Shoe_{side}"
        shoe.data.materials.append(mat_shoes)
        shoe.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Daniel Larson to {output_path}")

def build_referee_cobra(output_path):
    clear_scene()
    mat_skin = create_material("SkinCobra", (0.7, 0.58, 0.48, 1.0), roughness=0.6)
    mat_stripes = create_material("RefereeShirt", (0.9, 0.9, 0.9, 1.0), roughness=0.6)
    mat_hat = create_material("GothicHat", (0.05, 0.05, 0.06, 1.0), roughness=0.5)
    mat_pants = create_material("RefereePants", (0.08, 0.08, 0.1, 1.0), roughness=0.5)
    mat_halo = create_material("HaloGold", (1.0, 0.82, 0.2, 1.0), roughness=0.1, metallic=0.2, emission_color=(1.0, 0.85, 0.25, 1.0), emission_strength=4.0)
    
    root = bpy.data.objects.new("RefereeRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.34, depth=0.75, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.name = "Torso"
    torso.data.materials.append(mat_stripes)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.26, location=(0, 0, 1.68))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.48, depth=0.05, location=(0, 0, 1.82))
    brim = bpy.context.active_object
    brim.name = "HatBrim"
    brim.data.materials.append(mat_hat)
    brim.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.28, depth=0.32, location=(0, 0, 2.0))
    crown = bpy.context.active_object
    crown.name = "HatCrown"
    crown.data.materials.append(mat_hat)
    crown.parent = root
    
    # Permanent Gold Memorial Halo
    bpy.ops.mesh.primitive_torus_add(major_radius=0.35, minor_radius=0.045, location=(0, 0, 2.30))
    halo = bpy.context.active_object
    halo.name = "HaloMesh"
    halo.data.materials.append(mat_halo)
    halo.parent = root
    
    for side, x in [("L", -0.48), ("R", 0.48)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.11, depth=0.65, location=(x, 0, 1.2))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_stripes)
        arm.parent = root
        
    for side, x in [("L", -0.22), ("R", 0.22)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.15, depth=0.65, location=(x, 0, 0.58))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_pants)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.26, location=(x, 0.05, 0.14))
        boot = bpy.context.active_object
        boot.scale = (0.9, 1.3, 1.0)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_hat)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Referee to {output_path}")

if __name__ == "__main__":
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    models_dir = os.path.join(base_dir, "assets", "models")
    os.makedirs(models_dir, exist_ok=True)
    
    build_ring(os.path.join(models_dir, "ring_arena.glb"))
    build_tophiachu(os.path.join(models_dir, "tophiachu.glb"))
    build_novaonline(os.path.join(models_dir, "novaonline.glb"))
    build_cyraxx(os.path.join(models_dir, "cyraxx.glb"))
    build_candy_rooks(os.path.join(models_dir, "candy_rooks.glb"))
    build_andy_ditch(os.path.join(models_dir, "andy_ditch.glb"))
    build_jupiter_the_hybrid(os.path.join(models_dir, "jupiter_the_hybrid.glb"))
    build_anacondasin(os.path.join(models_dir, "anacondasin.glb"))
    build_daniel_larson(os.path.join(models_dir, "daniel_larson.glb"))
    build_referee_cobra(os.path.join(models_dir, "referee_cobra.glb"))
    print("ALL 8 ROSTER ASSETS + REFEREE GENERATED SUCCESSFULLY!")
