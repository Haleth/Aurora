local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\PetStable.lua ]]
    function Hook.PetStable_SetSelectedPetInfo(icon, name, level, family, talent)
        if family then
            _G.PetStableTypeText:SetText(family)
        else
            _G.PetStableTypeText:SetText("")
        end
    end
end

do --[[ FrameXML\PetStable.xml ]]
    function Skin.PetStableSlotTemplate(Button)
        local name = Button:GetName()

        Base.CropIcon(_G[name.."IconTexture"])
        Button.Background:SetColorTexture(0, 0, 0, 1)
        Button.Background:SetPoint("TOPLEFT", Button, -1, 1)
        Button.Background:SetPoint("BOTTOMRIGHT", Button, 1, -1)
        Base.CropIcon(Button.Checked)
        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
    function Skin.PetStableActiveSlotTemplate(Button)
        Skin.PetStableSlotTemplate(Button)

        Button.Border:Hide()
        Button.PetName:SetPoint("BOTTOMLEFT", Button, "TOPLEFT", -16, 5)
        Button.PetName:SetPoint("BOTTOMRIGHT", Button, "TOPRIGHT", 16, 5)
    end
end

function private.FrameXML.PetStable()
    _G.hooksecurefunc("PetStable_SetSelectedPetInfo", Hook.PetStable_SetSelectedPetInfo)

    local PetStableFrame = _G.PetStableFrame
    Skin.ButtonFrameTemplate(PetStableFrame)
    PetStableFrame.Inset:SetPoint("TOPLEFT", PetStableFrame.LeftInset, "TOPRIGHT", 5)
    PetStableFrame.Inset:SetPoint("BOTTOMRIGHT", -5, 126)

    _G.PetStableFrameModelBg:SetAtlas("GarrFollower-Shadow")
    _G.PetStableFrameModelBg:SetPoint("TOPLEFT", PetStableFrame.Inset, 0, -160)
    _G.PetStableFrameModelBg:SetPoint("BOTTOMRIGHT", PetStableFrame.Inset, 0, 0)
    _G.PetStableFrameModelBg:SetTexCoord(0.2, 0.8, 0, 0.8)

    Skin.InsetFrameTemplate(PetStableFrame.LeftInset)
    PetStableFrame.LeftInset:SetPoint("TOPLEFT", 0, -private.FRAME_TITLE_HEIGHT)
    PetStableFrame.LeftInset:SetPoint("BOTTOMRIGHT", PetStableFrame, "BOTTOMLEFT", 91, 0)
    _G.PetStableActiveBg:Hide()

    Skin.InsetFrameTemplate(PetStableFrame.BottomInset)
    _G.PetStableFrameStableBg:Hide()

    _G.PetStableModel:SetPoint("TOPLEFT", PetStableFrame.Inset)
    _G.PetStableModel:SetPoint("BOTTOMRIGHT", PetStableFrame.Inset)
    _G.PetStableModelRotateLeftButton:Hide()
    _G.PetStableModelRotateRightButton:Hide()
    _G.PetStableModelShadow:Hide()

    _G.PetStablePetInfo:SetPoint("TOPLEFT", PetStableFrame.Inset)
    _G.PetStablePetInfo:SetPoint("BOTTOMRIGHT", PetStableFrame.Inset, "TOPRIGHT", 0, -52)

    Base.CropIcon(_G.PetStableSelectedPetIcon)

    _G.PetStableNameText:SetFontObject("GameFontNormalHuge2")
    _G.PetStableNameText:SetPoint("TOPLEFT", _G.PetStableSelectedPetIcon, "TOPRIGHT", 2, 0)
    _G.PetStableLevelText:SetPoint("BOTTOMLEFT", _G.PetStableSelectedPetIcon, "BOTTOMRIGHT", 2, 0)
    _G.PetStableTypeText:SetPoint("BOTTOMRIGHT", -6, 6)

    _G.PetStableDiet:SetSize(20, 20)
    _G.PetStableDiet:SetPoint("TOPRIGHT", -6, -6)

    _G.PetStableDietTexture:SetTexture([[Interface\Icons\Ability_Hunter_BeastTraining]])
    _G.PetStableDietTexture:SetAllPoints()
    Base.CropIcon(_G.PetStableDietTexture)

    for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
        local slot = _G["PetStableActivePet"..i]
        Skin.PetStableActiveSlotTemplate(slot)
        if i > 1 then
            slot:SetPoint("TOPLEFT", _G["PetStableActivePet"..(i - 1)], "BOTTOMLEFT", 0, -35)
        end
    end

    for i = 1, _G.NUM_PET_STABLE_SLOTS do
        Skin.PetStableSlotTemplate(_G["PetStableStabledPet"..i])
    end

    Skin.UIPanelSquareButton(_G.PetStableNextPageButton, "RIGHT")
    Skin.UIPanelSquareButton(_G.PetStablePrevPageButton, "LEFT")
end
