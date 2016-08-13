-- [[ Lua Globals ]]
local _G = _G
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(select(2, ...))

_G.tinsert(C.themes["Aurora"], function()
	local r, g, b = C.r, C.g, C.b

	-- [[ Item reward highlight ]]

	_G.QuestInfoItemHighlight:GetRegions():Hide()

	local function clearHighlight()
		for _, button in pairs(_G.QuestInfoRewardsFrame.RewardButtons) do
			button.bg:SetBackdropColor(0, 0, 0, .25)
		end
	end

	local function setHighlight(self)
		clearHighlight()

		local _, point = self:GetPoint()
		if point then
			point.bg:SetBackdropColor(r, g, b, .2)
		end
	end

	hooksecurefunc(_G.QuestInfoItemHighlight, "SetPoint", setHighlight)
	_G.QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
	_G.QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

	-- [[ Shared ]]

	local function restyleSpellButton(bu)
		local name = bu:GetName()
		local icon = bu.Icon

		_G[name.."NameFrame"]:Hide()
		_G[name.."SpellBorder"]:Hide()

		icon:SetPoint("TOPLEFT", 3, -2)
		icon:SetDrawLayer("ARTWORK")
		icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(icon)

		local bg = _G.CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 14)
		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)
	end

	-- [[ Objectives ]]

	restyleSpellButton(_G.QuestInfoSpellObjectiveFrame)

	local function colourObjectivesText()
		if not _G.QuestInfoFrame.questLog then return end

		local objectivesTable = _G.QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		for i = 1, _G.GetNumQuestLeaderBoards() do
			local _, objectiveType, isCompleted = _G.GetQuestLogLeaderBoard(i)

			if (objectiveType ~= "spell" and objectiveType ~= "log" and numVisibleObjectives < _G.MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = objectivesTable[numVisibleObjectives]

				if isCompleted then
					objective:SetTextColor(.9, .9, .9)
				else
					objective:SetTextColor(1, 1, 1)
				end
			end
		end
	end

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colourObjectivesText)
	hooksecurefunc("QuestInfo_Display", colourObjectivesText)

	-- [[ Quest rewards ]]

	local function restyleRewardButton(bu, isMapQuestInfo)
		bu.NameFrame:Hide()

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon:SetDrawLayer("BACKGROUND", 1)
		F.CreateBG(bu.Icon, 1)

		local bg = _G.CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", bu, 1, 1)

		if isMapQuestInfo then
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 0)
			bu.Icon:SetSize(29, 29)
		else
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 1)
		end

		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)

		bu.bg = bg
	end

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if not bu.restyled then
			restyleRewardButton(bu, rewardsFrame == _G.MapQuestInfoRewardsFrame)

			bu.restyled = true
		end
	end)

	restyleRewardButton(_G.QuestInfoSkillPointFrame)
	restyleRewardButton(_G.MapQuestInfoRewardsFrame.XPFrame, true)
	restyleRewardButton(_G.MapQuestInfoRewardsFrame.MoneyFrame, true)
	restyleRewardButton(_G.MapQuestInfoRewardsFrame.SkillPointFrame, true)

	_G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)

	-- [[ Change text colours ]]

	hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", function(self, red, green, blue)
		if red == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif red == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	_G.QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoTitleHeader.SetTextColor = F.dummy
	_G.QuestInfoTitleHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoDescriptionHeader.SetTextColor = F.dummy
	_G.QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoObjectivesHeader.SetTextColor = F.dummy
	_G.QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.Header.SetTextColor = F.dummy
	_G.QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

	_G.QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	_G.QuestInfoDescriptionText.SetTextColor = F.dummy

	_G.QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	_G.QuestInfoObjectivesText.SetTextColor = F.dummy

	_G.QuestInfoGroupSize:SetTextColor(1, 1, 1)
	_G.QuestInfoGroupSize.SetTextColor = F.dummy

	_G.QuestInfoRewardText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardText.SetTextColor = F.dummy

	_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	_G.QuestInfoSpellObjectiveLearnLabel.SetTextColor = F.dummy

	_G.QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.ItemChooseText.SetTextColor = F.dummy

	_G.QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.ItemReceiveText.SetTextColor = F.dummy

	_G.QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.PlayerTitleText.SetTextColor = F.dummy

	_G.QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardsFrame.XPFrame.ReceiveText.SetTextColor = F.dummy
end)
