local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

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
    if private.isPatch then
        _G.hooksecurefunc("AudioOptionsVoicePanel_InitializeCommunicationModeUI", Hook.AudioOptionsVoicePanel_InitializeCommunicationModeUI)
    end

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
    if not private.isPatch then
        Skin.AudioOptionsSmallCheckButtonTemplate(_G.AudioOptionsSoundPanelEnableDSPs)
    end

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

    -----------------
    -- Voice Panel --
    -----------------
    if private.isPatch then
        local AudioOptionsVoicePanel = _G.AudioOptionsVoicePanel
        Skin.OptionsDropdownTemplate(AudioOptionsVoicePanel.OutputDeviceDropdown)
        Skin.OptionsSliderTemplate(AudioOptionsVoicePanel.VoiceChatVolume)
        Skin.OptionsDropdownTemplate(AudioOptionsVoicePanel.MicDeviceDropdown)
        Skin.OptionsSliderTemplate(AudioOptionsVoicePanel.VoiceChatMicVolume)
        Skin.OptionsSliderTemplate(AudioOptionsVoicePanel.VoiceChatMicSensitivity)

        local TestInputDevice = AudioOptionsVoicePanel.TestInputDevice
        Skin.OptionsButtonTemplate(TestInputDevice.ToggleTest)
        Skin.OptionsBoxTemplate(TestInputDevice.VUMeter)
        TestInputDevice.VUMeter:SetBackdropBorderColor(Color.button)
        TestInputDevice.VUMeter.Status:SetPoint("TOPLEFT", 1, -1)
        TestInputDevice.VUMeter.Status:SetPoint("BOTTOMRIGHT", -1, 1)
        Base.SetTexture(TestInputDevice.VUMeter.Status:GetStatusBarTexture(), "gradientUp")

        Skin.OptionsDropdownTemplate(AudioOptionsVoicePanel.ChatModeDropdown)
    end
end
