local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\StaticPopupSpecial.lua ]]
--end

do --[[ FrameXML\StaticPopupSpecial.xml ]]
    function Skin.PlayerReportFrameTemplate(Frame)
        Skin.DialogBorderTemplate(Frame.Border)

        local EditBox = Frame.Comment
        Base.CreateBackdrop(EditBox, private.backdrop, {
            tl = EditBox.TopLeft,
            tr = EditBox.TopRight,
            t = EditBox.Top,

            bl = EditBox.BottomLeft,
            br = EditBox.BottomRight,
            b = EditBox.Bottom,

            l = EditBox.Left,
            r = EditBox.Right,

            bg = EditBox.Middle
        })
        Base.SetBackdrop(EditBox, Color.frame)
        EditBox:SetBackdropBorderColor(Color.button)

        local scrollframe = EditBox.ScrollFrame
        Skin.UIPanelScrollFrameTemplate(scrollframe)

        scrollframe.ScrollBar:ClearAllPoints()
        scrollframe.ScrollBar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", -18, -13)
        scrollframe.ScrollBar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", -18, 13)

        scrollframe.ScrollBar.ScrollUpButton:SetPoint("BOTTOM", scrollframe.ScrollBar, "TOP")
        scrollframe.ScrollBar.ScrollDownButton:SetPoint("TOP", scrollframe.ScrollBar, "BOTTOM")

        Skin.UIPanelButtonTemplate(Frame.ReportButton)
        Skin.UIPanelButtonTemplate(Frame.CancelButton)
    end
end

function private.FrameXML.StaticPopupSpecial()
    local PetBattleQueueReadyFrame = _G.PetBattleQueueReadyFrame
    Skin.DialogBorderTemplate(PetBattleQueueReadyFrame.Border)
    Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.AcceptButton)
    Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.DeclineButton)

    if private.isPatch then
        Skin.PlayerReportFrameTemplate(_G.ClubFinderReportFrame)
    end
    Skin.PlayerReportFrameTemplate(_G.PlayerReportFrame)
end
