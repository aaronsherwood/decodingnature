#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 mouse;
uniform vec2 resolution;
uniform float size;
uniform vec3 color;

void main(void) {
    float dist = size/distance(gl_FragCoord.xy, mouse);
    gl_FragColor = vec4(color.r*dist,color.g*dist,color.b*dist,1.);
}
