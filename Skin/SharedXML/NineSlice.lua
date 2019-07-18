local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook
local Util = Aurora.Util

do --[[ FrameXML\AnchorUtil.xml ]]
    Hook.AnchorUtil = {}
    function Hook.AnchorUtil.ApplyNineSliceLayout(container, userLayout, textureKit)
        if not container._auroraBackdrop then return end
        container:SetBackdrop(private.backdrop)
    end
end


do --[[ SharedXML\NineSlice.lua ]]
    local nineSliceSetup =    {
        "TopLeftCorner",
        "TopRightCorner",
        "BottomLeftCorner",
        "BottomRightCorner",
        "TopEdge",
        "BottomEdge",
        "LeftEdge",
        "RightEdge",
        "Center",
    }

    local function GetNineSlicePiece(container, pieceName)
        if container.GetNineSlicePiece then
            return container:GetNineSlicePiece(pieceName)
        end

        return container[pieceName]
    end

    Hook.NineSliceUtil = {}
    function Hook.NineSliceUtil.ApplyLayout(container, userLayout, textureKit)
        if not container._auroraBackdrop then return end
        container:SetBackdrop(private.backdrop)
        for i = 1, #nineSliceSetup do
            local piece = GetNineSlicePiece(container, nineSliceSetup[i])
            if piece then
                piece:SetTexture("")
            end
        end
    end
end

function private.SharedXML.NineSlice()
    Util.Mixin(_G.NineSliceUtil, Hook.NineSliceUtil)
end
