@tool
##Code taken from CodePoodle at:[br]
##https://www.youtube.com/watch?v=6qim01M1Yp0
class_name Terrain
extends MeshInstance3D
@export var size:int = 256

@export_range(4,256, 4) var detailedness = 32:
	set(value):
		detailedness = value
		update_mesh()

@export var noise: FastNoiseLite:
	set(value):
		noise = value
		update_mesh()
		noise.changed.connect(update_mesh)

@export var height:float = 64:
	set(value):
		height = value
		update_mesh()
@export var collision_shape_3d: CollisionShape3D

@export_tool_button("Force Update Mesh") var action = update_mesh
@export_tool_button("Re-Seed Noise") var action2 = _ready

func get_height(x:float,y:float) -> float:
	return noise.get_noise_2d(x, y) * height
	
func get_normal(x:float,y:float) -> Vector3:
	var epsilon:float = size / detailedness
	var normal = Vector3(
		(get_height(x + epsilon, y) - get_height(x - epsilon, y)) / 2 * epsilon, 
		1,
		(get_height(x, y + epsilon) - get_height(x, y - epsilon)) / 2 * epsilon
	)
	return normal

func update_mesh() -> void:
	var plane:PlaneMesh = PlaneMesh.new()
	plane.subdivide_depth = detailedness
	plane.subdivide_width = detailedness
	plane.size = Vector2(size,size)
	var plane_mesh_array:Array = plane.get_mesh_arrays()
	var vertex_array : PackedVector3Array = plane_mesh_array[ArrayMesh.ARRAY_VERTEX]
	var normal_array : PackedVector3Array = plane_mesh_array[ArrayMesh.ARRAY_NORMAL]
	var tangent_array : PackedFloat32Array = plane_mesh_array[ArrayMesh.ARRAY_TANGENT]
	for i in vertex_array.size():
		var vertex := vertex_array[i]
		var normal := Vector3.UP
		var tangent := Vector3.RIGHT
		if noise:
			vertex.y = get_height(vertex.x, vertex.z)
			normal = get_normal(vertex.x, vertex.z)
			tangent = normal + Vector3.UP
		vertex_array[i] = vertex
		normal_array[i] = normal
		tangent_array[4 * i] = tangent.x
		tangent_array[4 * i + 1] = tangent.y
		tangent_array[4 * i + 2] = tangent.z
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,plane_mesh_array)
	mesh = array_mesh
	if collision_shape_3d:
		collision_shape_3d.shape = mesh.create_trimesh_shape()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise.seed = randi()
	update_mesh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
