local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

local F = _G.unpack(Aurora)

do --[[ AddOns\Blizzard_QuestChoice.xml ]]
    function Skin.QuestChoiceItemTemplate(Button)
        Button._auroraIconBorder = F.ReskinIcon(Button.Icon)
        Button.Name:SetTextColor(1, 1, 1)

        --[[ Scale ]]--
        Button:SetSize(167, 41)
        Button.Icon:SetSize(37, 37)
        Button.Name:ClearAllPoints()
        Button.Name:SetPoint("TOPLEFT", Button.Icon, "TOPRIGHT", 5, 0)
        Button.Name:SetPoint("BOTTOM", Button.Icon, 0, 0)
        Button.Name:SetPoint("RIGHT", -5, 0)
    end
    function Skin.QuestChoiceCurrencyTemplate(Frame)
        Base.CropIcon(Frame.Icon, Frame)
    end
    function Skin.QuestChoiceRewardsTemplate(Frame)
        Skin.QuestChoiceItemTemplate(Frame.Item)

        Skin.QuestChoiceCurrencyTemplate(Frame.Currencies.Currency1)
        Skin.QuestChoiceCurrencyTemplate(Frame.Currencies.Currency2)
        Skin.QuestChoiceCurrencyTemplate(Frame.Currencies.Currency3)

        --[[ Scale ]]--
        Frame:SetSize(210, 10)
        Frame.Item:SetPoint("TOPLEFT", 30, -5)
        Frame._auroraNoSetHeight = true
    end

    function Skin.QuestChoiceOptionTemplate(Button)
        Button.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
        Button.Artwork:ClearAllPoints()
        Button.Artwork:SetPoint("TOPLEFT", 13, -29)
        Button.Artwork:SetPoint("BOTTOMRIGHT", Button, "TOPRIGHT", -17, -100)

        if private.isPatch then
            Skin.UIPanelButtonTemplate(Button.OptionButtonsContainer.Buttons[1])
            Skin.UIPanelButtonTemplate(Button.OptionButtonsContainer.Buttons[2])
        else
            Skin.UIPanelButtonTemplate(Button.OptionButton)
        end
        Skin.QuestChoiceRewardsTemplate(Button.Rewards)

        Button.Header.Background:Hide()
        Button.Header.Text:SetTextColor(Color.grayLight:GetRGB())
        Button.OptionText:SetTextColor(Color.grayLight:GetRGB())
        Button.OptionText:SetPoint("TOP", Button.Artwork, "BOTTOM", 0, -30)

        --[[ Scale ]]--
        Button:SetSize(210, 268)
        if private.isPatch then
            Button.Rewards:SetPoint("BOTTOM", Button.OptionButtonsContainer, "TOP", 0, 5)
        else
            Button.Rewards:SetPoint("BOTTOM", Button.OptionButton, "TOP", 0, 5)
        end
        Button.Header:SetSize(256, 32)
        Button.Header:SetPoint("TOP", 10)
        Button.Header.Text:SetWidth(180)
        Button.Header.Text:SetPoint("TOPLEFT", 28, 2)
        Button.Header.Text:SetPoint("BOTTOMRIGHT", -28, 2)
        Button.OptionText:SetWidth(200)
        Button.OptionText:SetPoint("BOTTOM", Button.Rewards, "TOP", 0, 35)
        Button.OptionText:SetText("Text")
    end
end

--/dump QuestChoiceFrame.Option1.OptionText:GetContentHeight()
function private.AddOns.Blizzard_QuestChoice()
    local QuestChoiceFrame = _G.QuestChoiceFrame
    QuestChoiceFrame.topPadding = 100
    Skin.HorizontalLayoutFrame(QuestChoiceFrame)

    QuestChoiceFrame.BottomLeftCorner:Hide()
    QuestChoiceFrame.BottomRightCorner:Hide()
    QuestChoiceFrame.TopLeftCorner:Hide()
    QuestChoiceFrame.TopRightCorner:Hide()

    QuestChoiceFrame.BottomBorder:Hide()
    QuestChoiceFrame.TopBorder:Hide()
    QuestChoiceFrame.LeftBorder:Hide()
    QuestChoiceFrame.RightBorder:Hide()

    QuestChoiceFrame.LeftHide:Hide()
    QuestChoiceFrame.LeftHide2:Hide()
    QuestChoiceFrame.RightHide:Hide()
    QuestChoiceFrame.RightHide2:Hide()
    QuestChoiceFrame.BottomHide:Hide()
    QuestChoiceFrame.BottomHide2:Hide()

    QuestChoiceFrame.BG:Hide()

    QuestChoiceFrame.QuestionFrameRight:Hide()
    QuestChoiceFrame.QuestionFrameLeft:Hide()
    QuestChoiceFrame.QuestionFrameMiddle:Hide()

    QuestChoiceFrame.QuestionText:ClearAllPoints()
    QuestChoiceFrame.QuestionText:SetPoint("TOPLEFT", 20, -20)
    QuestChoiceFrame.QuestionText:SetPoint("BOTTOMRIGHT", QuestChoiceFrame, "TOPRIGHT", -20, -80)

    Base.SetBackdrop(QuestChoiceFrame)

    for i = 1, #QuestChoiceFrame.Options do
        Skin.QuestChoiceOptionTemplate(QuestChoiceFrame["Option"..i])
    end

    Skin.UIPanelCloseButton(QuestChoiceFrame.CloseButton)

    --[[ Scale ]]--
    QuestChoiceFrame._auroraNoSetHeight = true
    QuestChoiceFrame._auroraNoSetSize = true
end
