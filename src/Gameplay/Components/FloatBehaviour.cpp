#include "Gameplay/Components/FloatBehaviour.h"
#include <GLFW/glfw3.h>
#include "Gameplay/GameObject.h"
#include "Gameplay/Scene.h"
#include "Utils/ImGuiHelper.h"
#include "Gameplay/InputEngine.h"

void FloatBehaviour::Awake()
{
	_body = GetComponent<Gameplay::Physics::RigidBody>();
	if (_body == nullptr) {
		IsEnabled = false;
	}
}

void FloatBehaviour::RenderImGui() {
	LABEL_LEFT(ImGui::DragFloat, "Impulse", &_impulse, 1.0f);
}

nlohmann::json FloatBehaviour::ToJson() const {
	return {
		{ "impulse", _impulse }
	};
}

FloatBehaviour::FloatBehaviour() :
	IComponent(),
	_impulse(10.0f)
{ }

FloatBehaviour::~FloatBehaviour() = default;

FloatBehaviour::Sptr FloatBehaviour::FromJson(const nlohmann::json & blob) {
	FloatBehaviour::Sptr result = std::make_shared<FloatBehaviour>();
	result->_impulse = blob["impulse"];
	return result;
}

void FloatBehaviour::Update(float deltaTime) {
	
	if (rising == true)
	{
		return _body->ApplyImpulse(glm::vec3(0.0f, 0.0f, 1.0f));
		timer += 1;
	}
	else if(rising == false)
	{

		return _body->ApplyImpulse(glm::vec3(0.0f, 0.0f, -1.0f));
		timer += 1;
	}

	if (timer >= 100)
	{

		rising = !rising;
		timer = 0;

	}

		Gameplay::IComponent::Sptr ptr = Panel.lock();
		if (ptr != nullptr) {
			ptr->IsEnabled = !ptr->IsEnabled;
	
	}
}