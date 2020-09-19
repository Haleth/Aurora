local _, private = ...
if private.isClassic then return end

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
            if self.TutorialBox.activeTutorial == _G.LE_FRAME_TUTORIAL_BOUNTY_INTRO then
                if self:GetDisplayLocation() == _G.LE_MAP_OVERLAY_DISPLAY_LOCATION_TOP_RIGHT or self:GetDisplayLocation() == _G.LE_MAP_OVERLAY_DISPLAY_LOCATION_BOTTOM_RIGHT then
                    Skin.GlowBoxArrowTemplate(self.TutorialBox.Arrow, "Right")
                else
                    Skin.GlowBoxArrowTemplate(self.TutorialBox.Arrow, "Left")
                end
            end
        end
        function Hook.WorldMapBountyBoardMixin:TryShowingCompletionTutorial()
            if self.TutorialBox.activeTutorial == _G.LE_FRAME_TUTORIAL_BOUNTY_FINISHED then
                Skin.GlowBoxArrowTemplate(self.TutorialBox.Arrow, "Down")
            end
        end
    end
end

do --[[ FrameXML\WorldMapFrame.xml ]]
    do --[[ FrameXML\WorldMapFrameTemplates.xml ]]
        function Skin.WorldMapBountyBoardTemplate(Frame)
            if not private.isPatch then
                Skin.GlowBoxFrame(Frame.TutorialBox, "Right")
            end
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
