@tool
extends Area3D

var close_object_dict: Dictionary = {}

func _ready() -> void:
	connect("body_entered", _on_area_body_entered)
	connect("body_exited", _on_area_body_exited)
	
func _process(delta) -> void:
	_update_objects_portal_poperties()
	_update_close_object_positions()
	pass
	
func _physics_process(delta) -> void:
	pass
	
func _on_area_body_entered(body: PhysicsBody3D) -> void:
	if not "implements" in body:
		return
	if not body.implements == Interface.Portable:
		return
	if close_object_dict.has(body):
		return 
	
	#print("entered %s" % self)
	var body_portal_side = _check_object_side(body)
	var body_properties = {
		"side" = body_portal_side,
		"is_clone" = false
	}
	close_object_dict.get_or_add(body, body_properties)
	
	var clone = body.create_clone(get_parent().get_body_transform_to_other_portal(body))
	if(clone):
		var clone_properties = {
			"side" = -body_portal_side,
			"is_clone" = true
		}
		get_parent().other_portal.get_child(2).close_object_dict.get_or_add(clone, clone_properties)
	
	pass

func _on_area_body_exited(body: PhysicsBody3D) -> void:
	if not "implements" in body:
		return
	if not body.implements == Interface.Portable:
		return
	if not close_object_dict.has(body):
		return 	
	
	#print("exited %s" % self)
	body.update_shader_parameters(Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0))
	
	close_object_dict.erase(body)
	body.remove_clone(get_parent().other_portal.get_child(2).close_object_dict)
	pass



func _update_objects_portal_poperties() -> void:
	var portal_position = get_parent().global_transform.origin
	var portal_normal_forward = -get_parent().global_transform.basis.z
	for body in close_object_dict.keys():
		var body_properties = close_object_dict.get(body)
		var portal_normal_to_object = portal_normal_forward * body_properties.side
		body.update_shader_parameters(portal_position, portal_normal_to_object)
	pass
	

func _update_close_object_positions() -> void:
	for body: PhysicsBody3D in close_object_dict.keys():
		
		if(not close_object_dict.get(body).is_clone):
			body.update_clone(get_parent().get_body_transform_to_other_portal(body))
			
			if(_check_object_side(body) != close_object_dict.get(body).side):
				var body_transform_to_other_portal: Transform3D = get_parent().get_body_transform_to_other_portal(body)
				body.move_self_to_other_portal(body_transform_to_other_portal.orthonormalized())
				_on_area_body_exited(body)
				get_parent().other_portal.get_child(2)._on_area_body_entered(body)
			
	pass

func _check_object_side(body: PhysicsBody3D) -> int:
	var portal_origin: Vector3 = get_parent().global_transform.origin
	var body_origin: Vector3 = body.global_transform.origin
	var portal_to_body_vector: Vector3 = body_origin - portal_origin;
	
	var portal_forward_vector: Vector3 = -get_parent().global_transform.basis.z
	
	var is_on_same_side = 1
	if portal_forward_vector.dot(portal_to_body_vector) < 0:
		is_on_same_side = -1
	
	return is_on_same_side
