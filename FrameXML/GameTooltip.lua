local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local next = _G.next

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	if not _G.AuroraConfig.tooltips then return end

	local tooltips = {
		"GameTooltip",
		"ItemRefTooltip",
		"ShoppingTooltip1",
		"ShoppingTooltip2",
		"WorldMapTooltip",
		"ChatMenu",
		"EmoteMenu",
		"LanguageMenu",
		"VoiceMacroMenu",
	}

	local backdrop = {
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	}

	-- so other stuff which tries to look like GameTooltip doesn't mess up
	local getBackdrop = function()
		return backdrop
	end

	local getBackdropColor = function()
		return 0, 0, 0, .6
	end

	local getBackdropBorderColor = function()
		return 0, 0, 0
	end

	for i = 1, #tooltips do
		local t = _G[tooltips[i]]
		t:SetBackdrop(nil)

		local bg
		if t.BackdropFrame then
			bg = t.BackdropFrame
		else
			bg = _G.CreateFrame("Frame", nil, t)
			bg:SetFrameLevel(t:GetFrameLevel()-1)
		end
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
		bg:SetBackdrop(backdrop)
		bg:SetBackdropColor(0, 0, 0, .6)
		bg:SetBackdropBorderColor(0, 0, 0)

		t.GetBackdrop = getBackdrop
		t.GetBackdropColor = getBackdropColor
		t.GetBackdropBorderColor = getBackdropBorderColor
	end

	local sb = _G["GameTooltipStatusBar"]
	sb:SetHeight(3)
	sb:ClearAllPoints()
	sb:SetPoint("BOTTOMLEFT", _G.GameTooltip, "BOTTOMLEFT", 1, 1)
	sb:SetPoint("BOTTOMRIGHT", _G.GameTooltip, "BOTTOMRIGHT", -1, 1)
	sb:SetStatusBarTexture(C.media.backdrop)

	local sep = _G.GameTooltipStatusBar:CreateTexture(nil, "ARTWORK")
	sep:SetHeight(1)
	sep:SetPoint("BOTTOMLEFT", 0, 3)
	sep:SetPoint("BOTTOMRIGHT", 0, 3)
	sep:SetTexture(C.media.backdrop)
	sep:SetVertexColor(0, 0, 0)

	F.CreateBD(_G.FriendsTooltip)

	-- [[ Pet battle tooltips ]]

	local petTooltips = {"PetBattlePrimaryAbilityTooltip", "PetBattlePrimaryUnitTooltip", "FloatingBattlePetTooltip", "BattlePetTooltip", "FloatingPetBattleAbilityTooltip"}
	for _, tooltipName in next, petTooltips do
		local tooltip = _G[tooltipName]
		tooltip:DisableDrawLayer("BACKGROUND")
		local bg = _G.CreateFrame("Frame", nil, tooltip)
		bg:SetAllPoints()
		bg:SetFrameLevel(0)
		F.CreateBD(bg)

		if tooltip.Delimiter then
			tooltip.Delimiter:SetColorTexture(0, 0, 0)
			tooltip.Delimiter:SetHeight(1)
		elseif tooltip.Delimiter1 then
			tooltip.Delimiter1:SetHeight(1)
			tooltip.Delimiter1:SetColorTexture(0, 0, 0)
			tooltip.Delimiter2:SetHeight(1)
			tooltip.Delimiter2:SetColorTexture(0, 0, 0)
		end

		if tooltip.CloseButton then
			F.ReskinClose(tooltip.CloseButton)
		end
	end
end)
