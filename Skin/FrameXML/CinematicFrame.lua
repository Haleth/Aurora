local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\CinematicFrame.lua ]]
    function Hook.CinematicFrameCloseDialog_OnShow(self)
        self:SetScale(_G.UIParent:GetScale())
    end
end

do --[[ FrameXML\CinematicFrame.xml ]]
    function Skin.CinematicDialogButtonTemplate(Button)
        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetDisabledTexture("")
        Button:SetHighlightTexture("")

        Base.SetBackdrop(Button, Color.button)
        Base.SetHighlight(Button, "backdrop")
    end
end

function private.FrameXML.CinematicFrame()
    _G.CinematicFrame.closeDialog:HookScript("OnShow", Hook.CinematicFrameCloseDialog_OnShow)

    if private.isRetail then
        Skin.DialogBorderTemplate(_G.CinematicFrame.closeDialog.Border)
    else
        Skin.DialogBorderTemplate(_G.CinematicFrame.closeDialog)
    end
    Skin.CinematicDialogButtonTemplate(_G.CinematicFrameCloseDialogConfirmButton)
    Skin.CinematicDialogButtonTemplate(_G.CinematicFrameCloseDialogResumeButton)
end
