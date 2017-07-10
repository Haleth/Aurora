local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

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
    function Skin.SmallMoneyFrameTemplate(moneyFrame, addBackdrop)
        local moneyBG = _G.CreateFrame("Frame", nil, moneyFrame)
        moneyBG:SetSize(moneyFrame.maxDisplayWidth, 18)
        if addBackdrop then
            Aurora.Base.SetBackdrop(moneyBG)
            moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
        end

        moneyFrame._auroraMoneyBG = moneyBG
        moneyFrame:SetPoint("BOTTOMRIGHT", moneyBG)
        moneyFrame:SetPoint("TOPRIGHT", moneyBG)
        return moneyBG
    end
end

function private.FrameXML.MoneyFrame()
    _G.hooksecurefunc("MoneyFrame_Update", Hook.MoneyFrame_Update)
    _G.hooksecurefunc("MoneyFrame_SetMaxDisplayWidth", Hook.MoneyFrame_Update)
end
