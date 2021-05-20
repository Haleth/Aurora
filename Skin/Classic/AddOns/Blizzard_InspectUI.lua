local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util


do --[[ AddOns\Blizzard_InspectUI.lua ]]
    do --[[ InspectPaperDollFrame.lua ]]
        function Hook.InspectPaperDollFrame_OnShow()
            local _, classToken = _G.UnitClass(_G.InspectFrame.unit)
            _G.InspectPaperDollFrame._classBG:SetAtlas("dressingroom-background-"..classToken)
        end
        function Hook.InspectPaperDollItemSlotButton_Update(button)
            local unit = _G.InspectFrame.unit
            local quality = _G.GetInventoryItemQuality(unit, button:GetID())
            Hook.SetItemButtonQuality(button, quality, _G.GetInventoryItemID(unit, button:GetID()))
        end
    end
    do --[[ InspectPVPFrame.lua ]]
        Hook.InspectPvpTalentSlotMixin = {}
        function Hook.InspectPvpTalentSlotMixin:Update()
            if not self._auroraBG then return end

            local selectedTalentID = _G.C_SpecializationInfo.GetInspectSelectedPvpTalent(_G.INSPECTED_UNIT, self.slotIndex)
            if selectedTalentID then
                local _, _, texture = _G.GetPvpTalentInfoByID(selectedTalentID)
                self.Texture:SetTexture(texture)
                self._auroraBG:SetColorTexture(Color.black:GetRGB())
                self.Texture:SetDesaturated(false)
            else
                self.Texture:Show()
                self._auroraBG:SetColorTexture(Color.gray:GetRGB())
                self.Texture:SetDesaturated(true)
            end
        end
    end
    do --[[ InspectHonorFrame.lua ]]
        function Hook.InspectHonorFrame_Update()
            local xOffset = _G.InspectHonorFrameCurrentPVPRank:GetWidth()/2
            _G.InspectHonorFrameCurrentPVPTitle:SetPoint("TOP", _G.InspectFrame:GetBackdropTexture("bg"), -xOffset, -30)
        end
    end
    do --[[ InspectTalentFrame.lua ]]
        function Hook.InspectTalentFrameSpec_OnShow(self)
            local spec
            if _G.INSPECTED_UNIT ~= nil then
                spec = _G.GetInspectSpecialization(_G.INSPECTED_UNIT)
            end
            if spec ~= nil and spec > 0 then
                local role1 = _G.GetSpecializationRoleByID(spec)
                if role1 ~= nil then
                    local _, _, _, icon = _G.GetSpecializationInfoByID(spec)
                    self.specIcon:SetTexture(icon)
                    Base.SetTexture(self.roleIcon, "icon"..role1)
                end
            end
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
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.InspectFrameTab1,
        _G.InspectFrameTab2,
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
    --         InspectHonorFrame         --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("InspectHonorFrame_Update", Hook.InspectHonorFrame_Update)

    -- /run InspectHonorFramePvPIcon:SetTexture("Interface\\PvPRankBadges\\PvPRank05"); InspectHonorFramePvPIcon:Show()
    local tl2, tr2, bl2, br2
    tl, tr, bl, br, tl2, tr2, bl2, br2 = _G.InspectHonorFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()
    tl2:Hide()
    tr2:Hide()
    bl2:Hide()
    br2:Hide()

    _G.InspectHonorFrameCurrentSessionTitle:SetPoint("TOPLEFT", 36, -90)
end
