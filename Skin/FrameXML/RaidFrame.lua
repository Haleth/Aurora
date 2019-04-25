local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(Aurora)

function private.FrameXML.RaidFrame()
    if private.isPatch then
        Skin.RoleCountTemplate(_G.RaidFrame.RoleCount)
    end
    F.ReskinCheck(_G.RaidFrameAllAssistCheckButton)
    F.Reskin(_G.RaidFrameConvertToRaidButton)
    F.Reskin(_G.RaidFrameRaidInfoButton)

    if private.isPatch then
        Skin.DialogBorderDarkTemplate(_G.RaidInfoFrame.Border)
    else
        F.CreateBD(_G.RaidInfoFrame)
    end
    _G.RaidInfoFrame:SetPoint("TOPLEFT", _G.RaidFrame, "TOPRIGHT", 1, -28)
    _G.RaidInfoDetailHeader:Hide()
    _G.RaidInfoDetailFooter:Hide()
    _G.RaidInfoDetailCorner:Hide()
    _G.RaidInfoFrameHeader:Hide()

    _G.RaidInfoInstanceLabel:DisableDrawLayer("BACKGROUND")
    _G.RaidInfoIDLabel:DisableDrawLayer("BACKGROUND")
    F.ReskinClose(_G.RaidInfoCloseButton)
    F.ReskinScroll(_G.RaidInfoScrollFrameScrollBar)
    F.Reskin(_G.RaidInfoExtendButton)
    F.Reskin(_G.RaidInfoCancelButton)
end
