local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\Timer.lua ]]
    function Hook.StartTimer_SetGoTexture(timer)
        if not timer._auroraSkinned then
            Skin.StartTimerBar(timer)
            timer._auroraSkinned = true
        end
    end
end

do --[[ FrameXML\Timer.xml ]]
    function Skin.StartTimerBar(Frame)
        Skin.FrameTypeStatusBar(Frame.bar)
        local bg, border = Frame.bar:GetRegions()
        bg:Hide()
        border:Hide()
    end
end

function private.FrameXML.Timer()
    _G.hooksecurefunc("StartTimer_SetGoTexture", Hook.StartTimer_SetGoTexture)
end
