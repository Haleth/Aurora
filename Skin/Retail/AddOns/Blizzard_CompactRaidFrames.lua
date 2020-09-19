local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_CompactRaidFrames.lua ]]
    do --[[ Blizzard_CompactRaidFrameManager ]]
        function Hook.CompactRaidFrameManager_Toggle(self)
            if self.collapsed then
                Base.SetTexture(self.toggleButton:GetNormalTexture(), "arrowRight")
            else
                Base.SetTexture(self.toggleButton:GetNormalTexture(), "arrowLeft")
            end
         end
    end
end

do --[[ AddOns\Blizzard_CompactRaidFrames.xml ]]
    function Skin.CRFManagerFilterButtonTemplate(Button)
        Skin.UIMenuButtonStretchTemplate(Button)
        local bg = Button:GetBackdropTexture("bg")
        Button.selectedHighlight:SetColorTexture(1, 1, 0, 0.3)
        Button.selectedHighlight:SetPoint("TOPLEFT", bg, 1, -1)
        Button.selectedHighlight:SetPoint("BOTTOMRIGHT", bg, -1, 1)
    end
    Skin.CRFManagerFilterRoleButtonTemplate = Skin.CRFManagerFilterButtonTemplate
    Skin.CRFManagerFilterGroupButtonTemplate = Skin.CRFManagerFilterButtonTemplate
    function Skin.CRFManagerRaidIconButtonTemplate(Button)
        Button:SetSize(24, 24)
        Button:SetPoint(Button:GetPoint())

        Button:GetNormalTexture():SetSize(24, 24)
    end
end

function private.AddOns.Blizzard_CompactRaidFrames()
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameReservationManager --
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameContainer --
    ----====####$$$$%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameManager --
    ----====####$$$$%%%%%%$$$$####====----
    _G.hooksecurefunc("CompactRaidFrameManager_Toggle", Hook.CompactRaidFrameManager_Toggle)

    local CompactRaidFrameManager = _G.CompactRaidFrameManager
    CompactRaidFrameManager:DisableDrawLayer("ARTWORK")
    Base.SetBackdrop(CompactRaidFrameManager)

    local toggleButton = CompactRaidFrameManager.toggleButton
    toggleButton:SetPoint("RIGHT", -1, 0)
    toggleButton:SetScript("OnMouseDown", private.nop)
    toggleButton:SetScript("OnMouseUp", private.nop)

    local arrow = toggleButton:GetNormalTexture()
    arrow:ClearAllPoints()
    arrow:SetPoint("TOPLEFT", 3, -5)
    arrow:SetPoint("BOTTOMRIGHT", -3, 5)
    Base.SetTexture(arrow, "arrowRight")

    local displayFrame = CompactRaidFrameManager.displayFrame
    local displayFrameName = displayFrame:GetName()
    displayFrame:GetRegions():Hide()

    local headerDelineator = _G[displayFrameName.."HeaderDelineator"]
    headerDelineator:SetColorTexture(1, 1, 1)
    headerDelineator:SetPoint("TOPLEFT", 0, -27)
    headerDelineator:SetPoint("TOPRIGHT", -7, -27)
    headerDelineator:SetHeight(1)

    local optionsButton = _G[displayFrameName.."OptionsButton"]
    Skin.UIPanelInfoButton(optionsButton)

    displayFrame.optionsFlowContainer:SetPoint("TOPLEFT", headerDelineator, "BOTTOMLEFT", -10, -1)

    Skin.UIDropDownMenuTemplate(displayFrame.profileSelector)

    local filterOptions = displayFrame.filterOptions
    local footerDelineator = _G[filterOptions:GetName().."FooterDelineator"]
    footerDelineator:SetColorTexture(1, 1, 1)
    footerDelineator:SetPoint("BOTTOMLEFT", 0, 7)
    footerDelineator:SetPoint("BOTTOMRIGHT", 4, 7)
    footerDelineator:SetHeight(1)

    if private.isRetail then
        Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleTank)
        Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleHealer)
        Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleDamager)
    end
    for i = 1, 8 do
        Skin.CRFManagerFilterGroupButtonTemplate(filterOptions["filterGroup"..i])
    end

    Skin.UIMenuButtonStretchTemplate(displayFrame.lockedModeToggle)
    Skin.UIMenuButtonStretchTemplate(displayFrame.hiddenModeToggle)
    Skin.UIMenuButtonStretchTemplate(displayFrame.convertToRaid)

    local icons = {displayFrame.raidMarkers:GetChildren()}
    for i, icon in next, icons do
        Skin.CRFManagerRaidIconButtonTemplate(icon)
    end

    local leaderOptions = displayFrame.leaderOptions
    if private.isRetail then
        Skin.UIMenuButtonStretchTemplate(leaderOptions.rolePollButton)
    end
    Skin.UIMenuButtonStretchTemplate(leaderOptions.readyCheckButton)
    if private.isRetail then
        Skin.UIMenuButtonStretchTemplate(_G[leaderOptions:GetName().."RaidWorldMarkerButton"])
    end

    Skin.UICheckButtonTemplate(displayFrame.everyoneIsAssistButton)
end
