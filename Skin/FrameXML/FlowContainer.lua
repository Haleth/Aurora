local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\FlowContainer.lua ]]
    function Hook.FlowContainer_AddSpacer(container, spacerSize)
        container.flowFrames[#container.flowFrames] = Scale.Value(spacerSize)
    end

    function Hook.FlowContainer_DoLayout(container)
        if container.flowPauseUpdates then return end
        private.debug(container:GetName(), container.flowPauseUpdates)

        local i = 1;
        while ( i <= #container.flowFrames ) do
            local object = container.flowFrames[i]
            if type(object) == "table" then
                object._auroraNoSetPoint = true
            end
            i = i + 1
        end
    end
end

do --[[ FrameXML\FlowContainer.xml ]]
end

function private.FrameXML.FlowContainer()
    --[[
    ]]
    _G.hooksecurefunc("FlowContainer_AddSpacer", Hook.FlowContainer_AddSpacer)
    _G.hooksecurefunc("FlowContainer_DoLayout", Hook.FlowContainer_DoLayout)
end
