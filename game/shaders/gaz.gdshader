shader_type spatial;
render_mode blend_mix, cull_disabled;

uniform vec3 gas_color = vec3(0.3, 0.8, 0.3);
uniform float max_density = 0.4;
uniform float speed = 0.3;
uniform float scale = 1.5;
uniform int octaves = 4;

// Bruit lissé pseudo-3D
float smooth_noise(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);

    float n000 = fract(sin(dot(i + vec3(0,0,0), vec3(12.9898,78.233,45.164))) * 43758.5453);
    float n100 = fract(sin(dot(i + vec3(1,0,0), vec3(12.9898,78.233,45.164))) * 43758.5453);
    float n010 = fract(sin(dot(i + vec3(0,1,0), vec3(12.9898,78.233,45.164))) * 43758.5453);
    float n110 = fract(sin(dot(i + vec3(1,1,0), vec3(12.9898,78.233,45.164))) * 43758.5453);
    float n001 = fract(sin(dot(i + vec3(0,0,1), vec3(12.9898,78.233,45.164))) * 43758.5453);
    float n101 = fract(sin(dot(i + vec3(1,0,1), vec3(12.9898,78.233,45.164))) * 43758.5453);
    float n011 = fract(sin(dot(i + vec3(0,1,1), vec3(12.9898,78.233,45.164))) * 43758.5453);
    float n111 = fract(sin(dot(i + vec3(1,1,1), vec3(12.9898,78.233,45.164))) * 43758.5453);

    vec3 u = f*f*(3.0-2.0*f);

    float nx00 = mix(n000, n100, u.x);
    float nx10 = mix(n010, n110, u.x);
    float nx01 = mix(n001, n101, u.x);
    float nx11 = mix(n011, n111, u.x);

    float nxy0 = mix(nx00, nx10, u.y);
    float nxy1 = mix(nx01, nx11, u.y);

    return mix(nxy0, nxy1, u.z);
}

// Turbulence multi-octave
float turbulence(vec3 p) {
    float t = 0.0;
    float freq = 1.0;
    float amp = 1.0;
    for (int i = 0; i < octaves; i++) {
        t += smooth_noise(p * freq + vec3(0.0, 0.0, TIME * speed)) * amp;
        freq *= 2.0;
        amp *= 0.5;
    }
    return t;
}

varying vec3 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec3 pos = world_position * scale;
    float n = turbulence(pos);
    float alpha = smoothstep(0.3, 0.7, n) * max_density;

    ALBEDO = gas_color;
    ALPHA = alpha;
}