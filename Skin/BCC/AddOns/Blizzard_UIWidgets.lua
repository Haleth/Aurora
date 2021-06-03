local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_UIWidgets.lua ]]
    do --[[ Blizzard_UIWidgetManager ]]
        Hook.UIWidgetManagerMixin = {}
        function Hook.UIWidgetManagerMixin:CreateWidget(widgetID, widgetSetID, widgetType)
            if self.widgetVisTypeInfo[widgetType] then
                local widgetFrame = self.widgetIdToFrame[widgetID]
                if not widgetFrame then return end

                local template = self.widgetVisTypeInfo[widgetType].templateInfo.frameTemplate
                if Skin[template] then
                    if not widgetFrame._auroraSkinned then
                        Skin[template](widgetFrame)
                        widgetFrame._auroraSkinned = true
                    end
                else
                    private.debug("Missing template for UIWidgetContainerMixin", widgetFrame:GetDebugName(), template)
                end
            end
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
    do --[[ Blizzard_UIWidgetTemplateIconAndText ]]
        Skin.UIWidgetTemplateIconAndText = private.nop
    end
    do --[[ Blizzard_UIWidgetTemplateStatusBar ]]
        function Skin.UIWidgetTemplateStatusBar(Frame)
            local StatusBar = Frame.Bar
            Skin.FrameTypeStatusBar(StatusBar)
            StatusBar.BGLeft:SetAlpha(0)
            StatusBar.BGRight:SetAlpha(0)
            StatusBar.BGCenter:SetAlpha(0)
            StatusBar.BorderLeft:SetAlpha(0)
            StatusBar.BorderRight:SetAlpha(0)
            StatusBar.BorderCenter:SetAlpha(0)
            StatusBar.Spark:SetAlpha(0)
        end
    end
    do --[[ Blizzard_UIWidgetTemplateTextureWithState ]]
        Skin.UIWidgetTemplateTextureWithState = private.nop
    end
    do --[[ Blizzard_UIWidgetTemplateTextWithState ]]
        Skin.UIWidgetTemplateTextWithState = private.nop
    end
end

function private.AddOns.Blizzard_UIWidgets()
    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_UIWidgetManager    --
    ----====####$$$$%%%%$$$$####====----
    Util.Mixin(_G.UIWidgetManager, Hook.UIWidgetManagerMixin)


    ----====####$$$$%%%%%$$$$####====----
    --  Blizzard_UIWidgetTemplateBase  --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateIconAndText --
    ----====####$$$$%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateIconTextAndBackground --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateCaptureBar --
    ----====####$$$$%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateStatusBar --
    ----====####$$$$%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateDoubleStatusBar --
    ----====####$$$$%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateDoubleIconAndText --
    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateStackedResourceTracker --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateIconTextAndCurrencies --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateTextWithState --
    ----====####$$$$%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateHorizontalCurrencies --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateBulletTextList --
    ----====####$$$$%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateScenarioHeaderCurrenciesAndBackground --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_UIWidgetTopCenterFrame --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetBelowMinimapFrame --
    ----====####$$$$%%%%%%%%$$$$####====----
end
