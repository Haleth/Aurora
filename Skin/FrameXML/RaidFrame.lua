local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

function private.FrameXML.RaidFrame()
    Skin.UICheckButtonTemplate(_G.RaidFrameAllAssistCheckButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameConvertToRaidButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameRaidInfoButton)

    Base.SetBackdrop(_G.RaidInfoFrame)
    _G.RaidInfoFrame:SetPoint("TOPLEFT", _G.RaidFrame, "TOPRIGHT", 1, -28)
    _G.RaidInfoDetailHeader:Hide()
    _G.RaidInfoDetailCorner:Hide()

    Skin.UIPanelCloseButton(_G.RaidInfoCloseButton)
    _G.RaidInfoCloseButton:SetPoint("TOPRIGHT", 4, 4)
    Skin.UIPanelScrollFrameTemplate(_G.RaidInfoScrollFrame)
end
