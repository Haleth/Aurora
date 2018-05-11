local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
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
    _G.BattlefieldMapFrame.ScrollContainer:SetAllPoints()

    local r, g, b = Color.black:GetRGB()
    local BorderFrame = _G.BattlefieldMapFrame.BorderFrame
    BorderFrame.CloseButtonBorder:Hide()

    BorderFrame.TopLeft:SetColorTexture(r, g, b)
    BorderFrame.TopLeft:SetPoint("TOPLEFT")
    BorderFrame.TopLeft:SetSize(1, 1)
    BorderFrame.TopRight:SetColorTexture(r, g, b)
    BorderFrame.TopRight:SetPoint("TOPRIGHT")
    BorderFrame.TopRight:SetSize(1, 1)
    BorderFrame.BottomLeft:SetColorTexture(r, g, b)
    BorderFrame.BottomLeft:SetPoint("BOTTOMLEFT")
    BorderFrame.BottomLeft:SetSize(1, 1)
    BorderFrame.BottomRight:SetColorTexture(r, g, b)
    BorderFrame.BottomRight:SetPoint("BOTTOMRIGHT")
    BorderFrame.BottomRight:SetSize(1, 1)
    BorderFrame.Top:SetColorTexture(r, g, b)
    BorderFrame.Bottom:SetColorTexture(r, g, b)
    BorderFrame.Left:SetColorTexture(r, g, b)
    BorderFrame.Right:SetColorTexture(r, g, b)

    Skin.UIPanelCloseButton(BorderFrame.CloseButton)
    BorderFrame.CloseButton:SetPoint("TOPRIGHT", -1, -1)

    --[[ Scale ]]--
end

local F = _G.unpack(private.Aurora)
function private.AddOns.Blizzard_BattlefieldMinimap()
    _G.BattlefieldMinimapTab:DisableDrawLayer("BACKGROUND")

    local bg = F.CreateBDFrame(_G.BattlefieldMinimap, 1.0 - _G.BattlefieldMinimapOptions.opacity)
    _G.BattlefieldMinimap:SetPoint("TOPLEFT", _G.BattlefieldMinimapTab, "BOTTOMLEFT")
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", -5, 3)
    local r, g, b = bg:GetBackdropColor()

    _G.BattlefieldMinimapCorner:Hide()
    _G.BattlefieldMinimapBackground:Hide()
    _G.BattlefieldMinimapCloseButton:Hide()

    _G.hooksecurefunc("BattlefieldMinimap_UpdateOpacity", function()
        local alpha = 1.0 - _G.BattlefieldMinimapOptions.opacity
        bg:SetBackdropColor(r, g, b, alpha)
        bg:SetBackdropBorderColor(r, g, b, alpha)
    end)
end
