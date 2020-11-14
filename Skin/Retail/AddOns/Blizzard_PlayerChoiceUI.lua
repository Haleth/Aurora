local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_PlayerChoiceUI.lua ]]
    local textureKitColors = {
        default = {
            title = Color.white,
            description = Color.grayLight,
        },
        alliance = {
            title = Color.Create(0.36, 0.36, 1), -- 5E5EFF
            description = Color.Create(0.53, 0.53, 1), -- 8888FF
        },
        horde = {
            title = Color.Create(0.83, 0.23, 0.23), -- D43C3C
            description = Color.Create(0.86, 0.47, 0.47), -- DD7878
        },
        marine = {
            title = Color.white,
            description = Color.grayLight,
        },
        mechagon = {
            title = Color.Create(0.83, 0.23, 0.23), -- D43C3C
            description = Color.Create(0.83, 0.23, 0.23), -- DD7878
        },
    }

    Hook.PlayerChoiceFrameMixin = {}
    function Hook.PlayerChoiceFrameMixin:TryShow()
        self.NineSlice:SetFrameLevel(1)
        self.Background:Hide()
        self.BorderFrame:Hide()

        self.Title.Left:Hide()
        self.Title.Right:Hide()
        self.Title.Middle:Hide()
    end
    function Hook.PlayerChoiceFrameMixin:Update()
        local textureKitColor = textureKitColors[self.uiTextureKit] or textureKitColors.default
        for i, option in ipairs(self.Options) do
            --[[
            option.Background:Hide()
            option.ArtworkBorder:Hide()
            ]]
            option.Header.Ribbon:Hide()
            option.Header.Text:SetTextColor(textureKitColor.title:GetRGBA())
            option.OptionText:SetTextColor(textureKitColor.description:GetRGBA())

            if option.WidgetContainer.widgetFrames then
                for _, widgetFrame in next, option.WidgetContainer.widgetFrames do
                    if widgetFrame.widgetType == _G.Enum.UIWidgetVisualizationType.SpellDisplay then
                        widgetFrame.Spell:SetFontColor(textureKitColor.description)
                    elseif widgetFrame.widgetType == _G.Enum.UIWidgetVisualizationType.TextWithState then
                        widgetFrame.Text:SetTextColor(textureKitColor.description:GetRGB())
                    end
                end
            end

        end
    end

    Hook.PlayerChoiceOptionFrameMixin = {}
    function Hook.PlayerChoiceOptionFrameMixin:SetupArtworkForOption()
        local optionLayout = self:GetOptionLayoutInfo();
        self.ShadowMask:SetAlpha(0)
        if optionLayout.combineHeaderWithOption then
            self._auroraBG:Show()
        else
            self._auroraBG:Hide()
            self.Background:Hide()
            self.ArtworkBorder:Hide()
        end
    end
    function Hook.PlayerChoiceOptionFrameMixin:SetToWideSize()
    end
end

do --[[ AddOns\Blizzard_PlayerChoiceUI.xml ]]
    function Skin.PlayerChoiceOptionButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end
    function Skin.PlayerChoiceOptionTemplate(Button)
        Util.Mixin(Button, Hook.PlayerChoiceOptionFrameMixin)
        Button._auroraBG = _G.CreateFrame("Frame", nil, Button)
        Button._auroraBG.ignoreInLayout = true
        Base.SetBackdrop(Button._auroraBG, Color.frame)

        Button.BackgroundShadowSmall:SetTexCoord(0.02371541501976, 0.97628458498024, 0.01284796573876, 0.98715203426124)
        Button.BackgroundShadowLarge:SetTexCoord(0.02640264026403, 0.97359735973597, 0.01446654611212, 0.98553345388788)
        Button.ShadowMask:SetAlpha(0)

        Button.ArtworkBorderDisabled:SetAllPoints(Button.Artwork)
    end
end

function private.AddOns.Blizzard_PlayerChoiceUI()
    local PlayerChoiceFrame = _G.PlayerChoiceFrame
    Util.Mixin(PlayerChoiceFrame, Hook.PlayerChoiceFrameMixin)
    Skin.NineSlicePanelTemplate(PlayerChoiceFrame.NineSlice)

    for _, option in next, PlayerChoiceFrame.Options do
        Skin.PlayerChoiceOptionTemplate(option)
    end

    Skin.UIPanelCloseButton(PlayerChoiceFrame.CloseButton)
end
