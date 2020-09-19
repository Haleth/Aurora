local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_FlightMap.lua ]]
--end

--do --[[ AddOns\Blizzard_FlightMap.xml ]]
--end

function private.AddOns.Blizzard_FlightMap()
    local FlightMapFrame = _G.FlightMapFrame
    Skin.MapCanvasFrameTemplate(FlightMapFrame)
    Skin.PortraitFrameTemplate(FlightMapFrame.BorderFrame)
    FlightMapFrame.BorderFrame.TopBorder:Hide()

    Skin.MapCanvasFrameScrollContainerTemplate(FlightMapFrame.ScrollContainer)
    FlightMapFrame.ScrollContainer:SetAllPoints()
end
