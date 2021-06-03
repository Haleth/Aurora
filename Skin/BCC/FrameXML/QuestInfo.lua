local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\QuestInfo.lua ]]
    local templates = {}
    function Hook.QuestInfo_Display(template, parentFrame, acceptButton, material, mapView)
        local headerR, headerG, headerB = 1, 1, 1
        local textR, textG, textB = 0.8, 0.8, 0.8

        -- headers
        _G.QuestInfoTitleHeader:SetTextColor(headerR, headerG, headerB)
        _G.QuestInfoDescriptionHeader:SetTextColor(headerR, headerG, headerB)
        _G.QuestInfoObjectivesHeader:SetTextColor(headerR, headerG, headerB)
        _G.QuestInfoRewardsFrame.Header:SetTextColor(headerR, headerG, headerB)

        -- other text
        _G.QuestInfoDescriptionText:SetTextColor(textR, textG, textB)
        _G.QuestInfoObjectivesText:SetTextColor(textR, textG, textB)
        _G.QuestInfoGroupSize:SetTextColor(textR, textG, textB)
        _G.QuestInfoRewardText:SetTextColor(textR, textG, textB)

        -- reward frame text
        local rewardsFrame = _G.QuestInfoFrame.rewardsFrame
        rewardsFrame.ItemChooseText:SetTextColor(textR, textG, textB)
        rewardsFrame.ItemReceiveText:SetTextColor(textR, textG, textB)
        rewardsFrame.PlayerTitleText:SetTextColor(textR, textG, textB)
        if not mapView then
            rewardsFrame.XPFrame.ReceiveText:SetTextColor(textR, textG, textB)
        end

        local templateElements = templates[template]
        for i = 1, #templateElements do
            templateElements[i](parentFrame)
        end
    end
    function Hook.QuestInfo_ShowObjectives()
        local numObjectives = _G.GetNumQuestLeaderBoards()
        local objectivesTable = _G.QuestInfoObjectivesFrame.Objectives

        local shownObjs = 0
        for i = #objectivesTable, 1, -1 do
            local objective = objectivesTable[i]
            if objective:IsShown() then
                shownObjs = shownObjs + 1
                if shownObjs > numObjectives then
                    objective:SetTextColor(1, 1, 1)
                else
                    local _, _, finished = _G.GetQuestLogLeaderBoard(i)
                    if finished then
                        objective:SetTextColor(0.6, 0.6, 0.6)
                    else
                        objective:SetTextColor(0.9, 0.9, 0.9)
                    end
                end
            end
        end
    end

    local rewardFrames = {}
    function Hook.QuestInfo_GetRewardButton(rewardsFrame, index)
        local numRewardButtons = rewardFrames[rewardsFrame] or 0

        while numRewardButtons < #rewardsFrame.RewardButtons do
            numRewardButtons = numRewardButtons + 1
            Skin[rewardsFrame.buttonTemplate](rewardsFrame.RewardButtons[numRewardButtons])
        end

        rewardFrames[rewardsFrame] = numRewardButtons
    end

    templates = {
        [_G.QUEST_TEMPLATE_DETAIL] = {
        },
        [_G.QUEST_TEMPLATE_LOG] = {
            Hook.QuestInfo_ShowObjectives,
        },
        [_G.QUEST_TEMPLATE_REWARD] = {
        },
        [_G.QUEST_TEMPLATE_MAP_DETAILS] = {
            Hook.QuestInfo_ShowObjectives,
        },
        [_G.QUEST_TEMPLATE_MAP_REWARDS] = {
        },
    }
end

do --[[ FrameXML\QuestInfo.xml ]]
    function Skin.SmallQuestRewardItemButtonTemplate(Button)
        Skin.SmallItemButtonTemplate(Button)
    end
    function Skin.LargeQuestRewardItemButtonTemplate(Button)
        Skin.LargeItemButtonTemplate(Button)
    end
    function Skin.QuestInfoSpellHeaderTemplate(FontString)
        FontString:SetTextColor(0.8, 0.8, 0.8)
    end
end

function private.FrameXML.QuestInfo()
    _G.hooksecurefunc("QuestInfo_Display", Hook.QuestInfo_Display)
    _G.hooksecurefunc("QuestInfo_GetRewardButton", Hook.QuestInfo_GetRewardButton)

    ------------------------------
    -- QuestInfoObjectivesFrame --
    ------------------------------
    _G.hooksecurefunc("QuestInfo_ShowObjectives", Hook.QuestInfo_ShowObjectives)

    -------------------------------------
    -- QuestInfoSpecialObjectivesFrame --
    -------------------------------------
    Skin.QuestSpellTemplate(_G.QuestInfoSpellObjectiveFrame)

    -------------------------
    -- QuestInfoTimerFrame --
    -------------------------

    ---------------------------------
    -- QuestInfoRequiredMoneyFrame --
    ---------------------------------

    ---------------------------
    -- QuestInfoRewardsFrame --
    ---------------------------
    local QuestInfoRewardsFrame = _G.QuestInfoRewardsFrame

    local TitleFrame = QuestInfoRewardsFrame.TitleFrame
    Base.CropIcon(TitleFrame.Icon)
    TitleFrame.FrameLeft:Hide()
    TitleFrame.FrameCenter:Hide()
    TitleFrame.FrameRight:Hide()

    local titleBG = _G.CreateFrame("Frame", nil, TitleFrame)
    titleBG:SetPoint("TOPLEFT", TitleFrame.FrameLeft, -2, 0)
    titleBG:SetPoint("BOTTOMRIGHT", TitleFrame.FrameRight, 0, -1)
    Base.SetBackdrop(titleBG, Color.frame)

    local ItemHighlight = QuestInfoRewardsFrame.ItemHighlight
    ItemHighlight:GetRegions():Hide()
    Base.SetBackdrop(ItemHighlight, Color.highlight, Color.frame.a)
    ItemHighlight:SetBackdropOption("offsets", {
        left = 7,
        right = 104,
        top = 6,
        bottom = 17,
    })

    Util.Mixin(QuestInfoRewardsFrame.spellRewardPool, Hook.ObjectPoolMixin)
    Util.Mixin(QuestInfoRewardsFrame.spellHeaderPool, Hook.ObjectPoolMixin)


    --------------------
    -- QuestInfoFrame --
    --------------------
end
