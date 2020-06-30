local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
--local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\ScrollList.lua ]]
    Hook.ScrollListMixin = {}
    function Hook.ScrollListMixin:UpdatedSelectedHighlight()
        local selectedHighlight = self:GetSelectedHighlight()
        if selectedHighlight:IsShown() then
            local _, button = selectedHighlight:GetPoint()
            selectedHighlight:ClearAllPoints()
            selectedHighlight:SetAllPoints(button)
        end
    end
end

do --[[ FrameXML\ScrollList.xml ]]
    function Skin.ScrollListLineTemplate(Button)
        local normal = Button:GetNormalTexture()
        if normal then
            -- AuctionHouseAuctionsSummaryLineTemplate sets NormalTexture to nil
            --normal:SetColorTexture(Color.highlight:GetRGB())
            normal:SetAlpha(0)
        end

        Button:GetHighlightTexture():SetColorTexture(Color.highlight:GetRGB())
        Button:GetHighlightTexture():SetAlpha(0.5)
    end
    function Skin.ScrollListLineTextTemplate(Button)
        Skin.ScrollListLineTemplate(Button)
    end
    function Skin.ScrollListTemplate(Frame)
        local selectedHighlight = Frame:GetSelectedHighlight()
        selectedHighlight:SetColorTexture(Color.highlight:GetRGB())
        selectedHighlight:SetAlpha(0.5)

        Skin.HybridScrollBarTemplate(Frame.ScrollFrame.scrollBar)
        Frame.ScrollFrame.scrollBar.Background:Hide()
        Skin.InsetFrameTemplate(Frame.InsetFrame)
    end
end

function private.SharedXML.ScrollList()
    Util.Mixin(_G.ScrollListMixin, Hook.ScrollListMixin)
end
