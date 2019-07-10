#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform vec3 DiffuseBSDFColor;
uniform vec3 sunDir;
uniform vec3 sunCol;
uniform float envmapStrength;

in vec3 wnormal;
out vec4 fragColor;

void main()
{
    vec3 n = normalize(wnormal);
    vec3 basecol = DiffuseBSDFColor;
    float roughness = 0.0;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.0;
    vec3 direct = vec3(0.0);
    float svisibility = 1.0;
    float sdotNL = max(dot(n, sunDir), 0.0);
    direct += (((basecol * sdotNL) * sunCol) * svisibility);
    fragColor = vec4(direct + ((basecol * 0.5) * envmapStrength), 1.0);
    vec3 _64 = pow(fragColor.xyz, vec3(0.4545454680919647216796875));
    fragColor = vec4(_64.x, _64.y, _64.z, fragColor.w);
}

