local _, private = ...

-- [[ Lua Globals ]]
local _G = _G

-- [[ Core ]]
local _, C = _G.unpack(private.Aurora)

C.themes["Blizzard_ChallengesUI"] = function()
	_G.ChallengesFrameInset:DisableDrawLayer("BORDER")
	_G.ChallengesFrameInsetBg:Hide()
end
