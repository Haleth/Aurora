local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_PVPUI.lua ]]
    function Hook.PVPQueueFrame_SelectButton(index)
        for i = 1, 3 do
            local button = _G.PVPQueueFrame["CategoryButton"..i]
            if i == index then
                button.Background:Show()
            else
                button.Background:Hide()
            end
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
        Frame.CircleMask:Hide()
    end
    Skin.PVPStandardRewardTemplate = Skin.PVPRewardTemplate
    Skin.PVPAchievementRewardTemplate = Skin.PVPRewardTemplate

    function Skin.PVPConquestBarTemplate(StatusBar)
        Skin.FrameTypeStatusBar(StatusBar)
        StatusBar.Border:Hide()
        StatusBar.Background:Hide()

        Skin.PVPConquestRewardButton(StatusBar.Reward)
        StatusBar.Reward:SetPoint("LEFT", StatusBar, "RIGHT", -5, 0)
    end
    function Skin.PVPQueueFrameButtonTemplate(Button)
        Skin.FrameTypeButton(Button)

        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", Button.Icon, 0, 1)
        bg:SetPoint("BOTTOM", Button.Icon, 0, -1)
        bg:SetPoint("RIGHT")

        Button.Background:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.Background:SetAllPoints(bg)
        Button.Background:Hide()

        Button.Ring:Hide()
        Base.CropIcon(Button.Icon)
    end
    function Skin.PVPCasualActivityButton(Button)
        Skin.FrameTypeButton(Button)

        Button.SelectedTexture:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.SelectedTexture:ClearAllPoints()
        Button.SelectedTexture:SetPoint("TOPLEFT")
        Button.SelectedTexture:SetPoint("BOTTOMRIGHT")
    end
    function Skin.PVPCasualStandardButtonTemplate(Button)
        Skin.PVPCasualActivityButton(Button)
        Skin.PVPStandardRewardTemplate(Button.Reward)
    end
    function Skin.PVPCasualSpecialEventButtonTemplate(Button)
        Skin.PVPCasualActivityButton(Button)
        Skin.PVPAchievementRewardTemplate(Button.Reward)
    end
    function Skin.PVPRatedActivityButtonTemplate(Button)
        Skin.FrameTypeButton(Button)

        Button.SelectedTexture:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.SelectedTexture:ClearAllPoints()
        Button.SelectedTexture:SetPoint("TOPLEFT")
        Button.SelectedTexture:SetPoint("BOTTOMRIGHT")

        Skin.PVPStandardRewardTemplate(Button.Reward)
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
    HonorFrame:SetPoint("BOTTOM")

    Skin.PVPConquestBarTemplate(HonorFrame.ConquestBar)
    Skin.InsetFrameTemplate(HonorFrame.Inset)
    Skin.LFGRoleButtonTemplate(HonorFrame.TankIcon)
    Skin.LFGRoleButtonTemplate(HonorFrame.HealerIcon)
    Skin.LFGRoleButtonTemplate(HonorFrame.DPSIcon)
    Skin.UIDropDownMenuTemplate(_G.HonorFrameTypeDropDown)
    Skin.HybridScrollBarTemplate(_G.HonorFrameSpecificFrameScrollBar)

    local BonusFrame = HonorFrame.BonusFrame
    BonusFrame.WorldBattlesTexture:Hide()
    Skin.PVPCasualStandardButtonTemplate(BonusFrame.RandomBGButton)
    Skin.PVPCasualStandardButtonTemplate(BonusFrame.RandomEpicBGButton)
    Skin.PVPCasualStandardButtonTemplate(BonusFrame.Arena1Button)
    Skin.PVPCasualStandardButtonTemplate(BonusFrame.BrawlButton)
    Skin.PVPCasualSpecialEventButtonTemplate(BonusFrame.SpecialEventButton)
    if not private.isPatch then
        Skin.GlowBoxFrame(BonusFrame.BrawlHelpBox, "Left")
    end
    BonusFrame.ShadowOverlay:Hide()

    Skin.MagicButtonTemplate(HonorFrame.QueueButton)
    HonorFrame.QueueButton:SetPoint("BOTTOM", 0, 5)

    -----------
    -- Rated --
    -----------
    local ConquestFrame = _G.ConquestFrame
    ConquestFrame:SetPoint("BOTTOM")

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
    ConquestFrame.JoinButton:SetPoint("BOTTOM", 0, 5)

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
    Skin.PVPHonorRewardTemplate(CasualPanel.HonorLevelDisplay.NextRewardLevel)

    local NextRewardLevel = CasualPanel.HonorLevelDisplay.NextRewardLevel
    Base.CropIcon(NextRewardLevel.RewardIcon, NextRewardLevel)
    NextRewardLevel.IconCover:SetAllPoints(NextRewardLevel.RewardIcon)
    NextRewardLevel.CircleMask:Hide()
    NextRewardLevel.RingBorder:Hide()


    local RatedPanel = HonorInset.RatedPanel
    Skin.SeasonRewardFrameTemplate(RatedPanel.SeasonRewardFrame)

    local NewSeasonPopup = PVPQueueFrame.NewSeasonPopup
    Skin.PVPSeasonChangesNoticeTemplate(NewSeasonPopup)
    NewSeasonPopup:SetPoint("TOPLEFT", ConquestFrame, 4, -3)
    NewSeasonPopup:SetPoint("BOTTOMRIGHT", 0, 0)
    Skin.SeasonRewardFrameTemplate(NewSeasonPopup.SeasonRewardFrame)
    select(3, NewSeasonPopup.SeasonRewardFrame:GetRegions()):SetTextColor(Color.grayLight:GetRGB())
end
