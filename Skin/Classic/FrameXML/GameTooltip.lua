local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\GameTooltip.lua ]]
    function Hook.GameTooltip_SetBackdropStyle(self, style)
        if not self.IsEmbedded then
            Skin.FrameTypeFrame(self)
        end
    end
    function Hook.EmbeddedItemTooltip_Clear(self)
        if not self._auroraIconBorder then
            Skin.InternalEmbeddedItemTooltipTemplate(self)
        end
        self._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
        self._auroraIconBorder:Hide()
    end
    function Hook.EmbeddedItemTooltip_PrepareForItem(self)
        self._auroraIconBorder:Show()
    end
    function Hook.EmbeddedItemTooltip_PrepareForSpell(self)
        self._auroraIconBorder:Show()
    end
end

do --[[ FrameXML\GameTooltip.xml ]]
    do --[[ GameTooltipTemplate ]]
        function Skin.GameTooltipTemplate(GameTooltip)
            Skin.FrameTypeFrame(GameTooltip)

            local statusBar = _G[GameTooltip:GetName().."StatusBar"]
            Skin.FrameTypeStatusBar(statusBar)
            Base.SetBackdropColor(statusBar, Color.frame)

            statusBar:SetHeight(4)
            statusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 1, 0)
            statusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -1, 0)
        end
        Skin.ShoppingTooltipTemplate = Base.SetBackdrop
        function Skin.TooltipStatusBarTemplate(StatusBar)
            Skin.FrameTypeStatusBar(StatusBar)
            local _, border = StatusBar:GetRegions()
            border:Hide()
        end
        function Skin.TooltipProgressBarTemplate(Frame)
            local bar = Frame.Bar
            Skin.FrameTypeStatusBar(bar)

            bar:GetStatusBarTexture():SetDrawLayer("BORDER")
            bar.BorderLeft:Hide()
            bar.BorderRight:Hide()
            bar.BorderMid:Hide()

            local LeftDivider = bar.LeftDivider
            LeftDivider:SetColorTexture(Color.button:GetRGB())
            LeftDivider:SetSize(1, 15)
            LeftDivider:SetPoint("LEFT", 73, 0)

            local RightDivider = bar.RightDivider
            RightDivider:SetColorTexture(Color.button:GetRGB())
            RightDivider:SetSize(1, 15)
            RightDivider:SetPoint("RIGHT", -73, 0)

            _G.select(7, bar:GetRegions()):Hide()
        end
    end
    do --[[ GameTooltip ]]
        function Skin.InternalEmbeddedItemTooltipTemplate(Frame)
            Base.CropIcon(Frame.Icon)
            local bg = _G.CreateFrame("Frame", nil, Frame)
            bg:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
            bg:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
            Base.SetBackdrop(bg, Color.black, 0)
            Frame._auroraIconBorder = bg
        end
    end
end

function private.FrameXML.GameTooltip()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("GameTooltip_SetBackdropStyle", Hook.GameTooltip_SetBackdropStyle)
    _G.hooksecurefunc("EmbeddedItemTooltip_Clear", Hook.EmbeddedItemTooltip_Clear)
    _G.hooksecurefunc("EmbeddedItemTooltip_PrepareForItem", Hook.EmbeddedItemTooltip_PrepareForItem)
    _G.hooksecurefunc("EmbeddedItemTooltip_PrepareForSpell", Hook.EmbeddedItemTooltip_PrepareForSpell)

    Skin.ShoppingTooltipTemplate(_G.ShoppingTooltip1)
    Skin.ShoppingTooltipTemplate(_G.ShoppingTooltip2)
    Skin.GameTooltipTemplate(_G.GameTooltip)
    Skin.GameTooltipTemplate(_G.EmbeddedItemTooltip)
    Skin.InternalEmbeddedItemTooltipTemplate(_G.EmbeddedItemTooltip.ItemTooltip)
end
