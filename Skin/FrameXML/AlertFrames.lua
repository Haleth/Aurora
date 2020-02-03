local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\AlertFrames.lua ]]
    Hook.AlertContainerMixin = {}
    function Hook.AlertContainerMixin:AddAlertFrame(frame)
        if frame._auroraTemplate then
            Skin[frame._auroraTemplate](frame)
        end
    end
end

--do --[[ FrameXML\AlertFrames.xml ]]
--end

function private.FrameXML.AlertFrames()
    Util.Mixin(_G.AlertFrame, Hook.AlertContainerMixin)
end
