local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	_G.RaidFinderFrameBottomInset:DisableDrawLayer("BORDER")
	_G.RaidFinderFrameBottomInsetBg:Hide()
	_G.RaidFinderFrameBtnCornerRight:Hide()
	_G.RaidFinderFrameButtonBottomBorder:Hide()
	_G.RaidFinderQueueFrameScrollFrameScrollBackground:Hide()
	_G.RaidFinderQueueFrameScrollFrameScrollBackgroundTopLeft:Hide()
	_G.RaidFinderQueueFrameScrollFrameScrollBackgroundBottomRight:Hide()

	-- this fixes right border of second reward being cut off
	_G.RaidFinderQueueFrameScrollFrame:SetWidth(_G.RaidFinderQueueFrameScrollFrame:GetWidth()+1)

	F.ReskinScroll(_G.RaidFinderQueueFrameScrollFrameScrollBar)
end)
