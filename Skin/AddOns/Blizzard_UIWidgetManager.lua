local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
--local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_UIWidgetManager.lua ]]
    local UIWidgetManagerMixin do
        UIWidgetManagerMixin = {}
        function UIWidgetManagerMixin:ProcessWidget(widgetID, widgetSetID, widgetType)
            if Skin[widgetType] then
                private.debug("UIWidgetManagerMixin:ProcessWidget", widgetID, widgetSetID, widgetType)
                local widgetFrame = self.widgetIdToFrame[widgetID];
                if widgetFrame and not widgetFrame._auroraSkinned then
                    Skin[widgetType](widgetFrame)
                end
            end
        end
    end
    Hook.UIWidgetManagerMixin = UIWidgetManagerMixin
end

--[[ do AddOns\Blizzard_UIWidgetManager.xml
end ]]

function private.AddOns.Blizzard_UIWidgetManager()
    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_UIWidgetManager    --
    ----====####$$$$%%%%$$$$####====----
    local UIWidgetManager = _G.UIWidgetManager
    Util.Mixin(UIWidgetManager, Hook.UIWidgetManagerMixin)

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
