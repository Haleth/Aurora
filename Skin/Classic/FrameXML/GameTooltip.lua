local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\GameTooltip.lua ]]
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
    function Skin.GameTooltipTemplate(GameTooltip)
        Skin.SharedTooltipTemplate(GameTooltip)

        local statusBar = _G[GameTooltip:GetName().."StatusBar"]
        Skin.FrameTypeStatusBar(statusBar)
        Base.SetBackdropColor(statusBar, Color.frame)

        statusBar:SetHeight(4)
        statusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 1, 0)
        statusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -1, 0)
    end
    function Skin.InternalEmbeddedItemTooltipTemplate(Frame)
        Base.CropIcon(Frame.Icon)
        local bg = _G.CreateFrame("Frame", nil, Frame)
        bg:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
        Base.SetBackdrop(bg, Color.black, 0)
        Frame._auroraIconBorder = bg

        if private.isRetail then
            Skin.GarrisonFollowerTooltipContentsTemplate(Frame.FollowerTooltip)
            Util.Mixin(_G.GarrisonFollowerPortraitMixin, Hook.GarrisonFollowerPortraitMixin)
        end
    end
    function Skin.ShoppingTooltipTemplate(GameTooltip)
        Skin.SharedTooltipTemplate(GameTooltip)
    end
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

function private.FrameXML.GameTooltip()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("EmbeddedItemTooltip_Clear", Hook.EmbeddedItemTooltip_Clear)
    _G.hooksecurefunc("EmbeddedItemTooltip_PrepareForItem", Hook.EmbeddedItemTooltip_PrepareForItem)
    _G.hooksecurefunc("EmbeddedItemTooltip_PrepareForSpell", Hook.EmbeddedItemTooltip_PrepareForSpell)

    Skin.ShoppingTooltipTemplate(_G.ShoppingTooltip1)
    Skin.ShoppingTooltipTemplate(_G.ShoppingTooltip2)
    Skin.GameTooltipTemplate(_G.GameTooltip)
    Skin.GameTooltipTemplate(_G.EmbeddedItemTooltip)
    Skin.InternalEmbeddedItemTooltipTemplate(_G.EmbeddedItemTooltip.ItemTooltip)
end
