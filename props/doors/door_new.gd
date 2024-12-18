@tool
extends Node3D

@onready var viewport : SubViewport = $SubViewport
@onready var portal_camera : Camera3D = $SubViewport/Camera3D
@onready var box : MeshInstance3D = $MeshInstance3D3
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_shader = preload("res://shaders/cameraViewportSample.gdshader")

@export var other_portal : Node3D = self;
@export var cull_layer : int = 4
@export var is_open : bool = false

func _ready():
	var material = ShaderMaterial.new()
	material.shader = camera_shader
	box.material_override = material
	
	box.material_override.set_shader_parameter("texture_albedo", viewport.get_texture())
	box.set_layer_mask_value(1, false)
	box.set_layer_mask_value(cull_layer, true)
	
	portal_camera.fov = get_viewport().get_camera_3d().fov
	portal_camera.set_cull_mask_value(other_portal.cull_layer, false)
	
	viewport.size = get_viewport().get_visible_rect().size
	viewport.msaa_3d = get_viewport().msaa_3d
	viewport.screen_space_aa = get_viewport().screen_space_aa
	viewport.use_taa = get_viewport().use_taa
	viewport.use_debanding = get_viewport().use_debanding
	viewport.use_occlusion_culling = get_viewport().use_occlusion_culling
	viewport.mesh_lod_threshold = get_viewport().mesh_lod_threshold
	

func _update_camera_to_other_portal():
	var player_camera : Camera3D = get_viewport().get_camera_3d()
	if not player_camera:
		return
	#print(player_camera.global_transform)
	
	var player_camera_relative_to_portal_transform : Transform3D = self.global_transform.affine_inverse() * player_camera.global_transform
	
	portal_camera.global_transform = other_portal.global_transform * player_camera_relative_to_portal_transform
	
	#portal_camera.cull_mask = player_camera.cull_mask
	
func _process(_delta):
		_update_camera_to_other_portal()
		
func open():
		is_open = true
		animation_player.play("open")
		if (other_portal.is_open == false):
			other_portal.open()
	
		
func close():
		is_open = false
		animation_player.play("close")
		if (other_portal.is_open == true):
			other_portal.close()
