local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select = _G.select

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	if not _G.AuroraConfig.bags then return end

	local r, g, b = C.r, C.g, C.b

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

	local function onEnter(self)
		self.bg:SetBackdropBorderColor(r, g, b)
	end

	local function onLeave(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end

	local function styleBankButton(bu)
		local border = bu.IconBorder
		local questTexture = bu.IconQuestTexture
		local searchOverlay = bu.searchOverlay

		questTexture:SetDrawLayer("BACKGROUND")
		questTexture:SetSize(1, 1)

		border:SetTexture(C.media.backdrop)
		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND", 1)

		searchOverlay:SetPoint("TOPLEFT", -1, 1)
		searchOverlay:SetPoint("BOTTOMRIGHT", 1, -1)

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:SetHighlightTexture("")

		bu.icon:SetTexCoord(.08, .92, .08, .92)

		bu.bg = F.CreateBDFrame(bu, 0)

		bu:HookScript("OnEnter", onEnter)
		bu:HookScript("OnLeave", onLeave)
	end

	for i = 1, 28 do
		styleBankButton(_G["BankFrameItem"..i])
	end

	for i = 1, 7 do
		local bag = _G.BankSlotsFrame["Bag"..i]
		local _, highlightFrame = bag:GetChildren()
		local border = bag.IconBorder
		local searchOverlay = bag.searchOverlay

		bag:SetNormalTexture("")
		bag:SetPushedTexture("")
		bag:SetHighlightTexture("")

		highlightFrame:GetRegions():SetTexture(C.media.checked)

		border:SetTexture(C.media.backdrop)
		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND", 1)

		searchOverlay:SetPoint("TOPLEFT", -1, 1)
		searchOverlay:SetPoint("BOTTOMRIGHT", 1, -1)

		bag.icon:SetTexCoord(.08, .92, .08, .92)

		bag.bg = F.CreateBDFrame(bag, 0)

		bag:HookScript("OnEnter", onEnter)
		bag:HookScript("OnLeave", onLeave)
	end

	_G.BankItemAutoSortButton:GetNormalTexture():SetTexCoord(.17, .83, .17, .83)
	_G.BankItemAutoSortButton:GetPushedTexture():SetTexCoord(.17, .83, .17, .83)
	F.CreateBG(_G.BankItemAutoSortButton)

	_G.hooksecurefunc("BankFrameItemButton_Update", function(button)
		if not button.isBag and button.IconQuestTexture:IsShown() then
			button.IconBorder:SetVertexColor(1, 1, 0)
		end
	end)

	-- [[ Reagent bank ]]

	_G.ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	_G.ReagentBankFrame:DisableDrawLayer("BORDER")
	_G.ReagentBankFrame:DisableDrawLayer("ARTWORK")

	F.Reskin(_G.ReagentBankFrame.DespositButton)
	F.Reskin(_G.ReagentBankFrameUnlockInfoPurchaseButton)

	-- make button more visible
	_G.ReagentBankFrameUnlockInfoBlackBG:SetColorTexture(.1, .1, .1)

	local reagentButtonsStyled = false
	_G.ReagentBankFrame:HookScript("OnShow", function()
		if not reagentButtonsStyled then
			for i = 1, 98 do
				styleBankButton(_G["ReagentBankFrameItem"..i])
			end
			reagentButtonsStyled = true
		end
	end)
end)
