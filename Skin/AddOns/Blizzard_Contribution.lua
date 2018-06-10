local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

--[[ do AddOns\Blizzard_Contribution.lua
end ]]

 --[[ doAddOns\Blizzard_Contribution.xml
end ]]

function private.AddOns.Blizzard_Contribution()
    if not private.disabled.tooltips then
        Skin.GameTooltipTemplate(_G.ContributionTooltip)
        Skin.InternalEmbeddedItemTooltipTemplate(_G.ContributionTooltip.ItemTooltip)

        Skin.TooltipBorderedFrameTemplate(_G.ContributionBuffTooltip)
        Base.CropIcon(_G.ContributionBuffTooltip.Icon, _G.ContributionBuffTooltip)
        _G.ContributionBuffTooltip.Border:Hide()
    end
end
