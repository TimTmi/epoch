shader_type canvas_item;

uniform vec2 shadow_offset = vec2(5, 5);

void vertex() {
    // Offset the vertex position for the shadow effect
    VERTEX.x += shadow_offset.x;
    VERTEX.y += shadow_offset.y;
}

void fragment() {
    // Darken the pixel color to simulate a shadow
    COLOR.rgb *= 130.0 / 255.0;
}