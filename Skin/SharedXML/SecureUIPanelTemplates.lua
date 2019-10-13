local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals floor

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\SecureUIPanelTemplates.lua ]]
--end

do --[[ FrameXML\SecureUIPanelTemplates.xml ]]
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

        local bg = _G.CreateFrame("Frame", nil, ScrollFrame)
        bg:SetPoint("TOPLEFT", -4, 3)
        bg:SetPoint("BOTTOMRIGHT", 4, -3)
        bg:SetFrameLevel(ScrollFrame:GetFrameLevel())
        Base.CreateBackdrop(bg, private.backdrop, {
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
        Base.SetBackdrop(bg, Color.frame)
    end
    function Skin.FauxScrollFrameTemplate(ScrollFrame)
        Skin.UIPanelScrollFrameTemplate(ScrollFrame)
    end
    function Skin.ListScrollFrameTemplate(ScrollFrame)
        Skin.FauxScrollFrameTemplate(ScrollFrame)
        local name = ScrollFrame:GetName()
        _G[name.."Top"]:Hide()
        _G[name.."Bottom"]:Hide()
        _G[name.."Middle"]:Hide()
    end
    function Skin.UIPanelButtonNoTooltipTemplate(Button)
        Button.Left:SetAlpha(0)
        Button.Right:SetAlpha(0)
        Button.Middle:SetAlpha(0)
        Button:SetHighlightTexture("")

        Base.SetBackdrop(Button, Color.button)
        Base.SetHighlight(Button, "backdrop")
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
        Frame.CancelButton:SetPoint("BOTTOMRIGHT", -5, 5)
        Skin.UIPanelButtonTemplate(Frame.OkayButton)
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
