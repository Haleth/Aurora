local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_MacroUI.lua ]]
    function Hook.MacroFrame_OnShow(self)
        --_G.MacroPopupButton1:SetPoint("TOPLEFT", 25, -30)
        _G.MacroPopupButton1:SetPoint("TOPLEFT", _G.MacroPopupEditBox, "BOTTOMLEFT", 5, -20)
    end

    local MACRO_POPUP_FRAME_MINIMUM_PADDING = 40
    function Hook.MacroPopupFrame_AdjustAnchors(self)
        local rightSpace = _G.GetScreenWidth() - _G.MacroFrame:GetRight()
        local leftSpace = self.parentLeft

        self:ClearAllPoints()
        local minSpace = self:GetWidth() + Scale.Value(MACRO_POPUP_FRAME_MINIMUM_PADDING)
        if ( leftSpace >= rightSpace ) then
            if leftSpace < minSpace then
                Scale.RawSetPoint(self, "TOPRIGHT", _G.MacroFrame, "TOPLEFT", minSpace - leftSpace, 0)
            else
                self:SetPoint("TOPRIGHT", _G.MacroFrame, "TOPLEFT", -5, 0)
            end
        else
            if rightSpace < minSpace then
                Scale.RawSetPoint(self, "TOPLEFT", _G.MacroFrame, "TOPRIGHT", rightSpace - minSpace, 0)
            else
                self:SetPoint("TOPLEFT", _G.MacroFrame, "TOPRIGHT", 5, 0)
            end
        end
    end
end

do --[[ AddOns\Blizzard_MacroUI.xml ]]
    function Skin.MacroButtonTemplate(CheckButton)
        Skin.PopupButtonTemplate(CheckButton)
    end
    function Skin.MacroPopupButtonTemplate(CheckButton)
        Skin.SimplePopupButtonTemplate(CheckButton)

        local icon = _G[CheckButton:GetName().."Icon"]
        icon:SetAllPoints()
        Base.CropIcon(icon)

        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
end

