local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_GarrisonTemplates.lua ]]
    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_GarrisonSharedTemplates --
    ----====####$$$$%%%%%%$$$$####====----
    function Hook.GarrisonFollowerList_UpdateData(self)
        local followers = self.followers
        local followersList = self.followersList
        local numFollowers = #followersList
        local scrollFrame = self.listScroll
        local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
        local buttons = scrollFrame.buttons
        local numButtons = #buttons

        for i = 1, numButtons do
            local button = buttons[i]
            local index = offset + i -- adjust index
            if index <= numFollowers and followersList[index] ~= 0 then
                local follower = followers[followersList[index]]

                if follower.isCollected then
                    -- adjust text position if we have additional text to show below name
                    local nameOffsetY = 0
                    if follower.status then
                        nameOffsetY = nameOffsetY + 6
                    end
                    -- show iLevel for max level followers
                    if _G.ShouldShowILevelInFollowerList(follower) then
                        nameOffsetY = nameOffsetY + 6
                        button.Follower.ILevel:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -2)
                        button.Follower.Status:SetPoint("TOPLEFT", button.Follower.ILevel, "BOTTOMLEFT", 0, 0)
                    else
                        button.Follower.Status:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -2)
                    end

                    if button.Follower.DurabilityFrame:IsShown() then
                        nameOffsetY = nameOffsetY + 8

                        if follower.status then
                            button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.Status, "BOTTOMLEFT", 0, -4)
                        elseif _G.ShouldShowILevelInFollowerList(follower) then
                            button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.ILevel, "BOTTOMLEFT", 0, -6)
                        else
                            button.Follower.DurabilityFrame:SetPoint("TOPLEFT", button.Follower.Name, "BOTTOMLEFT", 0, -6)
                        end
                    end
                    button.Follower.Name:SetPoint("LEFT", button.Follower.PortraitFrame, "RIGHT", 10, nameOffsetY)

                    if follower.xp > 0 or follower.levelXP > 0 then
                        Scale.RawSetWidth(button.Follower.XPBar, (follower.xp/follower.levelXP) * Scale.Value(214))
                    end
                end

                Scale.RawSetHeight(button, button.Follower:GetHeight())
            end
        end
    end

    function Hook.GarrisonFollowerButton_SetCounterButton(button, followerID, index, info, lastUpdate, followerTypeID)
        local counter = button.Counters[index]
        if not counter._auroraSkinned then
            Skin.GarrisonMissionAbilityCounterTemplate(counter)
            counter._auroraSkinned = true
        end

        local scale = _G.GarrisonFollowerOptions[followerTypeID].followerListCounterScale
        if scale ~= 1 then
            counter:SetScale(1)
            local size = 20 * scale
            counter:SetSize(size, size)
        end
    end
    function Hook.GarrisonFollowerList_ExpandButtonAbilities(self, button, traitsFirst)
        if not button.isCollected then
            return -1
        end

        local abHeight = 0
        local buttonCount = 0
        for i = 1, #button.info.abilities do
            if traitsFirst == button.info.abilities[i].isTrait and button.info.abilities[i].icon then
                buttonCount = buttonCount + 1

                local Ability = button.Abilities[buttonCount]
                abHeight = abHeight + (Ability:GetHeight() + Scale.Value(3))
            end
        end
        for i = 1, #button.info.abilities do
            if traitsFirst ~= button.info.abilities[i].isTrait and button.info.abilities[i].icon then
                buttonCount = buttonCount + 1

                local Ability = button.Abilities[buttonCount]
                abHeight = abHeight + (Ability:GetHeight() + Scale.Value(3))
            end
        end

        for i = (#button.info.abilities + 1), #button.Abilities do
            button.Abilities[i]:Hide()
        end
        if abHeight > 0 then
            abHeight = abHeight + 8
            button.AbilitiesBG:Show()
            Scale.RawSetHeight(button.AbilitiesBG, abHeight)
        else
            button.AbilitiesBG:Hide()
        end
        return abHeight
    end
    function Hook.GarrisonFollowerList_ExpandButton(self, button, followerListFrame)
        local abHeight = Hook.GarrisonFollowerList_ExpandButtonAbilities(self, button, false)
        if abHeight == -1 then
            return
        end

        button.UpArrow:Show()
        button.DownArrow:Hide()
        Scale.RawSetHeight(button, Scale.Value(51) + abHeight)
        followerListFrame.expandedFollowerHeight = Scale.Value(51) + abHeight + Scale.Value(6)
    end
    function Hook.GarrisonFollowerButton_AddAbility(self, index, ability, followerType)
        local Ability = self.Abilities[index]
        if not Ability._auroraSkinned then
            Skin.GarrisonFollowerListButtonAbilityTemplate(Ability)
            Ability._auroraSkinned = true
        end
    end
    function Hook.GarrisonFollowerList_CollapseButton(self, button)
        button:SetHeight(46)
    end
    function Hook.GarrisonFollowerTabMixin_OnLoad(self)
        _G.hooksecurefunc(self.abilitiesPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
        _G.hooksecurefunc(self.equipmentPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
        _G.hooksecurefunc(self.countersPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
    end


    ----====####$$$$%%%%%%%$$$$####====----
    -- Blizzard_GarrisonMissionTemplates --
    ----====####$$$$%%%%%%%$$$$####====----
    function Hook.GarrisonMission_RemoveFollowerFromMission(self, frame, updateValues)
        Hook.GarrisonFollowerPortraitMixin_SetQuality(frame.PortraitFrame, 1)
    end
    function Hook.GarrisonMissionFrame_SetItemRewardDetails(frame)
        local _, _, quality = _G.GetItemInfo(frame.itemID)
        Hook.SetItemButtonQuality(frame, quality, frame.itemID)
    end
end

do --[[ AddOns\Blizzard_GarrisonTemplates.xml ]]
    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_GarrisonSharedTemplates --
    ----====####$$$$%%%%%%$$$$####====----
    function Skin.GarrisonUITemplate(Frame)
        Base.CreateBackdrop(Frame, private.backdrop, {
            bg = Frame.BackgroundTile,

            l = Frame.Left,
            r = Frame.Right,
            t = Frame.Top,
            b = Frame.Bottom,

            tl = Frame.GarrCorners.TopLeftGarrCorner,
            tr = Frame.GarrCorners.TopRightGarrCorner,
            bl = Frame.GarrCorners.BottomLeftGarrCorner,
            br = Frame.GarrCorners.BottomRightGarrCorner,

            borderLayer = "BACKGROUND",
            borderSublevel = -7,
        })
        Skin.BaseBasicFrameTemplate(Frame)
    end

    function Skin.GarrisonMissionBaseFrameTemplate(Frame)
        Frame.BaseFrameBackground:Hide()
        Frame.BaseFrameTop:Hide()
        Frame.BaseFrameBottom:Hide()
        Frame.BaseFrameLeft:Hide()
        Frame.BaseFrameRight:Hide()
        Frame.BaseFrameTopLeft:Hide()
        Frame.BaseFrameTopRight:Hide()
        Frame.BaseFrameBottomLeft:Hide()
        Frame.BaseFrameBottomRight:Hide()

        for i = 10, 17 do
            select(i, Frame:GetRegions()):Hide()
        end

        Base.SetBackdrop(Frame, Color.frame)
    end
    function Skin.GarrisonListTemplate(Frame)
        Skin.GarrisonMissionBaseFrameTemplate(Frame)

        Frame.listScroll:SetPoint("TOPLEFT", 2, -2)
        Frame.listScroll:SetPoint("BOTTOMRIGHT", -20, 2)
        Skin.HybridScrollBarTrimTemplate(Frame.listScroll.scrollBar)
    end
    function Skin.GarrisonListTemplateHeader(Frame)
        Skin.GarrisonListTemplate(Frame)

        Frame.HeaderLeft:Hide()
        Frame.HeaderRight:Hide()
        Frame.HeaderMid:Hide()
    end

    function Skin.GarrisonFollowerButtonTemplate(Frame)
        Frame.BG:Hide()
        Base.SetBackdrop(Frame, Color.button, 0.5)

        Frame.Selection:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
        Frame.Selection:SetAllPoints()

        Frame.XPBar:SetPoint("TOPLEFT", Frame.PortraitFrame, "BOTTOMRIGHT", 0, 6)
        Skin.GarrisonFollowerPortraitTemplate(Frame.PortraitFrame)
        Frame.PortraitFrame:SetPoint("TOPLEFT", -3, 3)
        Frame.Highlight:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
        Frame.Highlight:SetAllPoints()

        --[[ Scale ]]--
        Frame:SetWidth(260)
    end
    function Skin.GarrisonFollowerCombatAllySpellTemplate(Button)
        Base.CropIcon(Button.iconTexture, Button)
    end
    function Skin.GarrisonFollowerEquipmentTemplate(Button)
        Skin.GarrisonEquipmentTemplate(Button)
        Button.BG:Hide()
        Button.Border:Hide()

        local bg = _G.CreateFrame("Frame", nil, Button)
        bg:SetFrameLevel(Button:GetFrameLevel())
        bg:SetPoint("TOPLEFT", Button.Icon, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", Button.Icon, 1, -1)
        Base.SetBackdrop(bg, Color.button, 0.3)
    end
    function Skin.GarrisonMissionFollowerDurabilityFrameTemplate(Frame)
    end
    function Skin.GarrisonAbilityCounterTemplate(Frame)
        Base.CropIcon(Frame.Icon, Frame)
        Frame.Icon:SetSize(20, 20)

        Frame.Border:ClearAllPoints()
        Frame.Border:SetPoint("TOPLEFT", Frame.Icon, -8, 8)
        Frame.Border:SetPoint("BOTTOMRIGHT", Frame.Icon, 8, -8)
    end
    function Skin.GarrisonMissionAbilityCounterTemplate(Frame)
        Skin.GarrisonAbilityCounterTemplate(Frame)
    end
    function Skin.GarrisonFollowerListButtonAbilityTemplate(Frame)
        Base.CropIcon(Frame.Icon, Frame)
    end
    function Skin.GarrisonMissionFollowerButtonTemplate(Frame)
        Skin.GarrisonFollowerButtonTemplate(Frame)
        Frame.AbilitiesBG:SetAlpha(0)
        Frame.BusyFrame:SetAllPoints()
    end
    function Skin.GarrisonMissionFollowerOrCategoryListButtonTemplate(Frame)
        Skin.GarrisonMissionFollowerButtonTemplate(Frame.Follower)
    end
    function Skin.MaterialFrameTemplate(Frame)
        local bg, label = Frame:GetRegions()
        bg:Hide()
        label:SetPoint("LEFT", 5, 0)
        Frame.Materials:SetPoint("RIGHT", Frame.Icon, "LEFT", -5, 0)

        Base.CropIcon(Frame.Icon, Frame)
        Frame.Icon:SetSize(18, 18)
        Frame.Icon:SetPoint("RIGHT", -5, 0)

        Base.SetBackdrop(Frame, Color.frame, 0.5)
        Frame:SetBackdropBorderColor(Color.yellow)
    end
    function Skin.GarrisonEquipmentTemplate(Button)
        Base.CropIcon(Button.Icon)
    end

    ----====####$$$$%%%%%%%$$$$####====----
    -- Blizzard_GarrisonMissionTemplates --
    ----====####$$$$%%%%%%%$$$$####====----
    function Skin.GarrisonMissionRewardEffectsTemplate(Frame)
        Base.CropIcon(Frame.Icon)

        Frame.IconBorder:Hide()
        local iconBG = _G.CreateFrame("Frame", nil, Frame)
        iconBG:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
        iconBG:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
        Base.SetBackdrop(iconBG, Color.black, 0)
        Frame._auroraIconBorder = iconBG

        Frame.BG:SetAlpha(0)
        local nameBG = _G.CreateFrame("Frame", nil, Frame)
        nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 1, 0)
        nameBG:SetPoint("BOTTOMRIGHT", -3, -1)
        Base.SetBackdrop(nameBG, Color.frame)
        Frame._auroraNameBG = nameBG

        --[[ Scale ]]--
        Frame:SetSize(Frame:GetSize())
    end
    function Skin.GarrisonMissionPageOvermaxRewardTemplate(Frame)
        Base.CropIcon(Frame.Icon)

        Frame.IconBorder:Hide()
        local iconBG = _G.CreateFrame("Frame", nil, Frame)
        iconBG:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
        iconBG:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
        Base.SetBackdrop(iconBG, Color.black, 0)
        Frame._auroraIconBorder = iconBG

        --[[ Scale ]]--
        Frame:SetSize(Frame:GetSize())
    end
    function Skin.GarrisonMissionPageRewardTemplate(Frame)
        Skin.GarrisonMissionPageOvermaxRewardTemplate(Frame.OvermaxItem)
        Skin.GarrisonMissionRewardEffectsTemplate(Frame.Reward1)
        Skin.GarrisonMissionRewardEffectsTemplate(Frame.Reward2)
    end
    function Skin.GarrisonAbilityLargeCounterTemplate(Frame)
        Base.CropIcon(Frame.Icon, Frame)
    end
    function Skin.GarrisonMissionLargeMechanicTemplate(Frame)
        Skin.GarrisonAbilityLargeCounterTemplate(Frame)
    end
    function Skin.GarrisonMissionCheckTemplate(Frame)
    end
    function Skin.GarrisonMissionMechanicTemplate(Frame)
        Skin.GarrisonAbilityCounterTemplate(Frame)
    end
    function Skin.GarrisonMissionEnemyMechanicTemplate(Frame)
        Skin.GarrisonMissionMechanicTemplate(Frame)
        Skin.GarrisonMissionCheckTemplate(Frame)
    end
    function Skin.GarrisonMissionEnemyLargeMechanicTemplate(Frame)
        Skin.GarrisonMissionLargeMechanicTemplate(Frame)
        Skin.GarrisonMissionCheckTemplate(Frame)
    end
    function Skin.GarrisonMissionStageTemplate(Frame)
        Frame.LocBack:SetPoint("TOPLEFT")
        Frame.LocBack:SetPoint("BOTTOMRIGHT")
        Frame.LocBack:SetVertexColor(Color.gray:GetRGB())
        select(4, Frame:GetRegions()):Hide()

        local mask1 = Frame:CreateMaskTexture(nil, "ARTWORK")
        mask1:SetTexture([[Interface\Common\icon-shadow]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask1:SetPoint("TOPLEFT", Frame.LocBack, -150, 100)
        mask1:SetPoint("BOTTOMRIGHT", Frame.LocBack, 150, -20)
        Frame.LocBack:AddMaskTexture(mask1)
        Frame.LocMid:AddMaskTexture(mask1)
        Frame.LocFore:AddMaskTexture(mask1)
    end
    function Skin.StartMissionButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
        Button.Flash:SetAtlas("GarrMission_FollowerListButton-Select")
        Button.Flash:SetAllPoints()
        Button.Flash:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
    end
    function Skin.GarrisonMissionPageCostFrameTemplate(Button)
        Base.CropIcon(Button.CostIcon, Button)
    end
    function Skin.GarrisonMissionPageStageTemplate(Frame)
        Skin.GarrisonMissionStageTemplate(Frame)
        Skin.VerticalLayoutFrame(Frame.MissionInfo)
    end
    function Skin.GarrisonMissionPageCloseButtonTemplate(Button)
        Skin.UIPanelCloseButton(Button)
        Button:SetSize(22, 22)
    end
    function Skin.GarrisonMissionFrameTemplate(Frame)
        --[[ Scale ]]--
        Frame:SetSize(Frame:GetSize())
    end
    function Skin.GarrisonMissionCompleteDialogTemplate(Frame)
        Skin.GarrisonMissionStageTemplate(Frame.Stage)
        local left, right = select(5, Frame.Stage:GetRegions())
        left:Hide()
        right:Hide()

        Skin.UIPanelButtonTemplate(Frame.ViewButton)
    end
    function Skin.GarrisonMissionBonusRewardsTemplate(Frame)
        local bg, tl, tr, bl, br, l, r, t, b = Frame.Saturated:GetRegions()
        Base.CreateBackdrop(Frame, private.backdrop, {
            bg = bg,

            l = l,
            r = r,
            t = t,
            b = b,

            tl = tl,
            tr = tr,
            bl = bl,
            br = br,

            borderLayer = "BACKGROUND",
            borderSublevel = -7,
        })
        Base.SetBackdrop(Frame, Color.frame)
    end
    function Skin.GarrisonMissionCompleteStageTemplate(Frame)
    end
    function Skin.GarrisonMissionCompleteTemplate(Frame)
        Frame.ButtonFrameLeft:Hide()
        Frame.ButtonFrameRight:Hide()
        Skin.UIPanelButtonTemplate(Frame.NextMissionButton)
    end
    function Skin.GarrisonFollowerXPBarTemplate(StatusBar)
        StatusBar.XPLeft:ClearAllPoints()
        StatusBar.XPRight:ClearAllPoints()
        Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")
    end
    function Skin.GarrisonFollowerXPGainTemplate(Frame)
    end
    function Skin.GarrisonFollowerLevelUpTemplate(Frame)
    end
end

function private.AddOns.Blizzard_GarrisonTemplates()
    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_GarrisonSharedTemplates --
    ----====####$$$$%%%%%%$$$$####====----
    --_G.hooksecurefunc(_G.GarrisonFollowerList, "UpdateData", Hook.GarrisonFollowerList_UpdateData)
    _G.hooksecurefunc("GarrisonFollowerButton_SetCounterButton", Hook.GarrisonFollowerButton_SetCounterButton)
    --_G.hooksecurefunc(_G.GarrisonFollowerList, "ExpandButton", Hook.GarrisonFollowerList_ExpandButton)
    _G.hooksecurefunc("GarrisonFollowerButton_AddAbility", Hook.GarrisonFollowerButton_AddAbility)
    --_G.hooksecurefunc(_G.GarrisonFollowerList, "CollapseButton", Hook.GarrisonFollowerList_CollapseButton)

    _G.hooksecurefunc(_G.GarrisonFollowerTabMixin, "OnLoad", Hook.GarrisonFollowerTabMixin_OnLoad)

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--


    ----====####$$$$%%%%%%%$$$$####====----
    -- Blizzard_GarrisonMissionTemplates --
    ----====####$$$$%%%%%%%$$$$####====----
    _G.hooksecurefunc(_G.GarrisonMission, "RemoveFollowerFromMission", Hook.GarrisonMission_RemoveFollowerFromMission)
    _G.hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", Hook.GarrisonMissionFrame_SetItemRewardDetails)

    if not private.disabled.tooltips then
        Skin.GameTooltipTemplate(_G.GarrisonMissionMechanicTooltip)
        Skin.PositionGarrisonAbiltyBorder(_G.GarrisonMissionMechanicTooltip.Border, _G.GarrisonMissionMechanicTooltip.Icon)
        Skin.GameTooltipTemplate(_G.GarrisonMissionMechanicFollowerCounterTooltip)
        Skin.PositionGarrisonAbiltyBorder(_G.GarrisonMissionMechanicFollowerCounterTooltip.Border, _G.GarrisonMissionMechanicFollowerCounterTooltip.Icon)
    end

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
