local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_BarbershopUI"] = function()
	local BarberShopFrame = _G.BarberShopFrame
	for i = 1, BarberShopFrame:GetNumRegions() do
		local region = _G.select(i, BarberShopFrame:GetRegions())
		region:Hide()
	end
	F.SetBD(BarberShopFrame, 44, -75, -40, 44)

	for i = 1, #BarberShopFrame.Selector do
		local prevBtn, nextBtn = BarberShopFrame.Selector[i]:GetChildren()
		F.ReskinArrow(prevBtn, "left")
		F.ReskinArrow(nextBtn, "right")
	end

	_G.BarberShopFrameMoneyFrame:GetRegions():Hide()
	F.Reskin(_G.BarberShopFrameOkayButton)
	F.Reskin(_G.BarberShopFrameCancelButton)
	F.Reskin(_G.BarberShopFrameResetButton)

	F.SetBD(_G.BarberShopAltFormFrame, 0, 0, 2, -2)
	_G.BarberShopAltFormFrame:ClearAllPoints()
	_G.BarberShopAltFormFrame:SetPoint("BOTTOM", BarberShopFrame, "TOP", 0, -74)
	_G.BarberShopAltFormFrameBackground:Hide()
	_G.BarberShopAltFormFrameBorder:Hide()

	-- [[ Banner frame ]]

	_G.BarberShopBannerFrameBGTexture:Hide()

	F.SetBD(_G.BarberShopBannerFrame, 25, -80, -20, 75)
end
