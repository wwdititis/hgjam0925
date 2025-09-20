shader_type canvas_item;
render_mode unshaded;

uniform vec4 color_a : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Color para lo oscuro
uniform vec4 color_b : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Color para lo claro

uniform float intensity : hint_range(0.1, 5.0) = 2.0; // Control de intensidad/contraste

uniform sampler2D screen_tex : hint_screen_texture;

void fragment() {
    vec4 src = texture(screen_tex, SCREEN_UV);
    float luma = dot(src.rgb, vec3(0.299, 0.587, 0.114));

    // Aumentar intensidad aplicando una potencia (gamma-like)
    float adjusted = pow(luma, intensity);

    vec4 result = mix(color_a, color_b, adjusted);
    COLOR = vec4(result.rgb, src.a);
}
