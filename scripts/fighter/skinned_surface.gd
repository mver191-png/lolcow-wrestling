class_name SkinnedSurface
extends RefCounted
## CPU-side linear skinning for validation and geometry-derived bounds.
## Uses imported Skin bind indices/names and inverse binds. No GPU readback.
## Ignores blend shapes, cloth simulation and shader displacement.
var skeleton: Skeleton3D
var _surfaces: Array[Dictionary] = []
var vertex_count := 0
var _groups: Array[Dictionary] = []

func setup(model: Node3D, rig: Skeleton3D) -> void:
 skeleton = rig
 _surfaces.clear()
 _groups.clear()
 vertex_count = 0
 _visit(model)

func _visit(node: Node) -> void:
 if node is MeshInstance3D and node.mesh != null and node.skin != null:
  var mesh_node: MeshInstance3D = node
  var skin: Skin = mesh_node.skin
  var binds: Array[Transform3D] = []
  var bone_ids: PackedInt32Array = []
  for i in range(skin.get_bind_count()):
   var id := skeleton.find_bone(skin.get_bind_name(i)) if not skin.get_bind_name(i).is_empty() else skin.get_bind_bone(i)
   if id < 0 or id >= skeleton.get_bone_count():
    push_error("Invalid skin bind on " + str(node.name))
    return
   bone_ids.append(id)
   binds.append(skin.get_bind_pose(i))
  for i in range(mesh_node.mesh.get_surface_count()):
   var arrays := mesh_node.mesh.surface_get_arrays(i)
   if arrays.is_empty() or arrays[Mesh.ARRAY_BONES] == null: continue
   var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
   var joints: PackedInt32Array = arrays[Mesh.ARRAY_BONES]
   var weights: PackedFloat32Array = arrays[Mesh.ARRAY_WEIGHTS]
   var stride: int = joints.size() / maxi(vertices.size(), 1)
   if stride not in [4,8] or weights.size() != joints.size():
    push_error("Invalid skin influence arrays")
    continue
   _surfaces.append({"v":vertices,"j":joints,"w":weights,"stride":stride,"binds":binds,"bones":bone_ids})
   vertex_count += vertices.size()
 for child in node.get_children(): _visit(child)

func world_vertices() -> PackedVector3Array:
 var result := PackedVector3Array()
 if not is_instance_valid(skeleton): return result
 skeleton.force_update_all_bone_transforms()
 result.resize(vertex_count)
 var cursor := 0
 for surface in _surfaces:
  var transforms: Array[Transform3D] = []
  for i in range(surface.bones.size()):
   transforms.append(skeleton.global_transform * skeleton.get_bone_global_pose(surface.bones[i]) * surface.binds[i])
  var vertices: PackedVector3Array = surface.v
  var joints: PackedInt32Array = surface.j
  var weights: PackedFloat32Array = surface.w
  var stride: int = surface.stride
  for v in range(vertices.size()):
   var point := Vector3.ZERO
   for k in range(stride):
    var w: float = weights[v * stride + k]
    if w > 0.0: point += (transforms[joints[v * stride + k]] * vertices[v]) * w
   result[cursor] = point
   cursor += 1
 return result

static func measure(points: PackedVector3Array, canvas_y := 0.0, rope_half_extent := 3.8) -> Dictionary:
 var lo := Vector3(INF,INF,INF)
 var hi := Vector3(-INF,-INF,-INF)
 var below := 0
 var outside := 0
 for p in points:
  lo = lo.min(p)
  hi = hi.max(p)
  if p.y < canvas_y - .005: below += 1
  if maxf(absf(p.x), absf(p.z)) > rope_half_extent: outside += 1
 return {"min":lo,"max":hi,"floor_penetration":maxf(0.0,canvas_y-lo.y),
  "rope_overhang":maxf(0.0,maxf(maxf(absf(lo.x),absf(hi.x)),maxf(absf(lo.z),absf(hi.z)))-rope_half_extent),
  "vertices":points.size(),"below_floor":below,"outside_rope_envelope":outside}

func prepare_bounds() -> void:
 ## Equal influence tuples define a single affine transform of the bind mesh.
 ## Transforming each group's AABB encloses every skinned vertex in that group.
 ## No weight quantization, subsampling or bone-center proxy is used.
 _groups.clear()
 for surface in _surfaces:
  var grouped: Dictionary = {}
  var vertices: PackedVector3Array = surface.v
  var joints: PackedInt32Array = surface.j
  var weights: PackedFloat32Array = surface.w
  var stride: int = surface.stride
  for i in range(vertices.size()):
   var j := joints.slice(i*stride,(i+1)*stride)
   var w := weights.slice(i*stride,(i+1)*stride)
   var key := j.to_byte_array().hex_encode() + w.to_byte_array().hex_encode()
   if grouped.has(key):
    var group: Dictionary = grouped[key]
    group.box = group.box.expand(vertices[i])
   else:
    grouped[key] = {"box":AABB(vertices[i],Vector3.ZERO),"j":j,"w":w,"binds":surface.binds,"bones":surface.bones}
  for group in grouped.values(): _groups.append(group)

func conservative_bounds() -> AABB:
 if _groups.is_empty(): prepare_bounds()
 var result := AABB()
 var first := true
 skeleton.force_update_all_bone_transforms()
 var poses: Array[Transform3D] = []
 for i in range(skeleton.get_bone_count()): poses.append(skeleton.get_bone_global_pose(i))
 for group in _groups:
  var x := Vector3.ZERO
  var y := Vector3.ZERO
  var z := Vector3.ZERO
  var o := Vector3.ZERO
  for k in range(group.j.size()):
   var weight: float = group.w[k]
   if weight <= 0.0: continue
   var index: int = group.j[k]
   var transform: Transform3D = poses[group.bones[index]] * group.binds[index]
   x += transform.basis.x * weight
   y += transform.basis.y * weight
   z += transform.basis.z * weight
   o += transform.origin * weight
  var box: AABB = (skeleton.global_transform * Transform3D(Basis(x,y,z),o)) * group.box
  result = box if first else result.merge(box)
  first = false
 return result
