local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_DebugTools.lua ]]
--end

--do --[[ AddOns\Blizzard_DebugTools.xml ]]
--end

function private.AddOns.Blizzard_DebugTools()
    private.AddOns.Blizzard_EventTrace()

    if not private.disabled.tooltips then
        Skin.GameTooltipTemplate(_G.FrameStackTooltip)
    end
end
