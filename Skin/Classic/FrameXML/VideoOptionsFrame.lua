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

    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameApply)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameCancel)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameOkay)
    Util.PositionRelative("BOTTOMRIGHT", _G.VideoOptionsFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.VideoOptionsFrameCancel,
        _G.VideoOptionsFrameOkay,
    })

    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameDefaults)
    if private.isRetail then
        _G.VideoOptionsFrameDefaults:SetPoint("BOTTOMLEFT", 15, 15)
    else
        Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameClassic)
        Util.PositionRelative("BOTTOMLEFT", _G.VideoOptionsFrame, "BOTTOMLEFT", 15, 15, 5, "Right", {
            _G.VideoOptionsFrameDefaults,
            _G.VideoOptionsFrameClassic,
        })
    end
end
