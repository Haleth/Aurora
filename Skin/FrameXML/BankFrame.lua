local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

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

        if private.isRetail then
            if not button.isBag and button.IconQuestTexture:IsShown() then
                button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
            end
        else
            if link then
                local _, _, _, _, _, _, _, _, _, _, _, itemClassID = _G.GetItemInfo(link)
                if itemClassID == _G.LE_ITEM_CLASS_QUESTITEM then
                    button.IconQuestTexture:Show()
                    button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
                end
            end
        end
    end
end

do --[[ FrameXML\BankFrame.xml ]]
    function Skin.BankItemButtonGenericTemplate(ItemButton)
        Base.CreateBackdrop(ItemButton, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false
        })
        Skin.FrameTypeItemButton(ItemButton)
        ItemButton:SetBackdropColor(1, 1, 1, 0.75)
        Base.CropIcon(ItemButton:GetBackdropTexture("bg"))

        Base.CropIcon(ItemButton.IconQuestTexture)
    end
    function Skin.BankItemButtonBagTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        if private.isRetail then
            Base.CropIcon(ItemButton.SlotHighlightTexture)
        else
            Base.CropIcon(ItemButton.HighlightFrame.HighlightTexture)
        end
    end
    Skin.ReagentBankItemButtonGenericTemplate = Skin.BankItemButtonGenericTemplate

    -- BlizzWTF: Why is this not shared with ContainerFrame?
    function Skin.BankAutoSortButtonTemplate(Button)
        Button:SetSize(26, 26)
        Button:SetNormalTexture([[Interface\Icons\INV_Pet_Broom]])
        Button:GetNormalTexture():SetTexCoord(.13, .92, .13, .92)

        Button:SetPushedTexture([[Interface\Icons\INV_Pet_Broom]])
        Button:GetPushedTexture():SetTexCoord(.08, .87, .08, .87)

        local iconBorder = Button:CreateTexture(nil, "BACKGROUND")
        iconBorder:SetPoint("TOPLEFT", Button, -1, 1)
        iconBorder:SetPoint("BOTTOMRIGHT", Button, 1, -1)
        iconBorder:SetColorTexture(0, 0, 0)
    end
end

function private.FrameXML.BankFrame()
    if private.disabled.bags then return end
    _G.hooksecurefunc("BankFrameItemButton_Update", Hook.BankFrameItemButton_Update)

    --[[ BankFrame ]]--
    local BankFrame = _G.BankFrame
    if private.isRetail then
        Skin.PortraitFrameTemplate(BankFrame)
        _G.BankPortraitTexture:Hide()
        select(7, BankFrame:GetRegions()):Hide() -- Bank-Background

        Skin.CharacterFrameTabButtonTemplate(_G.BankFrameTab1)
        Skin.CharacterFrameTabButtonTemplate(_G.BankFrameTab2)
        Util.PositionRelative("TOPLEFT", BankFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
            _G.BankFrameTab1,
            _G.BankFrameTab2,
        })

        if not private.isPatch then
            Skin.GlowBoxFrame(BankFrame.GlowBox, "Left")
        end
        Skin.BagSearchBoxTemplate(_G.BankItemSearchBox)
        Skin.BankAutoSortButtonTemplate(_G.BankItemAutoSortButton)

        local BankSlotsFrame = _G.BankSlotsFrame
        BankSlotsFrame:DisableDrawLayer("BORDER")
        select(9, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY") -- ITEMSLOTTEXT
        select(10, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY") -- BAGSLOTTEXT

        Skin.UIPanelButtonTemplate(_G.BankFramePurchaseButton)
        Skin.InsetFrameTemplate(_G.BankFrameMoneyFrameInset)
        Skin.ThinGoldEdgeTemplate(_G.BankFrameMoneyFrameBorder)
    else
        Base.SetBackdrop(BankFrame)
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


    --[[ ReagentBankFrame ]]--
    if private.isRetail then
        local ReagentBankFrame = _G.ReagentBankFrame
        ReagentBankFrame:DisableDrawLayer("BACKGROUND")
        ReagentBankFrame:DisableDrawLayer("BORDER")
        ReagentBankFrame:DisableDrawLayer("ARTWORK")

        Skin.UIPanelButtonTemplate(ReagentBankFrame.DespositButton)

        ReagentBankFrame.UnlockInfo:DisableDrawLayer("BORDER")
        Skin.UIPanelButtonTemplate(_G.ReagentBankFrameUnlockInfoPurchaseButton) -- BlizzWTF: no parentKey?
    end
end
