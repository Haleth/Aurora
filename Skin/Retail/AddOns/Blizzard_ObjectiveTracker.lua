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
        function Hook.ObjectiveTracker_Initialize(self)
            Util.Mixin(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE)
            Util.Mixin(_G.QUEST_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE)
            Util.Mixin(_G.BONUS_OBJECTIVE_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.BonusObjectiveTrackerModuleMixin)
            Util.Mixin(_G.WORLD_QUEST_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.BonusObjectiveTrackerModuleMixin)
            Util.Mixin(_G.SCENARIO_TRACKER_MODULE, Hook.DEFAULT_OBJECTIVE_TRACKER_MODULE, Hook.SCENARIO_TRACKER_MODULE)
        end

        Hook.ObjectiveTrackerMinimizeButtonMixin = {}
        function Hook.ObjectiveTrackerMinimizeButtonMixin:SetCollapsed(collapsed)
            if collapsed then
                Base.SetTexture(self._auroraArrow, "arrowDown")
            else
                Base.SetTexture(self._auroraArrow, "arrowUp")
            end

            self:SetNormalTexture("")
            self:SetPushedTexture("")
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

        -- /dump Aurora.Color.blue:Hue(-0.333):GetRGB()
        local uiTextureKits = {
            Default = {color = Color.button, texture = ""},
            alliance = {color = private.FACTION_COLORS.Alliance, texture = [[Interface\Timer\Alliance-Logo]]},
            horde = {color = private.FACTION_COLORS.Horde, texture = [[Interface\Timer\Horde-Logo]]},
            legion = {color = Color.green:Lightness(-0.3), texture = ""},
        }

        function Hook.ScenarioStage_CustomizeBlock(stageBlock, scenarioType, widgetSetID, textureKit)
            -- /dump GetUITextureKitInfo(5117)
            private.debug("ScenarioStage_CustomizeBlock", scenarioType, widgetSetID, textureKit)

            if widgetSetID then
                stageBlock._auroraOverlay:Hide()
            else
                stageBlock._auroraOverlay:Show()

                local kit
                if textureKit then
                    kit = uiTextureKits[textureKit]
                elseif scenarioType == _G.LE_SCENARIO_TYPE_LEGION_INVASION then
                    kit = uiTextureKits.legion
                end

                if not kit then
                    kit = uiTextureKits.Default
                    private.debug("missing scenario block", textureKit)
                end

                Base.SetBackdropColor(stageBlock._auroraBG, kit.color, 0.75)
                stageBlock._auroraOverlay:SetTexture(kit.texture)
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
        Base.SetHighlight(Button)

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetDisabledTexture("")
        Button:SetHighlightTexture("")
    end

    ----====####$$$$$$$####====----
    -- Blizzard_ObjectiveTracker --
    ----====####$$$$$$$####====----
    Skin.ObjectiveTrackerBlockTemplate = private.nop
    function Skin.ObjectiveTrackerMinimizeButtonTemplate(Button)
        Util.Mixin(Button, Hook.ObjectiveTrackerMinimizeButtonMixin)

        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 1,
            right = 2,
            top = 2,
            bottom = 1,
        })

        local bg = Button:GetBackdropTexture("bg")
        local arrow = Button:CreateTexture(nil, "OVERLAY")
        arrow:SetPoint("TOPLEFT", bg, 2, -4)
        arrow:SetSize(9, 4.5)
        Button._auroraArrow = arrow
        Button._auroraTextures = {arrow}

        Hook.ObjectiveTrackerMinimizeButtonMixin.SetCollapsed(Button, false)
    end
    function Skin.ObjectiveTrackerHeaderTemplate(Frame)
        Frame.Background:Hide()

        local bg = Frame:CreateTexture(nil, "ARTWORK")
        bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
        bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
        bg:SetVertexColor(Color.highlight.r * 0.7, Color.highlight.g * 0.7, Color.highlight.b * 0.7)
        bg:SetPoint("BOTTOMLEFT", -30, -4)
        bg:SetSize(210, 30)

        Skin.ObjectiveTrackerMinimizeButtonTemplate(Frame.MinimizeButton)
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
    function Skin.AutoQuestPopUpBlockTemplate(ScrollFrame)
        local ScrollChild = ScrollFrame.ScrollChild
        Base.CreateBackdrop(ScrollChild, private.backdrop, {
            tl = ScrollChild.BorderTopLeft,
            tr = ScrollChild.BorderTopRight,
            bl = ScrollChild.BorderBotLeft,
            br = ScrollChild.BorderBotRight,

            t = ScrollChild.BorderTop,
            b = ScrollChild.BorderBottom,
            l = ScrollChild.BorderLeft,
            r = ScrollChild.BorderRight,

            bg = ScrollChild.Bg
        })

        Skin.FrameTypeFrame(ScrollChild)
        ScrollChild:SetBackdropBorderColor(Color.yellow:GetRGB())
        ScrollChild:SetBackdropOption("offsets", {
            left = 35,
            right = -1,
            top = 3,
            bottom = 3
        })
    end

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

    Skin.ObjectiveTrackerHeaderTemplate(_G.ObjectiveTrackerFrame.BlocksFrame.CampaignQuestHeader)
    for _, headerName in next, {"QuestHeader", "AchievementHeader", "ScenarioHeader", "UIWidgetsHeader"} do
        Skin.ObjectiveTrackerHeaderTemplate(_G.ObjectiveTrackerFrame.BlocksFrame[headerName])
    end

    Skin.ObjectiveTrackerMinimizeButtonTemplate(_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton)

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
    local _, _, _, _, _, bonusObj, worldQuests = _G.ObjectiveTrackerFrame.BlocksFrame:GetChildren()
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
    Skin.FrameTypeFrame(ScenarioChallengeModeBlock)

    ScenarioChallengeModeBlock.TimerBGBack:Hide()
    ScenarioChallengeModeBlock.TimerBG:Hide()

    Skin.FrameTypeStatusBar(ScenarioChallengeModeBlock.StatusBar)
    ScenarioChallengeModeBlock.StatusBar:SetStatusBarColor(Color.cyan:GetRGB())

    -- ScenarioProvingGroundsBlock


    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_ObjectiveTrackerUIWidgetContainer --
    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----
end
