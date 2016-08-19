local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_DebugTools"] = function()
	_G.ScriptErrorsFrame:SetScale(_G.UIParent:GetScale())
	_G.ScriptErrorsFrame:SetSize(386, 274)
	_G.ScriptErrorsFrame:DisableDrawLayer("OVERLAY")
	_G.ScriptErrorsFrameTitleBG:Hide()
	_G.ScriptErrorsFrameDialogBG:Hide()
	F.CreateBD(_G.ScriptErrorsFrame)

	_G.FrameStackTooltip:SetScale(_G.UIParent:GetScale())
	_G.FrameStackTooltip:SetBackdrop(nil)

	local bg = _G.CreateFrame("Frame", nil, _G.FrameStackTooltip)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT")
	bg:SetFrameLevel(_G.FrameStackTooltip:GetFrameLevel()-1)
	F.CreateBD(bg, .6)

	F.ReskinClose(_G.ScriptErrorsFrameClose)
	F.ReskinScroll(_G.ScriptErrorsFrameScrollFrameScrollBar)
	F.Reskin(_G.select(4, _G.ScriptErrorsFrame:GetChildren()))
	F.Reskin(_G.select(5, _G.ScriptErrorsFrame:GetChildren()))
	F.Reskin(_G.select(6, _G.ScriptErrorsFrame:GetChildren()))
end
