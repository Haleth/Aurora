local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\PetStable.lua ]]
--end

do --[[ FrameXML\PetStable.xml ]]
    function Skin.PetStableSlotTemplate(Button)
        Skin.AltItemButton(Button)
        _G[Button:GetName().."Background"]:Hide()
    end
end

function private.FrameXML.PetStable()
    local PetStableFrame = _G.PetStableFrame
    _G.PetStableFramePortrait:SetAlpha(0)
    for i = 2, 5 do
        select(i, _G.PetStableFrame:GetRegions()):Hide()
    end
    Base.SetBackdrop(_G.PetStableFrame)
    Skin.UIPanelCloseButton(_G.PetStableFrameCloseButton)
    _G.PetStableFrameCloseButton:SetPoint("TOPRIGHT", 4, 4)

    _G.PetStableModel:SetPoint("TOPLEFT", PetStableFrame, 0, -51)
    _G.PetStableModel:SetPoint("BOTTOMRIGHT", PetStableFrame, 0, 160)
    _G.PetStableModelRotateLeftButton:Hide()
    _G.PetStableModelRotateRightButton:Hide()

    Skin.PetStableSlotTemplate(_G.PetStableCurrentPet)
    _G.PetStableCurrentPet:SetPoint("BOTTOMLEFT", 95, 50)

    for i = 1, _G.NUM_PET_STABLE_SLOTS do
        Skin.PetStableSlotTemplate(_G["PetStableStabledPet"..i])
    end

    Skin.UIPanelButtonTemplate(_G.PetStablePurchaseButton)
    _G.PetStablePurchaseButton:SetPoint("BOTTOMRIGHT", -14, 60)

    --Skin.SmallMoneyFrameTemplate(_G.PetStableMoneyFrame)
    _G.PetStableMoneyFrame:SetPoint("BOTTOMRIGHT", -4, 4)
end
