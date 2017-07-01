local ADDON_NAME, private = ...

--  Lua Globals --
local select, tostring = _G.select, _G.tostring

local xpac, major, minor = _G.strsplit(".", _G.GetBuildInfo())
private.is730 = _G.tonumber(xpac) == 7 and (_G.tonumber(major) >= 3 or _G.tonumber(minor) >= 0)

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

local Aurora = {
    Hook = {},
    Skin = {}
}
private.Aurora = Aurora
_G.Aurora = Aurora
