shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 glow_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float glow_intensity = 0.5;
uniform float blur_size = 0.005;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 base = texture(SCREEN_TEXTURE, uv);
    
    vec4 blur = (
        texture(SCREEN_TEXTURE, uv + vec2(blur_size, 0.0)) +
        texture(SCREEN_TEXTURE, uv - vec2(blur_size, 0.0)) +
        texture(SCREEN_TEXTURE, uv + vec2(0.0, blur_size)) +
        texture(SCREEN_TEXTURE, uv - vec2(0.0, blur_size))
    ) / 4.0;
    
    vec4 glow = glow_color * glow_intensity * blur.a;
    COLOR = base + glow;
}
