local _, private = ...

-- [[ Lua Globals ]]
local select, next = _G.select, _G.next

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_AchievementUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.CreateBD(_G.AchievementFrame)
	_G.AchievementFrameCategories:SetBackdrop(nil)
	_G.AchievementFrameSummary:SetBackdrop(nil)
	for i = 1, 17 do
		select(i, _G.AchievementFrame:GetRegions()):Hide()
	end
	_G.AchievementFrameSummaryBackground:Hide()
	_G.AchievementFrameSummary:GetChildren():Hide()
	_G.AchievementFrameCategoriesContainerScrollBarBG:SetAlpha(0)
	for i = 1, 4 do
		select(i, _G.AchievementFrameHeader:GetRegions()):Hide()
	end
	_G.AchievementFrameHeaderLeftDDLInset:SetAlpha(0)
	_G.AchievementFrameHeaderRightDDLInset:SetAlpha(0)
	select(2, _G.AchievementFrameAchievements:GetChildren()):Hide()
	_G.AchievementFrameAchievementsBackground:Hide()
	select(3, _G.AchievementFrameAchievements:GetRegions()):Hide()
	_G.AchievementFrameStatsBG:Hide()
	_G.AchievementFrameSummaryAchievementsHeaderHeader:Hide()
	_G.AchievementFrameSummaryCategoriesHeaderTexture:Hide()
	select(3, _G.AchievementFrameStats:GetChildren()):Hide()
	select(5, _G.AchievementFrameComparison:GetChildren()):Hide()
	_G.AchievementFrameComparisonHeaderBG:Hide()
	_G.AchievementFrameComparisonHeaderPortrait:Hide()
	_G.AchievementFrameComparisonHeaderPortraitBg:Hide()
	_G.AchievementFrameComparisonBackground:Hide()
	_G.AchievementFrameComparisonDark:SetAlpha(0)
	_G.AchievementFrameComparisonSummaryPlayerBackground:Hide()
	_G.AchievementFrameComparisonSummaryFriendBackground:Hide()

	do
		local first = true
		hooksecurefunc("AchievementFrameCategories_Update", function()
			if first then
				for i = 1, 19 do
					local bu = _G["AchievementFrameCategoriesContainerButton"..i]

					bu.background:Hide()

					local bg = F.CreateBDFrame(bu, .25)
					bg:SetPoint("TOPLEFT", 0, -1)
					bg:SetPoint("BOTTOMRIGHT")

					bu:SetHighlightTexture(C.media.backdrop)
					local hl = bu:GetHighlightTexture()
					hl:SetVertexColor(r, g, b, .2)
					hl:SetPoint("TOPLEFT", 1, -2)
					hl:SetPoint("BOTTOMRIGHT", -1, 1)
				end
				first = false
			end
		end)
	end

	_G.AchievementFrameHeaderPoints:SetPoint("TOP", _G.AchievementFrame, "TOP", 0, -6)
	_G.AchievementFrameFilterDropDown:SetPoint("TOPLEFT", 148, 1)
	_G.AchievementFrameFilterDropDown:SetPoint("TOPLEFT", 148, 1)
	_G.AchievementFrame.searchBox:ClearAllPoints()
	_G.AchievementFrame.searchBox:SetPoint("TOPRIGHT", -98, -3)
	F.ReskinInput(_G.AchievementFrame.searchBox, 20)

	local function SkinSearchPreview(btn)
		btn:SetNormalTexture(C.media.backdrop)
		btn:GetNormalTexture():SetVertexColor(0.1, 0.1, 0.1, .9)
		btn:SetPushedTexture(C.media.backdrop)
		btn:GetPushedTexture():SetVertexColor(0.1, 0.1, 0.1, .9)
	end
	for i = 1, 5 do
		local btn = _G.AchievementFrame["searchPreview"..i]
		SkinSearchPreview(btn)
		btn.iconFrame:SetAlpha(0)
		F.ReskinIcon(btn.icon)
	end
	SkinSearchPreview(_G.AchievementFrame.showAllSearchResults)

	local prevContainer = _G.AchievementFrame.searchPreviewContainer
	prevContainer:DisableDrawLayer("OVERLAY")
	local prevContainerBG = _G.CreateFrame("Frame", nil, prevContainer)
	prevContainerBG:SetPoint("TOPRIGHT", 1, 1)
	prevContainerBG:SetPoint("BOTTOMLEFT", prevContainer.borderAnchor, 6, 4)
	prevContainerBG:SetFrameLevel(prevContainer:GetFrameLevel() - 1)
	F.CreateBD(prevContainerBG)
	_G.AchievementFrameFilterDropDownText:ClearAllPoints()
	_G.AchievementFrameFilterDropDownText:SetPoint("CENTER", -10, 1)
	F.ReskinDropDown(_G.AchievementFrameFilterDropDown)

	_G.AchievementFrameSummaryCategoriesStatusBar:SetStatusBarTexture(C.media.backdrop)
	_G.AchievementFrameSummaryCategoriesStatusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
	_G.AchievementFrameSummaryCategoriesStatusBarLeft:Hide()
	_G.AchievementFrameSummaryCategoriesStatusBarMiddle:Hide()
	_G.AchievementFrameSummaryCategoriesStatusBarRight:Hide()
	_G.AchievementFrameSummaryCategoriesStatusBarFillBar:Hide()
	_G.AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)
	_G.AchievementFrameSummaryCategoriesStatusBarTitle:SetPoint("LEFT", _G.AchievementFrameSummaryCategoriesStatusBar, "LEFT", 6, 0)
	_G.AchievementFrameSummaryCategoriesStatusBarText:SetPoint("RIGHT", _G.AchievementFrameSummaryCategoriesStatusBar, "RIGHT", -5, 0)

	local catStatusBG = CreateFrame("Frame", nil, _G.AchievementFrameSummaryCategoriesStatusBar)
	catStatusBG:SetPoint("TOPLEFT", -1, 1)
	catStatusBG:SetPoint("BOTTOMRIGHT", 1, -1)
	catStatusBG:SetFrameLevel(_G.AchievementFrameSummaryCategoriesStatusBar:GetFrameLevel()-1)
	F.CreateBD(catStatusBG, .25)

	for i = 1, 3 do
		local tab = _G["AchievementFrameTab"..i]
		if tab then
			F.ReskinTab(tab)
		end
	end

	for i = 1, 7 do
		local bu = _G["AchievementFrameAchievementsContainerButton"..i]
		bu:DisableDrawLayer("BORDER")
		bu.background:Hide()

		_G["AchievementFrameAchievementsContainerButton"..i.."TitleBackground"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."Glow"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."RewardBackground"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."PlusMinus"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."Highlight"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."IconOverlay"]:Hide()
		_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerL"]:SetAlpha(0)
		_G["AchievementFrameAchievementsContainerButton"..i.."GuildCornerR"]:SetAlpha(0)

		bu.description:SetTextColor(.9, .9, .9)
		bu.description.SetTextColor = F.dummy
		bu.description:SetShadowOffset(1, -1)
		bu.description.SetShadowOffset = F.dummy

		local bg = F.CreateBDFrame(bu, .25)
		bg:SetPoint("TOPLEFT", 1, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 2)

		bu.icon.texture:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(bu.icon.texture)

		-- can't get a backdrop frame to appear behind the checked texture for some reason

		local ch = bu.tracked

		ch:SetNormalTexture("")
		ch:SetPushedTexture("")
		ch:SetHighlightTexture(C.media.backdrop)

		local hl = ch:GetHighlightTexture()
		hl:SetPoint("TOPLEFT", 4, -4)
		hl:SetPoint("BOTTOMRIGHT", -4, 4)
		hl:SetVertexColor(r, g, b, .2)

		local check = ch:GetCheckedTexture()
		check:SetDesaturated(true)
		check:SetVertexColor(r, g, b)

		local tex = F.CreateGradient(ch)
		tex:SetPoint("TOPLEFT", 4, -4)
		tex:SetPoint("BOTTOMRIGHT", -4, 4)

		local left = ch:CreateTexture(nil, "BACKGROUND")
		left:SetWidth(1)
		left:SetColorTexture(0, 0, 0)
		left:SetPoint("TOPLEFT", tex, -1, 1)
		left:SetPoint("BOTTOMLEFT", tex, -1, -1)

		local right = ch:CreateTexture(nil, "BACKGROUND")
		right:SetWidth(1)
		right:SetColorTexture(0, 0, 0)
		right:SetPoint("TOPRIGHT", tex, 1, 1)
		right:SetPoint("BOTTOMRIGHT", tex, 1, -1)

		local top = ch:CreateTexture(nil, "BACKGROUND")
		top:SetHeight(1)
		top:SetColorTexture(0, 0, 0)
		top:SetPoint("TOPLEFT", tex, -1, 1)
		top:SetPoint("TOPRIGHT", tex, 1, -1)

		local bottom = ch:CreateTexture(nil, "BACKGROUND")
		bottom:SetHeight(1)
		bottom:SetColorTexture(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", tex, -1, -1)
		bottom:SetPoint("BOTTOMRIGHT", tex, 1, -1)
	end

	_G.AchievementFrameAchievementsContainerButton1.background:SetPoint("TOPLEFT", _G.AchievementFrameAchievementsContainerButton1, "TOPLEFT", 2, -3)

	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement)
		local _, _, _, completed = _G.GetAchievementInfo(category, achievement)
		if completed then
			if button.accountWide then
				button.label:SetTextColor(0, .6, 1)
			else
				button.label:SetTextColor(.9, .9, .9)
			end
		else
			if button.accountWide then
				button.label:SetTextColor(0, .3, .5)
			else
				button.label:SetTextColor(.65, .65, .65)
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		for i = 1, _G.GetAchievementNumCriteria(id) do
			local name = _G["AchievementFrameCriteria"..i.."Name"]
			if name and select(2, name:GetTextColor()) == 0 then
				name:SetTextColor(1, 1, 1)
			end

			local bu = _G["AchievementFrameMeta"..i]
			if bu and select(2, bu.label:GetTextColor()) == 0 then
				bu.label:SetTextColor(1, 1, 1)
			end
		end
	end)

	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local bar = _G["AchievementFrameProgressBar"..index]
		if not bar.reskinned then
			bar:SetStatusBarTexture(C.media.backdrop)

			_G["AchievementFrameProgressBar"..index.."BG"]:SetColorTexture(0, 0, 0, .25)
			_G["AchievementFrameProgressBar"..index.."BorderLeft"]:Hide()
			_G["AchievementFrameProgressBar"..index.."BorderCenter"]:Hide()
			_G["AchievementFrameProgressBar"..index.."BorderRight"]:Hide()

			local bg = CreateFrame("Frame", nil, bar)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			F.CreateBD(bg, 0)

			bar.reskinned = true
		end
	end)

	-- this is hidden behind other stuff in default UI
	_G.AchievementFrameSummaryAchievementsEmptyText:SetText("")

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local bu = _G["AchievementFrameSummaryAchievement"..i]

			if bu.accountWide then
				bu.label:SetTextColor(0, .6, 1)
			else
				bu.label:SetTextColor(.9, .9, .9)
			end

			if not bu.reskinned then
				bu:DisableDrawLayer("BORDER")

				local bd = _G["AchievementFrameSummaryAchievement"..i.."Background"]

				bd:SetTexture(C.media.backdrop)
				bd:SetVertexColor(0, 0, 0, .25)

				_G["AchievementFrameSummaryAchievement"..i.."TitleBackground"]:Hide()
				_G["AchievementFrameSummaryAchievement"..i.."Glow"]:Hide()
				_G["AchievementFrameSummaryAchievement"..i.."Highlight"]:SetAlpha(0)
				_G["AchievementFrameSummaryAchievement"..i.."IconOverlay"]:Hide()

				local text = _G["AchievementFrameSummaryAchievement"..i.."Description"]
				text:SetTextColor(.9, .9, .9)
				text.SetTextColor = F.dummy
				text:SetShadowOffset(1, -1)
				text.SetShadowOffset = F.dummy

				local bg = CreateFrame("Frame", nil, bu)
				bg:SetPoint("TOPLEFT", 2, -2)
				bg:SetPoint("BOTTOMRIGHT", -2, 2)
				F.CreateBD(bg, 0)

				local ic = _G["AchievementFrameSummaryAchievement"..i.."IconTexture"]
				ic:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(ic)

				bu.reskinned = true
			end
		end
	end)

	for i = 1, 12 do
		local bu = _G["AchievementFrameSummaryCategoriesCategory"..i]
		local label = _G["AchievementFrameSummaryCategoriesCategory"..i.."Label"]

		_G["AchievementFrameSummaryCategoriesCategory"..i.."Left"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Middle"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."Right"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."FillBar"]:Hide()
		_G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]:SetAlpha(0)

		bu:SetStatusBarTexture(C.media.backdrop)
		bu:GetStatusBarTexture():SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
		label:SetTextColor(1, 1, 1)
		label:SetPoint("LEFT", bu, "LEFT", 6, 0)

		bu.text:SetPoint("RIGHT", bu, "RIGHT", -5, 0)

		F.CreateBDFrame(bu, .25)
	end

	for i = 1, 20 do
		_G["AchievementFrameStatsContainerButton"..i.."BG"]:Hide()
		_G["AchievementFrameStatsContainerButton"..i.."BG"].Show = F.dummy
		_G["AchievementFrameStatsContainerButton"..i.."HeaderLeft"]:SetAlpha(0)
		_G["AchievementFrameStatsContainerButton"..i.."HeaderMiddle"]:SetAlpha(0)
		_G["AchievementFrameStatsContainerButton"..i.."HeaderRight"]:SetAlpha(0)
	end

	_G.AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", _G.AchievementFrameComparison, "TOPRIGHT", 39, 25)

	local headerbg = CreateFrame("Frame", nil, _G.AchievementFrameComparisonHeader)
	headerbg:SetPoint("TOPLEFT", 20, -20)
	headerbg:SetPoint("BOTTOMRIGHT", -28, -5)
	headerbg:SetFrameLevel(_G.AchievementFrameComparisonHeader:GetFrameLevel()-1)
	F.CreateBD(headerbg, .25)

	local summaries = {"AchievementFrameComparisonSummaryPlayer", "AchievementFrameComparisonSummaryFriend"}
	for i = 1, #summaries do
		local frame = _G[summaries[i]]
		frame:SetBackdrop(nil)
		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 2, -2)
		bg:SetPoint("BOTTOMRIGHT", -2, 0)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .25)
	end

	local bars = {"AchievementFrameComparisonSummaryPlayerStatusBar", "AchievementFrameComparisonSummaryFriendStatusBar"}
	for i = 1, #bars do
		local bar = _G[bars[i]]
		local name = bar:GetName()
		bar:SetStatusBarTexture(C.media.backdrop)
		bar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .4, 0, 0, .6, 0)
		_G[name.."Left"]:Hide()
		_G[name.."Middle"]:Hide()
		_G[name.."Right"]:Hide()
		_G[name.."FillBar"]:Hide()
		_G[name.."Title"]:SetTextColor(1, 1, 1)
		_G[name.."Title"]:SetPoint("LEFT", bar, "LEFT", 6, 0)
		_G[name.."Text"]:SetPoint("RIGHT", bar, "RIGHT", -5, 0)

		local bg = CreateFrame("Frame", nil, bar)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bar:GetFrameLevel()-1)
		F.CreateBD(bg, .25)
	end

	for i = 1, 9 do
		local buttons = {_G["AchievementFrameComparisonContainerButton"..i.."Player"], _G["AchievementFrameComparisonContainerButton"..i.."Friend"]}

		for _, button in next, buttons do
			button:DisableDrawLayer("BORDER")
			local bg = CreateFrame("Frame", nil, button)
			bg:SetPoint("TOPLEFT", 2, -3)
			bg:SetPoint("BOTTOMRIGHT", -2, 2)
			F.CreateBD(bg, 0)
		end

		local playerBG = _G["AchievementFrameComparisonContainerButton"..i.."PlayerBackground"]
		playerBG:SetTexture(C.media.backdrop)
		playerBG:SetVertexColor(0, 0, 0, .25)

		local friendBG = _G["AchievementFrameComparisonContainerButton"..i.."FriendBackground"]
		friendBG:SetTexture(C.media.backdrop)
		friendBG:SetVertexColor(0, 0, 0, .25)

		local text = _G["AchievementFrameComparisonContainerButton"..i.."PlayerDescription"]
		text:SetTextColor(.9, .9, .9)
		text.SetTextColor = F.dummy
		text:SetShadowOffset(1, -1)
		text.SetShadowOffset = F.dummy

		_G["AchievementFrameComparisonContainerButton"..i.."PlayerTitleBackground"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."PlayerGlow"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."PlayerIconOverlay"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendTitleBackground"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendGlow"]:Hide()
		_G["AchievementFrameComparisonContainerButton"..i.."FriendIconOverlay"]:Hide()

		local playerIcon = _G["AchievementFrameComparisonContainerButton"..i.."PlayerIconTexture"]
		playerIcon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(playerIcon)

		local friendIcon = _G["AchievementFrameComparisonContainerButton"..i.."FriendIconTexture"]
		friendIcon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(friendIcon)
	end

	F.ReskinClose(_G.AchievementFrameCloseButton)
	F.ReskinScroll(_G.AchievementFrameAchievementsContainerScrollBar)
	F.ReskinScroll(_G.AchievementFrameStatsContainerScrollBar)
	F.ReskinScroll(_G.AchievementFrameCategoriesContainerScrollBar)
	F.ReskinScroll(_G.AchievementFrameComparisonContainerScrollBar)
end
