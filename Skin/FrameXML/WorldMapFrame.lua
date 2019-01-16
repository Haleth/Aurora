local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\WorldMapFrame.lua ]]
    do --[[ FrameXML\WorldMapBountyBoard.lua ]]
        Hook.WorldMapBountyBoardMixin = {}
        function Hook.WorldMapBountyBoardMixin:TryShowingIntroTutorial()
            if self:GetDisplayLocation() == _G.LE_MAP_OVERLAY_DISPLAY_LOCATION_TOP_RIGHT or self:GetDisplayLocation() == _G.LE_MAP_OVERLAY_DISPLAY_LOCATION_BOTTOM_RIGHT then
                Skin.GlowBoxArrowTemplate(self.TutorialBox, "Right")
            else
                Skin.GlowBoxArrowTemplate(self.TutorialBox, "Left")
            end
        end
        function Hook.WorldMapBountyBoardMixin:TryShowingCompletionTutorial()
            Skin.GlowBoxArrowTemplate(self.TutorialBox, "Down")
        end
    end
end

do --[[ FrameXML\WorldMapFrame.xml ]]
    do --[[ FrameXML\WorldMapFrameTemplates.xml ]]
        function Skin.WorldMapBountyBoardTemplate(Frame)
            Skin.GlowBoxFrame(Frame.TutorialBox, "Right")
        end
        function Skin.WorldMapActionButtonTemplate(Frame)
        end
    end
end

function private.FrameXML.WorldMapFrame()
    ----====####$$$$%%%%%$$$$####====----
    --       WorldMapBountyBoard       --
    ----====####$$$$%%%%%$$$$####====----
    Util.Mixin(_G.WorldMapBountyBoardMixin, Hook.WorldMapBountyBoardMixin)


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
