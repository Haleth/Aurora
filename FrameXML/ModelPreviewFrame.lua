local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	local ModelPreviewFrame = _G.ModelPreviewFrame
	local Display = ModelPreviewFrame.Display
	local Model = Display.Model or Display.ModelScene -- is72

	Display.YesMountsTex:Hide()
	Display.ShadowOverlay:Hide()

	F.ReskinPortraitFrame(ModelPreviewFrame, true)
	F.Reskin(ModelPreviewFrame.CloseButton)
	F.ReskinArrow(Model.RotateLeftButton, "left")
	F.ReskinArrow(Model.RotateRightButton, "right")

	local bg = F.CreateBDFrame(Model, .25)
	bg:SetPoint("TOPLEFT", -1, 0)
	bg:SetPoint("BOTTOMRIGHT", 2, -2)

	Model.RotateLeftButton:SetPoint("TOPRIGHT", Model, "BOTTOM", -5, -10)
	Model.RotateRightButton:SetPoint("TOPLEFT", Model, "BOTTOM", 5, -10)
end)
