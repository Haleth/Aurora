local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\AudioOptionsPanelsVoice.lua ]]
--end

--do --[[ FrameXML\AudioOptionsPanelsVoice.xml ]]
--end

function private.SharedXML.AudioOptionsPanelsVoice()
    local AudioOptionsVoicePanel = _G.AudioOptionsVoicePanel
    Skin.OptionsDropdownTemplate(AudioOptionsVoicePanel.OutputDeviceDropdown)
    Skin.OptionsSliderTemplate(AudioOptionsVoicePanel.VoiceChatVolume)
    Skin.OptionsSliderTemplate(AudioOptionsVoicePanel.VoiceChatDucking)
    Skin.OptionsDropdownTemplate(AudioOptionsVoicePanel.MicDeviceDropdown)
    Skin.OptionsSliderTemplate(AudioOptionsVoicePanel.VoiceChatMicVolume)
    Skin.OptionsSliderTemplate(AudioOptionsVoicePanel.VoiceChatMicSensitivity)

    local TestInputDevice = AudioOptionsVoicePanel.TestInputDevice
    Skin.OptionsButtonTemplate(TestInputDevice.ToggleTest)
    TestInputDevice.VUMeter:SetBackdrop(nil)
    Skin.FrameTypeStatusBar(TestInputDevice.VUMeter.Status)

    Skin.OptionsDropdownTemplate(AudioOptionsVoicePanel.ChatModeDropdown)
end
