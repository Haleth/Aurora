local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do AddOns\Blizzard_OrderHallUI.lua
end ]]

--[[ do AddOns\Blizzard_OrderHallUI.xml
end ]]

function private.AddOns.Blizzard_OrderHallUI()
    ----====####$$$$%%%%%$$$$####====----
    --   Blizzard_OrderHallMissionUI   --
    ----====####$$$$%%%%%$$$$####====----
    if not private.isPatch then
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
    end

    ----====####$$$$%%%%%$$$$####====----
    --    Blizzard_OrderHallTalents    --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --  Blizzard_OrderHallCommandBar  --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
