#pragma once
#include "IComponent.h"
#include "Gameplay/Physics/RigidBody.h"

/// <summary>
/// A simple behaviour that applies an impulse along the Z axis to the 
/// rigidbody of the parent when the space key is pressed
/// </summary>
class FloatBehaviour : public Gameplay::IComponent {
public:
	typedef std::shared_ptr<FloatBehaviour> Sptr;

	std::weak_ptr<Gameplay::IComponent> Panel;

	FloatBehaviour();
	virtual ~FloatBehaviour();

	virtual void Awake() override;
	virtual void Update(float deltaTime) override;

	bool rising = true;

	int timer = 0;

public:
	virtual void RenderImGui() override;
	MAKE_TYPENAME(FloatBehaviour);
	virtual nlohmann::json ToJson() const override;
	static FloatBehaviour::Sptr FromJson(const nlohmann::json& blob);

protected:
	float _impulse;

	bool _isPressed = false;
	Gameplay::Physics::RigidBody::Sptr _body;
};