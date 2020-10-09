local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\PetStable.lua ]]
    function Hook.PetStable_Update()
        for i = 1, _G.NUM_PET_STABLE_SLOTS do
            local button = _G["PetStableStabledPet"..i]
            if i <= _G.GetNumStableSlots() then
                button:SetBackdropColor(Color.white, 0.75)
                button:SetBackdropBorderColor(Color.frame, 1)
            else
                button:SetBackdropColor(Color.red, 0.75)
                button:SetBackdropBorderColor(Color.red, 1)
            end
        end
    end
end

do --[[ FrameXML\PetStable.xml ]]
    function Skin.PetStableSlotTemplate(CheckButton)
        Base.CreateBackdrop(CheckButton, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        Base.CropIcon(CheckButton:GetBackdropTexture("bg"))
        Base.SetBackdrop(CheckButton, Color.black, Color.frame.a)
        CheckButton._auroraIconBorder = CheckButton

        CheckButton:SetBackdropColor(1, 1, 1, 0.75)
        CheckButton:SetBackdropBorderColor(Color.frame, 1)

        local name = CheckButton:GetName()
        Base.CropIcon(_G[name.."IconTexture"])
        _G[name.."Background"]:Hide()

        CheckButton:SetNormalTexture("")
        Base.CropIcon(CheckButton:GetPushedTexture())
        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
end

function private.FrameXML.PetStable()
    _G.hooksecurefunc("PetStable_Update", Hook.PetStable_Update)

    local PetStableFrame = _G.PetStableFrame
    Skin.FrameTypeFrame(PetStableFrame)
    PetStableFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local bg = PetStableFrame:GetBackdropTexture("bg")
    local portrait, tl, tr, bl, br = PetStableFrame:GetRegions()
    portrait:Hide()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    _G.PetStableTitleLabel:ClearAllPoints()
    _G.PetStableTitleLabel:SetPoint("TOPLEFT", bg)
    _G.PetStableTitleLabel:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    --_G.PetStableModel:SetPoint("TOPLEFT", PetStableFrame.Inset)
    --_G.PetStableModel:SetPoint("BOTTOMRIGHT", PetStableFrame.Inset)
    _G.PetStableModelRotateLeftButton:Hide()
    _G.PetStableModelRotateRightButton:Hide()

    --_G.PetStablePetInfo:SetPoint("TOPLEFT", PetStableFrame.Inset)
    --_G.PetStablePetInfo:SetPoint("BOTTOMRIGHT", PetStableFrame.Inset, "TOPRIGHT", 0, -52)

    Skin.PetStableSlotTemplate(_G.PetStableCurrentPet)
    Skin.PetStableSlotTemplate(_G.PetStableStabledPet1)
    Skin.PetStableSlotTemplate(_G.PetStableStabledPet2)

    Skin.UIPanelButtonTemplate(_G.PetStablePurchaseButton)

    local moneyBG = _G.CreateFrame("Frame", nil, PetStableFrame)
    Base.SetBackdrop(moneyBG, Color.frame)
    moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
    moneyBG:SetPoint("BOTTOMLEFT", bg, 5, 5)
    moneyBG:SetPoint("TOPRIGHT", bg, "BOTTOMRIGHT", -5, 27)
    Skin.SmallMoneyFrameTemplate(_G.PetStableMoneyFrame)
    _G.PetStableMoneyFrame:SetPoint("BOTTOMRIGHT", moneyBG, 7, 5)

    Skin.SmallMoneyFrameTemplate(_G.PetStableCostMoneyFrame)
    Skin.UIPanelCloseButton(_G.PetStableFrameCloseButton)
end
