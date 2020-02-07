local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util
local F, C = _G.unpack(Aurora)


do --[[ AddOns\Blizzard_InspectUI.lua ]]
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
    do --[[ InspectPaperDollFrame.lua ]]
        function Hook.InspectPaperDollItemSlotButton_Update(button)
            local unit = _G.InspectFrame.unit
            local quality = _G.GetInventoryItemQuality(unit, button:GetID())
            Hook.SetItemButtonQuality(button, quality, _G.GetInventoryItemID(unit, button:GetID()))
        end
    end
end

do --[[ AddOns\Blizzard_InspectUI.xml ]]
    do --[[ InspectPVPFrame.xml ]]
        function Skin.InspectPvpTalentSlotTemplate(Button)
            Skin.PvpTalentSlotTemplate(Button)
            Util.Mixin(Button, Hook.InspectPvpTalentSlotMixin)
        end
    end
    do --[[ InspectPaperDollFrame.xml ]]
        function Skin.InspectPaperDollItemSlotButtonTemplate(ItemButton)
            Skin.FrameTypeItemButton(ItemButton)
            ItemButton:SetNormalTexture("")
        end
    end
end

function private.AddOns.Blizzard_InspectUI()
    local InspectFrame = _G.InspectFrame
    if private.isRetail then
        -- TODO: properly update this
        _G.InspectModelFrame:DisableDrawLayer("OVERLAY")

        _G.InspectTalentFrame:GetRegions():Hide()
        select(2, _G.InspectTalentFrame:GetRegions()):Hide()
        _G.InspectGuildFrameBG:Hide()
        for i = 1, 5 do
            select(i, _G.InspectModelFrame:GetRegions()):Hide()
        end
        F.Reskin(_G.InspectPaperDollFrame.ViewButton)

        -- Character

        select(10, _G.InspectMainHandSlot:GetRegions()):Hide()

        local slots = {
            "Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
            "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
            "SecondaryHand", "Tabard",
        }

        for i = 1, #slots do
            local slot = _G["Inspect"..slots[i].."Slot"]
            local border = slot.IconBorder

            _G["Inspect"..slots[i].."SlotFrame"]:Hide()

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
    else
        Base.SetBackdrop(InspectFrame)
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
    end

    if private.isRetail then
        ----====####$$$$%%%%%$$$$####====----
        --         InspectPVPFrame         --
        ----====####$$$$%%%%%$$$$####====----
        _G.InspectPVPFrame.BG:Hide()
        for i = 1, #_G.InspectPVPFrame.Slots do
            Skin.InspectPvpTalentSlotTemplate(_G.InspectPVPFrame.Slots[i])
        end

        -- Talents

        local inspectSpec = _G.InspectTalentFrame.InspectSpec

        inspectSpec.ring:Hide()

        for i = 1, 7 do
            local row = _G.InspectTalentFrame.InspectTalents["tier"..i]
            for j = 1, 3 do
                local bu = row["talent"..j]

                bu.Slot:Hide()
                bu.border:SetTexture("")

                bu.icon:SetDrawLayer("ARTWORK")
                bu._auroraIconBG = Base.CropIcon(bu.icon, bu)
            end
        end

        inspectSpec.specIcon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(inspectSpec.specIcon)

        local function updateIcon(self)
            local spec = nil
            if _G.INSPECTED_UNIT ~= nil then
                spec = _G.GetInspectSpecialization(_G.INSPECTED_UNIT)
            end
            if spec ~= nil and spec > 0 then
                local role1 = _G.GetSpecializationRoleByID(spec)
                if role1 ~= nil then
                    local _, _, _, icon = _G.GetSpecializationInfoByID(spec)
                    self.specIcon:SetTexture(icon)
                end
            end
        end

        inspectSpec:HookScript("OnShow", updateIcon)
        _G.InspectTalentFrame:HookScript("OnEvent", function(self, event, unit)
            if not _G.InspectFrame:IsShown() then return end
            if event == "INSPECT_READY" and _G.InspectFrame.unit and _G.UnitGUID(_G.InspectFrame.unit) == unit then
                updateIcon(self.InspectSpec)
            end
        end)

        local roleIcon = inspectSpec.roleIcon

        roleIcon:SetTexture(C.media.roleIcons)

        do
            local left = inspectSpec:CreateTexture(nil, "OVERLAY")
            left:SetWidth(1)
            left:SetTexture(C.media.backdrop)
            left:SetVertexColor(0, 0, 0)
            left:SetPoint("TOPLEFT", roleIcon, 2, -2)
            left:SetPoint("BOTTOMLEFT", roleIcon, 2, 2)

            local right = inspectSpec:CreateTexture(nil, "OVERLAY")
            right:SetWidth(1)
            right:SetTexture(C.media.backdrop)
            right:SetVertexColor(0, 0, 0)
            right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
            right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 2)

            local top = inspectSpec:CreateTexture(nil, "OVERLAY")
            top:SetHeight(1)
            top:SetTexture(C.media.backdrop)
            top:SetVertexColor(0, 0, 0)
            top:SetPoint("TOPLEFT", roleIcon, 2, -2)
            top:SetPoint("TOPRIGHT", roleIcon, -2, -2)

            local bottom = inspectSpec:CreateTexture(nil, "OVERLAY")
            bottom:SetHeight(1)
            bottom:SetTexture(C.media.backdrop)
            bottom:SetVertexColor(0, 0, 0)
            bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 2)
            bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 2)
        end

        for i = 1, 4 do
            local tab = _G["InspectFrameTab"..i]
            F.ReskinTab(tab)
            if i ~= 1 then
                tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
            end
        end

        F.ReskinPortraitFrame(_G.InspectFrame, true)
    else
        ----====####$$$$%%%%%$$$$####====----
        --         InspectHonorFrame         --
        ----====####$$$$%%%%%$$$$####====----
        _G.hooksecurefunc("InspectHonorFrame_Update", Hook.InspectHonorFrame_Update)

        -- /run InspectHonorFramePvPIcon:SetTexture("Interface\\PvPRankBadges\\PvPRank05"); InspectHonorFramePvPIcon:Show()
        local tl, tr, bl, br, tl2, tr2, bl2, br2 = _G.InspectHonorFrame:GetRegions()
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
end
