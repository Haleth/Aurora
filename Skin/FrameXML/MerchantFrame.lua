local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\MoneyFrame.lua ]]
    local numCurrencies = 0
    function Hook.MerchantFrame_UpdateCurrencies()
        for i = numCurrencies + 1, _G.MAX_MERCHANT_CURRENCIES do
            local button = _G["MerchantToken"..i]
            if button then
                Skin.BackpackTokenTemplate(button)
                numCurrencies = numCurrencies + 1
            end
        end
    end
end

do --[[ FrameXML\MerchantFrame.xml ]]
    function Skin.MerchantItemTemplate(Frame)
        local name = Frame:GetName()
        _G[name.."SlotTexture"]:Hide()
        _G[name.."NameFrame"]:Hide()

        local bg = _G.CreateFrame("Frame", nil, Frame)
        bg:SetPoint("TOPLEFT", Frame.ItemButton.icon, "TOPRIGHT", 2, 1)
        bg:SetPoint("BOTTOMRIGHT", 0, -4)
        Base.SetBackdrop(bg, Color.frame)

        Frame.Name:ClearAllPoints()
        Frame.Name:SetPoint("TOPLEFT", bg, 2, -1)
        Frame.Name:SetPoint("BOTTOMRIGHT", bg, 0, 14)

        Skin.ItemButtonTemplate(Frame.ItemButton)
        Skin.SmallAlternateCurrencyFrameTemplate(_G[name.."AltCurrencyFrame"])
    end
end

function private.FrameXML.MerchantFrame()
    _G.hooksecurefunc("MerchantFrame_UpdateCurrencies", Hook.MerchantFrame_UpdateCurrencies)

    Skin.ButtonFrameTemplate(_G.MerchantFrame)
    _G.BuybackBG:SetPoint("TOPLEFT")
    _G.BuybackBG:SetPoint("BOTTOMRIGHT")

    -- BlizzWTF: This should use the title text included in the template
    _G.MerchantNameText:SetAllPoints(_G.MerchantFrame.TitleText)

    _G.MerchantFrameBottomLeftBorder:SetAlpha(0)
    _G.MerchantFrameBottomRightBorder:SetAlpha(0)

    for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
        Skin.MerchantItemTemplate(_G["MerchantItem"..i])
    end

    _G.MerchantRepairAllButton:SetPushedTexture("")
    _G.MerchantRepairAllIcon:SetTexture([[Interface\Icons\Trade_BlackSmithing]])
    Base.CropIcon(_G.MerchantRepairAllIcon, _G.MerchantRepairAllButton)

    local repairItem = _G.MerchantRepairItemButton:GetRegions()
    _G.MerchantRepairItemButton:SetPushedTexture("")
    repairItem:SetTexture([[Interface\Icons\INV_Hammer_20]])
    Base.CropIcon(repairItem, _G.MerchantRepairItemButton)

    _G.MerchantGuildBankRepairButton:SetPushedTexture("")
    _G.MerchantGuildBankRepairButtonIcon:SetTexture([[Interface\Icons\Trade_BlackSmithing]])
    _G.MerchantGuildBankRepairButtonIcon:SetVertexColor(0.9, 0.8, 0)
    Base.CropIcon(_G.MerchantGuildBankRepairButtonIcon, _G.MerchantGuildBankRepairButton)

    do
        local name = _G.MerchantBuyBackItem:GetName()
        _G[name.."SlotTexture"]:Hide()
        _G[name.."NameFrame"]:Hide()

        local bg = _G.CreateFrame("Frame", nil, _G.MerchantBuyBackItem)
        bg:SetPoint("TOPLEFT", _G.MerchantBuyBackItem.ItemButton.icon, "TOPRIGHT", 2, 1)
        bg:SetPoint("BOTTOMRIGHT", 0, -1)
        Base.SetBackdrop(bg, Color.frame)

        _G.MerchantBuyBackItem.Name:ClearAllPoints()
        _G.MerchantBuyBackItem.Name:SetPoint("TOPLEFT", bg, 2, -1)
        _G.MerchantBuyBackItem.Name:SetPoint("BOTTOMRIGHT", bg, 0, 14)

        Skin.ItemButtonTemplate(_G.MerchantBuyBackItem.ItemButton)
        _G[name.."MoneyFrame"]:SetPoint("BOTTOMLEFT", bg, 1, 1)
    end

    _G.MerchantExtraCurrencyInset:SetAlpha(0)
    Skin.ThinGoldEdgeTemplate(_G.MerchantExtraCurrencyBg, true)
    _G.MerchantMoneyInset:Hide()
    Skin.ThinGoldEdgeTemplate(_G.MerchantMoneyBg, true)

    for i, delta in _G.next, {"PrevPageButton", "NextPageButton"} do
        local button = _G["Merchant"..delta]
        button:ClearAllPoints()

        local label, bg = button:GetRegions()
        bg:Hide()
        if i == 1 then
            Skin.NavButtonPrevious(button)
            button:SetPoint("BOTTOMLEFT", 16, 82)
            label:SetPoint("LEFT", button, "RIGHT", 3, 0)
        else
            Skin.NavButtonNext(button)
            button:SetPoint("BOTTOMRIGHT", -16, 82)
            label:SetPoint("RIGHT", button, "LEFT", -3, 0)
        end
    end

    Skin.CharacterFrameTabButtonTemplate(_G.MerchantFrameTab1)
    _G.MerchantFrameTab1:ClearAllPoints()
    _G.MerchantFrameTab1:SetPoint("TOPLEFT", _G.MerchantFrame, "BOTTOMLEFT", 20, -1)
    Skin.CharacterFrameTabButtonTemplate(_G.MerchantFrameTab2)
    _G.MerchantFrameTab2:SetPoint("TOPLEFT", _G.MerchantFrameTab1, "TOPRIGHT", 1, 0)

    Skin.UIDropDownMenuTemplate(_G.MerchantFrame.lootFilter)
end
