local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\Backdrop.lua ]]
--end

do --[[ FrameXML\Backdrop.xml ]]
    function Skin.TooltipBackdropTemplate(Frame)
        Skin.FrameTypeFrame(Frame)
    end
    function Skin.TooltipBorderBackdropTemplate(Frame)
        Skin.FrameTypeFrame(Frame)
        Frame:SetBackdropColor(Color.frame, 0)
    end
end

--function private.SharedXML.Backdrop()
--end
