local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do AddOns\Blizzard_CompactUnitFrameProfiles.lua
end ]]

do --[[ AddOns\Blizzard_CompactUnitFrameProfiles.xml ]]
    function Skin.CompactUnitFrameProfilesDropdownTemplate(Frame)
        Skin.UIDropDownMenuTemplate(Frame)
    end
    function Skin.CompactUnitFrameProfilesCheckButtonTemplate(CheckButton)
        CheckButton:SetNormalTexture("")
        CheckButton:SetPushedTexture("")
        CheckButton:SetHighlightTexture("")

        local bd = _G.CreateFrame("Frame", nil, CheckButton)
        bd:SetPoint("TOPLEFT", 6, -6)
        bd:SetPoint("BOTTOMRIGHT", -6, 6)
        bd:SetFrameLevel(CheckButton:GetFrameLevel())
        Base.SetBackdrop(bd, Color.frame)
        bd:SetBackdropBorderColor(Color.button)

        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", -1, 1)
        check:SetPoint("BOTTOMRIGHT", 1, -1)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        local disabled = CheckButton:GetDisabledCheckedTexture()
        disabled:SetAllPoints(check)

        CheckButton._auroraBDFrame = bd
        Base.SetHighlight(CheckButton, "backdrop")

        --[[ Scale ]]--
        CheckButton:SetSize(CheckButton:GetSize())
    end
    function Skin.CompactUnitFrameProfilesSliderTemplate(Slider)
        Skin.HorizontalSliderTemplate(Slider)
    end
    function Skin.CompactUnitFrameProfileDialogWithCoverTemplate(Frame)
        Base.SetBackdrop(Frame)
    end
end

function private.AddOns.Blizzard_CUFProfiles()
    ----====####$$$$%%%%%%%$$$$####====----
    -- Blizzard_CompactUnitFrameProfiles --
    ----====####$$$$%%%%%%%$$$$####====----
    local profiles = _G.CompactUnitFrameProfiles
    Skin.UIDropDownMenuTemplate(_G.CompactUnitFrameProfilesProfileSelector)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesSaveButton)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesDeleteButton)
    Skin.InterfaceOptionsCheckButtonTemplate(_G.CompactUnitFrameProfilesRaidStylePartyFrames)


    Skin.CompactUnitFrameProfileDialogWithCoverTemplate(profiles.newProfileDialog)
    local bd = _G.CreateFrame("Frame", nil, _G.CompactUnitFrameProfilesNewProfileDialogEditBox)
    bd:SetPoint("TOPLEFT", -5, 0)
    bd:SetPoint("BOTTOMRIGHT", 5, 0)
    bd:SetFrameLevel(_G.CompactUnitFrameProfilesNewProfileDialogEditBox:GetFrameLevel())
    Base.SetBackdrop(bd, Color.button, 0.2)
    _G.CompactUnitFrameProfilesNewProfileDialogEditBoxLeft:Hide()
    _G.CompactUnitFrameProfilesNewProfileDialogEditBoxRight:Hide()
    _G.CompactUnitFrameProfilesNewProfileDialogEditBoxMid:Hide()
    Skin.UIDropDownMenuTemplate(_G.CompactUnitFrameProfilesNewProfileDialogBaseProfileSelector)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesNewProfileDialogCreateButton)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesNewProfileDialogCancelButton)

    Skin.CompactUnitFrameProfileDialogWithCoverTemplate(profiles.deleteProfileDialog)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesDeleteProfileDialogDeleteButton)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesDeleteProfileDialogCancelButton)

    Skin.CompactUnitFrameProfileDialogWithCoverTemplate(profiles.unsavedProfileDialog)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesConfirmUnsavedProfileDialogDontSaveButton)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesConfirmUnsavedProfileDialogSaveButton)
    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesConfirmUnsavedProfileDialogCancelButton)


    local optionsFrame = profiles.optionsFrame
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameHorizontalGroups)
    Skin.CompactUnitFrameProfilesDropdownTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs)
    Skin.CompactUnitFrameProfilesDropdownTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown)
    Skin.CompactUnitFrameProfilesSliderTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider)
    Skin.CompactUnitFrameProfilesSliderTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider)

    Skin.CompactUnitFrameProfilesCheckButtonTemplate(optionsFrame.autoActivate2Players)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(optionsFrame.autoActivate3Players)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(optionsFrame.autoActivate5Players)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players)

    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec3)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec4)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP)
    Skin.CompactUnitFrameProfilesCheckButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE)

    Skin.UIPanelButtonTemplate(_G.CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
