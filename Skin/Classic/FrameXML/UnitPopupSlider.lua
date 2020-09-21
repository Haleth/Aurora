local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\UnitPopupSlider.lua ]]
--end

do --[[ FrameXML\UnitPopupSlider.xml ]]
    function Skin.UnitPopupSliderTemplate(Slider)
        Skin.PropertySliderTemplate(Slider)
    end
end

--function private.FrameXML.UnitPopupSlider()
--end
