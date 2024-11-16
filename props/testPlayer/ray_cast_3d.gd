extends RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var hit_obj = get_collider()
		if hit_obj.has_method("interact") && Input.is_action_just_pressed("interact"):
			hit_obj.interact()
