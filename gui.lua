local F, C = unpack(Aurora)

-- these variables are loaded on init and updated only on gui.okay. Calling gui.cancel resets the saved vars to these
local oldAlpha, oldEnableFont, oldUseCustomColour
local oldCustomColour = {}

-- create frames/widgets

local gui = CreateFrame("Frame", "AuroraConfig", UIParent)
gui.name = "Aurora"
InterfaceOptions_AddCategory(gui)

local title = gui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("Aurora v."..GetAddOnMetadata("Aurora", "Version"))

local credits = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText("Aurora by Freethinker @ Steamwheedle Cartel - EU / Haleth on wowinterface.com")
credits:SetPoint("TOP", 0, -300)

local fontBox = CreateFrame("CheckButton", "AuroraConfigEnableFont", gui, "InterfaceOptionsCheckButtonTemplate")
fontBox:SetPoint("TOPLEFT", 16, -80)

local fontBoxText = fontBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
fontBoxText:SetPoint("LEFT", fontBox, "RIGHT", 1, 1)
fontBoxText:SetText("Replace default game fonts")

local colourBox = CreateFrame("CheckButton", "AuroraConfigUseClassColours", gui, "InterfaceOptionsCheckButtonTemplate")
colourBox:SetPoint("TOPLEFT", 16, -120)

local colourBoxText = colourBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
colourBoxText:SetPoint("LEFT", colourBox, "RIGHT", 1, 1)
colourBoxText:SetText("Use custom colour rather than class as highlight")

local colourButton = CreateFrame("Button", "AuroraConfigCustomColour", gui, "UIPanelButtonTemplate")
colourButton:SetPoint("LEFT", colourBoxText, "RIGHT", 20, 0)
colourButton:SetSize(128, 25)
colourButton:SetText("Change...")

local reloadText = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("TOPLEFT", 16, -170)
reloadText:SetText("The above settings require a UI reload.")

local reloadButton = CreateFrame("Button", "AuroraConfigReloadUI", gui, "UIPanelButtonTemplate")
reloadButton:SetPoint("LEFT", reloadText, "RIGHT", 20, 0)
reloadButton:SetSize(128, 25)
reloadButton:SetText("Reload UI")

local alphaSlider = CreateFrame("Slider", "AuroraConfigAlpha", gui, "OptionsSliderTemplate")
alphaSlider:SetPoint("TOPLEFT", 16, -230)
BlizzardOptionsPanel_Slider_Enable(alphaSlider)
alphaSlider:SetMinMaxValues(0, 1)
alphaSlider:SetValueStep(0.1)
AuroraConfigAlphaText:SetText("Backdrop opacity")

-- add event handlers

gui.refresh = function()
	alphaSlider:SetValue(AuroraConfig.alpha)
	fontBox:SetChecked(AuroraConfig.enableFont)
	colourBox:SetChecked(AuroraConfig.useCustomColour)
	if not colourBox:GetChecked() then
		colourButton:Disable()
	end
end

gui:RegisterEvent("ADDON_LOADED")
gui:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "Aurora" then return end

	oldAlpha = AuroraConfig.alpha
	oldEnableFont = AuroraConfig.enableFont
	oldUseCustomColour = AuroraConfig.useCustomColour
	oldCustomColour.r, oldCustomColour.g, oldCustomColour.b = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
	
	gui.refresh()
	
	F.Reskin(reloadButton)
	F.Reskin(colourButton)
	F.ReskinCheck(fontBox)
	F.ReskinCheck(colourBox)
	F.ReskinSlider(alphaSlider)
	
	self:UnregisterEvent("ADDON_LOADED")
end)

local function updateFrames()
	for i = 1, #C.frames do
		F.CreateBD(C.frames[i], AuroraConfig.alpha)
	end
end

gui.okay = function()
	oldAlpha = AuroraConfig.alpha
	oldEnableFont = AuroraConfig.enableFont
	oldUseCustomColour = AuroraConfig.useCustomColour
	oldCustomColour.r, oldCustomColour.g, oldCustomColour.b = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
end

gui.cancel = function()
	AuroraConfig.alpha = oldAlpha
	AuroraConfig.enableFont = oldEnableFont
	AuroraConfig.useCustomColour = oldUseCustomColour
	AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b = oldCustomColour.r, oldCustomColour.g, oldCustomColour.b
	
	updateFrames()
	gui.refresh()
end

gui.default = function()
	AuroraConfig.alpha = C.defaults.alpha
	AuroraConfig.enableFont = C.defaults.enableFont
	AuroraConfig.useCustomColour = C.defaults.useCustomColour
	AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b = C.defaults.customColour.r, C.defaults.customColour.g, C.defaults.customColour.b
	
	updateFrames()
	gui.refresh()
end

reloadButton:SetScript("OnClick", ReloadUI)

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

colourBox:SetScript("OnClick", function(self)
	if self:GetChecked() then
		AuroraConfig.useCustomColour = true
		colourButton:Enable()
	else
		AuroraConfig.useCustomColour = false
		colourButton:Disable()
	end
end)

local function setColour()
	local r, g, b = ColorPickerFrame:GetColorRGB()
	AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b = r, g, b
end

local function resetColour(restore)
	AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b = restore.r, restore.g, restore.b
end

colourButton:SetScript("OnClick", function()
	local r, g, b = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.previousValues = {r = r, g = g, b = b}
	ColorPickerFrame.func = setColour
	ColorPickerFrame.cancelFunc = resetColour
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end)

-- easy slash command

SlashCmdList.AURORA = function()
	InterfaceOptionsFrame_OpenToCategory(gui)
end
SLASH_AURORA1 = "/aurora"