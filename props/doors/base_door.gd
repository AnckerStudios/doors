extends StaticBody3D

@onready var parent = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var interactable: bool = true;

func interact():
	if interactable == true:
		if parent.is_open == false:
			parent.open()
		else:
			parent.close()
		await get_tree().create_timer(1.0, false).timeout
		interactable = true
