local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\AlertFrameSystems.lua ]]
    function Hook.DungeonCompletionAlertFrameReward_SetRewardMoney(frame, optionalMoney)
        frame.texture:SetTexture([[Interface/Icons/inv_misc_coin_02]])
    end
    function Hook.DungeonCompletionAlertFrameReward_SetRewardXP(frame, optionalXP)
        frame.texture:SetTexture([[Interface/Icons/xp_icon]])
    end
    function Hook.DungeonCompletionAlertFrameReward_SetRewardItem(frame, itemLink, texture)
        frame.texture:SetTexture(texture)
    end
    function Hook.DungeonCompletionAlertFrameReward_SetReward(frame, reward)
        frame.texture:SetTexture(reward.texturePath)
    end
end

do --[[ FrameXML\AlertFrameSystems.xml ]]
    --[[
    function Skin.TemplateAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            -- Called when created: the main skin
            Skin.FrameTypeFrame(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropOption("offsets", {
                left = 11,
                right = 11,
                top = 10,
                bottom = 10,
            })

            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            ContainedAlertFrame.glow:SetPoint("TOPLEFT", bg, -10, 10)
            ContainedAlertFrame.glow:SetPoint("BOTTOMRIGHT", bg, 10, -10)
            ContainedAlertFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glow:SetTexCoord(0, 1, 0, 1)

            ContainedAlertFrame._auroraTemplate = "TemplateAlertFrameTemplate"
        else
            -- Called OnShow: adjustments based on changes made in <AlertFrameSystem>.setUpFunction
        end
    end
    ]]
    function Skin.DungeonCompletionAlertFrameRewardTemplate(Button)
        local texture, ring = Button:GetRegions()
        Base.CropIcon(texture, Button)
        ring:Hide()
    end
    Skin.InvasionAlertFrameRewardTemplate = Skin.DungeonCompletionAlertFrameRewardTemplate
    Skin.WorldQuestFrameRewardTemplate = Skin.DungeonCompletionAlertFrameRewardTemplate

    local heroicTexture = _G.CreateTextureMarkup([[Interface/LFGFrame/UI-LFG-ICON-HEROIC]], 32, 32, 16, 20, 0, 0.5, 0, 0.625, -5, 0)
    function Skin.DungeonCompletionAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Skin.FrameTypeFrame(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")

            Base.CropIcon(ContainedAlertFrame.dungeonTexture, ContainedAlertFrame)
            ContainedAlertFrame.raidArt:SetAlpha(0)
            ContainedAlertFrame.dungeonArt:SetAlpha(0)

            local title = select(7, ContainedAlertFrame:GetRegions())
            title:SetPoint("LEFT", ContainedAlertFrame.dungeonTexture, "RIGHT", 5, 0)
            title:SetPoint("RIGHT", bg, -5, 0)

            ContainedAlertFrame.instanceName:SetPoint("LEFT", ContainedAlertFrame.dungeonTexture, "RIGHT", 5, 0)
            ContainedAlertFrame.instanceName:SetPoint("RIGHT", bg, -5, 0)
            ContainedAlertFrame.heroicIcon:SetAlpha(0)

            ContainedAlertFrame.glowFrame.glow:SetPoint("TOPLEFT", bg, -10, 10)
            ContainedAlertFrame.glowFrame.glow:SetPoint("BOTTOMRIGHT", bg, 10, -10)
            ContainedAlertFrame.glowFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glowFrame.glow:SetTexCoord(0, 1, 0, 1)

            ContainedAlertFrame.shine:SetHeight(55)
            ContainedAlertFrame.shine:SetTexCoord(0.794921875, 0.96484375, 0.06640625, 0.23046875)
            --ContainedAlertFrame.shine:SetTexCoord(0.78125, 0.912109375, 0.06640625, 0.23046875)

            ContainedAlertFrame._auroraTemplate = "DungeonCompletionAlertFrameTemplate"
        else
            local rewardData = ContainedAlertFrame.rewardData
            if rewardData.subtypeID == _G.LFG_SUBTYPEID_RAID then
                ContainedAlertFrame:SetBackdropOption("offsets", {
                    left = 20,
                    right = 20,
                    top = 14,
                    bottom = 9,
                })
                ContainedAlertFrame.shine:SetPoint("BOTTOMLEFT", 0, 10)
            else
                ContainedAlertFrame:SetBackdropOption("offsets", {
                    left = 7,
                    right = 7,
                    top = 11,
                    bottom = 12,
                })
                ContainedAlertFrame.shine:SetPoint("BOTTOMLEFT", 0, 13)
            end

            for i, button in next, ContainedAlertFrame.RewardFrames do
                if not button._auroraSkinned then
                    Skin.DungeonCompletionAlertFrameRewardTemplate(button)
                    button._auroraSkinned = true
                end
            end

            if rewardData.subtypeID == _G.LFG_SUBTYPEID_HEROIC then
                ContainedAlertFrame.instanceName:SetText(heroicTexture .. rewardData.name)
            end
        end
    end
    function Skin.AchievementAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Skin.FrameTypeFrame(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")

            ContainedAlertFrame.Background:Hide()
            ContainedAlertFrame.Unlocked:SetPoint("LEFT", ContainedAlertFrame.Icon.Texture, "RIGHT", 5, 0)
            ContainedAlertFrame.Unlocked:SetPoint("RIGHT", ContainedAlertFrame.Shield.Icon, "LEFT", -5, 0)
            ContainedAlertFrame.Unlocked:SetTextColor(1, 1, 1)
            ContainedAlertFrame.Name:SetSize(0, 0)

            local guildBG = ContainedAlertFrame:CreateTexture(nil, "BACKGROUND")
            guildBG:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
            guildBG:SetTexCoord(0, 0.6640625, 0, 0.25)
            guildBG:SetVertexColor(0, 0, 0)
            guildBG:SetPoint("BOTTOM", ContainedAlertFrame, "TOP", 0, -30)
            guildBG:SetSize(340, 64)
            ContainedAlertFrame._auroraGuildBG = guildBG

            ContainedAlertFrame.OldAchievement:SetAlpha(0)
            ContainedAlertFrame.glow:SetPoint("TOPLEFT", bg, -10, 10)
            ContainedAlertFrame.glow:SetPoint("BOTTOMRIGHT", bg, 10, -10)
            ContainedAlertFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glow:SetTexCoord(0, 1, 0, 1)
            ContainedAlertFrame.shine:SetHeight(58)

            Base.CropIcon(ContainedAlertFrame.Icon.Texture, ContainedAlertFrame)
            ContainedAlertFrame.Icon.Overlay:Hide()
            ContainedAlertFrame._auroraTemplate = "AchievementAlertFrameTemplate"
        else
            ContainedAlertFrame.Unlocked:SetPoint("RIGHT", ContainedAlertFrame.Shield.Icon, "LEFT", -5, 0)
            ContainedAlertFrame.Name:ClearAllPoints()
            ContainedAlertFrame.Name:SetPoint("TOP", ContainedAlertFrame.Unlocked, "BOTTOM", -2, 0)
            ContainedAlertFrame.Name:SetPoint("LEFT", ContainedAlertFrame.Icon.Texture, "RIGHT", 5, 0)
            ContainedAlertFrame.Name:SetPoint("RIGHT", ContainedAlertFrame.Shield.Icon, "LEFT", -5, 0)

            ContainedAlertFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glow:SetTexCoord(0, 1, 0, 1)
            if ContainedAlertFrame.guildDisplay then
                ContainedAlertFrame:SetBackdropOption("offsets", {
                    left = 6,
                    right = 6,
                    top = 29,
                    bottom = 15,
                })
                ContainedAlertFrame._auroraGuildBG:Show()

                ContainedAlertFrame.Icon:SetPoint("TOPLEFT", -26, 0)
                ContainedAlertFrame.shine:SetTexCoord(0.75195313, 0.91601563, 0.25, 0.3359375)
            else
                ContainedAlertFrame:SetBackdropOption("offsets", {
                    left = 6,
                    right = 6,
                    top = 13,
                    bottom = 15,
                })
                ContainedAlertFrame._auroraGuildBG:Hide()

                ContainedAlertFrame.shine:SetTexCoord(0.78125, 0.912109375, 0.06640625, 0.23046875)
                ContainedAlertFrame.shine:SetPoint("BOTTOMLEFT", 0, 16)

                if ContainedAlertFrame.oldCheevo then
                    local bg = ContainedAlertFrame:GetBackdropTexture("bg")
                    ContainedAlertFrame.Unlocked:SetPoint("RIGHT", bg, -5, 0)
                    ContainedAlertFrame.Name:SetPoint("LEFT", ContainedAlertFrame.Icon.Texture, "RIGHT", 5, 0)
                    ContainedAlertFrame.Name:SetPoint("RIGHT", bg, -5, 0)
                end
            end
        end
    end
    function Skin.CriteriaAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Skin.FrameTypeFrame(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropOption("offsets", {
                left = 0,
                right = 0,
                top = 2,
                bottom = 8,
            })

            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            ContainedAlertFrame.Background:Hide()
            ContainedAlertFrame.Unlocked:SetTextColor(Color.white:GetRGB())
            ContainedAlertFrame.Name:SetTextColor(Color.grayLight:GetRGB())

            ContainedAlertFrame.glow:SetPoint("TOPLEFT", bg, -10, 10)
            ContainedAlertFrame.glow:SetPoint("BOTTOMRIGHT", bg, 10, -10)
            ContainedAlertFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glow:SetTexCoord(0, 1, 0, 1)
            ContainedAlertFrame.shine:SetTexCoord(0.78125, 0.912109375, 0.0703125, 0.2265625)
            ContainedAlertFrame.shine:SetPoint("TOPLEFT", 18, -3)
            ContainedAlertFrame.shine:SetHeight(40)

            Base.CropIcon(ContainedAlertFrame.Icon.Texture, ContainedAlertFrame)
            ContainedAlertFrame.Icon.Texture:SetSize(40, 40)
            ContainedAlertFrame.Icon.Overlay:Hide()
            ContainedAlertFrame._auroraTemplate = "CriteriaAlertFrameTemplate"
        end
    end
    function Skin.GuildChallengeAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Skin.FrameTypeFrame(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropOption("offsets", {
                left = 9,
                right = 10,
                top = 14,
                bottom = 15,
            })

            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            local line = select(2, ContainedAlertFrame:GetRegions())
            line:SetColorTexture(1, 1, 1, 0.5)
            line:ClearAllPoints()
            line:SetPoint("TOPLEFT", ContainedAlertFrame.EmblemBackground, "TOPRIGHT", 10, -20)
            line:SetPoint("BOTTOMRIGHT", bg, -75, 20)

            ContainedAlertFrame.EmblemBackground:SetPoint("TOPLEFT", 14, -19)
            ContainedAlertFrame.EmblemBackground:SetTexCoord(0.060546875, 0.1328125, 0.00390625, 0.14453125)
            ContainedAlertFrame.EmblemBorder:SetAllPoints(ContainedAlertFrame.EmblemBackground)
            ContainedAlertFrame.EmblemBorder:SetTexCoord(0.060546875, 0.1328125, 0.15234375, 0.29296875)

            ContainedAlertFrame.glow:SetPoint("TOPLEFT", bg, -10, 10)
            ContainedAlertFrame.glow:SetPoint("BOTTOMRIGHT", bg, 10, -10)
            ContainedAlertFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glow:SetTexCoord(0, 1, 0, 1)

            ContainedAlertFrame._auroraTemplate = "GuildChallengeAlertFrameTemplate"
        end
    end
    function Skin.ScenarioLegionInvasionAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            local toastFrame, icon, title = ContainedAlertFrame:GetRegions()
            Skin.FrameTypeFrame(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropOption("offsets", {
                left = 11,
                right = 11,
                top = 10,
                bottom = 10,
            })

            toastFrame:Hide()
            Base.CropIcon(icon, ContainedAlertFrame)

            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            title:SetPoint("TOP", bg, 0, -15)
            title:SetPoint("LEFT", icon, "RIGHT", 5, 0)
            title:SetPoint("RIGHT", bg, -5, 0)
            ContainedAlertFrame._title = title

            ContainedAlertFrame.ZoneName:ClearAllPoints()
            ContainedAlertFrame.ZoneName:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
            ContainedAlertFrame.ZoneName:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -2)

            ContainedAlertFrame._auroraTemplate = "ScenarioLegionInvasionAlertFrameTemplate"
        else
            for i, button in next, ContainedAlertFrame.RewardFrames do
                if not button._auroraSkinned then
                    Skin.InvasionAlertFrameRewardTemplate(button)
                    button._auroraSkinned = true
                end
            end

            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            if ContainedAlertFrame.BonusStar:IsShown() then
                ContainedAlertFrame._title:SetPoint("RIGHT", bg, -45, 0)
            else
                ContainedAlertFrame._title:SetPoint("RIGHT", bg, -5, 0)
            end
        end
    end
    function Skin.ScenarioAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Skin.FrameTypeFrame(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropOption("offsets", {
                left = 11,
                right = 20,
                top = 10,
                bottom = 11,
            })

            select(1, ContainedAlertFrame:GetRegions()):Hide() -- iconBG
            ContainedAlertFrame.dungeonTexture:ClearAllPoints()
            ContainedAlertFrame.dungeonTexture:SetPoint("TOPLEFT", 17, -16)
            Base.CropIcon(ContainedAlertFrame.dungeonTexture, ContainedAlertFrame)
            select(3, ContainedAlertFrame:GetRegions()):Hide() -- toastFrame

            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            local title = select(4, ContainedAlertFrame:GetRegions())
            title:SetPoint("TOP", bg, 0, -15)
            title:SetPoint("LEFT", ContainedAlertFrame.dungeonTexture, "RIGHT", 5, 0)
            title:SetPoint("RIGHT", bg, -5, 0)
            ContainedAlertFrame._title = title

            ContainedAlertFrame.dungeonName:SetPoint("TOP", title, "BOTTOM", 0, -2)
            ContainedAlertFrame.dungeonName:SetPoint("LEFT", ContainedAlertFrame.dungeonTexture, "RIGHT", 5, 0)
            ContainedAlertFrame.dungeonName:SetPoint("RIGHT", bg, -5, 0)

            ContainedAlertFrame.glowFrame.glow:SetPoint("TOPLEFT", bg, -10, 10)
            ContainedAlertFrame.glowFrame.glow:SetPoint("BOTTOMRIGHT", bg, 10, -10)
            ContainedAlertFrame.glowFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glowFrame.glow:SetTexCoord(0, 1, 0, 1)

            ContainedAlertFrame.shine:SetTexCoord(0.794921875, 0.96484375, 0.06640625, 0.23046875)

            ContainedAlertFrame._auroraTemplate = "ScenarioAlertFrameTemplate"
        else
            for i, button in next, ContainedAlertFrame.RewardFrames do
                if not button._auroraSkinned then
                    Skin.DungeonCompletionAlertFrameRewardTemplate(button)
                    button._auroraSkinned = true
                end
            end

            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            if ContainedAlertFrame.BonusStar:IsShown() then
                ContainedAlertFrame._title:SetPoint("RIGHT", bg, -45, 0)
            else
                ContainedAlertFrame._title:SetPoint("RIGHT", bg, -5, 0)
            end
        end
    end
    function Skin.MoneyWonAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Skin.FrameTypeFrame(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropBorderColor(Color.yellow)
            ContainedAlertFrame:SetBackdropOption("offsets", {
                left = 11,
                right = 11,
                top = 10,
                bottom = 11,
            })

            ContainedAlertFrame.Background:Hide()
            Base.CropIcon(ContainedAlertFrame.Icon, ContainedAlertFrame)
            ContainedAlertFrame.IconBorder:Hide()

            ContainedAlertFrame.Label:SetPoint("TOPLEFT", ContainedAlertFrame.Icon, "TOPRIGHT", 10, -2)
            ContainedAlertFrame.Amount:SetPoint("BOTTOMLEFT", ContainedAlertFrame.Icon, "BOTTOMRIGHT", 10, 2)

            ContainedAlertFrame._auroraTemplate = "MoneyWonAlertFrameTemplate"
        end
    end
    function Skin.HonorAwardedAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            -- Called when created: the main skin
            Skin.FrameTypeFrame(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropBorderColor(Color.yellow)
            ContainedAlertFrame:SetBackdropOption("offsets", {
                left = 11,
                right = 11,
                top = 10,
                bottom = 11,
            })

            ContainedAlertFrame.Background:Hide()
            Base.CropIcon(ContainedAlertFrame.Icon, ContainedAlertFrame)
            ContainedAlertFrame.IconBorder:Hide()

            ContainedAlertFrame.Label:SetPoint("TOPLEFT", ContainedAlertFrame.Icon, "TOPRIGHT", 10, -2)
            ContainedAlertFrame.Amount:SetPoint("BOTTOMLEFT", ContainedAlertFrame.Icon, "BOTTOMRIGHT", 10, 2)

            ContainedAlertFrame._auroraTemplate = "HonorAwardedAlertFrameTemplate"
        end
    end
end

function private.FrameXML.AlertFrameSystems()
    -- Simple Alerts
    Util.Mixin(_G.GuildChallengeAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.DungeonCompletionAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.ScenarioAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.InvasionAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.DigsiteCompleteAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.EntitlementDeliveredAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.RafRewardDeliveredAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.GarrisonBuildingAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.GarrisonMissionAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.GarrisonShipMissionAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.GarrisonFollowerAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.GarrisonShipFollowerAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.GarrisonTalentAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.WorldQuestCompleteAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.LegendaryItemAlertSystem.alertFramePool, Hook.ObjectPoolMixin)

    Util.Mixin(_G.NewPetAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.NewMountAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.NewToyAlertSystem.alertFramePool, Hook.ObjectPoolMixin)

    --[[
    ]]
    _G.hooksecurefunc("DungeonCompletionAlertFrameReward_SetRewardMoney", Hook.DungeonCompletionAlertFrameReward_SetRewardMoney)
    _G.hooksecurefunc("DungeonCompletionAlertFrameReward_SetRewardXP", Hook.DungeonCompletionAlertFrameReward_SetRewardXP)
    _G.hooksecurefunc("DungeonCompletionAlertFrameReward_SetRewardItem", Hook.DungeonCompletionAlertFrameReward_SetRewardItem)
    _G.hooksecurefunc("DungeonCompletionAlertFrameReward_SetReward", Hook.DungeonCompletionAlertFrameReward_SetReward)


    -- Queued Alerts
    Util.Mixin(_G.AchievementAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.CriteriaAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.LootAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.LootUpgradeAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.MoneyWonAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.HonorAwardedAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.NewRecipeLearnedAlertSystem.alertFramePool, Hook.ObjectPoolMixin)
end
