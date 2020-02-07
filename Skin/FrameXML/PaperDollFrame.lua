local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\PaperDollFrame.lua ]]
    do --[[ PaperDollFrame.lua ]]
        function Hook.PaperDollFrame_SetLevel()
            local classLocale, classColor = private.charClass.locale, _G.CUSTOM_CLASS_COLORS[private.charClass.token]

            if private.isRetail then
                local level = _G.UnitLevel("player")
                local effectiveLevel = _G.UnitEffectiveLevel("player")

                if ( effectiveLevel ~= level ) then
                    level = _G.EFFECTIVE_LEVEL_FORMAT:format(effectiveLevel, level)
                end

                local _, specName = _G.GetSpecializationInfo(_G.GetSpecialization(), nil, nil, nil, _G.UnitSex("player"))
                if specName and specName ~= "" then
                    _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, level, classColor.colorStr, specName, classLocale)
                end

                local showTrialCap = false
                if _G.GameLimitedMode_IsActive() then
                    local rLevel = _G.GetRestrictedAccountData()
                    if _G.UnitLevel("player") >= rLevel then
                        showTrialCap = true
                    end
                end
                if showTrialCap then
                    _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterFrame.TitleText, "TOP", 0, -36)
                else
                    --_G.CharacterTrialLevelErrorText:Show()
                    _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterFrame.TitleText, "BOTTOM", 0, -4)
                end
            else
                _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, _G.UnitLevel("player"), _G.UnitRace("player"), classColor:WrapTextInColorCode(classLocale))
            end
        end
        function Hook.PaperDollItemSlotButton_Update(self)
            local quality = _G.GetInventoryItemQuality("player", self:GetID());
            Hook.SetItemButtonQuality(self, quality, _G.GetInventoryItemID("player", self:GetID()));
        end
    end
end

do --[[ FrameXML\PaperDollFrame.xml ]]
    do --[[ AzeritePaperDollItemOverlay.xml ]]
        function Skin.PaperDollAzeriteItemOverlayTemplate(Frame)
            Frame.RankFrame.Label:SetPoint("CENTER", Frame.RankFrame.Texture, 0, 0)
        end
    end
    do --[[ PaperDollFrame.xml ]]
        function Skin.PaperDollItemSlotButtonTemplate(ItemButton)
            Skin.FrameTypeItemButton(ItemButton)
            if private.isRetail then
                Skin.PaperDollAzeriteItemOverlayTemplate(ItemButton)
                _G[ItemButton:GetName().."Frame"]:Hide()

                if ItemButton.verticalFlyout then
                    ItemButton.popoutButton:SetPoint("TOP", ItemButton, "BOTTOM")
                    ItemButton.popoutButton:SetSize(38, 8)
                    Skin.EquipmentFlyoutPopoutButtonTemplate(ItemButton.popoutButton)
                    Base.SetTexture(ItemButton.popoutButton._auroraArrow, "arrowDown")
                else
                    ItemButton.popoutButton:SetPoint("LEFT", ItemButton, "RIGHT")
                    ItemButton.popoutButton:SetSize(8, 38)
                    Skin.EquipmentFlyoutPopoutButtonTemplate(ItemButton.popoutButton)
                end
            end
        end
        function Skin.PaperDollItemSlotButtonLeftTemplate(ItemButton)
            Skin.PaperDollItemSlotButtonTemplate(ItemButton)
        end
        function Skin.PaperDollItemSlotButtonRightTemplate(ItemButton)
            Skin.PaperDollItemSlotButtonTemplate(ItemButton)
        end
        function Skin.PaperDollItemSlotButtonBottomTemplate(ItemButton)
            Skin.PaperDollItemSlotButtonTemplate(ItemButton)
        end
        function Skin.PlayerTitleButtonTemplate(Button)
            Button.BgTop:SetTexture("")
            Button.BgBottom:SetTexture("")
            Button.BgMiddle:SetTexture("")

            Button.SelectedBar:SetColorTexture(1, 1, 0, 0.3)
            Button:GetHighlightTexture():SetColorTexture(0, 0, 1, 0.2)
        end
        function Skin.GearSetButtonTemplate(Button)
            Button.BgTop:SetTexture("")
            Button.BgBottom:SetTexture("")
            Button.BgMiddle:SetTexture("")

            Button.HighlightBar:SetColorTexture(0, 0, 1, 0.3)
            Button.SelectedBar:SetColorTexture(1, 1, 0, 0.3)

            Base.CropIcon(Button.icon, Button)
        end
        function Skin.GearSetPopupButtonTemplate(CheckButton)
            Skin.SimplePopupButtonTemplate(CheckButton)
            Base.CropIcon(_G[CheckButton:GetName().."Icon"])
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
        function Skin.PaperDollSidebarTabTemplate(Button)
            Button.TabBg:SetAlpha(0)
            Button.Hider:SetTexture("")

            Button.Icon:ClearAllPoints()
            Button.Icon:SetPoint("TOPLEFT", 1, -1)
            Button.Icon:SetPoint("BOTTOMRIGHT", -1, 1)

            Button.Highlight:SetTexture("")

            Base.SetBackdrop(Button, Color.button)
            Base.SetHighlight(Button, "backdrop")
        end

        function Skin.MagicResistanceFrameTemplate(Frame)
            Frame:SetSize(20, 20)
            local icon = Frame:GetRegions()
            Frame._icon = icon
            Base.CropIcon(icon, Frame)
        end
    end
