local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	F.ReskinPortraitFrame(_G.AddonList, true)
	F.Reskin(_G.AddonListEnableAllButton)
	F.Reskin(_G.AddonListDisableAllButton)
	F.Reskin(_G.AddonListCancelButton)
	F.Reskin(_G.AddonListOkayButton)
	F.ReskinCheck(_G.AddonListForceLoad)
	F.ReskinDropDown(_G.AddonCharacterDropDown)
	F.ReskinScroll(_G.AddonListScrollFrameScrollBar)

	_G.AddonCharacterDropDown:SetWidth(170)

	_G.hooksecurefunc("AddonList_Update", function()
		for i = 1, _G.MAX_ADDONS_DISPLAYED do
			local checkbox = _G["AddonListEntry"..i.."Enabled"]
			if not checkbox.isSkinned then
				F.ReskinCheck(checkbox, true)
				F.Reskin(_G["AddonListEntry"..i.."Load"])
				checkbox.isSkinned = true
			end
			checkbox:SetTriState(checkbox.state)
		end
	end)
end)
