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
    customHighlight = {enabled = false, r = 0.243, g = 0.570, b = 1},
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
        private.classColorsReset(customClassColors, _G.RAID_CLASS_COLORS)
    end

    private.setColorCache(customClassColors)
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
    private.updateHighlightColor()

    _G.CUSTOM_CLASS_COLORS:RegisterCallback(function()
        _G.AuroraOptions.refresh()
    end)

    if AuroraConfig.buttonsHaveGradient then
        Color.button:SetRGB(.4, .4, .4)
    end

    -- Show splash screen for first time users
    if not AuroraConfig.acknowledgedSplashScreen then
        _G.AuroraSplashScreen:Show()
    end

    -- Create API hooks
    local Base = Aurora.Base
    local Hook = Aurora.Hook
    local Skin = Aurora.Skin
    function Hook.SharedTooltip_SetBackdropStyle(self, style)
        if not self.IsEmbedded then
            Base.SetBackdrop(self, Color.frame, AuroraConfig.alpha)
        end
    end

    local gradientBackdrop = {
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
    _G.hooksecurefunc(private.FrameXML, "CharacterFrame", function()
        if private.isClassic then return end

        _G.CharacterStatsPane.ItemLevelFrame:SetPoint("TOP", 0, -12)
        _G.CharacterStatsPane.ItemLevelFrame.Background:Hide()
        _G.CharacterStatsPane.ItemLevelFrame.Value:SetFontObject("SystemFont_Outline_WTF2")

        _G.hooksecurefunc("PaperDollFrame_UpdateStats", function()
            if ( _G.UnitLevel("player") >= _G.MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY ) then
                _G.CharacterStatsPane.ItemLevelCategory:Hide()
                _G.CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -40)
            end
        end)
    end)
    _G.hooksecurefunc(private.FrameXML, "FriendsFrame", function()
        local BNetFrame = _G.FriendsFrameBattlenetFrame
        BNetFrame.Tag:SetParent(_G.FriendsFrame)
        BNetFrame.Tag:SetAllPoints(_G.FriendsFrame.TitleText)

        local BroadcastFrame = BNetFrame.BroadcastFrame
        local EditBox
        if private.isRetail then
            EditBox = BroadcastFrame.EditBox
            EditBox:SetParent(_G.FriendsFrame)
            EditBox:ClearAllPoints()
            EditBox:SetSize(239, 25)
            EditBox:SetPoint("TOPLEFT", 57, -28)
            EditBox:SetScript("OnEnterPressed", function()
                BroadcastFrame:SetBroadcast()
            end)
        else
            EditBox = _G.FriendsFrameBroadcastInput
            Skin.FrameTypeEditBox(EditBox)

            EditBox:ClearAllPoints()
            EditBox:SetSize(245, 29)
            EditBox:SetPoint("TOPLEFT", 54, -26)

            _G.FriendsFrameBroadcastInputLeft:Hide()
            _G.FriendsFrameBroadcastInputRight:Hide()
            _G.FriendsFrameBroadcastInputMiddle:Hide()
            _G.FriendsFrameBroadcastInputFill:SetPoint("LEFT", 20, 0)
            EditBox.icon:SetPoint("LEFT", 3, 0)

            local stop
            _G.hooksecurefunc(EditBox, "SetTextInsets", function(self, left, right, top, bottom)
                if stop then return end
                stop = true
                self:SetTextInsets(20, right, 0, 0)
                stop = nil
            end)
        end

        _G.hooksecurefunc("FriendsFrame_Update", function()
            local selectedTab = _G.PanelTemplates_GetSelectedTab(_G.FriendsFrame) or _G.FRIEND_TAB_FRIENDS
            local isFriendsTab = selectedTab == _G.FRIEND_TAB_FRIENDS

            _G.FriendsFrame.TitleText:SetShown(not isFriendsTab)
            BNetFrame.Tag:SetShown(isFriendsTab)
            EditBox:SetShown(_G.BNConnected() and isFriendsTab)
        end)
        _G.hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
            if _G.BNFeaturesEnabled() then
                if _G.BNConnected() then
                    BNetFrame:Hide()
                    EditBox:Show()
                    if private.isRetail then
                        BroadcastFrame:UpdateBroadcast()
                    else
                        _G.FriendsFrameBroadcastInput_UpdateDisplay()
                    end
                else
                    EditBox:Hide()
                end
            end
        end)
    end)

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
