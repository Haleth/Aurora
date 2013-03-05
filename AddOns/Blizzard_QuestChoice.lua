local F, C = unpack(select(2, ...))

C.modules["Blizzard_QuestChoice"] = function()
	for i = 1, 18 do
		select(i, QuestChoiceFrame:GetRegions()):Hide()
	end

	F.CreateBD(QuestChoiceFrame)
	F.CreateSD(QuestChoiceFrame)
	F.Reskin(QuestChoiceFrame.Option1.OptionButton)
	F.Reskin(QuestChoiceFrame.Option2.OptionButton)
	F.ReskinClose(QuestChoiceFrame.CloseButton)
end