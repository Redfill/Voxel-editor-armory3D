#version 450
in vec4 pos;
in vec2 tex;
in vec3 ipos;
out vec2 texCoord;
uniform mat4 WVP;
uniform float texUnpack;
void main() {
vec4 spos = vec4(pos.xyz, 1.0);
	spos.xyz += ipos;
	gl_Position = WVP * spos;
	texCoord = tex * texUnpack;
}
