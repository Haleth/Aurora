local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\UIMenu.lua ]]
    function Hook.UIMenuTemplate_OnShow(self)
        Base.SetBackdropColor(self)
    end
end

do --[[ FrameXML\UIMenu.xml ]]
    function Skin.UIMenuTemplate(Frame)
        Frame:HookScript("OnShow", Hook.UIMenuTemplate_OnShow)

        Base.SetBackdrop(Frame)
    end
end

--function private.FrameXML.UIMenu()
--end
