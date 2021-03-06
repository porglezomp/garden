#version 410

layout (location = 0) in vec3 vert;
layout (location = 1) in vec3 inNorm;
layout (location = 2) in vec2 inUV;

layout (location = 0) out vec3 pos;
layout (location = 1) out vec3 norm;
layout (location = 2) out vec2 uv;

uniform mat4 modelview;
uniform mat4 perspective;

void main() {
    gl_Position = perspective * modelview * vec4(vert, 1.0);
    pos = vert;
    // norm = mat3(perspective * modelview) * inNorm;
    norm = inNorm;
    uv = inUV;
}
