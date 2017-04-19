local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	local ModelPreviewFrame = _G.ModelPreviewFrame
	local Display = ModelPreviewFrame.Display
	local ModelScene = Display.ModelScene

	Display.YesMountsTex:Hide()
	Display.ShadowOverlay:Hide()

	F.ReskinPortraitFrame(ModelPreviewFrame, true)
	F.Reskin(ModelPreviewFrame.CloseButton)
	F.ReskinArrow(ModelScene.RotateLeftButton, "Left")
	F.ReskinArrow(ModelScene.RotateRightButton, "Right")

	local bg = F.CreateBDFrame(ModelScene, .25)
	bg:SetPoint("TOPLEFT", -1, 0)
	bg:SetPoint("BOTTOMRIGHT", 2, -2)

	ModelScene.RotateLeftButton:SetPoint("TOPRIGHT", ModelScene, "BOTTOM", -5, -10)
	ModelScene.RotateRightButton:SetPoint("TOPLEFT", ModelScene, "BOTTOM", 5, -10)
end)
