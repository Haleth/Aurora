local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local pairs = _G.pairs

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

-- [[ Splash screen ]]

local splash = CreateFrame("Frame", "AuroraSplashScreen", _G.UIParent)
splash:SetPoint("CENTER")
splash:SetSize(400, 300)
splash:Hide()

do
	local title = splash:CreateFontString(nil, "ARTWORK", "GameFont_Gigantic")
	title:SetTextColor(1, 1, 1)
	title:SetPoint("TOP", 0, -25)
	title:SetText("Aurora " .. _G.GetAddOnMetadata("Aurora", "Version"))

	local body = splash:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	body:SetPoint("TOP", title, "BOTTOM", 0, -20)
	body:SetWidth(360)
	body:SetJustifyH("CENTER")
	body:SetText("Thank you for using Aurora!\n\n\nType |cff00a0ff/aurora|r at any time to access Aurora's options.\n\nThere, you can customize the addon's appearance.\n\nYou can also turn off optional features such as bags and tooltips if they are incompatible with your other addons.\n\n\n\nEnjoy!")

	local okayButton = CreateFrame("Button", nil, splash, "UIPanelButtonTemplate")
	okayButton:SetSize(128, 25)
	okayButton:SetPoint("BOTTOM", 0, 10)
	okayButton:SetText("Got it")
	okayButton:SetScript("OnClick", function()
		splash:Hide()
		_G.AuroraConfig.acknowledgedSplashScreen = true
	end)

	splash.okayButton = okayButton
	splash.closeButton = CreateFrame("Button", nil, splash, "UIPanelCloseButton")
end

-- [[ Options UI ]]

-- these variables are loaded on init and updated only on gui.okay. Calling gui.cancel resets the saved vars to these
local old = {}

local checkboxes = {}

-- function to copy table contents and inner table
local function copyTable(source, target)
	for key, value in pairs(source) do
		if _G.type(value) == "table" then
			target[key] = {}
			for k, v in pairs(value) do
				target[key][k] = value[k]
			end
		else
			target[key] = value
		end
	end
end

local function addSubCategory(parent, name)
	local header = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	header:SetText(name)

	local line = parent:CreateTexture(nil, "ARTWORK")
	line:SetSize(450, 1)
	line:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
	line:SetColorTexture(1, 1, 1, .2)

	return header
end

local function toggle(f)
	_G.AuroraConfig[f.value] = f:GetChecked()
end

local function createToggleBox(parent, value, text)
	local f = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
	f.value = value

	f.Text:SetText(text)

	f:SetScript("OnClick", toggle)

	_G.tinsert(checkboxes, f)

	return f
end

-- create frames/widgets

local gui = CreateFrame("Frame", "AuroraOptions", _G.UIParent)
gui.name = "Aurora"
_G.InterfaceOptions_AddCategory(gui)

local title = gui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("Aurora " .. _G.GetAddOnMetadata("Aurora", "Version"))

local features = addSubCategory(gui, "Features")
features:SetPoint("TOPLEFT", 16, -80)

local bagsBox = createToggleBox(gui, "bags", "Bags")
bagsBox:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -20)

local chatBubbleBox = createToggleBox(gui, "chatBubbles", "Chat bubbles")
chatBubbleBox:SetPoint("LEFT", bagsBox, "RIGHT", 90, 0)

local lootBox = createToggleBox(gui, "loot", "Loot")
lootBox:SetPoint("TOPLEFT", bagsBox, "BOTTOMLEFT", 0, -8)

local tooltipsBox = createToggleBox(gui, "tooltips", "Tooltips")
tooltipsBox:SetPoint("LEFT", lootBox, "RIGHT", 90, 0)

local appearance = addSubCategory(gui, "Appearance")
appearance:SetPoint("TOPLEFT", lootBox, "BOTTOMLEFT", 0, -30)

local fontBox = createToggleBox(gui, "enableFont", "Replace default game fonts")
fontBox:SetPoint("TOPLEFT", appearance, "BOTTOMLEFT", 0, -20)

local colourBox = createToggleBox(gui, "useCustomColour", "Custom highlight colour")
colourBox:SetPoint("TOPLEFT", fontBox, "BOTTOMLEFT", 0, -8)

local colourButton = CreateFrame("Button", nil, gui)
colourButton:SetPoint("LEFT", colourBox.Text, "RIGHT", 10, 0)
colourButton:SetSize(16, 16)

local useButtonGradientColourBox = createToggleBox(gui, "useButtonGradientColour", "Gradient button style")
useButtonGradientColourBox:SetPoint("TOPLEFT", colourBox, "BOTTOMLEFT", 0, -8)

