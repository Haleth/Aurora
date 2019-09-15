local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

local item = _G.Item:CreateFromItemID(30234)
item:ContinueOnItemLoad(function(...)
    local color = item:GetItemQualityColor()
    item.data = {
        id = item:GetItemID(),
        link = item:GetItemLink(),
        name = item:GetItemName(),
        color = {color.r, color.g, color.b},
        texture = item:GetItemIcon(),
        count = 1,
    }
end)

local test = {
    type = "group",
    args = {}
}

function test.init()
    do -- Alert Frames
        local achievementAlerts do
            local guild, toon = 4989, 6348
            local achievementID, isGuild, isEarned = toon, false, false
            achievementAlerts = {
                name = "Achievement Alerts",
                type = "group",
                args = {
                    isGuild = {
                        name = "Guild Achievement",
                        type = "toggle",
                        get = function() return isGuild end,
                        set = function(info, value)
                            isGuild = value
                            achievementID = isGuild and guild or toon
                        end,
                        order = 10,
                    },
                    isEarned = {
                        name = "Already Earned",
                        type = "toggle",
                        get = function() return isEarned end,
                        set = function(info, value)
                            isEarned = value
                        end,
                        order = 10,
                    },
                    achievementGet = {
                        name = "Achievement",
                        desc = "AchievementAlertSystem",
                        type = "execute",
                        func = function()
                            if not _G.AchievementFrame then _G.UIParentLoadAddOn("Blizzard_AchievementUI") end
                            _G.AchievementAlertSystem:AddAlert(achievementID, isEarned)
                        end,
                    },
                    achievementCrit = {
                        name = "Achievement Criteria",
                        desc = "CriteriaAlertSystem",
                        type = "execute",
                        func = function()
                            if not _G.AchievementFrame then _G.UIParentLoadAddOn("Blizzard_AchievementUI") end
                            local criteriaString = _G.GetAchievementCriteriaInfo(achievementID, 1)
                            _G.CriteriaAlertSystem:AddAlert(achievementID, criteriaString)
                        end,
                    },
                },
            }
        end
        local lfgAlerts do
            lfgAlerts = {
                name = "LFG Alerts",
                type = "group",
                args = {
                    scenario = {
                        name = "Scenario",
                        desc = "ScenarioAlertSystem",
                        disabled = not _G.GetLFGCompletionReward(),
                        type = "execute",
                        func = function()
                            _G.ScenarioAlertSystem:AddAlert()
                        end,
                    },
                    dungeon = {
                        name = "Dungeon",
                        desc = "DungeonCompletionAlertSystem",
                        --disabled = not _G.GetLFGCompletionReward(),
                        type = "execute",
                        func = function()
                            _G.GetLFGCompletionReward = function()
                                return "Test", nil, 2, "Dungeon", 10, 2, 10, 3, 4, 3
                            end
                            _G.DungeonCompletionAlertSystem:AddAlert()
                        end,
                    },
                    guildDungeon = {
                        name = "Guild Dungeon",
                        desc = "GuildChallengeAlertSystem",
                        type = "execute",
                        func = function()
                            _G.GuildChallengeAlertSystem:AddAlert(1, 2, 5)
                        end,
                    },
                },
            }
        end
        local lootAlerts do
            -- _G.LootAlertSystem:AddAlert(itemLink, quantity, rollType, roll, specID, isCurrency, showFactionBG, lootSource, lessAwesome, isUpgraded)
            -- _G.LootUpgradeAlertSystem:AddAlert(itemLink, quantity, specID, baseQuality)
            -- _G.MoneyWonAlertSystem:AddAlert(amount)

            local rollType, lootSpec = _G.LOOT_ROLL_TYPE_NEED, 268 --[[ Brewmaster ]]
            local currencyID = 823 -- Apexis Crystals
            local bonusPrompt, bonusDuration = 244782, 10
            local rewardType, rewardQuantity = "item", 1
            local bonusResults = {
                "item",
                "currency",
                "money",
                "artifact_power",
            }
            lootAlerts = {
                name = "Loot Alerts",
                type = "group",
                args = {
                    header1 = {
                        name = "Items",
                        type = "header",
                        order = 0,
                    },
                    lootWon = {
                        name = "Loot Roll Won",
                        desc = "LootAlertSystem",
                        type = "execute",
                        func = function()
                            _G.LootAlertSystem:AddAlert(item.data.id, 1, rollType, 98, lootSpec)
                        end,
                        order = 1,
                    },
                    lootWonUpgrade = {
                        name = "Loot Roll Won (Upgrade)",
                        desc = "LootAlertSystem",
                        type = "execute",
                        func = function()
                            _G.LootAlertSystem:AddAlert(item.data.id, 1, rollType, 98, lootSpec, nil, nil, nil, nil, true)
                        end,
                        order = 1,
                    },
                    lootGiven = {
                        name = "Loot Given",
                        desc = "LootAlertSystem",
                        type = "execute",
                        func = function()
                            _G.LootAlertSystem:AddAlert(item.data.id, 1, nil, nil, lootSpec, nil, nil, nil, true)
                        end,
                        order = 1,
                    },
                    lootUpgrade = {
                        name = "Loot Upgrade",
                        desc = "LootUpgradeAlertSystem",
                        type = "execute",
                        func = function()
                            _G.LootUpgradeAlertSystem:AddAlert(item.data.id, 1, lootSpec, 3)
                        end,
                        order = 1,
                    },
                    header2 = {
                        name = "Bonus Roll",
                        type = "header",
                        order = 2,
                    },
                    bonusResultType = {
                        name = "Result Type",
                        type = "select",
                        values = bonusResults,
                        get = function()
                            for i, resultType in _G.ipairs(bonusResults) do
                                if resultType == rewardType then
                                    return i
                                end
                            end
                        end,
                        set = function(info, value)
                            rewardType = bonusResults[value]
                            if rewardType == "item" then
                                rewardQuantity = 1
                            elseif rewardType == "money" then
                                rewardQuantity = 123456
                            elseif rewardType == "artifact_power" then
                                rewardQuantity = 123456
                            end
                        end,
                        order = 3,
                    },
                    bonusPrompt = {
                        name = "Bonus Roll Prompt",
                        desc = "LootAlertSystem",
                        type = "execute",
                        func = function()
                            _G.BonusRollFrame_StartBonusRoll(bonusPrompt, "Woah! A bonus roll!", bonusDuration, currencyID, 2)
                            _G.C_Timer.After(bonusDuration, _G.BonusRollFrame_CloseBonusRoll)
                        end,
                        order = 3,
                    },
                    bonusStart = {
                        name = "Bonus Roll Start",
                        desc = "LootAlertSystem",
                        type = "execute",
                        func = function()
                            _G.BonusRollFrame_OnEvent(_G.BonusRollFrame, "BONUS_ROLL_STARTED")
                        end,
                        order = 3,
                    },
                    bonusResult = {
                        name = "Bonus Roll Result",
                        desc = "LootAlertSystem",
                        type = "execute",
                        func = function()
                            _G.BonusRollFrame_OnEvent(_G.BonusRollFrame, "BONUS_ROLL_RESULT", rewardType, item.data.link, rewardQuantity, lootSpec)
                        end,
                        order = 3,
                    },
                    header3 = {
                        name = "Currency",
                        type = "header",
                        order = 4,
                    },
                    lootMoney = {
                        name = "Loot Money",
                        desc = "MoneyWonAlertSystem",
                        type = "execute",
                        func = function()
                            _G.MoneyWonAlertSystem:AddAlert(123456)
                        end,
                        order = 5,
                    },
                    lootCurrency = {
                        name = "Loot Currency",
                        desc = "LootAlertSystem",
                        type = "execute",
                        func = function()
                            _G.LootAlertSystem:AddAlert(currencyID, 100, nil, nil, lootSpec, true)
                        end,
                        order = 5,
                    },
                    lootGarrisonCache = {
                        name = "Loot Garrison Cache",
                        desc = "LootAlertSystem",
                        type = "execute",
                        func = function()
                            _G.LootAlertSystem:AddAlert(824, 100, nil, nil, lootSpec, true, nil, 10)
                        end,
                        order = 5,
                    },
                    header4 = {
                        name = "Misc",
                        type = "header",
                        order = 6,
                    },
                    store = {
                        name = "Store Purchase",
                        desc = "StorePurchaseAlertSystem",
                        type = "execute",
                        func = function()
                            _G.StorePurchaseAlertSystem:AddAlert(item.data.texture, item.data.name, item.data.id)
                        end,
                        order = 7,
                    },
                    legendary = {
                        name = "Legion Legendary",
                        desc = "LegendaryItemAlertSystem",
                        type = "execute",
                        func = function()
                            _G.LegendaryItemAlertSystem:AddAlert(item.data.id)
                        end,
                        order = 7,
                    },
                },
            }
        end
        local garrisonAlerts do
            local isUpgraded, talentID = false, 370 --[[ Hunter: Long Range ]]
            local function hasGarrison()
                return _G.C_Garrison.GetLandingPageGarrisonType() > 0
            end
            local function isDraenorGarrison()
                return _G.C_Garrison.GetLandingPageGarrisonType() == _G.LE_GARRISON_TYPE_6_0
            end
            garrisonAlerts = {
                name = "Garrison Alerts",
                disabled = not hasGarrison(),
                type = "group",
                args = {
                    header1 = {
                        name = "Followers",
                        type = "header",
                        order = 0,
                    },
                    isUpgraded = {
                        name = "Follower is upgraded",
                        type = "toggle",
                        get = function() return isUpgraded end,
                        set = function(info, value)
                            isUpgraded = value
                        end,
                        order = 1,
                    },
                    follower = {
                        name = "Garrison Follower",
                        desc = "GarrisonFollowerAlertSystem",
                        type = "execute",
                        func = function()
                            local follower = _G.C_Garrison.GetFollowers(_G.LE_FOLLOWER_TYPE_GARRISON_7_0)[1]
                            _G.GarrisonFollowerAlertSystem:AddAlert(follower.followerID, follower.name, follower.level, follower.quality, isUpgraded, follower)
                        end,
                        order = 1,
                    },
                    followerShip = {
                        name = "Garrison Ship Follower",
                        desc = "GarrisonShipFollowerAlertSystem",
                        disabled = not isDraenorGarrison(),
                        type = "execute",
                        func = function()
                            local follower = _G.C_Garrison.GetFollowers(_G.LE_FOLLOWER_TYPE_SHIPYARD_6_2)[1]
                            _G.GarrisonShipFollowerAlertSystem:AddAlert(follower.followerID, follower.name, follower.className, follower.texPrefix, follower.level, follower.quality, isUpgraded, follower)
                        end,
                        order = 1,
                    },
                    header2 = {
                        name = "Missions",
                        type = "header",
                        order = 2,
                    },
                    mission = {
                        name = "Garrison Mission",
                        desc = "GarrisonMissionAlertSystem",
                        type = "execute",
                        func = function()
                            local mission = _G.C_Garrison.GetAvailableMissions(_G.LE_FOLLOWER_TYPE_GARRISON_7_0)[1]
                            _G.GarrisonMissionAlertSystem:AddAlert(mission)
                        end,
                        order = 3,
                    },
                    missionRandom = {
                        name = "Garrison Random Mission",
                        desc = "GarrisonRandomMissionAlertSystem",
                        type = "execute",
                        func = function()
                            local mission = _G.C_Garrison.GetAvailableMissions(_G.LE_FOLLOWER_TYPE_GARRISON_7_0)[1]
                            _G.GarrisonRandomMissionAlertSystem:AddAlert(mission)
                        end,
                        order = 3,
                    },
                    missionShip = {
                        name = "Garrison Ship Mission",
                        desc = "GarrisonShipMissionAlertSystem",
                        disabled = not isDraenorGarrison(),
                        type = "execute",
                        func = function()
                            local mission = _G.C_Garrison.GetAvailableMissions(_G.LE_FOLLOWER_TYPE_SHIPYARD_6_2)[1]
                            _G.GarrisonShipMissionAlertSystem:AddAlert(mission.missionID)
                        end,
                        order = 3,
                    },
                    header3 = {
                        name = "Misc",
                        type = "header",
                        order = 4,
                    },
                    building = {
                        name = "Garrison Building",
                        desc = "GarrisonBuildingAlertSystem",
                        type = "execute",
                        func = function()
                            _G.GarrisonBuildingAlertSystem:AddAlert("Barn")
                        end,
                        order = 5,
                    },
                    talent = {
                        name = "Garrison Talent",
                        desc = "GarrisonTalentAlertSystem",
                        type = "execute",
                        func = function()
                            _G.GarrisonTalentAlertSystem:AddAlert(_G.LE_GARRISON_TYPE_7_0, _G.C_Garrison.GetTalent(talentID))
                        end,
                        order = 5,
                    },
                },
            }
        end
        local bnetAlerts do
            local toastType, toastInfo = 1
            local toastTypes = {
                "online",
                "offline",
                "broadcast",
                "pending",
                "new",
            }
            bnetAlerts = {
                name = "Battle.net Alerts",
                type = "group",
                args = {
                    toastType = {
                        name = "Result Type",
                        type = "select",
                        values = toastTypes,
                        get = function() return toastType end,
                        set = function(info, value)
                            toastType = value
                            local _, online = _G.BNGetNumFriends()
                            if toastTypes[toastType] == "online" then
                                toastInfo = _G.BNGetFriendInfo(online + 1)
                            elseif toastTypes[toastType] == "offline" then
                                toastInfo = _G.BNGetFriendInfo(online + 1)
                            elseif toastTypes[toastType] == "broadcast" then
                                toastInfo = _G.BNGetFriendInfo(online + 1)
                            elseif toastTypes[toastType] == "pending" then
                                toastInfo = 4
                            elseif toastTypes[toastType] == "new" then
                                toastInfo = nil
                            end
                        end,
                        order = 3,
                    },
                    toast = {
                        name = "Battle.net Toast",
                        desc = "BNToastFrame_Show",
                        type = "execute",
                        func = function()
                            _G.BNToastFrame_AddToast(toastType, toastInfo)
                        end,
                    },
                },
            }
        end
        local miscAlerts do
            local recipeID, questID, archRace = 42141 --[[]], 42114 --[[]], 1 --[[ Dwarf ]]
            miscAlerts = {
                name = "Misc Alerts",
                type = "group",
                args = {
                    digsite = {
                        name = "Digsite Complete",
                        desc = "DigsiteCompleteAlertSystem",
                        type = "execute",
                        func = function()
                            _G.DigsiteCompleteAlertSystem:AddAlert(archRace)
                        end,
                    },
                    newRecipe = {
                        name = "New Recipe Learned",
                        desc = "NewRecipeLearnedAlertSystem",
                        type = "execute",
                        func = function()
                            _G.NewRecipeLearnedAlertSystem:AddAlert(recipeID)
                        end,
                    },
                    worldQuest = {
                        name = "World Quest Complete",
                        desc = "WorldQuestCompleteAlertSystem",
                        type = "execute",
                        func = function()
                            _G.WorldQuestCompleteAlertSystem:AddAlert(questID)
                        end,
                    },
                },
            }
        end

        test.args.alert = {
            name = "Alert Frames",
            type = "group",
            args = {
                achievementAlerts = achievementAlerts,
                lfgAlerts = lfgAlerts,
                lootAlerts = lootAlerts,
                garrisonAlerts = garrisonAlerts,
                bnetAlerts = bnetAlerts,
                miscAlerts = miscAlerts,
            }
        }
    end

    do -- Popup Frames
        local staticPopups do
            local addedFrameType, addedFrame = {
                "none",
                "hasEditBox",
                "hasMoneyFrame",
                "hasMoneyInputFrame",
                "hasItemFrame",
            }, 1

            _G.StaticPopupDialogs.TESTPOPUP1 = {
                text = "This is the main popup text",
                button1 = _G.YES,
                button2 = _G.NO,
                timeout = 0,
                closeButton = true,
                hideOnEscape = true,
                OnShow = function(self)
                    if addedFrame == 3 then
                        _G.MoneyFrame_Update(self.moneyFrame, 123456)
                    end
                end,
            }

            staticPopups = {
                name = "Static Popups",
                type = "group",
                args = {
                    closeButtonIsHide = {
                        name = "closeButtonIsHide",
                        type = "toggle",
                        get = function() return _G.StaticPopupDialogs.TESTPOPUP1.closeButtonIsHide end,
                        set = function(info, value)
                            _G.StaticPopupDialogs.TESTPOPUP1.closeButtonIsHide = value
                        end,
                        order = 1,
                    },
                    addedFrame = {
                        name = "addedFrame",
                        type = "select",
                        values = addedFrameType,
                        get = function()
                            return addedFrame
                        end,
                        set = function(info, value)
                            addedFrame = value
                            local popup = _G.StaticPopupDialogs.TESTPOPUP1

                            -- Blzz assumes these are mutually exclusive, so we put them on the same option
                            for i, option in next, addedFrameType do
                                if option ~= "none" then
                                    popup[option] = i == value
                                end
                            end
                        end,
                        order = 1,
                    },
                    subText = {
                        name = "subText",
                        type = "toggle",
                        get = function() return _G.StaticPopupDialogs.TESTPOPUP1.subText end,
                        set = function(info, value)
                            _G.StaticPopupDialogs.TESTPOPUP1.subText = value and "Here is some subText"
                        end,
                        order = 1,
                    },
                    staticPopup = {
                        name = "staticPopup",
                        desc = "LFGDungeonReadyDialog",
                        type = "execute",
                        func = function()
                            _G.StaticPopup_Show("TESTPOPUP1", "Text Arg1", "Text Arg2", item.data)
                        end,
                    },
                },
            }
        end

        test.args.popup = {
            name = "Popup Frames",
            type = "group",
            args = {
                staticPopups = staticPopups,
            }
        }
    end

    do -- Misc
        function _G.GetMaxBattlefieldID()
            return 1
        end
        function _G.GetBattlefieldStatus(id)
            return "active"
        end

        local misc do
            misc = {
                name = "Misc. Frames",
                type = "group",
                args = {
                    itemTextStatusBar = {
                        name = "TextFrame loading bar",
                        desc = "ItemTextStatusBar",
                        type = "execute",
                        func = function()
                            _G.ItemTextFrame_OnEvent(_G.ItemTextFrame, "ITEM_TEXT_TRANSLATION", 5)
                        end,
                    },
                    worldState = {
                        name = "PvP score frame",
                        desc = "WorldStateScoreFrame",
                        type = "execute",
                        func = function()
                            _G.ToggleWorldStateScoreFrame()
                        end,
                    },
                    timer = {
                        name = "PvP Start Timer",
                        desc = "StartTimerBar",
                        type = "execute",
                        func = function()
                            _G.TimerTracker_OnEvent(_G.TimerTracker, "START_TIMER", 1, 80, 80)
                        end,
                    },
                },
            }
        end

        test.args.misc = misc
    end

    test.init = nil
end

private.test = test
