local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(Aurora)

function private.FrameXML.RaidFrame()
    Skin.RoleCountTemplate(_G.RaidFrame.RoleCount)
    F.ReskinCheck(_G.RaidFrameAllAssistCheckButton)
    F.Reskin(_G.RaidFrameConvertToRaidButton)
    F.Reskin(_G.RaidFrameRaidInfoButton)

    Skin.DialogBorderDarkTemplate(_G.RaidInfoFrame.Border)
    if private.isPatch then
        Skin.DialogHeaderTemplate(_G.RaidInfoFrame.Header)
    else
        _G.RaidInfoFrameHeader:Hide()
    end
    _G.RaidInfoFrame:SetPoint("TOPLEFT", _G.RaidFrame, "TOPRIGHT", 1, -28)
    _G.RaidInfoDetailHeader:Hide()
    _G.RaidInfoDetailFooter:Hide()
    _G.RaidInfoDetailCorner:Hide()

    _G.RaidInfoInstanceLabel:DisableDrawLayer("BACKGROUND")
    _G.RaidInfoIDLabel:DisableDrawLayer("BACKGROUND")
    F.ReskinClose(_G.RaidInfoCloseButton)
    F.ReskinScroll(_G.RaidInfoScrollFrameScrollBar)
    F.Reskin(_G.RaidInfoExtendButton)
    F.Reskin(_G.RaidInfoCancelButton)
end
