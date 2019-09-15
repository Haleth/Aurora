local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ AddOns\Blizzard_TalentUI.lua ]]
--end

do --[[ AddOns\Blizzard_TalentUI.xml ]]
    function Skin.TalentButtonTemplate(Button)
        Skin.FrameTypeItemButton(Button)
    end
    function Skin.TalentTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
end

function private.AddOns.Blizzard_TalentUI()
    -----------------------
    --    TalentFrame    --
    -----------------------
    local talentFrame = _G.TalentFrame
    Base.SetBackdrop(talentFrame)
    _G.TalentFramePortrait:SetAlpha(0)
    talentFrame:DisableDrawLayer("BORDER")
    _G.TalentFramePointsLeft:Hide()
    _G.TalentFramePointsMiddle:Hide()
    _G.TalentFramePointsRight:Hide()
    Skin.UIPanelCloseButton(_G.TalentFrameCloseButton)
    _G.TalentFrameCloseButton:SetPoint("TOPRIGHT", talentFrame, "TOPRIGHT", 4, 5)
    _G.TalentFrameTitleText:SetPoint("TOP", 0, -10)
    Skin.UIPanelButtonTemplate(_G.TalentFrameCancelButton)
    _G.TalentFrameCancelButton:ClearAllPoints()
    _G.TalentFrameCancelButton:SetPoint("BOTTOMRIGHT", talentFrame, "BOTTOMRIGHT", -10, 10)
    Skin.TalentTabTemplate(_G.TalentFrameTab1)
    Skin.TalentTabTemplate(_G.TalentFrameTab2)
    Skin.TalentTabTemplate(_G.TalentFrameTab3)
    Util.PositionRelative("TOPLEFT", talentFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.TalentFrameTab1,
        _G.TalentFrameTab2,
        _G.TalentFrameTab3,
    })

    _G.TalentFrameSpentPoints:SetPoint("TOP", 0, -30)
    _G.TalentFrameTalentPointsText:SetPoint("BOTTOMRIGHT", talentFrame, "BOTTOMRIGHT", -150, 15)

    Skin.UIPanelScrollFrameTemplate(_G.TalentFrameScrollFrame)
    _G.TalentFrameScrollFrame:DisableDrawLayer("ARTWORK")
    _G.TalentFrameScrollFrame:SetPoint("TOPRIGHT", talentFrame, "TOPRIGHT", -28, -50)
    _G.TalentFrameScrollFrame:SetPoint("BOTTOMLEFT", talentFrame, "BOTTOMLEFT", 0, 40)

    _G.TalentFrameBackgroundTopLeft:SetPoint("TOPLEFT", 10, -50)
    _G.TalentFrameBackgroundTopLeft:SetSize(300, 350)
    _G.TalentFrameBackgroundTopRight:SetSize(64, 350)
    _G.TalentFrameBackgroundBottomLeft:SetSize(300, 128)
    _G.TalentFrameBackgroundBottomRight:SetSize(64, 128)

    ------------------------------
    --    TalentFrameTalents    --
    ------------------------------
    for index = 1, _G.MAX_NUM_TALENTS do
        local talentRow = _G["TalentFrameTalent"..index]
        Skin.TalentButtonTemplate(talentRow)
    end
end
