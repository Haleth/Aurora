local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\MovieFrame.lua ]]
    function Hook.MovieFrameCloseDialog_OnShow(self)
        self:SetScale(_G.UIParent:GetScale())
    end
end

--do --[[ FrameXML\MovieFrame.xml ]]
--end

function private.FrameXML.MovieFrame()
    _G.MovieFrame.CloseDialog:HookScript("OnShow", Hook.MovieFrameCloseDialog_OnShow)

    if private.isPatch then
        Skin.DialogBorderTemplate(_G.MovieFrame.CloseDialog.Border)
    else
        Base.SetBackdrop(_G.MovieFrame.CloseDialog)
    end

    Skin.CinematicDialogButtonTemplate(_G.MovieFrame.CloseDialog.ConfirmButton)
    Skin.CinematicDialogButtonTemplate(_G.MovieFrame.CloseDialog.ResumeButton)
end
