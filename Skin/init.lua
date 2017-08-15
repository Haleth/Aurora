local ADDON_NAME, private = ...

-- luacheck: globals select tostring tonumber

private.API_MAJOR, private.API_MINOR = 8, 0

local xpac, major, minor = _G.strsplit(".", _G.GetBuildInfo())
private.is730 = tonumber(xpac) == 7 and (tonumber(major) >= 3 and tonumber(minor) >= 0)

local classLocale, class, classID = _G.UnitClass("player")
private.charClass = {
    locale = classLocale,
    token = class,
    id = classID,
}

local debug do
    if _G.LibStub then
        local debugger
        local LTD = _G.LibStub("LibTextDump-1.0", true)
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

do -- private.CreateAPI
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
do -- private.FindUsage
    function private.FindUsage(table, func)
        hooksecurefunc(table, func, function()
            error("Found usage")
        end)
    end
end

local Aurora = {
    Base = private.CreateAPI({}),
    Hook = private.CreateAPI({}),
    Skin = private.CreateAPI({}),
}
private.Aurora = Aurora
_G.Aurora = Aurora


local eventFrame = _G.CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == ADDON_NAME then
        -- Setup function for the host addon
        if private.OnLoad then
            private.OnLoad()
        end

        -- Skin FrameXML
        for i = 1, #private.FrameXML do
            local file, isShared = _G.strsplit(".", private.FrameXML[i])
            local fileList = private.FrameXML
            if isShared then
                file = isShared
                fileList = private.SharedXML
            end
            if fileList[file] then
                fileList[file]()
            end
        end

        -- Skin prior loaded AddOns
        for addon, func in _G.next, private.AddOns do
            local loaded = _G.IsAddOnLoaded(addon)
            if loaded then
                func()
            end
        end

        private.isLoaded = true
    else
        -- Skin AddOn
        local addonModule = private.AddOns[addonName]
        if addonModule then
            addonModule()
        end
    end

    -- Load deprected themes
    local addonModule = Aurora[2].themes[addonName]
    if addonModule then
        if _G.type(addonModule) == "function" then
            addonModule()
        else
            for _, moduleFunc in _G.next, addonModule do
                moduleFunc()
            end
        end
    end
end)
