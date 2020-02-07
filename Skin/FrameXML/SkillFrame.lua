local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\SkillFrame.lua ]]
--end

do --[[ FrameXML\SkillFrame.xml ]]
    function Skin.SkillStatusBarTemplate(StatusBar)
        Skin.FrameTypeStatusBar(StatusBar)
        Base.SetHighlight(StatusBar, "backdrop")

        local name = StatusBar:GetName()
        Base.SetTexture(_G[name.."FillBar"], "gradientUp")

        _G[name.."Background"]:Hide()
        _G[name.."Border"]:SetAlpha(0)
    end
    function Skin.SkillLabelTemplate(Button)
        Skin.ExpandOrCollapse(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 269,
            top = 0,
            bottom = 1,
        })
    end
end

function private.FrameXML.SkillFrame()
    local SkillFrame = _G.SkillFrame
    local bg = _G.CharacterFrame:GetBackdropTexture("bg")

    local TopLeft, TopRight, BotLeft, BotRight, barLeft, barRight = SkillFrame:GetRegions()
    TopLeft:Hide()
    TopRight:Hide()
    BotLeft:Hide()
    BotRight:Hide()

    barLeft:Hide()
    barRight:SetColorTexture(Color.gray:GetRGB())
    barRight:SetPoint("TOPLEFT", bg, 10, -285)
    barRight:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -10, -286)

    _G.SkillFrameExpandButtonFrame:ClearAllPoints()
    _G.SkillFrameExpandButtonFrame:SetPoint("BOTTOMLEFT", _G.SkillTypeLabel1, "TOPLEFT", 0, -5)
    local left, middle, right = _G.SkillFrameExpandButtonFrame:GetRegions()
    left:SetAlpha(0)
    middle:SetAlpha(0)
    right:SetAlpha(0)
    Skin.SkillLabelTemplate(_G.SkillFrameCollapseAllButton)
    _G.SkillFrameCollapseAllButton:SetBackdropOption("offsets", {
        left = 3,
        right = 24,
        top = 5,
        bottom = 4,
    })

    Skin.UIPanelButtonTemplate(_G.SkillFrameCancelButton)

    _G.SkillTypeLabel1:ClearAllPoints()
    _G.SkillTypeLabel1:SetPoint("TOPLEFT", bg, 10, -45)
    for i = 1, _G.SKILLS_TO_DISPLAY do
        Skin.SkillLabelTemplate(_G["SkillTypeLabel"..i])
        Skin.SkillStatusBarTemplate(_G["SkillRankFrame"..i])

        _G["SkillRankFrame"..i]:SetPoint("TOPLEFT", _G["SkillTypeLabel"..i], 20, 0)
        if i > 1 then
            _G["SkillTypeLabel"..i]:ClearAllPoints()
            _G["SkillTypeLabel"..i]:SetPoint("TOPLEFT", _G["SkillTypeLabel"..i-1], "BOTTOMLEFT", 0, -6)
        end
    end

    _G.SkillListScrollFrame:ClearAllPoints()
    _G.SkillListScrollFrame:SetPoint("TOPLEFT", bg, 5, -(private.FRAME_TITLE_HEIGHT + 18))
    _G.SkillListScrollFrame:SetPoint("BOTTOMRIGHT", bg, -30, 142)
    Skin.FauxScrollFrameTemplate(_G.SkillListScrollFrame)
    local top, bottom = _G.SkillListScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    Skin.UIPanelScrollFrameTemplate(_G.SkillDetailScrollFrame)
    top, bottom = _G.SkillDetailScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()
    Skin.SkillStatusBarTemplate(_G.SkillDetailStatusBar)

    -------------
    -- Section --
    -------------
end
