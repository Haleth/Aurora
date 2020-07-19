local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_ObjectiveTracker.lua ]]
    do --[[ Blizzard_ObjectiveTrackerShared.lua ]]
        function Hook.QuestObjectiveItem_Initialize(itemButton, questLogIndex)
            if not itemButton._auroraSkinned then
                Skin.QuestObjectiveItemButtonTemplate(itemButton)
                itemButton._auroraSkinned = true
            end
        end
        function Hook.QuestObjectiveSetupBlockButton_AddRightButton(block, button, initialAnchorOffsets)
            if not button._auroraSkinned then
                Skin.QuestObjectiveFindGroupButtonTemplate(button)
                button._auroraSkinned = true
            end
        end
    end

    do --[[ Blizzard_ObjectiveTracker.lua ]]
        Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE = {}
        function Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE:AddObjective(block, objectiveKey, text, lineType, useFullHeight, dashStyle, colorStyle, adjustForNoText, overrideHeight)
            local line = block.lines[objectiveKey]
            if not line._auroraSkinned then
                local template = lineType and lineType.template or self.lineTemplate
                if Skin[template] then
                    Skin[template](line)
                    line._auroraSkinned = true
                else
                    private.debug("DEFAULT_OBJECTIVE_TRACKER_MODULE_AddObjective:", template, "does not exist.")
                    line._auroraSkinned = template
                end
            end
        end
        function Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE:AddTimerBar(block, line, duration, startTime)
            local timerBar = line.TimerBar
            if not timerBar._auroraSkinned then
                Skin.ObjectiveTrackerTimerBarTemplate(timerBar)
                timerBar._auroraSkinned = true
            end
        end
        function Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE:AddProgressBar(block, line, questID)
            local progressBar = line.ProgressBar
            if not progressBar._auroraSkinned then
                Skin.ObjectiveTrackerProgressBarTemplate(progressBar)
                progressBar._auroraSkinned = true
            end
        end
        function Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE:GetBlock(id)
            local block = self.usedBlocks[id]
            if not block._auroraSkinned then
                if Skin[self.blockTemplate] then
                    Skin[self.blockTemplate](block)
                    block._auroraSkinned = true
                else
                    private.debug("DEFAULT_OBJECTIVE_TRACKER_MODULE_GetBlock:", self.blockTemplate, "does not exist.")
                end
            end
        end
        function Hook.ObjectiveTracker_Initialize(self)
            Util.Mixin(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE)
            Util.Mixin(_G.QUEST_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.QUEST_TRACKER_MODULE)
            Util.Mixin(_G.BONUS_OBJECTIVE_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.BonusObjectiveTrackerModuleMixin)
            Util.Mixin(_G.WORLD_QUEST_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.BonusObjectiveTrackerModuleMixin)
            Util.Mixin(_G.SCENARIO_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.SCENARIO_TRACKER_MODULE)
            Util.Mixin(_G.AUTO_QUEST_POPUP_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.AUTO_QUEST_POPUP_TRACKER_MODULE)
        end
        function Hook.ObjectiveTracker_Collapse()
            local minimizeButton = _G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
            local bg = minimizeButton:GetBackdropTexture("bg")

            minimizeButton._auroraLine:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 2, 3)
            minimizeButton._auroraArrow:SetPoint("TOPLEFT", bg, 2, -2)
            Base.SetTexture(minimizeButton._auroraArrow, "arrowDown")
        end
        function Hook.ObjectiveTracker_Expand()
            local minimizeButton = _G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
            local bg = minimizeButton:GetBackdropTexture("bg")

            minimizeButton._auroraLine:SetPoint("TOPLEFT", bg, 2, -2)
            minimizeButton._auroraArrow:SetPoint("TOPLEFT", bg, 2.4, -6)
            Base.SetTexture(minimizeButton._auroraArrow, "arrowUp")
        end
    end

    do --[[ Blizzard_QuestObjectiveTracker.lua ]]
        local coords = _G.UnitFactionGroup("player") == "Horde" and _G.QUEST_TAG_TCOORDS.HORDE or _G.QUEST_TAG_TCOORDS.ALLIANCE
        local factionIcon = _G.CreateTextureMarkup(_G.QUEST_ICONS_FILE, _G.QUEST_ICONS_FILE_WIDTH, _G.QUEST_ICONS_FILE_HEIGHT, 16, 16,
                coords[1], coords[2], coords[3], coords[4], 0, 2)

        Hook.QUEST_TRACKER_MODULE = {}
        function Hook.QUEST_TRACKER_MODULE:SetBlockHeader(block, text, questLogIndex, isQuestComplete, questID)
            if _G.C_CampaignInfo.IsCampaignQuest(questID) then
                text = text..factionIcon
                block.HeaderText:SetText(text)
            end
        end
    end

    do --[[ Blizzard_AutoQuestPopUpTracker.lua ]]
        Hook.AUTO_QUEST_POPUP_TRACKER_MODULE = {}
        function Hook.AUTO_QUEST_POPUP_TRACKER_MODULE:Update()
            for _, block in next, self.usedBlocks do
                if not block._auroraSkinned then
                    Skin.AutoQuestPopUpBlockTemplate(block)
                    block._auroraSkinned = true
                end
            end
        end
    end

    do --[[ Blizzard_BonusObjectiveTracker.lua ]]
        Hook.BonusObjectiveTrackerModuleMixin = {}
        function Hook.BonusObjectiveTrackerModuleMixin:AddProgressBar(block, line, questID)
            local progressBar = line.ProgressBar
            if not progressBar._auroraSkinned then
                Skin.BonusTrackerProgressBarTemplate(progressBar)
                progressBar._auroraSkinned = true
            end
        end
    end

    do --[[ Blizzard_ScenarioObjectiveTracker.lua ]]
        Hook.SCENARIO_TRACKER_MODULE = {}
        function Hook.SCENARIO_TRACKER_MODULE:AddProgressBar(block, line, criteriaIndex)
            local progressBar = line.ProgressBar
            if not progressBar._auroraSkinned then
                Skin.ScenarioTrackerProgressBarTemplate(progressBar)
                progressBar._auroraSkinned = true
            end
        end
        Hook.SCENARIO_TRACKER_MODULE.GetBlock = private.nop

        -- /dump Aurora.Color.blue:Hue(-0.333):GetRGB()
        local uiTextureKits = {
            [0] = {color = Color.button, overlay = ""},
            [261] = {color = Color.blue:Lightness(-0.3), overlay = [[Interface\Timer\Alliance-Logo]]},
            [5117] = {color = Color.red:Lightness(-0.3), overlay = [[Interface\Timer\Horde-Logo]]},
            ["legion"] = {color = Color.green:Lightness(-0.3), overlay = ""},
        }
        function Hook.ScenarioStage_CustomizeBlock(stageBlock, scenarioType, widgetSetID, textureKitID)
            -- /dump GetUITextureKitInfo(5117)
            private.debug("ScenarioStage_CustomizeBlock", scenarioType, widgetSetID, textureKitID)

            if widgetSetID then
                stageBlock._auroraOverlay:Hide()
            else
                stageBlock._auroraOverlay:Show()

                local kit
                if textureKitID then
                    kit = uiTextureKits[textureKitID] or uiTextureKits[0]
                elseif scenarioType == _G.LE_SCENARIO_TYPE_LEGION_INVASION then
                    kit = uiTextureKits["legion"]
                else
                    kit = uiTextureKits[0]
                end

                Base.SetBackdropColor(stageBlock._auroraBG, kit.color, 0.75)
                stageBlock._auroraOverlay:SetTexture(kit.overlay)
            end
        end
    end
