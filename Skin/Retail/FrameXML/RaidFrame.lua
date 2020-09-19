local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\RaidFrame.lua ]]
--end

do --[[ FrameXML\RaidFrame.xml ]]
    function Skin.RaidInfoHeaderTemplate(Frame)
        Frame:DisableDrawLayer("BACKGROUND")
    end
end

function private.FrameXML.RaidFrame()
    if private.isRetail then
        Skin.RoleCountTemplate(_G.RaidFrame.RoleCount)
    end
    Skin.UICheckButtonTemplate(_G.RaidFrameAllAssistCheckButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameConvertToRaidButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameRaidInfoButton)


    if private.isRetail then
        Skin.DialogBorderDarkTemplate(_G.RaidInfoFrame.Border)
        Skin.DialogHeaderTemplate(_G.RaidInfoFrame.Header)

        _G.RaidInfoDetailHeader:Hide()
        _G.RaidInfoDetailFooter:Hide()
        _G.RaidInfoDetailCorner:Hide()

        Skin.RaidInfoHeaderTemplate(_G.RaidInfoInstanceLabel)
        Skin.RaidInfoHeaderTemplate(_G.RaidInfoIDLabel)
    else
        Skin.DialogBorderDarkTemplate(_G.RaidInfoFrame)

        _G.RaidInfoDetailHeader:Hide()
        _G.RaidInfoDetailCorner:Hide()
        _G.RaidInfoHeader:ClearAllPoints()
        _G.RaidInfoHeader:SetPoint("TOPLEFT")
        _G.RaidInfoHeader:SetPoint("BOTTOMRIGHT", _G.RaidInfoFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end
    _G.RaidInfoFrame:SetPoint("TOPLEFT", _G.RaidFrame, "TOPRIGHT", 1, -28)

    Skin.UIPanelCloseButton(_G.RaidInfoCloseButton)
    if private.isRetail then
        Skin.HybridScrollBarTemplate(_G.RaidInfoScrollFrame.scrollBar)
        Skin.UIPanelButtonTemplate(_G.RaidInfoExtendButton)
        Skin.UIPanelButtonTemplate(_G.RaidInfoCancelButton)
    else
        Skin.UIPanelScrollFrameTemplate(_G.RaidInfoScrollFrame)
        _G.RaidInfoScrollFrameTop:Hide()
        _G.RaidInfoScrollFrameBottom:Hide()
    end
end
