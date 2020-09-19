local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_AuctionUI.lua ]]
    function Hook.FilterButton_SetUp(button, info)
        button:SetNormalTexture("")

        local highlight = button:GetHighlightTexture()
        if info.type == "subSubCategory" then
            button:SetBackdrop(false)

            highlight:SetColorTexture(Color.highlight:GetRGB())
            highlight:SetAlpha(0.5)
        else
            button:SetBackdrop(true)
            highlight:SetAlpha(0)

            if info.type == "category" then
                button:SetBackdropOption("offsets", {
                    left = -1,
                    right = 1,
                    top = 1,
                    bottom = 1,
                })
            elseif info.type == "subCategory" then
                button:SetBackdropOption("offsets", {
                    left = 8,
                    right = 1,
                    top = 1,
                    bottom = 1,
                })
            end
        end
    end
    function Hook.AuctionFrameBrowse_Update()
        local offset = _G.FauxScrollFrame_GetOffset(_G.BrowseScrollFrame)
        local button, quality, _

        for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
            button = _G["BrowseButton"..i]
            if button:IsShown() then
                _, _, _, quality =  _G.GetAuctionItemInfo("list", offset + i);
                Hook.SetItemButtonQuality(button._item, quality)
            end
        end
    end
    function Hook.AuctionFrameBid_Update()
        local offset = _G.FauxScrollFrame_GetOffset(_G.BidScrollFrame)
        local button, quality, _

        for i = 1, _G.NUM_BIDS_TO_DISPLAY do
            button = _G["BidButton"..i]
            if button:IsShown() then
                _, _, _, quality =  _G.GetAuctionItemInfo("bidder", offset + i);
                Hook.SetItemButtonQuality(button._item, quality)
            end
        end
    end
    function Hook.AuctionFrameAuctions_Update()
        local offset = _G.FauxScrollFrame_GetOffset(_G.BidScrollFrame)
        local button, quality, _

        for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
            button = _G["AuctionsButton"..i]
            if button:IsShown() then
                _, _, _, quality =  _G.GetAuctionItemInfo("owner", offset + i);
                Hook.SetItemButtonQuality(button._item, quality)
            end
        end
    end
    function Hook.AuctionSellItemButton_OnEvent(self, event, ...)
        local _, texture, _, quality, _, _, _, _, _, itemID = _G.GetAuctionSellItemInfo()
        Hook.SetItemButtonQuality(self, quality, itemID)
        if texture then
            Base.CropIcon(self:GetNormalTexture())
        end
    end
    function Hook.SortButton_UpdateArrow(button, type, sort)
        local primaryColumn, reversed = _G.GetAuctionSort(type, 1)
        button.Arrow:SetTexCoord(0, 1, 0, 1)
        if sort == primaryColumn then
            if reversed then
                Base.SetTexture(button.Arrow, "arrowUp")
            else
                Base.SetTexture(button.Arrow, "arrowDown")
            end
        end
    end
end

