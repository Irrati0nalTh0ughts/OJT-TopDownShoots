shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 2.0) = 0.6;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.35;
uniform float pulse_speed : hint_range(0.0, 5.0) = 1.2;
uniform vec4 glow_color : source_color = vec4(1.0, 0.95, 0.6, 1.0);
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.08;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	// Isolate the near-white text pixels by brightness, then pulse a warm glow on them
	float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);
	float brightness = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
	float text_mask = smoothstep(0.75, 0.95, brightness);
	vec3 glow = glow_color.rgb * text_mask * pulse * glow_strength;

	// Vignette: darken the corners so the eye settles on the text
	vec2 centered_uv = UV - 0.5;
	float vignette = 1.0 - dot(centered_uv, centered_uv) * vignette_strength * 4.0;
	vignette = clamp(vignette, 0.0, 1.0);

	// Faint scanlines for a retro-screen feel
	float scanline = sin(UV.y * 400.0) * scanline_strength;

	vec3 final_color = tex_color.rgb * vignette - scanline;
	final_color += glow;

	COLOR = vec4(final_color, tex_color.a);
}