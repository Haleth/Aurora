local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_BarbershopUI.lua ]]
--end

do --[[ AddOns\Blizzard_BarbershopUI.xml ]]
    function Skin.BarberShopButtonTemplate(Button)
        Skin.SharedButtonLargeTemplate(Button)
    end
end

function private.AddOns.Blizzard_BarbershopUI()
    local BarberShopFrame = _G.BarberShopFrame
    Skin.BarberShopButtonTemplate(BarberShopFrame.CancelButton)
    Skin.BarberShopButtonTemplate(BarberShopFrame.ResetButton)
    Skin.BarberShopButtonTemplate(BarberShopFrame.AcceptButton)
end
