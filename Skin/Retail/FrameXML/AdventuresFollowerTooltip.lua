local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\AdventuresFollowerTooltip.lua ]]
--end

do --[[ FrameXML\AdventuresFollowerTooltip.xml ]]
    local portraitBGColor = Color.Create(0.0196, 0.047, 0.1176)
    function Skin.AdventuresLevelPortraitTemplate(Frame)
        Base.SetBackdrop(Frame, portraitBGColor, 1)
        Frame:SetBackdropOptions({
            offsets = {
                left = 6,
                right = 6,
                top = 6,
                bottom = 6,
            },

            backdropBorderLayer = "BORDER",
            backdropBorderSubLevel = 1
        })
        Frame._auroraPortraitBG = Frame

        local bg = Frame:GetBackdropTexture("bg")
        Frame.Portrait:ClearAllPoints()
        Frame.Portrait:SetPoint("TOPLEFT", bg)
        Frame.Portrait:SetPoint("BOTTOMRIGHT", bg)
        Frame.PuckBorder:Hide()

        local lvlBG = _G.CreateFrame("Frame", nil, Frame)
        lvlBG:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 0, 6)
        lvlBG:SetPoint("BOTTOMRIGHT", bg, 0, -6)
        Base.SetBackdrop(lvlBG, Color.frame, 1)
        Frame._auroraLvlBG = lvlBG

        Frame.LevelDisplayFrame.LevelText:SetParent(lvlBG)
        Frame.LevelDisplayFrame.LevelText:SetAllPoints()
        Frame.LevelDisplayFrame.LevelCircle:Hide()
    end
end

function private.FrameXML.AdventuresFollowerTooltip()
    ----====####$$$$%%%%$$$$####====----
    --              AdventuresFollowerTooltip              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
