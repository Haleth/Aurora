local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

--do --[[ FrameXML\GhostFrame.lua ]]
--end

--do --[[ FrameXML\GhostFrame.xml ]]
--end

function private.FrameXML.GhostFrame()
    Skin.UIPanelLargeSilverButton(_G.GhostFrame)
    Base.CropIcon(_G.GhostFrameContentsFrameIcon, _G.GhostFrameContentsFrame)
end
