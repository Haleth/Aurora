local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\CastingBarFrame.lua ]]
--end

do --[[ FrameXML\CastingBarFrame.xml ]]
    function Skin.CastingBarFrameTemplate(StatusBar)
        Skin.FrameTypeStatusBar(StatusBar)
        Base.SetBackdropColor(StatusBar, Color.frame)

        StatusBar:GetRegions():Hide()
        StatusBar.Border:Hide()
        StatusBar.Text:ClearAllPoints()
        StatusBar.Text:SetPoint("CENTER")
        StatusBar.Spark:SetAlpha(0)

        StatusBar.Flash:SetAllPoints(StatusBar)
        StatusBar.Flash:SetColorTexture(1, 1, 1)
    end
    function Skin.SmallCastingBarFrameTemplate(StatusBar)
        Skin.FrameTypeStatusBar(StatusBar)

        StatusBar:GetRegions():Hide()
        StatusBar.Border:Hide()
        StatusBar.Text:ClearAllPoints()
        StatusBar.Text:SetPoint("CENTER")
        StatusBar.Spark:SetAlpha(0)

        StatusBar.Flash:SetAllPoints(StatusBar)
        StatusBar.Flash:SetColorTexture(1, 1, 1)
    end
end

function private.FrameXML.CastingBarFrame()
    Skin.CastingBarFrameTemplate(_G.CastingBarFrame)
end
