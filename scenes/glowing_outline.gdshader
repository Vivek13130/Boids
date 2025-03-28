shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform vec4 glow_color  = vec4(1.0, 0.5, 0.0, 1.0);
uniform float glow_size = 3.0;

void fragment() {
    float outline = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(glow_size / 1000.0)).a;
    COLOR = mix(texture(SCREEN_TEXTURE, SCREEN_UV), glow_color, outline * 0.5);
}
