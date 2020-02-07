local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ FrameXML\CharacterFrame.lua ]]
--end

do --[[ FrameXML\CharacterFrame.xml ]]
    function Skin.CharacterStatFrameCategoryTemplate(Button)
        local bg = Button.Background
        bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
        bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
        bg:ClearAllPoints()
        bg:SetPoint("CENTER", 0, -5)
        bg:SetSize(210, 30)

        local r, g, b = Color.highlight:GetRGB()
        bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7)
    end
    function Skin.CharacterStatFrameTemplate(Button)
        local bg = Button.Background
        bg:ClearAllPoints()
        bg:SetPoint("TOPLEFT")
        bg:SetPoint("BOTTOMRIGHT")
        bg:SetColorTexture(1, 1, 1, 0.2)
    end
end

function private.FrameXML.CharacterFrame()
    local CharacterFrame = _G.CharacterFrame
    if private.isRetail then
        Skin.ButtonFrameTemplate(CharacterFrame)

        CharacterFrame.TitleText:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, "TOPRIGHT", 0, 0)
        CharacterFrame.Inset:SetPoint("TOPLEFT", 4, -private.FRAME_TITLE_HEIGHT)
        CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", _G.PANEL_DEFAULT_WIDTH + _G.PANEL_INSET_RIGHT_OFFSET, 4)

        Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab1)
        Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab2)
        Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab3)
        Util.PositionRelative("TOPLEFT", CharacterFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
            _G.CharacterFrameTab1,
            _G.CharacterFrameTab2,
            _G.CharacterFrameTab3,
        })

        Skin.InsetFrameTemplate(CharacterFrame.InsetRight)
        CharacterFrame.InsetRight:SetPoint("TOPLEFT", CharacterFrame.Inset, "TOPRIGHT", 1, -20)

        local CharacterStatsPane = _G.CharacterStatsPane
        Util.Mixin(CharacterStatsPane.statsFramePool, Hook.ObjectPoolMixin)

        local ClassBackground = CharacterStatsPane.ClassBackground
        local atlas = "legionmission-landingpage-background-"..private.charClass.token
        local info = _G.C_Texture.GetAtlasInfo(atlas)
        ClassBackground:ClearAllPoints()
        ClassBackground:SetPoint("CENTER")
        ClassBackground:SetSize(_G.Round(info.width * 0.7), _G.Round(info.height * 0.7))
        ClassBackground:SetAtlas(atlas)
        ClassBackground:SetDesaturated(true)
        ClassBackground:SetAlpha(0.4)


        CharacterStatsPane.ItemLevelFrame.Value:SetFontObject("SystemFont_Shadow_Huge2")
        CharacterStatsPane.ItemLevelFrame.Value:SetShadowOffset(0, 0)
        CharacterStatsPane.ItemLevelFrame.Background:Hide()
        Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.ItemLevelCategory)
        Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.AttributesCategory)
        Skin.CharacterStatFrameCategoryTemplate(CharacterStatsPane.EnhancementsCategory)
    else
        Base.SetBackdrop(CharacterFrame)
        CharacterFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local portrait = CharacterFrame:GetRegions()
        portrait:Hide()

        local bg = CharacterFrame:GetBackdropTexture("bg")
        _G.CharacterNameText:ClearAllPoints()
        _G.CharacterNameText:SetPoint("TOPLEFT", bg)
        _G.CharacterNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Skin.UIPanelCloseButton(_G.CharacterFrameCloseButton)

        Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab1)
        Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab2)
        Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab3)
        Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab4)
        Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab5)
        Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
            _G.CharacterFrameTab1,
            _G.CharacterFrameTab2,
            _G.CharacterFrameTab3,
            _G.CharacterFrameTab4,
            _G.CharacterFrameTab5,
        })
    end
end
