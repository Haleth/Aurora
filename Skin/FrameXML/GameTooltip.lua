local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ Core ]]
local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ SharedXML\GameTooltipTemplate.xml ]]
    function Skin.GameTooltipTemplate(gametooltip)
        Base.SetBackdrop(gametooltip, Aurora.frameColor:GetRGBA())
    end
    function Skin.ShoppingTooltipTemplate(gametooltip)
        Base.SetBackdrop(gametooltip, Aurora.frameColor:GetRGBA())
    end
    function Skin.TooltipMoneyFrameTemplate(frame)
        Skin.SmallMoneyFrameTemplate(frame)
    end
    function Skin.TooltipStatusBarTemplate(statusbar)
    end
    function Skin.TooltipProgressBarTemplate(frame)
        Base.SetTexture(frame.Bar:GetStatusBarTexture(), "gradientUp")

        local bar = frame.Bar
        Base.SetBackdrop(bar, Aurora.frameColor:GetRGBA())
        bar:SetBackdropBorderColor(Aurora.buttonColor:GetRGB())
        bar:GetStatusBarTexture():SetDrawLayer("BORDER")

        bar.BorderLeft:Hide()
        bar.BorderRight:Hide()
        bar.BorderMid:Hide()

        local LeftDivider = bar.LeftDivider
        LeftDivider:SetColorTexture(Aurora.buttonColor:GetRGB())
        LeftDivider:SetSize(1, 15)
        LeftDivider:SetPoint("LEFT", 73, 0)

        local RightDivider = bar.RightDivider
        RightDivider:SetColorTexture(Aurora.buttonColor:GetRGB())
        RightDivider:SetSize(1, 15)
        RightDivider:SetPoint("RIGHT", -73, 0)

        _G.select(7, bar:GetRegions()):Hide()
    end
end

do --[[ FrameXML\GameTooltip.lua ]]
    function Hook.GameTooltip_OnHide(gametooltip)
        Base.SetBackdropColor(gametooltip, Aurora.frameColor:GetRGBA())
    end
end
do --[[ FrameXML\GameTooltip.xml ]]
    function Skin.EmbeddedItemTooltip(frame)
        Base.CropIcon(frame.Icon)
        local bg = _G.CreateFrame("Frame", nil, frame)
        bg:SetPoint("TOPLEFT", frame.Icon, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", frame.Icon, 1, -1)
        Base.SetBackdrop(bg, 0,0,0,0)
        frame._auroraIconBorder = bg
    end
end

function private.FrameXML.GameTooltip()
    _G.hooksecurefunc("GameTooltip_OnHide", Hook.GameTooltip_OnHide)
    if not _G.AuroraConfig.tooltips then return end

    local tooltips = {
        "GameTooltip",
        "ItemRefTooltip",
        "ShoppingTooltip1",
        "ShoppingTooltip2",
        "WorldMapTooltip",
        "ChatMenu",
        "EmoteMenu",
        "LanguageMenu",
        "VoiceMacroMenu",
    }

    for i = 1, #tooltips do
        F.ReskinTooltip(_G[tooltips[i]])
    end

    local sb = _G["GameTooltipStatusBar"]
    sb:SetHeight(3)
    sb:ClearAllPoints()
    sb:SetPoint("BOTTOMLEFT", _G.GameTooltip, "BOTTOMLEFT", 1, 1)
    sb:SetPoint("BOTTOMRIGHT", _G.GameTooltip, "BOTTOMRIGHT", -1, 1)
    sb:SetStatusBarTexture(C.media.backdrop)

    local sep = _G.GameTooltipStatusBar:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("BOTTOMLEFT", 0, 3)
    sep:SetPoint("BOTTOMRIGHT", 0, 3)
    sep:SetTexture(C.media.backdrop)
    sep:SetVertexColor(0, 0, 0)

    F.CreateBD(_G.FriendsTooltip)

    F.ReskinClose(_G.ItemRefCloseButton)

    -- [[ Pet battle tooltips ]]

    local petTooltips = {"PetBattlePrimaryAbilityTooltip", "PetBattlePrimaryUnitTooltip", "FloatingBattlePetTooltip", "BattlePetTooltip", "FloatingPetBattleAbilityTooltip"}
    for _, tooltipName in next, petTooltips do
        local tooltip = _G[tooltipName]
        tooltip:DisableDrawLayer("BACKGROUND")
        local bg = _G.CreateFrame("Frame", nil, tooltip)
        bg:SetAllPoints()
        bg:SetFrameLevel(0)
        F.CreateBD(bg)

        if tooltip.Delimiter then
            tooltip.Delimiter:SetColorTexture(0, 0, 0)
            tooltip.Delimiter:SetHeight(1)
        elseif tooltip.Delimiter1 then
            tooltip.Delimiter1:SetHeight(1)
            tooltip.Delimiter1:SetColorTexture(0, 0, 0)
            tooltip.Delimiter2:SetHeight(1)
            tooltip.Delimiter2:SetColorTexture(0, 0, 0)
        end

        if tooltip.CloseButton then
            F.ReskinClose(tooltip.CloseButton)
        end
    end
end