end

do --[[ AddOns\Blizzard_ObjectiveTracker.xml ]]
    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_ObjectiveTrackerShared --
    ----====####$$$$%%%%%$$$$####====----
    function Skin.QuestObjectiveItemButtonTemplate(Button)
        Base.CropIcon(Button.icon, Button)
        Button:SetNormalTexture("")
        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
    function Skin.QuestObjectiveFindGroupButtonTemplate(Button)
        local bdFrame = _G.CreateFrame("Frame", nil, Button)
        bdFrame:SetPoint("TOPLEFT", 4, -4)
        bdFrame:SetPoint("BOTTOMRIGHT", -4, 4)
        bdFrame:SetFrameLevel(Button:GetFrameLevel())
        Base.SetBackdrop(bdFrame, Color.button)

        Button._auroraBDFrame = bdFrame
        Base.SetHighlight(Button, "backdrop")

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetDisabledTexture("")
        Button:SetHighlightTexture("")
    end

    ----====####$$$$$$$####====----
    -- Blizzard_ObjectiveTracker --
    ----====####$$$$$$$####====----
    Skin.ObjectiveTrackerBlockTemplate = private.nop
    function Skin.ObjectiveTrackerHeaderTemplate(Frame)
        Frame.Background:Hide()

        local bg = Frame:CreateTexture(nil, "ARTWORK")
        bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
        bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
        bg:SetVertexColor(Color.highlight.r * 0.7, Color.highlight.g * 0.7, Color.highlight.b * 0.7)
        bg:SetPoint("BOTTOMLEFT", -30, -4)
        bg:SetSize(210, 30)
    end
    Skin.ObjectiveTrackerLineTemplate = private.nop
    Skin.ObjectiveTrackerCheckLineTemplate = private.nop
    function Skin.ObjectiveTrackerTimerBarTemplate(Frame)
        Skin.FrameTypeStatusBar(Frame.Bar)

        local left, right, mid, bg = Frame.Bar:GetRegions()
        left:Hide()
        right:Hide()
        mid:Hide()
        bg:Hide()
    end
    function Skin.ObjectiveTrackerProgressBarTemplate(Frame)
        Skin.FrameTypeStatusBar(Frame.Bar)

        local left, right, mid, _, bg = Frame.Bar:GetRegions()
        left:Hide()
        right:Hide()
        mid:Hide()
        bg:Hide()
    end

    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_QuestObjectiveTracker --
    ----====####$$$$%%%%$$$$####====----
    function Skin.QuestObjectiveAnimLineTemplate(Frame)
        Skin.ObjectiveTrackerLineTemplate(Frame)
        Frame.Check:SetAtlas("worldquest-tracker-checkmark")
        Frame.Check:SetSize(18, 16)
    end

    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_AutoQuestPopUpTracker --
    ----====####$$$$%%%%$$$$####====----
    Skin.AutoQuestPopUpBlockTemplate = private.nop

    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_BonusObjectiveTracker --
    ----====####$$$$%%%%$$$$####====----
    function Skin.BonusObjectiveTrackerLineTemplate(Frame)
        Skin.ObjectiveTrackerCheckLineTemplate(Frame)
    end
    Skin.BonusObjectiveTrackerBlockTemplate = private.nop
    function Skin.BonusObjectiveTrackerHeaderTemplate(Frame)
        Skin.ObjectiveTrackerHeaderTemplate(Frame)
    end
    function Skin.BonusTrackerProgressBarTemplate(Frame)
        local bar = Frame.Bar
        bar:ClearAllPoints()
        bar:SetPoint("TOPLEFT", 10, -10)
        Skin.FrameTypeStatusBar(bar)

        bar.BarFrame:Hide()
        bar.IconBG:SetAlpha(0)
        bar.BarBG:Hide()
        bar.Icon:SetMask(nil)
        bar.Icon:SetSize(26, 26)
        bar.Icon:SetPoint("RIGHT", 33, 0)
        Base.CropIcon(bar.Icon, bar)
    end

    ----====####$$$$%%%%%%%$$$$####====----
    -- Blizzard_ScenarioObjectiveTracker --
    ----====####$$$$%%%%%%%$$$$####====----
    function Skin.ScenarioTrackerProgressBarTemplate(Frame)
        local bar = Frame.Bar
        Skin.FrameTypeStatusBar(bar)

        bar.BarFrame:Hide()
        bar.IconBG:SetColorTexture(0, 0, 0)
        bar.BarBG:Hide()
        bar.Icon:SetMask(nil)
        bar.Icon:SetSize(26, 26)
        bar.Icon:SetPoint("RIGHT", 33, 0)
        Base.CropIcon(bar.Icon)
    end
