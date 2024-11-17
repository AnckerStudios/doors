@tool
extends RigidBody3D

var path_dict = {"Blue": 'testCube_blue', "Red": 'testCube_red', "Green": 'testCube_green'}
@export_enum("Red", "Blue", "Green") var color = 'Blue':
	set(new_color):
		color = new_color
		change_color()
@export var cube_scale: Vector3 = Vector3(1.0, 1.0, 1.0)


@onready var cube_mesh : MeshInstance3D = $MeshInstance3D
@onready var collision_shape : CollisionShape3D = $CollisionShape3D
@onready var base_shader = preload("res://shaders/plane_cut_shader.gdshader")

var implements = Interface.Portable

var gravity_points: Array[Vector3] = [
	Vector3(-0.5, -0.5, -0.5),
	Vector3(0.5, 0.5, 0.5),
	Vector3(-0.5, 0.5, 0.5),
	Vector3(0.5, -0.5, 0.5),
	Vector3(0.5, 0.5, -0.5),
	Vector3(-0.5, -0.5, 0.5),
	Vector3(-0.5, 0.5, -0.5),
	Vector3(0.5, -0.5, -0.5)
	]
var distance_points: Array[float]

var clone: RigidBody3D = null


func _ready() -> void:
	#Interface._check_node(self)
	change_color()
	
	collision_shape.shape = BoxShape3D.new()
	collision_shape.shape.size = cube_scale
	cube_mesh.scale = cube_scale
	

func _process(delta):
	pass

func change_color() -> void:
	var material = ShaderMaterial.new()
	material.shader = base_shader
	var texture = load("res://textures/testCube/"+path_dict[color]+".png")
	material.set_shader_parameter("base_texture", texture)
	material.set_shader_parameter("uv_scale", Vector3(3, 2, 1))
	
	$MeshInstance3D.material_override = material

func update_shader_parameters(plane_position: Vector3, plane_normal: Vector3):
	cube_mesh.material_override.set_shader_parameter("plane_position", plane_position)
	cube_mesh.material_override.set_shader_parameter("plane_normal", plane_normal)
	pass

func move_self_to_other_portal(new_transform: Transform3D):
	self.global_transform = new_transform
	pass
	
func update_clone(new_transform: Transform3D):
	if(clone):
		clone.global_transform = new_transform
	pass
	
func create_clone(new_transform: Transform3D):
	clone = preload("res://props/testCube/testCubeWithShader.tscn").instantiate()
	clone.color = self.color
	clone.cube_scale = self.cube_scale
	
	get_parent().add_child(clone)
	update_clone(new_transform)
	return clone

func remove_clone(other_portal_dict: Dictionary):
	if(clone):
		other_portal_dict.erase(clone)
		clone.queue_free()
		clone = null
	pass
	
func calc_distance_to_hand(hand: Vector3):
	distance_points = []
	#print("points:")
	for i in range(len(gravity_points)):
		distance_points.append((hand - gravity_points[i]).length())
		#print(distance_points[i])
		
func calculate_torque() -> Vector3:
	var force_sum = Vector3(.0, .0, .0)
	var point_mass = 0.001
	for i in range(len(distance_points)):
		force_sum += distance_points[i] * Vector3.DOWN  * point_mass
		
	return -force_sum * get_gravity()
