local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\AudioOptionsPanels.lua ]]
    function Hook.AudioOptionsVoicePanel_InitializeCommunicationModeUI(self)
        Skin.CustomBindingButtonTemplateWithLabel(self.PushToTalkKeybindButton)
    end
end

do --[[ FrameXML\AudioOptionsPanels.xml ]]
    function Skin.CustomBindingButtonTemplate(Button)
        Skin.UIMenuButtonStretchTemplate(Button)
    end
    function Skin.CustomBindingButtonTemplateWithLabel(Button)
        Skin.CustomBindingButtonTemplate(Button)
    end
    function Skin.AudioOptionsBaseCheckButtonTemplate(CheckButton)
        Skin.OptionsBaseCheckButtonTemplate(CheckButton)
    end
    function Skin.AudioOptionsCheckButtonTemplate(CheckButton)
        Skin.AudioOptionsBaseCheckButtonTemplate(CheckButton)
    end
    function Skin.AudioOptionsSmallCheckButtonTemplate(CheckButton)
        Skin.AudioOptionsBaseCheckButtonTemplate(CheckButton)
    end
end

function private.FrameXML.AudioOptionsPanels()
    _G.hooksecurefunc("AudioOptionsVoicePanel_InitializeCommunicationModeUI", Hook.AudioOptionsVoicePanel_InitializeCommunicationModeUI)

    -----------------
    -- Sound Panel --
    -----------------
    Skin.AudioOptionsCheckButtonTemplate(_G.AudioOptionsSoundPanelEnableSound)

    -- Playback
    Skin.OptionsBoxTemplate(_G.AudioOptionsSoundPanelPlayback)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelSoundEffects)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelPetSounds)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelEmoteSounds)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelMusic)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelLoopMusic)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelPetBattleMusic)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelAmbientSounds)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelDialogSounds)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelErrorSpeech)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelSoundInBG)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelReverb)
    Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelHRTF)

    -- Hardware
    Skin.OptionsBoxTemplate(_G.AudioOptionsSoundPanelHardware)
    Skin.UIDropDownMenuTemplate(_G.AudioOptionsSoundPanelHardwareDropDown)
    Skin.UIDropDownMenuTemplate(_G.AudioOptionsSoundPanelSoundChannelsDropDown)
    Skin.UIDropDownMenuTemplate(_G.AudioOptionsSoundPanelSoundCacheSizeDropDown)

    -- Volume
    Skin.OptionsBoxTemplate(_G.AudioOptionsSoundPanelVolume)
    Skin.OptionsSliderTemplate(_G.AudioOptionsSoundPanelMasterVolume)
    Skin.OptionsSliderTemplate(_G.AudioOptionsSoundPanelSoundVolume)
    Skin.OptionsSliderTemplate(_G.AudioOptionsSoundPanelMusicVolume)
    Skin.OptionsSliderTemplate(_G.AudioOptionsSoundPanelAmbienceVolume)
    Skin.OptionsSliderTemplate(_G.AudioOptionsSoundPanelDialogVolume)
end
