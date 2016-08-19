local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	_G.LFRQueueFrame:DisableDrawLayer("BACKGROUND")
	_G.LFRBrowseFrame:DisableDrawLayer("BACKGROUND")
	_G.LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
	_G.LFRQueueFrameRoleInset:DisableDrawLayer("BORDER")
	_G.LFRQueueFrameListInset:DisableDrawLayer("BORDER")
	_G.LFRQueueFrameCommentInset:DisableDrawLayer("BORDER")
	_G.LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
	_G.LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
	_G.LFRBrowseFrameRoleInsetBg:Hide()
	_G.LFRQueueFrameRoleInsetBg:Hide()
	_G.LFRQueueFrameListInsetBg:Hide()
	_G.LFRQueueFrameCommentInsetBg:Hide()
	for i = 1, 7 do
		_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
	end

	F.Reskin(_G.LFRBrowseFrameSendMessageButton)
	F.Reskin(_G.LFRBrowseFrameInviteButton)
	F.Reskin(_G.LFRBrowseFrameRefreshButton)
	F.Reskin(_G.LFRQueueFrameFindGroupButton)
	F.Reskin(_G.LFRQueueFrameAcceptCommentButton)
	F.ReskinPortraitFrame(_G.RaidBrowserFrame)
	F.ReskinScroll(_G.LFRQueueFrameSpecificListScrollFrameScrollBar)
	F.ReskinScroll(_G.LFRQueueFrameCommentScrollFrameScrollBar)
	F.ReskinScroll(_G.LFRBrowseFrameListScrollFrameScrollBar)
	F.ReskinDropDown(_G.LFRBrowseFrameRaidDropDown)

	for i = 1, 2 do
		local tab = _G["LFRParentFrameSideTab"..i]
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(C.media.checked)
		if i == 1 then
			local a1, p, a2, x, y = tab:GetPoint()
			tab:SetPoint(a1, p, a2, x + 2, y)
		end
		F.CreateBG(tab)
		_G.select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	end

	for i = 1, _G.NUM_LFR_CHOICE_BUTTONS do
		local bu = _G["LFRQueueFrameSpecificListButton"..i].enableButton
		F.ReskinCheck(bu)
		bu.SetNormalTexture = F.dummy
		bu.SetPushedTexture = F.dummy

		F.ReskinExpandOrCollapse(_G["LFRQueueFrameSpecificListButton"..i].expandOrCollapseButton)
	end

	_G.hooksecurefunc("LFRQueueFrameSpecificListButton_SetDungeon", function(button, dungeonID)
		if _G.LFGCollapseList[dungeonID] then
			button.expandOrCollapseButton.plus:Show()
		else
			button.expandOrCollapseButton.plus:Hide()
		end

		button.enableButton:GetCheckedTexture():SetDesaturated(true)
	end)
end)
