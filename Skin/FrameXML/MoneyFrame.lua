local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin, Hook = Aurora.Base, Aurora.Skin, Aurora.Hook

do --[[ FrameXML\MoneyFrame.lua ]]
    function Hook.MoneyFrame_Update(frameName, money, forceShow)
        local moneyFrame
        if ( _G.type(frameName) == "table" ) then
            moneyFrame = frameName
            frameName = moneyFrame:GetName()
        else
            moneyFrame = _G[frameName]
        end

        if moneyFrame._auroraMoneyBG then
            local copperButton = _G[frameName.."CopperButton"]
            copperButton:ClearAllPoints()
            copperButton:SetPoint("BOTTOMRIGHT", frameName, -2, 2)
        end
    end
    function Hook.MoneyFrame_Update(moneyFrame, width)
        if moneyFrame._auroraMoneyBG then
            moneyFrame._auroraMoneyBG:SetWidth(width)
        end
    end
end

do --[[ FrameXML\MoneyFrame.xml ]]
    function Skin.SmallDenominationTemplate(button)
        local name = button:GetName()
        Base.CropIcon(_G[name.."Texture"], button)
    end
    function Skin.SmallAlternateCurrencyFrameTemplate(frame)
        local name = frame:GetName()
        Skin.SmallDenominationTemplate(_G[name.."Item1"])
        Skin.SmallDenominationTemplate(_G[name.."Item2"])
        Skin.SmallDenominationTemplate(_G[name.."Item3"])
    end
end

function private.FrameXML.MoneyFrame()
    _G.hooksecurefunc("MoneyFrame_Update", Hook.MoneyFrame_Update)
    _G.hooksecurefunc("MoneyFrame_SetMaxDisplayWidth", Hook.MoneyFrame_Update)
end
