#include "DebugWindow.h"
#include "Application/Application.h"
#include "Application/ApplicationLayer.h"
#include "Application/Layers/RenderLayer.h"

DebugWindow::DebugWindow() :
	IEditorWindow()
{
	Name = "Debug";
	SplitDirection = ImGuiDir_::ImGuiDir_None;
	SplitDepth = 0.5f;
	Requirements = EditorWindowRequirements::Menubar;
}

DebugWindow::~DebugWindow() = default;

void DebugWindow::RenderMenuBar() 
{
	Application& app = Application::Get();
	RenderLayer::Sptr renderLayer = app.GetLayer<RenderLayer>();

	BulletDebugMode physicsDrawMode = app.CurrentScene()->GetPhysicsDebugDrawMode();
	if (BulletDebugDraw::DrawModeGui("Physics Debug Mode:", physicsDrawMode)) {
		app.CurrentScene()->SetPhysicsDebugDrawMode(physicsDrawMode);
	}

	ImGui::Separator();

	RenderFlags flags = renderLayer->GetRenderFlags();
	bool changed = false;
	bool temp = *(flags & RenderFlags::EnableColorCorrection);
	bool tempSpec = *(flags & RenderFlags::EnableSpecular);
	bool tempAmb = *(flags & RenderFlags::EnableAmbient);
	bool tempDiff = *(flags & RenderFlags::EnableDiffuse);
	if (ImGui::Checkbox("Enable Color Correction", &temp)) {
		changed = true;
		flags = (flags & ~*RenderFlags::EnableColorCorrection) | (temp ? RenderFlags::EnableColorCorrection : RenderFlags::None);
	}

	if (ImGui::Checkbox("Enable Specular Shader", &tempSpec)) {
		changed = true;
		flags = (flags & ~*RenderFlags::EnableSpecular) | (tempSpec ? RenderFlags::EnableSpecular : RenderFlags::None);
	}

	if (ImGui::Checkbox("Enable Ambient Shader", &tempAmb)) {
		changed = true;
		flags = (flags & ~*RenderFlags::EnableAmbient) | (tempAmb ? RenderFlags::EnableAmbient : RenderFlags::None);
	}

	if (ImGui::Checkbox("Enable Diffuse Shader", &tempDiff)) {
		changed = true;
		flags = (flags & ~*RenderFlags::EnableDiffuse) | (tempDiff ? RenderFlags::EnableDiffuse: RenderFlags::None);
	}

	if (changed) {
		renderLayer->SetRenderFlags(flags);
	}
}
