local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    local function SkinHighlightFrames(user)
        local name = "TradeHighlight" .. user
        local frame = _G[name]
        for i = 1, 2 do
            if i == 2 then
                name = name .. "Enchant"
                frame = _G[name]
                frame:SetPoint("TOPLEFT", "Trade"..user.."Item7", -5, 17)
                frame:SetPoint("BOTTOMRIGHT", "Trade"..user.."Item7", 2, -5)
            else
                frame:SetPoint("TOPLEFT", "Trade"..user.."Item1", -5, 5)
                frame:SetPoint("BOTTOMRIGHT", "Trade"..user.."Item6", 2, -5)
            end

            _G[name.."Top"]:Hide()
            _G[name.."Bottom"]:Hide()
            _G[name.."Middle"]:Hide()

            F.CreateBD(frame, 0)
            frame:SetBackdropColor(0, 1, 0, 0.3)
            frame:SetBackdropBorderColor(0, 1, 0, 0.9)
        end
    end
    local function SkinTradeItems(user)
        local prefix = "Trade"..user
        _G[prefix.."ItemsInset"]:DisableDrawLayer("BORDER")
        _G[prefix.."ItemsInsetBg"]:Hide()
        _G[prefix.."EnchantInset"]:DisableDrawLayer("BORDER")
        _G[prefix.."EnchantInsetBg"]:Hide()

        prefix = prefix.."Item"
        local xOfs, yOfs
        if user == "Player" then
            xOfs, yOfs = 11, -70
        else
            xOfs, yOfs = 183, -70
        end

        for i = 1, _G.MAX_TRADE_ITEMS do
            local name = prefix..i
            local frame = _G[name]
            _G[name.."SlotTexture"]:Hide()

            local itemButton = _G[name.."ItemButton"]
            private.Skin.ItemButtonTemplate(itemButton)

            local nameFrame = _G[name.."NameFrame"]
            nameFrame:SetAlpha(0)

            local bg = _G.CreateFrame("Frame", nil, itemButton)
            bg:SetPoint("TOP", itemButton.icon, 0, 1)
            bg:SetPoint("BOTTOM", itemButton.icon, 0, -1)
            bg:SetPoint("LEFT", itemButton.icon, "RIGHT", 2, 0)
            bg:SetPoint("RIGHT", nameFrame, -4, 0)
            F.CreateBD(bg, .2)

            if i == 1 then
                frame:SetPoint("TOPLEFT", xOfs, yOfs)
            elseif i == 7 then
                frame:SetPoint("TOPLEFT", _G[prefix .. i - 1], "BOTTOMLEFT", 0, -27)
                local icon = _G.select(4, frame:GetRegions())
                icon:SetTexture([[Interface/Icons/INV_Potion_07]])
                icon:SetTexCoord(.08, .92, .08, .92)
                icon:SetDesaturated(true)
                icon:SetAllPoints(itemButton.icon)
            else
                frame:SetPoint("TOPLEFT", _G[prefix .. i - 1], "BOTTOMLEFT", 0, -11)
            end
            itemButton._auroraNameBG = bg
        end
    end

    F.ReskinPortraitFrame(_G.TradeFrame, true)

    _G.TradeFrameTradeButton:SetPoint("BOTTOMRIGHT", -84, 4)
    F.Reskin(_G.TradeFrameTradeButton)
    F.Reskin(_G.TradeFrameCancelButton)

    --[[ PLayer ]]--
    _G.TradeFramePlayerPortrait:Hide()
    _G.TradeFramePlayerNameText:SetPoint("TOPLEFT")
    _G.TradeFramePlayerNameText:SetPoint("BOTTOMRIGHT", _G.TradeFrame, "TOPLEFT", 172, -29)

    _G.TradePlayerInputMoneyInset:DisableDrawLayer("BORDER")
    _G.TradePlayerInputMoneyInsetBg:Hide()
    F.ReskinMoneyInput(_G.TradePlayerInputMoneyFrame)
    _G.TradePlayerInputMoneyFrame:SetPoint("TOPLEFT", 15, -35)

    SkinHighlightFrames("Player")
    SkinTradeItems("Player")

    --[[ Recipient ]]--
    _G.TradeFrameRecipientPortrait:Hide()
    _G.TradeRecipientPortraitFrame:Hide()
    _G.TradeRecipientBotLeftCorner:Hide()
    _G.TradeRecipientLeftBorder:Hide()

    _G.TradeRecipientBG:SetPoint("TOPLEFT", _G.TradeFrame, "TOPRIGHT", -172, 0)

    _G.TradeFrameRecipientNameText:SetPoint("TOPLEFT", _G.TradeFrame, "TOPRIGHT", -172, 0)
    _G.TradeFrameRecipientNameText:SetPoint("BOTTOMRIGHT", _G.TradeFrame, "TOPRIGHT", 0, -29)

    _G.TradeRecipientMoneyInset:DisableDrawLayer("BORDER")
    _G.TradeRecipientMoneyBg:Hide()
    local moneyBG = private.Skin.SmallMoneyFrameTemplate(_G.TradeRecipientMoneyFrame, true)
    moneyBG:SetPoint("TOPRIGHT", _G.TradeFrame, -6, -36)

    SkinHighlightFrames("Recipient")
    SkinTradeItems("Recipient")
end)
