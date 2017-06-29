local _, private = ...

local FrameXML = {
    -- add C namespace augmentations here
    "SharedXML.C_TimerAugment",

    -- add snippets independent of modules here
    "SharedXML.Util",
    "SharedXML.Pools",
    "SharedXML.LoopingSoundEffect",
    "SharedXML.CircularBuffer",
    "SharedXML.FontableFrameMixin",
    "SharedXML.Vector2D",
    "SharedXML.Vector3D",
    "SharedXML.Spline",
    "MixinUtil",

    -- intrinsics
    "SharedXML.ScrollingMessageFrame",

    "SharedXML.ModelSceneTemplates",
    "SharedXML.ModelSceneMixin",
    "SharedXML.ModelSceneActorMixin",

    "AnimatedStatusBar",
    "FlowContainer",
    "FrameLocks",


    "Constants",
    "Localization",
    "Fonts",
    "FontStyles",


    -- add new modules below here
    "WorldFrame",
    "UIParent",
    "QuestUtils",
    -- IME needs to be loaded after UIParent"/>
    "SharedXML.IME",
    "MoneyFrame",
    "MoneyInputFrame",
    "SharedXML.SharedUIPanelTemplates",
    "SharedXML.SharedBasicControls",
    "GameTooltip",
    "UIMenu",
    "UIDropDownMenu",
    "UIPanelTemplates",
    "SecureTemplates",
    "SecureHandlerTemplates",
    "SecureGroupHeaders",
    "SharedXML.ModelFrames",
    "WardrobeOutfits",
    "DressUpFrames",
    "ItemButtonTemplate",
    "NavigationBar",
    "SparkleFrame",
    "SharedXML.HybridScrollFrame",
    "GameMenuFrame",
    "CharacterFrameTemplates",
    "TextStatusBar",
    "UIErrorsFrame",
    "AutoComplete",
    "StaticPopup",
    "Sound",
    "OptionsFrameTemplates",
    "OptionsPanelTemplates",
    "UIOptions",
    "VideoOptionsFrame",
    "SharedXML.VideoOptionsPanels",
    "MacOptionsPanel",
    "AudioOptionsFrame",
    "AudioOptionsPanels",
    "InterfaceOptionsFrame",
    "InterfaceOptionsPanels",
    "SharedXML.AddonList",
    "GarrisonBaseUtils",
    "AlertFrames",
    "AlertFrameSystems",
    "MirrorTimer",
    "CoinPickupFrame",
    "StackSplitFrame",
    "FadingFrame",
    "ZoneText",
    "BuilderSpenderFrame",
    "UnitFrame",
    "Cooldown",
    "PVPHonorSystem",
    "ActionBarController",
    "TutorialFrame",
    "Minimap",
    "GameTime",
    -- "ActionWindow",
    "EquipmentFlyout",
    "BuffFrame",
    "LowHealthFrame",
    "CombatFeedback",
    "UnitPowerBarAlt",
    "CastingBarFrame",
    "UnitPopup",
    "BNet",
    "HistoryKeeper",
    "ChatFrame",
    "FloatingChatFrame",
    "VoiceChat",
    "ReadyCheck",
    "PlayerFrame",
    "PartyFrame",
    "TargetFrame",
    "TotemFrame",
    "PetFrame",
    "StatsFrame",
    "SpellBookFrame",
    "CharacterFrame",
    "PaperDollFrame",
    "ReputationFrame",
    "QuestFrame",
    "QuestPOI",
    "QuestInfo",
    "MerchantFrame",
    "TradeFrame",
    "ContainerFrame",
    "LootFrame",
    "ItemTextFrame",
    "TaxiFrame",
    "BankFrame",
    "ScrollOfResurrection",
    "RoleSelectionTemplate",
    "ItemRef",
    "SocialQueue",
    "QuickJoinToast",
    "FriendsFrame",
    "QuickJoin",
    "RaidFrame",
    "ChannelFrame",
    "PetActionBarFrame",
    "MultiCastActionBarFrame",
    "MainMenuBarBagButtons",
    "UnitPositionFrameTemplates",
    "WorldMapFrame",
    "QuestMapFrame",
    "RaidWarning",
    "CinematicFrame",
    "ComboFrame",
    "TabardFrame",
    "GuildRegistrarFrame",
    "PetitionFrame",
    "HelpFrame",
    "ColorPickerFrame",
    "GossipFrame",
    "MailFrame",
    "PetStable",
    "VehicleSeatIndicator",
    "DurabilityFrame",
    "WorldStateFrame",
    "PVEFrame",
    "LFGFrame",
    "LFDFrame",
    "LFRFrame",
    "RaidFinder",
    "ScenarioFinder",
    "LFGList",
    "RatingMenuFrame",
    "TalentFrameBase",
    "TalentFrameTemplates",
    "ClassPowerBar",
    "RuneFrame",
    "ShardBar",
    "ComboFramePlayer",
    "InsanityBar",
    "EasyMenu",
    "ChatConfigFrame",
    "MovieFrame",
    "AlternatePowerBar",
    "MonkStaggerBar",
    "LevelUpDisplay",
    "AnimationSystem",
    "EquipmentManager",
    "CompactUnitFrame",
    "CompactRaidGroup",
    "CompactPartyFrame",
    "RolePoll",
    "SpellFlyout",
    "PaladinPowerBar",
    "MageArcaneChargesBar",
    "SpellActivationOverlay",
    "GuildInviteFrame",
    "GhostFrame",
    "StreamingFrame",
    "IconIntroAnimation",
    "Timer",
    "MonkHarmonyBar",
    "RecruitAFriendFrame",
    "DestinyFrame",
    "PriestBar",
    "SharedPetBattleTemplates",
    "LootHistory",
    "FloatingPetBattleTooltip",
    "QueueStatusFrame",
    "BattlePetTooltip",
    "FloatingGarrisonFollowerTooltip",
    "GarrisonFollowerTooltip",
    "StaticPopupSpecial",
    "LossOfControlFrame",
    "PVPHelper",
    "MapBar",
    "ProductChoice",
    "ZoneAbility",
    "ArtifactToasts",
    "SharedXML.ModelPreviewFrame",
    "SplashFrame",
    "SharedXML.LayoutFrame",

    -- Save off whatever we need available unmodified.
    "SecureCapsule",

    -- add new modules above here
    "LocalizationPost",
}

