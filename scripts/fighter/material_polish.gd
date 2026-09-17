class_name MaterialPolish
extends RefCounted
## Non-destructive runtime material tuning. Dummy/headless rendering cannot create
## valid material instances, so visual-only overrides are intentionally skipped.
static func _has_property(object:Object,name:StringName)->bool:
	for p in object.get_property_list():
		if p.name==name:return true
	return false
static func apply(root:Node)->int:
	if DisplayServer.get_name()=="headless":return 0
	var changed:=0
	if root is MeshInstance3D and root.mesh:
		for surface in range(root.mesh.get_surface_count()):
			var source:=root.get_active_material(surface) as StandardMaterial3D
			if source==null:continue
			var mat:=source.duplicate(true) as StandardMaterial3D;var name:=mat.resource_name.to_lower()
			if name.contains("skin"):
				mat.roughness=.58;mat.metallic=0.;mat.specular_mode=BaseMaterial3D.SPECULAR_SCHLICK_GGX
				if _has_property(mat,&"subsurf_scatter_enabled"):mat.set("subsurf_scatter_enabled",true)
				if _has_property(mat,&"subsurf_scatter_strength"):mat.set("subsurf_scatter_strength",.18)
			elif name.contains("hair"):mat.roughness=.76;mat.metallic=0.
			elif name.contains("boots"):mat.roughness=.40;mat.metallic=.02
			elif name.contains("gear") or name.contains("trim") or name.contains("wrap"):mat.roughness=.68 if name.contains("gear") else .52;mat.metallic=.01
			elif name.contains("eyes"):mat.roughness=.20
			root.set_surface_override_material(surface,mat);changed+=1
	for child in root.get_children():changed+=apply(child)
	return changed
