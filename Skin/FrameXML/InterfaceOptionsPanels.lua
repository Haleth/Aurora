local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\InterfaceOptionsPanels.lua ]]
--end

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
    if private.isRetail then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsControlsPanelAutoDismount)
    end
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
    if private.isRetail then
        Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsCombatPanelFocusCastKeyDropDown)
    end
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsCombatPanelSelfCastKeyDropDown)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelAutoSelfCast)
    if private.isRetail then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelLossOfControl)
    end
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelEnableFloatingCombatText)
    if private.isRetail then
        Skin.OptionsSliderTemplate(_G.InterfaceOptionsCombatPanelSpellAlertOpacitySlider)
    else
        Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsCombatPanelCombatTextFloatModeDropDown)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextLowManaHealth)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextAuras)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextAuraFade)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextState)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextParryDodgeMiss)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextResistances)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextReputation)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextReactives)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextFriendlyNames)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextComboPoints)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextEnergyGains)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelCombatTextHonorGains)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelEnableCombatDamageText)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelEnablePeriodicDamage)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCombatPanelEnablePetDamage)
    end

    -------------
    -- Display --
    -------------
    if private.isRetail then
        Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsDisplayPanelOutlineDropDown)
    else
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelShowHelm)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelShowCloak)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelInstantQuestText)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelAutoQuestWatch)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelHideOutdoorWorldState)
    end
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelRotateMinimap)
    if private.isRetail then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelAJAlerts)
        if private.isPatch then
            Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelShowInGameNavigation)
        end
    else
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelShowMinimapClock)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelShowDetailedTooltips)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelShowLoadingScreenTip)
    end
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsDisplayPanelShowTutorials)
    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsDisplayPanelResetTutorials)
    if private.isRetail then
        Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsDisplayPanelSelfHighlightDropDown)
    end
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsDisplayPanelDisplayDropDown)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsDisplayPanelChatBubblesDropDown)

    ------------
    -- Social --
    ------------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelProfanityFilter)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelSpamFilter)
    if private.isClassic then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelShowLootSpam)
    end
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelGuildMemberAlert)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelBlockTrades)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelBlockGuildInvites)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelBlockChatChannelInvites)
    if private.isRetail then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelShowAccountAchievments)
    end
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelOnlineFriends)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelOfflineFriends)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelBroadcasts)
    if private.isRetail then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsSocialPanelAutoAcceptQuickJoinRequests)
    end
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
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelStackRightBars)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelLockActionBars)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsActionBarsPanelPickupActionKeyDropDown)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelAlwaysShowActionBars)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsActionBarsPanelCountdownCooldowns)

    -----------
    -- Names --
    -----------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelMyName)
    if private.isRetail then
        Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsNamesPanelNPCNamesDropDown)
    else
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelNPCNames)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelTitles)
    end
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelNonCombatCreature)

    -- Friendly
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelFriendlyPlayerNames)
    Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelFriendlyMinions)

    -- Enemy
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelEnemyPlayerNames)
    Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelEnemyMinions)

    -- UnitNameplates
    if private.isRetail then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesPersonalResource)
        Skin.InterfaceOptionsSmallCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesPersonalResourceOnEnemy)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesMakeLarger)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsNamesPanelUnitNameplatesAggroFlash)
    end
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
    if private.isClassic then
        Skin.OptionsSliderTemplate(_G.InterfaceOptionsCameraPanelMaxDistanceSlider)
    end
    Skin.OptionsSliderTemplate(_G.InterfaceOptionsCameraPanelFollowSpeedSlider)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsCameraPanelStyleDropDown)
    if private.isClassic then
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCameraPanelFollowTerrain)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCameraPanelHeadBob)
        Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsCameraPanelSmartPivot)
    end

    -----------
    -- Mouse --
    -----------
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsMousePanelInvertMouse)
    Skin.OptionsSliderTemplate(_G.InterfaceOptionsMousePanelMouseLookSpeedSlider)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsMousePanelEnableMouseSpeed)
    Skin.OptionsSliderTemplate(_G.InterfaceOptionsMousePanelMouseSensitivitySlider)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsMousePanelLockCursorToScreen)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsMousePanelClickToMove)
    Skin.UIDropDownMenuTemplate(_G.InterfaceOptionsMousePanelClickMoveStyleDropDown)

    -------------------
    -- Accessibility --
    -------------------
    local Accessibility = _G.InterfaceOptionsAccessibilityPanel
    Skin.InterfaceOptionsCheckButtonTemplate(Accessibility.MovePad)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.InterfaceOptionsAccessibilityPanelCinematicSubtitles)
    if private.isPatch then
        Skin.InterfaceOptionsCheckButtonTemplate(Accessibility.OverrideFadeOut)
    end
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
