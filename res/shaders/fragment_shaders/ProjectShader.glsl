#version 430

#include "../fragments/fs_common_inputs.glsl"

// We output a single color to the color buffer
layout(location = 0) out vec4 frag_color;

////////////////////////////////////////////////////////////////
/////////////// Instance Level Uniforms ////////////////////////
////////////////////////////////////////////////////////////////

// Represents a collection of attributes that would define a material
// For instance, you can think of this like material settings in 
// Unity
struct Material {
	sampler2D Diffuse;
	float     Shininess;
};
// Create a uniform for the material
uniform Material u_Material;

////////////////////////////////////////////////////////////////
///////////// Application Level Uniforms ///////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/multiple_point_lights.glsl"

////////////////////////////////////////////////////////////////
/////////////// Frame Level Uniforms ///////////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/frame_uniforms.glsl"
#include "../fragments/color_correction.glsl"

// https://learnopengl.com/Advanced-Lighting/Advanced-Lighting
void main() {

	//Normalize our input
	vec3 normal = normalize(inNormal);

	//Set the strength of our ambient lighting
	float ambientStrength = 0.1;

	//Get the colour and strength of the light
	vec3 lightAccumulation = CalcAllLightContribution(inWorldPos, normal, u_CamPos.xyz, u_Material.Shininess);


	//Get the values for the texture of the object
	vec4 textureColor = texture(u_Material.Diffuse, inUV);

	//Set the result of our ambient light
	vec3 ambient = ambientStrength * lightAccumulation;

	//A variable for the diffused lighting
	float diffuse = max(dot(normal, lightAccumulation), 0.0);
	
	float specularStrength = 0.5;

	//Get the direction our camera is looking by subtracting our fragments position from where our camera is looking
	vec3 viewDir = normalize(u_CamPos.xyz - inWorldPos);

	//Getting the reflection of the light with the inverse of the results of our light accumulation
	vec3 reflectDir = reflect(-lightAccumulation, normal);

	//Setting the strength of the specular component
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);

	vec3 specular = specularStrength * spec * lightAccumulation;

	vec3 result = vec3(0);

	//Specular
	if (IsFlagSet(FLAG_ENABLE_SPECULAR)){
	
	
	result += specular;
	
	}
	

	//Diffuse 
	if (IsFlagSet(FLAG_ENABLE_DIFFUSE)){
	
	result += diffuse;
	
	}

		//Ambient
	if (IsFlagSet(FLAG_ENABLE_AMBIENT)){
		//Set the result of our ambient light
	result += ambient;
	result *= textureColor.rgb;		
	}

	
	

	frag_color = vec4 (ColorCorrect(result), 1.0);


}