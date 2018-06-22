local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--[[ do FrameXML\MainMenuBarBagButtons.lua
end ]]

do --[[ FrameXML\MainMenuBarBagButtons.xml ]]
    function Skin.BagSlotButtonTemplate(CheckButton)
        Skin.ItemButtonTemplate(CheckButton)
        Base.CropIcon(CheckButton:GetCheckedTexture())

        --[[ Scale ]]--
        CheckButton:SetSize(30, 30)
    end
end

function private.FrameXML.MainMenuBarBagButtons()
    if private.disabled.mainmenubar then return end

    Skin.ItemButtonTemplate(_G.MainMenuBarBackpackButton)
    Base.CropIcon(_G.MainMenuBarBackpackButton:GetCheckedTexture())

    Skin.BagSlotButtonTemplate(_G.CharacterBag0Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag1Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag2Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag3Slot)
    if private.isPatch then
        _G.CharacterBag0Slot:SetPoint("RIGHT", _G.MainMenuBarBackpackButton, "LEFT", -4, -5)
    else
        _G.CharacterBag0Slot:SetPoint("RIGHT", _G.MainMenuBarBackpackButton, "LEFT", -3, 0)
    end
    _G.CharacterBag1Slot:SetPoint("RIGHT", _G.CharacterBag0Slot, "LEFT", -4, 0)
    _G.CharacterBag2Slot:SetPoint("RIGHT", _G.CharacterBag1Slot, "LEFT", -4, 0)
    _G.CharacterBag3Slot:SetPoint("RIGHT", _G.CharacterBag2Slot, "LEFT", -4, 0)

    if private.isPatch then
        Skin.GlowBoxFrame(_G.AzeriteInBagsHelpBox)
    end

    --[[ Scale ]]--
    if private.isPatch then
        _G.MainMenuBarBackpackButton:SetSize(40, 40)
        _G.MainMenuBarBackpackButton:SetPoint("TOPRIGHT", -4, -4)
    else
        _G.MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -4, 6)
    end
end
