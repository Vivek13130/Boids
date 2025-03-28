shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform float intensity = 1 ;

void fragment() {
    vec2 uv = SCREEN_UV;
    float scanline = sin(uv.y * 800.0) * intensity;
    vec3 color = texture(SCREEN_TEXTURE, uv).rgb * (1.0 - scanline);
    
    COLOR = vec4(color, 1.0);
}
