local _, private = ...

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
    if private.isRetail then
        Skin.ButtonFrameTemplate(_G.GuildRegistrarFrame)

        _G.GuildRegistrarFrameTop:Hide()
        _G.GuildRegistrarFrameBottom:Hide()
        _G.GuildRegistrarFrameMiddle:Hide()

        -- BlizzWTF: This texture doesn't have a handle because the name it's been given already exists via the template
        _G.select(7, _G.GuildRegistrarFrame:GetRegions()):Hide() -- GuildRegistrarFrameBg

        -- BlizzWTF: This should use the title text included in the template
        _G.GuildRegistrarFrameNpcNameText:SetAllPoints(_G.GuildRegistrarFrame.TitleText)
    else
        local GuildRegistrarFrame = _G.GuildRegistrarFrame
        Base.SetBackdrop(GuildRegistrarFrame)
        GuildRegistrarFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local portrait, tl, tr, bl, br = GuildRegistrarFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()

        local bg = GuildRegistrarFrame:GetBackdropTexture("bg")
        _G.GuildRegistrarFrameNpcNameText:ClearAllPoints()
        _G.GuildRegistrarFrameNpcNameText:SetPoint("TOPLEFT", bg)
        _G.GuildRegistrarFrameNpcNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Skin.UIPanelButtonTemplate(_G.GuildRegistrarFrameGoodbyeButton)
    end

    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFrameCancelButton)
    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFramePurchaseButton)

    _G.GuildRegistrarFrameEditBox:SetHeight(20)
    Base.SetBackdrop(_G.GuildRegistrarFrameEditBox, Color.frame)
    local _, _, left, right = _G.GuildRegistrarFrameEditBox:GetRegions()
    left:Hide()
    right:Hide()
end
