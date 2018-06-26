local _, private = ...

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
    AzeriteRespecFrame:SetClipsChildren(true)
    AzeriteRespecFrame.Background:Hide()

    AzeriteRespecFrame.ItemSlot:SetSize(66, 66)
    AzeriteRespecFrame.ItemSlot:SetPoint("CENTER", AzeriteRespecFrame)
    AzeriteRespecFrame.ItemSlot.Icon:ClearAllPoints()
    AzeriteRespecFrame.ItemSlot.Icon:SetPoint("TOPLEFT", 1, -1)
    AzeriteRespecFrame.ItemSlot.Icon:SetPoint("BOTTOMRIGHT", -1, 1)
    AzeriteRespecFrame.ItemSlot.GlowOverlay:SetAlpha(0)
    Base.SetBackdrop(AzeriteRespecFrame.ItemSlot, Color.violet, 0.5)
    Base.CropIcon(AzeriteRespecFrame.ItemSlot.Icon)

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

    Skin.GlowBoxFrame(AzeriteRespecFrame.HelpBox)

    --[[ Scale ]]--
end
