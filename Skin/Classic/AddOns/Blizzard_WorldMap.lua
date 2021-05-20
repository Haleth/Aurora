local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_WorldMap.lua ]]
--end

do --[[ AddOns\Blizzard_WorldMap.xml ]]
    do --[[ Blizzard_WorldMap.xml ]]
        function Skin.WorldMapFrameTemplate(Frame)
        end
    end

end

function private.AddOns.Blizzard_WorldMap()
    ----====####$$$$%%%%%$$$$####====----
    --        Blizzard_WorldMap        --
    ----====####$$$$%%%%%$$$$####====----
    local WorldMapFrame = _G.WorldMapFrame
    Skin.WorldMapFrameTemplate(WorldMapFrame)
    Skin.FrameTypeFrame(WorldMapFrame.BorderFrame)

    local top1, top2, top3, top4, mid1, mid2, mid3, mid4, bot1, bot2, bot3, bot4, title = WorldMapFrame.BorderFrame:GetRegions()
    top1:Hide()
    top2:Hide()
    top3:Hide()
    top4:Hide()
    mid1:Hide()
    mid2:Hide()
    mid3:Hide()
    mid4:Hide()
    bot1:Hide()
    bot2:Hide()
    bot3:Hide()
    bot4:Hide()

    local bg = WorldMapFrame.BorderFrame:GetBackdropTexture("bg")
    title:ClearAllPoints()
    title:SetPoint("TOPLEFT", bg)
    title:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIDropDownMenuTemplate(WorldMapFrame.ContinentDropDown)
    Skin.UIDropDownMenuTemplate(WorldMapFrame.ZoneDropDown)
    Skin.UIPanelButtonTemplate(_G.WorldMapZoomOutButton)
    Skin.UIPanelCloseButton(_G.WorldMapFrameCloseButton)
end

