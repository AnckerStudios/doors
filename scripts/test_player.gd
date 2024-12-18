extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0
var camera: Camera3D
var mouseDelta : Vector2 = Vector2()
@onready var interaction = $Camera3D/RayCast3D
@onready var  shapeCast : ShapeCast3D = $Camera3D/ShapeCast3D
@onready var hand = $Camera3D/Node3D
@onready var animation_player = $model/player_with_animation_3/AnimationPlayer

@export var gravity: Vector3 = Vector3(0, -9.8, 0)

var pickedObject: RigidBody3D
var pullPower = 4

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	camera = get_node("Camera3D")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if animation_player.current_animation != 'Jump':
			animation_player.play('Jump')
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("key_left", "key_right", "key_up", "key_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if animation_player.current_animation != 'Walk':
			animation_player.get_animation('Walk').loop = true
			animation_player.play('Walk')
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != 'Idle':
			animation_player.play('Idle')
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if pickedObject != null:
		var a = pickedObject.global_transform.origin
		var b = hand.global_transform.origin
		
		var base_len = 0.16
		var min_val = 0.0;
		var max_val = 0.65
		
		var hand_object_lenght = (b - a).length() - base_len
		var sigmoid = 1 / (1 + exp(-hand_object_lenght))
		
		var clamped_length = clamp(hand_object_lenght, min_val, max_val)
		#print(clamped_length)
		
		pickedObject.linear_velocity = pickedObject.linear_velocity * clamped_length
		
		pickedObject.apply_central_impulse((b-a))

func _process(delta):
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	mouseDelta = Vector2()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouseDelta = event.relative
	if Input.is_action_pressed("l_click"):
		if pickedObject == null:
			pick_object()
			
	if Input.is_action_just_released("l_click"):
		if pickedObject != null:
			drop_object()

func pick_object():
	#var collider = interaction.get_collider()
	print(shapeCast.get_collision_count())
	
	var min_length_collider = null;
	var min_length = 10000.0
	var hand_position = $Camera3D.position
	for i in range(shapeCast.get_collision_count()-1, -1, -1):
		var collider = shapeCast.get_collider(i)
		if collider is RigidBody3D:
			pickedObject = collider
		
		
func drop_object():
	if pickedObject != null:
		pickedObject = null
