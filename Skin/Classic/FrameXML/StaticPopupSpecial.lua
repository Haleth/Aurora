local _, private = ...
if private.isRetail then return end

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
        Skin.DialogBorderTemplate(Frame)

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
    Skin.PlayerReportFrameTemplate(_G.PlayerReportFrame)
end
