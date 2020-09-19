local _, private = ...
if private.isClassic then return end
if private.isPatch then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_QuestChoice.xml ]]
    function Skin.QuestChoiceOptionButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end
    function Skin.QuestChoiceItemTemplate(Button)
        Button._auroraIconBorder = Base.CropIcon(Button.Icon, Button)
        Button.Name:SetTextColor(1, 1, 1)
    end
    function Skin.QuestChoiceCurrencyTemplate(Frame)
        Base.CropIcon(Frame.Icon, Frame)
    end
    function Skin.QuestChoiceRewardsTemplate(Frame)
        Skin.QuestChoiceItemTemplate(Frame.Item)

        Skin.QuestChoiceCurrencyTemplate(Frame.Currencies.Currency1)
        Skin.QuestChoiceCurrencyTemplate(Frame.Currencies.Currency2)
        Skin.QuestChoiceCurrencyTemplate(Frame.Currencies.Currency3)
    end

    function Skin.QuestChoiceOptionTemplate(Button)
        Button.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
        Button.Artwork:ClearAllPoints()
        Button.Artwork:SetPoint("TOPLEFT", 13, -29)
        Button.Artwork:SetPoint("BOTTOMRIGHT", Button, "TOPRIGHT", -17, -100)

        Button.Header.Background:Hide()
        Button.Header.Text:SetTextColor(Color.grayLight:GetRGB())
        Button.OptionText:SetTextColor(Color.grayLight:GetRGB())
        Button.OptionText:SetPoint("TOP", Button.Artwork, "BOTTOM", 0, -30)

        Skin.QuestChoiceRewardsTemplate(Button.Rewards)
        Skin.QuestChoiceOptionButtonTemplate(Button.OptionButtonsContainer.Buttons[1])
        Skin.QuestChoiceOptionButtonTemplate(Button.OptionButtonsContainer.Buttons[2])
    end
end

--/dump QuestChoiceFrame.Option1.OptionText:GetContentHeight()
function private.AddOns.Blizzard_QuestChoice()
    local QuestChoiceFrame = _G.QuestChoiceFrame
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
end
