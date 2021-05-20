local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_CovenantSanctum.lua ]]
    do --[[ Blizzard_CovenantSanctum CovenantSanctumFrame]]
        local covenantID
        Hook.CovenantSanctumMixin = {}
        function Hook.CovenantSanctumMixin:SetCovenantInfo()
            if covenantID ~= self.covenantID then
                covenantID = self.covenantID

                local _, _, _, a = self.NineSlice:GetBackdropColor()
                Base.SetBackdropColor(self.NineSlice, private.COVENANT_COLORS[self.covenantData.textureKit], a)
                self.NineSlice:SetBackdropOption("offsets", {
                    left = 12,
                    right = 9,
                    top = 8,
                    bottom = 17,
                })
            end
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

    Skin.NineSlicePanelTemplate(CovenantSanctumFrame.NineSlice)
    CovenantSanctumFrame.NineSlice:SetFrameLevel(1)

    Skin.UIPanelCloseButton(CovenantSanctumFrame.CloseButton)

    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_CovenantSanctumUpgrades --
    ----====####$$$$%%%%%%$$$$####====----
    local UpgradesTab = CovenantSanctumFrame.UpgradesTab

    UpgradesTab.Background:SetPoint("TOPLEFT", 13, -9)
    UpgradesTab.Background:SetPoint("BOTTOMRIGHT", -310, 18)
    UpgradesTab.Background:SetAlpha(0.75)

    UpgradesTab.TalentsList.BackgroundTile:SetAlpha(0)
    UpgradesTab.TalentsList.Divider:SetAlpha(0)
    Skin.UIPanelButtonTemplate(UpgradesTab.TalentsList.UpgradeButton)

    Skin.UIPanelButtonTemplate(UpgradesTab.DepositButton)
end
