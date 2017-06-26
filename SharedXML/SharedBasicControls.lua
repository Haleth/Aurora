local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.SharedXML.SharedBasicControls()
    local ScriptErrorsFrame = _G.ScriptErrorsFrame
    ScriptErrorsFrame:SetScale(_G.UIParent:GetScale())
    for i = 1, 10 do
        -- Remove borders and backgrounds
        _G.select(i, ScriptErrorsFrame:GetRegions()):Hide()
    end
    F.CreateBD(ScriptErrorsFrame)
    F.ReskinClose((_G.ScriptErrorsFrame:GetChildren())) -- Close button

    ScriptErrorsFrame.DragArea:ClearAllPoints()
    ScriptErrorsFrame.DragArea:SetPoint("TOPLEFT")
    ScriptErrorsFrame.DragArea:SetPoint("BOTTOMRIGHT", _G.ScriptErrorsFrame, "TOPRIGHT", 0, -24)
    F.Reskin(ScriptErrorsFrame.Reload)
    F.ReskinArrow(ScriptErrorsFrame.PreviousError, "Left")
    F.ReskinArrow(ScriptErrorsFrame.NextError, "Right")
    F.ReskinScroll(ScriptErrorsFrame.ScrollFrame.ScrollBar)
    F.Reskin(ScriptErrorsFrame.Close)
end
