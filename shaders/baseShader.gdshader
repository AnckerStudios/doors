shader_type spatial;
uniform sampler2D base_texture : source_color;
uniform float scale = 1.0;
void vertex() {
}

void fragment() {
	vec2 uv = vec2(UV.x, UV.y);
	ALBEDO = texture(base_texture, uv * scale).xyz;
}

