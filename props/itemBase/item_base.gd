extends RigidBody3D

@export var gravity: Vector3 = Vector3(0, -9.8, 0)

func _integrate_forces(state):
	state.apply_force(gravity)
