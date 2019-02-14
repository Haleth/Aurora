local _, private = ...

-- [[ Lua Globals ]]
local next, ipairs = _G.next, _G.ipairs

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local _, C = _G.unpack(Aurora)

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

local function updateFrames()
    local r, g, b = Aurora.Color.frame:GetRGB()
    for i = 1, #C.frames do
        C.frames[i]:SetBackdropColor(r, g, b, _G.AuroraConfig.alpha)
    end
end

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
    local function toggle(self)
        _G.AuroraConfig[self.value] = self:GetChecked()
    end

    function createToggleBox(parent, value, text)
        local checkbutton = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
        checkbutton.Text:SetText(text)
        checkbutton.value = value

        _G.tinsert(checkboxes, checkbutton)

        checkbutton:SetScript("OnClick", toggle)
        return checkbutton
    end
end

local createColorSwatch do
    local info, swatch = {}
    function info.swatchFunc()
        local r, g, b = _G.ColorPickerFrame:GetColorRGB()
        local value = _G.AuroraConfig[swatch.value]
        if swatch.class then
            value = value[swatch.class]
        end
        value.r, value.g, value.b = r, g, b
        swatch:SetBackdropColor(r, g, b)

        if swatch.class then
            _G.CUSTOM_CLASS_COLORS:NotifyChanges()
        else
            private.updateHighlightColor()
        end
    end

    function info.cancelFunc(restore)
        local value = _G.AuroraConfig[swatch.value]
        if swatch.class then
            value = value[swatch.class]
        end
        value.r, value.g, value.b = restore.r, restore.g, restore.b
        swatch:SetBackdropColor(restore.r, restore.g, restore.b)

        if swatch.class then
            _G.CUSTOM_CLASS_COLORS:NotifyChanges()
        else
            private.updateHighlightColor()
        end
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

    local frameColor = Aurora.Color.frame
    function createColorSwatch(parent, value, text)
        local button = CreateFrame("Button", nil, parent)
        button:SetScript("OnClick", OnClick)
        button:SetSize(16, 16)
        Base.SetBackdrop(button, frameColor, 1)
        button.value = value

        if text then
            button:SetNormalFontObject("GameFontHighlight")
            button:SetText(text)
            button:GetFontString():SetPoint("LEFT", button, "RIGHT", 10, 0)
        end

        return button
    end
end

local createSlider do
    local numSliders = 0
    local function OnValueChanged(self, value)
        _G.AuroraConfig[self.value] = value
        if self.update then
            self.update()
        end
    end

    function createSlider(parent, value, text)
        numSliders = numSliders + 1
        local slider = CreateFrame("Slider", "AuroraOptionsSlider"..numSliders, parent, "OptionsSliderTemplate")
        slider:SetMinMaxValues(0, 1)
        slider:SetValueStep(0.1)
        slider.value = value

        if text then
            _G[slider:GetName().."Text"]:SetText(text)
        end

        _G.BlizzardOptionsPanel_Slider_Enable(slider)

        slider:SetScript("OnValueChanged", OnValueChanged)
        return slider
    end
end

local createButton do
    function createButton(parent, func, text)
        local button = CreateFrame("Button", nil, parent, "OptionsButtonTemplate")
        button:SetText(text)

        button:SetScript("OnClick", function(self)
            func()
        end)
        return button
    end
end

-- create frames/widgets
local gui = CreateFrame("Frame", "AuroraOptions", _G.UIParent)
gui.name = "Aurora"
_G.InterfaceOptions_AddCategory(gui)

local title = gui:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", -30, -26)
title:SetText("Aurora " .. _G.GetAddOnMetadata("Aurora", "Version"))

--[[ Features ]]--
local features = addSubCategory(gui, "Features")
features:SetPoint("TOPLEFT", 16, -80)

local bagsBox = createToggleBox(gui, "bags", "Bags")
bagsBox:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 10, -20)

local lootBox = createToggleBox(gui, "loot", "Loot")
lootBox:SetPoint("LEFT", bagsBox, "RIGHT", 105, 0)

local mainmenubarBox = createToggleBox(gui, "mainmenubar", "Main Menu Bar")
mainmenubarBox:SetPoint("LEFT", lootBox, "RIGHT", 105, 0)

local chatBubbleBox = createToggleBox(gui, "chatBubbles", "Chat bubbles")
chatBubbleBox:SetPoint("TOPLEFT", bagsBox, "BOTTOMLEFT", 0, -15)

local chatBubbleNamesBox = createToggleBox(gui, "chatBubbleNames", "Show names")
chatBubbleNamesBox:SetPoint("TOPLEFT", chatBubbleBox, "BOTTOMRIGHT", -3, 3)
chatBubbleNamesBox:SetSize(20, 20)

chatBubbleBox:SetScript("OnClick", function(self)
    if self:GetChecked() then
        _G.AuroraConfig.chatBubbles = true
        chatBubbleNamesBox:Enable()
    else
        _G.AuroraConfig.chatBubbles = false
        chatBubbleNamesBox:Disable()
    end
end)

