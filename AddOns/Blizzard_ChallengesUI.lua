-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local _, C = _G.unpack(_G.select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	_G.ChallengesFrameInset:DisableDrawLayer("BORDER")
	_G.ChallengesFrameInsetBg:Hide()
end
