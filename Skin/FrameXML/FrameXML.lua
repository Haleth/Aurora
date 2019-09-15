local _, private = ...

local FrameXML = {
    -- first
    "SharedXML.SharedConstants",

    -- add C namespace augmentations here
    "SharedXML.C_TimerAugment",

    -- add snippets independent of modules here
    "SharedXML.Util",
    "SharedXML.TimeUtil",
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
    "SharedXML.PixelUtil",
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
    "AuraUtil",
    "CommunitiesUtil",
    -- IME needs to be loaded after UIParent
    "SharedXML.IME",
    "MoneyFrame",
    "MoneyInputFrame",
    "SharedXML.PanelThemes",
    "SharedXML.SecureUIPanelTemplates",
    "SharedXML.SharedUIPanelTemplates",
    "SharedXML.SharedBasicControls",
    "SharedXML.CustomBindingButtonTemplate",
    "CustomBindingManager",
    "CustomBindingHandler",
    "GameTooltip",
    "UIMenu",
    "UIDropDownMenu",
    "UIPanelTemplates",
    "SecureTemplates",
    "SecureHandlerTemplates",
    "SecureGroupHeaders",
    "SharedXML.ModelFrames",
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
    "UnitFrame",
    "Cooldown",
    "ActionBarController",
    "TutorialFrame",
    "Minimap",
    "GameTime",
    -- "ActionWindow",
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
    "PetFrame",
    "StatsFrame",
    "SpellBookFrame",
    "CharacterFrame",
    "PaperDollFrame",
    "ReputationFrame",
    "SkillFrame",
    "QuestFrame",
    "QuestLogFrame",
    "QuestInfo",
    "MerchantFrame",
    "TradeFrame",
    "ContainerFrame",
    "LootFrame",
    "ItemTextFrame",
    "TaxiFrame",
    "BankFrame",
    "ScrollOfResurrection",
    "ItemRef",
    "FriendsFrame",
    "RaidFrame",
    "PetActionBarFrame",
    "MainMenuBarBagButtons",
    "UnitPositionFrameTemplates",
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
    "DurabilityFrame",
    "BattlegroundChatFilters",
    "WorldStateFrame",
    "RatingMenuFrame",
    "EasyMenu",
    "ChatConfigFrame",
    "MovieFrame",
    "AnimationSystem",
    "CompactUnitFrame",
    "CompactRaidGroup",
    "CompactPartyFrame",
    "StreamingFrame",
    "RecruitAFriendFrame",
    "LootHistory",
    "StaticPopupSpecial",
    "ProductChoice",
    "SharedXML.ModelPreviewFrame",

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
