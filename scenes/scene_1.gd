extends Node3D

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

func _ready():
	$Door.other_portal = $Door2
	$Door2.other_portal = $Door
