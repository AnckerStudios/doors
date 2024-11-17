extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var minLookAngle: float = -90.0
var maxLookAngle: float = 90.0
var lookSensitivity: float = 10.0
var camera: Camera3D
var mouseDelta: Vector2 = Vector2()
@onready var interaction = $Camera3D/RayCast3D
@onready var  shapeCast: ShapeCast3D = $Camera3D/ShapeCast3D
@onready var hand = $Camera3D/Node3D
@onready var body = $MeshInstance3D

var pickedObject: RigidBody3D
#var pullPower = 4
var starting_grab_position
var current_grab_position

var implements = Interface.Portable

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
		
		var base_len = 0.16
		var min_val = 0.0;
		var max_val = 0.65
		
		var hand_object_lenght = (b - a).length() - base_len
		var sigmoid = 1 / (1 + exp(-hand_object_lenght))
		
		var clamped_length = clamp(sigmoid, min_val, max_val)
		#print(clamped_length)
		
		pickedObject.linear_velocity = pickedObject.linear_velocity * clamped_length
		
		pickedObject.apply_central_impulse(b - a - starting_grab_position)
		#print(pickedObject.calculate_torque())
		var torque = pickedObject.calculate_torque()
		#pickedObject.apply_torque(Vector3(torque.y, 0.0, torque.y))
		#pickedObject.calc_distance_to_hand(starting_grab_position)
		
		#print(current_grab_position)
#func _process(delta):
	#camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	#camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	#rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	#mouseDelta = Vector2()

func _unhandled_input(event):
	var SENSITIVITY = 0.004
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouseDelta = event.relative
	if Input.is_action_just_pressed("l_click"):
		if pickedObject == null:
			pick_object()
			
	if Input.is_action_just_released("l_click"):
		if pickedObject != null:
			drop_object()

func pick_object():
	
	#print(shapeCast.get_collision_count())
	
	for i in range(0, shapeCast.get_collision_count()):
		var collider = shapeCast.get_collider(i)
		if collider is RigidBody3D:
			starting_grab_position = hand.global_transform.origin - collider.global_transform.origin
			collider.calc_distance_to_hand(starting_grab_position)
			pickedObject = collider
			break
		
	#var collider = interaction.get_collider()
	#if collider is RigidBody3D:
		#starting_grab_position = hand.global_transform.origin - collider.global_transform.origin
		#collider.calc_distance_to_hand(starting_grab_position)
		#pickedObject = collider
	pass
		
		
func drop_object():
	if pickedObject != null:
		pickedObject = null

func update_shader_parameters(_plane_position: Vector3, _plane_normal: Vector3):
	#body.material_override.set_shader_parameter("plane_position", plane_position)
	#body.material_override.set_shader_parameter("plane_normal", plane_normal)
	pass
	
func move_self_to_other_portal(new_transform: Transform3D):
	self.global_transform = new_transform
	pass
	
func update_clone(_new_transform: Transform3D):
	pass
	
func create_clone(_new_transform: Transform3D):
	return null

func remove_clone(_other_portal_dict: Dictionary):
	pass
