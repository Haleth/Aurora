local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\FloatingPetBattleTooltip.lua ]]
--end

do --[[ FrameXML\FloatingPetBattleTooltip.xml ]]
    function Skin.BattlePetTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)
    end
end

function private.FrameXML.FloatingPetBattleTooltip()
    if private.disabled.tooltips then return end

    Skin.SharedPetBattleAbilityTooltipTemplate(_G.FloatingPetBattleAbilityTooltip)
    Skin.UIPanelCloseButton(_G.FloatingPetBattleAbilityTooltip.CloseButton)

    Skin.BattlePetTooltipTemplate(_G.FloatingBattlePetTooltip)
    _G.FloatingBattlePetTooltip.Delimiter:SetHeight(1)
    Skin.UIPanelCloseButton(_G.FloatingBattlePetTooltip.CloseButton)
end
