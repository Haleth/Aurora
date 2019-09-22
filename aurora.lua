local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals next type

-- [[ Core ]]
local Aurora = private.Aurora
local _, C = _G.unpack(Aurora)

-- [[ Constants and settings ]]
local AuroraConfig

C.frames = {}
C.defaults = {
    acknowledgedSplashScreen = false,

    bags = true,
    chat = true,
    loot = true,
    mainmenubar = false,
    fonts = true,
    tooltips = true,
    chatBubbles = true,
        chatBubbleNames = true,

    buttonsHaveGradient = true,
    customHighlight = {enabled = false, r = 1, g = 1, b = 1},
    alpha = 0.5,

    --[[
        TODO: colorize - generate a monochrome color palette using the highlight
            color which overrides the default frame, button, and font colors
    ]]

    customClassColors = {},
}

function private.OnLoad()
    -- Load Variables
    _G.AuroraConfig = _G.AuroraConfig or {}
    AuroraConfig = _G.AuroraConfig

    if AuroraConfig.useButtonGradientColour ~= nil then
        AuroraConfig.buttonsHaveGradient = AuroraConfig.useButtonGradientColour
    end
    if AuroraConfig.enableFont ~= nil then
        AuroraConfig.fonts = AuroraConfig.enableFont
    end
    if AuroraConfig.customColour ~= nil then
        AuroraConfig.customHighlight = AuroraConfig.customColour
        if AuroraConfig.useCustomColour ~= nil then
            AuroraConfig.customHighlight.enabled = AuroraConfig.useCustomColour
        end
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
    local Color = Aurora.Color
    local customClassColors = AuroraConfig.customClassColors
    if not customClassColors[private.charClass.token] then
        private.classColorsReset(customClassColors, true)
    end

    function private.updateHighlightColor()
        local r, g, b
        if AuroraConfig.customHighlight.enabled then
            r, g, b = AuroraConfig.customHighlight.r, AuroraConfig.customHighlight.g, AuroraConfig.customHighlight.b
        else
            r, g, b = _G.CUSTOM_CLASS_COLORS[private.charClass.token]:GetRGB()
        end

        C.r, C.g, C.b = r, g, b -- deprecated
        Color.highlight:SetRGB(r, g, b)
    end
    function private.classColorsHaveChanged()
        local hasChanged = false
        for i = 1, #_G.CLASS_SORT_ORDER do
            local classToken = _G.CLASS_SORT_ORDER[i]
            local color = _G.CUSTOM_CLASS_COLORS[classToken]
            local cache = customClassColors[classToken]

            if not color:IsEqualTo(cache) then
                --print("Change found in", classToken)
                color:SetRGB(cache.r, cache.g, cache.b)
                hasChanged = true
            end
        end
        return hasChanged
    end
    function private.classColorsInit()
        if private.classColorsHaveChanged() or AuroraConfig.customHighlight.enabled then
            private.updateHighlightColor()
        end
    end
    _G.CUSTOM_CLASS_COLORS:RegisterCallback(function()
        for classToken, color in next, _G.CUSTOM_CLASS_COLORS do
            local ccc = customClassColors[classToken]
            ccc.r = color.r
            ccc.g = color.g
            ccc.b = color.b
            ccc.colorStr = color.colorStr
        end

        _G.AuroraOptions.refresh()
        private.updateHighlightColor()
    end)

    if AuroraConfig.buttonsHaveGradient then
        Color.button:SetRGB(.4, .4, .4)
    end

    -- Show splash screen for first time users
    if not AuroraConfig.acknowledgedSplashScreen then
        _G.AuroraSplashScreen:Show()
    end

    -- Create API hooks
    local Base, Hook = Aurora.Base, Aurora.Hook
    function Hook.GameTooltip_SetBackdropStyle(self, style)
        if not self.IsEmbedded then
            Base.SetBackdrop(self, Color.frame, AuroraConfig.alpha)
        end
    end

    local gradientBackdrop = {
        edgeSize = 1,
        bgFile = "gradientUp",
    }
    function Base.SetBackdrop(frame, color, alpha)
        local backdrop = private.backdrop
        if not alpha then
            if AuroraConfig.buttonsHaveGradient and Color.button:IsEqualTo(color) then
                backdrop = gradientBackdrop
            elseif not color then
                color, alpha = Color.frame, AuroraConfig.alpha
                _G.tinsert(C.frames, frame)
            end
        end

        Base.CreateBackdrop(frame, backdrop)
        Base.SetBackdropColor(frame, color, alpha)
    end

    -- Disable skins as per user settings
    private.disabled.bags = not AuroraConfig.bags
    private.disabled.chat = not AuroraConfig.chat
    private.disabled.fonts = not AuroraConfig.fonts
    private.disabled.tooltips = not AuroraConfig.tooltips
    private.disabled.mainmenubar = not AuroraConfig.mainmenubar
    if not AuroraConfig.chatBubbles then
        private.FrameXML.ChatBubbles = nil
    end
    if not AuroraConfig.chatBubbleNames then
        Hook.UpdateChatBubble = private.nop
    end
    if not AuroraConfig.loot then
        private.FrameXML.LootFrame = nil
    end

    function private.AddOns.Aurora()
        private.SetupGUI()
    end
end
