#version 450
#include "compiled.inc"
in vec2 texCoord;
out vec4 fragColor;
uniform sampler2D ImageTexture;
void main() {
	vec3 TextureCoordinate_001_texread_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
	vec3 Mapping_texread_Vector_res = TextureCoordinate_001_texread_UV_res;
	vec4 ImageTexture_texread_store = texture(ImageTexture, vec2(Mapping_texread_Vector_res.x, 1.0 - Mapping_texread_Vector_res.y).xy);
	ImageTexture_texread_store.rgb = pow(ImageTexture_texread_store.rgb, vec3(2.2));
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	vec3 ImageTexture_Color_res = ImageTexture_texread_store.rgb;
	basecol = ImageTexture_Color_res;
	roughness = 1.0;
	metallic = 0.0;
	occlusion = 1.0;
	specular = 1.0;
	fragColor = vec4(basecol, 1.0);
	fragColor.rgb = pow(fragColor.rgb, vec3(1.0 / 2.2));
}
