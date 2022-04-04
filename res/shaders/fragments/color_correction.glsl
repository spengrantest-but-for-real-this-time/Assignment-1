// We need the flags from the frame uniforms
#include "frame_uniforms.glsl"

// Our color correction 3d texture
uniform layout (binding=14) sampler3D s_ColorCorrection;



uniform layout (binding=15) sampler3D s_ColorCorrection2;

uniform layout (binding=16) sampler3D s_ColorCorrection3;

// Function for applying color correction
vec3 ColorCorrect(vec3 inputColor) {
    // If our color correction flag is set, we perform the color lookup
    if (IsFlagSet(FLAG_ENABLE_COLOR_CORRECTION)) {
        return texture(s_ColorCorrection, inputColor).rgb;
    }

    else if (IsFlagSet(FLAG_ENABLE_CC_2)) {
        return texture(s_ColorCorrection2, inputColor).rgb;
    }
    // Otherwise just return the input
    else {
        return inputColor;
    }
}

