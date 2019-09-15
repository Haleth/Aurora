local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\BankFrame.lua ]]
    function Hook.BankFrameItemButton_Update(button)
        if not button._auroraIconBorder then
            local container = button:GetParent():GetID()
            local buttonID = button:GetID()

            if button.isBag then
                container = -4
                Skin.BankItemButtonBagTemplate(button)
            else
                Skin.BankItemButtonGenericTemplate(button)
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
        Skin.FrameTypeItemButton(ItemButton)

        local bd = ItemButton._auroraIconBorder:GetBackdropTexture("bg")
        bd:SetTexture([[Interface\PaperDoll\UI-Backpack-EmptySlot]])
        bd:SetAlpha(0.75)
        Base.CropIcon(bd)

        Base.CropIcon(ItemButton.IconQuestTexture)
    end
    function Skin.BankItemButtonBagTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        Base.CropIcon(ItemButton:GetCheckedTexture())
    end

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
    Base.SetBackdrop(_G.BankFrame)
    _G.BankPortraitTexture:Hide()
    Skin.UIPanelCloseButton(_G.BankCloseButton)
    -- TODO: Maybe that should be 6 now?
    select(7, _G.BankFrame:GetRegions()):Hide() -- Bank-Background

    local BankSlotsFrame = _G.BankSlotsFrame
    BankSlotsFrame:DisableDrawLayer("BORDER")
    select(9, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY") -- ITEMSLOTTEXT
    select(10, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY") -- BAGSLOTTEXT

    Skin.UIPanelButtonTemplate(_G.BankFramePurchaseButton)
    Skin.SmallMoneyFrameTemplate(_G.BankFrameMoneyFrameInset)
end
