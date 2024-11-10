extends Node


class Portable:
	func update_shader_parameters(_plane_position: Vector3, _plane_normal: Vector3):
		pass
		

func _check_node(node: Node) -> void:
	if "implements" in node:
		var node_implements = node.implements
		if not node_implements is Array:
			var instance = node_implements.new()
			_assert_methods(node, instance)

func _assert_methods(node, interface_instance):
	var error_string: String = "Interface error: " + node.name + " does not possess the "
	for method in interface_instance.get_script().get_script_method_list():
		assert(method.name in node, error_string + method.name + " method.")
