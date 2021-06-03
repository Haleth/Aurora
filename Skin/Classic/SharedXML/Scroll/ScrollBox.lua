local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\ScrollBox.lua ]]
--end

do --[[ FrameXML\ScrollBox.xml ]]
    function Skin.ScrollBoxBaseTemplate(Frame)
    end
end

function private.SharedXML.ScrollBox()
end
