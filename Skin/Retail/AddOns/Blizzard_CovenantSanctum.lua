local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_CovenantSanctum.lua ]]
    do --[[ Blizzard_CovenantSanctum CovenantSanctumFrame.textureKit]]
        Hook.CovenantSanctumMixin = {}
        function Hook.CovenantSanctumMixin:SetCovenantInfo()
            local _, _, _, a = self.NineSlice:GetBackdropColor()
            local color = private.COVENANT_COLORS[self.textureKit]

            Base.SetBackdropColor(self.NineSlice, color, a)
            self.NineSlice:SetBackdropOption("offsets", {
                left = 25,
                right = 14,
                top = 26,
                bottom = 24,
            })

            self.UpgradesTabButton:SetButtonColor(color, a)
            self.RenownTabButton:SetButtonColor(color, a)
        end
    end
end

do --[[ AddOns\Blizzard_CovenantSanctum.xml ]]
    do --[[ Blizzard_CovenantSanctum ]]
        Skin.CovenantSanctumFrameTabButtonTemplate = Skin.CharacterFrameTabButtonTemplate
    end
end

function private.AddOns.Blizzard_CovenantSanctum()
    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_CovenantSanctum    --
    ----====####$$$$%%%%$$$$####====----
    local CovenantSanctumFrame = _G.CovenantSanctumFrame
    Util.Mixin(CovenantSanctumFrame, Hook.CovenantSanctumMixin)
    CovenantSanctumFrame:SetHitRectInsets(25, 25, 26, 24)

    Skin.NineSlicePanelTemplate(CovenantSanctumFrame.NineSlice)
    CovenantSanctumFrame.NineSlice:SetFrameLevel(1)
    CovenantSanctumFrame.NineSlice:SetHitRectInsets(25, 25, 26, 24)
    local bg = CovenantSanctumFrame.NineSlice:GetBackdropTexture("bg")

    Skin.CovenantSanctumFrameTabButtonTemplate(CovenantSanctumFrame.UpgradesTabButton)
    Skin.CovenantSanctumFrameTabButtonTemplate(CovenantSanctumFrame.RenownTabButton)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        CovenantSanctumFrame.UpgradesTabButton,
        CovenantSanctumFrame.RenownTabButton,
    })

    Skin.UIPanelCloseButton(CovenantSanctumFrame.CloseButton)
    CovenantSanctumFrame.CloseButton:SetPoint("TOPRIGHT", bg, 5.6, 5)

    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_CovenantSanctumUpgrades --
    ----====####$$$$%%%%%%$$$$####====----
    local UpgradesTab = CovenantSanctumFrame.UpgradesTab
    UpgradesTab:SetHitRectInsets(25, 25, 26, 24)

    UpgradesTab.TalentsList.BackgroundTile:SetAlpha(0)
    UpgradesTab.TalentsList.Divider:SetAlpha(0)
    Skin.UIPanelButtonTemplate(UpgradesTab.TalentsList.UpgradeButton)

    Skin.UIPanelButtonTemplate(UpgradesTab.DepositButton)

    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_CovenantSanctumRenown --
    ----====####$$$$%%%%$$$$####====----
    local RenownTab = CovenantSanctumFrame.RenownTab
    RenownTab:SetHitRectInsets(25, 25, 26, 24)

    RenownTab.BackgroundTile:SetAlpha(0)
    RenownTab.Divider:SetAlpha(0)

    -------------
    -- Section --
    -------------
end