end

function private.FrameXML.PaperDollFrame()
    _G.hooksecurefunc("PaperDollFrame_SetLevel", Hook.PaperDollFrame_SetLevel)
    if private.isClassic then
        _G.hooksecurefunc("PaperDollItemSlotButton_Update", Hook.PaperDollItemSlotButton_Update)
    end

    local CharacterFrame = _G.CharacterFrame
    if private.isRetail then
        local bg = CharacterFrame.NineSlice:GetBackdropTexture("bg")
        local classBG = _G.PaperDollFrame:CreateTexture(nil, "BORDER")
        classBG:SetAtlas("dressingroom-background-"..private.charClass.token)
        classBG:SetPoint("TOPLEFT", bg)
        classBG:SetPoint("BOTTOM", bg)
        classBG:SetPoint("RIGHT", CharacterFrame.Inset, 4, 0)
        classBG:SetAlpha(0.5)

        _G.PaperDollSidebarTabs:ClearAllPoints()
        _G.PaperDollSidebarTabs:SetPoint("BOTTOM", CharacterFrame.InsetRight, "TOP", 0, -3)
        _G.PaperDollSidebarTabs.DecorLeft:Hide()
        _G.PaperDollSidebarTabs.DecorRight:Hide()

        for i = 1, #_G.PAPERDOLL_SIDEBARS do
            local tab = _G["PaperDollSidebarTab"..i]
            Skin.PaperDollSidebarTabTemplate(tab)
        end


        Hook.HybridScrollFrame_CreateButtons(_G.PaperDollTitlesPane, "PlayerTitleButtonTemplate") -- Called here since the original is called OnLoad
        _G.PaperDollTitlesPane:SetPoint("BOTTOMRIGHT", CharacterFrame.InsetRight, -4, 4)
        Skin.HybridScrollBarTemplate(_G.PaperDollTitlesPane.scrollBar)
        _G.PaperDollTitlesPane.scrollBar:ClearAllPoints()
        _G.PaperDollTitlesPane.scrollBar:SetPoint("TOPRIGHT", 2, -19)
        _G.PaperDollTitlesPane.scrollBar:SetPoint("BOTTOMRIGHT", 2, 15)


        local PaperDollEquipmentManagerPane = _G.PaperDollEquipmentManagerPane
        Hook.HybridScrollFrame_CreateButtons(PaperDollEquipmentManagerPane, "GearSetButtonTemplate") -- Called here since the original is called OnLoad
        PaperDollEquipmentManagerPane:SetPoint("BOTTOMRIGHT", CharacterFrame.InsetRight, -4, 4)

        Skin.UIPanelButtonTemplate(PaperDollEquipmentManagerPane.EquipSet)
        Skin.UIPanelButtonTemplate(PaperDollEquipmentManagerPane.SaveSet)

        Skin.HybridScrollBarTemplate(PaperDollEquipmentManagerPane.scrollBar)
        PaperDollEquipmentManagerPane.scrollBar:ClearAllPoints()
        PaperDollEquipmentManagerPane.scrollBar:SetPoint("TOPRIGHT", 2, -19)
        PaperDollEquipmentManagerPane.scrollBar:SetPoint("BOTTOMRIGHT", 2, 15)


        _G.CharacterModelFrame:SetPoint("TOPLEFT", CharacterFrame.Inset, 45, -10)
        _G.CharacterModelFrame:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, -45, 30)

        _G.CharacterModelFrameBackgroundTopLeft:Hide()
        _G.CharacterModelFrameBackgroundTopRight:Hide()
        _G.CharacterModelFrameBackgroundBotLeft:Hide()
        _G.CharacterModelFrameBackgroundBotRight:Hide()

        _G.CharacterModelFrameBackgroundOverlay:Hide()

        _G.PaperDollInnerBorderTopLeft:Hide()
        _G.PaperDollInnerBorderTopRight:Hide()
        _G.PaperDollInnerBorderBottomLeft:Hide()
        _G.PaperDollInnerBorderBottomRight:Hide()
        _G.PaperDollInnerBorderLeft:Hide()
        _G.PaperDollInnerBorderRight:Hide()
        _G.PaperDollInnerBorderTop:Hide()
        _G.PaperDollInnerBorderBottom:Hide()
        _G.PaperDollInnerBorderBottom2:Hide()
    else
        local tl, tr, bl, br = _G.PaperDollFrame:GetRegions()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()

        _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterNameText, "BOTTOM", 0, -4)

        Skin.NavButtonNext(_G.CharacterModelFrameRotateRightButton)
        Skin.NavButtonPrevious(_G.CharacterModelFrameRotateLeftButton)

        -- Resists
        local resists = {
            {icon = [[Interface\Icons\Spell_Arcane_StarFire]]},
            {icon = [[Interface\Icons\INV_SummerFest_FireSpirit]]},
            {icon = [[Interface\Icons\Spell_Nature_ResistNature]]},
            {icon = [[Interface\Icons\Spell_Frost_FreezingBreath]]},
            {icon = [[Interface\Icons\Spell_Shadow_Twilight]]},
        }
        for i = 1, #resists do
            local frame = _G["MagicResFrame"..i]
            Skin.MagicResistanceFrameTemplate(frame)
            frame._icon:SetTexture(resists[i].icon)

            frame:ClearAllPoints()
            if i == 1 then
                frame:SetPoint("TOPRIGHT", -5, -5)
            else
                frame:SetPoint("TOPRIGHT", _G["MagicResFrame"..i - 1], "BOTTOMRIGHT", 0, -6)
            end
        end

        -- Stats
        _G.PlayerStatBackgroundTop:Hide()
        _G.PlayerStatBackgroundMiddle:Hide()
        _G.PlayerStatBackgroundBottom:Hide()
        _G.MeleeAttackBackgroundTop:Hide()
        _G.MeleeAttackBackgroundMiddle:Hide()
        _G.MeleeAttackBackgroundBottom:Hide()
        _G.RangedAttackBackgroundTop:Hide()
        _G.RangedAttackBackgroundMiddle:Hide()
        _G.RangedAttackBackgroundBottom:Hide()
    end


    local EquipmentSlots = {
        "CharacterHeadSlot", "CharacterNeckSlot", "CharacterShoulderSlot", "CharacterBackSlot", "CharacterChestSlot", "CharacterShirtSlot", "CharacterTabardSlot", "CharacterWristSlot",
        "CharacterHandsSlot", "CharacterWaistSlot", "CharacterLegsSlot", "CharacterFeetSlot", "CharacterFinger0Slot", "CharacterFinger1Slot", "CharacterTrinket0Slot", "CharacterTrinket1Slot"
    }
    local WeaponSlots = {
        "CharacterMainHandSlot", "CharacterSecondaryHandSlot", private.isClassic and "CharacterRangedSlot" or nil
    }

    local slotsPerSide, prevSlot = 8
    for i = 1, #EquipmentSlots do
        local button = _G[EquipmentSlots[i]]
        button:ClearAllPoints()
        local isLeftSide = button.IsLeftSide or i <= slotsPerSide

        if i % slotsPerSide == 1 then
            if private.isRetail then
                if isLeftSide then
                    button:SetPoint("TOPLEFT", CharacterFrame.Inset, 4, -11)
                else
                    button:SetPoint("TOPRIGHT", CharacterFrame.Inset, -4, -11)
                end
            else
                local bg = CharacterFrame:GetBackdropTexture("bg")
                if isLeftSide then
                    button:SetPoint("TOPLEFT", bg, 5, -30)
                else
                    button:SetPoint("TOPRIGHT", bg, -5, -30)
                end
            end
        else
            button:SetPoint("TOPLEFT", prevSlot, "BOTTOMLEFT", 0, -6)
        end

        if isLeftSide then
            Skin.PaperDollItemSlotButtonLeftTemplate(button)
        elseif isLeftSide == false then
            Skin.PaperDollItemSlotButtonRightTemplate(button)
        end

        prevSlot = button
    end

    for i = 1, #WeaponSlots do
        local button = _G[WeaponSlots[i]]

        if i == 1 then
            -- main hand
            if private.isRetail then
                button:SetPoint("BOTTOMLEFT", 130, 8)
            else
                local bg = CharacterFrame:GetBackdropTexture("bg")
                button:ClearAllPoints()
                button:SetPoint("BOTTOMLEFT", bg, 107, 8)
            end
        end

        _G.select(button:GetNumRegions(), button:GetRegions()):Hide()
        Skin.PaperDollItemSlotButtonBottomTemplate(button)
    end

    if private.isClassic then
        local slot, _, _, arrow = _G.CharacterAmmoSlot:GetRegions()
        slot:Hide()
        arrow:SetSize(7, 14)
        Base.SetTexture(arrow, "arrowLeft")
        Base.CropIcon(_G.CharacterAmmoSlotIconTexture, _G.CharacterAmmoSlot)
        _G.CharacterAmmoSlot:SetNormalTexture("")
        Base.CropIcon(_G.CharacterAmmoSlot:GetPushedTexture())
        Base.CropIcon(_G.CharacterAmmoSlot:GetHighlightTexture())
    end

    if private.isRetail then
        local GearManagerDialogPopup = _G.GearManagerDialogPopup
        Base.SetBackdrop(GearManagerDialogPopup)
        GearManagerDialogPopup:SetSize(510, 520)
        GearManagerDialogPopup.BG:Hide()
        Hook.BuildIconArray(GearManagerDialogPopup, "GearManagerDialogPopupButton", "GearSetPopupButtonTemplate", _G.NUM_GEARSET_ICONS_PER_ROW, _G.NUM_GEARSET_ICON_ROWS)

        local BorderBox = GearManagerDialogPopup.BorderBox
        for i = 1, 8 do
            select(i, BorderBox:GetRegions()):Hide()
        end

        _G.GearManagerDialogPopupEditBoxLeft:Hide()
        _G.GearManagerDialogPopupEditBoxMiddle:Hide()
        _G.GearManagerDialogPopupEditBoxRight:Hide()
        Base.SetBackdrop(_G.GearManagerDialogPopupEditBox)

        Skin.UIPanelButtonTemplate(_G.GearManagerDialogPopupCancel)
        Skin.UIPanelButtonTemplate(_G.GearManagerDialogPopupOkay)

        Skin.ListScrollFrameTemplate(_G.GearManagerDialogPopupScrollFrame)
        _G.GearManagerDialogPopupScrollFrame:ClearAllPoints()
        _G.GearManagerDialogPopupScrollFrame:SetPoint("TOPLEFT", 22, -81)
        _G.GearManagerDialogPopupScrollFrame:SetPoint("BOTTOMRIGHT", -29, 42)
    end
end
