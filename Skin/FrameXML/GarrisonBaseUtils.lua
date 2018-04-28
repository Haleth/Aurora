local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\GarrisonBaseUtils.lua ]]
    function Hook.GarrisonFollowerPortraitMixin_SetQuality(self, quality)
        local color = _G.ITEM_QUALITY_COLORS[quality]
        self:SetBackdropBorderColor(color.r, color.g, color.b)
    end
end

do --[[ FrameXML\GarrisonBaseUtils.xml ]]
    function Skin.PositionGarrisonAbiltyBorder(border, icon)
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", icon, -8, 8)
        border:SetPoint("BOTTOMRIGHT", icon, 8, -8)
    end
    function Skin.GarrisonFollowerPortraitTemplate(Frame)
        _G.hooksecurefunc(Frame, "SetQuality", Hook.GarrisonFollowerPortraitMixin_SetQuality)

        local size = Frame.Portrait:GetSize() + 2
        Frame:SetSize(size, size)
        Base.SetBackdrop(Frame, Color.frame, 1)

        Frame.PortraitRing:Hide()

        Frame.Portrait:ClearAllPoints()
        Frame.Portrait:SetPoint("TOPLEFT", 1, -1)

        Frame.PortraitRingQuality:SetTexture("")
        Frame.LevelBorder:SetAlpha(0)

        local lvlBG = Frame:CreateTexture(nil, "BORDER")
        lvlBG:SetColorTexture(0, 0, 0, 0.5)
        lvlBG:SetPoint("TOPLEFT", Frame, "BOTTOMLEFT", 1, 12)
        lvlBG:SetPoint("BOTTOMRIGHT", Frame, -1, 1)

        local level = Frame.Level
        level:ClearAllPoints()
        level:SetPoint("CENTER", lvlBG)

        Frame.PortraitRingCover:SetTexture("")
    end
end

function private.FrameXML.GarrisonBaseUtils()
    --[[
    ]]
end
