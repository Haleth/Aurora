local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    function private.Skin.SmallMoneyFrameTemplate(moneyFrame, addBackdrop)
        local moneyBG = _G.CreateFrame("Frame", nil, moneyFrame)
        moneyBG:SetFrameLevel(moneyFrame:GetFrameLevel() - 1)
        moneyBG:SetSize(moneyFrame.maxDisplayWidth, 18)
        if addBackdrop then
            F.CreateBD(moneyBG, .25)
            moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
        end

        moneyFrame.auroraMoneyBG = moneyBG
        moneyFrame:SetPoint("BOTTOMRIGHT", moneyBG)
        moneyFrame:SetPoint("TOPRIGHT", moneyBG)
        return moneyBG
    end

    _G.hooksecurefunc("MoneyFrame_Update", function(frameName, money, forceShow)
        local moneyFrame;
        if ( _G.type(frameName) == "table" ) then
            moneyFrame = frameName;
            frameName = moneyFrame:GetName();
        else
            moneyFrame = _G[frameName];
        end

        if moneyFrame.auroraMoneyBG then
            local copperButton = _G[frameName.."CopperButton"]
            copperButton:ClearAllPoints();
            copperButton:SetPoint("BOTTOMRIGHT", frameName, -2, 2)
        end
    end)
    _G.hooksecurefunc("MoneyFrame_SetMaxDisplayWidth", function(moneyFrame, width)
        if moneyFrame.auroraMoneyBG then
            moneyFrame.auroraMoneyBG:SetWidth(width)
        end
    end)
end)
