local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\GuildRegistrarFrame.lua ]]
--end

--do --[[ FrameXML\GuildRegistrarFrame.xml ]]
--end

function private.FrameXML.GuildRegistrarFrame()
    Skin.ButtonFrameTemplate(_G.GuildRegistrarFrame)

    _G.GuildRegistrarFrameTop:Hide()
    _G.GuildRegistrarFrameBottom:Hide()
    _G.GuildRegistrarFrameMiddle:Hide()

    -- BlizzWTF: This texture doesn't have a handle because the name it's been given already exists via the template
    _G.select(7, _G.GuildRegistrarFrame:GetRegions()):Hide() -- GuildRegistrarFrameBg

    -- BlizzWTF: This should use the title text included in the template
    _G.GuildRegistrarFrameNpcNameText:SetAllPoints(_G.GuildRegistrarFrame.TitleText)

    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFrameCancelButton)
    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFramePurchaseButton)

    _G.GuildRegistrarFrameEditBox:SetHeight(20)
    Base.SetBackdrop(_G.GuildRegistrarFrameEditBox, Color.frame)
    local _, _, left, right = _G.GuildRegistrarFrameEditBox:GetRegions()
    left:Hide()
    right:Hide()
end
