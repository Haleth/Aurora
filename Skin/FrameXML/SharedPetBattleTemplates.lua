local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\SharedPetBattleTemplates.lua ]]
end

do --[[ FrameXML\SharedPetBattleTemplates.xml ]]
    function Skin.SharedPetBattleAbilityTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)

        frame.Delimiter1:SetHeight(1)
        frame.Delimiter2:SetHeight(1)
    end
end

function private.FrameXML.SharedPetBattleTemplates()
    --[[
    ]]
end
