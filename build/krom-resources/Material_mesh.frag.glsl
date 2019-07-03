#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

out vec4 fragColor;

void main()
{
    vec3 basecol = vec3(0.800000011920928955078125);
    float roughness = 0.5;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.5;
    fragColor = vec4(basecol, 1.0);
    vec3 _32 = pow(fragColor.xyz, vec3(0.4545454680919647216796875));
    fragColor = vec4(_32.x, _32.y, _32.z, fragColor.w);
}

