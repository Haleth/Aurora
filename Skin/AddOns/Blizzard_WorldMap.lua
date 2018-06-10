local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_WorldMap.lua ]]
    ----====####$$$$%%%%%$$$$####====----
    --        Blizzard_WorldMap        --
    ----====####$$$$%%%%%$$$$####====----
    function Hook.WorldMapMixin_Minimize(self)
        self.NavBar:SetPoint("TOPLEFT", self.TitleCanvasSpacerFrame, 5, -30)
    end
    function Hook.WorldMapMixin_Maximize(self)
        --self.NavBar:SetPoint("TOPLEFT", self.TitleCanvasSpacerFrame, 4, -25)
    end
    function Hook.WorldMapMixin_AddOverlayFrame(self, templateName, templateType, anchorPoint, relativeTo, relativePoint, offsetX, offsetY)
        Skin[templateName](self.overlayFrames[#self.overlayFrames])
    end
end

do --[[ AddOns\Blizzard_WorldMap.xml ]]
    ----====####$$$$%%%%%$$$$####====----
    --        Blizzard_WorldMap        --
    ----====####$$$$%%%%%$$$$####====----
    function Skin.WorldMapFrameTemplate(Frame)
        Skin.MapCanvasFrameTemplate(Frame)
        Skin.MapCanvasFrameScrollContainerTemplate(Frame.ScrollContainer)
    end

    ----====####$$$$%%%%$$$$####====----
    --   Blizzard_WorldMapTemplates   --
    ----====####$$$$%%%%$$$$####====----
    function Skin.WorldMapFloorNavigationFrameTemplate(Frame)
        Skin.UIDropDownMenuTemplate(Frame)
    end
    function Skin.WorldMapTrackingOptionsButtonTemplate(Button)
        local shadow = Button:GetRegions()
        shadow:SetPoint("TOPRIGHT", 4, 0)

        Button.Background:Hide()
        Button.IconOverlay:SetAlpha(0)
        Button.Border:Hide()

        local tex = Button:GetHighlightTexture()
        tex:SetTexture([[Interface\Minimap\Tracking\None]], "ADD")
        tex:SetAllPoints(Button.Icon)
    end
    function Skin.WorldMapNavBarButtonTemplate(Frame)
        Skin.NavButtonTemplate()
    end
    function Skin.WorldMapNavBarTemplate(Frame)
        -- Skin.NavBarTemplate(Frame)  -- this is skinned from hooks in NavigationBar.lua
        Frame.InsetBorderBottomLeft:Hide()
        Frame.InsetBorderBottomRight:Hide()
        Frame.InsetBorderBottom:Hide()
        Frame.InsetBorderLeft:Hide()
        Frame.InsetBorderRight:Hide()
    end

    local function SkinQuestToggle(Button, arrowDir)
        Button:SetAllPoints()

        local shadow = Button:GetRegions()
        Scale.Atlas(shadow, "MapCornerShadow-Right", true)

        local arrow = Button:CreateTexture(nil, "ARTWORK")
        Base.SetTexture(arrow, "arrow"..arrowDir)
        arrow:SetPoint("TOPLEFT", 5, -9)
        arrow:SetPoint("BOTTOMRIGHT", -20, 9)
        arrow:SetVertexColor(Color.yellow:GetRGB())

        local quest = Button:CreateTexture(nil, "ARTWORK")
        quest:SetTexture([[Interface/QuestFrame/QuestMapLogAtlas]])
        quest:SetTexCoord(0.5390625, 0.556640625, 0.7265625, 0.75)
        quest:SetPoint("TOPLEFT", 14, -5)
        quest:SetPoint("BOTTOMRIGHT", -1, 3)

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetHighlightTexture("")
        Base.SetBackdrop(Button, Color.button)
        Base.SetHighlight(Button, "backdrop")
    end
    function Skin.WorldMapSidePanelToggleTemplate(Frame)
        SkinQuestToggle(Frame.OpenButton, "Right")
        SkinQuestToggle(Frame.CloseButton, "Left")

        --[[ Scale ]]--
        Frame:SetSize(32, 32)
    end
    function Skin.WorldMapZoneTimerTemplate(Frame)
    end
end

function private.AddOns.Blizzard_WorldMap()
    ----====####$$$$%%%%%$$$$####====----
    --        Blizzard_WorldMap        --
    ----====####$$$$%%%%%$$$$####====----
    local WorldMapFrame = _G.WorldMapFrame
    _G.hooksecurefunc(WorldMapFrame, "Minimize", Hook.WorldMapMixin_Minimize)
    _G.hooksecurefunc(WorldMapFrame, "Maximize", Hook.WorldMapMixin_Maximize)
    _G.hooksecurefunc(WorldMapFrame, "AddOverlayFrame", Hook.WorldMapMixin_AddOverlayFrame)
    Skin.WorldMapFrameTemplate(WorldMapFrame)

    Skin.PortraitFrameTemplate(WorldMapFrame.BorderFrame)
    WorldMapFrame.BorderFrame:SetFrameStrata(WorldMapFrame:GetFrameStrata())

    WorldMapFrame.BorderFrame.ButtonFrameEdge:Hide()
    WorldMapFrame.BorderFrame.InsetBorderTop:Hide()
    Skin.MainHelpPlateButton(WorldMapFrame.BorderFrame.Tutorial)
    WorldMapFrame.BorderFrame.Tutorial:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", -15, 15)
    Skin.MaximizeMinimizeButtonFrameTemplate(WorldMapFrame.BorderFrame.MaximizeMinimizeFrame)
    WorldMapFrame.BorderFrame.MaximizeMinimizeFrame:SetPoint("RIGHT", WorldMapFrame.BorderFrame.CloseButton, "LEFT", -5, 0)

    Skin.WorldMapFloorNavigationFrameTemplate(WorldMapFrame.overlayFrames[1])
    Skin.WorldMapTrackingOptionsButtonTemplate(WorldMapFrame.overlayFrames[2])
    Skin.WorldMapBountyBoardTemplate(WorldMapFrame.overlayFrames[3])
    Skin.WorldMapActionButtonTemplate(WorldMapFrame.overlayFrames[4])
    Skin.WorldMapZoneTimerTemplate(WorldMapFrame.overlayFrames[5])

    Skin.WorldMapNavBarTemplate(WorldMapFrame.NavBar)
    WorldMapFrame.NavBar:SetPoint("BOTTOMRIGHT", WorldMapFrame.TitleCanvasSpacerFrame, -5, 5)

    Skin.WorldMapSidePanelToggleTemplate(WorldMapFrame.SidePanelToggle)

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--


    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_WorldMapTooltip    --
    ----====####$$$$%%%%$$$$####====----
    if not private.disabled.tooltips then
        Skin.ShoppingTooltipTemplate(_G.WorldMapCompareTooltip1)
        Skin.ShoppingTooltipTemplate(_G.WorldMapCompareTooltip2)
        Skin.GameTooltipTemplate(_G.WorldMapTooltip)
        Skin.InternalEmbeddedItemTooltipTemplate(_G.WorldMapTooltip.ItemTooltip)
    end
end

