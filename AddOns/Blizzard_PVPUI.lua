local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_PVPUI"] = function()
	local r, g, b = C.r, C.g, C.b

	local PVPQueueFrame = _G.PVPQueueFrame
	local HonorFrame = _G.HonorFrame
	local ConquestFrame = _G.ConquestFrame
	local WarGamesFrame = _G.WarGamesFrame

	-- Category buttons

	for i = 1, 4 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		local icon = bu.Icon
		local cu = bu.CurrencyDisplay

		bu.Ring:Hide()

		F.Reskin(bu, true)

		bu.Background:SetAllPoints()
		bu.Background:SetColorTexture(r, g, b, .2)
		bu.Background:Hide()

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		icon.bg = F.CreateBG(icon)
		icon.bg:SetDrawLayer("ARTWORK")

		if cu then
			local ic = cu.Icon

			ic:SetSize(16, 16)
			ic:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
			cu.Amount:SetPoint("LEFT", ic, "RIGHT", 4, 0)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic.bg = F.CreateBG(ic)
			ic.bg:SetDrawLayer("BACKGROUND", 1)
		end
	end

	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

	hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
		local self = PVPQueueFrame
		for i = 1, 4 do
			local bu = self["CategoryButton"..i]
			if i == index then
				bu.Background:Show()
			else
				bu.Background:Hide()
			end
		end
	end)

	PVPQueueFrame.CategoryButton1.Background:Show()

	-- Honor frame

	local Inset = HonorFrame.Inset
	local BonusFrame = HonorFrame.BonusFrame

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	BonusFrame.WorldBattlesTexture:Hide()
	BonusFrame.ShadowOverlay:Hide()

	F.Reskin(BonusFrame.DiceButton)

	for _, bonusButton in pairs({"RandomBGButton", "Arena1Button", "AshranButton"}) do
		local bu = BonusFrame[bonusButton]
		local reward = bu.Reward

		F.Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()

		if reward then
			reward.Border:Hide()
			F.ReskinIcon(reward.Icon)
		end
	end

	_G.IncludedBattlegroundsDropDown:SetPoint("TOPRIGHT", BonusFrame.DiceButton, 40, 26)

	-- Role buttons

	local RoleInset = HonorFrame.RoleInset

	RoleInset:DisableDrawLayer("BACKGROUND")
	RoleInset:DisableDrawLayer("BORDER")

	for _, roleButton in pairs({RoleInset.HealerIcon, RoleInset.TankIcon, RoleInset.DPSIcon}) do
		roleButton.cover:SetTexture(C.media.roleIcons)
		roleButton:SetNormalTexture(C.media.roleIcons)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

		for i = 1, 2 do
			local left = roleButton:CreateTexture()
			left:SetDrawLayer("OVERLAY", i)
			left:SetWidth(1)
			left:SetTexture(C.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", roleButton, 6, -4)
			left:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			roleButton["leftLine"..i] = left

			local right = roleButton:CreateTexture()
			right:SetDrawLayer("OVERLAY", i)
			right:SetWidth(1)
			right:SetTexture(C.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", roleButton, -6, -4)
			right:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["rightLine"..i] = right

			local top = roleButton:CreateTexture()
			top:SetDrawLayer("OVERLAY", i)
			top:SetHeight(1)
			top:SetTexture(C.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", roleButton, 6, -4)
			top:SetPoint("TOPRIGHT", roleButton, -6, -4)
			roleButton["topLine"..i] = top

			local bottom = roleButton:CreateTexture()
			bottom:SetDrawLayer("OVERLAY", i)
			bottom:SetHeight(1)
			bottom:SetTexture(C.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			bottom:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["bottomLine"..i] = bottom
		end

		roleButton.leftLine2:Hide()
		roleButton.rightLine2:Hide()
		roleButton.topLine2:Hide()
		roleButton.bottomLine2:Hide()

		F.ReskinCheck(roleButton.checkButton)
	end

	-- Honor frame specific

	for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		F.CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		bu.tex = F.CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints(bu.tex)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = F.CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end

	-- Conquest Frame

	Inset = ConquestFrame.Inset

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	ConquestFrame.ArenaTexture:Hide()
	ConquestFrame.RatedBGTexture:Hide()
	ConquestFrame.ArenaHeader:Hide()
	ConquestFrame.RatedBGHeader:Hide()
	ConquestFrame.ShadowOverlay:Hide()

	F.CreateBD(_G.ConquestTooltip)

	local ConquestFrameButton_OnEnter = function(self)
		_G.ConquestTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, 0)
	end

	ConquestFrame.Arena2v2:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.Arena3v3:HookScript("OnEnter", ConquestFrameButton_OnEnter)
	ConquestFrame.RatedBG:HookScript("OnEnter", ConquestFrameButton_OnEnter)

	for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.RatedBG}) do
		F.Reskin(bu, true)
		local reward = bu.Reward

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()

		if reward then
			reward.Border:Hide()
			F.ReskinIcon(reward.Icon)
		end
	end

	ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)

	-- War games

	Inset = WarGamesFrame.RightInset

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	WarGamesFrame.InfoBG:Hide()
	WarGamesFrame.HorizontalBar:Hide()
	_G.WarGamesFrameInfoScrollFrame.scrollBarBackground:Hide()
	_G.WarGamesFrameInfoScrollFrame.scrollBarArtTop:Hide()
	_G.WarGamesFrameInfoScrollFrame.scrollBarArtBottom:Hide()

	_G.WarGamesFrameDescription:SetTextColor(.9, .9, .9)

	local function onSetNormalTexture(self, texture)
		if texture:find("Plus") then
			self.plus:Show()
		else
			self.plus:Hide()
		end
	end

	for _, button in pairs(WarGamesFrame.scrollFrame.buttons) do
		local bu = button.Entry
		local SelectedTexture = bu.SelectedTexture

		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		F.CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		local tex = F.CreateGradient(bu)
		tex:SetDrawLayer("BACKGROUND")
		tex:SetPoint("TOPLEFT", 3, -1)
		tex:SetPoint("BOTTOMRIGHT", -2, 3)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetColorTexture(r, g, b, .2)
		SelectedTexture:SetPoint("TOPLEFT", 2, 0)
		SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = F.CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)

		local header = button.Header

		header:GetNormalTexture():SetAlpha(0)
		header:SetHighlightTexture("")
		header:SetPushedTexture("")

		local headerBg = CreateFrame("Frame", nil, header)
		headerBg:SetSize(13, 13)
		headerBg:SetPoint("LEFT", 4, 0)
		headerBg:SetFrameLevel(header:GetFrameLevel()-1)
		F.CreateBD(headerBg, 0)

		local headerTex = F.CreateGradient(header)
		headerTex:SetAllPoints(headerBg)

		local minus = header:CreateTexture(nil, "OVERLAY")
		minus:SetSize(7, 1)
		minus:SetPoint("CENTER", headerBg)
		minus:SetTexture(C.media.backdrop)
		minus:SetVertexColor(1, 1, 1)

		local plus = header:CreateTexture(nil, "OVERLAY")
		plus:SetSize(1, 7)
		plus:SetPoint("CENTER", headerBg)
		plus:SetTexture(C.media.backdrop)
		plus:SetVertexColor(1, 1, 1)
		header.plus = plus

		hooksecurefunc(header, "SetNormalTexture", onSetNormalTexture)
	end

	F.ReskinCheck(_G.WarGameTournamentModeCheckButton)

	-- Main style

	F.Reskin(HonorFrame.QueueButton)
	F.Reskin(ConquestFrame.JoinButton)
	F.Reskin(_G.WarGameStartButton)
	F.ReskinDropDown(_G.HonorFrameTypeDropDown)
	F.ReskinScroll(_G.HonorFrameSpecificFrameScrollBar)
	F.ReskinScroll(_G.WarGamesFrameScrollFrameScrollBar)
	F.ReskinScroll(_G.WarGamesFrameInfoScrollFrameScrollBar)
end
