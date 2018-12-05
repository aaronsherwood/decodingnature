uniform vec2 resolution;
uniform bool circle;

varying vec4 vertColor;

void main() {
    vec2 v = gl_FragCoord.xy;

    gl_FragColor = vertColor;
}
