local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local next = _G.next

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	_G.CharacterFrameInsetRight:DisableDrawLayer("BACKGROUND")
	_G.CharacterFrameInsetRight:DisableDrawLayer("BORDER")

	F.ReskinPortraitFrame(_G.CharacterFrame, true)

    local CharacterStatsPane = _G.CharacterStatsPane
    CharacterStatsPane.ClassBackground:Hide()
    CharacterStatsPane.ItemLevelFrame:SetPoint("TOP", 0, -20)
    for _, category in next, {"AttributesCategory", "EnhancementsCategory"} do
        CharacterStatsPane[category].Background:Hide()
    end
    _G.hooksecurefunc("PaperDollFrame_UpdateStats", function()
        if ( _G.UnitLevel("player") >= _G.MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY ) then
            CharacterStatsPane.ItemLevelCategory:Hide()
            CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -40)
        end
    end)

    _G.CharacterFrame:HookScript("OnShow", function()
        for k, v in next, {_G.CharacterStatsPane:GetChildren()} do
            if v.Background then
                if v.Background:GetAtlas() then
                    v.Background:SetAtlas(nil)
                end
            end
        end
    end)

	local i = 1
	while _G["CharacterFrameTab"..i] do
		F.ReskinTab(_G["CharacterFrameTab"..i])
		i = i + 1
	end
end)
