-- [[ Lua Globals ]]
local _G = _G
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(select(2, ...))

_G.tinsert(C.themes["Aurora"], function()
	F.ReskinPortraitFrame(_G.QuestFrame, true)

	_G.QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
	_G.QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
	_G.QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
	_G.QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	_G.QuestFrameDetailPanel:DisableDrawLayer("BORDER")
	_G.QuestFrameRewardPanel:DisableDrawLayer("BORDER")

	_G.QuestDetailScrollFrameTop:Hide()
	_G.QuestDetailScrollFrameBottom:Hide()
	_G.QuestDetailScrollFrameMiddle:Hide()
	_G.QuestProgressScrollFrameTop:Hide()
	_G.QuestProgressScrollFrameBottom:Hide()
	_G.QuestProgressScrollFrameMiddle:Hide()
	_G.QuestRewardScrollFrameTop:Hide()
	_G.QuestRewardScrollFrameBottom:Hide()
	_G.QuestRewardScrollFrameMiddle:Hide()
	_G.QuestGreetingScrollFrameTop:Hide()
	_G.QuestGreetingScrollFrameBottom:Hide()
	_G.QuestGreetingScrollFrameMiddle:Hide()

	_G.QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
	_G.QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
	_G.QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
	_G.QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)

	hooksecurefunc("QuestFrame_SetMaterial", function(frame)
		_G[frame:GetName().."MaterialTopLeft"]:Hide()
		_G[frame:GetName().."MaterialTopRight"]:Hide()
		_G[frame:GetName().."MaterialBotLeft"]:Hide()
		_G[frame:GetName().."MaterialBotRight"]:Hide()
	end)

	local hRule = _G.QuestFrameGreetingPanel:CreateTexture()
	hRule:SetColorTexture(1, 1, 1, .2)
	hRule:SetSize(256, 1)
	hRule:SetPoint("CENTER", _G.QuestGreetingFrameHorizontalBreak)

	_G.QuestGreetingFrameHorizontalBreak:SetTexture("")

	_G.QuestFrameGreetingPanel:HookScript("OnShow", function()
		hRule:SetShown(_G.QuestGreetingFrameHorizontalBreak:IsShown())
	end)

	for i = 1, _G.MAX_REQUIRED_ITEMS do
		local bu = _G["QuestProgressItem"..i]
		local ic = _G["QuestProgressItem"..i.."IconTexture"]
		local na = _G["QuestProgressItem"..i.."NameFrame"]
		local co = _G["QuestProgressItem"..i.."Count"]

		ic:SetSize(40, 40)
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("OVERLAY")

		F.CreateBD(bu, .25)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = _G.CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:SetPoint("RIGHT", ic, 1, 0)
		F.CreateBD(line)
	end

	_G.QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	hooksecurefunc(_G.QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	for _, questButton in pairs({"QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "QuestFrameGreetingGoodbyeButton"}) do
		F.Reskin(_G[questButton])
	end
	
	F.Reskin(_G.QuestFrameDetailPanel.IgnoreButton)

	F.ReskinScroll(_G.QuestProgressScrollFrameScrollBar)
	F.ReskinScroll(_G.QuestRewardScrollFrameScrollBar)
	F.ReskinScroll(_G.QuestDetailScrollFrameScrollBar)
	F.ReskinScroll(_G.QuestGreetingScrollFrameScrollBar)

	-- Text colour stuff

	_G.QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	_G.QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	_G.QuestProgressTitleText:SetTextColor(1, 1, 1)
	_G.QuestProgressTitleText:SetShadowColor(0, 0, 0)
	_G.QuestProgressTitleText.SetTextColor = F.dummy
	_G.QuestProgressText:SetTextColor(1, 1, 1)
	_G.QuestProgressText.SetTextColor = F.dummy
	_G.GreetingText:SetTextColor(1, 1, 1)
	_G.GreetingText.SetTextColor = F.dummy
	_G.AvailableQuestsText:SetTextColor(1, 1, 1)
	_G.AvailableQuestsText.SetTextColor = F.dummy
	_G.AvailableQuestsText:SetShadowColor(0, 0, 0)
	_G.CurrentQuestsText:SetTextColor(1, 1, 1)
	_G.CurrentQuestsText.SetTextColor = F.dummy
	_G.CurrentQuestsText:SetShadowColor(0, 0, 0)

	-- [[ Quest NPC model ]]

	_G.QuestNPCModelShadowOverlay:Hide()
	_G.QuestNPCModelBg:Hide()
	_G.QuestNPCModel:DisableDrawLayer("OVERLAY")
	_G.QuestNPCModelNameText:SetDrawLayer("ARTWORK")
	_G.QuestNPCModelTextFrameBg:Hide()
	_G.QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")

	local npcbd = _G.CreateFrame("Frame", nil, _G.QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 1)
	npcbd:SetPoint("RIGHT", 2, 0)
	npcbd:SetPoint("BOTTOM", _G.QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(0)
	F.CreateBD(npcbd)

	local npcLine = _G.CreateFrame("Frame", nil, _G.QuestNPCModel)
	npcLine:SetPoint("BOTTOMLEFT", 0, -1)
	npcLine:SetPoint("BOTTOMRIGHT", 1, -1)
	npcLine:SetHeight(1)
	npcLine:SetFrameLevel(0)
	F.CreateBD(npcLine, 0)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, x, y)
		if parentFrame == _G.QuestLogPopupDetailFrame or parentFrame == _G.QuestFrame then
			x = x + 3
		end

		_G.QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)

	F.ReskinScroll(_G.QuestNPCModelTextScrollFrameScrollBar)
end)
