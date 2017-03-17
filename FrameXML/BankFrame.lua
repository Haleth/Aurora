local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	if not _G.AuroraConfig.bags then return end

	-- [[ Bank ]]

	select(16, _G.BankFrame:GetRegions()):Hide()
	_G.BankSlotsFrame:DisableDrawLayer("BORDER")
	_G.BankPortraitTexture:Hide()
	_G.BankFrameMoneyFrameInset:Hide()
	_G.BankFrameMoneyFrameBorder:Hide()

	-- "item slots" and "bag slots" text
	select(9, _G.BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY")
	select(10, _G.BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY")

	F.ReskinPortraitFrame(_G.BankFrame)
	F.Reskin(_G.BankFramePurchaseButton)
	F.ReskinTab(_G.BankFrameTab1)
	F.ReskinTab(_G.BankFrameTab2)
	F.ReskinInput(_G.BankItemSearchBox)

	local function styleBankButton(button)
		button:SetNormalTexture("")
		button:SetPushedTexture("")
		button:SetHighlightTexture("")

		F.ReskinIcon(button.icon)
		button.icon:SetTexCoord(.08, .92, .08, .92)
		button._auroraBG = F.CreateBDFrame(button, 0)

		local searchOverlay = button.searchOverlay
		searchOverlay:SetPoint("TOPLEFT", -1, 1)
		searchOverlay:SetPoint("BOTTOMRIGHT", 1, -1)
	end

	for i = 1, 28 do
		local item = _G["BankFrameItem"..i]
		styleBankButton(_G["BankFrameItem"..i])

		local questTexture = item.IconQuestTexture
		questTexture:SetTexCoord(.08, .92, .08, .92)
	end

	for i = 1, 7 do
		local bag = _G.BankSlotsFrame["Bag"..i]
		styleBankButton(bag)

		local _, highlightFrame = bag:GetChildren()
		highlightFrame:GetRegions():SetTexture(C.media.checked)
	end

	_G.BankItemAutoSortButton:SetSize(26, 26)
	_G.BankItemAutoSortButton:SetNormalTexture([[Interface\Icons\INV_Pet_Broom]])
	_G.BankItemAutoSortButton:GetNormalTexture():SetTexCoord(.13, .92, .13, .92)

	_G.BankItemAutoSortButton:SetPushedTexture([[Interface\Icons\INV_Pet_Broom]])
	_G.BankItemAutoSortButton:GetPushedTexture():SetTexCoord(.08, .87, .08, .87)
	F.CreateBG(_G.BankItemAutoSortButton)

	_G.hooksecurefunc("BankFrameItemButton_Update", function(button)
		if not button.isBag and button.IconQuestTexture:IsShown() then
			button._auroraBG:SetBackdropBorderColor(1, 1, 0)
		end
	end)

	-- [[ Reagent bank ]]
	local ReagentBankFrame = _G.ReagentBankFrame

	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("BORDER")
	ReagentBankFrame:DisableDrawLayer("ARTWORK")

	F.Reskin(ReagentBankFrame.DespositButton)

	ReagentBankFrame.UnlockInfo:SetPoint("TOPLEFT", 13, -60)
	ReagentBankFrame.UnlockInfo:SetPoint("BOTTOMRIGHT", -14, 48)
	F.CreateBDFrame(ReagentBankFrame.UnlockInfo, 0.2)
	local borderTextures = {
		"BottomLeftInner",
		"BottomRightInner",
		"TopRightInner",
		"TopLeftInner",
		"LeftInner",
		"RightInner",
		"TopInner",
		"BottomInner",
		"BlackBG"
	}
	for i = 1, #borderTextures do
		_G["ReagentBankFrameUnlockInfo"..borderTextures[i]]:Hide()
	end
	F.Reskin(_G.ReagentBankFrameUnlockInfoPurchaseButton)

	local reagentButtonsStyled = false
	ReagentBankFrame:HookScript("OnShow", function()
		if not reagentButtonsStyled then
			for i = 1, 98 do
				styleBankButton(_G["ReagentBankFrameItem"..i])
			end
			reagentButtonsStyled = true
		end
	end)
end)
