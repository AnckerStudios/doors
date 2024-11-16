extends Node3D

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

func _ready():
	#Engine.max_fps = 2
	$Door.other_portal = $Door2
	$Door2.other_portal = $Door
	
	$Door.cull_layer = 6
	$Door2.cull_layer = 8
	
	var depth = 6
	$Door.depth = depth
	$Door2.depth = depth
	
	$Player/Camera3D.set_cull_mask_value($Door.cull_layer + 1, false)
	$Player/Camera3D.set_cull_mask_value($Door2.cull_layer + 1, false)
