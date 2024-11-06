@tool
extends Area3D

var close_object_dict: Dictionary = {}

var normal_vector: Vector3 = Vector3(0, 0, 1)
@export var parent_rotation: Vector3 = Vector3(0, 0, 0)

func _ready():
	connect("body_entered", _on_area_body_entered)
	connect("body_exited", _on_area_body_exited)
	
func _process(delta):
	print(parent_rotation)
	normal_vector = normal_vector.rotated(Vector3(1,0,0), parent_rotation[0])
	print(normal_vector)
	pass
func _physics_process(delta):
	
	pass
	
func _on_area_body_entered(body: PhysicsBody3D) -> void:
	print("entered")
	
	close_object_dict.get_or_add(body, -1)
	pass

func _on_area_body_exited(body: PhysicsBody3D) -> void:
	print("exited")
	pass
