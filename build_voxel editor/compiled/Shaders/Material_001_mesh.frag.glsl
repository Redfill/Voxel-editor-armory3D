#version 450
#include "compiled.inc"
out vec4 fragColor;
void main() {
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	basecol = vec3(1.0, 1.0, 1.0);
	roughness = 0.0;
	metallic = 1.0;
	occlusion = 1.0;
	specular = 1.0;
	fragColor = vec4(basecol, 1.0);
	fragColor.rgb = pow(fragColor.rgb, vec3(1.0 / 2.2));
}
