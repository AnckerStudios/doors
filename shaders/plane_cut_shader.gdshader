shader_type spatial;
uniform sampler2D base_texture : source_color;
uniform float scale_repeat = 1.0;
uniform vec2 uv_scale = vec2(1.0, 1.0);

uniform vec3 plane_position = vec3(0.0);
uniform vec3 plane_normal = vec3(0.0);

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1)).xyz;
}

void fragment() {
	vec3 object_plane_vector = world_position - plane_position;
	if (dot(plane_normal, object_plane_vector) < 0.0){
		discard;
	}
	ALBEDO = texture(base_texture, UV * scale_repeat * uv_scale).xyz;
	//ALBEDO = plane_position;
}