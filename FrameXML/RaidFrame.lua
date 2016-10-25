local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    F.ReskinCheck(_G.RaidFrameAllAssistCheckButton)
    F.Reskin(_G.RaidFrameConvertToRaidButton)
    F.Reskin(_G.RaidFrameRaidInfoButton)

    F.CreateBD(_G.RaidInfoFrame)
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
end)
