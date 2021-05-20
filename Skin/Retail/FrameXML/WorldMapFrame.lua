local _, private = ...
if not private.isRetail then return end

-- [[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\WorldMapFrame.lua ]]
--end

do --[[ FrameXML\WorldMapFrame.xml ]]
    do --[[ FrameXML\WorldMapFrameTemplates.xml ]]
        function Skin.WorldMapBountyBoardTemplate(Frame)
        end
        function Skin.WorldMapActionButtonTemplate(Frame)
        end
    end
end

function private.FrameXML.WorldMapFrame()
    ----====####$$$$%%%%%$$$$####====----
    --       WorldMapBountyBoard       --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --      WorldMapActionButton      --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --      WorldMapPOIQuantizer      --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    --          WorldMapFrame          --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --     WorldMapFrameTemplates     --
    ----====####$$$$%%%%$$$$####====----
end
