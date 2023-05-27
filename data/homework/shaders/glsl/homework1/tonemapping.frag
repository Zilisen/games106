#version 450

layout (location = 0) in vec2 inUV;

layout (set = 0, binding = 0) uniform sampler2D originColor;

// tonemap 所使用的函数
vec3 Tonemap_ACES(const vec3 c) {
    // Narkowicz 2015, "ACES Filmic Tone Mapping Curve"
    // const float a = 2.51;
    // const float b = 0.03;
    // const float c = 2.43;
    // const float d = 0.59;
    // const float e = 0.14;
    // return saturate((x*(a*x+b))/(x*(c*x+d)+e));

    //ACES RRT/ODT curve fit courtesy of Stephen Hill
	vec3 a = c * (c + 0.0245786) - 0.000090537;
	vec3 b = c * (0.983729 * c + 0.4329510) + 0.238081;
	return a / b;
}

layout (location = 0) out vec4 outFragColor;

void main()
{
    vec3 color = texture(originColor, inUV).rgb;
#ifdef ENABLE_TONE_MAPPING
    color = Tonemap_ACES(color);
#endif
    const float invGamma = 0.45454545;
    color = pow(color, vec3(invGamma));
    outFragColor = vec4(color, 1.0f);
}