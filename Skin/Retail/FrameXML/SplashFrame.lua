local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\SplashFrame.lua ]]
--end

do --[[ FrameXML\SplashFrame.xml ]]
    Skin.SplashFeatureFrameTemplate = private.nop
end

function private.FrameXML.SplashFrame()
    local SplashFrame = _G.SplashFrame
    Skin.UIPanelButtonTemplate(SplashFrame.BottomCloseButton)

    Skin.UIPanelCloseButton(SplashFrame.TopCloseButton)
    Skin.SplashFeatureFrameTemplate(SplashFrame.Feature1)
    Skin.SplashFeatureFrameTemplate(SplashFrame.Feature2)
end
