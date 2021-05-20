local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next select

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ AddOns\Blizzard_TalentUI.lua ]]
--end

do --[[ AddOns\Blizzard_TalentUI.xml ]]
    function Skin.TalentTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.TalentBranchTemplate(Texture)
    end
    function Skin.TalentArrowTemplate(Texture)
    end
    function Skin.TalentButtonTemplate(Button)
        Skin.FrameTypeItemButton(Button)

        local name = Button:GetName()
        _G[name.."Slot"]:Hide()
    end
end

function private.AddOns.Blizzard_TalentUI()
    local TalentFrame = _G.TalentFrame
    Skin.FrameTypeFrame(TalentFrame)
    TalentFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local bg = TalentFrame:GetBackdropTexture("bg")
    local portrait, tl, tr, bl, br = TalentFrame:GetRegions()
    portrait:Hide()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    local textures = {
        TopLeft = {
            point = "TOPLEFT",
            x = 286, -- textureSize * (frameSize / fullBGSize)
            y = 327,
        },
        TopRight = {
            x = 72,
            y = 327,
        },
        BottomLeft = {
            x = 286,
            y = 163,
        },
        BottomRight = {
            x = 72,
            y = 163,
        },
    }
    for name, info in next, textures do
        local tex = _G["TalentFrameBackground"..name]
        if info.point then
            tex:SetPoint(info.point, bg)
        end
        tex:SetSize(info.x, info.y)
        tex:SetDrawLayer("BACKGROUND", 3)
        tex:SetAlpha(0.7)
    end

    _G.TalentFrameTitleText:ClearAllPoints()
    _G.TalentFrameTitleText:SetPoint("TOPLEFT", bg)
    _G.TalentFrameTitleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    _G.TalentFramePointsLeft:Hide()
    _G.TalentFramePointsMiddle:Hide()
    _G.TalentFramePointsRight:Hide()

    _G.TalentFrameSpentPoints:SetPoint("TOP", _G.TalentFrameTitleText, "BOTTOM", 0, 5)

    Skin.UIPanelCloseButton(_G.TalentFrameCloseButton)
    Skin.UIPanelButtonTemplate(_G.TalentFrameCancelButton)

    Skin.TalentTabTemplate(_G.TalentFrameTab1)
    Skin.TalentTabTemplate(_G.TalentFrameTab2)
    Skin.TalentTabTemplate(_G.TalentFrameTab3)
    Skin.TalentTabTemplate(_G.TalentFrameTab4)
    Skin.TalentTabTemplate(_G.TalentFrameTab5)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.TalentFrameTab1,
        _G.TalentFrameTab2,
        _G.TalentFrameTab3,
        _G.TalentFrameTab4,
        _G.TalentFrameTab5,
    })

    _G.TalentFrameScrollFrame:ClearAllPoints()
    _G.TalentFrameScrollFrame:SetPoint("TOPLEFT", bg, 5, -45)
    _G.TalentFrameScrollFrame:SetPoint("BOTTOMRIGHT", bg, -25, 30)
    Skin.UIPanelScrollFrameTemplate(_G.TalentFrameScrollFrame)
    local top, bottom = _G.TalentFrameScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    for i = 1, _G.MAX_NUM_TALENTS do
        Skin.TalentButtonTemplate(_G["TalentFrameTalent"..i])
    end
end
