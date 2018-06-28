local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\InterfaceOptionsPanels.lua
end ]]

do --[[ FrameXML\InterfaceOptionsPanels.xml ]]
    function Skin.InterfaceOptionsBaseCheckButtonTemplate(CheckButton)
        Skin.OptionsBaseCheckButtonTemplate(CheckButton)
    end
    function Skin.InterfaceOptionsCheckButtonTemplate(CheckButton)
        Skin.InterfaceOptionsBaseCheckButtonTemplate(CheckButton)
        CheckButton.Text:SetPoint(CheckButton.Text:GetPoint())
    end
    function Skin.InterfaceOptionsSmallCheckButtonTemplate(CheckButton)
        Skin.InterfaceOptionsBaseCheckButtonTemplate(CheckButton)
        local name = CheckButton:GetName()
        _G[name.."Text"]:SetPoint(_G[name.."Text"]:GetPoint())
    end
end

function private.FrameXML.InterfaceOptionsPanels()
    --------------
    -- Controls --
    --------------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsControlsPanelStickyTargeting)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsControlsPanelAutoDismount)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsControlsPanelAutoClearAFK)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsControlsPanelAutoLootCorpse)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsControlsPanelAutoLootKeyDropDown)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsControlsPanelInteractOnLeftClick)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsControlsPanelLootAtMouse)

    ------------
    -- Combat --
    ------------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelTargetOfTarget)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelFlashLowHealthWarning)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsCombatPanelFocusCastKeyDropDown)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsCombatPanelSelfCastKeyDropDown)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelAutoSelfCast)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelLossOfControl)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelEnableFloatingCombatText)
    Skin.OptionsSliderTemplate(_G.InterfaceOptionsCombatPanelSpellAlertOpacitySlider)

    -------------
    -- Display --
    -------------
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsDisplayPanelOutlineDropDown)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelRotateMinimap)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelAJAlerts)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelShowTutorials)
    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsDisplayPanelResetTutorials)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsDisplayPanelSelfHighlightDropDown)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsDisplayPanelDisplayDropDown)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsDisplayPanelChatBubblesDropDown)

    ------------
    -- Social --
    ------------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelProfanityFilter)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelSpamFilter)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelGuildMemberAlert)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelBlockTrades)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelBlockGuildInvites)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelBlockChatChannelInvites)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelShowAccountAchievments)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelOnlineFriends)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelOfflineFriends)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelBroadcasts)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelAutoAcceptQuickJoinRequests)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelFriendRequests)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelShowToastWindow)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelEnableTwitter)
    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsSocialPanelTwitterLoginButton)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsSocialPanelChatStyle)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsSocialPanelTimestamps)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsSocialPanelWhisperMode)
    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsSocialPanelRedockChat)

    ----------------
    -- ActionBars --
    ----------------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelBottomLeft)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelBottomRight)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelRight)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelRightTwo)
    if private.isPatch then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelStackRightBars)
    end
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelLockActionBars)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsActionBarsPanelPickupActionKeyDropDown)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelAlwaysShowActionBars)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelCountdownCooldowns)

    -----------
    -- Names --
    -----------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelMyName)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsNamesPanelNPCNamesDropDown)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelNonCombatCreature)

    -- Friendly
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelFriendlyPlayerNames)
    Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelFriendlyMinions)

    -- Enemy
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelEnemyPlayerNames)
    Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelEnemyMinions)

    -- UnitNameplates
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesPersonalResource)
    Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesPersonalResourceOnEnemy)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesMakeLarger)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesAggroFlash)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesShowAll)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesEnemies)
    Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesEnemyMinions)
    Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesEnemyMinus)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesFriends)
    Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesFriendlyMinions)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown)

    ------------
    -- Camera --
    ------------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCameraPanelWaterCollision)
    Skin.OptionsSliderTemplate(_G.InterfaceOptionsCameraPanelFollowSpeedSlider)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsCameraPanelStyleDropDown)

    -----------
    -- Mouse --
    -----------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsMousePanelInvertMouse)
    Skin.OptionsSliderTemplate(_G.InterfaceOptionsMousePanelMouseLookSpeedSlider)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsMousePanelEnableMouseSpeed)
    Skin.OptionsSliderTemplate(_G.InterfaceOptionsMousePanelMouseSensitivitySlider)
    if private.isPatch then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsMousePanelLockCursorToScreen)
    end
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsMousePanelClickToMove)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsMousePanelClickMoveStyleDropDown)

    -------------------
    -- Accessibility --
    -------------------
    local Accessibility = _G.InterfaceOptionsAccessibilityPanel
    Skin.InterfaceOptionsCheckButtonTemplate(Accessibility.MovePad)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsAccessibilityPanelCinematicSubtitles)
    Skin.InterfaceOptionsCheckButtonTemplate(Accessibility.ColorblindMode)

    local FilterExamples = Accessibility.ColorblindFilterExamples
    FilterExamples.Hostile:SetTexCoord(0.2, 0.8, 0.4, 0.6)
    FilterExamples.Hostile:SetPoint("BOTTOMLEFT", 9, 158)
    FilterExamples.Hostile:SetSize(103, 10)
    FilterExamples.HostileLabel:SetPoint("BOTTOMLEFT", FilterExamples.Hostile, "TOPLEFT", 1, 7)

    FilterExamples.Neutral:SetTexCoord(0.2, 0.8, 0.4, 0.6)
    FilterExamples.Neutral:SetPoint("TOPLEFT", FilterExamples.Hostile, "BOTTOMLEFT", 0, -37)
    FilterExamples.Neutral:SetSize(103, 10)
    FilterExamples.NeutralLabel:SetPoint("BOTTOMLEFT", FilterExamples.Neutral, "TOPLEFT", 1, 7)

    FilterExamples.Friendly:SetTexCoord(0.2, 0.8, 0.4, 0.6)
    FilterExamples.Friendly:SetPoint("TOPLEFT", FilterExamples.Neutral, "BOTTOMLEFT", 0, -37)
    FilterExamples.Friendly:SetSize(103, 10)
    FilterExamples.FriendlyLabel:SetPoint("BOTTOMLEFT", FilterExamples.Friendly, "TOPLEFT", 1, 7)

    Skin.UIDropDownMenuTemplate(Accessibility.ColorblindFilterDropDown)
    Skin.OptionsSliderTemplate(_G.InterfaceOptionsAccessibilityPanelColorblindStrengthSlider)

    -------------
    -- Section --
    -------------
    Skin.BasicFrameTemplate(_G.SocialBrowserFrame)
end
