shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform float intensity = 1.0;
uniform float speed = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    float wave = sin(uv.x * 50.0 + TIME * speed) * sin(uv.y * 50.0 - TIME * speed);
    
    vec3 holo_color = vec3(
        0.5 + 0.5 * cos(TIME + wave),
        0.5 + 0.5 * sin(TIME + wave),
        0.7 + 0.3 * cos(TIME * 2.0)
    );
    
    COLOR = texture(SCREEN_TEXTURE, uv) * vec4(holo_color * intensity, 1.0);
}
