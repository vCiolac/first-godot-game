shader_type canvas_item;

uniform float gradient_factor;

void fragment() {
    COLOR = vec4(0, 0, 0, gradient_factor *  UV.x);
}              
