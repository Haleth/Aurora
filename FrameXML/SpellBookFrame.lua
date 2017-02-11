local _, private = ...

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	_G.SpellBookFrame:DisableDrawLayer("BACKGROUND")
	_G.SpellBookFrame:DisableDrawLayer("BORDER")
	_G.SpellBookFrame:DisableDrawLayer("OVERLAY")
	_G.SpellBookFrameInset:DisableDrawLayer("BORDER")

	F.SetBD(_G.SpellBookFrame)
	F.ReskinClose(_G.SpellBookFrameCloseButton)

	_G.SpellBookFrameTabButton1:ClearAllPoints()
	_G.SpellBookFrameTabButton1:SetPoint("TOPLEFT", _G.SpellBookFrame, "BOTTOMLEFT", 0, 2)

	for i = 1, 5 do
		F.ReskinTab(_G["SpellBookFrameTabButton"..i])
	end

	for i = 1, _G.SPELLS_PER_PAGE do
		local bu = _G["SpellButton"..i]
		local ic = _G["SpellButton"..i.."IconTexture"]

		_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
		_G["SpellButton"..i.."Highlight"]:SetAlpha(0)

		bu.EmptySlot:SetAlpha(0)
		bu.TextBackground:Hide()
		bu.TextBackground2:Hide()
		bu.UnlearnedFrame:SetAlpha(0)

		bu:SetCheckedTexture("")
		bu:SetPushedTexture("")

		ic:SetTexCoord(.08, .92, .08, .92)

		ic.bg = F.CreateBG(bu)
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if _G.SpellBookFrame.bookType == _G.BOOKTYPE_PROFESSION then return end

		local slot, slotType = _G.SpellBook_GetSpellBookSlot(self);
		local name = self:GetName();
		local subSpellString = _G[name.."SubSpellName"]

		local isOffSpec = self.offSpecID ~= 0 and _G.SpellBookFrame.bookType == _G.BOOKTYPE_SPELL

		subSpellString:SetTextColor(1, 1, 1)

		if slotType == "FUTURESPELL" then
			local level = _G.GetSpellAvailableLevel(slot, _G.SpellBookFrame.bookType)
			if level and level > _G.UnitLevel("player") then
				self.SpellName:SetTextColor(.7, .7, .7)
				subSpellString:SetTextColor(.7, .7, .7)
			end
		else
			if slotType == "SPELL" and isOffSpec then
				subSpellString:SetTextColor(.7, .7, .7)
			end
		end

		self.RequiredLevelString:SetTextColor(.7, .7, .7)

		local ic = _G[name.."IconTexture"]
		if not ic.bg then return end
		if ic:IsShown() then
			ic.bg:Show()
		else
			ic.bg:Hide()
		end
	end)

	_G.SpellBookSkillLineTab1:SetPoint("TOPLEFT", _G.SpellBookSideTabsFrame, "TOPRIGHT", 2, -36)

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
		for i = 1, _G.GetNumSpellTabs() do
			local tab = _G["SpellBookSkillLineTab"..i]

			if not tab.styled then
				tab:GetRegions():Hide()
				tab:SetCheckedTexture(C.media.checked)

				F.CreateBG(tab)

				local nt = tab:GetNormalTexture()
				if nt then
					nt:SetTexCoord(.08, .92, .08, .92)
				end
				--tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)

				tab.styled = true
			end
		end
	end)

	_G.SpellBookFrameTutorialButton.Ring:Hide()
	_G.SpellBookFrameTutorialButton:SetPoint("TOPLEFT", _G.SpellBookFrame, "TOPLEFT", -12, 12)
end)
