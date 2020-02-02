local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do AddOns\Blizzard_AzeriteRespecUI.lua
end ]]

--[[ do AddOns\Blizzard_AzeriteRespecUI.xml
end ]]

function private.AddOns.Blizzard_AzeriteRespecUI()
    local AzeriteRespecFrame = _G.AzeriteRespecFrame
    Skin.EtherealFrameTemplate(AzeriteRespecFrame)
    AzeriteRespecFrame.Background:Hide()

    do -- ItemSlot
        local ItemSlot = AzeriteRespecFrame.ItemSlot
        Base.CreateBackdrop(ItemSlot, {
            bgFile = [[Interface\Icons\Spell_Frost_Stun]],
            --bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        local bg = ItemSlot:GetBackdropTexture("bg")
        bg:SetDesaturated(true)
        bg:SetBlendMode("ADD")
        Base.CropIcon(bg)
        Base.SetBackdropColor(ItemSlot, Color.violet, 0.8)

        ItemSlot:SetSize(58, 58)
        ItemSlot:ClearAllPoints()
        ItemSlot:SetPoint("TOPLEFT", 143, -97)

        ItemSlot.Icon:ClearAllPoints()
        ItemSlot.Icon:SetPoint("TOPLEFT", 1, -1)
        ItemSlot.Icon:SetPoint("BOTTOMRIGHT", -1, 1)
        Base.CropIcon(ItemSlot.Icon)

        ItemSlot.GlowOverlay:SetAlpha(0)
    end

    local ButtonFrame = AzeriteRespecFrame.ButtonFrame
    Skin.MagicButtonTemplate(ButtonFrame.AzeriteRespecButton)
    ButtonFrame.AzeriteRespecButton:SetPoint("BOTTOMRIGHT", -5, 5)
    Skin.ThinGoldEdgeTemplate(ButtonFrame.MoneyFrameEdge)
    ButtonFrame.MoneyFrameEdge:ClearAllPoints()
    ButtonFrame.MoneyFrameEdge:SetPoint("BOTTOMLEFT", 5, 5)
    ButtonFrame.MoneyFrameEdge:SetPoint("TOPRIGHT", ButtonFrame.AzeriteRespecButton, "TOPLEFT", -5, 0)
    Skin.SmallMoneyFrameTemplate(ButtonFrame.MoneyFrame)
    ButtonFrame.MoneyFrame:SetPoint("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, 7, 5)

    ButtonFrame:GetRegions():Hide()
    ButtonFrame.ButtonBorder:Hide()
    ButtonFrame.ButtonBottomBorder:Hide()
end