function private.AddOns.Blizzard_MacroUI()
    ----------------
    -- MacroFrame --
    ----------------
    _G.MacroFrame:HookScript("OnShow", Hook.MacroFrame_OnShow)

    Skin.ButtonFrameTemplate(_G.MacroFrame)

    -- BlizzWTF: These should use the widgets included in the template
    local portrait, title = select(18, _G.MacroFrame:GetRegions())
    portrait:Hide()
    title:SetAllPoints(_G.MacroFrame.TitleText)

    _G.MacroHorizontalBarLeft:Hide()
    select(21, _G.MacroFrame:GetRegions()):Hide()

    _G.MacroFrameSelectedMacroBackground:SetAlpha(0)
    _G.MacroFrameSelectedMacroName:SetPoint("TOPLEFT", _G.MacroFrameSelectedMacroButton, "TOPRIGHT", 9, 5)
    _G.MacroFrameEnterMacroText:ClearAllPoints()
    _G.MacroFrameEnterMacroText:SetPoint("BOTTOMLEFT", _G.MacroFrameTextBackground, "TOPLEFT", 7, 0)
    _G.MacroFrameCharLimitText:ClearAllPoints()
    _G.MacroFrameCharLimitText:SetPoint("TOP", _G.MacroFrameScrollFrame, "BOTTOM", 0, -3)

    Skin.MacroButtonTemplate(_G.MacroFrameSelectedMacroButton)
    _G.MacroFrameSelectedMacroButton:SetPoint("TOPLEFT", _G.MacroButtonScrollFrame, "BOTTOMLEFT", 7, -15)

    Skin.UIPanelScrollFrameTemplate(_G.MacroButtonScrollFrame)
    _G.MacroButtonScrollFrame:SetPoint("TOPLEFT", 10, -(private.FRAME_TITLE_HEIGHT + 20))
    _G.MacroButtonScrollFrame:SetSize(298, 140)
    _G.MacroButtonScrollFrameTop:Hide()
    _G.MacroButtonScrollFrameMiddle:Hide()
    _G.MacroButtonScrollFrameBottom:Hide()
    for i = 1, _G.MAX_ACCOUNT_MACROS do
        Skin.MacroButtonTemplate(_G["MacroButton"..i])
    end

    Skin.UIPanelButtonTemplate(_G.MacroEditButton)
    _G.MacroEditButton:ClearAllPoints()
    _G.MacroEditButton:SetPoint("BOTTOMLEFT", _G.MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 5, -5)

    Skin.UIPanelScrollFrameTemplate(_G.MacroFrameScrollFrame)
    _G.MacroFrameScrollFrame:SetPoint("TOPLEFT", _G.MacroButtonScrollFrame, "BOTTOMLEFT", 0, -80)
    _G.MacroFrameScrollFrame:SetPoint("BOTTOMRIGHT", -28, 42)
    _G.MacroFrameTextButton:SetAllPoints(_G.MacroFrameScrollFrame)

    Skin.UIPanelButtonTemplate(_G.MacroCancelButton)
    _G.MacroCancelButton:SetPoint("BOTTOMRIGHT", _G.MacroFrameScrollFrame, "TOPRIGHT", 23, 10)
    Skin.UIPanelButtonTemplate(_G.MacroSaveButton)

    Base.SetBackdrop(_G.MacroFrameTextBackground)
    _G.MacroFrameTextBackground:SetPoint("TOPLEFT", _G.MacroFrameScrollFrame, -2, 2)
    _G.MacroFrameTextBackground:SetPoint("BOTTOMRIGHT", _G.MacroFrameScrollFrame, 20, -2)

    Skin.TabButtonTemplate(_G.MacroFrameTab1)
    _G.MacroFrameTab1:ClearAllPoints()
    _G.MacroFrameTab1:SetPoint("BOTTOMLEFT", _G.MacroButtonScrollFrame, "TOPLEFT", 20, 0)
    Hook.PanelTemplates_TabResize(_G.MacroFrameTab1, -15)
    Skin.TabButtonTemplate(_G.MacroFrameTab2)
    _G.MacroFrameTab2:ClearAllPoints()
    _G.MacroFrameTab2:SetPoint("BOTTOMLEFT", _G.MacroFrameTab1, "BOTTOMRIGHT", 10, 0)
    Hook.PanelTemplates_TabResize(_G.MacroFrameTab2, -15, nil, nil, Scale.Value(150))

    Skin.UIPanelButtonTemplate(_G.MacroDeleteButton)
    _G.MacroDeleteButton:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.UIPanelButtonTemplate(_G.MacroNewButton)
    _G.MacroNewButton:SetPoint("BOTTOMRIGHT", _G.MacroExitButton, "BOTTOMLEFT", -2, 0)
    Skin.UIPanelButtonTemplate(_G.MacroExitButton)
    _G.MacroExitButton:SetPoint("BOTTOMRIGHT", -5, 5)

    --[[ Scale ]]--
    _G.MacroFrameSelectedMacroName:SetSize(256, 16)
    _G.MacroFrameCharLimitText:SetSize(0, 10)
    _G.MacroSaveButton:SetPoint("BOTTOM", _G.MacroCancelButton, "TOP", 0, 15)

    ---------------------
    -- MacroPopupFrame --
    ---------------------
    _G.hooksecurefunc("MacroPopupFrame_AdjustAnchors", Hook.MacroPopupFrame_AdjustAnchors)

    _G.MacroPopupFrame:SetSize(490, 471)
    _G.MacroPopupFrame:SetPoint("TOPLEFT", _G.MacroFrame, "TOPRIGHT", 5, 0)
    _G.MacroPopupFrame.BG:Hide()

    if private.isPatch then
        Skin.SelectionFrameTemplate(_G.MacroPopupFrame.BorderBox)

        local chooseIconLabel = select(9, _G.MacroPopupFrame.BorderBox:GetRegions())
        chooseIconLabel:ClearAllPoints()
        chooseIconLabel:SetPoint("BOTTOMLEFT", _G.MacroPopupScrollFrame, "TOPLEFT", 0, 1)
    else
        Base.SetBackdrop(_G.MacroPopupFrame)
        for i = 1, 8 do
            select(i, _G.MacroPopupFrame.BorderBox:GetRegions()):Hide()
        end
        Skin.UIPanelButtonTemplate(_G.MacroPopupCancelButton)
        _G.MacroPopupCancelButton:SetPoint("BOTTOMRIGHT", -5, 5)
        Skin.UIPanelButtonTemplate(_G.MacroPopupOkayButton)


        local enterNameLabel, chooseIconLabel = select(9, _G.MacroPopupFrame.BorderBox:GetRegions())
        enterNameLabel:Hide()
        chooseIconLabel:ClearAllPoints()
        chooseIconLabel:SetPoint("BOTTOMLEFT", _G.MacroPopupScrollFrame, "TOPLEFT", 0, 1)
    end

    _G.MacroPopupEditBox:SetPoint("TOPLEFT", 10, -10)
    Base.SetBackdrop(_G.MacroPopupEditBox, Color.frame)
    _G.MacroPopupNameLeft:Hide()
    _G.MacroPopupNameMiddle:Hide()
    _G.MacroPopupNameRight:Hide()

    Skin.ListScrollFrameTemplate(_G.MacroPopupScrollFrame)
    _G.MacroPopupScrollFrame:ClearAllPoints()
    _G.MacroPopupScrollFrame:SetPoint("TOPLEFT", _G.MacroPopupEditBox, "BOTTOMLEFT", 5, -20)
    _G.MacroPopupScrollFrame:SetPoint("BOTTOMRIGHT", -23, 33)

    --[[ Scale ]]--
    _G.MacroPopupEditBox:SetSize(182, 20)
end
