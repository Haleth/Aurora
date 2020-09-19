local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\PetitionFrame.lua ]]
--end

--do --[[ FrameXML\PetitionFrame.xml ]]
--end

function private.FrameXML.PetitionFrame()
    local PetitionFrame = _G.PetitionFrame

    if private.isRetail then
        Skin.ButtonFrameTemplate(_G.PetitionFrame)

        -- BlizzWTF: The portrait in the template is not being used.
        local portrait, bg, scrollTop, scrollBottom, scrollMiddle, scrollUp, scrollDown = _G.select(18, _G.PetitionFrame:GetRegions())
        portrait:Hide()
        bg:Hide()
        scrollTop:Hide()
        scrollBottom:Hide()
        scrollMiddle:Hide()
        scrollUp:Hide()
        scrollDown:Hide()
    else
        Base.SetBackdrop(PetitionFrame)
        PetitionFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local portrait, tl, tr, bl, br = PetitionFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()
    end


    _G.PetitionFrameCharterTitle:SetPoint("TOPLEFT", 8, -private.FRAME_TITLE_HEIGHT)
    _G.PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameInstructions:SetPoint("RIGHT", -8, 0)

    if private.isRetail then
        -- BlizzWTF: This should use the title text included in the template
        _G.PetitionFrameNpcNameText:SetAllPoints(_G.PetitionFrame.TitleText)
    else
        local bg = PetitionFrame:GetBackdropTexture("bg")
        _G.PetitionFrameNpcNameText:ClearAllPoints()
        _G.PetitionFrameNpcNameText:SetPoint("TOPLEFT", bg)
        _G.PetitionFrameNpcNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end

    Skin.UIPanelButtonTemplate(_G.PetitionFrameCancelButton)
    _G.PetitionFrameCancelButton:SetPoint("BOTTOMRIGHT", -4, 4)
    Skin.UIPanelButtonTemplate(_G.PetitionFrameSignButton)
    Skin.UIPanelButtonTemplate(_G.PetitionFrameRequestButton)
    if private.isClassic then
        Skin.UIPanelCloseButton(_G.PetitionFrameCloseButton)
    end
    Skin.UIPanelButtonTemplate(_G.PetitionFrameRenameButton)
    _G.PetitionFrameRenameButton:ClearAllPoints()
    _G.PetitionFrameRenameButton:SetPoint("TOPLEFT", _G.PetitionFrameRequestButton, "TOPRIGHT", 1, 0)
    _G.PetitionFrameRenameButton:SetPoint("BOTTOMRIGHT", _G.PetitionFrameCancelButton, "BOTTOMLEFT", -1, 0)
end
