local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_ItemUpgradeUI.lua ]]
    function Hook.ItemUpgradeFrame_Update()
        local ItemButton = _G.ItemUpgradeFrame.ItemButton
        if not _G.GetItemUpgradeItemInfo() then
            ItemButton.IconTexture:SetTexture([[Interface\PaperDoll\UI-Backpack-EmptySlot]])
        end
        Base.CropIcon(ItemButton.IconTexture)
    end
end

--do --[[ AddOns\Blizzard_ItemUpgradeUI.xml ]]
--end

function private.AddOns.Blizzard_ItemUpgradeUI()
    _G.hooksecurefunc("ItemUpgradeFrame_Update", Hook.ItemUpgradeFrame_Update)

    local ItemUpgradeFrame = _G.ItemUpgradeFrame
    Skin.ButtonFrameTemplate(ItemUpgradeFrame)

    local TextFrame = ItemUpgradeFrame.TextFrame
    TextFrame:GetRegions():Hide() -- BG
    TextFrame.Right:Hide()
    TextFrame.TopRight:Hide()
    TextFrame.BottomRight:Hide()
    TextFrame.Top:Hide()
    TextFrame.Bottom:Hide()

    local ItemButton = ItemUpgradeFrame.ItemButton
    Base.CropIcon(ItemButton.IconTexture, ItemButton)
    ItemButton.Frame:Hide()
    Base.CropIcon(ItemButton:GetPushedTexture())
    ItemButton:GetHighlightTexture():SetTexCoord(0.05, 0.95, 0.05, 0.95)

    local ButtonFrame = ItemUpgradeFrame.ButtonFrame
    ButtonFrame:GetRegions():Hide()
    ButtonFrame.ButtonBorder:Hide()
    ButtonFrame.ButtonBottomBorder:Hide()

    Skin.ThinGoldEdgeTemplate(_G.ItemUpgradeFrameMoneyFrame)
    Skin.BackpackTokenTemplate(_G.ItemUpgradeFrameMoneyFrame.Currency)
    Skin.MagicButtonTemplate(_G.ItemUpgradeFrameUpgradeButton)
end
