local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select = _G.select

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	if not _G.AuroraConfig.loot then return end

	_G.LootFramePortraitOverlay:Hide()

	select(19, _G.LootFrame:GetRegions()):SetPoint("TOP", _G.LootFrame, "TOP", 0, -7)

	hooksecurefunc("LootFrame_UpdateButton", function(index)
		local ic = _G["LootButton"..index.."IconTexture"]

		if not ic.bg then
			local bu = _G["LootButton"..index]

			_G["LootButton"..index.."IconQuestTexture"]:SetAlpha(0)
			_G["LootButton"..index.."NameFrame"]:Hide()

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")

			local bd = _G.CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT", 114, 0)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			F.CreateBD(bd, .25)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic.bg = F.CreateBG(ic)
		end

		if select(6, _G.GetLootSlotInfo(index)) then
			ic.bg:SetVertexColor(1, 1, 0)
		else
			ic.bg:SetVertexColor(0, 0, 0)
		end
	end)

	_G.LootFrameDownButton:ClearAllPoints()
	_G.LootFrameDownButton:SetPoint("BOTTOMRIGHT", -8, 6)
	_G.LootFramePrev:ClearAllPoints()
	_G.LootFramePrev:SetPoint("LEFT", _G.LootFrameUpButton, "RIGHT", 4, 0)
	_G.LootFrameNext:ClearAllPoints()
	_G.LootFrameNext:SetPoint("RIGHT", _G.LootFrameDownButton, "LEFT", -4, 0)

	F.ReskinPortraitFrame(_G.LootFrame, true)
	F.ReskinArrow(_G.LootFrameUpButton, "up")
	F.ReskinArrow(_G.LootFrameDownButton, "down")
end)
