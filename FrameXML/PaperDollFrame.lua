local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select, next = _G.select, _G.next

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	local r, g, b = C.r, C.g, C.b
	local classDisplayName = _G.UnitClass("player")

	_G.CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	_G.CharacterModelFrame:DisableDrawLayer("BORDER")
	_G.CharacterModelFrame:DisableDrawLayer("OVERLAY")

	-- [[ Item buttons ]]

	local function colourPopout(self)
		local aR, aG, aB
		local glow = self:GetParent().IconBorder

		if glow:IsShown() then
			aR, aG, aB = glow:GetVertexColor()
		else
			aR, aG, aB = r, g, b
		end

		self.arrow:SetVertexColor(aR, aG, aB)
	end

	local function clearPopout(self)
		self.arrow:SetVertexColor(1, 1, 1)
	end

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local border = slot.IconBorder

		_G["Character"..slots[i].."SlotFrame"]:Hide()

		slot:SetNormalTexture("")
		slot:SetPushedTexture("")
		slot.icon:SetTexCoord(.08, .92, .08, .92)

		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND")

		local popout = slot.popoutButton

		popout:SetNormalTexture("")
		popout:SetHighlightTexture("")

		local arrow = popout:CreateTexture(nil, "OVERLAY")

		if slot.verticalFlyout then
			arrow:SetSize(13, 8)
			arrow:SetTexture(C.media.arrowDown)
			arrow:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			arrow:SetSize(8, 14)
			arrow:SetTexture(C.media.arrowRight)
			arrow:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end

		popout.arrow = arrow

		popout:HookScript("OnEnter", clearPopout)
		popout:HookScript("OnLeave", colourPopout)
	end

	select(11, _G.CharacterMainHandSlot:GetRegions()):Hide()
	select(11, _G.CharacterSecondaryHandSlot:GetRegions()):Hide()

	_G.hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		-- also fires for bag slots, we don't want that
		if button.popoutButton then
			button.IconBorder:SetTexture(C.media.backdrop)
			button.icon:SetShown(button.hasItem)
			colourPopout(button.popoutButton)
		end
	end)
	_G.hooksecurefunc("PaperDollFrame_SetLevel", function()
		local classColorString = ("ff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)

		local _, specName = _G.GetSpecializationInfo(_G.GetSpecialization(), nil, nil, nil, _G.UnitSex("player"))
		_G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, _G.UnitLevel("player"), classColorString, specName, classDisplayName)
	end)

	-- [[ Sidebar tabs ]]
	F.Reskin(_G.PaperDollEquipmentManagerPaneSaveSet)

	_G.PaperDollSidebarTabs:GetRegions():Hide()
	select(2, _G.PaperDollSidebarTabs:GetRegions()):Hide()
	for i = 1, #_G.PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]

		if i == 1 then
			for j = 1, 4 do
				local region = select(j, tab:GetRegions())
				region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
				region.SetTexCoord = F.dummy
			end
		end

		tab.Highlight:SetColorTexture(r, g, b, .2)
		tab.Highlight:SetPoint("TOPLEFT", 3, -4)
		tab.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)
		tab.Hider:SetColorTexture(.3, .3, .3, .4)
		tab.TabBg:SetAlpha(0)

		select(2, tab:GetRegions()):ClearAllPoints()
		if i == 1 then
			select(2, tab:GetRegions()):SetPoint("TOPLEFT", 3, -4)
			select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, 0)
		else
			select(2, tab:GetRegions()):SetPoint("TOPLEFT", 2, -4)
			select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, -1)
		end

		tab.bg = _G.CreateFrame("Frame", nil, tab)
		tab.bg:SetPoint("TOPLEFT", 2, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", 0, -1)
		tab.bg:SetFrameLevel(0)
		F.CreateBD(tab.bg)

		tab.Hider:SetPoint("TOPLEFT", tab.bg, 1, -1)
		tab.Hider:SetPoint("BOTTOMRIGHT", tab.bg, -1, 1)
	end

	-- [[ Titles pane ]]

	F.ReskinScroll(_G.PaperDollTitlesPaneScrollBar)
	_G.PaperDollTitlesPane:HookScript("OnShow", function(titles)
		for x, object in next, titles.buttons do
			object:DisableDrawLayer("BACKGROUND")
			object.text:SetFont(C.media.font, 11)
		end
	end)

	-- [[ Equipment manager ]]

	_G.PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", _G.PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
	_G.PaperDollEquipmentManagerPaneEquipSet:SetWidth(_G.PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
	F.Reskin(_G.PaperDollEquipmentManagerPaneSaveSet)
	F.Reskin(_G.PaperDollEquipmentManagerPaneEquipSet)
	F.ReskinScroll(_G.PaperDollEquipmentManagerPaneScrollBar)
	--select(6, _G.PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()

	local GearManagerDialogPopup = _G.GearManagerDialogPopup
	GearManagerDialogPopup:SetHeight(520)
	F.CreateBD(GearManagerDialogPopup)
	GearManagerDialogPopup.BG:Hide()
	for i = 1, 8 do
		select(i, GearManagerDialogPopup.BorderBox:GetRegions()):Hide()
	end

	_G.GearManagerDialogPopupEditBoxLeft:Hide()
	_G.GearManagerDialogPopupEditBoxMiddle:Hide()
	_G.GearManagerDialogPopupEditBoxRight:Hide()
	F.CreateBD(_G.GearManagerDialogPopupEditBox, .25)
	F.Reskin(_G.GearManagerDialogPopupCancel)
	F.Reskin(_G.GearManagerDialogPopupOkay)

	_G.GearManagerDialogPopupScrollFrameTop:Hide()
	_G.GearManagerDialogPopupScrollFrameMiddle:Hide()
	_G.GearManagerDialogPopupScrollFrameBottom:Hide()
	F.ReskinScroll(_G.GearManagerDialogPopupScrollFrameScrollBar)
	_G.GearManagerDialogPopupScrollFrame:SetHeight(400)
	private.SkinIconArray("GearManagerDialogPopupButton", _G.NUM_GEARSET_ICONS_PER_ROW, _G.NUM_GEARSET_ICON_ROWS)

	local sets = false
	_G.PaperDollSidebarTab3:HookScript("OnClick", function()
		if sets == false then
			for i = 1, 9 do
				local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
				local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
				local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

				bu.HighlightBar:SetColorTexture(r, g, b, .1)
				bu.HighlightBar:SetDrawLayer("BACKGROUND")
				bu.SelectedBar:SetColorTexture(r, g, b, .2)
				bu.SelectedBar:SetDrawLayer("BACKGROUND")

				bd:Hide()
				bd.Show = F.dummy
				ic:SetTexCoord(.08, .92, .08, .92)

				F.CreateBG(ic)
			end
			sets = true
		end
	end)
end)
