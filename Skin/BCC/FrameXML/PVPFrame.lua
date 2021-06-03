local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
--local Aurora = private.Aurora

--do --[[ FrameXML\PVPFrame.lua ]]
--end

--do --[[ FrameXML\PVPFrame.xml ]]
--end

function private.FrameXML.PVPFrame()
    local tl, tr, bl, br, bg = _G.PVPFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()
    bg:Hide()
end
