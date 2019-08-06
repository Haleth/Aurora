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

    local top, bottom, left, right = _G.SideDressUpFrame:GetRegions()
    top:Hide()
    bottom:Hide()
    left:Hide()
    right:Hide()

    if private.isPatch then
        Skin.UIPanelButtonTemplate(SideDressUpFrame.ResetButton)
        Skin.UIPanelCloseButton(_G.SideDressUpFrameCloseButton)
        select(5, _G.SideDressUpFrameCloseButton:GetRegions()):Hide()
    else
        Skin.UIPanelButtonTemplate(_G.SideDressUpModel.ResetButton)
        Skin.UIPanelCloseButton(_G.SideDressUpModelCloseButton)
        select(5, _G.SideDressUpModelCloseButton:GetRegions()):Hide()
    end


    ------------------
    -- DressUpFrame --
    ------------------
    local DressUpFrame = _G.DressUpFrame
    Skin.ButtonFrameTemplate(DressUpFrame)
    Skin.WardrobeOutfitDropDownTemplate(DressUpFrame.OutfitDropDown)
    Skin.MaximizeMinimizeButtonFrameTemplate(DressUpFrame.MaxMinButtonFrame)
    Skin.UIPanelButtonTemplate(_G.DressUpFrameCancelButton)
    Skin.UIPanelButtonTemplate(DressUpFrame.ResetButton)
    Util.PositionRelative("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.DressUpFrameCancelButton,
        DressUpFrame.ResetButton,
    })

    DressUpFrame.ModelBackground:SetDrawLayer("BACKGROUND", 3)
    DressUpFrame.ModelBackground:ClearAllPoints()
    DressUpFrame.ModelBackground:SetPoint("TOPLEFT")
    DressUpFrame.ModelBackground:SetPoint("BOTTOMRIGHT")
    DressUpFrame.ModelBackground:SetAlpha(0.6)
end
