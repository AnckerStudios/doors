@tool
extends RigidBody3D

var path_dict = {"Blue": 'testCube_blue', "Red": 'testCube_red', "Green": 'testCube_green'}
@export_enum("Red", "Blue", "Green") var color = 'Blue':
	set(new_color):
		color = new_color
		change_color()



@onready var cube_mesh : MeshInstance3D = $MeshInstance3D
@onready var base_shader = preload("res://shaders/plane_cut_shader.gdshader")

var implements = Interface.Portable

func _ready() -> void:
	Interface._check_node(self)
	change_color()

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
	
