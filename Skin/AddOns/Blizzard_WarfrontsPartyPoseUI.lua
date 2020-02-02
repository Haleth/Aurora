local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_WarfrontsPartyPoseUI.lua ]]
--end

--do --[[ AddOns\Blizzard_WarfrontsPartyPoseUI.xml ]]
--end

function private.AddOns.Blizzard_WarfrontsPartyPoseUI()
    local WarfrontsPartyPoseFrame = _G.WarfrontsPartyPoseFrame
    Skin.PartyPoseFrameTemplate(WarfrontsPartyPoseFrame)
    Skin.PartyPoseModelFrameTemplate(WarfrontsPartyPoseFrame.ModelScene)
    Skin.UIPanelButtonNoTooltipResizeToFitTemplate(WarfrontsPartyPoseFrame.LeaveButton)
end
