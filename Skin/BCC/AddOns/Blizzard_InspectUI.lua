local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util


do --[[ AddOns\Blizzard_InspectUI.lua ]]
    do --[[ InspectPaperDollFrame.lua ]]
        function Hook.InspectPaperDollItemSlotButton_Update(button)
            local unit = _G.InspectFrame.unit
            local quality = _G.GetInventoryItemQuality(unit, button:GetID())
            Hook.SetItemButtonQuality(button, quality, _G.GetInventoryItemID(unit, button:GetID()))
        end
    end
end

do --[[ AddOns\Blizzard_InspectUI.xml ]]
    do --[[ InspectPaperDollFrame.xml ]]
        function Skin.InspectPaperDollItemSlotButtonTemplate(ItemButton)
            Skin.FrameTypeItemButton(ItemButton)
            ItemButton:SetNormalTexture("")
        end
        function Skin.InspectPaperDollItemSlotButtonLeftTemplate(ItemButton)
            Skin.InspectPaperDollItemSlotButtonTemplate(ItemButton)
            _G[ItemButton:GetName().."Frame"]:Hide()
        end
    end
end

function private.AddOns.Blizzard_InspectUI()
    local InspectFrame = _G.InspectFrame
    Skin.FrameTypeFrame(InspectFrame)
    InspectFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })
    local bg = InspectFrame:GetBackdropTexture("bg")

    _G.InspectFramePortrait:Hide()
    _G.InspectNameFrame:ClearAllPoints()
    _G.InspectNameFrame:SetPoint("TOPLEFT", bg)
    _G.InspectNameFrame:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelCloseButton(_G.InspectFrameCloseButton)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab2)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab3)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.InspectFrameTab1,
        _G.InspectFrameTab2,
        _G.InspectFrameTab3,
    })

    ----====####$$$$%%%%%$$$$####====----
    --      InspectPaperDollFrame      --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("InspectPaperDollItemSlotButton_Update", Hook.InspectPaperDollItemSlotButton_Update)

    local tl, tr, bl, br = _G.InspectPaperDollFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    Skin.NavButtonNext(_G.InspectModelFrameRotateRightButton)
    Skin.NavButtonPrevious(_G.InspectModelFrameRotateLeftButton)

    local slots = {
        "InspectHeadSlot", "InspectNeckSlot", "InspectShoulderSlot", "InspectBackSlot", "InspectChestSlot", "InspectShirtSlot", "InspectTabardSlot", "InspectWristSlot",
        "InspectHandsSlot", "InspectWaistSlot", "InspectLegsSlot", "InspectFeetSlot", "InspectFinger0Slot", "InspectFinger1Slot", "InspectTrinket0Slot", "InspectTrinket1Slot",
        "InspectMainHandSlot", "InspectSecondaryHandSlot", "InspectRangedSlot"
    }

    for i = 1, #slots do
        Skin.InspectPaperDollItemSlotButtonTemplate(_G[slots[i]])
    end

    ----====####$$$$%%%%%$$$$####====----
    --         InspectHonorFrame       --
    ----====####$$$$%%%%%$$$$####====----
    
    tl, tr, bl, br, bg = _G.InspectPVPFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()
    bg:Hide()

    ----====####$$$$%%%%%$$$$####====----
    --         InspectTalentFrame      --
    ----====####$$$$%%%%%$$$$####====----
    local TalentFrame = _G.InspectTalentFrame
    Skin.FrameTypeFrame(TalentFrame)
    TalentFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local bg = TalentFrame:GetBackdropTexture("bg")
    local tl, tr, bl, br = TalentFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()
	
	local textures = {
        TopLeft = {
            point = "TOPLEFT",
            x = 286, -- textureSize * (frameSize / fullBGSize)
            y = 327,
        },
        TopRight = {
            x = 72,
            y = 327,
        },
        BottomLeft = {
            x = 286,
            y = 163,
        },
        BottomRight = {
            x = 72,
            y = 163,
        },
    }
    for name, info in next, textures do
        local tex = _G["InspectTalentFrameBackground"..name]
        if info.point then
            tex:SetPoint(info.point, bg)
        end
        tex:SetSize(info.x, info.y)
        tex:SetDrawLayer("BACKGROUND", 3)
        tex:SetAlpha(0.7)
    end

    Skin.UIPanelCloseButton(_G.InspectTalentFrameCloseButton)
    Skin.UIPanelButtonTemplate(_G.InspectTalentFrameCancelButton)

    Skin.TalentTabTemplate(_G.InspectTalentFrameTab1)
    Skin.TalentTabTemplate(_G.InspectTalentFrameTab2)
    Skin.TalentTabTemplate(_G.InspectTalentFrameTab3)

    _G.InspectTalentFrameScrollFrame:ClearAllPoints()
    _G.InspectTalentFrameScrollFrame:SetPoint("TOPLEFT", bg, 5, -57)
    _G.InspectTalentFrameScrollFrame:SetPoint("BOTTOMRIGHT", bg, -25, 30)
    Skin.UIPanelScrollFrameTemplate(_G.InspectTalentFrameScrollFrame)
    local top, bottom = _G.InspectTalentFrameScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    for i = 1, _G.MAX_NUM_TALENTS do
        Skin.TalentButtonTemplate(_G["InspectTalentFrameTalent"..i])
    end
end
