@tool
extends Area3D

@onready var viewport : SubViewport = $SubViewport
@onready var portal_camera : Camera3D = $SubViewport/Camera3D
@onready var box : CSGBox3D = $CSGBox3D

@export var other_portal : Node3D = self;
@export var cull_layer : int = 4

func _ready():
	
	box.material_override.set_shader_parameter("texture_albedo", viewport.get_texture())
	box.set_layer_mask_value(1, false)
	box.set_layer_mask_value(cull_layer, true)
	
	portal_camera.set_cull_mask_value(other_portal.cull_layer, false)
	

func _update_camera_to_other_portal():
	var player_camera : Camera3D = get_viewport().get_camera_3d()
	if not player_camera:
		return
	#print(player_camera.global_transform)
	
	var player_camera_relative_to_portal_transform : Transform3D = self.global_transform.affine_inverse() * player_camera.global_transform
	
	portal_camera.global_transform = other_portal.global_transform * player_camera_relative_to_portal_transform
	portal_camera.fov = player_camera.fov
	
	portal_camera.cull_mask = player_camera.cull_mask
	portal_camera.set_cull_mask_value(other_portal.cull_layer, false)
	
	viewport.size = get_viewport().get_visible_rect().size
	viewport.msaa_3d = get_viewport().msaa_3d
	viewport.screen_space_aa = get_viewport().screen_space_aa
	viewport.use_taa = get_viewport().use_taa
	viewport.use_debanding = get_viewport().use_debanding
	viewport.use_occlusion_culling = get_viewport().use_occlusion_culling
	viewport.mesh_lod_threshold = get_viewport().mesh_lod_threshold
	
func _process(_delta):
		_update_camera_to_other_portal()
