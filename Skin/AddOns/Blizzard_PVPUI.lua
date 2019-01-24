local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals ipairs select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_PVPUI.lua ]]
    function Hook.PVPQueueFrame_SelectButton(index)
        local self = _G.PVPQueueFrame
        for i = 1, 3 do
            local bu = self["CategoryButton"..i]
            if i == index then
                bu.Background:Show()
            else
                bu.Background:Hide()
            end
        end
    end
    function Hook.PVPUIFrame_ConfigureRewardFrame(rewardFrame, honor, experience, itemRewards, currencyRewards)
        local rewardTexture, currencyID, itemID

        -- artifact-level currency trumps item
        if currencyRewards then
            for i, reward in ipairs(currencyRewards) do
                local name, _, texture, _, _, _, _, quality = _G.GetCurrencyInfo(reward.id)
                if quality == _G.LE_ITEM_QUALITY_ARTIFACT then
                    _, texture = _G.CurrencyContainerUtil.GetCurrencyContainerInfo(reward.id, reward.quantity, name, texture, quality)
                    rewardTexture = texture
                    currencyID = reward.id
                end
            end
        end

        if not currencyID and itemRewards then
            local reward = itemRewards[1]
            if reward then
                itemID = reward.id
                rewardTexture = reward.texture
            end
        end

        if currencyID or itemID then
            rewardFrame.Icon:SetTexture(rewardTexture)
        end
    end
    local faction = _G.UnitFactionGroup("player") == "Horde" and [[Interface\Icons\UI_Horde_HonorboundMedal]] or [[Interface\Icons\UI_Alliance_7LegionMedal]]
    function Hook.PVPConquestBarRewardMixin_SetTexture(self, texture, alpha)
        if not texture then
            self.Icon:SetTexture(faction)
        end
    end
end

do --[[ AddOns\Blizzard_PVPUI.xml ]]
    function Skin.SeasonRewardFrameTemplate(Frame)
        Frame.Ring:Hide()
        Base.CropIcon(Frame.Icon, Frame)
        Frame.CircleMask:Hide()
    end
    function Skin.PVPSeasonChangesNoticeTemplate(Frame)
        Frame.BottomLeftCorner:Hide()
        Frame.BottomRightCorner:Hide()
        Frame.TopLeftCorner:Hide()
        Frame.TopRightCorner:Hide()

        Frame.BottomBorder:Hide()
        Frame.TopBorder:Hide()
        Frame.LeftBorder:Hide()
        Frame.RightBorder:Hide()

        Frame.LeftHide:Hide()
        Frame.LeftHide2:Hide()
        Frame.RightHide:Hide()
        Frame.RightHide2:Hide()
        Frame.BottomHide:Hide()
        Frame.BottomHide2:Hide()

        Frame.Background:SetColorTexture(0, 0, 0, 0.75)
        Frame.Background:SetPoint("TOPLEFT")
        Frame.Background:SetPoint("BOTTOMRIGHT")

        Frame.TopLeftFiligree:Hide()
        Frame.TopRightFiligree:Hide()

        Frame.NewSeason:SetTextColor(Color.white:GetRGB())
        Frame.SeasonDescription:SetTextColor(Color.grayLight:GetRGB())
        Frame.SeasonDescription2:SetTextColor(Color.grayLight:GetRGB())

        Skin.UIPanelButtonTemplate(Frame.Leave)
    end
    function Skin.PVPRewardTemplate(Frame)
        Frame.Border:Hide()
        Base.CropIcon(Frame.Icon, Frame)
    end
    function Skin.PVPConquestBarTemplate(StatusBar)
        _G.hooksecurefunc(StatusBar.Reward, "SetTexture", Hook.PVPConquestBarRewardMixin_SetTexture)

        StatusBar.Border:Hide()
        StatusBar.Background:Hide()

        Base.SetBackdrop(StatusBar, Color.button, 0.3)
        local bg = StatusBar:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", -1, 1)
        bg:SetPoint("BOTTOMRIGHT", 1, -1)

        StatusBar.Reward:SetPoint("LEFT", StatusBar, "RIGHT", -5, 0)
        StatusBar.Reward.Ring:Hide()
        Base.CropIcon(StatusBar.Reward.Icon, StatusBar.Reward)
        StatusBar.Reward.CircleMask:Hide()

        Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")
    end
    function Skin.PVPQueueFrameButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.button)
        Button:SetBackdropBorderColor(Color.frame, 1)
        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", Button.Icon, "TOPRIGHT", 0, 1)
        bg:SetPoint("BOTTOM", Button.Icon, 0, -1)
        bg:SetPoint("RIGHT")

        Button.Background:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.Background:SetAllPoints(bg)
        Button.Background:Hide()
        Button.Ring:Hide()
        Base.CropIcon(Button.Icon, Button)

        local highlight = Button:GetHighlightTexture()
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        highlight:SetAllPoints(bg)
    end
    function Skin.PVPCasualActivityButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.button)

        Button.SelectedTexture:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.SelectedTexture:ClearAllPoints()
        Button.SelectedTexture:SetPoint("TOPLEFT")
        Button.SelectedTexture:SetPoint("BOTTOMRIGHT")

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")

        local highlight = Button:GetHighlightTexture()
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT")
        highlight:SetPoint("BOTTOMRIGHT")

        Skin.PVPRewardTemplate(Button.Reward)
    end
    function Skin.PVPRatedTierTemplate(Frame)
    end
    function Skin.PVPRatedActivityButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.button)

        Button.SelectedTexture:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.SelectedTexture:ClearAllPoints()
        Button.SelectedTexture:SetPoint("TOPLEFT")
        Button.SelectedTexture:SetPoint("BOTTOMRIGHT")

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")

        local highlight = Button:GetHighlightTexture()
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT")
        highlight:SetPoint("BOTTOMRIGHT")

        Skin.PVPRewardTemplate(Button.Reward)
        Skin.PVPRatedTierTemplate(Button.Tier)
    end
