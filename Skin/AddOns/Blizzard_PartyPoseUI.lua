local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_PartyPoseUI.lua ]]
    Hook.PartyPoseRewardsMixin = {}
    function Hook.PartyPoseRewardsMixin:SetRewardsQuality(quality)
        local color = _G.ITEM_QUALITY_COLORS[quality]
        self._auroraIconBorder:SetBackdropBorderColor(color.r, color.g, color.b)
    end
    Hook.PartyPoseMixin = {}
    function Hook.PartyPoseMixin:SetupTheme()
        local themeData = self.partyPoseData.themeData

        if self.OverlayElements.Topper then
            self.OverlayElements.Topper:SetPoint("BOTTOM", self.Border, "TOP", 0, themeData.topperOffset - 15);
        end

        self.Border:SetBackdropOption("offsets", {
            left = themeData.borderPaddingX or 0,
            right = themeData.borderPaddingX or 0,
            top = themeData.borderPaddingY or 0,
            bottom = themeData.borderPaddingY or 0,
        })
    end
end

do --[[ AddOns\Blizzard_PartyPoseUI.xml ]]
    function Skin.PartyPoseRewardsButtonTemplate(Button)
        Util.Mixin(Button, Hook.PartyPoseRewardsMixin)

        Button.NameFrame:SetAlpha(0)
        Base.CropIcon(Button.Icon)
        Button.IconBorder:Hide()

        local iconBG = _G.CreateFrame("Frame", nil, Button)
        iconBG:SetFrameLevel(Button:GetFrameLevel())
        iconBG:SetPoint("TOPLEFT", Button.Icon, -1, 1)
        iconBG:SetPoint("BOTTOMRIGHT", Button.Icon, 1, -1)
        Base.SetBackdrop(iconBG, Color.frame)
        Button._auroraIconBorder = iconBG

        local nameBG = _G.CreateFrame("Frame", nil, Button)
        nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 5, -18)
        nameBG:SetPoint("BOTTOMLEFT", iconBG, "BOTTOMRIGHT", 5, 0)
        nameBG:SetPoint("RIGHT", 60, 0)
        Base.SetBackdrop(nameBG, Color.frame)
    end
    function Skin.PartyPoseFrameTemplate(Frame)
        Util.Mixin(Frame, Hook.PartyPoseMixin)

        Frame.Border.Center = Frame.Background
        Skin.NineSlicePanelTemplate(Frame.Border)

        Frame.TitleBg:SetAlpha(0.6)

        Skin.PartyPoseRewardsButtonTemplate(Frame.RewardAnimations.RewardFrame)
    end
    function Skin.PartyPoseModelFrameTemplate(ModelScene)
        ModelScene:DisableDrawLayer("OVERLAY")
        ModelScene.Bg:SetAlpha(0.75)
    end
end

function private.AddOns.Blizzard_PartyPoseUI()
end
