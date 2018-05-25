local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\GarrisonBaseUtils.lua ]]
    function Hook.GarrisonFollowerPortraitMixin_SetQuality(self, quality)
        if not self._auroraPortraitBG then return end
        local color = _G.ITEM_QUALITY_COLORS[quality]
        self._auroraPortraitBG:SetBackdropBorderColor(color.r, color.g, color.b)
        self._auroraLvlBG:SetBackdropBorderColor(color.r, color.g, color.b)
    end
    function Hook.GarrisonFollowerPortraitMixin_SetNoLevel(self)
        if not self._auroraLvlBG then return end
        self._auroraLvlBG:Hide()
    end
    function Hook.GarrisonFollowerPortraitMixin_SetLevel(self)
        if not self._auroraLvlBG then return end
        self._auroraLvlBG:Show()
    end
    function Hook.GarrisonFollowerPortraitMixin_SetILevel(self)
        if not self._auroraLvlBG then return end
        self._auroraLvlBG:Show()
    end
end

do --[[ FrameXML\GarrisonBaseUtils.xml ]]
    function Skin.PositionGarrisonAbiltyBorder(border, icon)
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", icon, -8, 8)
        border:SetPoint("BOTTOMRIGHT", icon, 8, -8)
    end
    function Skin.GarrisonFollowerPortraitTemplate(Frame)
        Frame.PortraitRing:Hide()
        Frame.Portrait:SetPoint("CENTER", 0, 4)
        Frame.PortraitRingQuality:SetTexture("")

        local portraitBG = _G.CreateFrame("Frame", nil, Frame)
        portraitBG:SetFrameLevel(Frame:GetFrameLevel())
        portraitBG:SetPoint("TOPLEFT", Frame.Portrait, -1, 1)
        portraitBG:SetPoint("BOTTOMRIGHT", Frame.Portrait, 1, -1)
        Base.SetBackdrop(portraitBG, Color.frame, 1)
        Frame._auroraPortraitBG = portraitBG

        Frame.LevelBorder:SetAlpha(0)
        local lvlBG = _G.CreateFrame("Frame", nil, Frame)
        lvlBG:SetPoint("TOPLEFT", portraitBG, "BOTTOMLEFT", 0, 6)
        lvlBG:SetPoint("BOTTOMRIGHT", portraitBG, 0, -10)
        Base.SetBackdrop(lvlBG, Color.frame, 1)
        Frame._auroraLvlBG = lvlBG

        Frame.Level:SetParent(lvlBG)
        Frame.Level:SetPoint("CENTER", lvlBG)

        Frame.PortraitRingCover:SetTexture("")
    end
end

function private.FrameXML.GarrisonBaseUtils()
    _G.hooksecurefunc(_G.GarrisonFollowerPortraitMixin, "SetQuality", Hook.GarrisonFollowerPortraitMixin_SetQuality)
    _G.hooksecurefunc(_G.GarrisonFollowerPortraitMixin, "SetNoLevel", Hook.GarrisonFollowerPortraitMixin_SetNoLevel)
    _G.hooksecurefunc(_G.GarrisonFollowerPortraitMixin, "SetLevel", Hook.GarrisonFollowerPortraitMixin_SetLevel)
    _G.hooksecurefunc(_G.GarrisonFollowerPortraitMixin, "SetILevel", Hook.GarrisonFollowerPortraitMixin_SetILevel)
end
