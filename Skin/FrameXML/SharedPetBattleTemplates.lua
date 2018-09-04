local _, private = ...

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

        --[[ Scale ]]--
        Frame:SetSize(260, 90)
        Frame.AbilityPetType:SetSize(33, 33)
        Frame.AbilityPetType:SetPoint("TOPLEFT", 11, -10)
        Frame.CurrentCooldown:SetPoint("TOPLEFT", Frame.MaxCooldown, "BOTTOMLEFT", 0, -5)
        Frame.Description:SetWidth(239)

        Frame.Delimiter1:SetSize(250, 2)
        Frame.Delimiter1:SetPoint("TOP", Frame.Description, "BOTTOM", 0, -7)
        Frame.StrongAgainstIcon:SetSize(32, 32)
        Frame.StrongAgainstIcon:SetPoint("TOPLEFT", Frame.Delimiter1, "BOTTOMLEFT", 5, -5)
        Frame.StrongAgainstLabel:SetPoint("LEFT", Frame.StrongAgainstIcon, "RIGHT", 5, 0)
        Frame.StrongAgainstType1:SetSize(33, 33)
        Frame.StrongAgainstType1:SetPoint("LEFT", Frame.StrongAgainstLabel, "RIGHT", 5, -2)
        Frame.StrongAgainstType1Label:SetPoint("LEFT", Frame.StrongAgainstType1, "RIGHT", 5, 0)

        Frame.Delimiter2:SetSize(250, 2)
        Frame.Delimiter2:SetPoint("TOPLEFT", Frame.StrongAgainstIcon, "BOTTOMLEFT", -5, -5)
        Frame.WeakAgainstIcon:SetSize(32, 32)
        Frame.WeakAgainstIcon:SetPoint("TOPLEFT", Frame.Delimiter2, "BOTTOMLEFT", 5, -5)
        Frame.WeakAgainstLabel:SetPoint("LEFT", Frame.WeakAgainstIcon, "RIGHT", 5, 0)
        Frame.WeakAgainstType1:SetSize(33, 33)
        Frame.WeakAgainstType1:SetPoint("LEFT", Frame.WeakAgainstLabel, "RIGHT", 5, -2)
        Frame.WeakAgainstType1Label:SetPoint("LEFT", Frame.WeakAgainstType1, "RIGHT", 5, 0)

        Frame._auroraNoSetHeight = true
    end
end

function private.FrameXML.SharedPetBattleTemplates()
    _G.hooksecurefunc("SharedPetBattleAbilityTooltip_SetAbility", Hook.SharedPetBattleAbilityTooltip_SetAbility)
    --[[
    ]]
end
