local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\ScrollList.lua ]]
--end

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
        Skin.TemplatedListTemplate(Frame)
        Skin.HybridScrollBarTemplate(Frame.ScrollFrame.scrollBar)
        Frame.ScrollFrame.scrollBar.Background:Hide()
        Skin.InsetFrameTemplate(Frame.InsetFrame)
    end
end

--function private.SharedXML.ScrollList()
--end
