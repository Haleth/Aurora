local _, private = ...

-- [[ Lua Globals ]]
local next, ipairs = _G.next, _G.ipairs

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
local text = [[
Thank you for using Aurora!


Type |cff00a0ff/aurora|r at any time to access Aurora's options.

There, you can customize the addon's appearance.

You can also turn off optional features such as bags and tooltips if they are incompatible with your other addons.



Enjoy!
]]
	local title = splash:CreateFontString(nil, "ARTWORK", "GameFont_Gigantic")
	title:SetTextColor(1, 1, 1)
	title:SetPoint("TOP", 0, -25)
	title:SetText("Aurora " .. _G.GetAddOnMetadata("Aurora", "Version"))

	local body = splash:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	body:SetPoint("TOP", title, "BOTTOM", 0, -20)
	body:SetWidth(360)
	body:SetJustifyH("CENTER")
	body:SetText(text)

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
	for key, value in next, source do
		if _G.type(value) == "table" then
			target[key] = {}
			for k, v in next, value do
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

local createToggleBox do
	local function toggle(f)
		_G.AuroraConfig[f.value] = f:GetChecked()
	end

	function createToggleBox(parent, value, text)
		local f = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
		f.value = value

		f.Text:SetText(text)

		f:SetScript("OnClick", toggle)

		_G.tinsert(checkboxes, f)

		return f
	end
end


local createColorSwatch do
	local info, swatch = {}
	function info.swatchFunc()
		local r, g, b = _G.ColorPickerFrame:GetColorRGB()
		local value = _G.AuroraConfig[swatch.value]
		if swatch.class then
			value = value[swatch.class]
			value.colorStr = ("ff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
			_G.CUSTOM_CLASS_COLORS:NotifyChanges()
		end
		value.r, value.g, value.b = r, g, b
		swatch:SetBackdropColor(r, g, b)
	end

	function info.cancelFunc(restore)
		local value = _G.AuroraConfig[swatch.value]
		if swatch.class then
			value = value[swatch.class]
			value.colorStr = ("ff%02x%02x%02x"):format(restore.r * 255, restore.g * 255, restore.b * 255)
		end
		value.r, value.g, value.b = restore.r, restore.g, restore.b
	end

	local function OnClick(self)
		local value = _G.AuroraConfig[self.value]
		if self.class then
			value = value[self.class]
		end
		swatch = self
		info.r, info.g, info.b = value.r, value.g, value.b
		_G.OpenColorPicker(info)
	end

	function createColorSwatch(parent, value, text)
		local button = CreateFrame("Button", nil, parent)
		button:SetScript("OnClick", OnClick)
		button:SetBackdrop(C.backdrop)
		button:SetBackdropBorderColor(0, 0, 0)
		button:SetSize(16, 16)
		button.value = value

		if text then
			button:SetNormalFontObject("GameFontHighlight")
			button:SetText(text)
			button:GetFontString():SetPoint("LEFT", button, "RIGHT", 10, 0)
		end

		return button
	end
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

local lootBox = createToggleBox(gui, "loot", "Loot")
lootBox:SetPoint("LEFT", bagsBox, "RIGHT", 90, 0)

local chatBubbleBox = createToggleBox(gui, "chatBubbles", "Chat bubbles")
chatBubbleBox:SetPoint("TOPLEFT", bagsBox, "BOTTOMLEFT", 0, -8)

local chatBubbleNamesBox = createToggleBox(gui, "chatBubbleNames", "Show names")
chatBubbleNamesBox:SetPoint("TOPLEFT", chatBubbleBox, "BOTTOMRIGHT", -5, 0)
chatBubbleNamesBox:SetSize(22, 22)

local tooltipsBox = createToggleBox(gui, "tooltips", "Tooltips")
tooltipsBox:SetPoint("LEFT", chatBubbleBox, "RIGHT", 90, 0)

local appearance = addSubCategory(gui, "Appearance")
appearance:SetPoint("TOPLEFT", chatBubbleBox, "BOTTOMLEFT", 0, -35)

local fontBox = createToggleBox(gui, "enableFont", "Replace default game fonts")
fontBox:SetPoint("TOPLEFT", appearance, "BOTTOMLEFT", 0, -20)

local colourBox = createToggleBox(gui, "useCustomColour", "Custom highlight colour")
colourBox:SetPoint("TOPLEFT", fontBox, "BOTTOMLEFT", 0, -8)

local colourButton = createColorSwatch(gui, "customColour")
colourButton:SetPoint("LEFT", colourBox.Text, "RIGHT", 10, 0)

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


local classColors = {}
for i, class in ipairs(_G.CLASS_SORT_ORDER) do
	local classColor = createColorSwatch(gui, "customClassColors", class)
	classColor.class = class
	classColors[i] = classColor

	if i == 1 then
		classColor:SetPoint("TOPLEFT", gui, "TOPRIGHT", -130, -105)
	else
		classColor:SetPoint("TOPLEFT", classColors[i - 1], "BOTTOMLEFT", 0, -10)
	end
end

local resetButton = CreateFrame("Button", nil, gui, "UIPanelButtonTemplate")
resetButton:SetPoint("RIGHT", classColors[1], "LEFT", -10, 0)
resetButton:SetSize(50, 20)
resetButton:SetText(_G.RESET)


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

	for i, classColor in ipairs(classColors) do
		local color = _G.AuroraConfig.customClassColors[classColor.class]
		local class = _G.LOCALIZED_CLASS_NAMES_MALE[classColor.class]
		classColor:SetFormattedText("|c%s%s|r", color.colorStr, class)
		classColor:SetBackdropColor(color.r, color.g, color.b)
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

	F.Reskin(resetButton)
	F.Reskin(reloadButton)
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

chatBubbleBox:SetScript("OnClick", function(self)
	if self:GetChecked() then
		_G.AuroraConfig.chatBubbles = true
		chatBubbleNamesBox:Enable()
	else
		_G.AuroraConfig.chatBubbles = false
		chatBubbleNamesBox:Disable()
	end
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

alphaSlider:SetScript("OnValueChanged", function(_, value)
	_G.AuroraConfig.alpha = value
	updateFrames()
end)

reloadButton:SetScript("OnClick", _G.ReloadUI)

resetButton:SetScript("OnClick", function(self)
	private.classColorsReset(_G.AuroraConfig.customClassColors)
	gui.refresh()
end)


-- easy slash command

_G.SlashCmdList.AURORA = function(msg, editBox)
	private.debug("/aurora", msg)
	if msg == "debug" then
		local debugger = private.debugger
		if debugger then
			if debugger:Lines() == 0 then
				debugger:AddLine("Nothing to report.")
				debugger:Display()
				debugger:Clear()
				return
			end
			debugger:Display()
		end
	else
		_G.InterfaceOptionsFrame_OpenToCategory(gui)
	end
end
_G.SLASH_AURORA1 = "/aurora"
