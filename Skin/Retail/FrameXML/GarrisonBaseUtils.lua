local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\GarrisonBaseUtils.lua ]]
    Hook.GarrisonFollowerPortraitMixin = {}
    function Hook.GarrisonFollowerPortraitMixin:SetQuality(quality)
        if not self._auroraPortraitBG then return end
        local color = _G.ITEM_QUALITY_COLORS[quality]
        self._auroraPortraitBG:SetBackdropBorderColor(color.r, color.g, color.b)
        self._auroraLvlBG:SetBackdropBorderColor(color.r, color.g, color.b)
    end
    function Hook.GarrisonFollowerPortraitMixin:SetNoLevel()
        if not self._auroraLvlBG then return end
        self._auroraLvlBG:Hide()
    end
    function Hook.GarrisonFollowerPortraitMixin:SetLevel()
        if not self._auroraLvlBG then return end
        self._auroraLvlBG:Show()
    end
    function Hook.GarrisonFollowerPortraitMixin:SetILevel()
        if not self._auroraLvlBG then return end
        self._auroraLvlBG:Show()
    end
end

do --[[ FrameXML\GarrisonBaseUtils.xml ]]
    local portraitBGColor = Color.Create(0.02, 0.05, 0.11)
    function Skin.PositionGarrisonAbiltyBorder(border, icon)
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", icon, -8, 8)
        border:SetPoint("BOTTOMRIGHT", icon, 8, -8)
    end
    function Skin.GarrisonFollowerPortraitTemplate(Frame)
        Base.SetBackdrop(Frame, portraitBGColor, 1)
        Frame:SetBackdropOptions({
            offsets = {
                left = 4,
                right = 4,
                top = 4,
                bottom = 12,
            },

            backdropBorderLayer = "BORDER",
            backdropBorderSubLevel = 1
        })
        Frame._auroraPortraitBG = Frame

        Frame.PortraitRing:Hide()
        Frame.PortraitRingQuality:SetTexture("")

        local bg = Frame:GetBackdropTexture("bg")
        Frame.Portrait:ClearAllPoints()
        Frame.Portrait:SetPoint("TOPLEFT", bg)
        Frame.Portrait:SetPoint("BOTTOMRIGHT", bg)

        Frame.LevelBorder:SetAlpha(0)
        local lvlBG = _G.CreateFrame("Frame", nil, Frame)
        lvlBG:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 0, 4)
        lvlBG:SetPoint("BOTTOMRIGHT", bg, 0, -9)
        Base.SetBackdrop(lvlBG, Color.frame, 1)
        Frame._auroraLvlBG = lvlBG

        Frame.Level:SetParent(lvlBG)
        Frame.Level:SetAllPoints()

        Frame.PortraitRingCover:SetTexture("")
    end
end

function private.FrameXML.GarrisonBaseUtils()
    Util.Mixin(_G.GarrisonFollowerPortraitMixin, Hook.GarrisonFollowerPortraitMixin)
end
