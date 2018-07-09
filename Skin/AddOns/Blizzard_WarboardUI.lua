local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next max floor select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_WarboardUI.lua ]]
    local WarboardQuestChoiceFrameMixin do
        local SOLO_OPTION_WIDTH = 500

        local HEADERS_SHOWN_TOP_PADDING = 123
        local HEADERS_HIDDEN_TOP_PADDING = 150

        local contentHeaderTextureKitRegions = {
            ["Ribbon"] = "UI-Frame-%s-Ribbon",
        }
        WarboardQuestChoiceFrameMixin = {}
        if private.isPatch then
            function WarboardQuestChoiceFrameMixin:OnHeightChanged(heightDiff)
                private.debug("WarboardQuestChoiceFrameMixin:OnHeightChanged", heightDiff)
                for _, option in next, self.Options do
                    Scale.RawSetHeight(option.Background, Scale.Value(self.initOptionBackgroundHeight) + heightDiff)
                end
            end
            function WarboardQuestChoiceFrameMixin:Update()
                private.debug("WarboardQuestChoiceFrameMixin:Update")
                Hook.QuestChoiceFrameMixin.Update(self)

                local hasHeaders = false
                local numOptions = self:GetNumOptions()
                for i = 1, numOptions do
                    local option = self.Options[i]
                    option.Artwork:SetDesaturated(not option.hasActiveButton)
                    option.ArtworkBorder:SetShown(option.hasActiveButton)
                    option.ArtworkBorderDisabled:SetShown(not option.hasActiveButton)
                    if not hasHeaders then
                        hasHeaders = option.Header:IsShown()
                    end
                    option:SetupTextureKits(option.Header, contentHeaderTextureKitRegions)
                end

                -- resize solo options of standard size
                local lastOption = self.Options[numOptions]
                if numOptions == 1 and not lastOption.isWide then
                    lastOption:SetWidth(SOLO_OPTION_WIDTH)
                end
                -- title needs to reach across
                self.Title:SetPoint("RIGHT", lastOption, "RIGHT", 3, 0)

                if hasHeaders then
                    self.topPadding = HEADERS_HIDDEN_TOP_PADDING
                else
                    self.topPadding = HEADERS_SHOWN_TOP_PADDING
                end

                self:Layout()

                local showWarfrontHelpbox = false
                if _G.C_Scenario.IsInScenario() and not _G.GetCVarBitfield("closedInfoFrames", _G.LE_FRAME_TUTORIAL_WARFRONT_CONSTRUCTION) then
                    local scenarioType = select(10, _G.C_Scenario.GetInfo())
                    showWarfrontHelpbox = scenarioType == _G.LE_SCENARIO_TYPE_WARFRONT
                end
                if showWarfrontHelpbox then
                    self.WarfrontHelpBox:SetHeight(25 + self.WarfrontHelpBox.BigText:GetHeight())
                    self.WarfrontHelpBox:Show()
                else
                    self.WarfrontHelpBox:Hide()
                end
            end
        else
            function WarboardQuestChoiceFrameMixin:OnHeightChanged(heightDiff)
                private.debug("WarboardQuestChoiceFrameMixin:OnHeightChanged", heightDiff)
                local initOptionHeaderTextHeight = Scale.Value(self.initOptionHeaderTextHeight)
                local maxHeaderTextHeight = initOptionHeaderTextHeight
                private.debug("initOptionHeaderTextHeight", initOptionHeaderTextHeight)

                for _, option in next, self.Options do
                    maxHeaderTextHeight = max(maxHeaderTextHeight, option.Header.Text:GetHeight())
                end
                private.debug("maxHeaderTextHeight", maxHeaderTextHeight)

                local headerTextDifference = floor(maxHeaderTextHeight) - initOptionHeaderTextHeight
                private.debug("headerTextDifference", headerTextDifference)

                for _, option in next, self.Options do
                    Scale.RawSetHeight(option.Header.Text, maxHeaderTextHeight)
                    Scale.RawSetHeight(option, option:GetHeight() + headerTextDifference)
                    Scale.RawSetHeight(option.Header.Background, Scale.Value(self.initOptionBackgroundHeight) + heightDiff + headerTextDifference)
                end
            end
            function WarboardQuestChoiceFrameMixin:Update()
                private.debug("WarboardQuestChoiceFrameMixin:Update")
                Hook.QuestChoiceFrameMixin.Update(self)

                local _, _, numOptions = _G.GetQuestChoiceInfo()

                if (numOptions == 1) then
                    local textWidth = self.Title.Text:GetWidth()
                    local neededWidth = max(120, (textWidth/2) - 40)

                    local newWidth = (neededWidth*2)+430
                    self.fixedWidth = max(600, newWidth)
                    self.leftPadding = ((self.fixedWidth - self.Option1:GetWidth()) / 2) - 4
                    self.Title:SetPoint("LEFT", self.Option1, "LEFT", -neededWidth, 0)
                    self.Title:SetPoint("RIGHT", self.Option1, "RIGHT", neededWidth, 0)
                else
                    self.fixedWidth = 600
                    self.Title:SetPoint("LEFT", self.Option1, "LEFT", -3, 0)
                    self.Title:SetPoint("RIGHT", self.Options[numOptions], "RIGHT", 3, 0)
                end
                self:Layout()
            end
        end
    end
    Hook.WarboardQuestChoiceFrameMixin = WarboardQuestChoiceFrameMixin
