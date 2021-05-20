local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook

do --[[ FrameXML\HonorFrame.lua ]]
    function Hook.HonorFrame_Update(updateAll)
        _G.HonorFrameCurrentPVPTitle:SetPoint("TOP", _G.HonorGuildText, 0, -20)
    end
    function Hook.HonorFrame_SetLevel()
        local classLocale, classColor = private.charClass.locale, _G.CUSTOM_CLASS_COLORS[private.charClass.token]
        _G.HonorLevelText:SetFormattedText(_G.PLAYER_LEVEL, _G.UnitLevel("player"), _G.UnitRace("player"), classColor:WrapTextInColorCode(classLocale))
    end
end

--do --[[ FrameXML\HonorFrame.xml ]]
--end

function private.FrameXML.HonorFrame()
    _G.hooksecurefunc("HonorFrame_Update", Hook.HonorFrame_Update)
    _G.hooksecurefunc("HonorFrame_SetLevel", Hook.HonorFrame_SetLevel)

    local tl, tr, bl, br, _, _, tl2, tr2, bl2, br2 = _G.HonorFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()
    tl2:Hide()
    tr2:Hide()
    bl2:Hide()
    br2:Hide()

    _G.HonorFrameCurrentPVPRank:ClearAllPoints()
    _G.HonorFrameCurrentPVPRank:SetPoint("TOP", _G.HonorFrameCurrentPVPTitle, "BOTTOM", 0, -2)

    _G.HonorFrameRankButton:SetPoint("LEFT", _G.HonorFrameCurrentPVPTitle, -26, -6)
    _G.HonorFrameRankButton:SetPoint("RIGHT", _G.HonorFrameCurrentPVPTitle, 26, -6)
end