local alphaSlider = CreateFrame("Slider", "AuroraOptionsAlpha", gui, "OptionsSliderTemplate")
alphaSlider:SetPoint("TOPLEFT", useButtonGradientColourBox, "BOTTOMLEFT", 0, -40)
_G.BlizzardOptionsPanel_Slider_Enable(alphaSlider)
alphaSlider:SetMinMaxValues(0, 1)
alphaSlider:SetValueStep(0.1)
_G.AuroraOptionsAlphaText:SetText("Backdrop opacity *")

local line = gui:CreateTexture(nil, "ARTWORK")
line:SetSize(600, 1)
line:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", 0, -30)
line:SetColorTexture(1, 1, 1, .2)

local reloadText = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 0, -40)
reloadText:SetText("Settings not marked with an asterisk (*) require a UI reload.")

local reloadButton = CreateFrame("Button", nil, gui, "UIPanelButtonTemplate")
reloadButton:SetPoint("LEFT", reloadText, "RIGHT", 20, 0)
reloadButton:SetSize(128, 25)
reloadButton:SetText("Reload UI")

local credits = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText("Aurora by Lightsword @ Argent Dawn - EU / Haleth on wowinterface.com")
credits:SetPoint("BOTTOM", 0, 40)

-- add event handlers

gui.refresh = function()
	alphaSlider:SetValue(_G.AuroraConfig.alpha)

	for i = 1, #checkboxes do
		checkboxes[i]:SetChecked(_G.AuroraConfig[checkboxes[i].value] == true)
	end

	local customColour = _G.AuroraConfig.customColour
	colourButton:SetBackdropColor(customColour.r, customColour.g, customColour.b)
	if not colourBox:GetChecked() then
		colourButton:Disable()
		colourButton:SetAlpha(.7)
	end
end

gui:RegisterEvent("ADDON_LOADED")
gui:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "Aurora" then return end

	-- fill 'old' table
	copyTable(_G.AuroraConfig, old)

	F.CreateBD(splash)
	F.Reskin(splash.okayButton)
	F.ReskinClose(splash.closeButton)

	F.Reskin(reloadButton)
	F.CreateBD(colourButton)
	F.ReskinSlider(alphaSlider)

	for i = 1, #checkboxes do
		F.ReskinCheck(checkboxes[i])
	end

	self:UnregisterEvent("ADDON_LOADED")
end)

local function updateFrames()
	for i = 1, #C.frames do
		F.CreateBD(C.frames[i], _G.AuroraConfig.alpha)
	end
end

gui.okay = function()
	copyTable(_G.AuroraConfig, old)
end

gui.cancel = function()
	copyTable(old, _G.AuroraConfig)

	updateFrames()
	gui.refresh()
end

gui.default = function()
	copyTable(C.defaults, _G.AuroraConfig)

	updateFrames()
	gui.refresh()
end

reloadButton:SetScript("OnClick", _G.ReloadUI)

alphaSlider:SetScript("OnValueChanged", function(_, value)
	_G.AuroraConfig.alpha = value
	updateFrames()
end)

colourBox:SetScript("OnClick", function(self)
	if self:GetChecked() then
		_G.AuroraConfig.useCustomColour = true
		colourButton:Enable()
		colourButton:SetAlpha(1)
	else
		_G.AuroraConfig.useCustomColour = false
		colourButton:Disable()
		colourButton:SetAlpha(.7)
	end
end)

local function setColour()
	local r, g, b = _G.ColorPickerFrame:GetColorRGB()
	_G.AuroraConfig.customColour.r, _G.AuroraConfig.customColour.g, _G.AuroraConfig.customColour.b = r, g, b
	colourButton:SetBackdropColor(r, g, b)
end

local function resetColour(restore)
	_G.AuroraConfig.customColour.r, _G.AuroraConfig.customColour.g, _G.AuroraConfig.customColour.b = restore.r, restore.g, restore.b
end

colourButton:SetScript("OnClick", function()
	local r, g, b = _G.AuroraConfig.customColour.r, _G.AuroraConfig.customColour.g, _G.AuroraConfig.customColour.b
	_G.ColorPickerFrame:SetColorRGB(r, g, b)
	_G.ColorPickerFrame.previousValues = {r = r, g = g, b = b}
	_G.ColorPickerFrame.func = setColour
	_G.ColorPickerFrame.cancelFunc = resetColour
	_G.ColorPickerFrame:Hide()
	_G.ColorPickerFrame:Show()
end)

-- easy slash command

_G.SlashCmdList.AURORA = function()
	_G.InterfaceOptionsFrame_OpenToCategory(gui)
end
_G.SLASH_AURORA1 = "/aurora"
