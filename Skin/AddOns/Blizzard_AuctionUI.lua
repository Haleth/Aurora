local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Color = Aurora.Color
local F, C = _G.unpack(Aurora)

function private.AddOns.Blizzard_AuctionUI()
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

    F.ReskinClose(_G.AuctionFrameCloseButton, "TOPRIGHT", _G.AuctionFrame, "TOPRIGHT", -4, -15)

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
    _G.hooksecurefunc("FilterButton_SetUp", function(button, info)
        if not button._auroraSkinned then
            F.CreateBD(button, 0)
            button._auroraSkinned = true
        end
        local color = filterButtonColor
        button:SetBackdropColor(color.r, color.g, color.b, 0.6)
        button:SetBackdropBorderColor(color.r, color.g, color.b)
        button:SetNormalTexture("")
    end)
    SkinScroll(_G.BrowseFilterScrollFrame)
    SkinScroll(_G.BrowseScrollFrame)

    SkinSort({"BrowseQualitySort", "BrowseLevelSort", "BrowseDurationSort", "BrowseHighBidderSort", "BrowseCurrentBidSort"})
    SkinList("BrowseButton", 5, _G.NUM_BROWSE_TO_DISPLAY)

    F.ReskinInput(_G.BrowseName)
    F.ReskinInput(_G.BrowseMinLevel)
    F.ReskinInput(_G.BrowseMaxLevel)
    F.ReskinDropDown(_G.BrowseDropDown)
    F.ReskinCheck(_G.IsUsableCheckButton)
    F.ReskinCheck(_G.ShowOnPlayerCheckButton)
    F.Reskin(_G.BrowseSearchButton)

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
end
