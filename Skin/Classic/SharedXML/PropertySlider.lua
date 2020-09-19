local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ SharedXML\PropertySlider.lua ]]
--end

do --[[ SharedXML\PropertySlider.xml ]]
    function Skin.PropertySliderTemplate(Slider)
        Skin.HorizontalSliderTemplate(Slider)
    end
end

--function private.SharedXML.PropertySlider()
--end
