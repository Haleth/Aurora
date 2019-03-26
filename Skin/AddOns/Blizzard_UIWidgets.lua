local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_UIWidgets.lua ]]
    do --[[ Blizzard_UIWidgetManager ]]
        Hook.UIWidgetContainerMixin = {}
        function Hook.UIWidgetContainerMixin:CreateWidget(widgetID, widgetType, widgetTypeInfo, widgetInfo)
            local template = widgetTypeInfo.templateInfo.frameTemplate

            if Skin[template] then
                local widgetFrame = self.widgetFrames[widgetID]
                if widgetFrame and not widgetFrame._auroraSkinned then
                    Skin[template](widgetFrame)
                    widgetFrame._auroraSkinned = true
                else
                    private.debug("UIWidgetContainerMixin:CreateWidget Missing Template", template)
                end
            end
        end

        Hook.UIWidgetManagerMixin = {}
        function Hook.UIWidgetManagerMixin:OnWidgetContainerRegistered(widgetContainer)
            Util.Mixin(widgetContainer, Hook.UIWidgetContainerMixin)
        end
    end
end

do --[[ AddOns\Blizzard_UIWidgets.xml ]]
    do --[[ Blizzard_UIWidgetTemplateDoubleStatusBar ]]
        function Skin.UIWidgetTemplateDoubleStatusBar_StatusBarTemplate(StatusBar)
            Skin.FrameTypeStatusBar(StatusBar)

            StatusBar.BG:SetAlpha(0)
            StatusBar.BorderLeft:SetAlpha(0)
            StatusBar.BorderRight:SetAlpha(0)
            StatusBar.BorderCenter:SetAlpha(0)
            StatusBar.Spark:SetAlpha(0)
            StatusBar.SparkGlow:SetAlpha(0)
            StatusBar.BorderGlow:SetAllPoints(StatusBar)
            StatusBar.BorderGlow:SetTexCoord(0.025, 0.975, 0.19354838709677, 0.80645161290323)
        end
        function Skin.UIWidgetTemplateDoubleStatusBar(Frame)
            Skin.UIWidgetTemplateDoubleStatusBar_StatusBarTemplate(Frame.LeftBar)
            Skin.UIWidgetTemplateDoubleStatusBar_StatusBarTemplate(Frame.RightBar)
        end
    end
end

function private.AddOns.Blizzard_UIWidgets()
    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_UIWidgetManager    --
    ----====####$$$$%%%%$$$$####====----
    Util.Mixin(_G.UIWidgetManager, Hook.UIWidgetManagerMixin)


    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_UIWidgetTopCenterFrame --
    ----====####$$$$%%%%%$$$$####====----
    Util.Mixin(_G.UIWidgetTopCenterContainerFrame, Hook.UIWidgetContainerMixin)


    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetBelowMinimapFrame --
    ----====####$$$$%%%%%%%%$$$$####====----
    Util.Mixin(_G.UIWidgetBelowMinimapContainerFrame, Hook.UIWidgetContainerMixin)
end
