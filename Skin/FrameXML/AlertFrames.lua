local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
--local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\AlertFrames.lua ]]
    local AlertContainerMixin = {}
    function AlertContainerMixin:AddAlertFrame(frame)
        if frame._auroraTemplate then
            Skin[frame._auroraTemplate](frame)
        end
    end
    Hook.AlertContainerMixin = AlertContainerMixin
end

--[[ do FrameXML\AlertFrames.xml
end ]]

function private.FrameXML.AlertFrames()
    Util.Mixin(_G.AlertFrame, Hook.AlertContainerMixin)
end
