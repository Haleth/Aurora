local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\WardrobeOutfits.lua ]]
    Hook.WardrobeOutfitFrameMixin = {}
    local numButtons = 1
    function Hook.WardrobeOutfitFrameMixin:Update()
        while numButtons < #self.Buttons do
            numButtons = numButtons + 1
            Skin.WardrobeOutfitButtonTemplate(self.Buttons[numButtons])
        end
    end
end

do --[[ FrameXML\WardrobeOutfits.xml ]]
    function Skin.WardrobeOutfitButtonTemplate(Frame)
        local parent = Frame:GetParent()
        local selection = Frame.Selection
        selection:SetColorTexture(Color.gray.r, Color.gray.g, Color.gray.b, 0.5)
        selection:ClearAllPoints()
        selection:SetPoint("LEFT", parent, 1, 0)
        selection:SetPoint("RIGHT", parent, -1, 0)
        selection:SetPoint("TOP", 0, 0)
        selection:SetPoint("BOTTOM", 0, 0)

        local highlight = Frame.Highlight
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, .2)
        highlight:ClearAllPoints()
        highlight:SetPoint("LEFT", parent, 1, 0)
        highlight:SetPoint("RIGHT", parent, -1, 0)
        highlight:SetPoint("TOP", 0, 0)
        highlight:SetPoint("BOTTOM", 0, 0)

        Base.CropIcon(Frame.Icon)
    end
    function Skin.WardrobeOutfitDropDownTemplate(Frame)
        Skin.UIDropDownMenuTemplate(Frame)
        local offsets = Frame:GetBackdropOption("offsets")
        Frame:SetBackdropOption("offsets", {
            left = offsets.left,
            right = offsets.right,
            top = offsets.top,
            bottom = -1,
        })
        Skin.UIPanelButtonTemplate(Frame.SaveButton)
    end
end

function private.FrameXML.WardrobeOutfits()
    local WardrobeOutfitFrame = _G.WardrobeOutfitFrame
    Util.Mixin(WardrobeOutfitFrame, Hook.WardrobeOutfitFrameMixin)
    Skin.DialogBorderDarkTemplate(WardrobeOutfitFrame.Border)
    Skin.WardrobeOutfitButtonTemplate(WardrobeOutfitFrame.Buttons[1])


    local WardrobeOutfitEditFrame = _G.WardrobeOutfitEditFrame
    Skin.DialogBorderTemplate(WardrobeOutfitEditFrame.Border)

    local EditBox = WardrobeOutfitEditFrame.EditBox
    Skin.FrameTypeEditBox(EditBox)

    EditBox.LeftTexture:Hide()
    EditBox.RightTexture:Hide()
    EditBox.MiddleTexture:Hide()

    local bg = EditBox:GetBackdropTexture("bg")
    bg:SetPoint("TOPLEFT", -5, -3)
    bg:SetPoint("BOTTOMRIGHT", 5, 3)

    Skin.UIPanelButtonTemplate(WardrobeOutfitEditFrame.AcceptButton)
    Skin.UIPanelButtonTemplate(WardrobeOutfitEditFrame.CancelButton)
    Skin.UIPanelButtonTemplate(WardrobeOutfitEditFrame.DeleteButton)
end
