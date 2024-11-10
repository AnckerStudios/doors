@tool
extends Area3D

var close_object_dict: Dictionary = {}

func _ready():
	connect("body_entered", _on_area_body_entered)
	connect("body_exited", _on_area_body_exited)
	
func _process(delta):
	#print(-get_parent().global_transform.basis.z)
	
	pass
func _physics_process(delta):
	var portal_position = get_parent().global_transform.origin
	var portal_normal_forward = -get_parent().global_transform.basis.z
	for key in close_object_dict.keys():
		var portal_normal_to_object = portal_normal_forward * close_object_dict.get(key)
		key.update_shader_parameters(portal_position, portal_normal_to_object)
	pass
	
func _on_area_body_entered(body: PhysicsBody3D) -> void:
	#print("entered")
	
	if not "implements" in body:
		return
	if not body.implements == Interface.Portable:
		return
	
	var portal_origin: Vector3 = get_parent().global_transform.origin
	var body_origin: Vector3 = body.global_transform.origin
	var portal_to_body_vector: Vector3 = body_origin - portal_origin;
	
	var portal_forward_vector: Vector3 = -get_parent().global_transform.basis.z
	
	var is_on_same_side = 1
	if portal_forward_vector.dot(portal_to_body_vector) < 0:
		is_on_same_side = -1
		
	close_object_dict.get_or_add(body, is_on_same_side)
	#print(portal_to_body_vector)
	
	pass

func _on_area_body_exited(body: PhysicsBody3D) -> void:
	#print("exited")
	if not "implements" in body:
		return
	if not body.implements == Interface.Portable:
		return
	body.update_shader_parameters(Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0))
	close_object_dict.erase(body)
	
	#print(close_object_dict.keys())
	
	pass
