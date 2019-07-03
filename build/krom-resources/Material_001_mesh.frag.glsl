#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

out vec4 fragColor;

void main()
{
    vec3 basecol = vec3(1.0);
    float roughness = 0.0;
    float metallic = 1.0;
    float occlusion = 1.0;
    float specular = 1.0;
    fragColor = vec4(basecol, 1.0);
    vec3 _30 = pow(fragColor.xyz, vec3(0.4545454680919647216796875));
    fragColor = vec4(_30.x, _30.y, _30.z, fragColor.w);
}