local chatBox = createToggleBox(gui, "chat", "Chat Frames")
chatBox:SetPoint("LEFT", chatBubbleBox, "RIGHT", 105, 0)

local tooltipsBox = createToggleBox(gui, "tooltips", "Tooltips")
tooltipsBox:SetPoint("LEFT", chatBox, "RIGHT", 105, 0)

--[[ Appearance ]]--
local appearance = addSubCategory(gui, "Appearance")
appearance:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -110)

local fontBox = createToggleBox(gui, "fonts", "Replace default game fonts")
fontBox:SetPoint("TOPLEFT", appearance, "BOTTOMLEFT", 10, -20)

local highlightBox = createToggleBox(gui, "customHighlight", "Custom highlight color")
highlightBox:SetPoint("TOPLEFT", fontBox, "BOTTOMLEFT", 0, -15)

local highlightButton = createColorSwatch(gui, "customHighlight")
highlightButton:SetPoint("LEFT", highlightBox.Text, "RIGHT", 10, 0)

highlightBox:SetScript("OnClick", function(self)
    if self:GetChecked() then
        _G.AuroraConfig.customHighlight.enabled = true
        highlightButton:Enable()
        highlightButton:SetAlpha(1)
    else
        _G.AuroraConfig.customHighlight.enabled = false
        highlightButton:Disable()
        highlightButton:SetAlpha(.7)
    end
    private.updateHighlightColor()
end)

local buttonsHaveGradientBox = createToggleBox(gui, "buttonsHaveGradient", "Gradient button style")
buttonsHaveGradientBox:SetPoint("TOPLEFT", highlightBox, "BOTTOMLEFT", 0, -15)

local alphaSlider = createSlider(gui, "alpha", "Backdrop opacity *")
alphaSlider:SetPoint("TOPLEFT", buttonsHaveGradientBox, "BOTTOMLEFT", 0, -40)
alphaSlider.update = updateFrames

--[[ Misc ]]--
local line = gui:CreateTexture(nil, "ARTWORK")
line:SetSize(600, 1)
line:SetPoint("TOPLEFT", appearance, "BOTTOMLEFT", 0, -210)
line:SetColorTexture(1, 1, 1, .2)

local credits = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText([[
Aurora by Lightsword @ Argent Dawn - EU / Haleth on wowinterface.com

Maintained by Gethe
]])
credits:SetPoint("TOP", line, "BOTTOM", 0, -20)

local reloadText = gui:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("BOTTOMLEFT", 20, 26)
reloadText:SetText("* Does not require a Reload UI.")

local reloadButton = createButton(gui, _G.C_UI.Reload, _G.RELOADUI)
reloadButton:SetPoint("BOTTOMRIGHT", -20, 20)


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

local resetButton = createButton(gui, private.classColorsReset, _G.RESET)
resetButton:SetPoint("RIGHT", classColors[1], "LEFT", -10, 0)
resetButton:SetWidth(50)


gui.refresh = function()
    alphaSlider:SetValue(_G.AuroraConfig.alpha)

    for i = 1, #checkboxes do
        checkboxes[i]:SetChecked(_G.AuroraConfig[checkboxes[i].value] == true)
    end

    local customHighlight = _G.AuroraConfig.customHighlight
    highlightBox:SetChecked(_G.AuroraConfig.customHighlight.enabled == true)
    highlightButton:SetBackdropColor(customHighlight.r, customHighlight.g, customHighlight.b)
    if not highlightBox:GetChecked() then
        highlightButton:Disable()
        highlightButton:SetAlpha(.7)
    end

    for i, classColor in ipairs(classColors) do
        local color = _G.AuroraConfig.customClassColors[classColor.class]
        local class = _G.LOCALIZED_CLASS_NAMES_MALE[classColor.class]
        classColor:SetFormattedText("|c%s%s|r", color.colorStr, class)
        classColor:SetBackdropColor(color.r, color.g, color.b)
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

function private.SetupGUI()
    -- fill 'old' table
    copyTable(_G.AuroraConfig, old)

    Base.SetBackdrop(splash)
    Skin.UIPanelButtonTemplate(splash.okayButton)
    Skin.UIPanelCloseButton(splash.closeButton)

    Skin.OptionsSliderTemplate(alphaSlider)
    for i = 1, #checkboxes do
        Skin.InterfaceOptionsCheckButtonTemplate(checkboxes[i])
    end

    Skin.OptionsButtonTemplate(reloadButton)
    Skin.OptionsButtonTemplate(resetButton)
end

-- easy slash command
private.commands = {}
_G.SLASH_AURORA1 = "/aurora"
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
        else
            _G.print("LibTextDump is not available.")
        end
    elseif private.commands[msg] then
        private.commands[msg]()
    else
        _G.InterfaceOptionsFrame_OpenToCategory(gui)
        _G.InterfaceOptionsFrame_OpenToCategory(gui)
    end
end
