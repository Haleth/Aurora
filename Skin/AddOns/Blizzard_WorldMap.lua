local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_WorldMap.lua ]]
    do --[[ Blizzard_WorldMap.lua ]]
        Hook.WorldMapMixin = {}
        function Hook.WorldMapMixin:Minimize()
            self.NavBar:SetPoint("TOPLEFT", self.TitleCanvasSpacerFrame, 5, -30)
        end
        function Hook.WorldMapMixin:Maximize()
            --self.NavBar:SetPoint("TOPLEFT", self.TitleCanvasSpacerFrame, 4, -25)
        end
        function Hook.WorldMapMixin:AddOverlayFrame(templateName, templateType, anchorPoint, relativeTo, relativePoint, offsetX, offsetY)
            if Skin[templateName] then
                Skin[templateName](self.overlayFrames[#self.overlayFrames])
            end
        end
    end
end

do --[[ AddOns\Blizzard_WorldMap.xml ]]
    do --[[ Blizzard_WorldMapTemplates.xml ]]
        function Skin.WorldMapFloorNavigationFrameTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
        function Skin.WorldMapTrackingOptionsButtonTemplate(Button)
            Button.Background:Hide()
            Button.Border:Hide()

            local tex = Button:GetHighlightTexture()
            tex:SetTexture([[Interface\Minimap\Tracking\None]], "ADD")
            tex:SetAllPoints(Button.Icon)
        end
        function Skin.WorldMapTrackingPinButtonTemplate(Button)
        end
        function Skin.WorldMapNavBarButtonTemplate(Frame) -- not isPatch
            Skin.NavButtonTemplate()
        end
        function Skin.WorldMapNavBarTemplate(Frame)
            Skin.NavBarTemplate(Frame)  -- this is skinned from hooks in NavigationBar.lua
            Frame.InsetBorderBottomLeft:Hide()
            Frame.InsetBorderBottomRight:Hide()
            Frame.InsetBorderBottom:Hide()
            Frame.InsetBorderLeft:Hide()
            Frame.InsetBorderRight:Hide()
        end

        local function SkinQuestToggle(Button, arrowDir)
            Skin.FrameTypeButton(Button)
            Button:SetAllPoints()

            local arrow = Button:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", 5, -9)
            arrow:SetPoint("BOTTOMRIGHT", -20, 9)
            arrow:SetVertexColor(Color.yellow:GetRGB())
            Base.SetTexture(arrow, "arrow"..arrowDir)

            local quest = Button:CreateTexture(nil, "ARTWORK")
            quest:SetAtlas("questlog-waypoint-finaldestination-questionmark", true)
            quest:SetPoint("TOPLEFT", 11, -1)
        end
        function Skin.WorldMapSidePanelToggleTemplate(Frame)
            SkinQuestToggle(Frame.OpenButton, "Right")
            SkinQuestToggle(Frame.CloseButton, "Left")
        end
        function Skin.WorldMapZoneTimerTemplate(Frame)
        end
    end

    do --[[ Blizzard_WorldMap.xml ]]
        function Skin.WorldMapFrameTemplate(Frame)
            Skin.MapCanvasFrameTemplate(Frame)
            Skin.MapCanvasFrameScrollContainerTemplate(Frame.ScrollContainer)
        end
    end

end

function private.AddOns.Blizzard_WorldMap()
    ----====####$$$$%%%%%$$$$####====----
    --        Blizzard_WorldMap        --
    ----====####$$$$%%%%%$$$$####====----
    local WorldMapFrame = _G.WorldMapFrame
    Skin.WorldMapFrameTemplate(WorldMapFrame)
    if private.isRetail then
        Util.Mixin(WorldMapFrame, Hook.WorldMapMixin)

        Skin.PortraitFrameTemplate(WorldMapFrame.BorderFrame)
        WorldMapFrame.BorderFrame:SetFrameStrata(WorldMapFrame:GetFrameStrata())

        WorldMapFrame.BorderFrame.InsetBorderTop:Hide()
        Skin.MainHelpPlateButton(WorldMapFrame.BorderFrame.Tutorial)
        WorldMapFrame.BorderFrame.Tutorial:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", -15, 15)
        Skin.MaximizeMinimizeButtonFrameTemplate(WorldMapFrame.BorderFrame.MaximizeMinimizeFrame)

        Skin.WorldMapFloorNavigationFrameTemplate(WorldMapFrame.overlayFrames[1])
        Skin.WorldMapTrackingOptionsButtonTemplate(WorldMapFrame.overlayFrames[2])
        WorldMapFrame.overlayFrames[2]:SetPoint("TOPRIGHT", WorldMapFrame:GetCanvasContainer(), "TOPRIGHT", 0, 0)
        if private.isPatch then
            Skin.WorldMapTrackingPinButtonTemplate(WorldMapFrame.overlayFrames[3])
            Skin.WorldMapBountyBoardTemplate(WorldMapFrame.overlayFrames[4])
            Skin.WorldMapActionButtonTemplate(WorldMapFrame.overlayFrames[5])
            Skin.WorldMapZoneTimerTemplate(WorldMapFrame.overlayFrames[6])
        else
            Skin.WorldMapBountyBoardTemplate(WorldMapFrame.overlayFrames[3])
            Skin.WorldMapActionButtonTemplate(WorldMapFrame.overlayFrames[4])
            Skin.WorldMapZoneTimerTemplate(WorldMapFrame.overlayFrames[5])
        end

        Skin.WorldMapNavBarTemplate(WorldMapFrame.NavBar)
        WorldMapFrame.NavBar:SetPoint("BOTTOMRIGHT", WorldMapFrame.TitleCanvasSpacerFrame, -5, 5)

        Skin.WorldMapSidePanelToggleTemplate(WorldMapFrame.SidePanelToggle)
    else
        Base.SetBackdrop(WorldMapFrame.BorderFrame)

        local top1, top2, top3, top4, mid1, mid2, mid3, mid4, bot1, bot2, bot3, bot4, title = WorldMapFrame.BorderFrame:GetRegions()
        top1:Hide()
        top2:Hide()
        top3:Hide()
        top4:Hide()
        mid1:Hide()
        mid2:Hide()
        mid3:Hide()
        mid4:Hide()
        bot1:Hide()
        bot2:Hide()
        bot3:Hide()
        bot4:Hide()

        local bg = WorldMapFrame.BorderFrame:GetBackdropTexture("bg")
        title:ClearAllPoints()
        title:SetPoint("TOPLEFT", bg)
        title:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Skin.UIDropDownMenuTemplate(WorldMapFrame.ContinentDropDown)
        Skin.UIDropDownMenuTemplate(WorldMapFrame.ZoneDropDown)
        Skin.UIPanelButtonTemplate(_G.WorldMapZoomOutButton)
        Skin.UIPanelCloseButton(_G.WorldMapFrameCloseButton)
    end
end

