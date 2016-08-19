local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select = _G.select

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_AuctionUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.SetBD(_G.AuctionFrame, 2, -10, 0, 10)
	F.CreateBD(_G.AuctionProgressFrame)

	_G.AuctionProgressBar:SetStatusBarTexture(C.media.backdrop)
	local ABBD = CreateFrame("Frame", nil, _G.AuctionProgressBar)
	ABBD:SetPoint("TOPLEFT", -1, 1)
	ABBD:SetPoint("BOTTOMRIGHT", 1, -1)
	ABBD:SetFrameLevel(_G.AuctionProgressBar:GetFrameLevel()-1)
	F.CreateBD(ABBD, .25)

	_G.AuctionProgressBar.Icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBG(_G.AuctionProgressBar.Icon)

	_G.AuctionProgressBar.Text:ClearAllPoints()
	_G.AuctionProgressBar.Text:SetPoint("CENTER", 0, 1)

	F.ReskinClose(_G.AuctionProgressFrameCancelButton, "LEFT", _G.AuctionProgressBar, "RIGHT", 4, 0)
	select(14, _G.AuctionProgressFrameCancelButton:GetRegions()):SetPoint("CENTER", 0, 2)

	_G.AuctionFrame:DisableDrawLayer("ARTWORK")
	_G.AuctionPortraitTexture:Hide()
	for i = 1, 4 do
		select(i, _G.AuctionProgressFrame:GetRegions()):Hide()
	end
	_G.BrowseFilterScrollFrame:GetRegions():Hide()
	select(2, _G.BrowseFilterScrollFrame:GetRegions()):Hide()
	_G.BrowseScrollFrame:GetRegions():Hide()
	select(2, _G.BrowseScrollFrame:GetRegions()):Hide()
	_G.BidScrollFrame:GetRegions():Hide()
	select(2, _G.BidScrollFrame:GetRegions()):Hide()
	_G.AuctionsScrollFrame:GetRegions():Hide()
	select(2, _G.AuctionsScrollFrame:GetRegions()):Hide()
	_G.BrowseQualitySort:DisableDrawLayer("BACKGROUND")
	_G.BrowseLevelSort:DisableDrawLayer("BACKGROUND")
	_G.BrowseDurationSort:DisableDrawLayer("BACKGROUND")
	_G.BrowseHighBidderSort:DisableDrawLayer("BACKGROUND")
	_G.BrowseCurrentBidSort:DisableDrawLayer("BACKGROUND")
	_G.BidQualitySort:DisableDrawLayer("BACKGROUND")
	_G.BidLevelSort:DisableDrawLayer("BACKGROUND")
	_G.BidDurationSort:DisableDrawLayer("BACKGROUND")
	_G.BidBuyoutSort:DisableDrawLayer("BACKGROUND")
	_G.BidStatusSort:DisableDrawLayer("BACKGROUND")
	_G.BidBidSort:DisableDrawLayer("BACKGROUND")
	_G.AuctionsQualitySort:DisableDrawLayer("BACKGROUND")
	_G.AuctionsDurationSort:DisableDrawLayer("BACKGROUND")
	_G.AuctionsHighBidderSort:DisableDrawLayer("BACKGROUND")
	_G.AuctionsBidSort:DisableDrawLayer("BACKGROUND")
	select(6, _G.BrowseCloseButton:GetRegions()):Hide()
	select(6, _G.BrowseBuyoutButton:GetRegions()):Hide()
	select(6, _G.BrowseBidButton:GetRegions()):Hide()
	select(6, _G.BidCloseButton:GetRegions()):Hide()
	select(6, _G.BidBuyoutButton:GetRegions()):Hide()
	select(6, _G.BidBidButton:GetRegions()):Hide()

	_G.hooksecurefunc("FilterButton_SetUp", function(button)
		button:SetNormalTexture("")
	end)

	local lastSkinnedTab = 1
	_G.AuctionFrame:HookScript("OnShow", function()
		local tab = _G["AuctionFrameTab"..lastSkinnedTab]

		while tab do
			F.ReskinTab(tab)
			lastSkinnedTab = lastSkinnedTab + 1
			tab = _G["AuctionFrameTab"..lastSkinnedTab]
		end
	end)

	local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BrowseResetButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
	for i = 1, #abuttons do
		F.Reskin(_G[abuttons[i]])
	end

	_G.BrowseCloseButton:ClearAllPoints()
	_G.BrowseCloseButton:SetPoint("BOTTOMRIGHT", _G.AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
	_G.BrowseBuyoutButton:ClearAllPoints()
	_G.BrowseBuyoutButton:SetPoint("RIGHT", _G.BrowseCloseButton, "LEFT", -1, 0)
	_G.BrowseBidButton:ClearAllPoints()
	_G.BrowseBidButton:SetPoint("RIGHT", _G.BrowseBuyoutButton, "LEFT", -1, 0)
	_G.BidBuyoutButton:ClearAllPoints()
	_G.BidBuyoutButton:SetPoint("RIGHT", _G.BidCloseButton, "LEFT", -1, 0)
	_G.BidBidButton:ClearAllPoints()
	_G.BidBidButton:SetPoint("RIGHT", _G.BidBuyoutButton, "LEFT", -1, 0)
	_G.AuctionsCancelAuctionButton:ClearAllPoints()
	_G.AuctionsCancelAuctionButton:SetPoint("RIGHT", _G.AuctionsCloseButton, "LEFT", -1, 0)

	-- Blizz needs to be more consistent

	_G.BrowseBidPriceSilver:SetPoint("LEFT", _G.BrowseBidPriceGold, "RIGHT", 1, 0)
	_G.BrowseBidPriceCopper:SetPoint("LEFT", _G.BrowseBidPriceSilver, "RIGHT", 1, 0)
	_G.BidBidPriceSilver:SetPoint("LEFT", _G.BidBidPriceGold, "RIGHT", 1, 0)
	_G.BidBidPriceCopper:SetPoint("LEFT", _G.BidBidPriceSilver, "RIGHT", 1, 0)
	_G.StartPriceSilver:SetPoint("LEFT", _G.StartPriceGold, "RIGHT", 1, 0)
	_G.StartPriceCopper:SetPoint("LEFT", _G.StartPriceSilver, "RIGHT", 1, 0)
	_G.BuyoutPriceSilver:SetPoint("LEFT", _G.BuyoutPriceGold, "RIGHT", 1, 0)
	_G.BuyoutPriceCopper:SetPoint("LEFT", _G.BuyoutPriceSilver, "RIGHT", 1, 0)

	for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
		local bu = _G["BrowseButton"..i]
		local it = _G["BrowseButton"..i.."Item"]
		local ic = _G["BrowseButton"..i.."ItemIconTexture"]

		if bu and it then
			it:SetNormalTexture("")
			it:SetPushedTexture("")

			ic:SetTexCoord(.08, .92, .08, .92)

			F.CreateBG(it)

			it.IconBorder:SetTexture("")
			_G["BrowseButton"..i.."Left"]:Hide()
			select(5, _G["BrowseButton"..i]:GetRegions()):Hide()
			_G["BrowseButton"..i.."Right"]:Hide()

			local bd = CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT", 0, 5)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			F.CreateBD(bd, .25)

			bu:SetHighlightTexture(C.media.backdrop)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:SetPoint("TOPLEFT", 0, -1)
			hl:SetPoint("BOTTOMRIGHT", -1, 6)
		end
	end

	for i = 1, _G.NUM_BIDS_TO_DISPLAY do
		local bu = _G["BidButton"..i]
		local it = _G["BidButton"..i.."Item"]
		local ic = _G["BidButton"..i.."ItemIconTexture"]

		it:SetNormalTexture("")
		it:SetPushedTexture("")

		ic:SetTexCoord(.08, .92, .08, .92)

		F.CreateBG(it)

		it.IconBorder:SetTexture("")
		_G["BidButton"..i.."Left"]:Hide()
		select(6, _G["BidButton"..i]:GetRegions()):Hide()
		_G["BidButton"..i.."Right"]:Hide()

		local bd = CreateFrame("Frame", nil, bu)
		bd:SetPoint("TOPLEFT")
		bd:SetPoint("BOTTOMRIGHT", 0, 5)
		bd:SetFrameLevel(bu:GetFrameLevel()-1)
		F.CreateBD(bd, .25)

		bu:SetHighlightTexture(C.media.backdrop)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .2)
		hl:ClearAllPoints()
		hl:SetPoint("TOPLEFT", 0, -1)
		hl:SetPoint("BOTTOMRIGHT", -1, 6)
	end

	for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
		local bu = _G["AuctionsButton"..i]
		local it = _G["AuctionsButton"..i.."Item"]
		local ic = _G["AuctionsButton"..i.."ItemIconTexture"]

		it:SetNormalTexture("")
		it:SetPushedTexture("")

		ic:SetTexCoord(.08, .92, .08, .92)

		F.CreateBG(it)

		it.IconBorder:SetTexture("")
		_G["AuctionsButton"..i.."Left"]:Hide()
		select(4, _G["AuctionsButton"..i]:GetRegions()):Hide()
		_G["AuctionsButton"..i.."Right"]:Hide()

		local bd = CreateFrame("Frame", nil, bu)
		bd:SetPoint("TOPLEFT")
		bd:SetPoint("BOTTOMRIGHT", 0, 5)
		bd:SetFrameLevel(bu:GetFrameLevel()-1)
		F.CreateBD(bd, .25)

		bu:SetHighlightTexture(C.media.backdrop)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .2)
		hl:ClearAllPoints()
		hl:SetPoint("TOPLEFT", 0, -1)
		hl:SetPoint("BOTTOMRIGHT", -1, 6)
	end

	local auctionhandler = CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local AuctionsItemButtonIconTexture = _G.AuctionsItemButton:GetNormalTexture()
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
			AuctionsItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
			AuctionsItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)
		end
	end)

	F.CreateBD(_G.AuctionsItemButton, .25)
	local _, AuctionsItemButtonNameFrame = _G.AuctionsItemButton:GetRegions()
	AuctionsItemButtonNameFrame:Hide()

	F.ReskinClose(_G.AuctionFrameCloseButton, "TOPRIGHT", _G.AuctionFrame, "TOPRIGHT", -4, -14)
	F.ReskinScroll(_G.BrowseScrollFrameScrollBar)
	F.ReskinScroll(_G.AuctionsScrollFrameScrollBar)
	F.ReskinScroll(_G.BrowseFilterScrollFrameScrollBar)
	F.ReskinDropDown(_G.PriceDropDown)
	F.ReskinDropDown(_G.DurationDropDown)
	F.ReskinInput(_G.BrowseName)
	F.ReskinArrow(_G.BrowsePrevPageButton, "left")
	F.ReskinArrow(_G.BrowseNextPageButton, "right")
	F.ReskinCheck(_G.ExactMatchCheckButton)
	F.ReskinCheck(_G.IsUsableCheckButton)
	F.ReskinCheck(_G.ShowOnPlayerCheckButton)
	
	_G.BrowseNameText:ClearAllPoints()
	_G.BrowseNameText:SetPoint("TOPLEFT", _G.AuctionFrameBrowse, "TOPLEFT", 80, -38)
	_G.BrowseLevelText:ClearAllPoints()
	_G.BrowseLevelText:SetPoint("TOPLEFT", _G.AuctionFrameBrowse, "TOPLEFT", 230, -40)
	_G.BrowseDropDownName:ClearAllPoints()
	_G.BrowseDropDownName:SetPoint("TOPLEFT", _G.AuctionFrameBrowse, "TOPLEFT", 310, -40)
	_G.BrowseDropDown:ClearAllPoints()
	_G.BrowseDropDown:SetPoint("TOPLEFT", _G.AuctionFrameBrowse, "TOPLEFT", 290, -48)
	
	_G.BrowsePrevPageButton:SetPoint("TOPLEFT", 660, -60)
	_G.BrowseNextPageButton:SetPoint("TOPRIGHT", 67, -60)
	_G.BrowsePrevPageButton:GetRegions():SetPoint("LEFT", _G.BrowsePrevPageButton, "RIGHT", 2, 0)

	_G.BrowseDropDownLeft:SetAlpha(0)
	_G.BrowseDropDownMiddle:SetAlpha(0)
	_G.BrowseDropDownRight:SetAlpha(0)

	local a1, p, a2, x, y = _G.BrowseDropDownButton:GetPoint()
	_G.BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
	_G.BrowseDropDownButton:SetSize(16, 16)
	F.Reskin(_G.BrowseDropDownButton, true)

	local tex = _G.BrowseDropDownButton:CreateTexture(nil, "OVERLAY")
	tex:SetTexture(C.media.arrowDown)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	tex:SetVertexColor(1, 1, 1)
	_G.BrowseDropDownButton.tex = tex

	local bg = CreateFrame("Frame", nil, _G.BrowseDropDown)
	bg:SetPoint("TOPLEFT", 16, -5)
	bg:SetPoint("BOTTOMRIGHT", 109, 11)
	bg:SetFrameLevel(_G.BrowseDropDown:GetFrameLevel()-1)
	F.CreateBD(bg, 0)

	F.CreateGradient(bg)

	local colourArrow = F.colourArrow
	local clearArrow = F.clearArrow

	_G.BrowseDropDownButton:HookScript("OnEnter", colourArrow)
	_G.BrowseDropDownButton:HookScript("OnLeave", clearArrow)

	local inputs = {"BrowseMinLevel", "BrowseMaxLevel", "BrowseBidPriceGold", "BrowseBidPriceSilver", "BrowseBidPriceCopper", "BidBidPriceGold", "BidBidPriceSilver", "BidBidPriceCopper", "StartPriceGold", "StartPriceSilver", "StartPriceCopper", "BuyoutPriceGold", "BuyoutPriceSilver", "BuyoutPriceCopper", "AuctionsStackSizeEntry", "AuctionsNumStacksEntry"}
	for i = 1, #inputs do
		F.ReskinInput(_G[inputs[i]])
	end

	-- [[ WoW token ]]

	local BrowseWowTokenResults = _G.BrowseWowTokenResults

	F.Reskin(BrowseWowTokenResults.Buyout)

	-- Tutorial

	local WowTokenGameTimeTutorial = _G.WowTokenGameTimeTutorial

	F.ReskinPortraitFrame(WowTokenGameTimeTutorial, true)
	F.Reskin(_G.StoreButton)

	-- Token

	do
		local Token = BrowseWowTokenResults.Token
		local icon = Token.Icon
		local iconBorder = Token.IconBorder

		Token.ItemBorder:Hide()
		iconBorder:SetTexture(C.media.backdrop)
		iconBorder:SetDrawLayer("BACKGROUND")
		iconBorder:SetPoint("TOPLEFT", icon, -1, 1)
		iconBorder:SetPoint("BOTTOMRIGHT", icon, 1, -1)
		icon:SetTexCoord(.08, .92, .08, .92)
	end
end
