local _, private = ...

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	F.ReskinPortraitFrame(_G.QuestFrame, true)
	--[[ QuestFrame ]]

	hooksecurefunc("QuestFrame_SetMaterial", function(frame, material)
		private.debug("QuestFrame_SetMaterial", material)
		if material ~= "Parchment" then
			local name = frame:GetName()
			_G[name.."MaterialTopLeft"]:Hide()
			_G[name.."MaterialTopRight"]:Hide()
			_G[name.."MaterialBotLeft"]:Hide()
			_G[name.."MaterialBotRight"]:Hide()
		end
	end)

	--[[ Reward Panel ]]
	_G.QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
	_G.QuestFrameRewardPanel:DisableDrawLayer("BORDER")
	F.Reskin(_G.QuestFrameCompleteQuestButton)

	_G.QuestRewardScrollFrameTop:Hide()
	_G.QuestRewardScrollFrameBottom:Hide()
	_G.QuestRewardScrollFrameMiddle:Hide()
	F.ReskinScroll(_G.QuestRewardScrollFrame.ScrollBar)


	--[[ Progress Panel ]]
	_G.QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
	_G.QuestFrameProgressPanel:DisableDrawLayer("BORDER")

	F.Reskin(_G.QuestFrameGoodbyeButton)
	F.Reskin(_G.QuestFrameCompleteButton)

	_G.QuestProgressScrollFrameTop:Hide()
	_G.QuestProgressScrollFrameBottom:Hide()
	_G.QuestProgressScrollFrameMiddle:Hide()
	F.ReskinScroll(_G.QuestProgressScrollFrame.ScrollBar)

	_G.QuestProgressTitleText:SetTextColor(1, 1, 1)
	_G.QuestProgressTitleText:SetShadowColor(0, 0, 0)
	_G.QuestProgressTitleText.SetTextColor = F.dummy
	_G.QuestProgressText:SetTextColor(1, 1, 1)
	_G.QuestProgressText.SetTextColor = F.dummy
	_G.QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	_G.QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	hooksecurefunc(_G.QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	for i = 1, _G.MAX_REQUIRED_ITEMS do
		local bu = _G["QuestProgressItem"..i]
		F.CreateBD(bu, .25)

		bu.Icon:SetPoint("TOPLEFT", 1, -1)
		bu.Icon:SetDrawLayer("OVERLAY")
		F.ReskinIcon(bu.Icon)

		bu.NameFrame:Hide()
		bu.Count:SetDrawLayer("OVERLAY")
	end


	--[[ Detail Panel ]]
	_G.QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
	_G.QuestFrameDetailPanel:DisableDrawLayer("BORDER")

	F.Reskin(_G.QuestFrameDeclineButton)
	F.Reskin(_G.QuestFrameAcceptButton)

	_G.QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off
	_G.QuestDetailScrollFrameTop:Hide()
	_G.QuestDetailScrollFrameBottom:Hide()
	_G.QuestDetailScrollFrameMiddle:Hide()
	F.ReskinScroll(_G.QuestDetailScrollFrame.ScrollBar)


	--[[ Greeting Panel ]]
	_G.QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	F.Reskin(_G.QuestFrameGreetingGoodbyeButton)

	_G.QuestGreetingScrollFrameTop:Hide()
	_G.QuestGreetingScrollFrameBottom:Hide()
	_G.QuestGreetingScrollFrameMiddle:Hide()
	F.ReskinScroll(_G.QuestGreetingScrollFrame.ScrollBar)

	_G.GreetingText:SetTextColor(1, 1, 1)
	_G.GreetingText.SetTextColor = F.dummy
	_G.CurrentQuestsText:SetTextColor(1, 1, 1)
	_G.CurrentQuestsText.SetTextColor = F.dummy
	_G.CurrentQuestsText:SetShadowColor(0, 0, 0)
	_G.AvailableQuestsText:SetTextColor(1, 1, 1)
	_G.AvailableQuestsText.SetTextColor = F.dummy
	_G.AvailableQuestsText:SetShadowColor(0, 0, 0)

	local hRule = _G.QuestFrameGreetingPanel:CreateTexture()
	hRule:SetColorTexture(1, 1, 1, .2)
	hRule:SetSize(256, 1)
	hRule:SetPoint("CENTER", _G.QuestGreetingFrameHorizontalBreak)

	_G.QuestGreetingFrameHorizontalBreak:SetTexture("")

	local function UpdateGreetingPanel()
		hRule:SetShown(_G.QuestGreetingFrameHorizontalBreak:IsShown())
		local numActiveQuests = _G.GetNumActiveQuests()
		if numActiveQuests > 0 then
			for i = 1, numActiveQuests do
				local questTitleButton = _G["QuestTitleButton"..i]
				local title = _G.GetActiveTitle(i)
				if ( _G.IsActiveQuestTrivial(i) ) then
					questTitleButton:SetFormattedText(_G.AURORA_TRIVIAL_QUEST_DISPLAY, title)
				else
					questTitleButton:SetFormattedText(_G.AURORA_NORMAL_QUEST_DISPLAY, title)
				end
			end
		end

		local numAvailableQuests = _G.GetNumAvailableQuests()
		if numAvailableQuests > 0 then
			for i = numActiveQuests + 1, numActiveQuests + numAvailableQuests do
				local questTitleButton = _G["QuestTitleButton"..i]
				local title = _G.GetAvailableTitle(i - numActiveQuests)
				if _G.GetAvailableQuestInfo(i - numActiveQuests) then
					questTitleButton:SetFormattedText(_G.AURORA_TRIVIAL_QUEST_DISPLAY, title);
				else
					questTitleButton:SetFormattedText(_G.AURORA_NORMAL_QUEST_DISPLAY, title);
				end
			end
		end
	end
	_G.QuestFrameGreetingPanel:HookScript("OnShow", UpdateGreetingPanel)
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", UpdateGreetingPanel)

	-- [[ Quest NPC model ]]
	_G.QuestNPCModelBg:Hide()
	_G.QuestNPCModel:DisableDrawLayer("OVERLAY")
	_G.QuestNPCModelNameText:SetDrawLayer("ARTWORK")

	_G.QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")
	_G.QuestNPCModelTextFrameBg:Hide()
	F.ReskinScroll(_G.QuestNPCModelTextScrollFrameScrollBar)

	local npcbd = _G.CreateFrame("Frame", nil, _G.QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 1)
	npcbd:SetPoint("RIGHT", 2, 0)
	npcbd:SetPoint("BOTTOM", _G.QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(0)
	F.CreateBD(npcbd)

	local npcLine = _G.CreateFrame("Frame", nil, _G.QuestNPCModel)
	npcLine:SetPoint("BOTTOMLEFT", 0, -1)
	npcLine:SetPoint("BOTTOMRIGHT", 1, -1)
	npcLine:SetHeight(1)
	npcLine:SetFrameLevel(0)
	F.CreateBD(npcLine, 0)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, x, y)
		if parentFrame == _G.QuestLogPopupDetailFrame or parentFrame == _G.QuestFrame then
			x = x + 3
		end

		_G.QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)
end)
