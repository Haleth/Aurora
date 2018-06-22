local _, private = ...

local FrameXML = {
    -- add C namespace augmentations here
    "SharedXML.C_TimerAugment",

    -- add snippets independent of modules here
    "SharedXML.Util",
    "SharedXML.AnchorUtil",
    "SharedXML.EasingUtil",
    "SharedXML.BindingUtil",
    "SharedXML.FrameUtil",
    "SharedXML.Pools",
    "SharedXML.LoopingSoundEffect",
    "SharedXML.CircularBuffer",
    "SharedXML.FontableFrameMixin",
    "SharedXML.Vector2D",
    "SharedXML.Vector3D",
    "SharedXML.Spline",
    "SharedXML.LayoutFrame",
    "SharedXML.ManagedLayoutFrame",
    "SharedXML.BulletPoint",
    "SharedXML.TransformTree_TransformTree",
    "SharedXML.KeyCommand",
    "SharedXML.CustomBindingButtonMixin",
    "MixinUtil",

    -- intrinsics
    "SharedXML.ScrollingMessageFrame",

    "SharedXML.ModelSceneTemplates",
    "SharedXML.ModelSceneMixin",
    "SharedXML.ModelSceneActorMixin",
    "SharedXML.FrameStack",

    "AnimatedStatusBar",
    "FlowContainer",
    "FrameLocks",
    "PlayerMovementFrameFader",


    "SharedXML.SoundKitConstants",
    "Constants",
    "Localization",
    "Fonts",
    "FontStyles",

    "SharedXML.PropertyBindingMixin",
    "SharedXML.PropertyButton",
    "SharedXML.PropertyFontString",
    "SharedXML.PropertySlider",
    "QuestLogOwnerMixin",

    "ObjectAPI_ContinuableContainer",
    "ObjectAPI_ItemLocation",
    "ObjectAPI_Item",
    "ObjectAPI_Spell",
    "ObjectAPI_PlayerLocation",

    -- add new modules below here
    "WorldFrame",
    "UIParent",
    "QuestUtils",
    "MapUtil",
    "AzeriteUtil",
    "VehicleUtil",
    "CurrencyContainer",
    -- IME needs to be loaded after UIParent
    "SharedXML.IME",
    "MoneyFrame",
    "MoneyInputFrame",
    "SharedXML.SecureUIPanelTemplates",
    "SharedXML.SharedUIPanelTemplates",
    "SharedXML.SharedBasicControls",
    "SharedXML.CustomBindingButtonTemplate",
    "CustomBindingManager",
    "CustomBindingHandler",
    "GarrisonBaseUtils",
    "FloatingGarrisonFollowerTooltip",
    "GarrisonFollowerTooltip",
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
    "AlertFrameIntrinsic",
    "AlertFrames",
    "AlertFrameSystems",
    "SocialToast",
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
    "VoiceChatHeadsetButton",
    "VoiceToggleButton",
    "UnitPopupSlider",
    "UnitPopupCustomControls",
    "UnitPopup",
    "HistoryKeeper",
    "ChatFrame",
    "FloatingChatFrame",
    "BNet",
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
    "PetActionBarFrame",
    "MultiCastActionBarFrame",
    "MainMenuBarBagButtons",
    "UnitPositionFrameTemplates",
    "FogOfWarFrameTemplates",
    "WorldMapFrame",
    "WarCampaignTemplates",
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
    "BattlegroundChatFilters",
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
    "StaticPopupSpecial",
    "LossOfControlFrame",
    "PVPHelper",
    "ProductChoice",
    "ZoneAbility",
    "ArtifactToasts",
    "AzeriteItemToasts",
    "AzeriteIslandsToast",
    "IslandsQueueFrame",
    "SharedXML.ModelPreviewFrame",
    "SplashFrame",
    "QuestChoiceFrameMixin",
    "AzeriteEmpoweredItemDataSource",

    -- Save off whatever we need available unmodified.
    "SecureCapsule",

    -- add new modules above here
    "LocalizationPost",
}

private.FrameXML = private.CreateAPI(FrameXML)
private.SharedXML = private.CreateAPI({})

--[==[ Some boilerplate stuff for new files
local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\File.lua ]]
end

do --[[ FrameXML\File.xml ]]
end

function private.FrameXML.File()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
function private.SharedXML.File()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
]==]
