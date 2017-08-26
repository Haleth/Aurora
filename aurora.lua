local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ Core ]]
local Aurora = private.Aurora
local _, C = _G.unpack(Aurora)

-- [[ Constants and settings ]]
local AuroraConfig

C.frames = {}
C.classicons = { -- adjusted for borderless icons
    ["WARRIOR"]     = {0.01953125, 0.234375, 0.01953125, 0.234375},
    ["MAGE"]        = {0.26953125, 0.48046875, 0.01953125, 0.234375},
    ["ROGUE"]       = {0.515625, 0.7265625, 0.01953125, 0.234375},
    ["DRUID"]       = {0.76171875, 0.97265625, 0.01953125, 0.234375},
    ["HUNTER"]      = {0.01953125, 0.234375, 0.26953125, 0.484375},
    ["SHAMAN"]      = {0.26953125, 0.48046875, 0.26953125, 0.484375},
    ["PRIEST"]      = {0.515625, 0.7265625, 0.26953125, 0.484375},
    ["WARLOCK"]     = {0.76171875, 0.97265625, 0.26953125, 0.484375},
    ["PALADIN"]     = {0.01953125, 0.234375, 0.51953125, 0.734375},
    ["DEATHKNIGHT"] = {0.26953125, 0.48046875, 0.51953125, 0.734375},
    ["MONK"]        = {0.515625, 0.7265625, 0.51953125, 0.734375},
    ["DEMONHUNTER"] = {0.76171875, 0.97265625, 0.51953125, 0.734375},
}

C.media = {
    ["arrowUp"] = "Interface\\AddOns\\Aurora\\media\\arrow-up-active",
    ["arrowDown"] = "Interface\\AddOns\\Aurora\\media\\arrow-down-active",
    ["arrowLeft"] = "Interface\\AddOns\\Aurora\\media\\arrow-left-active",
    ["arrowRight"] = "Interface\\AddOns\\Aurora\\media\\arrow-right-active",
    ["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
    ["checked"] = "Interface\\AddOns\\Aurora\\media\\CheckButtonHilight",
    ["font"] = "Interface\\AddOns\\Aurora\\media\\font.ttf",
    ["gradient"] = "Interface\\AddOns\\Aurora\\media\\gradient",
    ["roleIcons"] = "Interface\\Addons\\Aurora\\media\\UI-LFG-ICON-ROLES",
}

C.defaults = {
    ["acknowledgedSplashScreen"] = false,

    ["alpha"] = 0.5,
    ["bags"] = true,
    ["buttonsHaveGradient"] = true,
    ["chatBubbles"] = true,
        ["chatBubbleNames"] = true,
    ["enableFont"] = true,
    ["loot"] = true,
    ["useCustomColour"] = false,
        ["customColour"] = {r = 1, g = 1, b = 1},
    ["customClassColors"] = false,
    ["tooltips"] = true,
}

function private.OnLoad()
    -- Load Variables
    _G.AuroraConfig = _G.AuroraConfig or {}
    AuroraConfig = _G.AuroraConfig

    if AuroraConfig.useButtonGradientColour ~= nil then
        AuroraConfig.buttonsHaveGradient = AuroraConfig.useButtonGradientColour
    end

    -- Remove deprecated or corrupt variables
    for key, value in next, AuroraConfig do
        if C.defaults[key] == nil then
            AuroraConfig[key] = nil
        end
    end

    -- Load or init variables
    for key, value in next, C.defaults do
        if AuroraConfig[key] == nil then
            if _G.type(value) == "table" then
                AuroraConfig[key] = {}
                for k, v in next, value do
                    AuroraConfig[key][k] = value[k]
                end
            else
                AuroraConfig[key] = value
            end
        end
    end

    -- Setup colors
    function private.updateHighlightColor()
        if AuroraConfig.useCustomColour then
            Aurora.highlightColor:SetRGB(AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b)
        else
            Aurora.highlightColor:SetRGB(_G.CUSTOM_CLASS_COLORS[private.charClass.token]:GetRGB())
        end
    end
    function private.classColorsInit()
        for classToken, color in next, AuroraConfig.customClassColors do
            _G.CUSTOM_CLASS_COLORS[classToken]:SetRGB(color.r, color.g, color.b)
        end

        private.updateHighlightColor()
        C.r, C.g, C.b = Aurora.highlightColor:GetRGB()
    end
    function private.classColorsHaveChanged()
        for i = 1, #_G.CLASS_SORT_ORDER do
            local classToken = _G.CLASS_SORT_ORDER[i]
            local color = _G.CUSTOM_CLASS_COLORS[classToken]
            local cache = AuroraConfig.customClassColors[classToken]

            if not color:IsEqualTo(cache) then
                --print("Change found in", classToken)
                color:SetRGB(cache.r, cache.g, cache.b)
                return true
            end
        end
    end
    _G.CUSTOM_CLASS_COLORS:RegisterCallback(function()
        for classToken, color in next, _G.CUSTOM_CLASS_COLORS do
            local ccc = AuroraConfig.customClassColors[classToken]
            ccc.r = color.r
            ccc.g = color.g
            ccc.b = color.b
            ccc.colorStr = color.colorStr
        end

        _G.AuroraOptions.refresh()
        private.updateHighlightColor()
    end)

    if not AuroraConfig.customClassColors or not AuroraConfig.customClassColors[private.charClass.token].colorStr then
        local customClassColors = {}
        private.classColorsReset(customClassColors, true)
        AuroraConfig.customClassColors = customClassColors
    end

    if AuroraConfig.buttonsHaveGradient then
        Aurora.buttonColor:SetRGBA(.3, .3, .3, 0.7)
    end

    -- Show splash screen for first time users
    if not AuroraConfig.acknowledgedSplashScreen then
        _G.AuroraSplashScreen:Show()
    end

    -- Create API hooks
    function Aurora.Base.Post.SetBackdrop(frame, r, g, b, a)
        if AuroraConfig.buttonsHaveGradient and Aurora.buttonColor:IsEqualTo(r, g, b, a) then
            Aurora.Base.SetTexture(frame:GetBackdropTexture("bg"), "gradientUp")
            Aurora.Base.SetBackdropColor(frame, r, g, b, a)
        elseif not a then
            r, g, b = Aurora.frameColor:GetRGB()
            frame:SetBackdropColor(r, g, b, AuroraConfig.alpha)
            _G.tinsert(C.frames, frame)
        end
    end

    function private.FrameXML.Post.CharacterFrame()
        _G.CharacterStatsPane.ItemLevelFrame:SetPoint("TOP", 0, -12)
        _G.CharacterStatsPane.ItemLevelFrame.Background:Hide()
        _G.CharacterStatsPane.ItemLevelFrame.Value:SetFontObject("SystemFont_Outline_WTF2")

        _G.hooksecurefunc("PaperDollFrame_UpdateStats", function()
            if ( _G.UnitLevel("player") >= _G.MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY ) then
                _G.CharacterStatsPane.ItemLevelCategory:Hide()
                _G.CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -40)
            end
        end)
    end
end
