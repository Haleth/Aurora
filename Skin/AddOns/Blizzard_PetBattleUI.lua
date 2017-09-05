local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_PetBattleUI.lua ]]
    function Hook.PetBattleUnitFrame_UpdateDisplay(self)
        local petOwner = self.petOwner;
        local petIndex = self.petIndex;

        if self._auroraIconBG then
            local rarity = _G.C_PetBattles.GetBreedQuality(petOwner, petIndex)
            local color = _G.ITEM_QUALITY_COLORS[rarity-1]
            self._auroraIconBG:SetColorTexture(color.r, color.g, color.b)
        end
    end
end

do --[[ AddOns\Blizzard_PetBattleUI.xml ]]
    function Skin.PetBattleUnitTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        frame._auroraIconBG = Base.CropIcon(frame.Icon, frame)
        frame.HealthBorder:SetColorTexture(Aurora.frameColor:GetRGB())
        frame.XPBorder:SetColorTexture(Aurora.frameColor:GetRGB())

        frame.Border:Hide()
        Base.SetTexture(frame.ActualHealthBar, "gradientUp")
        Base.SetTexture(frame.XPBar, "gradientUp")

        frame.Delimiter:SetHeight(1)
        frame.Delimiter2:SetHeight(1)
    end
end

function private.AddOns.Blizzard_PetBattleUI()
    _G.hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", Hook.PetBattleUnitFrame_UpdateDisplay)

    if not private.disabled.tooltips then
        Skin.PetBattleUnitTooltipTemplate(_G.PetBattlePrimaryUnitTooltip)
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.PetBattlePrimaryAbilityTooltip)
    end
end
