local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do FrameXML\SecureUIPanelTemplates.lua
end ]]

do --[[ FrameXML\SecureUIPanelTemplates.xml ]]
    function Skin.InputBoxTemplate(EditBox)
        EditBox.Left:Hide()
        EditBox.Right:Hide()
        EditBox.Middle:Hide()

        local bg = _G.CreateFrame("Frame", nil, EditBox)
        bg:SetHeight(20)
        bg:SetPoint("LEFT", -5, 0)
        bg:SetPoint("RIGHT", 0, 0)
        bg:SetFrameLevel(EditBox:GetFrameLevel())
        Base.SetBackdrop(bg, Color.frame)
        EditBox._auroraBG = bg

        --[[ Scale ]]--
        EditBox:SetSize(EditBox:GetSize())
    end

    function Skin.UIPanelScrollBarButton(Button)
        Button:SetSize(17, 17)
        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetHighlightTexture("")

        local disabled = Button:GetDisabledTexture()
        disabled:SetVertexColor(0, 0, 0, .3)
        disabled:SetDrawLayer("OVERLAY")
        disabled:SetAllPoints()

        Base.SetBackdrop(Button, Color.button)
    end
    function Skin.UIPanelScrollUpButtonTemplate(Button)
        Skin.UIPanelScrollBarButton(Button)

        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 4, -6)
        arrow:SetPoint("BOTTOMRIGHT", -5, 7)
        Base.SetTexture(arrow, "arrowUp")

        Button._auroraHighlight = {arrow}
        Base.SetHighlight(Button, "texture")
    end
    function Skin.UIPanelScrollDownButtonTemplate(Button)
        Skin.UIPanelScrollBarButton(Button)

        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 4, -7)
        arrow:SetPoint("BOTTOMRIGHT", -5, 6)
        Base.SetTexture(arrow, "arrowDown")

        Button._auroraHighlight = {arrow}
        Base.SetHighlight(Button, "texture")
    end
    function Skin.UIPanelScrollBarTemplate(Slider)
        Skin.UIPanelScrollUpButtonTemplate(Slider.ScrollUpButton)
        Skin.UIPanelScrollDownButtonTemplate(Slider.ScrollDownButton)
        Skin.ScrollBarThumb(Slider.ThumbTexture)

        --[[ Scale ]]--
        Slider:SetWidth(Slider:GetWidth())
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
end

function private.SharedXML.SecureUIPanelTemplates()
end
