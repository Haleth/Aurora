local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	if not _G.AuroraConfig.loot then return end

	--[[ LootFrame ]]--
	_G.LootFramePortraitOverlay:Hide()

	select(19, _G.LootFrame:GetRegions()):SetPoint("TOP", _G.LootFrame, "TOP", 0, -7)

	for index = 1, 4 do
		local item = _G["LootButton"..index]
		local icon = _G["LootButton"..index.."IconTexture"]
		item._auroraBG = F.ReskinIcon(icon)

		_G["LootButton"..index.."IconQuestTexture"]:SetTexCoord(.08, .92, .08, .92)
		local nameFrame = _G["LootButton"..index.."NameFrame"]
		nameFrame:Hide()

		local bg = F.CreateBDFrame(nameFrame, .2)
		bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 3, 1)
		bg:SetPoint("BOTTOMRIGHT", nameFrame, -5, 11)

		item:SetNormalTexture("")
		item:SetPushedTexture("")
	end

	hooksecurefunc("LootFrame_UpdateButton", function(index)
		if _G["LootButton"..index.."IconQuestTexture"]:IsShown() then
			_G["LootButton"..index]._auroraBG:SetBackdropBorderColor(1, 1, 0)
		end
	end)

	_G.LootFrameDownButton:ClearAllPoints()
	_G.LootFrameDownButton:SetPoint("BOTTOMRIGHT", -8, 6)
	_G.LootFramePrev:ClearAllPoints()
	_G.LootFramePrev:SetPoint("LEFT", _G.LootFrameUpButton, "RIGHT", 4, 0)
	_G.LootFrameNext:ClearAllPoints()
	_G.LootFrameNext:SetPoint("RIGHT", _G.LootFrameDownButton, "LEFT", -4, 0)

	F.ReskinPortraitFrame(_G.LootFrame, true)
	F.ReskinArrow(_G.LootFrameUpButton, "Up")
	F.ReskinArrow(_G.LootFrameDownButton, "Down")


	--[[ MasterLooterFrame ]]--
	local MasterLooterFrame = _G.MasterLooterFrame
	for i = 1, 9 do
		select(i, MasterLooterFrame:GetRegions()):Hide()
	end
	F.CreateBD(MasterLooterFrame)
	F.ReskinClose(select(3, MasterLooterFrame:GetChildren()))

	local item = MasterLooterFrame.Item
	item.NameBorderLeft:Hide()
	item.NameBorderRight:Hide()
	item.NameBorderMid:Hide()
	item._auroraBG = F.ReskinIcon(item.Icon)

	MasterLooterFrame:HookScript("OnShow", function(MLFrame)
		_G.LootFrame:SetAlpha(.4)
	end)

	MasterLooterFrame:HookScript("OnHide", function(MLFrame)
		_G.LootFrame:SetAlpha(1)
	end)

	hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
		for i = 1, _G.MAX_RAID_MEMBERS do
			local playerFrame = MasterLooterFrame["player"..i]
			if playerFrame then
				if not playerFrame.styled then
					playerFrame.Bg:SetPoint("TOPLEFT", 1, -1)
					playerFrame.Bg:SetPoint("BOTTOMRIGHT", -1, 1)
					playerFrame.Highlight:SetPoint("TOPLEFT", 1, -1)
					playerFrame.Highlight:SetPoint("BOTTOMRIGHT", -1, 1)

					playerFrame.Highlight:SetTexture(C.media.backdrop)

					F.CreateBD(playerFrame, 0)

					playerFrame.styled = true
				end
				local colour = C.classcolours[select(2, _G.UnitClass(playerFrame.Name:GetText()))]
				playerFrame.Name:SetTextColor(colour.r, colour.g, colour.b)
				playerFrame.Highlight:SetVertexColor(colour.r, colour.g, colour.b, .2)
			else
				break
			end
		end
	end)
end)
