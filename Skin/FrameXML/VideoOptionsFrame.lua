local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Util = Aurora.Util

--do --[[ FrameXML\VideoOptionsFrame.lua ]]
--end

--do --[[ FrameXML\VideoOptionsFrame.xml ]]
--end

function private.FrameXML.VideoOptionsFrame()
    Skin.OptionsFrameTemplate(_G.VideoOptionsFrame)
    Base.SetBackdrop(_G.VideoOptionsFrameCategoryFrame)

    _G.VideoOptionsFrameCategoryFrameTopLeft:Hide()
    _G.VideoOptionsFrameCategoryFrameTopRight:Hide()
    _G.VideoOptionsFrameCategoryFrameBottomLeft:Hide()
    _G.VideoOptionsFrameCategoryFrameBottomRight:Hide()
    _G.VideoOptionsFrameCategoryFrameTop:Hide()
    _G.VideoOptionsFrameCategoryFrameLeft:Hide()
    _G.VideoOptionsFrameCategoryFrameRight:Hide()
    _G.VideoOptionsFrameCategoryFrameBottom:Hide()

    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameOkay)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameCancel)
    Util.PositionRelative("BOTTOMRIGHT", _G.VideoOptionsFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.VideoOptionsFrameCancel,
        _G.VideoOptionsFrameOkay,
    })
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameDefaults)
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameClassic)
    Util.PositionRelative("BOTTOMLEFT", _G.VideoOptionsFrame, "BOTTOMLEFT", 15, 15, 5, "Right", {
        _G.VideoOptionsFrameDefaults,
        _G.VideoOptionsFrameClassic,
    })
    Skin.UIPanelButtonTemplate(_G.VideoOptionsFrameApply)

    _G.VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", _G.VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
end
