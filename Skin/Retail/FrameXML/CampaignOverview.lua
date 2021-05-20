local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\CampaignOverview.lua ]]
    local uiTextureKits = private.uiTextureKits

    Hook.CampaignOverviewMixin = {}
    function Hook.CampaignOverviewMixin:SetCampaign(campaignID)
        local campaignHeader = self.Header
        local campaign = campaignHeader.campaign
        if campaign then
            local kit = uiTextureKits[campaign.uiTextureKit]
            if not kit then
                kit = uiTextureKits.Default
                private.debug("missing campaign header", campaign.uiTextureKit)
            end
            campaignHeader.Background:SetTexture("")
            campaignHeader._auroraBG:SetColorTexture(kit.color:GetRGB())

            local overlay = campaignHeader._auroraOverlay
            overlay:SetPoint("CENTER", campaignHeader._auroraBG, "RIGHT", -25, 0)
            if kit.texture then
                overlay:SetTexture(kit.texture)
                overlay:SetSize(130, 130)

                overlay:SetBlendMode("ADD")
                overlay:SetVertexColor(1, 1, 1)
            else
                overlay:SetAtlas(kit.atlas)
                overlay:SetSize(66.33, 76.56)

                overlay:SetBlendMode("BLEND")
                overlay:SetVertexColor(0, 0, 0)
            end
            campaignHeader.HighlightTexture:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)
        end
    end
    function Hook.CampaignOverviewMixin:UpdateCampaignLoreText(campaignID, textEntries)
        local campaign, color = self.Header.campaign
        if campaign then
            color = uiTextureKits[campaign.uiTextureKit].color
        else
            color = Color.highlight
        end

        for texture in self.texturePool:EnumerateActive() do
            local _, line = texture:GetPoint()
            texture:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
            texture:SetTexCoord(0, 0.6640625, 0, 0.3125)
            texture:SetPoint("BOTTOM", line, 0, -8)
            texture:SetHeight(30)
            texture:SetDesaturated(true)
            texture:SetVertexColor(color:GetRGB())
        end
    end
end

do --[[ FrameXML\CampaignOverview.xml ]]
    function Skin.CampaignOverviewTemplate(Frame)
        Skin.CampaignHeaderDisplayTemplate(Frame.Header)
        Skin.UIPanelScrollFrameTemplate(Frame.ScrollFrame)

        Frame.ScrollFrame.Top:Hide()
        Frame.ScrollFrame.Bottom:Hide()
        Frame.ScrollFrame.Middle:Hide()
        Frame.ScrollFrame.TopShadow:Hide()
        Frame.ScrollFrame.BottomShadow:Hide()

        Frame.BG:Hide()

        Util.Mixin(Frame, Hook.CampaignOverviewMixin)
    end
end

function private.FrameXML.CampaignOverview()
    ----====####$$$$%%%%$$$$####====----
    --              CampaignOverview              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
