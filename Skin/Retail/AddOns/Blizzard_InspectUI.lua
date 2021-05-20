local _, private = ...
if not private.isRetail then return end

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
        Skin.InspectPaperDollItemSlotButtonRightTemplate = Skin.InspectPaperDollItemSlotButtonLeftTemplate
        Skin.InspectPaperDollItemSlotButtonBottomTemplate = Skin.InspectPaperDollItemSlotButtonLeftTemplate
    end
    do --[[ InspectPVPFrame.xml ]]
        function Skin.InspectPvpTalentSlotTemplate(Button)
            Skin.PvpTalentSlotTemplate(Button)
            Util.Mixin(Button, Hook.InspectPvpTalentSlotMixin)
        end
    end
    do --[[ InspectTalentFrame.xml ]]
        function Skin.InspectTalentButtonTemplate(Button)
            Button._auroraIconBG = Base.CropIcon(Button.icon, Button)
            Button.Slot:Hide()
            Button.border:SetTexture("")
        end
        function Skin.InspectTalentRowTemplate(Frame)
            Skin.InspectTalentButtonTemplate(Frame.talent1)
            Skin.InspectTalentButtonTemplate(Frame.talent2)
            Skin.InspectTalentButtonTemplate(Frame.talent3)
        end
    end
end

function private.AddOns.Blizzard_InspectUI()
    local InspectFrame = _G.InspectFrame
    ----====####$$$$%%%%$$$$####====----
    --       Blizzard_InspectUI       --
    ----====####$$$$%%%%$$$$####====----
    Skin.ButtonFrameTemplate(InspectFrame)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab2)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab3)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab4)
    Util.PositionRelative("TOPLEFT", InspectFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.InspectFrameTab1,
        _G.InspectFrameTab2,
        _G.InspectFrameTab3,
        _G.InspectFrameTab4,
    })

    ----====####$$$$%%%%%$$$$####====----
    --      InspectPaperDollFrame      --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("InspectPaperDollFrame_OnShow", Hook.InspectPaperDollFrame_OnShow)

    local InspectPaperDollFrame = _G.InspectPaperDollFrame
    InspectPaperDollFrame:HookScript("OnShow", Hook.InspectPaperDollFrame_OnShow)

    Skin.UIPanelButtonTemplate(InspectPaperDollFrame.ViewButton)

    local bg = InspectFrame.NineSlice:GetBackdropTexture("bg")
    local classBG = InspectPaperDollFrame:CreateTexture(nil, "BORDER")
    classBG:SetAtlas("dressingroom-background-"..private.charClass.token)
    classBG:SetPoint("TOPLEFT", bg)
    classBG:SetPoint("BOTTOM", bg)
    classBG:SetPoint("RIGHT", InspectFrame.Inset, 4, 0)
    classBG:SetAlpha(0.5)
    InspectPaperDollFrame._classBG = classBG

    _G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
    _G.InspectModelFrame.BackgroundOverlay:Hide()
    _G.InspectModelFrame:DisableDrawLayer("OVERLAY")

    local EquipmentSlots = {
        "InspectHeadSlot", "InspectNeckSlot", "InspectShoulderSlot", "InspectBackSlot", "InspectChestSlot", "InspectShirtSlot", "InspectTabardSlot", "InspectWristSlot",
        "InspectHandsSlot", "InspectWaistSlot", "InspectLegsSlot", "InspectFeetSlot", "InspectFinger0Slot", "InspectFinger1Slot", "InspectTrinket0Slot", "InspectTrinket1Slot"
    }
    local WeaponSlots = {
        "InspectMainHandSlot", "InspectSecondaryHandSlot"
    }

    local slotsPerSide, prevSlot = 8
    for i = 1, #EquipmentSlots do
        local button = _G[EquipmentSlots[i]]
        button:ClearAllPoints()
        local isLeftSide = button.IsLeftSide or i <= slotsPerSide

        if i % slotsPerSide == 1 then
            if isLeftSide then
                button:SetPoint("TOPLEFT", InspectFrame.Inset, 4, 22)
            else
                button:SetPoint("TOPRIGHT", InspectFrame.Inset, -4, 22)
            end
        else
            button:SetPoint("TOPLEFT", prevSlot, "BOTTOMLEFT", 0, -6)
        end

        if isLeftSide then
            Skin.InspectPaperDollItemSlotButtonLeftTemplate(button)
        elseif isLeftSide == false then
            Skin.InspectPaperDollItemSlotButtonRightTemplate(button)
        end

        prevSlot = button
    end

    for i = 1, #WeaponSlots do
        local button = _G[WeaponSlots[i]]

        if i == 1 then
            -- main hand
            button:SetPoint("BOTTOMLEFT", 130, 8)
        end

        _G.select(button:GetNumRegions(), button:GetRegions()):Hide()
        Skin.InspectPaperDollItemSlotButtonBottomTemplate(button)
    end

    ----====####$$$$%%%%%$$$$####====----
    --         InspectPVPFrame         --
    ----====####$$$$%%%%%$$$$####====----
    local InspectPVPFrame = _G.InspectPVPFrame
    InspectPVPFrame.BG:SetTexCoord(0.00390625, 0.3115234375, 0.34375, 0.87890625)
    InspectPVPFrame.BG:SetDesaturated(true)
    InspectPVPFrame.BG:SetBlendMode("ADD")
    InspectPVPFrame.BG:SetAllPoints(bg)

    InspectPVPFrame.RatedBG:SetPoint("TOPLEFT", InspectPVPFrame, 8, -124)
    InspectPVPFrame.Slots[1]:SetPoint("TOPRIGHT", InspectPVPFrame, -46, -124)
    for i = 1, #InspectPVPFrame.Slots do
        Skin.InspectPvpTalentSlotTemplate(InspectPVPFrame.Slots[i])
    end

    ----====####$$$$%%%%$$$$####====----
    --       InspectTalentFrame       --
    ----====####$$$$%%%%$$$$####====----
    _G.hooksecurefunc("InspectTalentFrameSpec_OnShow", Hook.InspectTalentFrameSpec_OnShow)

    local InspectTalentFrame = _G.InspectTalentFrame
    local talentBG, talentTile = InspectTalentFrame:GetRegions()
    talentBG:Hide()
    talentTile:Hide()

    local InspectSpec = InspectTalentFrame.InspectSpec
    InspectSpec:HookScript("OnShow", Hook.InspectTalentFrameSpec_OnShow)
    InspectSpec.ring:Hide()
    Base.CropIcon(InspectSpec.specIcon, InspectSpec)

    local InspectTalents = InspectTalentFrame.InspectTalents
    Skin.InspectTalentRowTemplate(InspectTalents.tier1)
    Skin.InspectTalentRowTemplate(InspectTalents.tier2)
    Skin.InspectTalentRowTemplate(InspectTalents.tier3)
    Skin.InspectTalentRowTemplate(InspectTalents.tier4)
    Skin.InspectTalentRowTemplate(InspectTalents.tier5)
    Skin.InspectTalentRowTemplate(InspectTalents.tier6)
    Skin.InspectTalentRowTemplate(InspectTalents.tier7)

    ----====####$$$$%%%%%$$$$####====----
    --        InspectGuildFrame        --
    ----====####$$$$%%%%%$$$$####====----
    --local InspectGuildFrame = _G.InspectGuildFrame
    _G.InspectGuildFrameBG:Hide()
end
