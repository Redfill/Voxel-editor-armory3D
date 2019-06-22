#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

out vec4 fragColor;

void main()
{
    vec3 basecol = vec3(0.0236709527671337127685546875, 0.80000007152557373046875, 0.00800146162509918212890625);
    float roughness = 0.100000001490116119384765625;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 1.0;
    fragColor = vec4(basecol, 1.0);
    vec3 _34 = pow(fragColor.xyz, vec3(0.4545454680919647216796875));
    fragColor = vec4(_34.x, _34.y, _34.z, fragColor.w);
}

