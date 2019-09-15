local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

function private.FrameXML.TaxiFrame()
    local TaxiFrame = _G.TaxiFrame
    _G.TaxiPortrait:SetAlpha(0)
    for i = 2, 5 do
        select(i, _G.TaxiFrame:GetRegions()):Hide()
    end

    Base.SetBackdrop(TaxiFrame)
    _G.TaxiMerchant:SetPoint("TOP", 0, -5)
    Skin.UIPanelCloseButton(_G.TaxiCloseButton)
    _G.TaxiCloseButton:SetPoint("TOPRIGHT", 4, 4)
end
