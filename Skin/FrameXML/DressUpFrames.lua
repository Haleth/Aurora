local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Util = Aurora.Util

function private.FrameXML.DressUpFrames()
    -----------------
    -- SideDressUp --
    -----------------

    --[[ Used with:
        - AuctionUI
        - VoidStorageUI
    ]]
    local SideDressUpFrame = _G.SideDressUpFrame
    Base.SetBackdrop(SideDressUpFrame)

    local top, bottom, left, right = SideDressUpFrame:GetRegions()
    top:Hide()
    bottom:Hide()
    left:Hide()
    right:Hide()

    SideDressUpFrame.ModelScene:SetPoint("TOPLEFT")
    SideDressUpFrame.ModelScene:SetPoint("BOTTOMRIGHT")
    Skin.UIPanelButtonTemplate(SideDressUpFrame.ResetButton)
    Skin.UIPanelCloseButton(_G.SideDressUpFrameCloseButton)
    select(5, _G.SideDressUpFrameCloseButton:GetRegions()):Hide()


    ------------------
    -- DressUpFrame --
    ------------------
    local DressUpFrame = _G.DressUpFrame
    Skin.ButtonFrameTemplate(DressUpFrame)
    Skin.WardrobeOutfitDropDownTemplate(DressUpFrame.OutfitDropDown)
    Skin.MaximizeMinimizeButtonFrameTemplate(DressUpFrame.MaxMinButtonFrame)

    DressUpFrame.ModelScene:SetPoint("TOPLEFT")
    DressUpFrame.ModelScene:SetPoint("BOTTOMRIGHT")

    Skin.UIPanelButtonTemplate(_G.DressUpFrameCancelButton)
    _G.DressUpFrameCancelButton:SetFrameLevel(_G.DressUpFrameCancelButton:GetFrameLevel() + 1)
    Skin.UIPanelButtonTemplate(DressUpFrame.ResetButton)
    DressUpFrame.ResetButton:SetFrameLevel(DressUpFrame.ResetButton:GetFrameLevel() + 1)
    Util.PositionRelative("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.DressUpFrameCancelButton,
        DressUpFrame.ResetButton,
    })

    DressUpFrame.ModelBackground:SetDrawLayer("BACKGROUND", 3)
    DressUpFrame.ModelBackground:SetAlpha(0.6)
end
