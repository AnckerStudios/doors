shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D[10] textures : source_color;
uniform int array_length;

void vertex() {
	
}

void fragment() {
	vec3 pink_color = vec3(1.0, 0.0, 1.0);
	
	bool found = false;
	for(int i = 0; i < array_length; i++){
		vec3 current_albedo = texture(textures[i], SCREEN_UV).xyz;
		if(current_albedo != pink_color){
			float shading_coeff = (1.0 - float(i)/float(array_length));
			ALBEDO = current_albedo * shading_coeff;
			found = true;
			break;
		}
	}
	if(!found){
		ALBEDO = vec3(0.0);
	}
	
}
