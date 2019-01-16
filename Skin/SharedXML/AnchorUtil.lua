local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook
local Util = Aurora.Util

do --[[ FrameXML\AnchorUtil.xml ]]
    Hook.AnchorUtil = {}

    do --[[ FrameXML\NineSlice.lua ]]
        function Hook.AnchorUtil.ApplyNineSliceLayout(container, userLayout, textureKit)
            if not container._auroraBackdrop then return end
            container:SetBackdrop(private.backdrop)
        end
    end
end


function private.SharedXML.AnchorUtil()
    Util.Mixin(_G.AnchorUtil, Hook.AnchorUtil)
end
