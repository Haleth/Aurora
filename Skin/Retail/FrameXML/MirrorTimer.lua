local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\MirrorTimer.lua ]]
--end

do --[[ FrameXML\MirrorTimer.xml ]]
    function Skin.MirrorTimerTemplate(Frame)
        local name = Frame:GetName()
        Skin.FrameTypeStatusBar(_G[name.."StatusBar"])

        Frame:GetRegions():Hide()
        _G[name.."Text"]:ClearAllPoints()
        _G[name.."Text"]:SetPoint("CENTER", _G[name.."StatusBar"])
        _G[name.."Border"]:Hide()
    end
end

function private.FrameXML.MirrorTimer()
    Skin.MirrorTimerTemplate(_G.MirrorTimer1)
    Skin.MirrorTimerTemplate(_G.MirrorTimer2)
    Skin.MirrorTimerTemplate(_G.MirrorTimer3)
end
