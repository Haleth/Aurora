local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_GarrisonUI.lua ]]
    function Hook.GarrisonFollowerMission_RemoveFollowerFromMission(self, frame, updateValues)
        Hook.GarrisonFollowerPortraitMixin_SetQuality(frame.PortraitFrame, 1)
    end
end

do --[[ AddOns\Blizzard_GarrisonUI.xml ]]
    do --[[ Blizzard_GarrisonShipyardUI.xml ]]
        function Skin.GarrisonBonusEffectFrameTemplate(Frame)
            Base.CropIcon(Frame.Icon, Frame)
        end
        function Skin.GarrisonBonusAreaTooltipFrameTemplate(Frame)
            Skin.GarrisonBonusEffectFrameTemplate(Frame.BonusEffectFrame)
        end
    end
    do --[[ Blizzard_GarrisonMissionUI.xml ]]
        function Skin.GarrisonFollowerMissionPortraitTemplate(Frame)
            Skin.GarrisonFollowerPortraitTemplate(Frame)
            Hook.GarrisonFollowerPortraitMixin_SetQuality(Frame, 1)
            Frame.Level:Hide()

            Frame.Empty:SetAtlas("Garr_FollowerPortrait_Bg")
            Frame.Empty:SetAllPoints(Frame.Portrait)
            Frame.Empty:SetTexCoord(0.08620689655172, 0.86206896551724, 0.06896551724138, 0.8448275862069)

            Frame.Highlight:SetTexture([[Interface\Buttons\CheckButtonHilight]])
            Frame.Highlight:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
            Frame.Highlight:SetPoint("TOPLEFT", Frame._auroraPortraitBG)
            Frame.Highlight:SetPoint("BOTTOMRIGHT", Frame._auroraLvlBG, "TOPRIGHT")
        end
        function Skin.GarrisonMissionListTabTemplate(Button)
            Button.Left:SetAlpha(0)
            Button.Right:SetAlpha(0)
            Button.Middle:SetAlpha(0)
            Button.SelectedLeft:SetAlpha(0)
            Button.SelectedRight:SetAlpha(0)
            Button.SelectedMid:SetAlpha(0)
        end
        function Skin.GarrisonFollowerPageAbilityIconButtonTemplate(Button)
            Base.CropIcon(Button.Icon)
        end
        function Skin.GarrisonFollowerPageAbilityTemplate(Button)
            Skin.GarrisonFollowerPageAbilityIconButtonTemplate(Button.IconButton, Button)
        end
        function Skin.GarrisonMissionListButtonRewardTemplate(Frame)
            Base.CropIcon(Frame.Icon)

            local bg = _G.CreateFrame("Frame", nil, Frame)
            bg:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
            bg:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
            Base.SetBackdrop(bg, Color.black, 0)
            Frame._auroraIconBorder = bg

            --[[ Scale ]]--
            Frame:SetSize(Frame:GetSize())
        end
        function Skin.GarrisonMissionListButtonNewHighlightTemplate(Frame)
        end
        function Skin.GarrisonMissionListButtonTemplate(Button)
            local bg, l, r, t, b, _, t2, b2, tl, tr, bl, br = Button:GetRegions()
            Base.CreateBackdrop(Button, private.backdrop, {
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
            Base.SetBackdrop(Button, Color.button)
            t2:Hide()
            b2:Hide()

            Button:DisableDrawLayer("HIGHLIGHT")
            Base.SetHighlight(Button, "backdrop")
            Skin.GarrisonMissionListButtonRewardTemplate(Button.Rewards[1])
        end
        function Skin.GarrisonFollowerMissionRewardsFrameTemplate(Frame)
            local bg, l, r, t, b, tl, tr, bl, br = Frame:GetRegions()
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
        function Skin.GarrisonMissionPageFollowerTemplate(Frame)
            Frame:GetRegions():Hide()
            local portraitBG = _G.CreateFrame("Frame", nil, Frame)
            portraitBG:SetFrameLevel(Frame:GetFrameLevel())
            portraitBG:SetPoint("TOPLEFT", Frame, -1, 1)
            portraitBG:SetPoint("BOTTOMRIGHT", Frame, 1, -1)
            Base.SetBackdrop(portraitBG, Color.button, 0.5)

            Skin.GarrisonFollowerMissionPortraitTemplate(Frame.PortraitFrame)
        end
        function Skin.GarrisonMissionPageBaseTemplate(Frame)
        end
        function Skin.GarrisonMissionListTemplate(Frame)
            Skin.GarrisonListTemplate(Frame)
            Skin.GarrisonMissionListTabTemplate(Frame.Tab1)
            Skin.GarrisonMissionListTabTemplate(Frame.Tab2)
            Skin.MaterialFrameTemplate(Frame.MaterialFrame)
            Frame.MaterialFrame:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", -9, 9)
            Frame.MaterialFrame:SetPoint("TOPLEFT", Frame, "TOPRIGHT", -307, 34)

            Skin.GarrisonMissionPageBaseTemplate(Frame.CompleteDialog.BorderFrame)
            Skin.GarrisonMissionCompleteDialogTemplate(Frame.CompleteDialog.BorderFrame)
        end
        function Skin.GarrisonFollowerTabTemplate(Frame)
            _G.hooksecurefunc(Frame.abilitiesPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
            _G.hooksecurefunc(Frame.equipmentPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
            _G.hooksecurefunc(Frame.countersPool, "Acquire", Hook.ObjectPoolMixin_Acquire)

            Skin.GarrisonMissionBaseFrameTemplate(Frame)

            Frame.HeaderBG:Hide()

            Skin.GarrisonFollowerPortraitTemplate(Frame.PortraitFrame)
            Skin.GarrisonFollowerXPBarTemplate(Frame.XPBar)

            Skin.GarrisonFollowerCombatAllySpellTemplate(Frame.AbilitiesFrame.CombatAllySpell[1])
            Skin.GarrisonFollowerCombatAllySpellTemplate(Frame.AbilitiesFrame.CombatAllySpell[2])
        end
    end
    do --[[ Blizzard_OrderHallMissionUI.xml ]]
        function Skin.OrderHallMissionListButtonTemplate(Button)
            Skin.GarrisonMissionListButtonTemplate(Button)
        end
        function Skin.OrderHallFrameTabButtonTemplate(Button)
            Skin.CharacterFrameTabButtonTemplate(Button)
            Button._auroraTabResize = true
        end
    end
end

function private.AddOns.Blizzard_GarrisonUI()
    ----====####$$$$%%%%%$$$$####====----
    --   Blizzard_GarrisonBuildingUI   --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.tooltips then
        Skin.TooltipBorderedFrameTemplate(_G.GarrisonBuildingFrame.BuildingLevelTooltip)
    end

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--




    ----====####$$$$%%%%$$$$####====----
    --   Blizzard_GarrisonMissionUI   --
    ----====####$$$$%%%%$$$$####====----
    _G.hooksecurefunc(_G.GarrisonFollowerMission, "RemoveFollowerFromMission", Hook.GarrisonFollowerMission_RemoveFollowerFromMission)

    Skin.GarrisonFollowerPortraitTemplate(_G.GarrisonFollowerPlacer)

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--




    ----====####$$$$%%%%%$$$$####====----
    --   Blizzard_GarrisonShipyardUI   --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.tooltips then
        Base.SetBackdrop(_G.GarrisonBonusAreaTooltip)
        Skin.GarrisonBonusAreaTooltipFrameTemplate(_G.GarrisonBonusAreaTooltip.BonusArea)

        Base.SetBackdrop(_G.GarrisonShipyardMapMissionTooltip)
        Skin.EmbeddedItemTooltip(_G.GarrisonShipyardMapMissionTooltip.ItemTooltip)
        Skin.GarrisonBonusEffectFrameTemplate(_G.GarrisonShipyardMapMissionTooltip.BonusEffect)
        Skin.GarrisonBonusEffectFrameTemplate(_G.GarrisonShipyardMapMissionTooltip.BonusReward)
    end

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--




    ----====####$$$$%%%%$$$$####====----
    --  Blizzard_GarrisonLandingPage  --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--




    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_GarrisonCapacitiveDisplay --
    ----====####$$$$%%%%%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--




    ----====####$$$$%%%%%$$$$####====----
    --   Blizzard_GarrisonMonumentUI   --
    ----====####$$$$%%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--




    ----====####$$$$%%%%$$$$####====----
    --  Blizzard_GarrisonRecruiterUI  --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--




    if not private.isPatch then return end
    ----====####$$$$%%%%%$$$$####====----
    --   Blizzard_OrderHallMissionUI   --
    ----====####$$$$%%%%%$$$$####====----
    local OrderHallMissionFrame = _G.OrderHallMissionFrame
    Skin.GarrisonMissionFrameTemplate(OrderHallMissionFrame)
    Skin.GarrisonUITemplate(OrderHallMissionFrame)

    OrderHallMissionFrame.ClassHallIcon:SetClipsChildren(true)
    OrderHallMissionFrame.ClassHallIcon:SetFrameLevel(OrderHallMissionFrame:GetFrameLevel())
    OrderHallMissionFrame.ClassHallIcon:SetFrameStrata(OrderHallMissionFrame:GetFrameStrata())
    OrderHallMissionFrame.ClassHallIcon:SetPoint("TOPLEFT")
    OrderHallMissionFrame.ClassHallIcon:SetSize(200, 200)
    local _, className = _G.UnitClass("player")
    OrderHallMissionFrame.ClassHallIcon.Icon:ClearAllPoints()
    OrderHallMissionFrame.ClassHallIcon.Icon:SetPoint("CENTER", OrderHallMissionFrame.ClassHallIcon, "TOPLEFT", 50, -50)
    OrderHallMissionFrame.ClassHallIcon.Icon:SetAtlas("legionmission-landingpage-background-"..className, true)
    OrderHallMissionFrame.ClassHallIcon.Icon:SetDesaturated(true)

    Skin.OrderHallFrameTabButtonTemplate(OrderHallMissionFrame.Tab1)
    OrderHallMissionFrame.Tab1:SetPoint("TOPLEFT", OrderHallMissionFrame, "BOTTOMLEFT", 20, -1)
    Skin.OrderHallFrameTabButtonTemplate(OrderHallMissionFrame.Tab2)
    OrderHallMissionFrame.Tab2:SetPoint("TOPLEFT", OrderHallMissionFrame.Tab1, "TOPRIGHT", 1, 0)
    Skin.OrderHallFrameTabButtonTemplate(OrderHallMissionFrame.Tab3)
    OrderHallMissionFrame.Tab3:SetPoint("TOPLEFT", OrderHallMissionFrame.Tab2, "TOPRIGHT", 1, 0)

    ------------------
    -- FollowerList --
    ------------------
    local OrderHallFollowerList = OrderHallMissionFrame.FollowerList
    Skin.GarrisonListTemplateHeader(OrderHallFollowerList)
    Skin.MaterialFrameTemplate(OrderHallFollowerList.MaterialFrame)
    OrderHallFollowerList.MaterialFrame:SetPoint("TOPLEFT", OrderHallFollowerList, "BOTTOMLEFT", 0, -2)
    OrderHallFollowerList.MaterialFrame:SetPoint("BOTTOMRIGHT", 0, -30)
    Skin.SearchBoxTemplate(OrderHallFollowerList.SearchBox)

    --[[ Scale ]]--

    ------------
    -- MapTab --
    ------------
    local OrderHallMapTab = OrderHallMissionFrame.MapTab
    OrderHallMapTab.ScrollContainer:ClearAllPoints()
    OrderHallMapTab.ScrollContainer:SetPoint("TOPLEFT")
    OrderHallMapTab.ScrollContainer:SetPoint("BOTTOMRIGHT")

    --[[ Scale ]]--

    ----------------
    -- MissionTab --
    ----------------
    local OrderHallMissionTab = OrderHallMissionFrame.MissionTab
    Skin.GarrisonMissionListTemplate(OrderHallMissionTab.MissionList)

    local CombatAllyUI = OrderHallMissionTab.MissionList.CombatAllyUI
    Base.SetBackdrop(CombatAllyUI, Color.frame)
    CombatAllyUI.Background:Hide()

    local AddFollowerButton = CombatAllyUI.Available.AddFollowerButton
    AddFollowerButton.EmptyPortrait:Hide()
    AddFollowerButton.Plus:SetSize(42, 42)
    AddFollowerButton.Plus:SetPoint("CENTER", 0, 5)
    local portraitBG = _G.CreateFrame("Frame", nil, AddFollowerButton)
    portraitBG:SetFrameLevel(AddFollowerButton:GetFrameLevel())
    portraitBG:SetPoint("TOPLEFT", AddFollowerButton.Plus, -1, 1)
    portraitBG:SetPoint("BOTTOMRIGHT", AddFollowerButton.Plus, 1, -1)
    Base.SetBackdrop(portraitBG, Color.button, 1)
    AddFollowerButton.PortraitHighlight:SetTexture([[Interface\Buttons\CheckButtonHilight-Blue]])
    AddFollowerButton.PortraitHighlight:SetTexCoord(0.234375, 0.765625, 0.234375, 0.765625)
    AddFollowerButton.PortraitHighlight:SetAllPoints(portraitBG)

    Skin.GarrisonFollowerPortraitTemplate(CombatAllyUI.InProgress.PortraitFrame)
    Skin.GarrisonFollowerCombatAllySpellTemplate(CombatAllyUI.InProgress.CombatAllySpell)
    Skin.UIPanelButtonTemplate(CombatAllyUI.InProgress.Unassign)

    OrderHallMissionTab.ZoneSupportMissionPageBackground.Background:ClearAllPoints()
    OrderHallMissionTab.ZoneSupportMissionPageBackground.Background:SetAllPoints(OrderHallMissionTab)

    local ZoneSupportMissionPage = OrderHallMissionTab.ZoneSupportMissionPage
    ZoneSupportMissionPage.ButtonFrame:SetAtlas("GarrMission_PartyBuffsBG", true)
    ZoneSupportMissionPage.ButtonFrame:SetWidth(400)
    ZoneSupportMissionPage.ButtonFrame:SetPoint("TOP", ZoneSupportMissionPage, "BOTTOM", 0, -13)
    Skin.GarrisonFollowerMissionRewardsFrameTemplate(ZoneSupportMissionPage)
    Skin.GarrisonMissionPageCloseButtonTemplate(ZoneSupportMissionPage.CloseButton)
    ZoneSupportMissionPage.CloseButton:SetPoint("TOPRIGHT", -5, 426)
    Skin.GarrisonMissionPageCostFrameTemplate(ZoneSupportMissionPage.CostFrame)
    Skin.GarrisonMissionPageFollowerTemplate(ZoneSupportMissionPage.Follower1)
    Skin.GarrisonFollowerCombatAllySpellTemplate(ZoneSupportMissionPage.CombatAllySpell)
    Skin.StartMissionButtonTemplate(ZoneSupportMissionPage.StartMissionButton)

    --[[ Scale ]]--

    -----------------
    -- FollowerTab --
    -----------------
    local OrderHallFollowerTab = OrderHallMissionFrame.FollowerTab
    Skin.GarrisonFollowerTabTemplate(OrderHallFollowerTab)

    --[[ Scale ]]--

    ---------------------
    -- MissionComplete --
    ---------------------
    local OrderHallMissionComplete = OrderHallMissionFrame.MissionComplete
    Skin.GarrisonMissionPageBaseTemplate(OrderHallMissionComplete)
    Skin.GarrisonMissionCompleteTemplate(OrderHallMissionComplete)

    --[[ Scale ]]--




    ----====####$$$$%%%%%$$$$####====----
    --      Blizzard_BFAMissionUI      --
    ----====####$$$$%%%%%$$$$####====----
    local BFAMissionFrame = _G.BFAMissionFrame
    Skin.GarrisonMissionFrameTemplate(BFAMissionFrame)
    Skin.GarrisonUITemplate(BFAMissionFrame)

    Skin.OrderHallFrameTabButtonTemplate(BFAMissionFrame.Tab1)
    BFAMissionFrame.Tab1:ClearAllPoints()
    BFAMissionFrame.Tab1:SetPoint("TOPLEFT", BFAMissionFrame, "BOTTOMLEFT", 20, -1)
    Skin.OrderHallFrameTabButtonTemplate(BFAMissionFrame.Tab2)
    BFAMissionFrame.Tab2:SetPoint("TOPLEFT", BFAMissionFrame.Tab1, "TOPRIGHT", 1, 0)
    Skin.OrderHallFrameTabButtonTemplate(BFAMissionFrame.Tab3)
    BFAMissionFrame.Tab3:SetPoint("TOPLEFT", BFAMissionFrame.Tab2, "TOPRIGHT", 1, 0)

    ------------------
    -- FollowerList --
    ------------------
    local BFAFollowerList = BFAMissionFrame.FollowerList
    Skin.GarrisonListTemplateHeader(BFAFollowerList)
    Skin.MaterialFrameTemplate(BFAFollowerList.MaterialFrame)
    BFAFollowerList.MaterialFrame:SetPoint("TOPLEFT", BFAFollowerList, "BOTTOMLEFT", 0, -2)
    BFAFollowerList.MaterialFrame:SetPoint("BOTTOMRIGHT", 0, -30)
    Skin.SearchBoxTemplate(BFAFollowerList.SearchBox)

    --[[ Scale ]]--

    ------------
    -- MapTab --
    ------------
    local BFAMapTab = BFAMissionFrame.MapTab
    BFAMapTab.ScrollContainer:ClearAllPoints()
    BFAMapTab.ScrollContainer:SetPoint("TOPLEFT")
    BFAMapTab.ScrollContainer:SetPoint("BOTTOMRIGHT")

    --[[ Scale ]]--

    ----------------
    -- MissionTab --
    ----------------
    local BFAMissionTab = BFAMissionFrame.MissionTab
    Skin.GarrisonMissionListTemplate(BFAMissionTab.MissionList)

    --[[ Scale ]]--

    -----------------
    -- FollowerTab --
    -----------------
    local BFAFollowerTab = BFAMissionFrame.FollowerTab
    Skin.GarrisonFollowerTabTemplate(BFAFollowerTab)

    --[[ Scale ]]--

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
