#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float kernel_value_00;
uniform float kernel_value_01;
uniform float kernel_value_02;
uniform float kernel_value_10;
uniform float kernel_value_11;
uniform float kernel_value_12;
uniform float kernel_value_20;
uniform float kernel_value_21;
uniform float kernel_value_22;

uniform vec2 resolution;


void main(void) {
    vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
    vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
    vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
    vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
    vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
    vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
    vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
    vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
    vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);

    vec4 col0 = texture2D(texture, tc0) * kernel_value_00;
    vec4 col1 = texture2D(texture, tc1) * kernel_value_01;
    vec4 col2 = texture2D(texture, tc2) * kernel_value_02;
    vec4 col3 = texture2D(texture, tc3) * kernel_value_10;
    vec4 col4 = texture2D(texture, tc4) * kernel_value_11;
    vec4 col5 = texture2D(texture, tc5) * kernel_value_12;
    vec4 col6 = texture2D(texture, tc6) * kernel_value_20;
    vec4 col7 = texture2D(texture, tc7) * kernel_value_21;
    vec4 col8 = texture2D(texture, tc8) * kernel_value_22;

    vec4 sum = col0 + col1 + col2 + col3 + col4 + col5 + col6 + col7 + col8;
    if (gl_FragCoord.x/resolution.x > .5)
        gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
    else
        gl_FragColor = texture2D(texture, tc4);
}
