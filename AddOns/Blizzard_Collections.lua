local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_Collections"] = function()
	local r, g, b = C.r, C.g, C.b

	-- [[ General ]]

	for i = 1, 14 do
		if i ~= 8 then
			select(i, _G.CollectionsJournal:GetRegions()):Hide()
		end
	end

	F.CreateBD(_G.CollectionsJournal)
	F.ReskinTab(_G.CollectionsJournalTab1)
	F.ReskinTab(_G.CollectionsJournalTab2)
	F.ReskinTab(_G.CollectionsJournalTab3)
	F.ReskinTab(_G.CollectionsJournalTab4)
	F.ReskinTab(_G.CollectionsJournalTab5)
	F.ReskinClose(_G.CollectionsJournalCloseButton)

	_G.CollectionsJournalTab2:SetPoint("LEFT", _G.CollectionsJournalTab1, "RIGHT", -15, 0)
	_G.CollectionsJournalTab3:SetPoint("LEFT", _G.CollectionsJournalTab2, "RIGHT", -15, 0)
	_G.CollectionsJournalTab4:SetPoint("LEFT", _G.CollectionsJournalTab3, "RIGHT", -15, 0)
	_G.CollectionsJournalTab5:SetPoint("LEFT", _G.CollectionsJournalTab4, "RIGHT", -15, 0)

	-- [[ Mounts and pets ]]

	local PetJournal = _G.PetJournal
	local MountJournal = _G.MountJournal

	for i = 1, 9 do
		select(i, MountJournal.MountCount:GetRegions()):Hide()
		select(i, PetJournal.PetCount:GetRegions()):Hide()
	end

	MountJournal.LeftInset:Hide()
	MountJournal.RightInset:Hide()
	PetJournal.LeftInset:Hide()
	PetJournal.RightInset:Hide()
	PetJournal.PetCardInset:Hide()
	PetJournal.loadoutBorder:Hide()
	MountJournal.MountDisplay.YesMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.NoMountsTex:SetAlpha(0)
	MountJournal.MountDisplay.ShadowOverlay:Hide()
	_G.PetJournalTutorialButton.Ring:Hide()

	F.CreateBD(MountJournal.MountCount, .25)
	F.CreateBD(PetJournal.PetCount, .25)
	F.CreateBD(MountJournal.MountDisplay.ModelFrame, .25)

	F.Reskin(_G.MountJournalMountButton)
	F.Reskin(_G.PetJournalSummonButton)
	F.Reskin(_G.PetJournalFindBattle)
	F.ReskinScroll(_G.MountJournalListScrollFrameScrollBar)
	F.ReskinScroll(_G.PetJournalListScrollFrameScrollBar)
	F.ReskinInput(_G.MountJournalSearchBox)
	F.ReskinInput(_G.PetJournalSearchBox)
	F.ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateLeftButton, "left")
	F.ReskinArrow(MountJournal.MountDisplay.ModelFrame.RotateRightButton, "right")
	F.ReskinFilterButton(_G.PetJournalFilterButton)
	F.ReskinFilterButton(_G.MountJournalFilterButton)

	_G.MountJournalFilterButton:SetPoint("TOPRIGHT", MountJournal.LeftInset, -5, -8)
	_G.PetJournalFilterButton:SetPoint("TOPRIGHT", _G.PetJournalLeftInset, -5, -8)

	_G.PetJournalTutorialButton:SetPoint("TOPLEFT", PetJournal, "TOPLEFT", -14, 14)

	local scrollFrames = {MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons}
	for _, scrollFrame in pairs(scrollFrames) do
		for i = 1, #scrollFrame do
			local bu = scrollFrame[i]
			local ic = bu.icon

			bu:GetRegions():Hide()
			bu:SetHighlightTexture("")
			bu.iconBorder:SetTexture("")
			bu.selectedTexture:SetTexture("")

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", 0, -1)
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			F.CreateBD(bg, .25)
			bu.bg = bg

			ic:SetTexCoord(.08, .92, .08, .92)
			ic.bg = F.CreateBG(ic)

			bu.name:SetParent(bg)

			if bu.DragButton then
				bu.DragButton.ActiveTexture:SetTexture(C.media.checked)
			else
				bu.dragButton.ActiveTexture:SetTexture(C.media.checked)
				bu.dragButton.levelBG:SetAlpha(0)
				bu.dragButton.level:SetFontObject(_G.GameFontNormal)
				bu.dragButton.level:SetTextColor(1, 1, 1)
			end
		end
	end

	local function updateMountScroll()
		local buttons = MountJournal.ListScrollFrame.buttons
		for i = 1, #buttons do
			local bu = buttons[i]
			if bu.index ~= nil then
				bu.bg:Show()
				bu.icon:Show()
				bu.icon.bg:Show()

				if bu.selectedTexture:IsShown() then
					bu.bg:SetBackdropColor(r, g, b, .25)
				else
					bu.bg:SetBackdropColor(0, 0, 0, .25)
				end
			else
				bu.bg:Hide()
				bu.icon:Hide()
				bu.icon.bg:Hide()
			end
		end
	end

	hooksecurefunc("MountJournal_UpdateMountList", updateMountScroll)
	hooksecurefunc(_G.MountJournalListScrollFrame, "update", updateMountScroll)

	local function updatePetScroll()
		local petButtons = PetJournal.listScroll.buttons
		if petButtons then
			for i = 1, #petButtons do
				local bu = petButtons[i]

				local index = bu.index
				if index then
					local petID, _, isOwned = _G.C_PetJournal.GetPetInfoByIndex(index)

					if petID and isOwned then
						local _, _, _, _, rarity = _G.C_PetJournal.GetPetStats(petID)

						if rarity then
							local color = _G.ITEM_QUALITY_COLORS[rarity-1]
							bu.name:SetTextColor(color.r, color.g, color.b)
						else
							bu.name:SetTextColor(1, 1, 1)
						end
					else
						bu.name:SetTextColor(.5, .5, .5)
					end

					if bu.selectedTexture:IsShown() then
						bu.bg:SetBackdropColor(r, g, b, .25)
					else
						bu.bg:SetBackdropColor(0, 0, 0, .25)
					end
				end
			end
		end
	end

	hooksecurefunc("PetJournal_UpdatePetList", updatePetScroll)
	hooksecurefunc(_G.PetJournalListScrollFrame, "update", updatePetScroll)

	_G.PetJournalHealPetButtonBorder:Hide()
	_G.PetJournalHealPetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	PetJournal.HealPetButton:SetPushedTexture("")
	F.CreateBG(PetJournal.HealPetButton)

	do
		local ic = MountJournal.MountDisplay.InfoButton.Icon
		ic:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(ic)
	end

	if _G.AuroraConfig.tooltips then
		for _, f in pairs({_G.PetJournalPrimaryAbilityTooltip, _G.PetJournalSecondaryAbilityTooltip}) do
			f:DisableDrawLayer("BACKGROUND")
			local bg = CreateFrame("Frame", nil, f)
			bg:SetAllPoints()
			bg:SetFrameLevel(0)
			F.CreateBD(bg)
		end
	end

	_G.PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
	_G.PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", _G.PetJournalLoadoutBorderTop, "TOP", 0, 4)

	-- Favourite mount button

	_G.MountJournalSummonRandomFavoriteButtonBorder:Hide()
	_G.MountJournalSummonRandomFavoriteButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	_G.MountJournalSummonRandomFavoriteButton:SetPushedTexture("")
	F.CreateBG(_G.MountJournalSummonRandomFavoriteButton)

	-- Pet card

	local card = _G.PetJournalPetCard

	_G.PetJournalPetCardBG:Hide()
	card.PetInfo.levelBG:SetAlpha(0)
	card.PetInfo.qualityBorder:SetAlpha(0)
	card.AbilitiesBG1:SetAlpha(0)
	card.AbilitiesBG2:SetAlpha(0)
	card.AbilitiesBG3:SetAlpha(0)

	card.PetInfo.level:SetFontObject(_G.GameFontNormal)
	card.PetInfo.level:SetTextColor(1, 1, 1)

	card.PetInfo.icon:SetTexCoord(.08, .92, .08, .92)
	card.PetInfo.icon.bg = F.CreateBG(card.PetInfo.icon)

	F.CreateBD(card, .25)

	for i = 2, 12 do
		select(i, card.xpBar:GetRegions()):Hide()
	end

	card.xpBar:SetStatusBarTexture(C.media.backdrop)
	F.CreateBDFrame(card.xpBar, .25)

	_G.PetJournalPetCardHealthFramehealthStatusBarLeft:Hide()
	_G.PetJournalPetCardHealthFramehealthStatusBarRight:Hide()
	_G.PetJournalPetCardHealthFramehealthStatusBarMiddle:Hide()
	_G.PetJournalPetCardHealthFramehealthStatusBarBGMiddle:Hide()

	card.HealthFrame.healthBar:SetStatusBarTexture(C.media.backdrop)
	F.CreateBDFrame(card.HealthFrame.healthBar, .25)

	for i = 1, 6 do
		local bu = card["spell"..i]

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(bu.icon)
	end

	hooksecurefunc("PetJournal_UpdatePetCard", function(self)
		local petInfo = self.PetInfo
		local red, green, blue

		if petInfo.qualityBorder:IsShown() then
			red, green, blue = petInfo.qualityBorder:GetVertexColor()
		else
			red, green, blue = 0, 0, 0
		end

		petInfo.icon.bg:SetVertexColor(red, green, blue)
	end)

	-- Pet loadout

	for i = 1, 3 do
		local bu = PetJournal.Loadout["Pet"..i]

		_G["PetJournalLoadoutPet"..i.."BG"]:Hide()

		bu.iconBorder:SetAlpha(0)
		bu.qualityBorder:SetTexture("")
		bu.levelBG:SetAlpha(0)
		bu.helpFrame:GetRegions():Hide()

		bu.level:SetFontObject(_G.GameFontNormal)
		bu.level:SetTextColor(1, 1, 1)

		bu.icon:SetTexCoord(.08, .92, .08, .92)
		bu.icon.bg = F.CreateBDFrame(bu.icon, .25)

		bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
		bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)

		F.CreateBD(bu, .25)

		for j = 2, 12 do
			select(j, bu.xpBar:GetRegions()):Hide()
		end

		bu.xpBar:SetStatusBarTexture(C.media.backdrop)
		F.CreateBDFrame(bu.xpBar, .25)

		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarLeft"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarRight"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarMiddle"]:Hide()
		_G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarBGMiddle"]:Hide()

		bu.healthFrame.healthBar:SetStatusBarTexture(C.media.backdrop)
		F.CreateBDFrame(bu.healthFrame.healthBar, .25)

		for j = 1, 3 do
			local spell = bu["spell"..j]

			spell:SetPushedTexture("")

			spell.selected:SetTexture(C.media.checked)

			spell:GetRegions():Hide()

			spell.FlyoutArrow:SetTexture(C.media.arrowDown)
			spell.FlyoutArrow:SetSize(8, 8)
			spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

			spell.icon:SetTexCoord(.08, .92, .08, .92)
			F.CreateBG(spell.icon)
		end
	end

	hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local bu = PetJournal.Loadout["Pet"..i]

			bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
			bu.icon.bg:SetBackdropBorderColor(bu.qualityBorder:GetVertexColor())

			bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
		end
	end)

	PetJournal.SpellSelect.BgEnd:Hide()
	PetJournal.SpellSelect.BgTiled:Hide()

	for i = 1, 2 do
		local bu = PetJournal.SpellSelect["Spell"..i]

		bu:SetCheckedTexture(C.media.checked)
		bu:SetPushedTexture("")

		bu.icon:SetDrawLayer("ARTWORK")
		bu.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(bu.icon)
	end

	-- [[ Toy box ]]

	local ToyBox = _G.ToyBox

	local toyIcons = ToyBox.iconsFrame
	toyIcons.Bg:Hide()
	toyIcons.BackgroundTile:Hide()
	toyIcons:DisableDrawLayer("BORDER")
	toyIcons:DisableDrawLayer("ARTWORK")
	toyIcons:DisableDrawLayer("OVERLAY")

	F.ReskinInput(ToyBox.searchBox)
	F.ReskinFilterButton(_G.ToyBoxFilterButton)
	F.ReskinArrow(ToyBox.navigationFrame.prevPageButton, "left")
	F.ReskinArrow(ToyBox.navigationFrame.nextPageButton, "right")

	ToyBox.navigationFrame.prevPageButton:SetPoint("BOTTOMRIGHT", -320, 51)
	ToyBox.navigationFrame.nextPageButton:SetPoint("BOTTOMRIGHT", -285, 51)

	-- Progress bar

	local toyProgress = ToyBox.progressBar
	toyProgress.border:Hide()
	toyProgress:DisableDrawLayer("BACKGROUND")

	toyProgress.text:SetPoint("CENTER", 0, 1)
	toyProgress:SetStatusBarTexture(C.media.backdrop)

	F.CreateBDFrame(toyProgress, .25)

	-- Toys!

	local shouldChangeTextColor = true

	local changeTextColor = function(toyString)
		if shouldChangeTextColor then
			shouldChangeTextColor = false

			local self = toyString:GetParent()

			if _G.PlayerHasToy(self.itemID) then
				local _, _, quality = _G.GetItemInfo(self.itemID)
				if quality then
					toyString:SetTextColor(_G.GetItemQualityColor(quality))
				else
					toyString:SetTextColor(1, 1, 1)
				end
			else
				toyString:SetTextColor(.5, .5, .5)
			end

			shouldChangeTextColor = true
		end
	end

	local buttons = ToyBox.iconsFrame
	for i = 1, 18 do
		local bu = buttons["spellButton"..i]
		local ic = bu.iconTexture

		bu:SetPushedTexture("")
		bu:SetHighlightTexture("")

		bu.cooldown:SetAllPoints(ic)

		bu.slotFrameCollected:SetTexture("")
		bu.slotFrameUncollected:SetTexture("")

		ic:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(ic)

		hooksecurefunc(bu.name, "SetTextColor", changeTextColor)
	end

	-- [[ Heirlooms ]]

	local HeirloomsJournal = _G.HeirloomsJournal

	local heirloomIcons = HeirloomsJournal.iconsFrame
	heirloomIcons.Bg:Hide()
	heirloomIcons.BackgroundTile:Hide()
	heirloomIcons:DisableDrawLayer("BORDER")
	heirloomIcons:DisableDrawLayer("ARTWORK")
	heirloomIcons:DisableDrawLayer("OVERLAY")

	F.ReskinInput(_G.HeirloomsJournalSearchBox)
	F.ReskinDropDown(_G.HeirloomsJournalClassDropDown)
	F.ReskinFilterButton(_G.HeirloomsJournalFilterButton)
	F.ReskinArrow(HeirloomsJournal.navigationFrame.prevPageButton, "left")
	F.ReskinArrow(HeirloomsJournal.navigationFrame.nextPageButton, "right")

	HeirloomsJournal.navigationFrame.prevPageButton:SetPoint("BOTTOMRIGHT", -320, 51)
	HeirloomsJournal.navigationFrame.nextPageButton:SetPoint("BOTTOMRIGHT", -285, 51)

	-- Progress bar

	local heirloomProgress = HeirloomsJournal.progressBar
	heirloomProgress.border:Hide()
	heirloomProgress:DisableDrawLayer("BACKGROUND")

	heirloomProgress.text:SetPoint("CENTER", 0, 1)
	heirloomProgress:SetStatusBarTexture(C.media.backdrop)

	F.CreateBDFrame(heirloomProgress, .25)

	-- Buttons

	hooksecurefunc("HeirloomsJournal_UpdateButton", function(button)
		if not button.styled then
			local ic = button.iconTexture

			button.slotFrameCollected:SetTexture("")
			button.slotFrameUncollected:SetTexture("")
			button.levelBackground:SetAlpha(0)

			button.iconTextureUncollected:SetTexCoord(.08, .92, .08, .92)
			button.bg = F.ReskinIcon(ic)

			button.level:ClearAllPoints()
			button.level:SetPoint("BOTTOM", 0, 1)

			local newLevelBg = button:CreateTexture(nil, "OVERLAY")
			newLevelBg:SetColorTexture(0, 0, 0, .5)
			newLevelBg:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 4, 5)
			newLevelBg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 5)
			newLevelBg:SetHeight(11)
			button.newLevelBg = newLevelBg

			button.styled = true
		end

		if button.iconTexture:IsShown() then
			button.name:SetTextColor(1, 1, 1)
			button.bg:SetVertexColor(.9, .8, .5)
			button.newLevelBg:Show()
		else
			button.name:SetTextColor(.5, .5, .5)
			button.bg:SetVertexColor(0, 0, 0)
			button.newLevelBg:Hide()
		end
	end)

	hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function()
		for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
			local header = HeirloomsJournal.heirloomHeaderFrames[i]
			if not header.styled then
				header.text:SetTextColor(1, 1, 1)
				header.text:SetFont(C.media.font, 16)

				header.styled = true
			end
		end

		for i = 1, #HeirloomsJournal.heirloomEntryFrames do
			local button = HeirloomsJournal.heirloomEntryFrames[i]

			if button.iconTexture:IsShown() then
				button.name:SetTextColor(1, 1, 1)
				button.bg:SetVertexColor(.9, .8, .5)
				button.newLevelBg:Show()
			else
				button.name:SetTextColor(.5, .5, .5)
				button.bg:SetVertexColor(0, 0, 0)
				button.newLevelBg:Hide()
			end
		end
	end)

	-- [[ WardrobeCollection ]]

	local WardrobeCollectionFrame = _G.WardrobeCollectionFrame
	local ModelsFrame = WardrobeCollectionFrame.ModelsFrame

	_G.WardrobeCollectionFrameBg:Hide()
	ModelsFrame:DisableDrawLayer("BACKGROUND")
	ModelsFrame:DisableDrawLayer("BORDER")
	ModelsFrame:DisableDrawLayer("ARTWORK")
	ModelsFrame:DisableDrawLayer("OVERLAY")

	F.ReskinInput(_G.WardrobeCollectionFrameSearchBox)
	F.ReskinFilterButton(_G.WardrobeCollectionFrame.FilterButton)
	F.ReskinDropDown(_G.WardrobeCollectionFrameWeaponDropDown)
	F.ReskinArrow(WardrobeCollectionFrame.NavigationFrame.PrevPageButton, "left")
	F.ReskinArrow(WardrobeCollectionFrame.NavigationFrame.NextPageButton, "right")

	WardrobeCollectionFrame.NavigationFrame.PrevPageButton:SetPoint("BOTTOM", 23, 51)
	WardrobeCollectionFrame.NavigationFrame.NextPageButton:SetPoint("BOTTOM", 58, 51)

	-- Progress bar

	local progressBar = WardrobeCollectionFrame.progressBar
	progressBar.borderLeft:Hide()
	progressBar.borderMid:Hide()
	progressBar.borderRight:Hide()
	progressBar:DisableDrawLayer("BACKGROUND")

	progressBar.text:SetPoint("CENTER", 0, 1)
	progressBar:SetStatusBarTexture(C.media.backdrop)

	F.CreateBDFrame(progressBar, .25)

	-- [[ Wardrobe ]]

	local WardrobeFrame = _G.WardrobeFrame
	local WardrobeTransmogFrame = _G.WardrobeTransmogFrame

	_G.WardrobeTransmogFrameBg:Hide()
	WardrobeTransmogFrame.Inset.BG:Hide()
	WardrobeTransmogFrame.Inset:DisableDrawLayer("BORDER")
	WardrobeTransmogFrame.MoneyLeft:Hide()
	WardrobeTransmogFrame.MoneyMiddle:Hide()
	WardrobeTransmogFrame.MoneyRight:Hide()
	WardrobeTransmogFrame.SpecButton.Icon:Hide()

	for i = 1, 9 do
		select(i, WardrobeTransmogFrame.SpecButton:GetRegions()):Hide()
	end

	F.ReskinPortraitFrame(WardrobeFrame)
	F.Reskin(WardrobeTransmogFrame.ApplyButton)
	F.Reskin(_G.WardrobeOutfitDropDown.SaveButton)
	F.ReskinArrow(_G.WardrobeTransmogFrame.SpecButton, "down")
	F.ReskinDropDown(_G.WardrobeOutfitDropDown)

	_G.WardrobeOutfitDropDown:SetHeight(32)
	_G.WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT", _G.WardrobeOutfitDropDown, "RIGHT", -13, 2)
	WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

	local slots = {"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Back", "Shirt", "Tabard", "MainHand", "SecondaryHand"}

	for i = 1, #slots do
		local slot = WardrobeTransmogFrame.Model[slots[i].."Button"]
		if slot then
			slot.Border:Hide()
			slot.Icon:SetDrawLayer("BACKGROUND", 1)
			F.ReskinIcon(slot.Icon)
		end
	end
end
