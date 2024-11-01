@tool
extends RigidBody3D

var path_dict = {"Blue": 'testCube_blue', "Red": 'testCube_red', "Green": 'testCube_green'}
@export_enum("Blue", "Red", "Green") var color = 'Blue':
	set(new_color):
		color = new_color
		change_color()

#func _ready() -> void:
	#change_color()


func change_color() -> void:
	var material = StandardMaterial3D.new()
	var texture = load("res://textures/testCube/"+path_dict[color]+".png")
	material.albedo_texture = texture
	material.uv1_scale = Vector3(3, 2, 1)
	$MeshInstance3D.set_surface_override_material(0, material)