do --[[ AddOns\Blizzard_AuctionUITemplates.xml ]]
    function Skin.AuctionRadioButtonTemplate(CheckButton)
        Skin.FrameTypeCheckButton(CheckButton)
        CheckButton:SetBackdropOption("offsets", {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4,
        })

        local bg = CheckButton:GetBackdropTexture("bg")
        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bg, 1, -1)
        check:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        check:SetColorTexture(Color.highlight:GetRGB())
    end
    function Skin.AuctionClassButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = -1,
            right = 1,
            top = 1,
            bottom = 1,
        })

        Button:GetRegions():SetTexture("") -- lines
        Button:SetNormalTexture("")

        local highlight = Button:GetHighlightTexture()
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT", 15, -1)
        highlight:SetPoint("BOTTOMRIGHT", -1, 1)
        highlight:SetColorTexture(Color.highlight:GetRGB())
    end
    function Skin.AuctionSortButtonTemplate(Button)
        local name = Button:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()

        local texture = Button:GetNormalTexture()
        texture:SetSize(10, 5)
    end
    function Skin.BrowseButtonTemplate(Button)
        local name = Button:GetName()
        local _, _, left, right, mid = Button:GetRegions()
        left:Hide()
        right:Hide()
        mid:Hide()

        local item = _G[name.."Item"]
        item.Count = _G[name.."ItemCount"]
        _G[name.."ItemStock"]:SetPoint("TOPLEFT", 2, -2)
        item.icon = _G[name.."ItemIconTexture"]
        item.icon:SetTexture(private.textures.plain)
        Skin.FrameTypeItemButton(item)
        Button._item = item

        local highlight = Button:GetHighlightTexture()
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT", item, "TOPRIGHT", 2, 0)
        highlight:SetPoint("BOTTOMLEFT", item, "BOTTOMRIGHT", 2, 0)
        highlight:SetPoint("RIGHT", 0, 0)
        highlight:SetColorTexture(Color.highlight:GetRGB())
        highlight:SetAlpha(0.25)
    end
    function Skin.BidButtonTemplate(Button)
        local name = Button:GetName()
        local _, _, _, left, right, mid = Button:GetRegions()
        left:Hide()
        right:Hide()
        mid:Hide()

        local item = _G[name.."Item"]
        item.Count = _G[name.."ItemCount"]
        _G[name.."ItemStock"]:SetPoint("TOPLEFT", 2, -2)
        item.icon = _G[name.."ItemIconTexture"]
        item.icon:SetTexture(private.textures.plain)
        Skin.FrameTypeItemButton(item)
        Button._item = item

        local highlight = Button:GetHighlightTexture()
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT", item, "TOPRIGHT", 2, 0)
        highlight:SetPoint("BOTTOMLEFT", item, "BOTTOMRIGHT", 2, 0)
        highlight:SetPoint("RIGHT", 0, 0)
        highlight:SetColorTexture(Color.highlight:GetRGB())
        highlight:SetAlpha(0.25)
    end
    function Skin.AuctionsButtonTemplate(Button)
        local name = Button:GetName()
        local _, left, right, mid = Button:GetRegions()
        left:Hide()
        right:Hide()
        mid:Hide()

        local item = _G[name.."Item"]
        item.Count = _G[name.."ItemCount"]
        _G[name.."ItemStock"]:SetPoint("TOPLEFT", 2, -2)
        item.icon = _G[name.."ItemIconTexture"]
        item.icon:SetTexture(private.textures.plain)
        Skin.FrameTypeItemButton(item)
        Button._item = item

        local highlight = Button:GetHighlightTexture()
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT", item, "TOPRIGHT", 2, 0)
        highlight:SetPoint("BOTTOMLEFT", item, "BOTTOMRIGHT", 2, 0)
        highlight:SetPoint("RIGHT", 0, 0)
        highlight:SetColorTexture(Color.highlight:GetRGB())
        highlight:SetAlpha(0.25)
    end
    function Skin.AuctionTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
    end
end

