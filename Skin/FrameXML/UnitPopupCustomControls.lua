local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\UnitPopupCustomControls.lua
end ]]

do --[[ FrameXML\UnitPopupCustomControls.xml ]]
    function Skin.UnitPopupVoiceToggleButtonTemplate(Button)
        Skin.VoiceToggleButtonTemplate(Button)
    end
    function Skin.UnitPopupVoiceSliderTemplate(Slider)
        Skin.UnitPopupSliderTemplate(Slider)
    end
end

function private.FrameXML.UnitPopupCustomControls()
    if not private.isPatch then return end
    Skin.UnitPopupVoiceSliderTemplate(_G.UnitPopupVoiceSpeakerVolume.Slider)
    Skin.UnitPopupVoiceToggleButtonTemplate(_G.UnitPopupVoiceSpeakerVolume.Toggle)

    Skin.UnitPopupVoiceSliderTemplate(_G.UnitPopupVoiceMicrophoneVolume.Slider)
    Skin.UnitPopupVoiceToggleButtonTemplate(_G.UnitPopupVoiceMicrophoneVolume.Toggle)

    Skin.UnitPopupVoiceSliderTemplate(_G.UnitPopupVoiceUserVolume.Slider)
    Skin.UnitPopupVoiceToggleButtonTemplate(_G.UnitPopupVoiceUserVolume.Toggle)
end
