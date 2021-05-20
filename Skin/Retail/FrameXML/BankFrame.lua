local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

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

        if not button.isBag and button.IconQuestTexture:IsShown() then
            button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
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
        Base.CropIcon(ItemButton.SlotHighlightTexture)
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
    Skin.PortraitFrameTemplate(BankFrame)
    _G.BankPortraitTexture:Hide()
    select(7, BankFrame:GetRegions()):Hide() -- Bank-Background

    Skin.CharacterFrameTabButtonTemplate(_G.BankFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.BankFrameTab2)
    Util.PositionRelative("TOPLEFT", BankFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.BankFrameTab1,
        _G.BankFrameTab2,
    })

    Skin.BagSearchBoxTemplate(_G.BankItemSearchBox)
    Skin.BankAutoSortButtonTemplate(_G.BankItemAutoSortButton)

    local BankSlotsFrame = _G.BankSlotsFrame
    BankSlotsFrame:DisableDrawLayer("BORDER")
    select(9, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY") -- ITEMSLOTTEXT
    select(10, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY") -- BAGSLOTTEXT

    Skin.UIPanelButtonTemplate(_G.BankFramePurchaseButton)
    Skin.InsetFrameTemplate(_G.BankFrameMoneyFrameInset)
    Skin.ThinGoldEdgeTemplate(_G.BankFrameMoneyFrameBorder)


    --[[ ReagentBankFrame ]]--
    local ReagentBankFrame = _G.ReagentBankFrame
    ReagentBankFrame:DisableDrawLayer("BACKGROUND")
    ReagentBankFrame:DisableDrawLayer("BORDER")
    ReagentBankFrame:DisableDrawLayer("ARTWORK")

    Skin.UIPanelButtonTemplate(ReagentBankFrame.DespositButton)

    ReagentBankFrame.UnlockInfo:DisableDrawLayer("BORDER")
    Skin.UIPanelButtonTemplate(_G.ReagentBankFrameUnlockInfoPurchaseButton) -- BlizzWTF: no parentKey?
end
