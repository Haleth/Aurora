local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

-- TODO: Added Pet Paperdoll panel and stats. Added Honor panel. Added Skill panel.

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
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
    Base.SetBackdrop(CharacterFrame)
    _G.CharacterFramePortrait:SetAlpha(0)
    Skin.UIPanelCloseButton(_G.CharacterFrameCloseButton)
    _G.CharacterFrameCloseButton:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", 4, 5)
    _G.CharacterNameFrame:SetPoint("TOP", CharacterFrame, "TOP", 0, -5)

    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab2)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab3)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab4)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab5)
    Util.PositionRelative("TOPLEFT", CharacterFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.CharacterFrameTab1,
        _G.CharacterFrameTab2,
        _G.CharacterFrameTab3,
        _G.CharacterFrameTab4,
        _G.CharacterFrameTab5,
    })
end
