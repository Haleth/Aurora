local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\StaticPopupSpecial.lua ]]
--end

do --[[ FrameXML\StaticPopupSpecial.xml ]]
    function Skin.PlayerReportFrameTemplate(Frame)
        if private.isRetail then
            Skin.DialogBorderTemplate(Frame.Border)
        else
            Skin.DialogBorderTemplate(Frame)
        end

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
        Skin.FrameTypeEditBox(EditBox)

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
    if private.isRetail then
        local PetBattleQueueReadyFrame = _G.PetBattleQueueReadyFrame
        Skin.DialogBorderTemplate(PetBattleQueueReadyFrame.Border)
        Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.AcceptButton)
        Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.DeclineButton)

        Skin.PlayerReportFrameTemplate(_G.ClubFinderReportFrame)
    end

    Skin.PlayerReportFrameTemplate(_G.PlayerReportFrame)
end