end

function private.AddOns.Blizzard_PVPUI()
    _G.hooksecurefunc("PVPQueueFrame_SelectButton", Hook.PVPQueueFrame_SelectButton)

    local PVPQueueFrame = _G.PVPQueueFrame
    Skin.PVPQueueFrameButtonTemplate(PVPQueueFrame.CategoryButton1)
    Skin.PVPQueueFrameButtonTemplate(PVPQueueFrame.CategoryButton2)
    PVPQueueFrame.CategoryButton2:SetPoint("LEFT", PVPQueueFrame.CategoryButton1)
    Skin.PVPQueueFrameButtonTemplate(PVPQueueFrame.CategoryButton3)
    PVPQueueFrame.CategoryButton3:SetPoint("LEFT", PVPQueueFrame.CategoryButton2)
    PVPQueueFrame.CategoryButton1.Icon:SetTexture([[Interface\Icons\Achievement_BG_WinWSG]])
    PVPQueueFrame.CategoryButton2.Icon:SetTexture([[Interface\Icons\Achievement_BG_KillXEnemies_GeneralsRoom]])
    PVPQueueFrame.CategoryButton3.Icon:SetTexture([[Interface\Icons\Ability_Warrior_OffensiveStance]])

    ------------
    -- Casual --
    ------------
    local HonorFrame = _G.HonorFrame
    Skin.PVPConquestBarTemplate(HonorFrame.ConquestBar)
    Skin.InsetFrameTemplate(HonorFrame.Inset)
    Skin.LFGRoleButtonTemplate(HonorFrame.TankIcon)
    Skin.LFGRoleButtonTemplate(HonorFrame.HealerIcon)
    Skin.LFGRoleButtonTemplate(HonorFrame.DPSIcon)
    Skin.UIDropDownMenuTemplate(_G.HonorFrameTypeDropDown)
    Skin.HybridScrollBarTemplate(_G.HonorFrameSpecificFrameScrollBar)

    local BonusFrame = HonorFrame.BonusFrame
    BonusFrame.WorldBattlesTexture:Hide()
    Skin.PVPCasualActivityButtonTemplate(BonusFrame.RandomBGButton)
    Skin.PVPCasualActivityButtonTemplate(BonusFrame.RandomEpicBGButton)
    Skin.PVPCasualActivityButtonTemplate(BonusFrame.Arena1Button)
    Skin.PVPCasualActivityButtonTemplate(BonusFrame.BrawlButton)
    Skin.GlowBoxFrame(BonusFrame.BrawlHelpBox, "Left")
    BonusFrame.ShadowOverlay:Hide()

    Skin.MagicButtonTemplate(HonorFrame.QueueButton)

    -----------
    -- Rated --
    -----------
    local ConquestFrame = _G.ConquestFrame
    ConquestFrame.RatedBGTexture:Hide()
    Skin.PVPConquestBarTemplate(ConquestFrame.ConquestBar)
    Skin.InsetFrameTemplate(ConquestFrame.Inset)
    Skin.LFGRoleButtonTemplate(ConquestFrame.TankIcon)
    Skin.LFGRoleButtonTemplate(ConquestFrame.HealerIcon)
    Skin.LFGRoleButtonTemplate(ConquestFrame.DPSIcon)

    Skin.PVPRatedActivityButtonTemplate(ConquestFrame.Arena2v2)
    Skin.PVPRatedActivityButtonTemplate(ConquestFrame.Arena3v3)
    Skin.PVPRatedActivityButtonTemplate(ConquestFrame.RatedBG)
    ConquestFrame.ShadowOverlay:Hide()

    Skin.MagicButtonTemplate(ConquestFrame.JoinButton)
    Skin.GlowBoxTemplate(ConquestFrame.NoSeason)
    Skin.GlowBoxTemplate(ConquestFrame.Disabled)

    ----------------
    -- HonorInset --
    ----------------
    local HonorInset = PVPQueueFrame.HonorInset
    Skin.InsetFrameTemplate(HonorInset)
    local _, bg2 = HonorInset:GetRegions()
    bg2:Hide()

    local CasualPanel = HonorInset.CasualPanel
    local NextRewardLevel = CasualPanel.HonorLevelDisplay.NextRewardLevel
    Base.CropIcon(NextRewardLevel.RewardIcon, NextRewardLevel)
    NextRewardLevel.IconCover:SetAllPoints(NextRewardLevel.RewardIcon)
    NextRewardLevel.CircleMask:Hide()
    NextRewardLevel.RingBorder:Hide()

    local RatedPanel = HonorInset.RatedPanel
    Skin.SeasonRewardFrameTemplate(RatedPanel.SeasonRewardFrame)

    Skin.PVPSeasonChangesNoticeTemplate(PVPQueueFrame.NewSeasonPopup)
    PVPQueueFrame.NewSeasonPopup:SetPoint("TOPLEFT", ConquestFrame, 4, -3)
    PVPQueueFrame.NewSeasonPopup:SetPoint("BOTTOMRIGHT", 0, 0)
    Skin.SeasonRewardFrameTemplate(_G.SeasonRewardFrame)
    select(3, _G.SeasonRewardFrame:GetRegions()):SetTextColor(Color.grayLight:GetRGB())


    -------------
    -- Section --
    -------------
end
