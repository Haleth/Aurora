local _, private = ...
if not private.isRetail then return end

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
    Skin.RoleCountTemplate(_G.RaidFrame.RoleCount)
    Skin.UICheckButtonTemplate(_G.RaidFrameAllAssistCheckButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameConvertToRaidButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameRaidInfoButton)


    Skin.DialogBorderDarkTemplate(_G.RaidInfoFrame.Border)
    Skin.DialogHeaderTemplate(_G.RaidInfoFrame.Header)

    _G.RaidInfoDetailHeader:Hide()
    _G.RaidInfoDetailFooter:Hide()
    _G.RaidInfoDetailCorner:Hide()

    Skin.RaidInfoHeaderTemplate(_G.RaidInfoInstanceLabel)
    Skin.RaidInfoHeaderTemplate(_G.RaidInfoIDLabel)
    _G.RaidInfoFrame:SetPoint("TOPLEFT", _G.RaidFrame, "TOPRIGHT", 1, -28)

    Skin.UIPanelCloseButton(_G.RaidInfoCloseButton)
    Skin.HybridScrollBarTemplate(_G.RaidInfoScrollFrame.scrollBar)
    Skin.UIPanelButtonTemplate(_G.RaidInfoExtendButton)
    Skin.UIPanelButtonTemplate(_G.RaidInfoCancelButton)
end
