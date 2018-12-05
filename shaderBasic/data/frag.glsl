#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;
uniform float time;

void main(void) {

    float r = (sin(time*.001)+1.)*.5;
    r*=gl_FragCoord.x/resolution.x;
    vec4 col;
    if (gl_FragCoord.y>100.)
    col = vec4(r,0.,0.,1.);
    else
    col = vec4(1.,0.,0.,1.);
    gl_FragColor = col;
}
