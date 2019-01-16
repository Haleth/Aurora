local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ FrameXML\VideoOptionsFrame.lua ]]
--end

--do --[[ FrameXML\VideoOptionsFrame.xml ]]
--end

function private.FrameXML.VideoOptionsFrame()
    Skin.OptionsFrameTemplate(_G.VideoOptionsFrame)

    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameOkay)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameCancel)
    Util.PositionRelative("BOTTOMRIGHT", _G.VideoOptionsFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.VideoOptionsFrameCancel,
        _G.VideoOptionsFrameOkay,
    })
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameDefaults)
    _G.VideoOptionsFrameDefaults:SetPoint("BOTTOMLEFT", 15, 15)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameApply)

    _G.VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", _G.VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
end
