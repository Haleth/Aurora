local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_ScrappingMachineUI.lua ]]
    Hook.ScrappingMachineItemSlotMixin = {}
    function Hook.ScrappingMachineItemSlotMixin:ClearSlot()
        if self._auroraIconOverlay then
            self._auroraIconBorder:SetBackdropBorderColor(Color.button, 1)
            self._auroraIconOverlay:Hide()
        end
    end
end

do --[[ AddOns\Blizzard_ScrappingMachineUI.xml ]]
    function Skin.ScrappingMachineItemSlot(Button)
        Util.Mixin(Button, Hook.ScrappingMachineItemSlotMixin)
        Base.CreateBackdrop(Button, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        Base.CropIcon(Button:GetBackdropTexture("bg"))
        Button:SetBackdropColor(1, 1, 1, 0.75)
        Button:SetBackdropBorderColor(Color.button, 1)
        Button._auroraIconBorder = Button

        Base.CropIcon(Button.Icon)
        Base.CropIcon(Button:GetHighlightTexture())
    end
end

function private.AddOns.Blizzard_ScrappingMachineUI()
    local ScrappingMachineFrame = _G.ScrappingMachineFrame
    Skin.ButtonFrameTemplate(ScrappingMachineFrame)
    ScrappingMachineFrame.NineSlice:SetBackdropOption("offsets", {
        left = 4,
        right = 4,
        top = 20,
        bottom = 0,
    })

    ScrappingMachineFrame.ItemSlots:GetRegions():Hide()
    ScrappingMachineFrame.ItemSlots:ClearAllPoints()
    ScrappingMachineFrame.ItemSlots:SetPoint("TOPLEFT", 93, -73)
    for button in ScrappingMachineFrame.ItemSlots.scrapButtons:EnumerateActive() do
        Skin.ScrappingMachineItemSlot(button)
    end

    Skin.MagicButtonTemplate(ScrappingMachineFrame.ScrapButton)
end
