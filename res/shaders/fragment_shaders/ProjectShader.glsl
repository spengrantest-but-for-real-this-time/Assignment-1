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

//Add a uniform for the LUT for the toon shading
uniform sampler1D s_ToonTerm;

////////////////////////////////////////////////////////////////
///////////// Application Level Uniforms ///////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/multiple_point_lights.glsl"

////////////////////////////////////////////////////////////////
/////////////// Frame Level Uniforms ///////////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/frame_uniforms.glsl"
#include "../fragments/color_correction.glsl"


// https://simonharris.co/making-a-noise-film-grain-post-processing-effect-from-scratch-in-threejs/

////A function to allow us to generate "Random" numbers as a vec2 
////As open GL has no "random" function we fake it
//float random(vec2 p)
//{
//
//
//	vec2 K1 = vec2(
//
//		23.14069263277926, //e ^ pi
//		2.6651441412690225 // 2 ^ sqrt (2)
//
//
//	);
//
//	//Do some math to return a psuedo random number
//	//Dot product of P (our fragment UV and our vec2)
//	//Cos that value
//	//Multiply it by a large number
//	//Fract returns the nearest integer as a fraction
//	return fract(cos(dot(p, K1)) * 12345.6789);
//
//}

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

	//Normalizing the  distance between camera position and the lights position to get the 
	//Direction from the light to the camera
	vec3 toEye = normalize(u_CamPos.xyz - inWorldPos);

	
	//Getting the reflection of the light with the inverse direction of our camera to the fragment
	vec3 reflectDir = reflect(-toEye, normal);


	//A variable for the diffused lighting
	float diffuse = max(dot(normal, lightAccumulation), 0.0);
	
	//Strength of our specular lighting, gotten from the specular material and the UV input
	float specularStrength = 0.5;

	//Get the direction our camera is looking by subtracting our fragments position from where our camera is looking
	vec3 viewDir = normalize(u_CamPos.xyz - inWorldPos);





	//Setting the strength of the specular component
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);

	vec3 specular = specularStrength * spec * lightAccumulation;


	//An intesity value for our cel-shading, using the position of our lights and 
	//the normal of our fragment
	float intensity = dot(normalize(inWorldPos), normal);

	vec4 color2;

	if (intensity > 0.95) { color2 = vec4(1.0, 1.0, 1.0, 1.0);}
	else if (intensity > 0.75) { color2 = vec4(0.8, 0.8, 0.8, 1.0);}
	else if (intensity > 0.50) { color2 = vec4(0.6, 0.6, 0.6, 1.0);}
	else if (intensity > 0.25) { color2 = vec4(0.4, 0.4, 0.4, 1.0);}
	else { color2 = vec4(0.2, 0.2, 0.2, 1.0);}

	vec3 result = vec3(0);

		if (IsFlagSet(FLAG_ENABLE_CUSTOM))
	{
			//Adding the "cartoon" effect
	textureColor *= color2; 


		//if toon shader flag is set
	// Using a LUT to allow artists to tweak toon shading settings
    result.r = texture(s_ToonTerm, result.r).r;
    result.g = texture(s_ToonTerm, result.g).g;
    result.b = texture(s_ToonTerm, result.b).b;
	}




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
	//Also multiply the ambient lighting result to increase the brightness of the scene
	result += ambient * 8;
	result *= textureColor.rgb;		
	}
	//End of if	

	

	frag_color = vec4 (ColorCorrect(result), 1.0);


}