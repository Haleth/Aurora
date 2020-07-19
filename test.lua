local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next table unpack random

if private.Aurora then
    private.isDev = true
end

local commands = private.commands
local function CopyTable(oldTable)
    local newTable = {}
    for k, v in next, oldTable do
        newTable[k] = v
    end
    return newTable
end
local function GetItem(itemID, isCurrency)
    local data
    if isCurrency then
        data = {
            id = itemID,
            isCurrency = true,
        }
    else
        local item = _G.Item:CreateFromItemID(itemID)
        item:ContinueOnItemLoad(function(...)
            local itemName, itemLink, itemRarity, _, _, _, _, itemStackCount, _, itemIcon, _, itemClassID = _G.GetItemInfo(itemID)
            data = {
                id = itemID,
                link = itemLink,
                name = itemName,
                texture = itemIcon,
                quality = itemRarity,
                isQuestItem = itemClassID == _G.LE_ITEM_CLASS_QUESTITEM,
                locked = false,
                count = random(1, itemStackCount),
            }
            data.isQuestActive = data.isQuestItem and (itemID % 2) == 1
        end)
    end

    return data
end

local function GetBoolen()
    return random(1, 10) > 5
end

local testItem = GetItem(14551)
local test, container
function commands.test()
    local Aurora = _G.Aurora
    local Base = Aurora.Base
    local Skin = Aurora.Skin
    local Color = Aurora.Color

    Aurora.isDev = true

    local AceConfig = _G.LibStub("AceConfig-3.0", true)
    if AceConfig then
        if not test then
            container = _G.LibStub("AceGUI-3.0"):Create("Frame")
            local optionsFrame = container.frame
            test = {
                type = "group",
                args = {}
            }

            do -- Alert Frames
                test.args.alert = {
                    name = "Alert Frames",
                    type = "group",
                    args = {
                    }
                }
                local alertArgs = test.args.alert.args

                if private.isRetail then -- achievementAlerts
                    local guild, toon = 4989, 6348
                    local achievementID, isGuild, isEarned = toon, false, false
                    alertArgs.achievementAlerts = {
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
                if private.isRetail then -- lfgAlerts
                    alertArgs.lfgAlerts = {
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
                do -- lootAlerts
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
                    alertArgs.lootAlerts = {
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
                                    _G.LootAlertSystem:AddAlert(testItem.id, 1, rollType, 98, lootSpec)
                                end,
                                order = 1,
                            },
                            lootWonUpgrade = {
                                name = "Loot Roll Won (Upgrade)",
                                desc = "LootAlertSystem",
                                type = "execute",
                                func = function()
                                    _G.LootAlertSystem:AddAlert(testItem.id, 1, rollType, 98, lootSpec, nil, nil, nil, nil, true)
                                end,
                                order = 1,
                            },
                            lootGiven = {
                                name = "Loot Given",
                                desc = "LootAlertSystem",
                                type = "execute",
                                func = function()
                                    _G.LootAlertSystem:AddAlert(testItem.id, 1, nil, nil, lootSpec, nil, nil, nil, true)
                                end,
                                order = 1,
                            },
                            lootUpgrade = {
                                name = "Loot Upgrade",
                                desc = "LootUpgradeAlertSystem",
                                type = "execute",
                                func = function()
                                    _G.LootUpgradeAlertSystem:AddAlert(testItem.id, 1, lootSpec, 3)
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
                                    _G.BonusRollFrame_OnEvent(_G.BonusRollFrame, "BONUS_ROLL_RESULT", rewardType, testItem.link, rewardQuantity, lootSpec)
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
                                    _G.StorePurchaseAlertSystem:AddAlert(testItem.texture, testItem.name, testItem.id)
                                end,
                                order = 7,
                            },
                            legendary = {
                                name = "Legion Legendary",
                                desc = "LegendaryItemAlertSystem",
                                type = "execute",
                                func = function()
                                    _G.LegendaryItemAlertSystem:AddAlert(testItem.id)
                                end,
                                order = 7,
                            },
                        },
                    }
                end
                if private.isRetail then -- garrisonAlerts
                    local isUpgraded, talentID = false, 370 --[[ Hunter: Long Range ]]
                    local function hasGarrison()
                        return _G.C_Garrison.GetLandingPageGarrisonType() > 0
                    end
                    local function isDraenorGarrison()
                        return _G.C_Garrison.GetLandingPageGarrisonType() == _G.LE_GARRISON_TYPE_6_0
                    end
                    alertArgs.garrisonAlerts = {
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
                do -- bnetAlerts
                    local toastType, toastInfo = 1
                    local toastTypes = {
                        "online",
                        "offline",
                        "broadcast",
                        "pending",
                        "new",
                    }
                    alertArgs.bnetAlerts = {
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
                do -- miscAlerts
                    local recipeID, questID, archRace = 42141 --[[]], 42114 --[[]], 1 --[[ Dwarf ]]
                    alertArgs.miscAlerts = {
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
            end

            do -- Popup Frames
                test.args.popup = {
                    name = "Popup Frames",
                    type = "group",
                    args = {
                    }
                }
                local popupArgs = test.args.popup.args

                if private.isRetail then -- helpTips
                    local buttonStyleType do
                        buttonStyleType = {}
                        for name, index in next, _G.HelpTip.ButtonStyle do
                            buttonStyleType[index] = name
                        end
                    end
                    local targetPointType do
                        targetPointType = {}
                        for name, index in next, _G.HelpTip.Point do
                            targetPointType[index] = name
                        end
                    end
                    local alignmentType do
                        alignmentType = {}
                        for name, index in next, _G.HelpTip.Alignment do
                            alignmentType[index] = name
                        end
                    end

                    local textFormat = "%s-%s-%s"
                    local infoTable = {
                        text = "text",                                   -- also acts as a key for various API, MUST BE SET
                        textColor = _G.HIGHLIGHT_FONT_COLOR,
                        textJustifyH = "LEFT",
                        buttonStyle = _G.HelpTip.ButtonStyle.None,  -- button to close the helptip, or no button at all
                        targetPoint = _G.HelpTip.Point.TopEdgeCenter,   -- where at the parent the helptip should point
                        alignment = _G.HelpTip.Alignment.Center,   -- alignment of the helptip relative to the parent (basically where the arrow is located)
                        hideArrow = false,                      -- whether to hide the arrow
                        offsetX = 0,
                        offsetY = 0,
                    }
                    popupArgs.helpTips = {
                        name = "Help Tips",
                        type = "group",
                        args = {
                            buttonStyle = {
                                name = "buttonStyle",
                                type = "select",
                                values = buttonStyleType,
                                get = function()
                                    return infoTable.buttonStyle
                                end,
                                set = function(info, value)
                                    infoTable.buttonStyle = value
                                end,
                                order = 1,
                            },
                            targetPoint = {
                                name = "targetPoint",
                                type = "select",
                                values = targetPointType,
                                get = function()
                                    return infoTable.targetPoint
                                end,
                                set = function(info, value)
                                    infoTable.targetPoint = value
                                end,
                                order = 1,
                            },
                            alignment = {
                                name = "alignment",
                                type = "select",
                                values = alignmentType,
                                get = function()
                                    return infoTable.alignment
                                end,
                                set = function(info, value)
                                    infoTable.alignment = value
                                end,
                                order = 1,
                            },
                            helpTip = {
                                name = "helpTip",
                                desc = "HelpTip:Show()",
                                type = "execute",
                                func = function(self, ...)
                                    local text = textFormat:format(targetPointType[infoTable.targetPoint], alignmentType[infoTable.alignment], buttonStyleType[infoTable.buttonStyle])
                                    if not _G.HelpTip:IsShowing(optionsFrame, text) then
                                        local info = CopyTable(infoTable)
                                        info.text = text
                                        _G.HelpTip:Show(optionsFrame, info)
                                    end
                                end,
                            }
                        }
                    }
                end
                do -- staticPopups
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

                    popupArgs.staticPopups = {
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
                                    _G.StaticPopup_Show("TESTPOPUP1", "Text Arg1", "Text Arg2", testItem)
                                end,
                            },
                        },
                    }
                end
                if private.isRetail then -- lfgPopups
                    local dungeonId, hasResponded, totalEncounters, completedEncounters, numMembers = 1778, true, 4, 2, 5
                    local name = "Some Dungeon"

                    local typeIDs, typeID = {
                        "TYPEID_DUNGEON",
                        "TYPEID_RANDOM_DUNGEON",
                    }, 1

                    local subTypeIDs, subTypeID = {
                        "LFG_SUBTYPEID_DUNGEON",
                        "LFG_SUBTYPEID_HEROIC",
                        "LFG_SUBTYPEID_RAID",
                        "LFG_SUBTYPEID_SCENARIO",
                        "LFG_SUBTYPEID_FLEXRAID",
                        "LFG_SUBTYPEID_WORLDPVP",
                    }, 1

                    function _G.GetLFGDungeonRewards()
                        return false, 123, typeID, 456, name, 1
                    end
                    function _G.GetLFGProposalEncounter(index)
                        return "Boss "..index, nil, (index % 2) == 0
                    end
                    local members = {
                        {role = "TANK", responded = true, accepted = false},
                        {role = "HEALER", responded = true, accepted = true},
                        {role = "DAMAGER", responded = false, accepted = false},
                        {role = "DAMAGER", responded = false, accepted = true},
                        {role = "DAMAGER", responded = true, accepted = true},
                    }
                    function _G.GetLFGProposalMember(index)
                        local member = members[index]
                        return false, member.role, 1, member.responded, member.accepted, "Name"
                    end

                    local LfgSearchResultData = {
                        searchResultID = dungeonId,
                        activityID = dungeonId,
                        leaderName = "leaderName",
                        name = name,
                        comment = "comment",
                        voiceChat = "voiceChat",
                        requiredItemLevel = 123,
                        requiredHonorLevel = 456,
                        numMembers = numMembers,
                        numBNetFriends = 2,
                        numCharFriends = 1,
                        numGuildMates = 3,
                        isDelisted = false,
                        autoAccept = true,
                        age = 0,
                        questID = 65143,
                    }
                    function _G.C_LFGList.GetSearchResultInfo(searchResultID)
                        local info = CopyTable(LfgSearchResultData)
                        return info
                    end
                    function _G.C_LFGList.GetApplicationInfo(searchResultID)
                        return dungeonId, "invited", nil, nil, "TANK"
                    end

                    popupArgs.lfgPopups = {
                        name = "Group Finder Popups",
                        type = "group",
                        args = {
                            header1 = {
                                name = "LFG",
                                type = "header",
                                order = 0,
                            },
                            typeID = {
                                name = "typeID",
                                type = "select",
                                values = typeIDs,
                                get = function()
                                    return typeID
                                end,
                                set = function(info, value)
                                    typeID = value
                                end,
                                order = 1,
                            },
                            subTypeID = {
                                name = "subTypeID",
                                type = "select",
                                values = subTypeIDs,
                                get = function()
                                    return subTypeID
                                end,
                                set = function(info, value)
                                    subTypeID = value
                                end,
                                order = 1,
                            },
                            proposal = {
                                name = "LFG Proposal",
                                desc = "LFGDungeonReadyDialog",
                                type = "execute",
                                func = function()
                                    hasResponded = false
                                    function _G.GetLFGProposal()
                                        return true, dungeonId, _G[typeIDs[typeID]], subTypeID, name, "Interface\\LFGFrame\\UI-LFG-BACKGROUND-TolDagor", "DAMAGER", hasResponded, totalEncounters, completedEncounters, numMembers, true, false, nil, false
                                    end
                                    if _G.LFGDungeonReadyPopup:IsShown() then
                                        _G.LFGEventFrame_OnEvent(_G.LFGDungeonReadyPopup, "LFG_PROPOSAL_UPDATE")
                                    else
                                        _G.LFGEventFrame_OnEvent(_G.LFGDungeonReadyPopup, "LFG_PROPOSAL_SHOW")
                                    end
                                end,
                                order = 2,
                            },
                            lfgReadyCheck = {
                                name = "LFG Ready Check",
                                desc = "LFGDungeonReadyStatus",
                                type = "execute",
                                func = function()
                                    hasResponded = true
                                    function _G.GetLFGProposal()
                                        return true, dungeonId, typeID, subTypeID, name, "Interface\\LFGFrame\\UI-LFG-BACKGROUND-TolDagor", "DAMAGER", hasResponded, totalEncounters, completedEncounters, numMembers, true, false, nil, false
                                    end
                                    if _G.LFGDungeonReadyPopup:IsShown() then
                                        _G.LFGEventFrame_OnEvent(_G.LFGDungeonReadyPopup, "LFG_PROPOSAL_UPDATE")
                                    else
                                        _G.LFGEventFrame_OnEvent(_G.LFGDungeonReadyPopup, "LFG_PROPOSAL_SHOW")
                                    end
                                end,
                                order = 2,
                            },
                            invite = {
                                name = "LFG Invite",
                                desc = "LFGInvitePopup",
                                type = "execute",
                                func = function()
                                    _G.LFGInvitePopup.timeOut = 1000000
                                    _G.StaticPopupSpecial_Show(_G.LFGInvitePopup)
                                end,
                                order = 3,
                            },
                            listApp = {
                                name = "LFG List Application",
                                desc = "LFGListApplicationDialog",
                                type = "execute",
                                func = function()
                                    _G.LFGListApplicationDialog.timeOut = 1000000
                                    _G.LFGListApplicationDialog_Show(_G.LFGListApplicationDialog, dungeonId)
                                end,
                                order = 3,
                            },
                            listInvite = {
                                name = "LFG List Invite",
                                desc = "LFGListInviteDialog",
                                type = "execute",
                                func = function()
                                    _G.LFGListInviteDialog.timeOut = 1000000
                                    _G.LFGListInviteDialog_Show(_G.LFGListInviteDialog, dungeonId)
                                end,
                                order = 3,
                            },
                            header2 = {
                                name = "LFD",
                                type = "header",
                                order = 4,
                            },
                            lfdRollCheck = {
                                name = "LFD Roll Check",
                                desc = "LFDRoleCheckPopup",
                                type = "execute",
                                func = function()
                                    _G.LFDFrame_OnEvent(_G.LFDParentFrame, "LFG_ROLE_CHECK_SHOW")
                                end,
                                order = 4,
                            },
                            lfdReadyCheck = {
                                name = "LFD Ready Check",
                                desc = "LFDReadyCheckPopup",
                                type = "execute",
                                func = function()
                                    _G.LFDFrame_OnEvent(_G.LFDParentFrame, "LFG_READY_CHECK_SHOW")
                                end,
                                order = 4,
                            },
                        },
                    }
                end
                do -- helpPopups
                    local ticketStatuses, ticketStatus = {
                        "LE_TICKET_STATUS_OPEN",
                        "LE_TICKET_STATUS_SURVEY",
                        "LE_TICKET_STATUS_NMI",
                        "LE_TICKET_STATUS_RESPONSE",
                    }, 1

                    local hasTicket = true
                    local event = "UPDATE_WEB_TICKET"

                    popupArgs.helpPopups = {
                        name = "Help & Report Popups",
                        type = "group",
                        args = {
                            header1 = {
                                name = "Help",
                                type = "header",
                                order = 0,
                            },
                            ticketStatus = {
                                name = "ticketStatus",
                                type = "select",
                                values = ticketStatuses,
                                get = function()
                                    return ticketStatus
                                end,
                                set = function(info, value)
                                    ticketStatus = value
                                end,
                                order = 1,
                            },
                            ticket = {
                                name = "Ticket Status",
                                desc = "TicketStatusFrame",
                                type = "execute",
                                func = function()
                                    _G.TicketStatusFrame:Show()
                                    _G.TicketStatusFrame_OnEvent(_G.TicketStatusFrame, event, hasTicket, 1, ticketStatus, 1)
                                end,
                                order = 1,
                            },
                            header2 = {
                                name = "Report",
                                type = "header",
                                order = 10,
                            },
                            proposal = {
                                name = "Report Cheating",
                                desc = "ReportCheatingDialog",
                                type = "execute",
                                func = function()
                                    --_G.HelpFrame_ShowReportCheatingDialog(playerLocation)
                                    local frame = _G.ReportCheatingDialog
                                    frame.CommentFrame.EditBox:SetText("")
                                    frame.CommentFrame.EditBox.InformationText:Show()
                                    _G.StaticPopupSpecial_Show(frame)
                                end,
                                order = 11,
                            },
                        },
                    }
                end
            end

            do -- Battle.net
                local isConnected = true
                function _G.BNConnected()
                    return isConnected
                end
                local featuresEnabled = true
                function _G.BNFeaturesEnabled()
                    return featuresEnabled
                end

                test.args.bnet = {
                    name = "Battle.net",
                    type = "group",
                    args = {
                        isConnected = {
                            name = "isConnected",
                            desc = "BNConnected",
                            type = "toggle",
                            get = function() return isConnected end,
                            set = function(info, value)
                                isConnected = value
                                _G.FriendsFrame_CheckBattlenetStatus()
                            end,
                            order = 1,
                        },
                        featuresEnabled = {
                            name = "featuresEnabled",
                            desc = "BNFeaturesEnabled",
                            type = "toggle",
                            get = function() return featuresEnabled end,
                            set = function(info, value)
                                featuresEnabled = value
                                _G.FriendsFrame_CheckBattlenetStatus()
                            end,
                            order = 1,
                        },
                    }
                }
            end

            do -- Loot
                local numLootItems = 1
                function _G.GetNumLootItems()
                    return numLootItems
                end

                local lootInfo = {
                    -- lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive
                    GetItem(24282),
                    GetItem(13422),
                    GetItem(16252),
                    GetItem(11815),
                    GetItem(14551),
                    GetItem(17771),

                    GetItem(18492),
                    GetItem(22727),

                    GetItem(401, true),
                    GetItem(1534, true),
                }
                function _G.GetLootSlotInfo(slot)
                    local item = lootInfo[slot]
                    return item.texture, item.name, item.count, item.currencyID, item.quality, item.locked, item.isQuestItem, item.questId, item.isActive
                end
                function _G.GetLootSlotType(slot)
                    return lootInfo[slot].currencyID and _G.LOOT_SLOT_CURRENCY or _G.LOOT_SLOT_ITEM
                end
                function _G.LootSlotHasItem(slot)
                    return not not lootInfo[slot]
                end
                function _G.RollOnLoot(rollID, buttonID)
                    if buttonID == 0 then
                        local frame
                        for idx, frm in next, _G.GroupLootContainer.rollFrames do
                            if rollID == frm.rollID then
                                frame = frm
                                break
                            end
                        end

                        _G.GroupLootContainer_RemoveFrame(_G.GroupLootContainer, frame)
                    end
                end
                function _G.GetLootRollItemInfo(rollID)
                    local canNeed, canGreed, canDisenchant = GetBoolen(), GetBoolen(), GetBoolen()

                    local reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired
                    if not canNeed then
                        reasonNeed = 5
                    end
                    if not canGreed then
                        reasonGreed = 2
                    end
                    if not canDisenchant then
                        deSkillRequired = 100
                        reasonDisenchant = 4
                    end

                    local info = lootInfo[rollID]                           -- bindOnPickUp
                    return info.texture, info.item, info.quantity, info.quality, false, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired
                end

                test.args.loot = {
                    name = "Loot",
                    type = "group",
                    args = {
                        numLootItems = {
                            name = "numLootItems",
                            desc = "GetNumLootItems",
                            type = "range",
                            min = 1, max = #lootInfo, step = 1,
                            get = function() return numLootItems end,
                            set = function(info, value)
                                numLootItems = value
                                if _G.LootFrame:IsShown() then
                                    _G.LootFrame_Show(_G.LootFrame)
                                end
                            end,
                            order = 1,
                        },
                        show = {
                            name = "Show Loot",
                            desc = "LootFrame_Show",
                            type = "execute",
                            func = function(info, value)
                                _G.LootFrame.page = 1
                                _G.LootFrame_Show(_G.LootFrame)
                            end,
                            order = 1,
                        },
                        roll = {
                            name = "Roll Loot",
                            desc = "GroupLootFrame_OpenNewFrame",
                            type = "execute",
                            func = function(info, value)
                                _G.GroupLootFrame_OpenNewFrame(random(1, #lootInfo), 20)
                            end,
                            order = 1,
                        },
                    }
                }
            end

            do -- Skins
                local bdOptions = {
                    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                    tile = true,
                    tileSize = 16,
                    insets = {
                        left = 4,
                        right = 4,
                        top = 4,
                        bottom = 4
                    },
                    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                    tileEdge = true,
                    edgeSize = 16,

                    backdropColor = Color.green,
                    backdropBorderColor = Color.red,
                }

                local blizzBDFrame = _G.CreateFrame("Frame", nil, optionsFrame)
                blizzBDFrame:SetBackdrop(bdOptions)
                blizzBDFrame:SetSize(100, 100)
                blizzBDFrame:SetPoint("BOTTOMRIGHT", optionsFrame, "TOP", -5, 0)
                blizzBDFrame:Hide()
                --blizzBDFrame:SetBackdropColor(bdOptions.backdropColor:GetRGB())
                --blizzBDFrame:SetBackdropBorderColor(bdOptions.backdropBorderColor:GetRGB())

                local auroraBDFrame = _G.CreateFrame("Frame", nil, optionsFrame)
                Base.CreateBackdrop(auroraBDFrame, bdOptions)
                auroraBDFrame:SetSize(100, 100)
                auroraBDFrame:SetPoint("BOTTOMLEFT", optionsFrame, "TOP", 5, 0)
                auroraBDFrame:Hide()
                --auroraBDFrame:SetBackdropColor(bdOptions.backdropColor:GetRGB())
                --auroraBDFrame:SetBackdropBorderColor(bdOptions.backdropBorderColor:GetRGB())


                local Dialog = _G.CreateFrame("Frame", "AuroraTestFrame", optionsFrame, "UIPanelDialogTemplate")
                Skin.UIPanelDialogTemplate(Dialog)
                Dialog:SetSize(300, 300)
                Dialog:ClearAllPoints()
                Dialog:SetPoint("TOPRIGHT", optionsFrame, "TOPLEFT", -10, 0)
                Dialog:Hide()

                local Button1 = _G.CreateFrame("Button", nil, Dialog, "UIPanelButtonTemplate")
                Button1:SetSize(50, 20)
                Button1:SetPoint("TOPLEFT", 10, -10)
                Button1:LockHighlight()
                Button1:UnlockHighlight()
                --Button1:Disable()

                local Button2 = _G.CreateFrame("Button", nil, Dialog, "UIPanelButtonTemplate")
                Button2:SetSize(50, 50)
                Button2:SetPoint("TOPLEFT", 10, -40)
                Skin.UIPanelButtonTemplate(Button2)
                Button2:LockHighlight()
                Button2:UnlockHighlight()
                --Button2:Disable()

                local Button3 = _G.CreateFrame("Button", nil, Dialog, "UIPanelButtonTemplate")
                Button3:SetSize(100, 50)
                Button3:SetPoint("TOPLEFT", 10, -100)
                Skin.UIPanelButtonTemplate(Button3)

                test.args.skins = {
                    name = "Skins",
                    type = "group",
                    args = {
                        backdrop = {
                            name = "Show backdrop tests",
                            type = "toggle",
                            get = function() return auroraBDFrame:IsShown() end,
                            set = function(info, value)
                                blizzBDFrame:SetShown(value)
                                auroraBDFrame:SetShown(value)
                            end,
                            order = 1,
                        },
                        dialog = {
                            name = "Show widget tests",
                            type = "toggle",
                            get = function() return Dialog:IsShown() end,
                            set = function(info, value)
                                Dialog:SetShown(value)
                            end,
                            order = 1,
                        },
                    },
                }
            end

            if private.isRetail then -- PvP
                function _G.GetNumBattlefieldScores()
                    return 20
                end
                function _G.GetMaxBattlefieldID()
                    return 1
                end
                function _G.GetBattlefieldStatus(id)
                    return "active"
                end

                local PVPTeamInfo = {
                    name = "team ",
                    size = 10,
                    rating = 0,
                    ratingNew = 0,
                    ratingMMR = 0,
                }
                function _G.C_PvP.GetTeamInfo(index)
                    local info = CopyTable(PVPTeamInfo)
                    info.name = info.name..index
                    return info
                end

                local PVPPostMatchCurrencyReward = {
                    currencyType = 0,
                    quantityChanged = 0,
                }
                function _G.C_PvP.GetPostMatchCurrencyRewards()
                    local rewards = {}
                    local info = CopyTable(PVPPostMatchCurrencyReward)
                    info.currencyType = _G.Constant.Currency.Honor
                    info.quantityChanged = 123
                    rewards[1] = info

                    info = CopyTable(PVPPostMatchCurrencyReward)
                    info.currencyType = _G.Constant.Currency.Conquest
                    info.quantityChanged = 456
                    rewards[2] = info
                    return rewards
                end

                function _G.C_PvP.IsRatedBattleground()
                    return true
                end
                function _G.C_PvP.IsRatedMap()
                    return true
                end

                local PVPScoreInfo = {
                    name = "player ",
                    guid = "",
                    killingBlows = 0,
                    honorableKills = 0,
                    deaths = 0,
                    honorGained = 0,
                    faction = 0,
                    raceName = "",
                    className = "",
                    classToken = "",
                    damageDone = 0,
                    healingDone = 0,
                    rating = 0,
                    ratingChange = 0,
                    prematchMMR = 0,
                    mmrChange = 0,
                    talentSpec = "",
                    honorLevel = 0,
                    stats = {
                        {
                            pvpStatID = 0,
                            pvpStatValue = 0,
                            name = "",
                            tooltip = "",
                            iconName = "",
                        }
                    },
                }

                local numClasses = _G.GetNumClasses()
                function _G.C_PvP.GetScoreInfo(offsetIndex)
                    local info = CopyTable(PVPScoreInfo)
                    info.name = info.name..offsetIndex

                    local raceInfo = _G.C_CreatureInfo.GetRaceInfo((offsetIndex % 12) + 1)
                    info.raceName = raceInfo.raceName
                    info.faction = _G.PLAYER_FACTION_GROUP[_G.C_CreatureInfo.GetFactionInfo(raceInfo.raceID).groupTag]

                    local classInfo = _G.C_CreatureInfo.GetClassInfo((offsetIndex % numClasses) + 1)
                    info.className = classInfo.className
                    info.classToken = classInfo.classFile

                    local numSpecs = _G.GetNumSpecializationsForClassID(classInfo.classID)
                    local _, name = _G.GetSpecializationInfoForClassID(classInfo.classID, (offsetIndex % numSpecs) + 1)
                    info.talentSpec = name

                    info.honorLevel = offsetIndex

                    return info
                end

                test.args.pvp = {
                    name = "PvP Score",
                    type = "group",
                    args = {
                        pvpScore = {
                            name = "PvP scoreboard",
                            desc = "PVPMatchScoreboard",
                            type = "execute",
                            func = function()
                                _G.PVPMatchScoreboard:BeginShow()
                            end,
                        },
                        pvpResults = {
                            name = "PvP results",
                            desc = "PVPMatchResults",
                            type = "execute",
                            func = function()
                                _G.PVPMatchResults:BeginShow()
                            end,
                        },
                        pvpTimer = {
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

            do -- Misc
                if private.isRetail then
                    local PartyPoseInfo = {
                        partyPoseID = 6,
                        mapID = 1898,
                        widgetSetID = 3,
                        victoryModelSceneID = 110,
                        defeatModelSceneID = 229,
                        victorySoundKitID = 118540,
                        defeatSoundKitID = 118536,
                    }
                    function _G.C_PartyPose.GetPartyPoseInfoByMapID(mapID)
                        return CopyTable(PartyPoseInfo)
                    end
                    function _G.GetLFGCompletionReward()
                        --     name, typeID, subtypeID, iconTextureFile, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards
                        return "name", 1,    1,         54343,           12345,     0,        54321,          0,             2,            1
                    end
                    function _G.GetLFGCompletionRewardItem(rewardIndex)
                        --     texture, quantity, isBonus, bonusQuantity, name, quality, id, objectType
                        return testItem.texture, 1, false,   1, testItem.name,  4, testItem.id, "item"
                    end
                    function _G.GetLFGCompletionRewardItemLink(rewardIndex)
                        return testItem.link
                    end
                end

                test.args.misc = {
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
                        islandsScoreFrame = {
                            name = "Islands Score Frame",
                            desc = "IslandsPartyPoseFrame",
                            hidden = private.isClassic,
                            type = "execute",
                            func = function()
                                _G.IslandsPartyPose_LoadUI()
                                _G.IslandsPartyPoseFrame:LoadScreen(981, 1)
                                _G.IslandsPartyPoseFrame:SetRewards()
                                _G.ShowUIPanel(_G.IslandsPartyPoseFrame)
                            end,
                        },
                        warfrontScoreFrame = {
                            name = "Warfront Score Frame",
                            desc = "WarfrontsPartyPoseFrame",
                            hidden = private.isClassic,
                            type = "execute",
                            func = function()
                                _G.WarfrontsPartyPose_LoadUI()
                                _G.WarfrontsPartyPoseFrame:LoadScreen(1876, 1)
                                --_G.WarfrontsPartyPoseFrame:SetRewards()
                                _G.ShowUIPanel(_G.WarfrontsPartyPoseFrame)
                            end,
                        },
                        compactRaidFrameManager = {
                            name = "Compact Raid Frame Manager",
                            desc = "CompactRaidFrameManager",
                            type = "execute",
                            func = function()
                                _G.CompactRaidFrameManager:Show()
                            end,
                        },
                    },
                }

            end

            AceConfig:RegisterOptionsTable("test", test)
        end


        _G.C_Timer.After(0, function()
            _G.LibStub("AceConfigDialog-3.0"):Open("test", container)
        end)
    else
        _G.print("AceConfig does not exist.")
    end
end

local profile -- /aurora profile
function commands.profile()
    if not profile then
        local Aurora = _G.Aurora
        profile = Aurora.Profile

        local COLUMN_INFO = {
            [1] = {
                title = _G.NAME,
                width = 200,
                attribute = "name",
            },
            [2] = {
                title = "Time",
                width = 100,
                attribute = "time",
            },
            [3] = {
                title = "Total Time",
                width = 100,
                attribute = "total",
            },
            [4] = {
                title = "# Called",
                width = 0,
                attribute = "num",
            },
        }

        function Aurora.Skin.FriendsFrameWhoButtonTemplate(Button)
            local name, variable, level, class = Button:GetRegions()
            name:SetWidth(COLUMN_INFO[1].width)
            Button.name = name

            variable:SetWidth(COLUMN_INFO[2].width)
            variable:SetPoint("LEFT", name, "RIGHT", 0, 0)
            Button.variable = variable

            level:SetWidth(COLUMN_INFO[3].width)
            level:SetJustifyH("LEFT")
            level:SetPoint("LEFT", variable, "RIGHT", 0, 0)
            Button.level = level

            class:SetWidth(COLUMN_INFO[4].width)
            class:SetPoint("LEFT", level, "RIGHT", 0, 0)
            Button.class = class

            local highlight = Button:GetHighlightTexture()
            highlight:SetPoint("LEFT")
            highlight:SetPoint("RIGHT", class)
        end

        local frame = _G.CreateFrame("Frame", nil, _G.UIParent, "ButtonFrameTemplate")
        frame:SetPoint("CENTER")
        frame:SetSize(500, 400)
        profile.frame = frame
        frame.TitleText:Show()

        _G.ButtonFrameTemplate_HidePortrait(frame)
        _G.FrameTemplate_SetAtticHeight(frame, 52)
        _G.ButtonFrameTemplate_HideButtonBar(frame)

        local scroll = _G.CreateFrame("ScrollFrame", nil, frame, "BasicHybridScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", frame.Inset, 0, 0)
        scroll:SetPoint("BOTTOMRIGHT", frame.Inset, -20, 0)
        frame.scroll = scroll
        function scroll:update()
            --print("profile data update")
            local offset = _G.HybridScrollFrame_GetOffset(self)
            local buttons = self.buttons
            local numButtons = #buttons
            local numFunctions = #profile

            local sortType = frame.columns.sortType
            table.sort(profile, function(a, b)
                if a[sortType] ~= b[sortType] then
                    if sortType == "name" then
                        return a.name < b.name
                    else
                        return a[sortType] > b[sortType]
                    end
                else
                    return a.name < b.name
                end
            end)

            local button, index, info
            for i = 1, numButtons do
                button = buttons[i]
                index = offset + i
                info = profile[index]

                if index <= numFunctions then
                    --print("info", index)

                    button.name:SetText(info.name)
                    button.variable:SetFormattedText("%.6f", info.time)
                    button.level:SetFormattedText("%.6f", info.total)
                    button.class:SetText(info.num)

                    button.tooltip1 = info.name
                    button.tooltip2 = info.time

                    button:Show()
                    button.index = index
                else
                    button:Hide()
                end
            end

            local totalHeight = numFunctions * self.buttonHeight
            local displayedHeight = numButtons * self.buttonHeight
            _G.HybridScrollFrame_Update(self, totalHeight, displayedHeight)
        end

        _G.HybridScrollFrame_CreateButtons(scroll, "FriendsFrameWhoButtonTemplate", 0, 0)

        local columns = _G.CreateFrame("Frame", nil, frame, "ColumnDisplayTemplate")
        columns:SetHeight(26)
        columns:SetPoint("TOPLEFT", frame.TopTileStreaks, 8, 0)
        columns:SetPoint("BOTTOMRIGHT", scroll, "TOPRIGHT", 24, 0)
        columns:LayoutColumns(COLUMN_INFO)
        function columns:sortingFunction(columnIndex)
            self.sortType = COLUMN_INFO[columnIndex].attribute
            frame.scroll:update()
        end
        columns.sortType = "time"
        frame.columns = columns

        local isProfiling = _G.GetCVar("scriptProfile") == "1"
        local mem
        local cpuTotal, cpuPrev, cpu
        _G.C_Timer.NewTicker(1, function(...)
            _G.UpdateAddOnMemoryUsage()
            _G.UpdateAddOnCPUUsage()

            scroll:update()
            mem = _G.GetAddOnMemoryUsage(profile.host)
            if mem > 1000 then
                mem = mem / 1000
                mem = ("%.2f MB"):format(mem)
            else
                mem = ("%.0f KB"):format(mem)
            end

            cpuPrev = cpuTotal or 0
            cpuTotal = _G.GetAddOnCPUUsage(profile.host)
            cpu = cpuTotal - cpuPrev

            if isProfiling then
                frame.TitleText:SetFormattedText("%s  Memory: %s  CPU: %.2f ms", profile.host, mem, cpu)
            else
                frame.TitleText:SetFormattedText("%s  Memory: %s  Enable CVAR \"scriptProfile\" for CPU", profile.host, mem, cpu)
            end
        end)
    end

    profile.frame:Show()
end
