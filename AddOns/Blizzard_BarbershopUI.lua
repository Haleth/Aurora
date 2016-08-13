-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(_G.select(2, ...))

C.themes["Blizzard_BarbershopUI"] = function()
	local BarberShopFrame = _G.BarberShopFrame
	BarberShopFrame:GetRegions():Hide()
	_G.BarberShopFrameMoneyFrame:GetRegions():Hide()
	_G.BarberShopAltFormFrameBackground:Hide()
	_G.BarberShopAltFormFrameBorder:Hide()

	_G.BarberShopAltFormFrame:ClearAllPoints()
	_G.BarberShopAltFormFrame:SetPoint("BOTTOM", BarberShopFrame, "TOP", 0, -74)

	F.SetBD(BarberShopFrame, 44, -75, -40, 44)
	F.SetBD(_G.BarberShopAltFormFrame, 0, 0, 2, -2)

	F.Reskin(_G.BarberShopFrameOkayButton)
	F.Reskin(_G.BarberShopFrameCancelButton)
	F.Reskin(_G.BarberShopFrameResetButton)

	for i = 1, #BarberShopFrame.Selector do
		local prevBtn, nextBtn = BarberShopFrame.Selector[i]:GetChildren()
		F.ReskinArrow(prevBtn, "left")
		F.ReskinArrow(nextBtn, "right")
	end

	-- [[ Banner frame ]]

	_G.BarberShopBannerFrameBGTexture:Hide()

	F.SetBD(_G.BarberShopBannerFrame, 25, -80, -20, 75)
end
