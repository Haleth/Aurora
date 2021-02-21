local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Color = Aurora.Color

do --[[ SharedXML\SharedColorConstants.lua ]]
    private.PAPER_FRAME_TITLE_COLOR = Color.white
    private.PAPER_FRAME_TEXT_COLOR = Color.grayLight

    private.FACTION_COLORS = {
        Alliance = Color.Create(0.0, 0.2, 0.6),
        Horde = Color.Create(0.5, 0.0, 0.0),
    }
    private.AZERITE_COLORS = {
        Color.Create(0.3765, 0.8157, 0.9098),
        Color.Create(0.7098, 0.5019, 0.1725),
    }
    private.COVENANT_COLORS = {
        Kyrian = Color.Create(0.5, 0.45, 0.45),
        Venthyr = Color.Create(0.4, 0.0, 0.0),
        NightFae = Color.Create(0.2, 0.3, 0.4),
        Necrolord = Color.Create(0.1, 0.4, 0.15),
        Maw = Color.Create(0.302, 0.525, 0.553),
    }
end

function private.SharedXML.SharedColorConstants()
    _G.CUSTOM_CLASS_COLORS:NotifyChanges()
end
