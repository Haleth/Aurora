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
        bg:SetPoint("TOPLEFT", EditBox.Left)
        bg:SetPoint("BOTTOMRIGHT", EditBox.Right)
        bg:SetFrameLevel(EditBox:GetFrameLevel() - 1)
        Base.SetBackdrop(bg, Color.frame)
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

        Slider.ThumbTexture:SetAlpha(0)
        Slider.ThumbTexture:SetSize(17, 24)

        local thumb = _G.CreateFrame("Frame", nil, Slider)
        thumb:SetPoint("TOPLEFT", Slider.ThumbTexture, 0, -2)
        thumb:SetPoint("BOTTOMRIGHT", Slider.ThumbTexture, 0, 2)
        Base.SetBackdrop(thumb, Color.button)
        Slider._auroraThumb = thumb

        --[[ Scale ]]--
        Slider:SetWidth(Slider:GetWidth())
    end

    function Skin.UIPanelScrollFrameTemplate(ScrollFrame)
        Skin.UIPanelScrollBarTemplate(ScrollFrame.ScrollBar)
        ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ScrollFrame, "TOPRIGHT", 2, -17)
        ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", ScrollFrame, "BOTTOMRIGHT", 2, 17)
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
