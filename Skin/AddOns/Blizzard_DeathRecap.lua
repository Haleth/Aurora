local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_DeathRecap.lua ]]
--end

do --[[ AddOns\Blizzard_DeathRecap.xml ]]
    function Skin.DeathRecapEntryTemplate(Frame)
        Base.CropIcon(Frame.SpellInfo.Icon, Frame)
        Frame.SpellInfo.IconBorder:Hide()
    end
end

function private.AddOns.Blizzard_DeathRecap()
    local DeathRecapFrame = _G.DeathRecapFrame

    Base.CreateBackdrop(DeathRecapFrame, private.backdrop, {
        tl = _G.DeathRecapFrameBorderTopLeft,
        tr = _G.DeathRecapFrameBorderTopRight,
        bl = _G.DeathRecapFrameBorderBottomLeft,
        br = _G.DeathRecapFrameBorderBottomRight,

        t = _G.DeathRecapFrameBorderTop,
        b = _G.DeathRecapFrameBorderBottom,
        l = _G.DeathRecapFrameBorderLeft,
        r = _G.DeathRecapFrameBorderRight,

        bg = _G.DeathRecapFrame.Background,

    })
    Base.SetBackdrop(DeathRecapFrame)

    local titleText = DeathRecapFrame.Title
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT")
    titleText:SetPoint("BOTTOMRIGHT", DeathRecapFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    DeathRecapFrame.Divider:Hide()

    Skin.UIPanelCloseButton(DeathRecapFrame.CloseXButton)
    DeathRecapFrame.CloseXButton:SetPoint("TOPRIGHT", 5, 5)
    DeathRecapFrame.DragButton:SetAllPoints(titleText)

    for i = 1, _G.NUM_DEATH_RECAP_EVENTS do
        Skin.DeathRecapEntryTemplate(DeathRecapFrame.DeathRecapEntry[i])
    end
    Skin.UIPanelButtonTemplate(DeathRecapFrame.CloseButton)
end
