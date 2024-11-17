@tool
extends RigidBody3D

@onready var box: MeshInstance3D = $MeshInstance3D3
@onready var green_screen_box: MeshInstance3D = $MeshInstance3D4

@export var depth: int = 2

var viewports: Array[SubViewport]
var portal_cameras: Array[Camera3D]


@export var other_portal : Node3D = self
@onready var cull_layer : int

@onready var camera_shader = preload("res://shaders/cameraViewportSample.gdshader")
func _ready():
	await get_parent().ready
	
	_change_portal_thickness_basend_on_camera()
	
	for i in range(depth):
		var current_viewport: SubViewport = SubViewport.new()
		var current_camera: Camera3D = Camera3D.new()
		
		_set_portal_camera_properties(current_camera)
		_set_subviewport_properties(current_viewport)
		
		current_viewport.add_child(current_camera)
		self.add_child(current_viewport)
		
		portal_cameras.append(current_camera)
		viewports.append(current_viewport)
		
	#portal_cameras[depth - 1].set_cull_mask_value(cull_layer + 1, false)
	_init_portal()
	
func _process(_delta):
	_update_camera_to_other_portal()
	_change_portal_thickness_basend_on_camera()
	pass
	
func _physics_process(delta):
	
	pass



func _update_camera_to_other_portal():
	var player_camera: Camera3D = get_viewport().get_camera_3d()
	if not player_camera:
		return
		
	var player_camera_transform: Transform3D = player_camera.global_transform
	
	for i in range(depth):
		player_camera_transform = other_portal.global_transform * self.global_transform.affine_inverse() * player_camera_transform
		portal_cameras[i].global_transform = player_camera_transform
	
func _update_camera_to_other_portal_1(camera: Transform3D):
		
	var player_camera_transform = camera
	
	for i in range(depth):
		player_camera_transform = other_portal.global_transform * self.global_transform.affine_inverse() * player_camera_transform
		portal_cameras[i].global_transform = player_camera_transform
	
	
func _init_portal():
	var material = ShaderMaterial.new()
	material.shader = camera_shader
	box.material_override = material
	
	var viewport_textures: Array[ViewportTexture]
	for i in range(depth):
		viewport_textures.append(viewports[i].get_texture())
		
	box.material_override.set_shader_parameter("textures", viewport_textures)
	box.material_override.set_shader_parameter("array_length", depth)
	
	box.set_layer_mask_value(1, false)
	box.set_layer_mask_value(cull_layer, true)
	
	green_screen_box.set_layer_mask_value(1, false)
	green_screen_box.set_layer_mask_value(cull_layer + 1, true)
	
	
	
func _set_subviewport_properties(subviewport: SubViewport):
	subviewport.size = get_viewport().get_visible_rect().size
	subviewport.msaa_3d = get_viewport().msaa_3d
	subviewport.screen_space_aa = get_viewport().screen_space_aa
	subviewport.use_taa = get_viewport().use_taa
	subviewport.use_debanding = get_viewport().use_debanding
	subviewport.use_occlusion_culling = get_viewport().use_occlusion_culling
	subviewport.mesh_lod_threshold = get_viewport().mesh_lod_threshold

func _set_portal_camera_properties(camera: Camera3D):
	camera.fov = get_viewport().get_camera_3d().fov
	camera.set_cull_mask_value(other_portal.cull_layer, false)
	camera.set_cull_mask_value(other_portal.cull_layer + 1, false)
	camera.set_cull_mask_value(cull_layer, false)

	
	
func get_body_transform_to_other_portal(body: PhysicsBody3D) -> Transform3D:
	var body_transform: Transform3D = body.global_transform
	#body_transform = body_transform.orthonormalized()
	
	var new_body_transform = other_portal.global_transform * self.global_transform.affine_inverse() * body_transform
	
	return new_body_transform
	
func _change_portal_thickness_basend_on_camera():
	var player_camera: Camera3D = get_viewport().get_camera_3d()
	if not player_camera:
		return
		
	var viewport_size: Vector2 = get_viewport().size
	var halfHeight: float = player_camera.near * tan(rad_to_deg(player_camera.fov) * 0.5)
	var halfWidth: float = halfHeight * viewport_size[0]/viewport_size[1]
	
	var distance_to_near_clip_plane_corner = Vector3(halfWidth, halfWidth, player_camera.near).length() * 0.5
	
	var portal_normal_forward: Vector3 = -get_parent().global_transform.basis.z
	var portal_to_camera_vector: Vector3 = self.global_transform.origin - player_camera.global_transform.origin
	var portal_normal_and_camera_vector_dot: float = portal_normal_forward.dot(portal_to_camera_vector)
	
	var new_scale = Vector3(box.scale.x, box.scale.y, distance_to_near_clip_plane_corner)
	box.scale = new_scale
	green_screen_box.scale = new_scale
	
	var new_position = Vector3.FORWARD * distance_to_near_clip_plane_corner * (0.5 if portal_normal_and_camera_vector_dot > 0.0 else -0.5)
	box.position = new_position
	green_screen_box.position = new_position

	pass
	
