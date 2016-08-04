local F, C = unpack(select(2, ...))

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

C.themes["Blizzard_TradeSkillUI"] = function()
	F.ReskinPortraitFrame(TradeSkillFrame)

	local rankFrame = TradeSkillFrame.RankFrame
	rankFrame.BorderLeft:Hide()
	rankFrame.BorderRight:Hide()
	rankFrame.BorderMid:Hide()
	--rankFrame.Background:Hide()
	rankFrame:SetStatusBarTexture(C.media.backdrop)
	rankFrame.SetStatusBarColor = F.dummy
	rankFrame:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)
	F.CreateBDFrame(rankFrame)

	F.ReskinInput(TradeSkillFrame.SearchBox)
	F.ReskinFilterButton(TradeSkillFrame.FilterButton)
	TradeSkillFrame.FilterButton:SetPoint("TOPRIGHT", -7, -55)

	F.ReskinArrow(TradeSkillFrame.LinkToButton, "right")
	TradeSkillFrame.LinkToButton:SetPoint("BOTTOMRIGHT", TradeSkillFrame.FilterButton, "TOPRIGHT", 0, 6)

	--[[ Recipe List ]]--
	local recipeInset = TradeSkillFrame.RecipeInset
	recipeInset.Bg:Hide()
	recipeInset:DisableDrawLayer("BORDER")
	local recipeList = TradeSkillFrame.RecipeList
	F.ReskinScroll(recipeList.scrollBar, "TradeSkillFrame")

	hooksecurefunc(recipeList, "RefreshDisplay", function(self)
		for i = 1, #self.buttons do
			local tradeSkillButton = self.buttons[i]
			if not tradeSkillButton._isSkinned then
				local bg = CreateFrame("Frame", nil, tradeSkillButton)
				F.CreateBD(bg, .0)
				F.CreateGradient(bg)
				bg:SetSize(15, 15)
				bg:SetPoint("TOPLEFT", tradeSkillButton:GetNormalTexture())
				tradeSkillButton:SetHighlightTexture("")
				tradeSkillButton:SetPushedTexture("")
				tradeSkillButton:SetNormalTexture("")
				tradeSkillButton.SetNormalTexture = function(self, texture)
					if texture == "" then
						bg:Hide()
					else
						bg:Show()
					end
				end

				tradeSkillButton.minus = bg:CreateTexture(nil, "ARTWORK")
				tradeSkillButton.minus:SetSize(7, 1)
				tradeSkillButton.minus:SetPoint("CENTER")
				tradeSkillButton.minus:SetTexture(C.media.backdrop)
				tradeSkillButton.minus:SetVertexColor(1, 1, 1)

				tradeSkillButton.plus = bg:CreateTexture(nil, "ARTWORK")
				tradeSkillButton.plus:SetSize(1, 7)
				tradeSkillButton.plus:SetPoint("CENTER")
				tradeSkillButton.plus:SetTexture(C.media.backdrop)
				tradeSkillButton.plus:SetVertexColor(1, 1, 1)

				tradeSkillButton:HookScript("OnEnter", F.colourExpandOrCollapse)
				tradeSkillButton:HookScript("OnLeave", F.clearExpandOrCollapse)

				tradeSkillButton._isSkinned = true
			end
		end
	end)

	for _, tab in pairs({TradeSkillFrame.RecipeList.LearnedTab, TradeSkillFrame.RecipeList.UnlearnedTab}) do
		tab.LeftDisabled:SetAlpha(0)
		tab.MiddleDisabled:SetAlpha(0)
		tab.RightDisabled:SetAlpha(0)

		tab.Left:SetAlpha(0)
		tab.Middle:SetAlpha(0)
		tab.Right:SetAlpha(0)

		tab.Text:SetPoint("CENTER")
		tab.Text:SetTextColor(1, 1, 1)

		tab:HookScript("OnEnable", onEnable)
		tab:HookScript("OnDisable", onDisable)
		tab:HookScript("OnClick", onClick)

		tab:SetHeight(25)
		tab.SetHeight = function() end

		F.Reskin(tab)
	end

	TradeSkillFrame.RecipeList.LearnedTab:SetBackdropColor(r, g, b, .2)

	--[[ Recipe Details ]]--
	local detailsInset = TradeSkillFrame.DetailsInset
	detailsInset.Bg:Hide()
	detailsInset:DisableDrawLayer("BORDER")
	local detailsFrame = TradeSkillFrame.DetailsFrame
	detailsFrame.Background:Hide()
	F.ReskinScroll(detailsFrame.ScrollBar, "TradeSkillFrame")
	F.Reskin(detailsFrame.CreateAllButton)
	F.Reskin(detailsFrame.ViewGuildCraftersButton)
	F.Reskin(detailsFrame.ExitButton)
	F.Reskin(detailsFrame.CreateButton)
	F.ReskinInput(detailsFrame.CreateMultipleInputBox)
	detailsFrame.CreateMultipleInputBox:DisableDrawLayer("BACKGROUND")
	F.ReskinArrow(detailsFrame.CreateMultipleInputBox.IncrementButton, "right")
	F.ReskinArrow(detailsFrame.CreateMultipleInputBox.DecrementButton, "left")

	local contents = detailsFrame.Contents
	contents.ResultIcon.Background:Hide()
	hooksecurefunc(contents.ResultIcon, "SetNormalTexture", function(self)
		if not self._isSkinned then
			F.ReskinIcon(self:GetNormalTexture())
			self._isSkinned = true
		end
	end)
	for i = 1, #contents.Reagents do
		local reagent = contents.Reagents[i]
		F.ReskinIcon(reagent.Icon)
		reagent.NameFrame:Hide()
		local bg = F.CreateBDFrame(reagent.NameFrame, .2)
		bg:SetPoint("TOPLEFT", reagent.Icon, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -4, 0)
	end
end
