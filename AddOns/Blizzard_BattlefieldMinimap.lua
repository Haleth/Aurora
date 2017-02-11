local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

C.themes["Blizzard_BattlefieldMinimap"] = function()
	F.SetBD(_G.BattlefieldMinimap, -1, 1, -5, 3)
	_G.BattlefieldMinimapCorner:Hide()
	_G.BattlefieldMinimapBackground:Hide()
	_G.BattlefieldMinimapCloseButton:Hide()
end
