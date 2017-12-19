local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Skin = Aurora.Skin

local F = _G.unpack(Aurora)

do --[[ AddOns\Blizzard_QuestChoice.xml ]]
    function Skin.QuestChoiceItemTemplate(button)
        button._auroraIconBorder = F.ReskinIcon(button.Icon)
        button.Name:SetTextColor(1, 1, 1)

        --[[ Scale ]]--
        button:SetSize(167, 41)
        button.Icon:SetSize(37, 37)
        button.Name:ClearAllPoints()
        button.Name:SetPoint("TOPLEFT", button.Icon, "TOPRIGHT", 5, 0)
        button.Name:SetPoint("BOTTOM", button.Icon, 0, 0)
        button.Name:SetPoint("RIGHT", -5, 0)
    end
    function Skin.QuestChoiceCurrencyTemplate(frame)
        Base.CropIcon(frame.Icon, frame)
    end
    function Skin.QuestChoiceRewardsTemplate(frame)
        Skin.QuestChoiceItemTemplate(frame.Item)

        Skin.QuestChoiceCurrencyTemplate(frame.Currencies.Currency1)
        Skin.QuestChoiceCurrencyTemplate(frame.Currencies.Currency2)
        Skin.QuestChoiceCurrencyTemplate(frame.Currencies.Currency3)

        --[[ Scale ]]--
        frame:SetSize(210, 10)
        frame.Item:SetPoint("TOPLEFT", 30, -5)
        frame._auroraNoSetHeight = true
    end
    function Skin.QuestChoiceOptionTemplate(button)
        button.Artwork:SetTexCoord(0.140625, 0.84375, 0.2265625, 0.78125)
        button.Artwork:ClearAllPoints()
        button.Artwork:SetPoint("TOPLEFT", 13, -29)
        button.Artwork:SetPoint("BOTTOMRIGHT", button, "TOPRIGHT", -17, -100)

        Skin.UIPanelButtonTemplate(button.OptionButton)
        Skin.QuestChoiceRewardsTemplate(button.Rewards)

        button.Header.Background:Hide()
        button.Header.Text:SetTextColor(.9, .9, .9)

        button.OptionText:SetText("Text")
        button.OptionText:SetTextColor(.9, .9, .9)
        button.OptionText:SetPoint("LEFT", 5, 0)
        button.OptionText:SetPoint("RIGHT", -5, 0)
        button.OptionText:SetPoint("TOP", button.Artwork, "BOTTOM", 0, -37)
        button.OptionText:SetPoint("BOTTOM", button.Rewards, "TOP", 0, 35)

        --[[ Scale ]]--
        button:SetSize(210, 268)
        button.OptionButton:SetSize(175, 22)
        local oldGetContentHeight =  button.OptionText.GetContentHeight
        function button.OptionText:GetContentHeight()
            return Scale.Value(oldGetContentHeight(self))
        end
        button.Rewards:SetPoint("BOTTOM", button.OptionButton, "TOP", 0, 5)

        button._auroraNoSetHeight = true
        button._auroraNoSetPoint = true
        button.OptionText._auroraNoSetWidth = true
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

    Base.SetBackdrop(QuestChoiceFrame)

    for i = 1, #QuestChoiceFrame.Options do
        Skin.QuestChoiceOptionTemplate(QuestChoiceFrame["Option"..i])
    end

    Skin.UIPanelCloseButton(QuestChoiceFrame.CloseButton)

    --[[ Scale ]]--
    QuestChoiceFrame._auroraNoSetHeight = true
    QuestChoiceFrame._auroraNoSetSize = true
end
