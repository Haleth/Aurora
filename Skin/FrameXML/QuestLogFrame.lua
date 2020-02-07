local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\QuestLogFrame.lua ]]
    function Hook.QuestLog_Update(Button)
        local numEntries = _G.GetNumQuestLogEntries()
        local questIndex, questLogTitle, isHeader, _

        for i = 1, _G.QUESTS_DISPLAYED do
            questIndex = i + _G.FauxScrollFrame_GetOffset(_G.QuestLogListScrollFrame)
            questLogTitle = _G["QuestLogTitle"..i]
            if questIndex <= numEntries then
                _, _, _, isHeader = _G.GetQuestLogTitle(questIndex)
                if isHeader then
                    questLogTitle._minus:Show()
                    questLogTitle:GetHighlightTexture():SetTexture("")
                else
                    questLogTitle._minus:Hide()
                    questLogTitle._plus:Hide()
                end
            end
        end
    end
    function Hook.QuestLog_UpdateQuestDetails(Button)
        local numObjectives = _G.GetNumQuestLeaderBoards()
        for i=1, numObjectives do
            local objective = _G["QuestLogObjective"..i];
            local _, _, isFinished = _G.GetQuestLogLeaderBoard(i)
            if isFinished then
                objective:SetTextColor(Color.gray:GetRGB());
            else
                objective:SetTextColor(Color.white:GetRGB());
            end
        end
    end
end

do --[[ FrameXML\QuestLogFrame.xml ]]
    function Skin.QuestLogTitleButtonTemplate(Button)
        Skin.ExpandOrCollapse(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 284,
            top = 0,
            bottom = 3,
        })
    end
end

function private.FrameXML.QuestLogFrame()
    _G.hooksecurefunc("QuestLog_Update", Hook.QuestLog_Update)
    _G.hooksecurefunc("QuestLog_UpdateQuestDetails", Hook.QuestLog_UpdateQuestDetails)

    local QuestLogFrame = _G.QuestLogFrame
    Base.SetBackdrop(QuestLogFrame)
    QuestLogFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local _, portrait, TopLeft, TopRight, BotLeft, BotRight = QuestLogFrame:GetRegions()
    portrait:Hide()
    TopLeft:Hide()
    TopRight:Hide()
    BotLeft:Hide()
    BotRight:Hide()

    local bg = QuestLogFrame:GetBackdropTexture("bg")
    _G.QuestLogTitleText:ClearAllPoints()
    _G.QuestLogTitleText:SetPoint("TOPLEFT", bg)
    _G.QuestLogTitleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    _G.QuestLogCountRight:Hide()
    _G.QuestLogCountMiddle:Hide()
    _G.QuestLogCountLeft:Hide()

    _G.QuestLogExpandButtonFrame:SetPoint("TOPLEFT", 20, -48)
    Skin.QuestLogTitleButtonTemplate(_G.QuestLogCollapseAllButton)
    _G.QuestLogCollapseAllButton:SetBackdropOption("offsets", {
        left = 3,
        right = 24,
        top = 4,
        bottom = 5,
    })
    local left, middle, right = select(7, _G.QuestLogCollapseAllButton:GetRegions())
    left:SetAlpha(0)
    middle:SetAlpha(0)
    right:SetAlpha(0)


    TopLeft, TopRight, BotLeft, BotRight = _G.EmptyQuestLogFrame:GetRegions()
    portrait:Hide()
    TopLeft:Hide()
    TopRight:Hide()
    BotLeft:Hide()
    BotRight:Hide()

    Skin.UIPanelCloseButton(_G.QuestLogFrameCloseButton)
    Skin.UIPanelButtonTemplate(_G.QuestLogFrameAbandonButton)
    _G.QuestLogFrameAbandonButton:SetPoint("BOTTOMLEFT", bg, 5, 5)
    Skin.UIPanelButtonTemplate(_G.QuestFrameExitButton)
    _G.QuestFrameExitButton:SetPoint("BOTTOMRIGHT", bg, -5, 5)
    Skin.UIPanelButtonTemplate(_G.QuestFramePushQuestButton)
    _G.QuestFramePushQuestButton:SetPoint("LEFT", _G.QuestLogFrameAbandonButton, "RIGHT", 1, 0)
    _G.QuestFramePushQuestButton:SetPoint("RIGHT", _G.QuestFrameExitButton, "LEFT", -1, 0)

    _G.QuestLogSkillHighlight:SetColorTexture(1, 1, 1, 0.5)

    for i=1, _G.QUESTS_DISPLAYED do
        Skin.QuestLogTitleButtonTemplate(_G["QuestLogTitle"..i])
    end

    Skin.FauxScrollFrameTemplate(_G.QuestLogListScrollFrame)
    Skin.UIPanelScrollFrameTemplate(_G.QuestLogDetailScrollFrame)
    _G.QuestLogDetailScrollFrame:SetPoint("BOTTOMRIGHT", bg, -30, 30)
end
