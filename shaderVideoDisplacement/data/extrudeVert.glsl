uniform mat4 transform;
uniform vec4 viewport;
uniform vec2 resolution;
uniform float time;

attribute vec4 position;
attribute vec4 color;
attribute vec4 direction;

varying vec2 center;
varying vec2 normal;
varying vec4 vertColor;

// this is how we receive the texture
uniform sampler2D tex0;

vec3 clipToWindow(vec4 clip, vec4 viewport) {
    vec3 dclip = clip.xyz / clip.w;
    vec2 xypos = (dclip.xy + vec2(1.0, 1.0)) * 0.5 * viewport.zw;
    return vec3(xypos, dclip.z * 0.5 + 0.5);
}

out vec2 texCoordVarying;

void main()
{
    // get the position of the vertex relative to the modelViewProjectionMatrix
    vec4 modifiedPosition = position;
    
    // we need to scale up the values we get from the texture
    float scale = -150.;
    
    // here we get the red channel value from the texture
    // to use it as vertical displacement
    vec2 texcoord = position.xy/resolution;
    texcoord.y=texcoord.y;
    float displacementZ = texture(tex0, texcoord).r;
//    displacementZ += sin(time + (position.x / 100.0)) * 1.;
    
    // use the displacement we created from the texture data
    // to modify the vertex position
    modifiedPosition.z += displacementZ * scale;
    
    // this is the resulting vertex position
    gl_Position = modifiedPosition;
    
    
    vec4 clip0 =transform*modifiedPosition;
    vec4 clip1 = clip0 + transform * vec4(direction.xyz, 0);
    float thickness = direction.w;
    
    vec3 win0 = clipToWindow(clip0, viewport);
    vec3 win1 = clipToWindow(clip1, viewport);
    vec2 tangent = win1.xy - win0.xy;
    
    normal = normalize(vec2(-tangent.y, tangent.x));
    vec2 offset = normal * thickness;
    gl_Position.xy = clip0.xy + offset.xy;
    gl_Position.zw = clip0.zw;
    vertColor = vec4(vec3(texture(tex0, texcoord)),1.);
    
    center = (win0.xy + win1.xy) / 2.0;
}
