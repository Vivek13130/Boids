shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE  : hint_screen_texture;
uniform float time_factor : hint_range(0.0, 5.0) = 5.0;
uniform float wave_strength = 0.01;

void fragment() {
    vec2 uv = SCREEN_UV;
    uv.x += sin(UV.y * 10.0 + TIME * time_factor) * wave_strength;
    uv.y += cos(UV.x * 10.0 + TIME * time_factor) * wave_strength;
    
    COLOR = texture(SCREEN_TEXTURE, uv);
}
