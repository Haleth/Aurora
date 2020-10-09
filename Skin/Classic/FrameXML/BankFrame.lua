local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\BankFrame.lua ]]
    function Hook.BankFrameItemButton_Update(button)
        local bagID = button.isBag and -4 or button:GetParent():GetID()
        local slotID = button:GetID()

        local _, _, _, quality, _, _, link = _G.GetContainerItemInfo(bagID, slotID)
        if not button._auroraIconBorder then
            if bagID == _G.REAGENTBANK_CONTAINER then
                Skin.ReagentBankItemButtonGenericTemplate(button)
            else
                if button.isBag then
                    Skin.BankItemButtonBagTemplate(button)
                else
                    Skin.BankItemButtonGenericTemplate(button)
                end
            end

            Hook.SetItemButtonQuality(button, quality, link)
        end

        if link then
            local _, _, _, _, _, _, _, _, _, _, _, itemClassID = _G.GetItemInfo(link)
            if itemClassID == _G.LE_ITEM_CLASS_QUESTITEM then
                button.IconQuestTexture:Show()
                button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
            end
        end
    end
end

do --[[ FrameXML\BankFrame.xml ]]
    function Skin.BankItemButtonGenericTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        ItemButton:SetBackdropOptions({
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false
        })
        ItemButton:SetBackdropColor(1, 1, 1, 0.75)
        Base.CropIcon(ItemButton:GetBackdropTexture("bg"))

        Base.CropIcon(ItemButton.IconQuestTexture)
    end
    function Skin.BankItemButtonBagTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        Base.CropIcon(ItemButton.HighlightFrame.HighlightTexture)
    end
end

function private.FrameXML.BankFrame()
    if private.disabled.bags then return end
    _G.hooksecurefunc("BankFrameItemButton_Update", Hook.BankFrameItemButton_Update)

    --[[ BankFrame ]]--
    local BankFrame = _G.BankFrame
    Skin.FrameTypeFrame(BankFrame)
    BankFrame:SetBackdropOption("offsets", {
        left = 12,
        right = 35,
        top = 13,
        bottom = 94,
    })

    local portrait, bankBG = BankFrame:GetRegions()
    portrait:Hide()
    bankBG:Hide()

    local bg = BankFrame:GetBackdropTexture("bg")
    _G.BankFrameTitleText:ClearAllPoints()
    _G.BankFrameTitleText:SetPoint("TOPLEFT", bg)
    _G.BankFrameTitleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelCloseButton(_G.BankCloseButton)

    local BankSlotsFrame = _G.BankSlotsFrame
    for i = 1, 24 do
        Skin.BankItemButtonGenericTemplate(BankSlotsFrame["Item"..i])
    end

    for i = 1, 6 do
        Skin.BankItemButtonBagTemplate(BankSlotsFrame["Bag"..i])
    end

    for i = 1, select("#", BankSlotsFrame:GetRegions()) do
        select(i, BankSlotsFrame:GetRegions()):Hide()
    end

    Skin.UIPanelButtonTemplate(_G.BankFramePurchaseButton)
    Skin.SmallMoneyFrameTemplate(_G.BankFrameDetailMoneyFrame)

    local moneyBG = _G.CreateFrame("Frame", nil, BankFrame)
    Base.SetBackdrop(moneyBG, Color.frame)
    moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
    moneyBG:SetPoint("BOTTOMLEFT", bg, 5, 5)
    moneyBG:SetPoint("TOPRIGHT", bg, "BOTTOMRIGHT", -5, 27)
    Skin.SmallMoneyFrameTemplate(_G.BankFrameMoneyFrame)
    _G.BankFrameMoneyFrame:SetPoint("BOTTOMRIGHT", moneyBG, 7, 5)
end