function private.AddOns.Blizzard_AuctionUI()
    _G.hooksecurefunc("FilterButton_SetUp", Hook.FilterButton_SetUp)
    _G.hooksecurefunc("AuctionFrameBrowse_Update", Hook.AuctionFrameBrowse_Update)
    _G.hooksecurefunc("AuctionFrameBid_Update", Hook.AuctionFrameBid_Update)
    _G.hooksecurefunc("AuctionFrameAuctions_Update", Hook.AuctionFrameAuctions_Update)
    _G.hooksecurefunc("SortButton_UpdateArrow", Hook.SortButton_UpdateArrow)

    local AuctionFrame = _G.AuctionFrame
    Base.SetBackdrop(AuctionFrame)
    AuctionFrame:SetBackdropOption("offsets", {
        left = 12,
        right = 2,
        top = 13,
        bottom = 11,
    })

    _G.AuctionPortraitTexture:Hide()
    _G.AuctionFrameTopLeft:Hide()
    _G.AuctionFrameTop:Hide()
    _G.AuctionFrameTopRight:Hide()
    _G.AuctionFrameBotLeft:Hide()
    _G.AuctionFrameBot:Hide()
    _G.AuctionFrameBotRight:Hide()

    local auctionBg = AuctionFrame:GetBackdropTexture("bg")
    Skin.AuctionTabTemplate(_G.AuctionFrameTab1)
    Skin.AuctionTabTemplate(_G.AuctionFrameTab2)
    Skin.AuctionTabTemplate(_G.AuctionFrameTab3)
    Util.PositionRelative("TOPLEFT", auctionBg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.AuctionFrameTab1,
        _G.AuctionFrameTab2,
        _G.AuctionFrameTab3,
    })

    local moneyBG = _G.CreateFrame("Frame", nil, _G.AuctionFrame)
    Base.SetBackdrop(moneyBG, Color.frame)
    moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
    moneyBG:SetPoint("BOTTOMLEFT", auctionBg, 5, 5)
    moneyBG:SetSize(160, 22)
    Skin.SmallMoneyFrameTemplate(_G.AuctionFrameMoneyFrame)
    _G.AuctionFrameMoneyFrame:SetPoint("BOTTOMRIGHT", moneyBG, 7, 5)

    Skin.UIPanelCloseButton(_G.AuctionFrameCloseButton)


    ------------
    -- Browse --
    ------------
    local AuctionFrameBrowse = _G.AuctionFrameBrowse
    _G.BrowseTitle:ClearAllPoints()
    _G.BrowseTitle:SetPoint("TOPLEFT", auctionBg)
    _G.BrowseTitle:SetPoint("BOTTOMRIGHT", auctionBg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    --[[ Browse Categories ]]--
    for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
        Skin.AuctionClassButtonTemplate(AuctionFrameBrowse.FilterButtons[i])
    end

    Skin.FauxScrollFrameTemplate(_G.BrowseFilterScrollFrame)
    local top, bottom = _G.BrowseFilterScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    Skin.FauxScrollFrameTemplate(_G.BrowseScrollFrame)
    top, bottom = _G.BrowseScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    --[[ WoW Token ]]--
    -- BrowseWowTokenResults is not accessable

    --[[ Browse List ]]--
    Skin.AuctionSortButtonTemplate(_G.BrowseQualitySort)
    Skin.AuctionSortButtonTemplate(_G.BrowseLevelSort)
    Skin.AuctionSortButtonTemplate(_G.BrowseDurationSort)
    Skin.AuctionSortButtonTemplate(_G.BrowseHighBidderSort)
    Skin.AuctionSortButtonTemplate(_G.BrowseCurrentBidSort)
    for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
        Skin.BrowseButtonTemplate(_G["BrowseButton"..i])
    end

    Skin.NavButtonPrevious(_G.BrowsePrevPageButton)
    Skin.NavButtonNext(_G.BrowseNextPageButton)

    --[[ Browse Header ]]--
    Skin.InputBoxInstructionsTemplate(_G.BrowseName)
    Skin.InputBoxTemplate(_G.BrowseMinLevel)
    Skin.InputBoxTemplate(_G.BrowseMaxLevel)
    Skin.UIDropDownMenuTemplate(_G.BrowseDropDown)
    Skin.UICheckButtonTemplate(_G.IsUsableCheckButton)
    Skin.UICheckButtonTemplate(_G.ShowOnPlayerCheckButton)
    Skin.UIPanelButtonTemplate(_G.BrowseSearchButton)

    --[[ Browse Footer ]]--
    Skin.UIPanelButtonTemplate(_G.BrowseCloseButton)
    select(6, _G.BrowseCloseButton:GetRegions()):Hide()
    Skin.UIPanelButtonTemplate(_G.BrowseBuyoutButton)
    select(6, _G.BrowseBuyoutButton:GetRegions()):Hide()
    Skin.UIPanelButtonTemplate(_G.BrowseBidButton)
    select(6, _G.BrowseBidButton:GetRegions()):Hide()
    Util.PositionRelative("BOTTOMRIGHT", auctionBg, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.BrowseCloseButton,
        _G.BrowseBuyoutButton,
        _G.BrowseBidButton,
    })

    Skin.MoneyInputFrameTemplate(_G.BrowseBidPrice)

    ---------
    -- Bid --
    ---------
    --local AuctionFrameBid = _G.AuctionFrameBid
    _G.BidTitle:ClearAllPoints()
    _G.BidTitle:SetPoint("TOPLEFT", auctionBg)
    _G.BidTitle:SetPoint("BOTTOMRIGHT", auctionBg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    --[[ Bid List ]]--
    Skin.AuctionSortButtonTemplate(_G.BidQualitySort)
    Skin.AuctionSortButtonTemplate(_G.BidLevelSort)
    Skin.AuctionSortButtonTemplate(_G.BidDurationSort)
    Skin.AuctionSortButtonTemplate(_G.BidBuyoutSort)
    Skin.AuctionSortButtonTemplate(_G.BidStatusSort)
    Skin.AuctionSortButtonTemplate(_G.BidBidSort)

    Skin.FauxScrollFrameTemplate(_G.BidScrollFrame)
    top, bottom = _G.BidScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    for i = 1, _G.NUM_BIDS_TO_DISPLAY do
        Skin.BidButtonTemplate(_G["BidButton"..i])
    end

    --[[ Bid Footer ]]--
    Skin.MoneyInputFrameTemplate(_G.BidBidPrice)

    Skin.UIPanelButtonTemplate(_G.BidCloseButton)
    select(6, _G.BidCloseButton:GetRegions()):Hide()
    Skin.UIPanelButtonTemplate(_G.BidBuyoutButton)
    select(6, _G.BidBuyoutButton:GetRegions()):Hide()
    Skin.UIPanelButtonTemplate(_G.BidBidButton)
    select(6, _G.BidBidButton:GetRegions()):Hide()
    Util.PositionRelative("BOTTOMRIGHT", auctionBg, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.BidCloseButton,
        _G.BidBuyoutButton,
        _G.BidBidButton,
    })



    --------------
    -- Auctions --
    --------------
    --local AuctionFrameAuctions = _G.AuctionFrameAuctions
    _G.AuctionsTitle:ClearAllPoints()
    _G.AuctionsTitle:SetPoint("TOPLEFT", auctionBg)
    _G.AuctionsTitle:SetPoint("BOTTOMRIGHT", auctionBg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    --[[ Auctions List ]]--
    Skin.AuctionSortButtonTemplate(_G.AuctionsQualitySort)
    Skin.AuctionSortButtonTemplate(_G.AuctionsDurationSort)
    Skin.AuctionSortButtonTemplate(_G.AuctionsHighBidderSort)
    Skin.AuctionSortButtonTemplate(_G.AuctionsBidSort)

    Skin.FauxScrollFrameTemplate(_G.AuctionsScrollFrame)
    top, bottom = _G.AuctionsScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
        Skin.AuctionsButtonTemplate(_G["AuctionsButton"..i])
    end

    --[[ Auction Create ]]--
    do -- AuctionsItemButton
        local item = _G.AuctionsItemButton
        Base.CreateBackdrop(item, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        Base.CropIcon(item:GetBackdropTexture("bg"))
        Base.SetBackdrop(item, Color.black, Color.frame.a)
        item._auroraIconBorder = item

        item:SetBackdropColor(1, 1, 1, 0.75)
        item:SetBackdropBorderColor(Color.frame, 1)

        item:HookScript("OnEvent", Hook.AuctionSellItemButton_OnEvent)
    end
    do -- AuctionsStackSizeEntry
        local EditBox = _G.AuctionsStackSizeEntry
        EditBox.Left = _G.AuctionsStackSizeEntryLeft
        EditBox.Right = _G.AuctionsStackSizeEntryRight
        EditBox.Middle = _G.AuctionsStackSizeEntryMiddle
        Skin.InputBoxTemplate(EditBox)
    end
    Skin.UIPanelButtonTemplate(_G.AuctionsStackSizeMaxButton)

    do -- AuctionsNumStacksEntry
        local EditBox = _G.AuctionsNumStacksEntry
        EditBox.Left = _G.AuctionsStackSizeEntryLeft
        EditBox.Right = _G.AuctionsStackSizeEntryRight
        EditBox.Middle = _G.AuctionsStackSizeEntryMiddle
        Skin.InputBoxTemplate(EditBox)
    end
    Skin.UIPanelButtonTemplate(_G.AuctionsNumStacksMaxButton)

    Skin.UIDropDownMenuTemplate(_G.PriceDropDown)
    Skin.MoneyInputFrameTemplate(_G.StartPrice)
    Skin.AuctionRadioButtonTemplate(_G.AuctionsShortAuctionButton)
    Skin.AuctionRadioButtonTemplate(_G.AuctionsMediumAuctionButton)
    Skin.AuctionRadioButtonTemplate(_G.AuctionsLongAuctionButton)
    Skin.MoneyInputFrameTemplate(_G.BuyoutPrice)
    Skin.UIPanelButtonTemplate(_G.AuctionsCreateAuctionButton)

    --[[ Auctions Footer ]]--
    Skin.UIPanelButtonTemplate(_G.AuctionsCloseButton)
    Skin.UIPanelButtonTemplate(_G.AuctionsCancelAuctionButton)
    Util.PositionRelative("BOTTOMRIGHT", auctionBg, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.AuctionsCloseButton,
        _G.AuctionsCancelAuctionButton,
    })


    --[=[
    F.SetBD(_G.AuctionFrame, 11, -12, -1, 10)
    _G.AuctionPortraitTexture:Hide()
    _G.AuctionFrame:DisableDrawLayer("ARTWORK")

    for i = 1, 3 do
        F.ReskinTab(_G["AuctionFrameTab"..i])
    end

    local moneyBG = _G.CreateFrame("Frame", nil, _G.AuctionFrame)
    Base.SetBackdrop(moneyBG, Color.frame)
    moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
    moneyBG:SetPoint("BOTTOMLEFT", 20, 18)
    moneyBG:SetPoint("TOPRIGHT", _G.AuctionFrame, "BOTTOMLEFT", 175, 35)

    F.ReskinClose(_G.AuctionFrameCloseButton)

    local function SkinSort(sortButtons)
        for i = 1, #sortButtons do
            _G[sortButtons[i]]:DisableDrawLayer("BACKGROUND")
        end
    end
    local function SkinScroll(scroll)
        scroll:GetRegions():Hide()
        select(2, scroll:GetRegions()):Hide()
        F.ReskinScroll(scroll.ScrollBar)
    end
    local function SkinList(prefix, middleIdx, numToDisplay)
        for i = 1, numToDisplay do
            local name = prefix..i
            local button = _G[name]
            local item = _G[name.."Item"]
            local icon = _G[name.."ItemIconTexture"]

            if button and item then
                item._auroraIconBorder = F.ReskinIcon(icon)
                item:SetNormalTexture("")
                item:SetPushedTexture("")

                _G[name.."Left"]:Hide()
                _G[name.."Right"]:Hide()
                select(middleIdx, button:GetRegions()):Hide() -- middle

                local bd = _G.CreateFrame("Frame", nil, button)
                bd:SetPoint("TOPLEFT", item, "TOPRIGHT", 2, 1)
                bd:SetPoint("BOTTOMRIGHT", 0, 4)
                bd:SetFrameLevel(button:GetFrameLevel()-1)
                F.CreateBD(bd, .25)
                button._auroraBD = bd

                local highlight = button:GetHighlightTexture()
                highlight:SetTexture([[Interface\ClassTrainerFrame\TrainerTextures]])
                highlight:SetTexCoord(0.005859375, 0.5703125, 0.85546875, 0.939453125)
                highlight:SetPoint("TOPLEFT", bd, 1, -1)
                highlight:SetPoint("BOTTOMRIGHT", bd, -1, 1)
            end
        end
    end
    local function SkinButtons(buttons, hasBorder)
        for i = 1, #buttons do
            local button = buttons[i]
            F.Reskin(button)
            if hasBorder then
                select(6, button:GetRegions()):Hide()
            end
            if i == 1 then
                button:SetPoint("BOTTOMRIGHT", 66, 15)
            else
                button:SetPoint("RIGHT", buttons[i - 1], "LEFT", -1, 0)
            end
        end
    end

    --[[ Browse ]]--
    local filterButtonColor = {r = 0.2, g = 0.2, b = 0.2}
    local wowTokenColor = _G.BAG_ITEM_QUALITY_COLORS[_G.LE_ITEM_QUALITY_WOW_TOKEN]
    _G.hooksecurefunc("FilterButton_SetUp", function(button, info)
        if not button._auroraSkinned then
            F.CreateBD(button, 0)
            button._auroraSkinned = true
        end
        local color
        if info.isToken then
            color = wowTokenColor
        else
            color = filterButtonColor
        end
        button:SetBackdropColor(color.r, color.g, color.b, 0.6)
        button:SetBackdropBorderColor(color.r, color.g, color.b)
        button:SetNormalTexture("")
    end)
    SkinScroll(_G.BrowseFilterScrollFrame)
    SkinScroll(_G.BrowseScrollFrame)

    -- WoW token
    local BrowseWowTokenResults = _G.BrowseWowTokenResults
    F.Reskin(BrowseWowTokenResults.Buyout)

    local token = BrowseWowTokenResults.Token
    token.ItemBorder:Hide()
    local itemBG = F.CreateBDFrame(token.ItemBorder, .2)
    itemBG:SetPoint("TOPLEFT", token.Icon, "TOPRIGHT", 3, 1)
    itemBG:SetPoint("BOTTOMRIGHT", -2, 2)
    local iconBG = F.ReskinIcon(token.Icon)
    iconBG:SetBackdropBorderColor(wowTokenColor.r, wowTokenColor.g, wowTokenColor.b)
    token.IconBorder:Hide()

    local WowTokenGameTimeTutorial = _G.WowTokenGameTimeTutorial
    F.ReskinPortraitFrame(WowTokenGameTimeTutorial, true)
    WowTokenGameTimeTutorial.Tutorial:SetDrawLayer("BACKGROUND", 7)

    F.Reskin(_G.StoreButton)
    _G.StoreButton:SetSize(149, 26)
    _G.StoreButton:SetPoint("TOPLEFT", _G.WowTokenGameTimeTutorial.RightDisplay.Tutorial2, "BOTTOMLEFT", 56, -12)

    SkinSort({"BrowseQualitySort", "BrowseLevelSort", "BrowseDurationSort", "BrowseHighBidderSort", "BrowseCurrentBidSort"})
    SkinList("BrowseButton", 5, _G.NUM_BROWSE_TO_DISPLAY)

    F.ReskinInput(_G.BrowseName)
    F.ReskinInput(_G.BrowseMinLevel)
    F.ReskinInput(_G.BrowseMaxLevel)
    F.ReskinDropDown(_G.BrowseDropDown)
    F.ReskinCheck(_G.IsUsableCheckButton)
    F.ReskinCheck(_G.ShowOnPlayerCheckButton)
    F.Reskin(_G.BrowseSearchButton)

    F.ReskinArrow(_G.BrowsePrevPageButton, "Left")
    _G.BrowsePrevPageButton:SetPoint("TOPLEFT", 660, -60)
    F.ReskinArrow(_G.BrowseNextPageButton, "Right")
    _G.BrowseNextPageButton:SetPoint("TOPRIGHT", 67, -60)

    SkinButtons({_G.BrowseCloseButton, _G.BrowseBuyoutButton, _G.BrowseBidButton}, true)
    F.ReskinMoneyInput(_G.BrowseBidPrice)

    --[[ Bid ]]--
    SkinSort({"BidQualitySort", "BidLevelSort", "BidDurationSort", "BidBuyoutSort", "BidStatusSort", "BidBidSort"})
    SkinScroll(_G.BidScrollFrame)
    SkinList("BidButton", 6, _G.NUM_BIDS_TO_DISPLAY)
    F.ReskinMoneyInput(_G.BidBidPrice)
    SkinButtons({_G.BidCloseButton, _G.BidBuyoutButton, _G.BidBidButton}, true)

    --[[ Auctions ]]--
    SkinSort({"AuctionsQualitySort", "AuctionsDurationSort", "AuctionsHighBidderSort", "AuctionsBidSort"})
    SkinScroll(_G.AuctionsScrollFrame)
    SkinList("AuctionsButton", 4, _G.NUM_AUCTIONS_TO_DISPLAY)

    _G.AuctionsItemButton._auroraIconBorder = F.CreateBDFrame(_G.AuctionsItemButton, .2)
    local nameFrame = select(2, _G.AuctionsItemButton:GetRegions())
    nameFrame:Hide()
    local nameBG = F.CreateBDFrame(_G.AuctionsItemButton, .2)
    nameBG:SetPoint("TOPLEFT", _G.AuctionsItemButton, "TOPRIGHT", 3, 1)
    nameBG:SetPoint("BOTTOMRIGHT", nameFrame)
    _G.AuctionsItemButton:HookScript("OnEvent", function(self, event, ...)
        local icon = _G.AuctionsItemButton:GetNormalTexture()
        if icon then
            icon:SetTexCoord(.08, .92, .08, .92)
        end
    end)

    F.ReskinInput(_G.AuctionsStackSizeEntry)
    F.Reskin(_G.AuctionsStackSizeMaxButton)
    F.ReskinInput(_G.AuctionsNumStacksEntry)
    F.Reskin(_G.AuctionsNumStacksMaxButton)
    F.ReskinDropDown(_G.PriceDropDown)
    F.ReskinMoneyInput(_G.StartPrice)
    F.ReskinMoneyInput(_G.BuyoutPrice)
    SkinButtons({_G.AuctionsCloseButton, _G.AuctionsCancelAuctionButton})
    F.Reskin(_G.AuctionsCreateAuctionButton)

    -- AuctionProgressFrame
    for i = 1, 4 do
        select(i, _G.AuctionProgressFrame:GetRegions()):Hide()
    end
    F.CreateBD(_G.AuctionProgressFrame)
    _G.AuctionProgressFrame:SetSize(280, 53)
    _G.AuctionProgressFrame:SetPoint("BOTTOM", 0, 179)

    local AuctionProgressBar = _G.AuctionProgressBar
    F.CreateBD(AuctionProgressBar, 0)
    AuctionProgressBar:SetPoint("CENTER", 3, -1)
    AuctionProgressBar:SetStatusBarTexture(C.media.backdrop)
    AuctionProgressBar.Border:Hide()
    AuctionProgressBar.Text:ClearAllPoints()
    AuctionProgressBar.Text:SetPoint("CENTER", 0, 1)
    F.ReskinIcon(AuctionProgressBar.Icon)
    AuctionProgressBar.Icon:ClearAllPoints()
    AuctionProgressBar.Icon:SetPoint("TOPRIGHT", AuctionProgressBar, "TOPLEFT", -10, 5)
    F.ReskinClose(_G.AuctionProgressFrameCancelButton, "TOPLEFT", AuctionProgressBar, "TOPRIGHT", 11, 2)
    ]=]
end
