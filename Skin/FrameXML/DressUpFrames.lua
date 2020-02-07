local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select next

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
        - AuctionHouseUI
        - VoidStorageUI
    ]]
    local SideDressUpFrame = _G.SideDressUpFrame
    Base.SetBackdrop(SideDressUpFrame)

    local top, bottom, left, right = SideDressUpFrame:GetRegions()
    top:Hide()
    bottom:Hide()
    left:Hide()
    right:Hide()

    if private.isRetail then
        SideDressUpFrame.ModelScene:SetPoint("TOPLEFT")
        SideDressUpFrame.ModelScene:SetPoint("BOTTOMRIGHT")

        Skin.UIPanelButtonTemplate(SideDressUpFrame.ResetButton)
        Skin.UIPanelCloseButton(_G.SideDressUpFrameCloseButton)
        select(5, _G.SideDressUpFrameCloseButton:GetRegions()):Hide()
    else
        _G.SideDressUpModel:SetPoint("TOPLEFT")
        _G.SideDressUpModel:SetPoint("BOTTOMRIGHT")
        _G.SideDressUpModel.controlFrame:SetPoint("TOP", 0, -5)

        Skin.UIPanelButtonTemplate(_G.SideDressUpModel.ResetButton)
        Skin.UIPanelCloseButton(_G.SideDressUpModelCloseButton)
        select(5, _G.SideDressUpModelCloseButton:GetRegions()):Hide()
    end


    ------------------
    -- DressUpFrame --
    ------------------
    local DressUpFrame = _G.DressUpFrame
    if private.isRetail then
        Skin.ButtonFrameTemplate(DressUpFrame)
        Skin.WardrobeOutfitDropDownTemplate(DressUpFrame.OutfitDropDown)
        Skin.MaximizeMinimizeButtonFrameTemplate(DressUpFrame.MaxMinButtonFrame)

        DressUpFrame.ModelScene:SetPoint("TOPLEFT")
        DressUpFrame.ModelScene:SetPoint("BOTTOMRIGHT")

        DressUpFrame.ModelBackground:SetDrawLayer("BACKGROUND", 3)
        DressUpFrame.ModelBackground:SetAlpha(0.6)

        Skin.UIPanelButtonTemplate(_G.DressUpFrameCancelButton)
        _G.DressUpFrameCancelButton:SetFrameLevel(_G.DressUpFrameCancelButton:GetFrameLevel() + 1)
        Skin.UIPanelButtonTemplate(DressUpFrame.ResetButton)
        DressUpFrame.ResetButton:SetFrameLevel(DressUpFrame.ResetButton:GetFrameLevel() + 1)
        Util.PositionRelative("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
            _G.DressUpFrameCancelButton,
            DressUpFrame.ResetButton,
        })
    else
        Base.SetBackdrop(DressUpFrame)
        DressUpFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local bg = DressUpFrame:GetBackdropTexture("bg")
        Skin.UIPanelCloseButton(_G.DressUpFrameCloseButton)
        Skin.UIPanelButtonTemplate(_G.DressUpFrameCancelButton)
        _G.DressUpFrameCancelButton:SetFrameLevel(_G.DressUpFrameCancelButton:GetFrameLevel() + 1)
        Skin.UIPanelButtonTemplate(DressUpFrame.ResetButton)
        DressUpFrame.ResetButton:SetFrameLevel(DressUpFrame.ResetButton:GetFrameLevel() + 1)
        Util.PositionRelative("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -15, 15, 5, "Left", {
            _G.DressUpFrameCancelButton,
            DressUpFrame.ResetButton,
        })

        DressUpFrame.DressUpModel:SetPoint("TOPLEFT", bg, 0, -private.FRAME_TITLE_HEIGHT)
        DressUpFrame.DressUpModel:SetPoint("BOTTOMRIGHT", bg)
        _G.DressUpModelFrameRotateRightButton:SetPoint("TOPLEFT", bg, 5, -5)
        Skin.NavButtonNext(_G.DressUpModelFrameRotateRightButton)
        Skin.NavButtonPrevious(_G.DressUpModelFrameRotateLeftButton)

        local portrait, tl, tr, bl, br, _, desc = DressUpFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()
        desc:Hide()


        local titleText = DressUpFrame.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT", bg)
        titleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        local textures = {
            BGTopLeft = {
                point = "TOPLEFT",
                x = 271,
                y = 326,
            },
            BGTopRight = {
                x = 66,
                y = 326,
            },
            BGBottomLeft = {
                x = 271,
                y = 164,
            },
            BGBottomRight = {
                x = 66,
                y = 164,
            },
        }
        for name, info in next, textures do
            local tex = DressUpFrame[name]
            if info.point then
                tex:SetPoint(info.point, bg)
            end
            tex:SetSize(info.x, info.y)
            tex:SetDrawLayer("BACKGROUND", 3)
            tex:SetAlpha(0.7)
        end
    end
end
