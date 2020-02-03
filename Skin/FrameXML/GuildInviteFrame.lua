local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\GuildInviteFrame.lua ]]
--end

--do --[[ FrameXML\GuildInviteFrame.xml ]]
--end

function private.FrameXML.GuildInviteFrame()
    Skin.TranslucentFrameTemplate(_G.GuildInviteFrame)

    _G.GuildInviteFrameBackground:Hide()

    _G.GuildInviteFrameInviterName:SetPoint("TOP", 0, -20)
    _G.GuildInviteFrameTabardBorder:SetPoint("TOPLEFT", "$parentTabardBackground", 0, 0)
    _G.GuildInviteFrameTabardBorder:SetSize(62, 62)

    _G.GuildInviteFrameTabardRing:Hide()

    Skin.UIPanelButtonTemplate(_G.GuildInviteFrameJoinButton)
    Skin.UIPanelButtonTemplate(_G.GuildInviteFrameDeclineButton)
end
