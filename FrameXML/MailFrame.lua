local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	_G.SendMailMoneyInset:DisableDrawLayer("BORDER")
	_G.InboxFrame:GetRegions():Hide()
	_G.SendMailMoneyBg:Hide()
	_G.SendMailMoneyInsetBg:Hide()
	_G.OpenMailFrameIcon:Hide()
	_G.OpenMailHorizontalBarLeft:Hide()
	select(18, _G.MailFrame:GetRegions()):Hide()
	select(25, _G.OpenMailFrame:GetRegions()):Hide()
	for i = 4, 7 do
		select(i, _G.SendMailFrame:GetRegions()):Hide()
	end
	select(4, _G.SendMailScrollFrame:GetRegions()):Hide()
	select(2, _G.OpenMailScrollFrame:GetRegions()):Hide()

	F.ReskinPortraitFrame(_G.MailFrame, true)
	F.ReskinPortraitFrame(_G.OpenMailFrame, true)
	F.Reskin(_G.SendMailMailButton)
	F.Reskin(_G.SendMailCancelButton)
	F.Reskin(_G.OpenMailReplyButton)
	F.Reskin(_G.OpenMailDeleteButton)
	F.Reskin(_G.OpenMailCancelButton)
	F.Reskin(_G.OpenMailReportSpamButton)
	F.Reskin(_G.OpenAllMail)
	F.ReskinInput(_G.SendMailNameEditBox, 20)
	F.ReskinInput(_G.SendMailSubjectEditBox)
	F.ReskinInput(_G.SendMailMoneyGold)
	F.ReskinInput(_G.SendMailMoneySilver)
	F.ReskinInput(_G.SendMailMoneyCopper)
	F.ReskinScroll(_G.SendMailScrollFrameScrollBar)
	F.ReskinScroll(_G.OpenMailScrollFrameScrollBar)
	F.ReskinRadio(_G.SendMailSendMoneyButton)
	F.ReskinRadio(_G.SendMailCODButton)

	_G.SendMailMailButton:SetPoint("RIGHT", _G.SendMailCancelButton, "LEFT", -1, 0)
	_G.OpenMailDeleteButton:SetPoint("RIGHT", _G.OpenMailCancelButton, "LEFT", -1, 0)
	_G.OpenMailReplyButton:SetPoint("RIGHT", _G.OpenMailDeleteButton, "LEFT", -1, 0)

	_G.SendMailMoneySilver:SetPoint("LEFT", _G.SendMailMoneyGold, "RIGHT", 1, 0)
	_G.SendMailMoneyCopper:SetPoint("LEFT", _G.SendMailMoneySilver, "RIGHT", 1, 0)

	_G.OpenMailLetterButton:SetNormalTexture("")
	_G.OpenMailLetterButton:SetPushedTexture("")
	_G.OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

	for i = 1, 2 do
		F.ReskinTab(_G["MailFrameTab"..i])
	end

	local bgmail = CreateFrame("Frame", nil, _G.OpenMailLetterButton)
	bgmail:SetPoint("TOPLEFT", -1, 1)
	bgmail:SetPoint("BOTTOMRIGHT", 1, -1)
	bgmail:SetFrameLevel(_G.OpenMailLetterButton:GetFrameLevel()-1)
	F.CreateBD(bgmail)

	_G.OpenMailMoneyButton:SetNormalTexture("")
	_G.OpenMailMoneyButton:SetPushedTexture("")
	_G.OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

	local bgmoney = CreateFrame("Frame", nil, _G.OpenMailMoneyButton)
	bgmoney:SetPoint("TOPLEFT", -1, 1)
	bgmoney:SetPoint("BOTTOMRIGHT", 1, -1)
	bgmoney:SetFrameLevel(_G.OpenMailMoneyButton:GetFrameLevel()-1)
	F.CreateBD(bgmoney)

	_G.SendMailSubjectEditBox:SetPoint("TOPLEFT", _G.SendMailNameEditBox, "BOTTOMLEFT", 0, -1)

	for i = 1, _G.INBOXITEMS_TO_DISPLAY do
		local it = _G["MailItem"..i]
		local bu = _G["MailItem"..i.."Button"]
		local st = _G["MailItem"..i.."ButtonSlot"]
		local ic = _G["MailItem"..i.."Button".."Icon"]
		local line = select(3, _G["MailItem"..i]:GetRegions())

		local a, b = it:GetRegions()
		a:Hide()
		b:Hide()

		bu:SetCheckedTexture(C.media.checked)

		st:Hide()
		line:Hide()
		ic:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		F.CreateBD(bg, 0)
	end

	for i = 1, _G.ATTACHMENTS_MAX_SEND do
		local bu = _G["SendMailAttachment"..i]
		local border = bu.IconBorder

		bu:GetRegions():Hide()

		border:SetTexture(C.media.backdrop)
		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)
	end

	-- sigh
	-- we mess with quality colour numbers, so we have to fix this
	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, _G.ATTACHMENTS_MAX_SEND do
			local bu = _G["SendMailAttachment"..i]

			if bu:GetNormalTexture() == nil and bu.IconBorder:IsShown() then
				bu.IconBorder:Hide()
			end
		end
	end)

	for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
		local bu = _G["OpenMailAttachmentButton"..i]
		local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]
		local border = bu.IconBorder

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		ic:SetTexCoord(.08, .92, .08, .92)

		border:SetTexture(C.media.backdrop)
		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)
	end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, _G.ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]
			if button:GetNormalTexture() then
				button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)
end)
