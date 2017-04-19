local _, private = ...

-- [[ Lua Globals ]]
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

	for i = 1, #tooltips do
		F.ReskinTooltip(_G[tooltips[i]])
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
