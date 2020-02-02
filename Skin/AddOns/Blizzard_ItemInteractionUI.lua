local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_ItemInteractionUI.lua ]]
    Hook.ItemInteractionMixin = {}
    function Hook.ItemInteractionMixin:UpdateCostFrame()
        local costsMoney = self:CostsGold()
        local costsCurrency = self:CostsCurrency()
        local hasPrice = costsMoney or costsCurrency
        local buttonFrame = self.ButtonFrame
        local bg = self.NineSlice:GetBackdropTexture("bg")

        if not hasPrice then
            buttonFrame.ActionButton:SetPoint("BOTTOM", bg, 0, 5)
        else
            buttonFrame.ActionButton:SetPoint("BOTTOMRIGHT", bg, -5, 5)
        end
    end
end

--do --[[ AddOns\Blizzard_ItemInteractionUI.xml ]]
--end

function private.AddOns.Blizzard_ItemInteractionUI()
    local ItemInteractionFrame = _G.ItemInteractionFrame
    Util.Mixin(ItemInteractionFrame, Hook.ItemInteractionMixin)
    Skin.PortraitFrameTemplate(ItemInteractionFrame)
    ItemInteractionFrame.NineSlice:SetBackdropOption("offsets", {
        left = 2,
        right = 2,
        top = 20,
        bottom = 0,
    })

    local bg = ItemInteractionFrame.NineSlice:GetBackdropTexture("bg")
    local titleText = ItemInteractionFrame.TitleText
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT", bg)
    titleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    ItemInteractionFrame.CloseButton:SetPoint("TOPRIGHT", bg, 5.6, 5)

    do -- ItemSlot
        local ItemSlot = ItemInteractionFrame.ItemSlot
        Base.CreateBackdrop(ItemSlot, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        ItemSlot:SetBackdropColor(1, 1, 1, 1)
        ItemSlot:SetBackdropBorderColor(Color.cyan, 1)
        Base.CropIcon(ItemSlot:GetBackdropTexture("bg"))

        ItemSlot:SetSize(58, 58)
        ItemSlot:ClearAllPoints()
        ItemSlot:SetPoint("TOPLEFT", 143, -97)

        ItemSlot.Icon:ClearAllPoints()
        ItemSlot.Icon:SetPoint("TOPLEFT", 1, -1)
        ItemSlot.Icon:SetPoint("BOTTOMRIGHT", -1, 1)
        Base.CropIcon(ItemSlot.Icon)

        ItemSlot.GlowOverlay:SetAlpha(0)
    end

    local ButtonFrame = ItemInteractionFrame.ButtonFrame
    Skin.MagicButtonTemplate(ButtonFrame.ActionButton)
    Skin.ThinGoldEdgeTemplate(ButtonFrame.MoneyFrameEdge)
    ButtonFrame.MoneyFrameEdge:ClearAllPoints()
    ButtonFrame.MoneyFrameEdge:SetPoint("BOTTOMLEFT", bg, 5, 5)
    ButtonFrame.MoneyFrameEdge:SetPoint("TOPRIGHT", ButtonFrame.ActionButton, "TOPLEFT", -5, 0)
    Skin.BackpackTokenTemplate(ButtonFrame.Currency)
    ButtonFrame.Currency:SetPoint("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, -9, 4)
    Skin.SmallMoneyFrameTemplate(ButtonFrame.MoneyFrame)
    ButtonFrame.MoneyFrame:SetPoint("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, 7, 5)

    ButtonFrame.BlackBorder:SetAlpha(0)
    ButtonFrame.ButtonBorder:Hide()
    ButtonFrame.ButtonBottomBorder:Hide()
end
