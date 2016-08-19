local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select, pairs, ipairs = _G.select, _G.pairs, _G.ipairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_EncounterJournal"] = function()
	local r, g, b = C.r, C.g, C.b

	local EncounterJournal = _G.EncounterJournal
	_G.EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	EncounterJournal:DisableDrawLayer("BORDER")
	_G.EncounterJournalInset:DisableDrawLayer("BORDER")
	EncounterJournal:DisableDrawLayer("OVERLAY")

	_G.EncounterJournalPortrait:Hide()
	_G.EncounterJournalInstanceSelectBG:Hide()
	_G.EncounterJournalBg:Hide()
	_G.EncounterJournalTitleBg:Hide()
	_G.EncounterJournalInsetBg:Hide()
	_G.EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
	_G.EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()
	EncounterJournal.encounter.info.difficulty.UpLeft:SetAlpha(0)
	EncounterJournal.encounter.info.difficulty.UpRight:SetAlpha(0)
	EncounterJournal.encounter.info.difficulty.DownLeft:SetAlpha(0)
	EncounterJournal.encounter.info.difficulty.DownRight:SetAlpha(0)
	select(5, _G.EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	select(6, _G.EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	EncounterJournal.encounter.info.lootScroll.filter.UpLeft:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.filter.UpRight:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.filter.DownLeft:SetAlpha(0)
	EncounterJournal.encounter.info.lootScroll.filter.DownRight:SetAlpha(0)
	select(5, _G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	select(6, _G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetRegions()):Hide()
	_G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle.UpLeft:SetAlpha(0)
	_G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle.UpRight:SetAlpha(0)	
	_G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle.DownLeft:SetAlpha(0)	
	_G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle.DownRight:SetAlpha(0)	
	
	F.SetBD(EncounterJournal)

	-- [[ Dungeon / raid tabs ]]

	local function onEnable(self)
		self:SetHeight(self.storedHeight) -- prevent it from resizing
		self:SetBackdropColor(0, 0, 0, 0)
	end

	local function onDisable(self)
		self:SetBackdropColor(r, g, b, .2)
	end

	local function onClick(self)
		self:GetFontString():SetTextColor(1, 1, 1)
	end

	for _, tabName in pairs({"EncounterJournalInstanceSelectSuggestTab", "EncounterJournalInstanceSelectDungeonTab", "EncounterJournalInstanceSelectRaidTab", "EncounterJournalInstanceSelectLootJournalTab"}) do
		local tab = _G[tabName]
		local text = tab:GetFontString()

		tab:DisableDrawLayer("OVERLAY")

		tab.mid:Hide()
		tab.left:Hide()
		tab.right:Hide()

		tab.midHighlight:SetAlpha(0)
		tab.leftHighlight:SetAlpha(0)
		tab.rightHighlight:SetAlpha(0)

		tab:SetHeight(tab.storedHeight)
		tab.grayBox:GetRegions():SetAllPoints(tab)

		text:SetPoint("CENTER")
		text:SetTextColor(1, 1, 1)

		tab:HookScript("OnEnable", onEnable)
		tab:HookScript("OnDisable", onDisable)
		tab:HookScript("OnClick", onClick)

		F.Reskin(tab)
	end

	_G.EncounterJournalInstanceSelectSuggestTab:SetBackdropColor(r, g, b, .2)

	-- [[ Side tabs ]]

	_G.EncounterJournalEncounterFrameInfoOverviewTab:ClearAllPoints()
	_G.EncounterJournalEncounterFrameInfoOverviewTab:SetPoint("TOPLEFT", _G.EncounterJournalEncounterFrameInfo, "TOPRIGHT", 9, -35)
	_G.EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
	_G.EncounterJournalEncounterFrameInfoLootTab:SetPoint("TOP", _G.EncounterJournalEncounterFrameInfoOverviewTab, "BOTTOM", 0, 1)
	_G.EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
	_G.EncounterJournalEncounterFrameInfoBossTab:SetPoint("TOP", _G.EncounterJournalEncounterFrameInfoLootTab, "BOTTOM", 0, 1)

	local tabs = {"OverviewTab", "LootTab", "BossTab", "ModelTab"}
	for i = 1, #tabs do
		local tab = _G["EncounterJournalEncounterFrameInfo"..tabs[i]]
		tab:SetScale(.75)

		tab:SetBackdrop({
			bgFile = C.media.backdrop,
			edgeFile = C.media.backdrop,
			edgeSize = 1 / .75,
		})

		tab:SetBackdropColor(0, 0, 0, .5)
		tab:SetBackdropBorderColor(0, 0, 0)

		tab:SetNormalTexture("")
		tab:SetPushedTexture("")
		tab:SetDisabledTexture("")
		tab:SetHighlightTexture("")
	end

	-- [[ Instance select ]]

	F.ReskinDropDown(_G.EncounterJournalInstanceSelectTierDropDown)


	local function listInstances()
		local index = 1
		while true do
			local bu = EncounterJournal.instanceSelect.scroll.child["instance"..index]
			if not bu then return end

			bu:SetNormalTexture("")
			bu:SetHighlightTexture("")
			bu:SetPushedTexture("")

			bu.bgImage:SetDrawLayer("BACKGROUND", 1)

			local bg = F.CreateBG(bu.bgImage)
			bg:SetPoint("TOPLEFT", 3, -3)
			bg:SetPoint("BOTTOMRIGHT", -4, 2)

			index = index + 1
		end
	end

	hooksecurefunc("EncounterJournal_ListInstances", listInstances)
	listInstances()

	-- [[ Encounter frame ]]

	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")

	_G.EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1, 1, 1)

	F.CreateBDFrame(_G.EncounterJournalEncounterFrameInfoModelFrame, .25)

	_G.EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint("TOPLEFT", _G.EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

	do
		local numBossButtons = 1
		local bossButton

		hooksecurefunc("EncounterJournal_DisplayInstance", function()
			bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			while bossButton do
				F.Reskin(bossButton, true)

				bossButton.text:SetTextColor(1, 1, 1)
				bossButton.text.SetTextColor = F.dummy

				local hl = bossButton:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .2)
				hl:SetPoint("TOPLEFT", 2, -1)
				hl:SetPoint("BOTTOMRIGHT", 0, 1)

				bossButton.creature:SetPoint("TOPLEFT", 0, -4)

				numBossButtons = numBossButtons + 1
				bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			end

			-- move last tab
			local _, point = _G.EncounterJournalEncounterFrameInfoModelTab:GetPoint()
			_G.EncounterJournalEncounterFrameInfoModelTab:SetPoint("TOP", point, "BOTTOM", 0, 1)
		end)
	end

	hooksecurefunc("EncounterJournal_ToggleHeaders", function(self)
		local index = 1
		local header = _G["EncounterJournalInfoHeader"..index]
		while header do
			if not header.styled then
				header.flashAnim.Play = F.dummy

				header.descriptionBG:SetAlpha(0)
				header.descriptionBGBottom:SetAlpha(0)
				for i = 4, 18 do
					select(i, header.button:GetRegions()):SetTexture("")
				end

				header.description:SetTextColor(1, 1, 1)
				header.button.title:SetTextColor(1, 1, 1)
				header.button.title.SetTextColor = F.dummy
				header.button.expandedIcon:SetTextColor(1, 1, 1)
				header.button.expandedIcon.SetTextColor = F.dummy

				-- Blizzard already uses .tex for this frame, so we can't do highlights
				F.Reskin(header.button, true)

				header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)
				header.button.bg = F.CreateBG(header.button.abilityIcon)

				header.styled = true
			end

			if header.button.abilityIcon:IsShown() then
				header.button.bg:Show()
			else
				header.button.bg:Hide()
			end

			index = index + 1
			header = _G["EncounterJournalInfoHeader"..index]
		end
	end)

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, role, index)
		local header = self.overviews[index]
		if not header.styled then
			header.flashAnim.Play = F.dummy

			header.descriptionBG:SetAlpha(0)
			header.descriptionBGBottom:SetAlpha(0)
			for i = 4, 18 do
				select(i, header.button:GetRegions()):SetTexture("")
			end

			header.button.title:SetTextColor(1, 1, 1)
			header.button.title.SetTextColor = F.dummy
			header.button.expandedIcon:SetTextColor(1, 1, 1)
			header.button.expandedIcon.SetTextColor = F.dummy

			-- Blizzard already uses .tex for this frame, so we can't do highlights
			F.Reskin(header.button, true)

			header.styled = true
		end
	end)

	hooksecurefunc("EncounterJournal_SetBullets", function(object, description)
		local parent = object:GetParent()

		if parent.Bullets then
			for _, bullet in pairs(parent.Bullets) do
				if not bullet.styled then
					bullet.Text:SetTextColor(1, 1, 1)
					bullet.styled = true
				end
			end
		end
	end)

	local encLoot = EncounterJournal.encounter.info.lootScroll.buttons

	for i = 1, #encLoot do
		local item = encLoot[i]

		item.boss:SetTextColor(1, 1, 1)
		item.slot:SetTextColor(1, 1, 1)
		item.armorType:SetTextColor(1, 1, 1)

		item.bossTexture:SetAlpha(0)
		item.bosslessTexture:SetAlpha(0)

		item.icon:SetPoint("TOPLEFT", 1, -1)

		item.icon:SetTexCoord(.08, .92, .08, .92)
		item.icon:SetDrawLayer("OVERLAY")
		F.CreateBG(item.icon)

		local bg = CreateFrame("Frame", nil, item)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(item:GetFrameLevel() - 1)
		F.CreateBD(bg, .25)
	end

	-- [[ Search results ]]

	_G.EncounterJournalSearchResultsBg:Hide()
	for i = 3, 11 do
		select(i, _G.EncounterJournalSearchResults:GetRegions()):Hide()
	end

	F.CreateBD(_G.EncounterJournalSearchResults)
	_G.EncounterJournalSearchResults:SetBackdropColor(.15, .15, .15, .9)

	EncounterJournal.searchBox.searchPreviewContainer.botLeftCorner:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.botRightCorner:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.bottomBorder:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.leftBorder:Hide()
	EncounterJournal.searchBox.searchPreviewContainer.rightBorder:Hide()

	local function resultOnEnter(self)
		self.hl:Show()
	end

	local function resultOnLeave(self)
		self.hl:Hide()
	end

	local function styleSearchButton(result, index)
		if index == 1 then
			result:SetPoint("TOPLEFT", _G.EncounterJournalSearchBox, "BOTTOMLEFT", 0, 1)
			result:SetPoint("TOPRIGHT", _G.EncounterJournalSearchBox, "BOTTOMRIGHT", -5, 1)
		else
			result:SetPoint("TOPLEFT", _G.EncounterJournalSearchBox["sbutton"..index-1], "BOTTOMLEFT", 0, 1)
			result:SetPoint("TOPRIGHT", _G.EncounterJournalSearchBox["sbutton"..index-1], "BOTTOMRIGHT", 0, 1)
		end

		result:SetNormalTexture("")
		result:SetPushedTexture("")
		result:SetHighlightTexture("")

		local hl = result:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(C.media.backdrop)
		hl:SetVertexColor(r, g, b, .2)
		hl:Hide()
		result.hl = hl

		F.CreateBD(result)
		result:SetBackdropColor(.1, .1, .1, .9)

		if result.icon then
			result:GetRegions():Hide() -- icon frame

			result.icon:SetTexCoord(.08, .92, .08, .92)

			local bg = F.CreateBG(result.icon)
			bg:SetDrawLayer("BACKGROUND", 1)
		end

		result:HookScript("OnEnter", resultOnEnter)
		result:HookScript("OnLeave", resultOnLeave)
	end

	for i = 1, 5 do
		styleSearchButton(_G.EncounterJournalSearchBox["sbutton"..i], i)
	end

	styleSearchButton(_G.EncounterJournalSearchBox.showAllResults, 6)

	hooksecurefunc("EncounterJournal_SearchUpdate", function()
		local scrollFrame = EncounterJournal.searchResults.scrollFrame
		local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
		local results = scrollFrame.buttons
		local result, index

		local numResults = _G.EJ_GetNumSearchResults()

		for i = 1, #results do
			result = results[i]
			index = offset + i

			if index <= numResults then
				if not result.styled then
					result:SetNormalTexture("")
					result:SetPushedTexture("")
					result:GetRegions():Hide()

					result.resultType:SetTextColor(1, 1, 1)
					result.path:SetTextColor(1, 1, 1)

					F.CreateBG(result.icon)

					result.styled = true
				end

				if result.icon:GetTexCoord() == 0 then
					result.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc(EncounterJournal.searchResults.scrollFrame, "update", function(self)
		for i = 1, #self.buttons do
			local result = self.buttons[i]

			if result.icon:GetTexCoord() == 0 then
				result.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

	F.ReskinClose(_G.EncounterJournalSearchResultsCloseButton)
	F.ReskinScroll(_G.EncounterJournalSearchResultsScrollFrameScrollBar)

	-- [[ Various controls ]]

	F.Reskin(_G.EncounterJournalEncounterFrameInfoDifficulty)
	F.Reskin(_G.EncounterJournalEncounterFrameInfoResetButton)
	F.Reskin(_G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle)
	F.ReskinClose(_G.EncounterJournalCloseButton)
	F.ReskinInput(_G.EncounterJournalSearchBox)
	F.ReskinScroll(_G.EncounterJournalInstanceSelectScrollFrameScrollBar)
	F.ReskinScroll(_G.EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
	F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar)
	F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
	F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
	F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)

	-- [[ Suggest frame ]]

	local suggestFrame = EncounterJournal.suggestFrame

	-- Tooltip

	local EncounterJournalTooltip = _G.EncounterJournalTooltip

	F.CreateBD(EncounterJournalTooltip)

	EncounterJournalTooltip.Item1.newBg = F.ReskinIcon(EncounterJournalTooltip.Item1.icon)
	EncounterJournalTooltip.Item2.newBg = F.ReskinIcon(EncounterJournalTooltip.Item2.icon)

	local function rewardOnEnter()
		for i = 1, 2 do
			local item = EncounterJournalTooltip["Item"..i]
			if item:IsShown() then
				if item.IconBorder:IsShown() then
					item.newBg:SetVertexColor(item.IconBorder:GetVertexColor())
					item.IconBorder:Hide()
				else
					item.newBg:SetVertexColor(0, 0, 0)
				end
			end
		end
	end

	--[[ Suggestion Frames ]]
	do
		-- Suggestion 1
		local suggestion = suggestFrame.Suggestion1

		suggestion.bg:Hide()

		F.CreateBD(suggestion, .25)

		suggestion.icon:SetPoint("TOPLEFT", 135, -15)
		F.CreateBG(suggestion.icon)

		local centerDisplay = suggestion.centerDisplay

		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)

		F.Reskin(suggestion.button)

		local reward = suggestion.reward

		reward:HookScript("OnEnter", rewardOnEnter)
		reward.text:SetTextColor(.9, .9, .9)
		reward.iconRing:Hide()
		reward.iconRingHighlight:SetTexture("")
		F.CreateBG(reward.icon)

		F.ReskinArrow(suggestion.prevButton, "left")
		F.ReskinArrow(suggestion.nextButton, "right")

		-- Suggestion 2 and 3

		for i = 2, 3 do
			suggestion = suggestFrame["Suggestion"..i]

			suggestion.bg:Hide()

			F.CreateBD(suggestion, .25)

			suggestion.icon:SetPoint("TOPLEFT", 10, -10)
			F.CreateBG(suggestion.icon)

			centerDisplay = suggestion.centerDisplay

			centerDisplay:ClearAllPoints()
			centerDisplay:SetPoint("TOPLEFT", 85, -10)
			centerDisplay.title.text:SetTextColor(1, 1, 1)
			centerDisplay.description.text:SetTextColor(.9, .9, .9)

			F.Reskin(centerDisplay.button)

			reward = suggestion.reward

			reward:HookScript("OnEnter", rewardOnEnter)
			reward.iconRing:Hide()
			reward.iconRingHighlight:SetTexture("")
			F.CreateBG(reward.icon)
		end
	end

	-- [[ Loot tab ]]

	F.Reskin(EncounterJournal.LootJournal.LegendariesFrame.ClassButton)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton:GetFontString():SetTextColor(1, 1, 1)
	select(5, EncounterJournal.LootJournal.LegendariesFrame.ClassButton:GetRegions()):Hide()
	select(6, EncounterJournal.LootJournal.LegendariesFrame.ClassButton:GetRegions()):Hide()
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.UpLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.UpRight:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.HighLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.HighRight:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.DownLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.ClassButton.DownRight:SetAlpha(0)

	F.Reskin(EncounterJournal.LootJournal.LegendariesFrame.SlotButton)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton:GetFontString():SetTextColor(1, 1, 1)
	select(5, EncounterJournal.LootJournal.LegendariesFrame.SlotButton:GetRegions()):Hide()
	select(6, EncounterJournal.LootJournal.LegendariesFrame.SlotButton:GetRegions()):Hide()
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.UpLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.UpRight:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.HighLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.HighRight:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.DownLeft:SetAlpha(0)
	EncounterJournal.LootJournal.LegendariesFrame.SlotButton.DownRight:SetAlpha(0)

	EncounterJournal.LootJournal:DisableDrawLayer("BACKGROUND")
	F.ReskinScroll(_G.EncounterJournalScrollBar)
	F.ReskinDropDown(_G.LootJournalViewDropDown)

	local itemsLeftSide = EncounterJournal.LootJournal.LegendariesFrame.buttons
	local itemsRightSide = EncounterJournal.LootJournal.LegendariesFrame.rightSideButtons
	for _, items in ipairs({itemsLeftSide, itemsRightSide}) do
		for i = 1, #items do
			local item = items[i]

			item.ItemType:SetTextColor(1, 1, 1)
			item.Background:Hide()

			item.Icon:SetPoint("TOPLEFT", 1, -1)

			item.Icon:SetTexCoord(.08, .92, .08, .92)
			item.Icon:SetDrawLayer("OVERLAY")
			F.CreateBG(item.Icon)

			local bg = CreateFrame("Frame", nil, item)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
			bg:SetFrameLevel(item:GetFrameLevel() - 1)
			F.CreateBD(bg, .25)
		end
	end

	F.Reskin(EncounterJournal.LootJournal.ItemSetsFrame.ClassButton)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton:GetFontString():SetTextColor(1, 1, 1)
	select(5, EncounterJournal.LootJournal.ItemSetsFrame.ClassButton:GetRegions()):Hide()
	select(6, EncounterJournal.LootJournal.ItemSetsFrame.ClassButton:GetRegions()):Hide()
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.UpLeft:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.UpRight:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.HighLeft:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.HighRight:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.DownLeft:SetAlpha(0)
	EncounterJournal.LootJournal.ItemSetsFrame.ClassButton.DownRight:SetAlpha(0)

	hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "UpdateList", function()
		local itemSets = EncounterJournal.LootJournal.ItemSetsFrame.buttons
		for i = 1, #itemSets do
			local itemSet = itemSets[i]

			itemSet.ItemLevel:SetTextColor(1, 1, 1)
			itemSet.Background:Hide()

			if not itemSet.bg then
				local bg = CreateFrame("Frame", nil, itemSet)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 1)
				bg:SetFrameLevel(itemSet:GetFrameLevel() - 1)
				F.CreateBD(bg, .25)
				itemSet.bg = bg
			end

			local items = itemSet.ItemButtons
			for j = 1, #items do
				local item = items[j]

				item.Border:Hide()
				item.Icon:SetPoint("TOPLEFT", 1, -1)

				item.Icon:SetTexCoord(.08, .92, .08, .92)
				item.Icon:SetDrawLayer("OVERLAY")
				F.CreateBG(item.Icon)
			end
		end
	end)

	-- Hook functions

	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = suggestFrame

		if #self.suggestions > 0 then
			local suggestion = self.Suggestion1
			local data = self.suggestions[1]

			suggestion.iconRing:Hide()

			if data.iconPath then
				suggestion.icon:SetMask("")
				suggestion.icon:SetTexture(data.iconPath)
				suggestion.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end

		if #self.suggestions > 1 then
			for i = 2, #self.suggestions do
				local suggestion = self["Suggestion"..i]
				if not suggestion then break end

				local data = self.suggestions[i]

				suggestion.iconRing:Hide()

				if data.iconPath then
					suggestion.icon:SetMask("")
					suggestion.icon:SetTexture(data.iconPath)
					suggestion.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
		local rewardData = suggestion.reward.data
		if rewardData then
			local texture = rewardData.itemIcon or rewardData.currencyIcon or [[Interface\Icons\achievement_guildperk_mobilebanking]]
			suggestion.reward.icon:SetMask("")
			suggestion.reward.icon:SetTexture(texture)
			suggestion.reward.icon:SetTexCoord(.08, .92, .08, .92)
		end
	end)
end
