local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

-- [[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook

do --[[ FrameXML\BossBannerToast.lua ]]
    function Hook.BossBanner_ConfigureLootFrame(lootFrame, data)
        lootFrame.PlayerName:SetTextColor(_G.CUSTOM_CLASS_COLORS[data.className]:GetRGB())
    end
end

--do --[[ FrameXML\BossBannerToast.xml ]]
--end

function private.FrameXML.BossBannerToast()
    _G.hooksecurefunc("BossBanner_ConfigureLootFrame", Hook.BossBanner_ConfigureLootFrame)
end
