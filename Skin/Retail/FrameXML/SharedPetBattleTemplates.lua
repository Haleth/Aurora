local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\SharedPetBattleTemplates.lua ]]
    function Hook.SharedPetBattleAbilityTooltip_SetAbility(self, abilityInfo, additionalText)
        local abilityID = abilityInfo:GetAbilityID()
        if ( not abilityID ) then
            return
        end

        local _, _, _, _, _, _, petType = _G.C_PetBattles.GetAbilityInfoByID(abilityID)
        if self.AbilityPetType:IsShown() then
            self.AbilityPetType:SetTexture([[Interface\Icons\Icon_PetFamily_]].._G.PET_TYPE_SUFFIX[petType])
        end
    end
end

do --[[ FrameXML\SharedPetBattleTemplates.xml ]]
    function Skin.SharedPetBattleAbilityTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)
        Base.CropIcon(Frame.AbilityPetType, Frame)

        Frame.Delimiter1:SetHeight(1)
        Frame.Delimiter2:SetHeight(1)
    end
end

function private.FrameXML.SharedPetBattleTemplates()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("SharedPetBattleAbilityTooltip_SetAbility", Hook.SharedPetBattleAbilityTooltip_SetAbility)
end
