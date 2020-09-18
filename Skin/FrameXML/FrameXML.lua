local _, private = ...

local FrameXML = {
    -- first
    "SharedXML.SharedConstants",

    -- add C namespace augmentations here
    "SharedXML.C_TimerAugment",

    -- add snippets independent of modules here
    "SharedXML.ErrorUtil",
    "SharedXML.Mixin",
    "SharedXML.TableUtil",
    "SharedXML.FunctionUtil",
    "SharedXML.MathUtil",
    "SharedXML.Rectangle",
    "SharedXML.TextureUtil",
    "SharedXML.Flags",
    "SharedXML.CallbackRegistry",
    "SharedXML.CvarUtil",
    "SharedXML.Color",
    "SharedXML.ColorUtil",
    "SharedXML.SharedColorConstants",
    "SharedXML.LinkUtil",
    "SharedXML.InterfaceUtil",
    "SharedXML.UnitUtil",
    "SharedXML.AccountUtil",
    "SharedXML.FormattingUtil",
    "SharedXML.TabGroup",
    "SharedXML.SmoothStatusBar",
    "SharedXML.PredictedSetting",
    "SharedXML.SecureUtil",
    "SharedXML.TimeUtil",
    "SharedXML.NineSlice",
    "SharedXML.EasingUtil",
    "SharedXML.BindingUtil",
    "SharedXML.FrameUtil",
    "SharedXML.RegionUtil",
    "SharedXML.AnchorUtil",
    "SharedXML.ScriptAnimationUtil",
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
    "SharedXML.PixelUtil",
    "SharedXML.TableBuilder",
    "SharedXML.NewFeatureLabel",
    "SharedXML.GlobalCallbackRegistry",
    "SharedXML.SelectableButton",
    "SharedXML.ButtonGroup",
    "SharedXML.EventButton",
    "SharedXML.ScrollController",
    "SharedXML.ScrollBox",
    "SharedXML.ScrollBar",
    "SharedXML.ScrollUtil",
    "MixinUtil",

    -- intrinsics
    "SharedXML.ScrollingMessageFrame",
    "SharedXML.DropDownToggleButton",

    "SharedXML.AnimationTemplates",
    "SharedXML.ModelSceneTemplates",
    "SharedXML.ModelSceneMixin",
    "SharedXML.ModelSceneActorMixin",
    "SharedXML.SharedTooltipTemplates",
    "SharedXML.FrameStack",

    "AnimatedStatusBar",
    "PowerDependencyLine",
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
    "ObjectAPI_AsyncCallbackSystem",
    "ObjectAPI_ObjectCache",
    "ObjectAPI_Item",
    "ObjectAPI_Spell",
    "ObjectAPI_PlayerLocation",
    "ObjectAPI_CampaignChapter",
    "ObjectAPI_Campaign",
    "ObjectAPI_Quest",
    "ObjectAPI_UiMapPoint",
    "ObjectAPI_CovenantCalling",

    -- add new modules below here
    "SharedXML.Backdrop",
    "WorldFrame",
    "UIParent",
    "SharedXML.ScriptedAnimations_ScriptedAnimationEffects",
    "SharedXML.ScriptedAnimations_ScriptAnimatedModelSceneActor",
    "SharedXML.ScriptedAnimations_ScriptAnimatedEffectController",
    "SharedXML.ScriptedAnimations_ScriptAnimatedModelScene",
    "SharedXML.GlobalFXModelScenes",
    "PartyUtil",
    "QuestUtils",
    "AchievementUtil",
    "AchievementDisplayFrame",
    "MapUtil",
    "AzeriteUtil",
    "AzeriteEssenceUtil",
    "AuraUtil",
    "CalendarUtil",
    "CommunitiesUtil",
    "RuneforgeUtil",
    "ItemUtil",
    "PVPUtil",
    "TransmogUtil",
    "ActionButtonUtil",
    "DifficultyUtil",
    "ItemDisplay",
    "HelpTip",
    "ExtraAbilityContainer",
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
    "AdventuresFollowerTooltip",
    "FloatingGarrisonFollowerTooltip",
    "GarrisonFollowerTooltip",
    "GameTooltip",
    "UIMenu",
    "SharedXML.UIDropDownMenu",
    "UIPanelTemplates",
    "SecureTemplates",
    "SecureHandlerTemplates",
    "SecureGroupHeaders",
    "AzeriteAnimationTemplates",
    "SharedXML.StaticModelInfo",
    "SharedXML.ModelFrameTemplates",
    "SharedXML.ModelFrames",
    "SharedXML.DressUpModelFrameMixin",
    "SharedXML.CharacterModelFrameMixin",
    "PetStableModelMixin",
    "QuestNPCModelFrameMixin",
    "TabardModelFrameMixin",
    "WardrobeOutfits",
    "DressUpFrames",
    "ItemButtonTemplate",
    "NavigationBar",
    "SharedXML.HybridScrollFrame",
    "SharedXML.TemplatedList",
    "SharedXML.ScrollList",
    "SharedXML.PagedList",
    "SharedXML.GridList",
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
    "PVPUITemplates",
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
    "CustomizationDebugFrame",
    "StatsFrame",
    "SpellBookFrame",
    "CharacterFrame",
    "PaperDollFrame",
    "PetPaperDollFrame", -- isClassic
    "SkillFrame", -- isClassic
    "ReputationFrame",
    "QuestFrame",
    "QuestLogFrame", -- isClassic
    "QuestTimerFrame", -- isClassic
    "QuestPOI",
    "QuestInfo",
    "MerchantFrame",
    "TradeFrame",
    "ContainerFrame",
    "LootFrame",
    "ItemTextFrame",
    "TaxiFrame",
    "BankFrame",
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
    "CampaignUtil",
    "WarCampaignTemplates",
    "CampaignOverview",
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
    "CustomGossipFrameBase",
    "MailFrame",
    "PetStable",
    "VehicleSeatIndicator",
    "DurabilityFrame",
    "BattlegroundChatFilters",
    "QueueUpdater",
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
    "ZoneAbility",
    "ArtifactToasts",
    "AzeriteItemToasts",
    "AzeriteIslandsToast",
    "SharedXML.ModelPreviewFrame",
    "ClassTrainerFrameTemplates", -- isClassic
    "SplashFrame",
    "AzeriteEmpoweredItemDataSource",
    "GuildUtil",
    "QuestSession",
    "ActionStatus",

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
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ FrameXML\File.lua ]]
--end

--do --[[ FrameXML\File.xml ]]
--end

function private.FrameXML.File()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
function private.SharedXML.File()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
]==]
