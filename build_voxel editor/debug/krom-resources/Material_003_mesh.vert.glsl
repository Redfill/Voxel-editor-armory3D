#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform mat4 WVP;
uniform float texUnpack;

in vec4 pos;
in vec3 ipos;
out vec2 texCoord;
in vec2 tex;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    vec3 _25 = spos.xyz + ipos;
    spos = vec4(_25.x, _25.y, _25.z, spos.w);
    gl_Position = WVP * spos;
    texCoord = tex * texUnpack;
}

