local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_UIWidgets.lua ]]
    do --[[ Blizzard_UIWidgetManager.lua ]]
        Hook.UIWidgetManagerMixin = {}
        function Hook.UIWidgetManagerMixin:ProcessWidget(widgetID, widgetSetID, widgetType)
            if Skin[widgetType] then
                private.debug("UIWidgetManagerMixin:ProcessWidget", widgetID, widgetSetID, widgetType)
                local widgetFrame = self.widgetIdToFrame[widgetID];
                if widgetFrame and not widgetFrame._auroraSkinned then
                    Skin[widgetType](widgetFrame)
                end
            end
        end
    end
end

--do --[[ AddOns\Blizzard_UIWidgets.xml ]]
--end

function private.AddOns.Blizzard_UIWidgets()
    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_UIWidgetManager    --
    ----====####$$$$%%%%$$$$####====----
    local UIWidgetManager = _G.UIWidgetManager
    Util.Mixin(UIWidgetManager, Hook.UIWidgetManagerMixin)

    -------------
    -- Section --
    -------------
end
