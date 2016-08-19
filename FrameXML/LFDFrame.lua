local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	_G.LFDParentFrame:DisableDrawLayer("BACKGROUND")
	_G.LFDParentFrameInset:DisableDrawLayer("BACKGROUND")
	_G.LFDParentFrame:DisableDrawLayer("BORDER")
	_G.LFDParentFrameInset:DisableDrawLayer("BORDER")
	_G.LFDParentFrame:DisableDrawLayer("OVERLAY")

	_G.LFDQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
	_G.LFDQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()

	-- this fixes right border of second reward being cut off
	_G.LFDQueueFrameRandomScrollFrame:SetWidth(_G.LFDQueueFrameRandomScrollFrame:GetWidth()+1)

	_G.hooksecurefunc("LFGDungeonListButton_SetDungeon", function(button, dungeonID)
		if not button.expandOrCollapseButton.plus then
			F.ReskinCheck(button.enableButton)
			F.ReskinExpandOrCollapse(button.expandOrCollapseButton)
		end
		if _G.LFGCollapseList[dungeonID] then
			button.expandOrCollapseButton.plus:Show()
		else
			button.expandOrCollapseButton.plus:Hide()
		end

		button.enableButton:GetCheckedTexture():SetDesaturated(true)
	end)

	F.CreateBD(_G.LFDRoleCheckPopup)
	F.Reskin(_G.LFDRoleCheckPopupAcceptButton)
	F.Reskin(_G.LFDRoleCheckPopupDeclineButton)
	F.Reskin(_G.LFDQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
end)
