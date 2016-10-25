local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    if not C.is71 then return end
    
    local QuickJoinFrame = _G.QuickJoinFrame
    _G.QuickJoinScrollFrameTop:Hide()
    _G.QuickJoinScrollFrameMiddle:Hide()
    _G.QuickJoinScrollFrameBottom:Hide()
    F.Reskin(QuickJoinFrame.JoinQueueButton)
end)
