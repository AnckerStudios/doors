shader_type spatial;
render_mode unshaded, cull_disabled;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(1.0, 0.0, 1.0);
}
