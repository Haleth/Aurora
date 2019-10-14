local _, private = ...

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
        if self.SelectedHighlight:IsShown() then
            local _, button = self.SelectedHighlight:GetPoint()
            self.SelectedHighlight:ClearAllPoints()
            self.SelectedHighlight:SetAllPoints(button)
        end
    end
end

do --[[ FrameXML\ScrollList.xml ]]
    function Skin.ScrollListLineTemplate(Button)
        -- AuctionHouseAuctionsSummaryLineTemplate sets NormalTexture to nil
        --local normal = Button:GetNormalTexture()
        --normal:SetColorTexture(Color.highlight:GetRGB())
        --normal:SetAlpha(0.5)

        Button:GetHighlightTexture():SetColorTexture(Color.highlight:GetRGB())
        Button:GetHighlightTexture():SetAlpha(0.5)
    end
    function Skin.ScrollListLineTextTemplate(Button)
        Skin.ScrollListLineTemplate(Button)
    end
    function Skin.ScrollListTemplate(Frame)
        Frame.SelectedHighlight:SetColorTexture(Color.highlight:GetRGB())
        Frame.SelectedHighlight:SetAlpha(0.5)

        Skin.HybridScrollBarTemplate(Frame.ScrollFrame.scrollBar)
        Frame.ScrollFrame.scrollBar.Background:Hide()
        Skin.InsetFrameTemplate(Frame.InsetFrame)
    end
end

function private.SharedXML.ScrollList()
    Util.Mixin(_G.ScrollListMixin, Hook.ScrollListMixin)
end
