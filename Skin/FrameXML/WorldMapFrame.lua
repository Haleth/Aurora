local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\WorldMapBountyBoard.lua ]]
    local WorldMapBountyBoardMixin do
        WorldMapBountyBoardMixin = {}
        function WorldMapBountyBoardMixin:TryShowingIntroTutorial()
            if self:GetDisplayLocation() == _G.LE_MAP_OVERLAY_DISPLAY_LOCATION_TOP_RIGHT or self:GetDisplayLocation() == _G.LE_MAP_OVERLAY_DISPLAY_LOCATION_BOTTOM_RIGHT then
                Skin.GlowBoxArrowTemplate(self.TutorialBox, "Right")
            else
                Skin.GlowBoxArrowTemplate(self.TutorialBox, "Left")
            end
        end
        function WorldMapBountyBoardMixin:TryShowingCompletionTutorial()
            Skin.GlowBoxArrowTemplate(self.TutorialBox, "Down")
        end
    end
    Hook.WorldMapBountyBoardMixin = WorldMapBountyBoardMixin
end

do --[[ FrameXML\WorldMapFrameTemplates.xml ]]
    function Skin.WorldMapBountyBoardTemplate(Frame)
        Skin.GlowBoxFrame(Frame.TutorialBox, "Right")
    end
    function Skin.WorldMapActionButtonTemplate(Frame)
    end
end

function private.FrameXML.WorldMapFrame()
    Util.Mixin(_G.WorldMapBountyBoardMixin, Hook.WorldMapBountyBoardMixin)
end
