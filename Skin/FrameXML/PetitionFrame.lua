local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

--do --[[ FrameXML\PetitionFrame.lua ]]
--end

--do --[[ FrameXML\PetitionFrame.xml ]]
--end

function private.FrameXML.PetitionFrame()
    _G.PetitionFramePortrait:SetAlpha(0)
    for i = 2, 5 do
        select(i, _G.PetitionFrame:GetRegions()):Hide()
    end
    Base.SetBackdrop(_G.PetitionFrame)
    Skin.UIPanelCloseButton(_G.PetitionFrameCloseButton)
    _G.PetitionFrameCloseButton:SetPoint("TOPRIGHT", 4, 4)

    _G.PetitionFrameCharterTitle:SetPoint("TOPLEFT", 8, -private.FRAME_TITLE_HEIGHT)
    _G.PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameInstructions:SetPoint("RIGHT", -8, 0)

    Skin.UIPanelButtonTemplate(_G.PetitionFrameCancelButton)
    Skin.UIPanelButtonTemplate(_G.PetitionFrameSignButton)
    Skin.UIPanelButtonTemplate(_G.PetitionFrameRequestButton)
    Skin.UIPanelButtonTemplate(_G.PetitionFrameRenameButton)
    _G._G.PetitionFrameCancelButton:SetPoint("BOTTOMRIGHT", -4, 4)
    _G.PetitionFrameRequestButton:SetPoint("BOTTOMLEFT", 4, 4)
    _G.PetitionFrameSignButton:SetPoint("BOTTOMLEFT", 4, 4)
end
