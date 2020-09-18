local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\Backdrop.lua ]]
--end

do --[[ FrameXML\Backdrop.xml ]]
    function Skin.TooltipBackdropTemplate(Frame)
        Base.SetBackdrop(Frame)
    end
    function Skin.TooltipBorderBackdropTemplate(Frame)
        Base.SetBackdrop(Frame)
        Frame:SetBackdropColor(Color.frame, 0)
    end
end

function private.SharedXML.Backdrop()
    ----====####$$$$%%%%$$$$####====----
    --              Backdrop              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
