local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    _G.ChannelFrameLeftInset:DisableDrawLayer("BORDER")
    _G.ChannelFrameLeftInsetBg:Hide()
    _G.ChannelFrameRightInset:DisableDrawLayer("BORDER")
    _G.ChannelFrameRightInsetBg:Hide()
    F.Reskin(_G.ChannelFrameNewButton)
    
    _G.ChannelRosterScrollFrameTop:SetAlpha(0)
    _G.ChannelRosterScrollFrameBottom:SetAlpha(0)
    F.ReskinScroll(_G.ChannelRosterScrollFrameScrollBar)
    for i = 1, _G.MAX_DISPLAY_CHANNEL_BUTTONS do
        _G["ChannelButton"..i]:SetNormalTexture("")
    end


    F.CreateBD(_G.ChannelFrameDaughterFrame)
    _G.ChannelFrameDaughterFrameTitlebar:Hide()
    _G.ChannelFrameDaughterFrameCorner:Hide()
    F.ReskinInput(_G.ChannelFrameDaughterFrameChannelName)
    F.ReskinInput(_G.ChannelFrameDaughterFrameChannelPassword)
    F.ReskinClose(_G.ChannelFrameDaughterFrameDetailCloseButton)
    F.Reskin(_G.ChannelFrameDaughterFrameOkayButton)
    F.Reskin(_G.ChannelFrameDaughterFrameCancelButton)
end)
