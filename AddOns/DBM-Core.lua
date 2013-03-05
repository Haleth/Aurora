local F, C = unpack(select(2, ...))

C.modules["DBM-Core"] = function()
	local firstInfo = true
	hooksecurefunc(DBM.InfoFrame, "Show", function()
		if firstInfo then
			DBMInfoFrame:SetBackdrop(nil)
			local bd = CreateFrame("Frame", nil, DBMInfoFrame)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT")
			bd:SetFrameLevel(DBMInfoFrame:GetFrameLevel()-1)
			F.CreateBD(bd)

			firstInfo = false
		end
	end)

	local firstRange = true
	hooksecurefunc(DBM.RangeCheck, "Show", function()
		if firstRange then
			DBMRangeCheck:SetBackdrop(nil)
			local bd = CreateFrame("Frame", nil, DBMRangeCheck)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT")
			bd:SetFrameLevel(DBMRangeCheck:GetFrameLevel()-1)
			F.CreateBD(bd)

			firstRange = false
		end
	end)
end