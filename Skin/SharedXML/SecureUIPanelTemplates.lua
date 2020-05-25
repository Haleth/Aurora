local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals floor

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ FrameXML\SecureUIPanelTemplates.lua ]]
--end

do --[[ FrameXML\SecureUIPanelTemplates.xml ]]
    function Skin.LargeInputBoxTemplate(EditBox)
        Skin.FrameTypeEditBox(EditBox)
        EditBox:SetBackdropOption("offsets", {
            left = 3,
            right = 3,
            top = 2,
            bottom = 6,
        })

        EditBox.Left:Hide()
        EditBox.Right:Hide()
        EditBox.Middle:Hide()
    end

    function Skin.InputBoxTemplate(EditBox)
        Skin.FrameTypeEditBox(EditBox)

        -- This is a slightly fancy way of getting a consistent height from frames of variable height.
        local yOfs = floor(EditBox:GetHeight() / 2 + .5) - 10
        EditBox:SetBackdropOption("offsets", {
            left = -4,
            right = 1,
            top = yOfs,
            bottom = yOfs,
        })

        EditBox.Left:Hide()
        EditBox.Right:Hide()
        EditBox.Middle:Hide()
    end

    function Skin.UIPanelScrollBarButton(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 0,
            right = 1,
            top = 0,
            bottom = 0,
        })

        local bg = Button:GetBackdropTexture("bg")
        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", bg, 3, -5)
        arrow:SetPoint("BOTTOMRIGHT", bg, -3, 5)
        Button._auroraTextures = {arrow}
    end
    function Skin.UIPanelScrollUpButtonTemplate(Button)
        Skin.UIPanelScrollBarButton(Button)

        local arrow = Button._auroraTextures[1]
        Base.SetTexture(arrow, "arrowUp")
    end
    function Skin.UIPanelScrollDownButtonTemplate(Button)
        Skin.UIPanelScrollBarButton(Button)

        local arrow = Button._auroraTextures[1]
        Base.SetTexture(arrow, "arrowDown")
    end
    function Skin.UIPanelScrollBarTemplate(Slider)
        Skin.UIPanelScrollUpButtonTemplate(Slider.ScrollUpButton)
        Skin.UIPanelScrollDownButtonTemplate(Slider.ScrollDownButton)
        Skin.ScrollBarThumb(Slider.ThumbTexture)
    end

    function Skin.UIPanelScrollFrameTemplate(ScrollFrame)
        Skin.UIPanelScrollBarTemplate(ScrollFrame.ScrollBar)
        ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ScrollFrame, "TOPRIGHT", 2, -17)
        ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", ScrollFrame, "BOTTOMRIGHT", 2, 17)
    end
    function Skin.InputScrollFrameTemplate(ScrollFrame)
        Skin.UIPanelScrollFrameTemplate(ScrollFrame)
        Base.CreateBackdrop(ScrollFrame, {
            offsets = {
                left = -4,
                right = -4,
                top = -3,
                bottom = -4,
            }
        }, {
            bg = ScrollFrame.MiddleTex,

            l = ScrollFrame.LeftTex,
            r = ScrollFrame.RightTex,
            t = ScrollFrame.TopTex,
            b = ScrollFrame.BottomTex,

            tl = ScrollFrame.TopLeftTex,
            tr = ScrollFrame.TopRightTex,
            bl = ScrollFrame.BottomLeftTex,
            br = ScrollFrame.BottomRightTex,

            borderLayer = "BACKGROUND",
            borderSublevel = -7,
        })
        Base.SetBackdrop(ScrollFrame, Color.frame)
        ScrollFrame:SetBackdropBorderColor(Color.button)
    end
    function Skin.FauxScrollFrameTemplate(ScrollFrame)
        Skin.UIPanelScrollFrameTemplate(ScrollFrame)
    end
    function Skin.ListScrollFrameTemplate(ScrollFrame)
        Skin.FauxScrollFrameTemplate(ScrollFrame)
        ScrollFrame.ScrollBarTop:Hide()
        ScrollFrame.ScrollBarBottom:Hide()

        local _, _, middle = ScrollFrame:GetRegions()
        middle:Hide()
    end
    function Skin.UIPanelButtonNoTooltipTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button.Left:SetAlpha(0)
        Button.Right:SetAlpha(0)
        Button.Middle:SetAlpha(0)
    end
    function Skin.UIPanelButtonNoTooltipResizeToFitTemplate(Button)
        Skin.UIPanelButtonNoTooltipTemplate(Button)
    end
    function Skin.SelectionFrameTemplate(Frame)
        Base.SetBackdrop(Frame)
        Frame.TopLeft:ClearAllPoints()
        Frame.TopRight:ClearAllPoints()
        Frame.BottomLeft:ClearAllPoints()
        Frame.BottomRight:ClearAllPoints()

        Skin.UIPanelButtonTemplate(Frame.CancelButton)
        Skin.UIPanelButtonTemplate(Frame.OkayButton)

        local bg = Frame:GetBackdropTexture("bg")
        Util.PositionRelative("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -5, 5, 5, "Left", {
            Frame.CancelButton,
            Frame.OkayButton,
        })
    end
    function Skin.SecureDialogBorderNoCenterTemplate(Frame)
        Base.CreateBackdrop(Frame, private.backdrop, {
            tl = Frame.TopLeftCorner,
            tr = Frame.TopRightCorner,
            bl = Frame.BottomLeftCorner,
            br = Frame.BottomRightCorner,

            t = Frame.TopEdge,
            b = Frame.BottomEdge,
            l = Frame.LeftEdge,
            r = Frame.RightEdge,

            bg = Frame.Bg
        })

        Base.SetBackdrop(Frame, Color.frame, 0)
    end
    function Skin.SecureDialogBorderTemplate(Frame)
        Skin.SecureDialogBorderNoCenterTemplate(Frame)
        Base.SetBackdrop(Frame)
    end
end

--function private.SharedXML.SecureUIPanelTemplates()
--end
