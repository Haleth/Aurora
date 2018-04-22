local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\VideoOptionsFrame.lua
end ]]

--[[ do FrameXML\VideoOptionsFrame.xml
end ]]

function private.FrameXML.VideoOptionsFrame()
    Skin.OptionsFrameTemplate(_G.VideoOptionsFrame)

    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameOkay)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameCancel)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameDefaults)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameApply)

    _G.VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", _G.VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
end
