shader_type particles;
render_mode disable_velocity;

// ---- Streams ----
uniform int stream_count = 4;            // number of distinct helical strands
uniform float stream_jitter = 0.3;       // random offset within each stream (radians), keeps it from looking too rigid
uniform float group_rotation_speed = 0.5;

// ---- Shape ----
uniform float swirl_speed = 3.0;
uniform float base_radius = 60.0;
uniform float radius_bottom_scale = 0.35;
uniform float radius_top_scale = 0.15;
uniform float wobble_amount = 8.0;
uniform float wobble_speed = 2.0;

// ---- Direction / flow ----
uniform vec2 flow_direction = vec2(0.0, -1.0); // normalized; (0,-1)=up, (0,1)=down, (1,0)=rightward, etc.
uniform float rise_speed = 80.0;
uniform vec2 emitter_origin = vec2(0.0, 0.0);

// ---- Lifetime ----
uniform float lifetime_sec = 4.0;

// ---- Scale ----
uniform float scale_min = 0.5;   // size at spawn
uniform float scale_max = 1.2;   // size at peak (mid-life)
uniform float scale_end = 0.3;   // size at death
uniform float min_scale_depth = 0.55; // extra depth-fake shrink for "behind" particles

// ---- Color ----
uniform vec4 color_start : source_color = vec4(0.8, 0.8, 0.85, 1.0);
uniform vec4 color_mid   : source_color = vec4(0.9, 0.9, 0.95, 1.0);
uniform vec4 color_end   : source_color = vec4(0.6, 0.6, 0.65, 0.0);
uniform float min_alpha_depth = 0.35; // alpha for "behind" particles

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

void start() {
    float id = float(INDEX) + float(RANDOM_SEED);

    // Assign this particle to one of N streams, each offset evenly around the circle
    int stream_id = int(mod(float(INDEX), float(max(stream_count, 1))));
    float stream_angle = (float(stream_id) / float(max(stream_count, 1))) * TAU;
    float jitter = (hash(id) - 0.5) * 2.0 * stream_jitter;

    CUSTOM.x = stream_angle + jitter; // base angle offset for this particle
    CUSTOM.y = TIME;                  // spawn time
    CUSTOM.z = hash(id + 37.0) * TAU; // wobble phase

    TRANSFORM = mat4(1.0);
    TRANSFORM[3].xy = emitter_origin;
}

void process() {
    float age = TIME - CUSTOM.y;
    if (age < 0.0) age += lifetime_sec;
    float t = clamp(age / lifetime_sec, 0.0, 1.0);

    float angle = CUSTOM.x + age * swirl_speed - TIME * group_rotation_speed;

    // Funnel radius profile: narrow bottom -> wide mid -> narrow top
    float profile = 1.0 - abs(t - 0.5) * 2.0;
    float scale_range = radius_top_scale - radius_bottom_scale;
    float base_scale = radius_bottom_scale + scale_range * t;
    float radius = base_radius * mix(base_scale, 1.0, profile);
    radius += sin(age * wobble_speed + CUSTOM.z) * wobble_amount;

    // Build local 2D offset in the funnel's own "up/across" space, then rotate
    // into flow_direction so the whole tornado can point any way you like.
    vec2 dir = normalize(flow_direction);
    vec2 perp = vec2(-dir.y, dir.x); // perpendicular = the "sideways sway" axis

    float travel = age * rise_speed;
    vec2 pos = emitter_origin + dir * travel + perp * (cos(angle) * radius);

    TRANSFORM[3].xy = pos;

    // Depth fake based on the swirl phase
    float depth = (sin(angle) + 1.0) * 0.5;

    // Scale over lifetime (spawn -> peak at mid-life -> shrink near death), then depth-modulated
    float life_scale = mix(mix(scale_min, scale_max, clamp(t * 2.0, 0.0, 1.0)),
                            scale_end,
                            clamp((t - 0.5) * 2.0, 0.0, 1.0));
    float s = life_scale * mix(min_scale_depth, 1.0, depth);
    TRANSFORM[0].xy = vec2(s, 0.0);
    TRANSFORM[1].xy = vec2(0.0, s);

    // Color over lifetime
    vec4 col = mix(color_start, color_mid, clamp(t * 2.0, 0.0, 1.0));
    col = mix(col, color_end, clamp((t - 0.5) * 2.0, 0.0, 1.0));
    col.a *= mix(min_alpha_depth, 1.0, depth);

    float fade = min(t * 6.0, (1.0 - t) * 4.0);
    col.a *= clamp(fade, 0.0, 1.0);

    COLOR = col;
}