end

function private.AddOns.Blizzard_ObjectiveTracker()
    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_ObjectiveTrackerShared --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("QuestObjectiveItem_Initialize", Hook.QuestObjectiveItem_Initialize)
    _G.hooksecurefunc("QuestObjectiveSetupBlockButton_AddRightButton", Hook.QuestObjectiveSetupBlockButton_AddRightButton)

    ----====####$$$$$$$####====----
    -- Blizzard_ObjectiveTracker --
    ----====####$$$$$$$####====----
    _G.hooksecurefunc("ObjectiveTracker_Initialize", Hook.ObjectiveTracker_Initialize)
    _G.hooksecurefunc("ObjectiveTracker_Collapse", Hook.ObjectiveTracker_Collapse)
    _G.hooksecurefunc("ObjectiveTracker_Expand", Hook.ObjectiveTracker_Expand)

    do -- MinimizeButton
        local Button = _G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 1,
            right = 2,
            top = 2,
            bottom = 1,
        })

        local line = Button:CreateTexture(nil, "OVERLAY")
        line:SetColorTexture(1, 1, 1)
        line:SetSize(9, 1)
        Button._auroraLine = line

        local arrow = Button:CreateTexture(nil, "OVERLAY")
        arrow:SetSize(9, 4.5)
        Button._auroraArrow = arrow

        Button._auroraTextures = {line, arrow}
        if _G.ObjectiveTrackerFrame.collapsed then
            Hook.ObjectiveTracker_Collapse()
        else
            Hook.ObjectiveTracker_Expand()
        end
    end

    for _, headerName in next, {"QuestHeader", "AchievementHeader", "ScenarioHeader", "UIWidgetsHeader"} do
        Skin.ObjectiveTrackerHeaderTemplate(_G.ObjectiveTrackerFrame.BlocksFrame[headerName])
    end

    ----====####$$$$%$$$$####====----
    -- Blizzard_QuestSuperTracking --
    ----====####$$$$%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_QuestObjectiveTracker --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%%%%%%$$$$####====----
    -- Blizzard_AchievementObjectiveTracker --
    ----====####$$$$%%%%%%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_AutoQuestPopUpTracker --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_BonusObjectiveTracker --
    ----====####$$$$%%%%$$$$####====----
    local _, _, _, _, bonusObj, worldQuests = _G.ObjectiveTrackerFrame.BlocksFrame:GetChildren()
    Skin.BonusObjectiveTrackerHeaderTemplate(bonusObj)
    Skin.BonusObjectiveTrackerHeaderTemplate(worldQuests)

    ----====####$$$$%%%%%%%$$$$####====----
    -- Blizzard_ScenarioObjectiveTracker --
    ----====####$$$$%%%%%%%$$$$####====----
    _G.hooksecurefunc("ScenarioStage_CustomizeBlock", Hook.ScenarioStage_CustomizeBlock)


    -- ScenarioObjectiveBlock
    -- ScenarioStageBlock
    local ScenarioStageBlock = _G.ScenarioStageBlock
    ScenarioStageBlock.NormalBG:Hide()
    local ssbBD = _G.CreateFrame("Frame", nil, ScenarioStageBlock)
    ssbBD:SetFrameLevel(ScenarioStageBlock:GetFrameLevel())
    ssbBD:SetAllPoints(ScenarioStageBlock.NormalBG)
    ssbBD:SetClipsChildren(true)
    ssbBD:SetPoint("TOPLEFT", ScenarioStageBlock.NormalBG, 3, -3)
    ssbBD:SetPoint("BOTTOMRIGHT", ScenarioStageBlock.NormalBG, -3, 3)
    Base.SetBackdrop(ssbBD, Color.button, 0.75)
    ScenarioStageBlock._auroraBG = ssbBD

    local overlay = ssbBD:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(120, 120)
    overlay:SetPoint("TOPRIGHT", 23, 20)
    overlay:SetAlpha(0.2)
    overlay:SetDesaturated(true)
    ScenarioStageBlock._auroraOverlay = overlay

    -- ScenarioChallengeModeBlock
    local ScenarioChallengeModeBlock = _G.ScenarioChallengeModeBlock
    local bg = select(3, ScenarioChallengeModeBlock:GetRegions())
    bg:Hide()
    Base.SetBackdrop(ScenarioChallengeModeBlock)

    ScenarioChallengeModeBlock.TimerBGBack:Hide()
    ScenarioChallengeModeBlock.TimerBG:Hide()

    Skin.FrameTypeStatusBar(ScenarioChallengeModeBlock.StatusBar)
    ScenarioChallengeModeBlock.StatusBar:SetStatusBarColor(Color.cyan:GetRGB())

    -- ScenarioProvingGroundsBlock
    if not private.isPatch then
        Skin.GlowBoxFrame(_G.ScenarioBlocksFrame.WarfrontHelpBox, "Right")
    end


    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_ObjectiveTrackerUIWidgetContainer --
    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----
end
