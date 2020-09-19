local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_IslandsQueueUI.lua ]]
    Hook.IslandsQueueWeeklyQuestMixin = {}
    function Hook.IslandsQueueWeeklyQuestMixin:SetElementsEnabled(enabled)
        if enabled then
            self.StatusBar:SetStatusBarAtlas("_islands-queue-progressbar-fill")
        end
    end
end

do --[[ AddOns\Blizzard_IslandsQueueUI.xml ]]
    function Skin.IslandsQueueFrameTutorialTemplate(Frame)
        Base.SetBackdrop(Frame)
        local bg = Frame:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 290, -135)
        bg:SetPoint("BOTTOMRIGHT", -290, 135)

        Frame.BlackBackground:SetAllPoints(_G.IslandsQueueFrame)

        Frame.Background:SetTexture([[Interface\Icons\INV_Glowing Azerite Spire]])
        Frame.Background:SetSize(64, 64)
        Frame.Background:ClearAllPoints()
        Frame.Background:SetPoint("TOP", bg, "TOP", -1, 5)
        local iconBG = Base.CropIcon(Frame.Background, Frame)
        iconBG:SetColorTexture(Color.yellow:GetRGB())
        Frame.TutorialText:SetTextColor(Color.grayLight:GetRGB())

        Skin.UIPanelButtonNoTooltipTemplate(Frame.Leave)
        Frame.Leave:SetPoint("BOTTOM", bg, "BOTTOM", 0, 35)
        Skin.UIPanelCloseButton(Frame.CloseButton)
        Frame.CloseButton:SetPoint("TOPRIGHT", bg, "TOPRIGHT", 3, 3)
    end
    function Skin.IslandsQueueFrameWeeklyQuestFrameTemplate(Frame)
        Util.Mixin(Frame, Hook.IslandsQueueWeeklyQuestMixin)
        Skin.FrameTypeStatusBar(Frame.StatusBar)

        local OverlayFrame = Frame.OverlayFrame
        OverlayFrame.FillBackground:Hide()
        OverlayFrame.Bar:Hide()
        OverlayFrame.Spark:SetAlpha(0)


        local QuestReward = Frame.QuestReward
        Base.CropIcon(QuestReward.Icon, QuestReward)

        Base.SetBackdrop(QuestReward.Tooltip)
        Skin.InternalEmbeddedItemTooltipTemplate(QuestReward.Tooltip.ItemTooltip)
    end
    function Skin.IslandsQueueFrameDifficultyButtonTemplate(Button)
    end
    function Skin.IslandsQueueScreenDifficultySelector(Frame)
        Frame.Background:Hide()
        Skin.UIPanelButtonNoTooltipTemplate(Frame.QueueButton)
    end
    function Skin.IslandsQueueFrameIslandCardTemplate(Frame)
    end
    function Skin.IslandsQueueFrameCardFrameTemplate(Frame)
        Skin.IslandsQueueFrameIslandCardTemplate(Frame.CenterCard)
        Skin.IslandsQueueFrameIslandCardTemplate(Frame.LeftCard)
        Skin.IslandsQueueFrameIslandCardTemplate(Frame.RightCard)
    end
end

function private.AddOns.Blizzard_IslandsQueueUI()
    local IslandsQueueFrame = _G.IslandsQueueFrame
    Skin.PortraitFrameTemplate(IslandsQueueFrame)

    IslandsQueueFrame.TopWoodBorder:Hide()
    IslandsQueueFrame.BottomWoodBorder:Hide()
    IslandsQueueFrame.LeftWoodBorder:Hide()
    IslandsQueueFrame.RightWoodBorder:Hide()

    IslandsQueueFrame.TopLeftWoodCorner:Hide()
    IslandsQueueFrame.TopRightWoodCorner:Hide()
    IslandsQueueFrame.BottomLeftWoodCorner:Hide()
    IslandsQueueFrame.BottomRightWoodCorner:Hide()

    local queueBG = select(14, IslandsQueueFrame:GetRegions())
    queueBG:SetAllPoints()
    queueBG:SetAlpha(0.5)

    IslandsQueueFrame.TitleBanner.Banner:Hide()
    IslandsQueueFrame.TitleBanner.TitleText:SetAllPoints(IslandsQueueFrame.TitleText)

    Skin.IslandsQueueFrameCardFrameTemplate(IslandsQueueFrame.IslandCardsFrame)
    Skin.IslandsQueueScreenDifficultySelector(IslandsQueueFrame.DifficultySelectorFrame)
    IslandsQueueFrame.DifficultySelectorFrame:SetPoint("BOTTOM", 0, -10)
    Skin.IslandsQueueFrameWeeklyQuestFrameTemplate(IslandsQueueFrame.WeeklyQuest)
    Skin.IslandsQueueFrameTutorialTemplate(IslandsQueueFrame.TutorialFrame)

    IslandsQueueFrame.ArtOverlayFrame.portrait:Hide()
    IslandsQueueFrame.ArtOverlayFrame.PortraitFrame:Hide()

    Skin.MainHelpPlateButton(IslandsQueueFrame.HelpButton)
    IslandsQueueFrame.HelpButton:SetPoint("TOPLEFT", -15, 15)
end
