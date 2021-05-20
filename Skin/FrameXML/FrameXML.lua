local _, private = ...

-- luacheck: globals tinsert setmetatable rawset

private.fileOrder = {}
local mt = {
    __newindex = function(t, k, v)
        tinsert(private.fileOrder, {list = t, name = k})
        rawset(t, k, v)
    end
}

private.FrameXML = setmetatable({}, mt)
private.SharedXML = setmetatable({}, mt)

--[==[ Some boilerplate stuff for new files
local _, private = ...
if not private.isRetail then return end
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ FrameXML\File.lua ]]
--end

--do --[[ FrameXML\File.xml ]]
--end

function private.FrameXML.File()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
function private.SharedXML.File()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
]==]