end

do --[[ AddOns\Blizzard_WarboardUI.xml ]]
    function Skin.WarboardQuestChoiceOptionTemplate(Button)
        if private.isPatch then
            Button.Background:Hide()
            Button.ArtworkBorder:SetAlpha(0)
            Button.ArtworkBorderDisabled:SetColorTexture(1, 0, 0, 0.3)
            Button.ArtworkBorderDisabled:SetAllPoints(Button.Artwork)
        else
            Button.Nail:Hide()
        end
        Button.Artwork:ClearAllPoints()
        Button.Artwork:SetPoint("TOPLEFT", 31, -31)
        Button.Artwork:SetPoint("BOTTOMRIGHT", Button, "TOPRIGHT", -31, -112)

        if private.isPatch then
            Skin.UIPanelButtonTemplate(Button.OptionButtonsContainer.OptionButton1)
            Skin.UIPanelButtonTemplate(Button.OptionButtonsContainer.OptionButton2)

            Button.Header.Ribbon:Hide()
        else
            Button.Border:Hide()
            Skin.UIPanelButtonTemplate(Button.OptionButton)

            Button.Header.Background:Hide()
        end

        Button.Header.Text:SetTextColor(.9, .9, .9)
        Button.OptionText:SetTextColor(.9, .9, .9)

        --[[ Scale ]]--
        Button:SetSize(240, 332)
        Button.Header.Text:SetWidth(180)
        Button.Header.Text:SetPoint("TOP", Button.Artwork, "BOTTOM", 0, -21)
        Button.OptionText:SetWidth(180)
        Button.OptionText:SetPoint("TOP", Button.Header.Text, "BOTTOM", 0, -12)
        if private.isPatch then
            Button.OptionText:SetPoint("BOTTOM", Button.OptionButtonsContainer, "TOP", 0, 39)
        else
            Button.OptionText:SetPoint("BOTTOM", Button.OptionButton, "TOP", 0, 39)
        end
        Button.OptionText:SetText("Text")
    end
end

function private.AddOns.Blizzard_WarboardUI()
    local WarboardQuestChoiceFrame = _G.WarboardQuestChoiceFrame
    Skin.HorizontalLayoutFrame(WarboardQuestChoiceFrame)
    _G.Mixin(WarboardQuestChoiceFrame, Hook.WarboardQuestChoiceFrameMixin)

    if not private.isPatch then
        WarboardQuestChoiceFrame.Top:Hide()
        WarboardQuestChoiceFrame.Bottom:Hide()
        WarboardQuestChoiceFrame.Left:Hide()
        WarboardQuestChoiceFrame.Right:Hide()

        WarboardQuestChoiceFrame.Header:SetAlpha(0)
    end

    _G.WarboardQuestChoiceFrameTopRightCorner:Hide()
    WarboardQuestChoiceFrame.topLeftCorner:Hide()
    WarboardQuestChoiceFrame.topBorderBar:Hide()
    _G.WarboardQuestChoiceFrameBotRightCorner:Hide()
    _G.WarboardQuestChoiceFrameBotLeftCorner:Hide()
    _G.WarboardQuestChoiceFrameBottomBorder:Hide()
    WarboardQuestChoiceFrame.leftBorderBar:Hide()
    _G.WarboardQuestChoiceFrameRightBorder:Hide()

    Base.SetBackdrop(WarboardQuestChoiceFrame)

    if private.isPatch then
        WarboardQuestChoiceFrame.BorderFrame:Hide()
    else
        WarboardQuestChoiceFrame.GarrCorners:Hide()
    end

    for _, option in next, WarboardQuestChoiceFrame.Options do
        Skin.WarboardQuestChoiceOptionTemplate(option)
    end

    WarboardQuestChoiceFrame.Background:Hide()
    WarboardQuestChoiceFrame.Title.Left:Hide()
    WarboardQuestChoiceFrame.Title.Right:Hide()
    WarboardQuestChoiceFrame.Title.Middle:Hide()

    Skin.UIPanelCloseButton(WarboardQuestChoiceFrame.CloseButton)
    WarboardQuestChoiceFrame.CloseButton:SetPoint("TOPRIGHT", -10, -10)

    if private.isPatch then
        -- BlizzWTF: Why not just use GlowBoxArrowTemplate?
        local WarfrontHelpBox = WarboardQuestChoiceFrame.WarfrontHelpBox
        local Arrow = _G.CreateFrame("Frame", nil, WarfrontHelpBox)
        Arrow.Arrow = WarfrontHelpBox.ArrowRight
        Arrow.Arrow:SetParent(Arrow)
        Arrow.Glow = WarfrontHelpBox.ArrowGlowRight
        Arrow.Glow:SetParent(Arrow)
        WarfrontHelpBox.Arrow = Arrow
        WarfrontHelpBox.Text = WarfrontHelpBox.BigText
        Skin.GlowBoxFrame(WarfrontHelpBox, "Right")
    end

    --[[ Scale ]]--
    WarboardQuestChoiceFrame.Title:SetSize(500, 85)
end
