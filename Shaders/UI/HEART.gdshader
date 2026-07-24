shader_type canvas_item;

uniform vec4 top_color : source_color = vec4(1.0, 0.50, 0.50, 1.0);
uniform vec4 bottom_color : source_color = vec4(0.75, 0.08, 0.08, 1.0);

uniform float shine_strength : hint_range(0.0, 1.0) = 0.35;
uniform float rim_strength : hint_range(0.0, 1.0) = 0.18;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if (tex.a == 0.0) {
		discard;
	}

	// Vertical color gradient.
	vec3 color = mix(top_color.rgb, bottom_color.rgb, UV.y);

	// Soft highlight toward the upper-left.
	float shine = smoothstep(0.45, 0.0, distance(UV, vec2(0.30, 0.25)));
	color += shine * shine_strength;

	// Slight rim light around the top.
	float rim = pow(1.0 - UV.y, 3.0);
	color += rim * rim_strength;

	COLOR = vec4(color, tex.a);
}