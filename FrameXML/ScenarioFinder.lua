local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	_G.ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
	_G.ScenarioFinderFrame.TopTileStreaks:Hide()
	_G.ScenarioFinderFrameBtnCornerRight:Hide()
	_G.ScenarioFinderFrameButtonBottomBorder:Hide()
	_G.ScenarioQueueFrameRandomScrollFrameScrollBackground:Hide()
	_G.ScenarioQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
	_G.ScenarioQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()
	_G.ScenarioQueueFrameSpecificScrollFrameScrollBackgroundTopLeft:Hide()
	_G.ScenarioQueueFrameSpecificScrollFrameScrollBackgroundBottomRight:Hide()
	_G.ScenarioQueueFrame.Bg:Hide()
	_G.ScenarioFinderFrameInset:GetRegions():Hide()

	_G.ScenarioQueueFrameRandomScrollFrame:SetWidth(304)

	F.Reskin(_G.ScenarioQueueFrameFindGroupButton)
	F.Reskin(_G.ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
	F.ReskinDropDown(_G.ScenarioQueueFrameTypeDropDown)
	F.ReskinScroll(_G.ScenarioQueueFrameRandomScrollFrameScrollBar)
	F.ReskinScroll(_G.ScenarioQueueFrameSpecificScrollFrameScrollBar)
end)
