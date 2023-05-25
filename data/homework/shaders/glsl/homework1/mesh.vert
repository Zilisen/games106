#version 450

layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec2 inUV;
layout (location = 3) in vec3 inColor;
layout (location = 4) in vec4 inTangent;
layout (location = 5) in uint inNodeIndex;

layout (set = 0, binding = 0) uniform UBOScene
{
	mat4 projection;
	mat4 view;
	vec4 lightPos;
	vec4 viewPos;
} uboScene;

layout(push_constant) uniform PushConsts {
	mat4 model;
} primitive;

layout (set = 2, binding = 0) readonly buffer AniMatrixs{
	mat4 animMatrixs[];
} anims;

layout (location = 0) out vec3 outNormal;
layout (location = 1) out vec3 outColor;
layout (location = 2) out vec2 outUV;
layout (location = 3) out vec3 outWorldPos;
layout (location = 4) out vec4 outTangent;

void main() 
{
	outColor = inColor;
	outUV = inUV;
	
	mat4 model = anims.animMatrixs[inNodeIndex];
	vec4 worldPos = model * vec4(inPos.xyz, 1.0);
	gl_Position = uboScene.projection * uboScene.view * worldPos;


	outWorldPos = vec3(worldPos);

	//outNormal = transpose(inverse(mat3(model))) * inNormal;
	outNormal = mat3(model) * inNormal;
	outTangent = vec4(mat3(model) * inTangent.xyz, inTangent.w);
}
