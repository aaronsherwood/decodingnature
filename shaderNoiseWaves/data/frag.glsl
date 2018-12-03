#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

float hash( vec2 p ) {
    float h = dot(p,vec2(127.1,311.7));
    return fract(sin(h)*43758.5453123);
}
float noise( in vec2 p ) {
    vec2 i = floor( p );
    vec2 f = fract( p );
    vec2 u = f*f*(3.0-2.0*f);
    return -1.0+2.0*mix( mix( hash( i + vec2(0.0,0.0) ),
                             hash( i + vec2(1.0,0.0) ), u.x),
                        mix( hash( i + vec2(0.0,1.0) ),
                            hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

uniform float d;
uniform float power;
uniform float time;

void main(void) {
    float total = 0.0;
    for (float i = d; i>=1; i=i/2.0) {
        total += noise(vec2(gl_FragCoord.x/d-time*.0001, gl_FragCoord.y/d+time*.0001))* d;
    }
    float turbulence = 128.0 * total/d;
    float base = (gl_FragCoord.x * 0.02) + (gl_FragCoord.y*0.02);
    float offset = -time*.001+base + (power * turbulence /256.0);
    float gray = abs(sin(offset));
    gl_FragColor = vec4(vec3(gray),1.);
}
