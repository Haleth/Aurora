local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin, Util = Aurora.Base, Aurora.Skin, Aurora.Util
local _, C = _G.unpack(Aurora)

function private.AddOns.Blizzard_InspectUI()
    -- TODO: properly update this
    --F.CreateGradient(_G.InspectPaperDollFrame)
    --_G.InspectPaperDollFrame:DisableDrawLayer("BORDER")

    Skin.UIPanelCloseButton(_G.InspectFrameCloseButton)
    _G.InspectFrameCloseButton:SetPoint("TOPRIGHT", 4, 5)
    _G.InspectFramePortrait:Hide()

    -- Character
    _G.InspectModelFrame:DisableDrawLayer("OVERLAY")
    Skin.RotateOrbitCameraRightButtonTemplate(_G.InspectModelFrameRotateLeftButton)
    Skin.RotateOrbitCameraLeftButtonTemplate(_G.InspectModelFrameRotateRightButton)
    for i = 1, 4 do
        select(i, _G.InspectPaperDollFrame:GetRegions()):Hide()
    end
    Base.SetBackdrop(_G.InspectPaperDollFrame)

    -- Honor
    for i = 1, 8 do
        select(i, _G.InspectHonorFrame:GetRegions()):Hide()
    end
    Base.SetBackdrop(_G.InspectHonorFrame)

    select(9, _G.InspectMainHandSlot:GetRegions()):Hide()

    local slots = {
        "Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist",
        "Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1",
        "MainHand", "SecondaryHand", "Ranged",
    }

    for i = 1, #slots do
        local slot = _G["Inspect"..slots[i].."Slot"]
        local border = slot.IconBorder

        --_G["Inspect"..slots[i].."SlotIconTexture"]:Hide()

        slot:SetNormalTexture("")
        slot:SetPushedTexture("")

        border:SetPoint("TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", 1, -1)
        border:SetDrawLayer("BACKGROUND")

        slot.icon:SetTexCoord(.08, .92, .08, .92)
    end

    _G.hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
        button.IconBorder:SetTexture(C.media.backdrop)
        button.icon:SetShown(button.hasItem)
    end)

    -- Honor -- TODO

    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab2)
    Util.PositionRelative("TOPLEFT", _G.InspectFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.InspectFrameTab1,
        _G.InspectFrameTab2,
    })
end
