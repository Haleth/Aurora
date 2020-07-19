local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\ScenarioFinder.lua ]]
--end

do --[[ FrameXML\ScenarioFinder.xml ]]
    Skin.ScenarioSpecificChoiceTemplate = Skin.LFGSpecificChoiceTemplate
end

function private.FrameXML.ScenarioFinder()
    local ScenarioFinderFrame = _G.ScenarioFinderFrame
    Skin.InsetFrameTemplate(ScenarioFinderFrame.Inset)

    local Queue = ScenarioFinderFrame.Queue
    Queue.Bg:Hide()
    Skin.UIDropDownMenuTemplate(Queue.Dropdown)

    local Random = Queue.Random
    Skin.UIPanelScrollFrameTemplate(Random.ScrollFrame)
    Skin.LFGRewardFrameTemplate(Random.ScrollFrame.Child)
    _G.ScenarioQueueFrameRandomScrollFrameScrollBackground:Hide()
    _G.ScenarioQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
    _G.ScenarioQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()

    local Specific = Queue.Specific
    Skin.ScenarioSpecificChoiceTemplate(Specific.Button1)
    Skin.FauxScrollFrameTemplate(Specific.ScrollFrame)
    _G.ScenarioQueueFrameSpecificScrollFrameScrollBackgroundTopLeft:Hide()
    _G.ScenarioQueueFrameSpecificScrollFrameScrollBackgroundBottomRight:Hide()

    Skin.MagicButtonTemplate(_G.ScenarioQueueFrameFindGroupButton)
end
