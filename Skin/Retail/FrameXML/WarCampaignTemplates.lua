local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\WarCampaignTemplates.lua ]]
    Hook.CampaignCollapseButtonMixin = {}
    function Hook.CampaignCollapseButtonMixin:UpdateState(isCollapsed)
        if isCollapsed then
            self:SetNormalTexture("Plus")
        else
            self:SetNormalTexture("Minus")
        end

        self:SetPushedTexture("")
    end
end

do --[[ FrameXML\WarCampaignTemplates.xml ]]
    function Skin.CampaignTooltipTemplate(Frame)
        Base.SetBackdrop(Frame)
        Skin.InternalEmbeddedItemTooltipTemplate(Frame.ItemTooltip)
    end
    function Skin.CampaignHeaderDisplayTemplate(Frame)
        local clipFrame = _G.CreateFrame("Frame", nil, Frame)
        clipFrame:SetFrameLevel(Frame:GetFrameLevel())
        clipFrame:SetPoint("TOPLEFT", 6, 0)
        clipFrame:SetPoint("TOPRIGHT", -5, 0)
        clipFrame:SetHeight(47)
        clipFrame:SetClipsChildren(true)
        Frame._clipFrame = clipFrame

        local BG = clipFrame:CreateTexture(nil, "BACKGROUND")
        BG:SetAllPoints()
        Frame._auroraBG = BG

        local overlay = clipFrame:CreateTexture(nil, "OVERLAY")
        overlay:SetDesaturated(true)
        overlay:SetAlpha(0.3)
        Frame._auroraOverlay = overlay

        Frame.TopFiligree:Hide()
        --Frame.Text:SetPoint("BOTTOMLEFT", Frame.Background, "LEFT", 43, 0)
        Frame.HighlightTexture:SetAllPoints(clipFrame)
    end
    function Skin.CampaignHeaderTemplate(Frame)
        Skin.CampaignHeaderDisplayTemplate(Frame)
        Skin.ExpandOrCollapse(Frame.CollapseButton)
        Frame.CollapseButton:SetBackdropOption("offsets", {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        })
        Util.Mixin(Frame.CollapseButton, Hook.CampaignCollapseButtonMixin)
    end
end

function private.FrameXML.WarCampaignTemplates()
end
