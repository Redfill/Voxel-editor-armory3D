#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform sampler2D ImageTexture;

in vec2 texCoord;
out vec4 fragColor;

void main()
{
    vec3 TextureCoordinate_001_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
    vec3 Mapping_texread_Vector_res = TextureCoordinate_001_texread_UV_res;
    vec4 ImageTexture_texread_store = texture(ImageTexture, vec2(Mapping_texread_Vector_res.x, 1.0 - Mapping_texread_Vector_res.y));
    vec3 _47 = pow(ImageTexture_texread_store.xyz, vec3(2.2000000476837158203125));
    ImageTexture_texread_store = vec4(_47.x, _47.y, _47.z, ImageTexture_texread_store.w);
    vec3 ImageTexture_Color_res = ImageTexture_texread_store.xyz;
    vec3 basecol = ImageTexture_Color_res;
    float roughness = 1.0;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 1.0;
    fragColor = vec4(basecol, 1.0);
    vec3 _70 = pow(fragColor.xyz, vec3(0.4545454680919647216796875));
    fragColor = vec4(_70.x, _70.y, _70.z, fragColor.w);
}

