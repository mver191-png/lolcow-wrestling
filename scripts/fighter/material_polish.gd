class_name MaterialPolish
extends RefCounted
## Optional Forward+ material overrides. Imported PBR materials are the fallback.
## The Compatibility backend reproduced invalid material RID diagnostics during
## immediate model replacement with overrides enabled. Do not apply that path.
static func _has_property(object: Object, name: StringName) -> bool:
 for property in object.get_property_list():
  if property.name == name: return true
 return false

static func apply(root: Node) -> int:
 if DisplayServer.get_name() == "headless": return 0
 if RenderingServer.get_current_rendering_method() != "forward_plus": return 0
 var changed := 0
 if root is MeshInstance3D and root.mesh:
  for surface in range(root.mesh.get_surface_count()):
   var source := root.get_active_material(surface) as StandardMaterial3D
   if source == null: continue
   # The material is instance-local; immutable imported textures remain shared.
   var material := source.duplicate(false) as StandardMaterial3D
   var name := material.resource_name.to_lower()
   if name.contains("skin"):
    material.roughness = .58
    material.metallic = 0.0
    material.specular_mode = BaseMaterial3D.SPECULAR_SCHLICK_GGX
    if _has_property(material, &"subsurf_scatter_enabled"): material.set("subsurf_scatter_enabled",true)
    if _has_property(material, &"subsurf_scatter_strength"): material.set("subsurf_scatter_strength",.18)
   elif name.contains("hair"):
    material.roughness = .76
    material.metallic = 0.0
   elif name.contains("boots"):
    material.roughness = .40
    material.metallic = .02
   elif name.contains("gear") or name.contains("trim") or name.contains("wrap"):
    material.roughness = .68 if name.contains("gear") else .52
    material.metallic = .01
   elif name.contains("eyes"):
    material.roughness = .20
   root.set_surface_override_material(surface, material)
   changed += 1
 for child in root.get_children(): changed += apply(child)
 return changed
