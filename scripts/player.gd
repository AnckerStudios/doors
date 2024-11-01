extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0
var camera: Camera3D
var mouseDelta : Vector2 = Vector2()
@onready var interaction = $Camera3D/RayCast3D
@onready var hand = $Camera3D/Node3D

var pickedObject: RigidBody3D
var pullPower = 4

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	camera = get_node("Camera3D")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("key_left", "key_right", "key_up", "key_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if pickedObject != null:
		var a = pickedObject.global_transform.origin
		var b = hand.global_transform.origin
		pickedObject.apply_central_impulse((b-a))

func _process(delta):
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	mouseDelta = Vector2()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouseDelta = event.relative
	if Input.is_action_just_pressed("l_click"):
		if pickedObject == null:
			pick_object()
		else:
			drop_object()

func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		pickedObject = collider
		
func drop_object():
	if pickedObject != null:
		pickedObject = null
