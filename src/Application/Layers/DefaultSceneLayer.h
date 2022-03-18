#pragma once
#include "Application/ApplicationLayer.h"
#include "json.hpp"
#include "Graphics/Textures/Texture3D.h"

/**
 * This example layer handles creating a default test scene, which we will use 
 * as an entry point for creating a sample scene
 */
class DefaultSceneLayer final : public ApplicationLayer {
public:

	Texture3D::Sptr lut1;
	Texture3D::Sptr lut2;
	Texture3D::Sptr lut3;


	MAKE_PTRS(DefaultSceneLayer)

	DefaultSceneLayer();
	virtual ~DefaultSceneLayer();

	// Inherited from ApplicationLayer

	virtual void OnAppLoad(const nlohmann::json& config) override;

protected:
	void _CreateScene();
};

