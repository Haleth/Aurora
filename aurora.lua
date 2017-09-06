local ADDON_NAME, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals next type

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

local hostDev
if ADDON_NAME == "Aurora" then
    for i = 1, _G.GetNumAddOns() do
        local meta = _G.GetAddOnMetadata(i, "X-Aurora-Host")
        if meta and type(_G[meta]) == "function" then
            local _, _, _, enabled = _G.GetAddOnInfo(i)
            if enabled then
                hostDev = _G[meta]
            end
        end
    end
end

function private.OnLoad()
    if hostDev then
        return hostDev(private)
    end

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
        local r, g, b
        if AuroraConfig.useCustomColour then
            r, g, b = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
        else
            r, g, b = _G.CUSTOM_CLASS_COLORS[private.charClass.token]:GetRGB()
        end

        C.r, C.g, C.b = r, g, b -- deprecated
        Aurora.highlightColor:SetRGBA(r, g, b, Aurora.frameColor.a)
    end
    function private.classColorsInit()
        for classToken, color in next, AuroraConfig.customClassColors do
            _G.CUSTOM_CLASS_COLORS[classToken]:SetRGB(color.r, color.g, color.b)
        end
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
        AuroraConfig.customClassColors = {}
        private.classColorsReset(AuroraConfig.customClassColors, true)
    end

    if AuroraConfig.buttonsHaveGradient then
        Aurora.buttonColor:SetRGBA(.3, .3, .3, 0.7)
    end

    -- Show splash screen for first time users
    if not AuroraConfig.acknowledgedSplashScreen then
        _G.AuroraSplashScreen:Show()
    end

    -- Create API hooks
    local Base, Hook = Aurora.Base, Aurora.Hook
    function Hook.GameTooltip_OnHide(gametooltip)
        local color = Aurora.frameColor
        Base.SetBackdropColor(gametooltip, color.r, color.g, color.b, AuroraConfig.alpha)
    end

    function Base.Post.SetBackdrop(frame, r, g, b, a)
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

    -- Disable skins as per user settings
    private.disabled.fonts = not AuroraConfig.enableFont
    private.disabled.tooltips = not AuroraConfig.tooltips
    if not AuroraConfig.chatBubbles then
        private.FrameXML.ChatBubbles = nil
    end
    if not AuroraConfig.chatBubbleNames then
        Hook.UpdateChatBubble = private.nop
    end
    if not AuroraConfig.bags then
        private.FrameXML.BankFrame = nil
        private.FrameXML.ContainerFrame = nil
    end
    if not AuroraConfig.loot then
        private.FrameXML.LootFrame = nil
    end
end
