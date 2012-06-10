local F, C = unpack(Aurora)

local oldAlpha, oldEnableFont

-- create frames/widgets

local gui = CreateFrame("Frame", "AuroraConfig", UIParent)
gui.name = "Aurora"
InterfaceOptions_AddCategory(gui)

local title = gui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("Aurora v."..GetAddOnMetadata("Aurora", "Version"))

local credits = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText("Aurora by Freethinker @ Steamwheedle Cartel - EU / Haleth on wowinterface.com")
credits:SetPoint("TOP", 0, -240)

local fontBox = CreateFrame("CheckButton", "AuroraConfigEnableFont", gui, "InterfaceOptionsCheckButtonTemplate")
fontBox:SetPoint("TOPLEFT", 16, -80)

local fontBoxText = fontBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
fontBoxText:SetPoint("LEFT", fontBox, "RIGHT", 1, 1)
fontBoxText:SetText("Replace default game fonts (requires UI reload)")

local reloadButton = CreateFrame("Button", "AuroraConfigReloadUI", gui, "UIPanelButtonTemplate")
reloadButton:SetPoint("LEFT", fontBoxText, "RIGHT", 20, 0)
reloadButton:SetSize(128, 25)
reloadButton:SetText("Reload UI")
reloadButton:SetScript("OnClick", ReloadUI)

local alphaSlider = CreateFrame("Slider", "AuroraConfigAlpha", gui, "OptionsSliderTemplate")
alphaSlider:SetPoint("TOPLEFT", 16, -140)
BlizzardOptionsPanel_Slider_Enable(alphaSlider)
alphaSlider:SetMinMaxValues(0, 1)
alphaSlider:SetValueStep(0.1)
AuroraConfigAlphaText:SetText("Alpha")

F.Reskin(reloadButton)
F.ReskinCheck(fontBox)
F.ReskinSlider(alphaSlider)

-- add event handlers

local function updateFrames()
	for i = 1, #C.frames do
		F.CreateBD(C.frames[i], AuroraConfig.alpha)
	end
end

gui.refresh = function()
	alphaSlider:SetValue(oldAlpha)
	fontBox:SetChecked(oldEnableFont)
end

gui:RegisterEvent("ADDON_LOADED")
gui:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "Aurora" then return end

	oldAlpha = AuroraConfig.alpha
	oldEnableFont = AuroraConfig.enableFont
	
	gui.refresh()
	
	self:UnregisterEvent("ADDON_LOADED")
end)

gui.okay = function()
	oldAlpha = AuroraConfig.alpha
	oldEnableFont = AuroraConfig.enableFont
end

gui.cancel = function()
	AuroraConfig.alpha = oldAlpha
	AuroraConfig.enableFont = oldEnableFont
	updateFrames()
	gui.refresh()
end

gui.default = function()
	oldAlpha = C.defaults.alpha
	oldEnableFont = C.defaults.enableFont
	AuroraConfig.alpha = oldAlpha
	AuroraConfig.enableFont = oldEnableFont
	updateFrames()
	gui.refresh()
end

alphaSlider:SetScript("OnValueChanged", function(_, value)
	AuroraConfig.alpha = value
	updateFrames()
end)

fontBox:SetScript("OnClick", function(self)
	if self:GetChecked() then
		AuroraConfig.enableFont = true
	else
		AuroraConfig.enableFont = false
	end
end)

-- easy slash command

SlashCmdList.AURORA = function()
	InterfaceOptionsFrame_OpenToCategory(gui)
end
SLASH_AURORA1 = "/aurora"