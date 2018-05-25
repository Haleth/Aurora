local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
--local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
--local Color = Aurora.Color

do --[[ AddOns\Blizzard_MapCanvasDetailLayer.lua ]]
    function Hook.MapCanvasDetailLayerMixin_RefreshDetailTiles(self)
        local layers = _G.C_Map.GetMapArtLayers(self.mapID)
        local layerInfo = layers[self.layerIndex]

        for detailTile in self.detailTilePool:EnumerateActive() do
            if not detailTile._auroraSkinned then
                detailTile:SetSize(layerInfo.tileWidth, layerInfo.tileHeight)
                detailTile._auroraSkinned = true
            end
        end
    end
end

--[[ do AddOns\Blizzard_MapCanvas.lua
end ]]

do --[[ AddOns\Blizzard_MapCanvas.xml ]]
    function Skin.MapCanvasFrameScrollContainerTemplate(ScrollFrame)
    end
    function Skin.MapCanvasFrameTemplate(Frame)
    end
end

function private.AddOns.Blizzard_MapCanvas()
    ----====####$$$$%%%%%$$$$####====----
    --  Blizzard_MapCanvasDetailLayer  --
    ----====####$$$$%%%%%$$$$####====----
    if private.isPatch then
        _G.hooksecurefunc(_G.MapCanvasDetailLayerMixin, "RefreshDetailTiles", Hook.MapCanvasDetailLayerMixin_RefreshDetailTiles)
    end

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
