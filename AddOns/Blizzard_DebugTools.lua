local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_DebugTools"] = function()
	if not C.is725 then
		_G.ScriptErrorsFrame:SetScale(_G.UIParent:GetScale())
		_G.ScriptErrorsFrame:SetSize(386, 274)
		_G.ScriptErrorsFrame:DisableDrawLayer("OVERLAY")
		_G.ScriptErrorsFrameTitleBG:Hide()
		_G.ScriptErrorsFrameDialogBG:Hide()
		F.CreateBD(_G.ScriptErrorsFrame)
		F.Reskin(_G.select(4, _G.ScriptErrorsFrame:GetChildren()))
		F.Reskin(_G.select(5, _G.ScriptErrorsFrame:GetChildren()))
		F.Reskin(_G.select(6, _G.ScriptErrorsFrame:GetChildren()))

		F.ReskinScroll(_G.ScriptErrorsFrameScrollFrameScrollBar)
		F.ReskinClose(_G.ScriptErrorsFrameClose)
	end

    --[[ EventTrace ]]--
    for i = 1, _G.EventTraceFrame:GetNumRegions() do
        local region = _G.select(i, _G.EventTraceFrame:GetRegions())
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        end
    end
    _G.EventTraceFrame:SetHeight(600)
    F.CreateBD(_G.EventTraceFrame)
    F.ReskinClose(_G.EventTraceFrameCloseButton)

    _G.EventTraceFrameTitleButton:ClearAllPoints()
    _G.EventTraceFrameTitleButton:SetPoint("TOPLEFT")
    _G.EventTraceFrameTitleButton:SetPoint("BOTTOMRIGHT", _G.EventTraceFrame, "TOPRIGHT", 0, -24)

    _G.EventTraceFrameScrollBG:Hide()
    local thumb = _G.EventTraceFrameScroll.thumb
    thumb:SetAlpha(0)
    thumb:SetWidth(17)
    local etraceBG = _G.CreateFrame("Frame", nil, _G.EventTraceFrameScroll)
    etraceBG:SetPoint("TOPLEFT", thumb, 0, 0)
    etraceBG:SetPoint("BOTTOMRIGHT", thumb, 0, 0)
    F.CreateBD(etraceBG, 0)
    F.CreateGradient(etraceBG)

    F.ReskinTooltip(_G.EventTraceTooltip)

    --[[ FrameStack ]]--
    F.ReskinTooltip(_G.FrameStackTooltip)
end
