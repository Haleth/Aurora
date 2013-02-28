local F, C = unpack(select(2, ...))

C.modules["Blizzard_PVPUI"] = function()
	PVPUIFrame:DisableDrawLayer("ARTWORK")
	PVPUIFrame.LeftInset:DisableDrawLayer("BORDER")
	PVPUIFrame.Background:Hide()
	PVPUIFrame.Shadows:Hide()
	PVPUIFrame.LeftInset:GetRegions():Hide()
	select(24, PVPUIFrame:GetRegions()):Hide()
	select(25, PVPUIFrame:GetRegions()):Hide()

	PVPUIFrameTab2:SetPoint("LEFT", PVPUIFrameTab1, "RIGHT", -15, 0)

	F.ReskinPortraitFrame(PVPUIFrame)
	F.ReskinTab(PVPUIFrame.Tab1)
	F.ReskinTab(PVPUIFrame.Tab2)
	F.Reskin(HonorFrame.SoloQueueButton)
	F.Reskin(HonorFrame.GroupQueueButton)
	F.ReskinDropDown(HonorFrameTypeDropDown)
end