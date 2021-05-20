local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\MovieFrame.lua ]]
    function Hook.MovieFrameCloseDialog_OnShow(self)
        self:SetScale(_G.UIParent:GetScale())
    end
end

--do --[[ FrameXML\MovieFrame.xml ]]
--end

function private.FrameXML.MovieFrame()
    _G.MovieFrame.CloseDialog:HookScript("OnShow", Hook.MovieFrameCloseDialog_OnShow)

    Skin.DialogBorderTemplate(_G.MovieFrame.CloseDialog.Border)
    Skin.CinematicDialogButtonTemplate(_G.MovieFrame.CloseDialog.ConfirmButton)
    Skin.CinematicDialogButtonTemplate(_G.MovieFrame.CloseDialog.ResumeButton)
end
