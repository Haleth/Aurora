local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	local r, g, b = C.r, C.g, C.b
	local function restyleRewardButton(bu, isMapQuestInfo)
		bu.NameFrame:Hide()

		bu.Icon:SetDrawLayer("BACKGROUND", 1)
		F.ReskinIcon(bu.Icon)

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
	local function colourObjectivesText()
		private.debug("colourObjectivesText")
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

	restyleSpellButton(_G.QuestInfoSpellObjectiveFrame)
	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colourObjectivesText)
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material, mapView)
		private.debug("QuestInfo_Display")
		local rewardsFrame = _G.QuestInfoFrame.rewardsFrame
		local isQuestLog = _G.QuestInfoFrame.questLog ~= nil
		local isMapQuest = rewardsFrame == _G.MapQuestInfoRewardsFrame

		colourObjectivesText()

		if ( template.canHaveSealMaterial ) then
			local questFrame = parentFrame:GetParent():GetParent()
			questFrame.SealMaterialBG:Hide()
		end

		local numSpellRewards = isQuestLog and _G.GetNumQuestLogRewardSpells() or _G.GetNumRewardSpells()
		if numSpellRewards > 0 then
			-- Spell Headers
			for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
				private.debug("spellHeaderPool", spellHeader:GetText())
				spellHeader:SetVertexColor(1, 1, 1)
			end
			-- Follower Rewards
			for followerReward in rewardsFrame.followerRewardPool:EnumerateActive() do
				private.debug("followerRewardPool", followerReward.Name:GetText())
				if not followerReward.isSkinned then
					followerReward.PortraitFrame:SetScale(1)
					followerReward.PortraitFrame:ClearAllPoints()
					followerReward.PortraitFrame:SetPoint("TOPLEFT")
					if isMapQuest then
						followerReward.PortraitFrame.Portrait:SetSize(29, 29)
					end
					F.ReskinGarrisonPortrait(followerReward.PortraitFrame)

					followerReward.BG:Hide()
					followerReward.BG:SetPoint("TOPLEFT", followerReward.PortraitFrame, "TOPRIGHT")
					followerReward.BG:SetPoint("BOTTOMRIGHT")
					F.CreateBD(followerReward, .25)
					followerReward:SetHeight(followerReward.PortraitFrame:GetHeight())

					if not isMapQuest then
						followerReward.Class:SetWidth(45)
					end

					followerReward.isSkinned = true
				end
				followerReward.PortraitFrame:SetBackdropBorderColor(followerReward.PortraitFrame.PortraitRingQuality:GetVertexColor())
			end
			-- Spell Rewards
			for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
				private.debug("spellRewardPool", spellReward.Name:GetText())
				if not spellReward.isSkinned then
					restyleRewardButton(spellReward, isMapQuest)
					local border = _G.select(4, spellReward:GetRegions())
					border:Hide()
					if not isMapQuest then
						spellReward.Icon:SetPoint("TOPLEFT", 0, 0)
						spellReward:SetHitRectInsets(0,0,0,0)
						spellReward:SetSize(147, 41)
					end
					spellReward.isSkinned = true
				end
			end
		end
	end)

	--_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	--_G.QuestInfoSpellObjectiveLearnLabel.SetTextColor = F.dummy


	--[[ QuestInfoRewardsFrame ]]
	local QuestInfoRewardsFrame = _G.QuestInfoRewardsFrame
	QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.Header.SetTextColor = F.dummy
	QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

	QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemChooseText.SetTextColor = F.dummy

	QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemReceiveText.SetTextColor = F.dummy

	QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.PlayerTitleText.SetTextColor = F.dummy

	for i, name in next, {"HonorFrame", "SkillPointFrame", "ArtifactXPFrame"} do
		private.debug("Quest restyleRewardButton", name)
		restyleRewardButton(QuestInfoRewardsFrame[name])
	end
	QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.XPFrame.ReceiveText.SetTextColor = F.dummy

	local function clearHighlight()
		for _, button in next, QuestInfoRewardsFrame.RewardButtons do
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

	local QuestInfoPlayerTitleFrame = _G.QuestInfoPlayerTitleFrame
	F.ReskinIcon(QuestInfoPlayerTitleFrame.Icon)
	QuestInfoPlayerTitleFrame.FrameLeft:Hide()
	QuestInfoPlayerTitleFrame.FrameCenter:Hide()
	QuestInfoPlayerTitleFrame.FrameRight:Hide()

	local titleBG = _G.CreateFrame("Frame", nil, QuestInfoPlayerTitleFrame)
	titleBG:SetPoint("TOPLEFT", QuestInfoPlayerTitleFrame.FrameLeft, -2, 0)
	titleBG:SetPoint("BOTTOMRIGHT", QuestInfoPlayerTitleFrame.FrameRight, 0, -1)
	F.CreateBD(titleBG, .25)

	local ItemHighlight = QuestInfoRewardsFrame.ItemHighlight
	ItemHighlight:GetRegions():Hide()

	hooksecurefunc(ItemHighlight, "SetPoint", setHighlight)
	ItemHighlight:HookScript("OnShow", setHighlight)
	ItemHighlight:HookScript("OnHide", clearHighlight)


	--[[ MapQuestInfoRewardsFrame ]]
	for i, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"} do
		private.debug("Map restyleRewardButton", name)
		restyleRewardButton(_G.MapQuestInfoRewardsFrame[name], true)
	end
	_G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)


	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if not bu.restyled then
			restyleRewardButton(bu, rewardsFrame == _G.MapQuestInfoRewardsFrame)

			bu.restyled = true
		end
	end)



	--[[ QuestInfoFrame ]]
	_G.QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoTitleHeader.SetTextColor = F.dummy
	_G.QuestInfoTitleHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	_G.QuestInfoObjectivesText.SetTextColor = F.dummy

	_G.QuestInfoRewardText:SetTextColor(1, 1, 1)
	_G.QuestInfoRewardText.SetTextColor = F.dummy

	hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", function(self, red, green, blue)
		if red == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif red == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	_G.QuestInfoGroupSize:SetTextColor(1, 1, 1)
	_G.QuestInfoGroupSize.SetTextColor = F.dummy

	_G.QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoDescriptionHeader.SetTextColor = F.dummy
	_G.QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	_G.QuestInfoObjectivesHeader.SetTextColor = F.dummy
	_G.QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)

	_G.QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	_G.QuestInfoDescriptionText.SetTextColor = F.dummy

	--[[ QuestInfoSealFrame ]]
	_G.QuestInfoSealFrame.Text:SetShadowColor(0.2, 0.2, 0.2)
	_G.QuestInfoSealFrame.Text:SetShadowOffset(0.6, -0.6)
end)
