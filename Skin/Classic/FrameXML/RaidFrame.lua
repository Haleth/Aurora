local _, private = ...
if private.isRetail then return end

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
    Skin.UICheckButtonTemplate(_G.RaidFrameAllAssistCheckButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameConvertToRaidButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameRaidInfoButton)


    Skin.DialogBorderDarkTemplate(_G.RaidInfoFrame)

    _G.RaidInfoDetailHeader:Hide()
    _G.RaidInfoDetailCorner:Hide()
    _G.RaidInfoHeader:ClearAllPoints()
    _G.RaidInfoHeader:SetPoint("TOPLEFT")
    _G.RaidInfoHeader:SetPoint("BOTTOMRIGHT", _G.RaidInfoFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    _G.RaidInfoFrame:SetPoint("TOPLEFT", _G.RaidFrame, "TOPRIGHT", 1, -28)

    Skin.UIPanelCloseButton(_G.RaidInfoCloseButton)
    Skin.UIPanelScrollFrameTemplate(_G.RaidInfoScrollFrame)
    _G.RaidInfoScrollFrameTop:Hide()
    _G.RaidInfoScrollFrameBottom:Hide()
end
