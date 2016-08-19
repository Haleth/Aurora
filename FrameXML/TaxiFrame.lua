local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    local TaxiFrame = _G.TaxiFrame
	TaxiFrame:DisableDrawLayer("BORDER")
	TaxiFrame:DisableDrawLayer("OVERLAY")
	TaxiFrame.Bg:Hide()
	TaxiFrame.TitleBg:Hide()
	TaxiFrame.TopTileStreaks:Hide()

	F.SetBD(TaxiFrame, 3, -23, -5, 3)
	F.ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", _G.TaxiRouteMap, "TOPRIGHT", -6, -6)
end)
