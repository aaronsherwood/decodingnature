//uniform sampler2D tex0;
//
//in vec2 texCoordVarying;
//
//out vec4 outputColor;
//
//void main()
//{
//    outputColor = texture(tex0, texCoordVarying);
//}

//uniform float weight;
//uniform float alphaScale;
uniform vec2 resolution;
uniform vec2 mouse;

varying vec2 center;
varying vec2 normal;
varying vec4 vertColor;

void main() {
    vec2 v = gl_FragCoord.xy - center;
    float alpha = 1.0 - abs(2.0 * dot(normalize(normal), v) / 3.f);
    gl_FragColor = vec4(vertColor.rgb,      alpha);
}
