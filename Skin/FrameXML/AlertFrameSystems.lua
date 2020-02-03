local _, private = ...
if private.isClassic then return end

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
            Base.SetBackdrop(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", ContainedAlertFrame.icon, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", 0, 0)
            ContainedAlertFrame._auroraBG = bg

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
            Base.SetBackdrop(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", ContainedAlertFrame.dungeonTexture, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", -8, 8)
            ContainedAlertFrame._auroraBG = bg

            Base.CropIcon(ContainedAlertFrame.dungeonTexture, ContainedAlertFrame)
            ContainedAlertFrame.raidArt:SetAlpha(0)
            ContainedAlertFrame.dungeonArt1:SetAlpha(0)
            ContainedAlertFrame.dungeonArt2:SetAlpha(0)
            ContainedAlertFrame.dungeonArt3:SetAlpha(0)
            ContainedAlertFrame.dungeonArt4:SetAlpha(0)

            local title = select(7, ContainedAlertFrame:GetRegions())
            title:SetPoint("LEFT", ContainedAlertFrame.dungeonTexture, "RIGHT", 5, 0)
            title:SetPoint("RIGHT", bg, -5, 0)
            ContainedAlertFrame.instanceName:SetPoint("LEFT", ContainedAlertFrame.dungeonTexture, "RIGHT", 5, 0)
            ContainedAlertFrame.instanceName:SetPoint("RIGHT", bg, -5, 0)
            ContainedAlertFrame.heroicIcon:SetAlpha(0)

            ContainedAlertFrame.glowFrame.glow:SetPoint("TOPLEFT", ContainedAlertFrame._auroraBG, -10, 10)
            ContainedAlertFrame.glowFrame.glow:SetPoint("BOTTOMRIGHT", ContainedAlertFrame._auroraBG, 10, -10)
            ContainedAlertFrame.glowFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glowFrame.glow:SetTexCoord(0, 1, 0, 1)

            ContainedAlertFrame._auroraTemplate = "DungeonCompletionAlertFrameTemplate"
        else
            local rewardData = ContainedAlertFrame.rewardData
            if rewardData.subtypeID == _G.LFG_SUBTYPEID_RAID then
                ContainedAlertFrame._auroraBG:SetPoint("BOTTOMRIGHT", -21, 13)
            else
                ContainedAlertFrame._auroraBG:SetPoint("BOTTOMRIGHT", -8, 8)
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
            Base.SetBackdrop(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", ContainedAlertFrame.Icon.Texture, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", -7, 15)
            ContainedAlertFrame._auroraBG = bg

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
                ContainedAlertFrame._auroraBG:SetPoint("TOPLEFT", 6, -29)
                ContainedAlertFrame._auroraGuildBG:Show()

                ContainedAlertFrame.Icon:SetPoint("TOPLEFT", -26, 0)
                ContainedAlertFrame.shine:SetTexCoord(0.75195313, 0.91601563, 0.25, 0.3359375)
            else
                ContainedAlertFrame._auroraBG:SetPoint("TOPLEFT", 6, -13)
                ContainedAlertFrame._auroraGuildBG:Hide()

                ContainedAlertFrame.shine:SetTexCoord(0.78125, 0.912109375, 0.06640625, 0.23046875)
                ContainedAlertFrame.shine:SetPoint("BOTTOMLEFT", 0, 16)

                if ContainedAlertFrame.oldCheevo then
                    ContainedAlertFrame.Unlocked:SetPoint("RIGHT", ContainedAlertFrame._auroraBG, -5, 0)
                    ContainedAlertFrame.Name:SetPoint("LEFT", ContainedAlertFrame.Icon.Texture, "RIGHT", 5, 0)
                    ContainedAlertFrame.Name:SetPoint("RIGHT", ContainedAlertFrame._auroraBG, -5, 0)
                end
            end
        end
    end
    function Skin.CriteriaAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Base.SetBackdrop(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", ContainedAlertFrame.Icon.Texture, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", 16, 4)
            ContainedAlertFrame._auroraBG = bg

            ContainedAlertFrame.Background:Hide()
            ContainedAlertFrame.Unlocked:SetPoint("TOP", bg, 0, -13)
            ContainedAlertFrame.Unlocked:SetPoint("LEFT", ContainedAlertFrame.Icon.Texture, "RIGHT", 5, 0)
            ContainedAlertFrame.Unlocked:SetPoint("RIGHT", bg, -5, 0)
            ContainedAlertFrame.Unlocked:SetTextColor(1, 1, 1)

            ContainedAlertFrame.Name:SetPoint("TOP", ContainedAlertFrame.Unlocked, "BOTTOM", 0, -2)
            ContainedAlertFrame.Name:SetPoint("LEFT", ContainedAlertFrame.Icon.Texture, "RIGHT", 5, 0)
            ContainedAlertFrame.Name:SetPoint("RIGHT", bg, -5, 0)

            ContainedAlertFrame.glow:SetPoint("TOPLEFT", bg, -10, 10)
            ContainedAlertFrame.glow:SetPoint("BOTTOMRIGHT", bg, 10, -10)
            ContainedAlertFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glow:SetTexCoord(0, 1, 0, 1)
            ContainedAlertFrame.shine:SetTexCoord(0.78125, 0.912109375, 0.06640625, 0.23046875)
            ContainedAlertFrame.shine:SetPoint("TOPLEFT", 18, 2)
            ContainedAlertFrame.shine:SetHeight(50)

            Base.CropIcon(ContainedAlertFrame.Icon.Texture, ContainedAlertFrame)
            ContainedAlertFrame.Icon.Texture:SetSize(40, 40)
            ContainedAlertFrame.Icon.Overlay:Hide()
            ContainedAlertFrame._auroraTemplate = "CriteriaAlertFrameTemplate"
        end
    end
    function Skin.GuildChallengeAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Base.SetBackdrop(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", ContainedAlertFrame.EmblemBackground, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", -10, 15)
            ContainedAlertFrame._auroraBG = bg

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
            Base.SetBackdrop(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", icon, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", -8, 10)
            ContainedAlertFrame._auroraBG = bg

            toastFrame:Hide()
            Base.CropIcon(icon, ContainedAlertFrame)

            title:SetPoint("TOP", bg, 0, -15)
            title:SetPoint("LEFT", icon, "RIGHT", 5, 0)
            title:SetPoint("RIGHT", bg, -5, 0)
            ContainedAlertFrame.ZoneName:ClearAllPoints()
            ContainedAlertFrame.ZoneName:SetPoint("TOP", title, "BOTTOM", 0, -2)
            ContainedAlertFrame.ZoneName:SetPoint("LEFT", icon, "RIGHT", 5, 0)
            ContainedAlertFrame.ZoneName:SetPoint("RIGHT", bg, -5, 0)

            ContainedAlertFrame._auroraTemplate = "ScenarioLegionInvasionAlertFrameTemplate"
        else
            for i, button in next, ContainedAlertFrame.RewardFrames do
                if not button._auroraSkinned then
                    Skin.InvasionAlertFrameRewardTemplate(button)
                    button._auroraSkinned = true
                end
            end
        end
    end
    function Skin.ScenarioAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            Base.SetBackdrop(ContainedAlertFrame)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", ContainedAlertFrame.dungeonTexture, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", -8, 12)
            ContainedAlertFrame._auroraBG = bg

            select(1, ContainedAlertFrame:GetRegions()):Hide() -- iconBG
            Base.CropIcon(ContainedAlertFrame.dungeonTexture, ContainedAlertFrame)
            select(3, ContainedAlertFrame:GetRegions()):Hide() -- toastFrame

            local title = select(4, ContainedAlertFrame:GetRegions())
            title:SetPoint("TOP", bg, 0, -15)
            title:SetPoint("LEFT", ContainedAlertFrame.dungeonTexture, "RIGHT", 5, 0)
            title:SetPoint("RIGHT", bg, -5, 0)
            ContainedAlertFrame.dungeonName:SetPoint("TOP", title, "BOTTOM", 0, -2)
            ContainedAlertFrame.dungeonName:SetPoint("LEFT", ContainedAlertFrame.dungeonTexture, "RIGHT", 5, 0)
            ContainedAlertFrame.dungeonName:SetPoint("RIGHT", bg, -5, 0)

            ContainedAlertFrame.glowFrame.glow:SetPoint("TOPLEFT", ContainedAlertFrame._auroraBG, -10, 10)
            ContainedAlertFrame.glowFrame.glow:SetPoint("BOTTOMRIGHT", ContainedAlertFrame._auroraBG, 10, -10)
            ContainedAlertFrame.glowFrame.glow:SetAtlas("Toast-Flash")
            ContainedAlertFrame.glowFrame.glow:SetTexCoord(0, 1, 0, 1)

            ContainedAlertFrame._auroraTemplate = "ScenarioAlertFrameTemplate"
        else
            for i, button in next, ContainedAlertFrame.RewardFrames do
                if not button._auroraSkinned then
                    Skin.DungeonCompletionAlertFrameRewardTemplate(button)
                    button._auroraSkinned = true
                end
            end
        end
    end
    function Skin.MoneyWonAlertFrameTemplate(ContainedAlertFrame)
        if not ContainedAlertFrame._auroraTemplate then
            -- Called when created: the main skin
            Base.SetBackdrop(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropBorderColor(Color.yellow)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", ContainedAlertFrame.Icon, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", -10, 12)
            ContainedAlertFrame._auroraBG = bg

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
            Base.SetBackdrop(ContainedAlertFrame)
            ContainedAlertFrame:SetBackdropBorderColor(Color.yellow)
            local bg = ContainedAlertFrame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", ContainedAlertFrame.Icon, -5, 5)
            bg:SetPoint("BOTTOMRIGHT", -10, 12)
            ContainedAlertFrame._auroraBG = bg

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
