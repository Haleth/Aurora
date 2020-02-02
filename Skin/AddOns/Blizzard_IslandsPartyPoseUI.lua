local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_IslandsPartyPoseUI.lua ]]
--end

--do --[[ AddOns\Blizzard_IslandsPartyPoseUI.xml ]]
--end

function private.AddOns.Blizzard_IslandsPartyPoseUI()
    local IslandsPartyPoseFrame = _G.IslandsPartyPoseFrame
    Skin.PartyPoseFrameTemplate(IslandsPartyPoseFrame)
    Skin.PartyPoseModelFrameTemplate(IslandsPartyPoseFrame.ModelScene)
    Skin.UIPanelButtonNoTooltipResizeToFitTemplate(IslandsPartyPoseFrame.LeaveButton)
end
