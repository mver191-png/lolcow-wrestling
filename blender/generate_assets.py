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
    
    # Materials
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
    
    # Canvas platform (8x8m, 1m high, top at y=0)
    # In Blender: Z is up, X is right, Y is forward
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
        
        # Turnbuckle pads at 3 heights: 0.5, 1.0, 1.5
        for h in [0.5, 1.0, 1.5]:
            bpy.ops.mesh.primitive_cube_add(size=0.18, location=(cx * 0.96, cy * 0.96, h))
            pad = bpy.context.active_object
            pad.name = f"{name}_Pad_{h}"
            pad.data.materials.append(cmat)
            
    # 3-tier Ropes on 4 sides
    for h in [0.5, 1.0, 1.5]:
        # North & South ropes
        for y_pos in [-3.8, 3.8]:
            bpy.ops.mesh.primitive_cylinder_add(radius=0.035, depth=7.6, location=(0, y_pos, h))
            rope = bpy.context.active_object
            rope.rotation_euler = (0, math.radians(90), 0)
            rope.name = f"Rope_NS_{y_pos}_{h}"
            rope.data.materials.append(mat_rope)
        # East & West ropes
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
    
    # Stylized heavyweight character mesh: broad torso, recognizable hair volume, wrestling outfit
    mat_skin = create_material("SkinTophiachu", (0.55, 0.38, 0.28, 1.0), roughness=0.6)
    mat_hair = create_material("HairTophiachu", (0.12, 0.08, 0.05, 1.0), roughness=0.9)
    mat_outfit = create_material("OutfitTophiachu", (0.42, 0.18, 0.52, 1.0), roughness=0.5) # Purple
    mat_boots = create_material("BootsTophiachu", (0.1, 0.1, 0.12, 1.0), roughness=0.4)
    mat_wraps = create_material("WrapsTophiachu", (0.85, 0.85, 0.85, 1.0), roughness=0.8)
    
    # Root
    root = bpy.data.objects.new("TophiachuRoot", None)
    bpy.context.collection.objects.link(root)
    
    # Torso (Heavyweight, grounded)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.55, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.scale = (1.1, 0.95, 1.25)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_outfit)
    torso.parent = root
    
    # Head
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.32, location=(0, 0, 1.78))
    head = bpy.context.active_object
    head.scale = (1.05, 1.0, 1.05)
    bpy.ops.object.transform_apply(scale=True)
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    # Hair volume (distinct curly silhouette)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.38, location=(0, -0.05, 1.90))
    hair = bpy.context.active_object
    hair.scale = (1.2, 1.15, 0.95)
    bpy.ops.object.transform_apply(scale=True)
    hair.name = "Hair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    # Arms & Wrist wraps
    for side, x in [("L", -0.65), ("R", 0.65)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.16, depth=0.7, location=(x, 0, 1.25))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        # Wrist wraps
        bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.2, location=(x, 0, 0.95))
        wrap = bpy.context.active_object
        wrap.name = f"Wrap_{side}"
        wrap.data.materials.append(mat_wraps)
        wrap.parent = root
        
    # Heavyweight Legs & Boots
    for side, x in [("L", -0.32), ("R", 0.32)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.22, depth=0.6, location=(x, 0, 0.55))
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

def build_cyraxx(output_path):
    clear_scene()
    
    # Lightweight, compact frame: lean torso, scruffy headwear/hair, olive/black gear
    mat_skin = create_material("SkinCyraxx", (0.75, 0.65, 0.55, 1.0), roughness=0.6)
    mat_beanie = create_material("BeanieCyraxx", (0.15, 0.15, 0.18, 1.0), roughness=0.8)
    mat_gear = create_material("GearCyraxx", (0.12, 0.35, 0.22, 1.0), roughness=0.5) # Olive Green
    mat_boots = create_material("BootsCyraxx", (0.08, 0.08, 0.08, 1.0), roughness=0.3)
    
    root = bpy.data.objects.new("CyraxxRoot", None)
    bpy.context.collection.objects.link(root)
    
    # Lean Torso
    bpy.ops.mesh.primitive_cylinder_add(radius=0.28, depth=0.65, location=(0, 0, 1.05))
    torso = bpy.context.active_object
    torso.scale = (0.9, 0.75, 1.0)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_gear)
    torso.parent = root
    
    # Head & Beanie
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
    
    # Arms (Lean burst striker)
    for side, x in [("L", -0.42), ("R", 0.42)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.09, depth=0.6, location=(x, 0, 1.1))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
    # Legs & high boots
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

def build_referee_cobra(output_path):
    clear_scene()
    
    # Referee KingCobraJFS (1991-2025): Striped referee shirt, gothic accents, glowing gold halo
    mat_skin = create_material("SkinCobra", (0.7, 0.58, 0.48, 1.0), roughness=0.6)
    mat_stripes = create_material("RefereeShirt", (0.9, 0.9, 0.9, 1.0), roughness=0.6)
    mat_hat = create_material("GothicHat", (0.05, 0.05, 0.06, 1.0), roughness=0.5)
    mat_pants = create_material("RefereePants", (0.08, 0.08, 0.1, 1.0), roughness=0.5)
    mat_halo = create_material("HaloGold", (1.0, 0.82, 0.2, 1.0), roughness=0.1, metallic=0.2, emission_color=(1.0, 0.85, 0.25, 1.0), emission_strength=4.0)
    
    root = bpy.data.objects.new("RefereeRoot", None)
    bpy.context.collection.objects.link(root)
    
    # Torso (Referee uniform)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.34, depth=0.75, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.name = "Torso"
    torso.data.materials.append(mat_stripes)
    torso.parent = root
    
    # Black stripes on shirt
    for i in range(4):
        angle = i * (math.pi / 2)
        bpy.ops.mesh.primitive_cube_add(size=0.08, location=(0.32 * math.cos(angle), 0.32 * math.sin(angle), 1.15))
        stripe = bpy.context.active_object
        stripe.scale = (0.2, 0.8, 9.0)
        bpy.ops.object.transform_apply(scale=True)
        stripe.name = f"Stripe_{i}"
        stripe.data.materials.append(mat_hat)
        stripe.parent = root
        
    # Head & Gothic Hat
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.24, location=(0, 0, 1.68))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    # Hat / bandana
    bpy.ops.mesh.primitive_cylinder_add(radius=0.32, depth=0.15, location=(0, 0, 1.82))
    hat_brim = bpy.context.active_object
    hat_brim.name = "HatBrim"
    hat_brim.data.materials.append(mat_hat)
    hat_brim.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.22, depth=0.25, location=(0, 0, 1.95))
    hat_top = bpy.context.active_object
    hat_top.name = "HatTop"
    hat_top.data.materials.append(mat_hat)
    hat_top.parent = root
    
    # Permanent Gold Memorial Halo floating above head
    bpy.ops.mesh.primitive_torus_add(major_radius=0.35, minor_radius=0.045, location=(0, 0, 2.25))
    halo = bpy.context.active_object
    halo.name = "HaloMesh"
    halo.data.materials.append(mat_halo)
    halo.parent = root
    
    # Arms
    for side, x in [("L", -0.48), ("R", 0.48)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.11, depth=0.65, location=(x, 0, 1.2))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_stripes)
        arm.parent = root
        
    # Pants & Boots
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
    build_cyraxx(os.path.join(models_dir, "cyraxx.glb"))
    build_referee_cobra(os.path.join(models_dir, "referee_cobra.glb"))
    print("ALL ASSETS GENERATED SUCCESSFULLY!")
