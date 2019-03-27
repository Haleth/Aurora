local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next max floor select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_WarboardUI.lua ]]
    local textureKitColors = {
        ["alliance"] = {
            title = Color.Create(0.36, 0.36, 1), -- 5E5EFF
            description = Color.Create(0.53, 0.53, 1), -- 8888FF
        },
        ["horde"] = {
            title = Color.Create(0.83, 0.23, 0.23), -- D43C3C
            description = Color.Create(0.86, 0.47, 0.47), -- DD7878
        },
    }

    Hook.WarboardQuestChoiceFrameMixin = {}
    function Hook.WarboardQuestChoiceFrameMixin:TryShow()
        local textureKit = _G.GetUITextureKitInfo(self.uiTextureKitID)
        local textureKitColor = textureKitColors[textureKit]
        if textureKitColor then
            for _, option in next, self.Options do
                option.Header.Text:SetTextColor(textureKitColor.title:GetRGBA())
                option.OptionText:SetTextColor(textureKitColor.description:GetRGBA())
            end
        end

        if not self.NineSlice.Center then
            self.NineSlice.Center = self.Background.BackgroundTile
            Skin.NineSlicePanelTemplate(self.NineSlice)
            Base.SetBackdrop(self.NineSlice)

            self.CloseButton.Border:Hide()
        end
    end

    Hook.WarboardQuestChoiceOptionFrameMixin = {}
    function Hook.WarboardQuestChoiceOptionFrameMixin:ConfigureButtons()
        self.ArtworkBorderDisabled:SetColorTexture(0.5, 0.2, 0.2, 0.3)
    end
end

do --[[ AddOns\Blizzard_WarboardUI.xml ]]
    function Skin.WarboardQuestChoiceOptionTemplate(Button)
        Util.Mixin(Button, Hook.WarboardQuestChoiceOptionFrameMixin)

        Button.Background:Hide()
        Button.ArtworkBorder:SetAlpha(0)
        Button.ArtworkBorderDisabled:SetAllPoints(Button.Artwork)
        Button.Artwork:ClearAllPoints()
        Button.Artwork:SetPoint("TOPLEFT", 31, -31)
        Button.Artwork:SetPoint("BOTTOMRIGHT", Button, "TOPRIGHT", -31, -112)

        Skin.QuestChoiceOptionButtonTemplate(Button.OptionButtonsContainer.Buttons[1])
        Skin.QuestChoiceOptionButtonTemplate(Button.OptionButtonsContainer.Buttons[2])

        Button.Header.Ribbon:Hide()
        Button.Header.Text:SetTextColor(.9, .9, .9)
        Button.OptionText:SetTextColor(.9, .9, .9)
    end
end

function private.AddOns.Blizzard_WarboardUI()
    local WarboardQuestChoiceFrame = _G.WarboardQuestChoiceFrame
    Util.Mixin(WarboardQuestChoiceFrame, Hook.WarboardQuestChoiceFrameMixin)

    WarboardQuestChoiceFrame.BorderFrame:Hide()
    for _, option in next, WarboardQuestChoiceFrame.Options do
        Skin.WarboardQuestChoiceOptionTemplate(option)
    end

    WarboardQuestChoiceFrame.Title.Left:Hide()
    WarboardQuestChoiceFrame.Title.Right:Hide()
    WarboardQuestChoiceFrame.Title.Middle:Hide()

    Skin.UIPanelCloseButton(WarboardQuestChoiceFrame.CloseButton)
    Skin.GlowBoxFrame(WarboardQuestChoiceFrame.WarfrontHelpBox, "Right")
end
