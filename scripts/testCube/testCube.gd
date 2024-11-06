@tool
extends RigidBody3D

var path_dict = {"Blue": 'testCube_blue', "Red": 'testCube_red', "Green": 'testCube_green'}
@export_enum("Red", "Blue", "Green") var color = 'Blue':
	set(new_color):
		color = new_color
		change_color()


@export var cutting_plane : MeshInstance3D = null

@onready var cube_mesh : MeshInstance3D = $MeshInstance3D
@onready var base_shader = preload("res://shaders/baseShader.gdshader")

func _ready() -> void:
	change_color()

#func _process(delta):
	#cube_mesh.material_override.set_shader_parameter("plane_position", cutting_plane.global_transform.origin)
	#cube_mesh.material_override.set_shader_parameter("plane_normal", Vector3(-1.0, .0, .0))

func change_color() -> void:
	var material = ShaderMaterial.new()
	material.shader = base_shader
	var texture = load("res://textures/testCube/"+path_dict[color]+".png")
	material.set_shader_parameter("base_texture", texture)
	material.set_shader_parameter("uv_scale", Vector3(3, 2, 1))
	
	$MeshInstance3D.material_override = material
