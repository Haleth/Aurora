local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_MacroUI.lua ]]
    function Hook.MacroFrame_OnShow(self)
        --_G.MacroPopupButton1:SetPoint("TOPLEFT", 25, -30)
        _G.MacroPopupButton1:SetPoint("TOPLEFT", _G.MacroPopupScrollFrame, 0, -1)
    end
end

--[[
Your addon Aurora if i have the opacity to high the macro icons when making a new
one are gone you cant see them unless i make it more transparent only happens on
that screen as far i can tell any help would be greatly appreciated
]]

do --[[ AddOns\Blizzard_MacroUI.xml ]]
    function Skin.MacroButtonTemplate(CheckButton)
        Skin.PopupButtonTemplate(CheckButton)
    end
    function Skin.MacroPopupButtonTemplate(CheckButton)
        Skin.SimplePopupButtonTemplate(CheckButton)

        local bg = CheckButton:GetBackdropTexture("bg")
        local icon = _G[CheckButton:GetName().."Icon"]
        icon:SetAllPoints()
        icon:SetPoint("TOPLEFT", bg, 1, -1)
        icon:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        Base.CropIcon(icon)

        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
end

function private.AddOns.Blizzard_MacroUI()
    ----------------
    -- MacroFrame --
    ----------------
    local MacroFrame = _G.MacroFrame
    MacroFrame:HookScript("OnShow", Hook.MacroFrame_OnShow)

    Skin.ButtonFrameTemplate(MacroFrame)
    local bg = MacroFrame.NineSlice:GetBackdropTexture("bg")

    -- BlizzWTF: These should use the widgets included in the template
    local portrait, title = select(6, MacroFrame:GetRegions())
    portrait:Hide()
    title:SetAllPoints(MacroFrame.TitleText)

    _G.MacroHorizontalBarLeft:Hide()
    select(9, MacroFrame:GetRegions()):Hide()

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

    Skin.FrameTypeEditBox(_G.MacroFrameTextBackground)
    _G.MacroFrameTextBackground:SetPoint("TOPLEFT", _G.MacroFrameScrollFrame, -2, 2)
    _G.MacroFrameTextBackground:SetPoint("BOTTOMRIGHT", _G.MacroFrameScrollFrame, 20, -2)

    Skin.TabButtonTemplate(_G.MacroFrameTab1)
    _G.MacroFrameTab1:ClearAllPoints()
    _G.MacroFrameTab1:SetPoint("BOTTOMLEFT", _G.MacroButtonScrollFrame, "TOPLEFT", 20, 0)
    Skin.TabButtonTemplate(_G.MacroFrameTab2)
    _G.MacroFrameTab2:ClearAllPoints()
    _G.MacroFrameTab2:SetPoint("BOTTOMLEFT", _G.MacroFrameTab1, "BOTTOMRIGHT", 10, 0)

    Skin.UIPanelButtonTemplate(_G.MacroDeleteButton)
    _G.MacroDeleteButton:SetPoint("BOTTOMLEFT", bg, 5, 5)

    Skin.UIPanelButtonTemplate(_G.MacroNewButton)
    Skin.UIPanelButtonTemplate(_G.MacroExitButton)
    Util.PositionRelative("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -5, 5, 5, "Left", {
        _G.MacroExitButton,
        _G.MacroNewButton,
    })

    ---------------------
    -- MacroPopupFrame --
    ---------------------
    local MacroPopupFrame = _G.MacroPopupFrame

    local BorderBox = MacroPopupFrame.BorderBox
    Base.CreateBackdrop(BorderBox, private.backdrop, {
        bg = MacroPopupFrame.BG
    })
    Skin.SelectionFrameTemplate(BorderBox)
    BorderBox:SetBackdropOption("offsets", {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5,
    })

    bg = BorderBox:GetBackdropTexture("bg")
    local chooseIconLabel = select(9, BorderBox:GetRegions())
    chooseIconLabel:ClearAllPoints()
    chooseIconLabel:SetPoint("BOTTOMLEFT", _G.MacroPopupScrollFrame, "TOPLEFT", -1, 1)

    Skin.FrameTypeEditBox(_G.MacroPopupEditBox)
    _G.MacroPopupEditBox:SetPoint("TOPLEFT", bg, 20, -20)
    _G.MacroPopupNameLeft:Hide()
    _G.MacroPopupNameMiddle:Hide()
    _G.MacroPopupNameRight:Hide()

    Skin.ListScrollFrameTemplate(_G.MacroPopupScrollFrame)
    _G.MacroPopupScrollFrame:ClearAllPoints()
    _G.MacroPopupScrollFrame:SetPoint("TOPLEFT", bg, 25, -60)
    _G.MacroPopupScrollFrame:SetPoint("BOTTOMRIGHT", bg, -23, 33)
end
