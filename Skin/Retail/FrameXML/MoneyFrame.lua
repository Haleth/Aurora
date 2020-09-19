local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type floor mod

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\MoneyFrame.lua ]]
--end

do --[[ FrameXML\MoneyFrame.xml ]]
    Skin.SmallMoneyFrameTemplate = private.nop
    function Skin.SmallDenominationTemplate(Button)
        local name = Button:GetName()
        Base.CropIcon(_G[name.."Texture"], Button)
    end
    function Skin.SmallAlternateCurrencyFrameTemplate(Frame)
        local name = Frame:GetName()
        Skin.SmallDenominationTemplate(_G[name.."Item1"])
        Skin.SmallDenominationTemplate(_G[name.."Item2"])
        Skin.SmallDenominationTemplate(_G[name.."Item3"])
    end
end

--function private.FrameXML.MoneyFrame()
--end