private.FrameXML = FrameXML
private.SharedXML = {}

-- [[ Lua Globals ]]
local next, tinsert = _G.next, _G.tinsert

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.SharedXML.SharedUIPanelTemplates()
    local r, g, b = C.r, C.g, C.b

    local function colourArrow(f)
        if f:IsEnabled() then
            for _, pixel in next, f.pixels do
                pixel:SetColorTexture(r, g, b)
            end
        end
    end

    local function clearArrow(f)
        for _, pixel in next, f.pixels do
            pixel:SetColorTexture(1, 1, 1)
        end
    end

    function private.Skin.MaximizeMinimizeButtonFrameTemplate(frame)
        for _, name in next, {"MaximizeButton", "MinimizeButton"} do
            local button = frame[name]
            button:SetSize(17, 17)
            button:ClearAllPoints()
            button:SetPoint("CENTER")
            F.Reskin(button)

            button.pixels = {}

            local lineOfs = 2.5
            local line = button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(0.5)
            line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
            line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
            tinsert(button.pixels, line)

            local hline = button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(7, 1)
            tinsert(button.pixels, hline)

            local vline = button:CreateTexture()
            vline:SetColorTexture(1, 1, 1)
            vline:SetSize(1, 7)
            tinsert(button.pixels, vline)

            if name == "MaximizeButton" then
                hline:SetPoint("TOP", 1, -4)
                vline:SetPoint("RIGHT", -4, 1)
            else
                hline:SetPoint("BOTTOM", -1, 4)
                vline:SetPoint("LEFT", 4, -1)
            end

            button:SetScript("OnEnter", colourArrow)
            button:SetScript("OnLeave", clearArrow)
        end
    end
end
