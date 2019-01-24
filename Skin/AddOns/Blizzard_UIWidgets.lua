local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_UIWidgets.lua ]]
    do --[[ Blizzard_UIWidgetManager.lua ]]
        Hook.UIWidgetContainerMixin = {}
        function Hook.UIWidgetContainerMixin:ProcessWidget(widgetID, widgetType)
            if Skin[widgetType] then
                private.debug("UIWidgetContainerMixin:ProcessWidget", widgetID, widgetType)
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
    if private.isPatch then
        local UIWidgetContainerMixin = _G.UIWidgetContainerMixin
        Util.Mixin(UIWidgetContainerMixin, Hook.UIWidgetContainerMixin)
    end

    -------------
    -- Section --
    -------------
end
