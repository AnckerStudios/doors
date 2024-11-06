@tool
extends Node3D

var path_dict = {"Blue": 'testCube_blue', "Red": 'testCube_red', "Green": 'testCube_green'}
@export var gravity: Vector3 = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
