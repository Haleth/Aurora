local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do AddOns\Blizzard_BattlefieldMap.lua
end ]]

--[[ do AddOns\Blizzard_BattlefieldMap.xml
end ]]

function private.AddOns.Blizzard_BattlefieldMap()
    -----------------------
    -- BattlefieldMapTab --
    -----------------------
    _G.BattlefieldMapTab.Left:Hide()
    _G.BattlefieldMapTab.Middle:Hide()
    _G.BattlefieldMapTab.Right:Hide()

    -------------------------
    -- BattlefieldMapFrame --
    -------------------------
    local BattlefieldMapFrame = _G.BattlefieldMapFrame
    BattlefieldMapFrame.ScrollContainer:SetAllPoints()

    local BorderFrame = BattlefieldMapFrame.BorderFrame
    BorderFrame.CloseButtonBorder:Hide()
    Base.CreateBackdrop(BorderFrame, private.backdrop, {
        tl = BorderFrame.TopLeft,
        tr = BorderFrame.TopRight,
        bl = BorderFrame.BottomLeft,
        br = BorderFrame.BottomRight,

        t = BorderFrame.Top,
        b = BorderFrame.Bottom,
        l = BorderFrame.Left,
        r = BorderFrame.Right,
    })
    Base.SetBackdrop(BorderFrame, Color.frame, 0)

    Skin.UIPanelCloseButton(BorderFrame.CloseButton)
    BorderFrame.CloseButton:SetPoint("TOPRIGHT", 10, 9)
end
