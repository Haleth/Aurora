local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\ScrollBox.lua ]]
--end

do --[[ FrameXML\ScrollBox.xml ]]
    function Skin.ScrollBoxTemplate(Frame)
        Skin.ScrollControllerTemplate(Frame)
    end
end

function private.SharedXML.ScrollBox()
end
