local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select = _G.select

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

local function GetItemQualityColor(link)
	if link then
		local _, _, quality = _G.GetItemInfo(link)
		if quality then
			return _G.GetItemQualityColor(quality)
		else
			return 1, 1, 1
		end
	else
		return 1, 1, 1
	end
end
_G.tinsert(C.themes["Aurora"], function()
	_G.MerchantMoneyInset:DisableDrawLayer("BORDER")
	_G.MerchantExtraCurrencyInset:DisableDrawLayer("BORDER")
	_G.BuybackBG:SetAlpha(0)
	_G.MerchantMoneyBg:Hide()
	_G.MerchantMoneyInsetBg:Hide()
	_G.MerchantFrameBottomLeftBorder:SetAlpha(0)
	_G.MerchantFrameBottomRightBorder:SetAlpha(0)
	_G.MerchantExtraCurrencyBg:SetAlpha(0)
	_G.MerchantExtraCurrencyInsetBg:Hide()
	_G.MerchantPrevPageButton:GetRegions():Hide()
	_G.MerchantNextPageButton:GetRegions():Hide()
	select(2, _G.MerchantPrevPageButton:GetRegions()):Hide()
	select(2, _G.MerchantNextPageButton:GetRegions()):Hide()

	F.ReskinPortraitFrame(_G.MerchantFrame, true)
	F.ReskinDropDown(_G.MerchantFrameLootFilter)
	F.ReskinArrow(_G.MerchantPrevPageButton, "left")
	F.ReskinArrow(_G.MerchantNextPageButton, "right")

	_G.MerchantFrameTab1:ClearAllPoints()
	_G.MerchantFrameTab1:SetPoint("CENTER", _G.MerchantFrame, "BOTTOMLEFT", 50, -14)
	_G.MerchantFrameTab2:SetPoint("LEFT", _G.MerchantFrameTab1, "RIGHT", -15, 0)

	for i = 1, 2 do
		F.ReskinTab(_G["MerchantFrameTab"..i])
	end

	_G.MerchantNameText:SetDrawLayer("ARTWORK")

	for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
		local button = _G["MerchantItem"..i]
		local bu = _G["MerchantItem"..i.."ItemButton"]
		local mo = _G["MerchantItem"..i.."MoneyFrame"]
		local ic = bu.icon

		bu:SetHighlightTexture("")

		_G["MerchantItem"..i.."SlotTexture"]:Hide()
		_G["MerchantItem"..i.."NameFrame"]:Hide()
		_G["MerchantItem"..i.."Name"]:SetHeight(20)

		local a1, p, a2= bu:GetPoint()
		bu:SetPoint(a1, p, a2, -2, -2)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:SetSize(40, 40)

		local a3, p2, a4, x, y = mo:GetPoint()
		mo:SetPoint(a3, p2, a4, x, y+2)

		F.CreateBD(bu, 0)

		button.bd = _G.CreateFrame("Frame", nil, button)
		button.bd:SetPoint("TOPLEFT", 39, 0)
		button.bd:SetPoint("BOTTOMRIGHT")
		button.bd:SetFrameLevel(0)
		F.CreateBD(button.bd, .25)

		ic:SetTexCoord(.08, .92, .08, .92)
		ic:ClearAllPoints()
		ic:SetPoint("TOPLEFT", 1, -1)
		ic:SetPoint("BOTTOMRIGHT", -1, 1)

		for j = 1, 3 do
			F.CreateBG(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"])
			_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]:SetTexCoord(.08, .92, .08, .92)
		end
	end

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		local numMerchantItems = _G.GetMerchantNumItems()
		for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
			local index = ((_G.MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i
			if index <= numMerchantItems then
				local _, _, price, _, _, _, extendedCost = _G.GetMerchantItemInfo(index)
				if extendedCost and (price <= 0) then
					_G["MerchantItem"..i.."AltCurrencyFrame"]:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 35)
				end

				local bu = _G["MerchantItem"..i.."ItemButton"]
				local name = _G["MerchantItem"..i.."Name"]
				name:SetTextColor(GetItemQualityColor(bu.link))
			end
		end

		_G.MerchantBuyBackItemName:SetTextColor(GetItemQualityColor(_G.GetBuybackItemLink(_G.GetNumBuybackItems())))
	end)

	hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
		for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
			local name = _G["MerchantItem"..i.."Name"]
			name:SetTextColor(GetItemQualityColor(_G.GetBuybackItemLink(i)))
		end
	end)

	_G.MerchantBuyBackItemSlotTexture:SetAlpha(0)
	_G.MerchantBuyBackItemNameFrame:Hide()
	_G.MerchantBuyBackItemItemButton:SetNormalTexture("")
	_G.MerchantBuyBackItemItemButton:SetPushedTexture("")

	F.CreateBD(_G.MerchantBuyBackItemItemButton, 0)
	F.CreateBD(_G.MerchantBuyBackItem, .25)

	_G.MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
	_G.MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
	_G.MerchantBuyBackItemItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
	_G.MerchantBuyBackItemItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

	_G.MerchantBuyBackItemName:SetHeight(25)
	_G.MerchantBuyBackItemName:ClearAllPoints()
	_G.MerchantBuyBackItemName:SetPoint("LEFT", _G.MerchantBuyBackItemSlotTexture, "RIGHT", -5, 8)

	_G.MerchantGuildBankRepairButton:SetPushedTexture("")
	F.CreateBG(_G.MerchantGuildBankRepairButton)
	_G.MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)

	_G.MerchantRepairAllButton:SetPushedTexture("")
	F.CreateBG(_G.MerchantRepairAllButton)
	_G.MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)

	_G.MerchantRepairItemButton:SetPushedTexture("")
	F.CreateBG(_G.MerchantRepairItemButton)
	local icon = _G.MerchantRepairItemButton:GetRegions()
	icon:SetTexture("Interface\\Icons\\INV_Hammer_20")
	icon:SetTexCoord(.08, .92, .08, .92)

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		for i = 1, _G.MAX_MERCHANT_CURRENCIES do
			local bu = _G["MerchantToken"..i]
			if bu and not bu.reskinned then
				local ic = _G["MerchantToken"..i.."Icon"]
				local co = _G["MerchantToken"..i.."Count"]

				ic:SetTexCoord(.08, .92, .08, .92)
				ic:SetDrawLayer("OVERLAY")
				ic:SetPoint("LEFT", co, "RIGHT", 2, 0)
				co:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 0)

				F.CreateBG(ic)
				bu.reskinned = true
			end
		end
	end)
end)
