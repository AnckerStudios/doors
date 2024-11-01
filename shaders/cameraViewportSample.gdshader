shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D texture_albedo : source_color;


void vertex() {
	
}

void fragment() {
	ALBEDO = texture(texture_albedo, SCREEN_UV).xyz;
}
