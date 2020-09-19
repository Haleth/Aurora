local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_UIWidgets.lua ]]
    do --[[ Blizzard_UIWidgetManager ]]
        Hook.UIWidgetContainerMixin = {}
        function Hook.UIWidgetContainerMixin:CreateWidget(widgetID, widgetType, widgetTypeInfo, widgetInfo)
            local template = widgetTypeInfo.templateInfo.frameTemplate

            local widgetFrame = self.widgetFrames[widgetID]
            if Skin[template] then
                if widgetFrame and not widgetFrame._auroraSkinned then
                    Skin[template](widgetFrame)
                    widgetFrame._auroraSkinned = true
                end
            else
                private.debug("UIWidgetContainerMixin:CreateWidget Missing Template", widgetFrame and widgetFrame:GetDebugName(), template)
            end
        end

        Hook.UIWidgetManagerMixin = {}
        if private.isRetail then
            function Hook.UIWidgetManagerMixin:OnWidgetContainerRegistered(widgetContainer)
                local setWidgets = _G.C_UIWidgetManager.GetAllWidgetsBySetID(widgetContainer.widgetSetID)
                local widgetID, widgetType, widgetTypeInfo, widgetVisInfo
                for _, widgetInfo in next, setWidgets do
                    widgetID, widgetType = widgetInfo.widgetID, widgetInfo.widgetType
                    widgetTypeInfo = _G.UIWidgetManager:GetWidgetTypeInfo(widgetType)
                    widgetVisInfo = widgetTypeInfo.visInfoDataFunction(widgetID)

                    Hook.UIWidgetContainerMixin.CreateWidget(widgetContainer, widgetID, widgetType, widgetTypeInfo, widgetVisInfo)
                end

                Util.Mixin(widgetContainer, Hook.UIWidgetContainerMixin)
            end
        else
            function Hook.UIWidgetManagerMixin:CreateWidget(widgetID, widgetSetID, widgetType)
                if self.widgetVisTypeInfo[widgetType] then
                    Hook.UIWidgetContainerMixin.CreateWidget(self, widgetID, widgetType, self.widgetVisTypeInfo[widgetType])
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_UIWidgets.xml ]]
    do --[[ Blizzard_UIWidgetTemplateBase ]]
        function Skin.UIWidgetBaseStatusBarTemplate(StatusBar)
            Skin.FrameTypeStatusBar(StatusBar)
        end
        function Skin.UIWidgetBaseSpellTemplate(Frame)
            Base.CropIcon(Frame.Icon, Frame)

            Frame.Border:SetAlpha(0)
            Frame.DebuffBorder:SetAlpha(0)
        end
    end
    do --[[ Blizzard_UIWidgetTemplateDoubleStatusBar ]]
        function Skin.UIWidgetTemplateDoubleStatusBar_StatusBarTemplate(StatusBar)
            Skin.UIWidgetBaseStatusBarTemplate(StatusBar)

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
            Skin.UIWidgetBaseStatusBarTemplate(StatusBar)
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
    do --[[ Blizzard_UIWidgetTemplateSpellDisplay ]]
        function Skin.UIWidgetTemplateSpellDisplay(Frame)
            Skin.UIWidgetBaseSpellTemplate(Frame.Spell)
        end
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


    ----====####$$$$%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateTextureAndText --
    ----====####$$$$%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateSpellDisplay --
    ----====####$$$$%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateDoubleStateIconRow --
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateTextureAndTextRow --
    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateZoneControl --
    ----====####$$$$%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateCaptureZone --
    ----====####$$$$%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_UIWidgetTopCenterFrame --
    ----====####$$$$%%%%%$$$$####====----
    if private.isRetail then
        Util.Mixin(_G.UIWidgetTopCenterContainerFrame, Hook.UIWidgetContainerMixin)
    end


    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetBelowMinimapFrame --
    ----====####$$$$%%%%%%%%$$$$####====----
    if private.isRetail then
        Util.Mixin(_G.UIWidgetBelowMinimapContainerFrame, Hook.UIWidgetContainerMixin)
    end


    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_UIWidgetPowerBarFrame --
    ----====####$$$$%%%%$$$$####====----


end
