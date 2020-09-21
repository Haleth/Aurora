local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\ItemRef.lua ]]
--end

--do --[[ FrameXML\ItemRef.xml ]]
--end

function private.FrameXML.ItemRef()
    if private.disabled.tooltips then return end

    Skin.ShoppingTooltipTemplate(_G.ItemRefShoppingTooltip1)
    Skin.ShoppingTooltipTemplate(_G.ItemRefShoppingTooltip2)

    Skin.GameTooltipTemplate(_G.ItemRefTooltip)
    if private.isPatch then
        Skin.UIPanelCloseButton(_G.ItemRefTooltip.CloseButton)
    else
        Skin.UIPanelCloseButton(_G.ItemRefCloseButton)
    end
end
