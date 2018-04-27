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
    function Skin.InputBoxTemplate(editbox)
        editbox.Left:Hide()
        editbox.Right:Hide()
        editbox.Middle:Hide()

        local bg = _G.CreateFrame("Frame", nil, editbox)
        bg:SetPoint("TOPLEFT", editbox.Left)
        bg:SetPoint("BOTTOMRIGHT", editbox.Right)
        bg:SetFrameLevel(editbox:GetFrameLevel() - 1)
        Base.SetBackdrop(bg, Color.frame)
    end

    function Skin.UIPanelScrollBarButton(button)
        button:SetSize(17, 17)
        button:SetNormalTexture("")
        button:SetPushedTexture("")
        button:SetHighlightTexture("")

        local disabled = button:GetDisabledTexture()
        disabled:SetVertexColor(0, 0, 0, .3)
        disabled:SetDrawLayer("OVERLAY")
        disabled:SetAllPoints()

        Base.SetBackdrop(button, Color.button)
    end
    function Skin.UIPanelScrollUpButtonTemplate(button)
        Skin.UIPanelScrollBarButton(button)

        local arrow = button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 4, -6)
        arrow:SetPoint("BOTTOMRIGHT", -5, 7)
        Base.SetTexture(arrow, "arrowUp")

        button._auroraHighlight = {arrow}
        Base.SetHighlight(button, "texture")
    end
    function Skin.UIPanelScrollDownButtonTemplate(button)
        Skin.UIPanelScrollBarButton(button)

        local arrow = button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 4, -7)
        arrow:SetPoint("BOTTOMRIGHT", -5, 6)
        Base.SetTexture(arrow, "arrowDown")

        button._auroraHighlight = {arrow}
        Base.SetHighlight(button, "texture")
    end
    function Skin.UIPanelScrollBarTemplate(slider)
        Skin.UIPanelScrollUpButtonTemplate(slider.ScrollUpButton)
        Skin.UIPanelScrollDownButtonTemplate(slider.ScrollDownButton)

        slider.ThumbTexture:SetAlpha(0)
        slider.ThumbTexture:SetSize(17, 24)

        local thumb = _G.CreateFrame("Frame", nil, slider)
        thumb:SetPoint("TOPLEFT", slider.ThumbTexture, 0, -2)
        thumb:SetPoint("BOTTOMRIGHT", slider.ThumbTexture, 0, 2)
        Base.SetBackdrop(thumb, Color.button)
        slider._auroraThumb = thumb

        --[[ Scale ]]--
        slider:SetWidth(slider:GetWidth())
    end

    function Skin.UIPanelScrollFrameTemplate(scrollframe)
        Skin.UIPanelScrollBarTemplate(scrollframe.ScrollBar)
        scrollframe.ScrollBar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", 2, -17)
        scrollframe.ScrollBar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", 2, 17)
    end
    function Skin.FauxScrollFrameTemplate(scrollframe)
        Skin.UIPanelScrollFrameTemplate(scrollframe)
    end
    function Skin.ListScrollFrameTemplate(scrollframe)
        Skin.FauxScrollFrameTemplate(scrollframe)
        local name = scrollframe:GetName()
        _G[name.."Top"]:Hide()
        _G[name.."Bottom"]:Hide()
        _G[name.."Middle"]:Hide()
    end
    function Skin.SelectionFrameTemplate(frame)
        frame.TopLeft:ClearAllPoints()
        frame.TopRight:ClearAllPoints()
        frame.BottomLeft:ClearAllPoints()
        frame.BottomRight:ClearAllPoints()

        Skin.UIPanelButtonTemplate(frame.CancelButton)
        frame.CancelButton:SetPoint("BOTTOMRIGHT", -5, 5)
        Skin.UIPanelButtonTemplate(frame.OkayButton)
    end
end

function private.SharedXML.SecureUIPanelTemplates()
end
