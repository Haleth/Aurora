local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\GuildRegistrarFrame.lua ]]
--end

--do --[[ FrameXML\GuildRegistrarFrame.xml ]]
--end

function private.FrameXML.GuildRegistrarFrame()
    _G.GuildRegistrarFramePortrait:SetAlpha(0)
    for i = 2, 5 do
        select(i, _G.GuildRegistrarFrame:GetRegions()):Hide()
    end
    Base.SetBackdrop(_G.GuildRegistrarFrame)
    Skin.UIPanelCloseButton(_G.GuildRegistrarFrameCloseButton)
    _G.GuildRegistrarFrameCloseButton:SetPoint("TOPRIGHT", 4, 4)

    _G.GuildRegistrarFrameNpcNameText:SetPoint("TOP", 0, -10)

    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFrameCancelButton)
    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFramePurchaseButton)

    _G.GuildRegistrarFrameEditBox:SetHeight(20)
    Base.SetBackdrop(_G.GuildRegistrarFrameEditBox, Color.frame)
    local _, _, left, right = _G.GuildRegistrarFrameEditBox:GetRegions()
    left:Hide()
    right:Hide()

    select(2, _G.GuildRegistrarGreetingFrame:GetRegions()):Hide()
end
