local ADDON_NAME, private = ...

--  Lua Globals --
local select, tostring = _G.select, _G.tostring

local xpac, major, minor = _G.strsplit(".", _G.GetBuildInfo())
private.is730 = _G.tonumber(xpac) == 7 and (_G.tonumber(major) >= 3 and _G.tonumber(minor) >= 0)
local classLocale, class, classID = _G.UnitClass("player")
private.charClass = {
    locale = classLocale,
    token = class,
    id = classID,
}

local debug do
    if _G.LibStub then
        local debugger
        local LTD = _G.LibStub((_G.RealUI and "RealUI_" or "").."LibTextDump-1.0", true)
        function debug(...)
            if not debugger then
                if LTD then
                    debugger = LTD:New(ADDON_NAME .." Debug Output", 640, 480)
                    private.debugger = debugger
                else
                    return
                end
            end
            local time = _G.date("%H:%M:%S")
            local text = ("[%s]"):format(time)
            for i = 1, select("#", ...) do
                local arg = select(i, ...)
                text = text .. "     " .. tostring(arg)
            end
            debugger:AddLine(text)
        end
    else
        debug = function() end
    end
    private.debug = debug
end

do
    local apiMeta = {
        __newindex = function(table, key, value)
            if _G.type(value) == "function" then
                _G.rawset(table, key, function(...)
                    if table.Pre[key] then
                        table.Pre[key](...)
                    end
                    local ret = value(...)
                    if table.Post[key] then
                        table.Post[key](...)
                    end
                    return ret
                end)
            end
        end
    }
    function private.CreateAPI(api)
        api.Pre = {}
        api.Post = {}
        return _G.setmetatable(api, apiMeta)
    end
end

local Aurora = {
    Base = private.CreateAPI({}),
    Hook = private.CreateAPI({}),
    Skin = private.CreateAPI({}),
}
private.Aurora = Aurora
_G.Aurora = Aurora
