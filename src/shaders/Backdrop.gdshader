shader_type canvas_item;

uniform vec4 center_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Color at the center
uniform vec4 rim_color : source_color = vec4(0.0, 0.5, 1.0, 1.0);   // Color of the rim
uniform float radius : hint_range(0.0, 1.0) = 0.5;                // Outer radius of the circle
uniform float rim_thickness : hint_range(0.0, 0.1) = 0.02;        // Thickness of the hard inner rim

void fragment() {
    // Get UV coordinates (0 to 1 across the texture)
    vec2 uv = UV;
    
    // Center the UV coordinates to (0,0) at the middle of the texture
    vec2 centered_uv = uv - vec2(0.5);
    
    // Calculate the distance from the center
    float dist = length(centered_uv);
    
    // Define the inner radius (where the rim starts)
    float inner_radius = radius - rim_thickness;
    
    // Initialize color
    vec4 color = vec4(0.0);
    
    // Assign color based on distance
    if (dist > radius) {
        // Outside the circle: transparent
        color = vec4(0.0, 0.0, 0.0, 0.0);
    } else if (dist > inner_radius) {
        // In the rim: use rim_color
        color = rim_color;
    } else {
        // Inside the inner area: interpolate from center_color to rim_color
        float t = dist / inner_radius; // Normalize distance for gradient
        color = center_color;
    }
    
    // Set the final color
    COLOR = color;
}