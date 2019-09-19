local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\BankFrame.lua ]]
    function Hook.BankFrameItemButton_Update(button)
        if not button._auroraIconBorder then
            local container = button:GetParent():GetID()
            local buttonID = button:GetID()

            if container == _G.REAGENTBANK_CONTAINER then
                Skin.ReagentBankItemButtonGenericTemplate(button)
            else
                if button.isBag then
                    container = -4
                    Skin.BankItemButtonBagTemplate(button)
                else
                    Skin.BankItemButtonGenericTemplate(button)
                end
            end

            local _, _, _, quality, _, _, _, _, _, itemID = _G.GetContainerItemInfo(container, buttonID)
            Hook.SetItemButtonQuality(button, quality, itemID)
        end

        if not button.isBag and button.IconQuestTexture:IsShown() then
            button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
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
    Skin.PortraitFrameTemplate(_G.BankFrame)
    _G.BankPortraitTexture:Hide()
    select(7, _G.BankFrame:GetRegions()):Hide() -- Bank-Background

    Skin.CharacterFrameTabButtonTemplate(_G.BankFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.BankFrameTab2)
    Util.PositionRelative("TOPLEFT", _G.BankFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.BankFrameTab1,
        _G.BankFrameTab2,
    })

    Skin.GlowBoxFrame(_G.BankFrame.GlowBox, "Left")
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
