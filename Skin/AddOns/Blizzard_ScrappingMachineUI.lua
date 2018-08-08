local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_ScrappingMachineUI.lua ]]
    function Hook.ScrappingMachineItemSlotMixin_ClearSlot(self)
        self._auroraIconBorder:SetBackdropBorderColor(Color.button, 1)
    end
end

do --[[ AddOns\Blizzard_ScrappingMachineUI.xml ]]
    function Skin.ScrappingMachineItemSlot(Button)
        _G.hooksecurefunc(Button, "ClearSlot", Hook.ScrappingMachineItemSlotMixin_ClearSlot)

        Base.CropIcon(Button.Icon)

        local bd = _G.CreateFrame("Frame", nil, Button)
        bd:SetPoint("TOPLEFT", -1, 1)
        bd:SetPoint("BOTTOMRIGHT", 1, -1)

        Base.CreateBackdrop(bd, {
            edgeSize = 1,
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        })
        Base.CropIcon(bd:GetBackdropTexture("bg"))
        bd:SetBackdropColor(1, 1, 1, 0.75)
        bd:SetBackdropBorderColor(Color.button, 1)
        bd:SetFrameLevel(Button:GetFrameLevel())
        Button._auroraIconBorder = bd

        Base.CropIcon(Button:GetHighlightTexture())
    end
end

function private.AddOns.Blizzard_ScrappingMachineUI()
    local ScrappingMachineFrame = _G.ScrappingMachineFrame
    Skin.ButtonFrameTemplate(ScrappingMachineFrame)
    ScrappingMachineFrame:SetSize(333, 234)

    ScrappingMachineFrame.Background:SetAllPoints()
    ScrappingMachineFrame.ItemSlots:GetRegions():Hide()
    for button in ScrappingMachineFrame.ItemSlots.scrapButtons:EnumerateActive() do
        Skin.ScrappingMachineItemSlot(button)
    end

    Skin.MagicButtonTemplate(ScrappingMachineFrame.ScrapButton)

    --[[ Scale ]]--
end
