shader_type canvas_item;

uniform int levels = 1;
uniform float spread = 0.01;
uniform sampler2D screen_texture : hint_screen_texture; // NEW: Replaces SCREEN_TEXTURE

vec3 chromatic_slice(float t) {
    return max(vec3(1.0 - t, 1.0 - abs(t - 1.0), t - 1.0), 0.0);
}

void fragment() {
    vec3 sum = vec3(0.0); // Fix uninitialized sum
    COLOR.rgb = vec3(0);
    vec2 offset = (UV - vec2(0.5)) * vec2(1, -1);
    
    for (int i = 0; i < levels; i++) {
        float t = 2.0 * float(i) / float(levels - 1); // range 0.0 -> 2.0
        vec3 slice = chromatic_slice(t);
        sum += slice;
        vec2 slice_offset = (t - 1.0) * spread * offset;

        // FIX: Use the new screen texture uniform
        COLOR.rgb += slice * texture(screen_texture, SCREEN_UV + slice_offset).rgb;
    }
    
    COLOR.rgb /= sum; // Normalize
}
