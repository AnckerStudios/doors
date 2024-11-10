shader_type spatial;
uniform sampler2D base_texture : source_color;
uniform float scale_repeat = 1.0;
uniform vec2 uv_scale = vec2(3.0, 2.0);
void vertex() {
}

void fragment() {
	ALBEDO = texture(base_texture, UV * scale_repeat * uv_scale).xyz;
}
