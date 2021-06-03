local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\PaperDollFrame.lua ]]
    do --[[ PaperDollFrame.lua ]]
        function Hook.PaperDollFrame_SetLevel()
            local classLocale, classColor = private.charClass.locale, _G.CUSTOM_CLASS_COLORS[private.charClass.token]
            _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, _G.UnitLevel("player"), _G.UnitRace("player"), classColor:WrapTextInColorCode(classLocale))
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
        Skin.PaperDollItemSlotButtonTemplate = Skin.FrameTypeItemButton
        Skin.PaperDollItemSlotButtonLeftTemplate = Skin.PaperDollItemSlotButtonTemplate
        Skin.PaperDollItemSlotButtonRightTemplate = Skin.PaperDollItemSlotButtonTemplate
        Skin.PaperDollItemSlotButtonBottomTemplate = Skin.PaperDollItemSlotButtonTemplate
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
    _G.hooksecurefunc("PaperDollItemSlotButton_Update", Hook.PaperDollItemSlotButton_Update)

    local CharacterFrame = _G.CharacterFrame
    local tl, tr, bl, br = _G.PaperDollFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    _G.CharacterLevelText:SetPoint("CENTER", _G.CharacterNameText, "BOTTOM", 0, -4)
    Skin.UIDropDownMenuTemplate(_G.PlayerTitleDropDown)

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
    _G.PlayerStatLeftTop:Hide()
    _G.PlayerStatLeftMiddle:Hide()
    _G.PlayerStatLeftBottom:Hide()
    _G.PlayerStatRightTop:Hide()
    _G.PlayerStatRightMiddle:Hide()
    _G.PlayerStatRightBottom:Hide()

    Skin.UIDropDownMenuTemplate(_G.PlayerStatFrameLeftDropDown)
    Skin.UIDropDownMenuTemplate(_G.PlayerStatFrameRightDropDown)


    local EquipmentSlots = {
        "CharacterHeadSlot", "CharacterNeckSlot", "CharacterShoulderSlot", "CharacterBackSlot", "CharacterChestSlot", "CharacterShirtSlot", "CharacterTabardSlot", "CharacterWristSlot",
        "CharacterHandsSlot", "CharacterWaistSlot", "CharacterLegsSlot", "CharacterFeetSlot", "CharacterFinger0Slot", "CharacterFinger1Slot", "CharacterTrinket0Slot", "CharacterTrinket1Slot"
    }
    local WeaponSlots = {
        "CharacterMainHandSlot", "CharacterSecondaryHandSlot", "CharacterRangedSlot"
    }

    local bg = CharacterFrame:GetBackdropTexture("bg")
    local slotsPerSide, prevSlot = 8
    for i = 1, #EquipmentSlots do
        local button = _G[EquipmentSlots[i]]
        button:ClearAllPoints()
        local isLeftSide = button.IsLeftSide or i <= slotsPerSide

        if i % slotsPerSide == 1 then
            if isLeftSide then
                button:SetPoint("TOPLEFT", bg, 5, -30)
            else
                button:SetPoint("TOPRIGHT", bg, -5, -30)
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
            button:ClearAllPoints()
            button:SetPoint("BOTTOMLEFT", bg, 107, 8)
        end

        _G.select(button:GetNumRegions(), button:GetRegions()):Hide()
        Skin.PaperDollItemSlotButtonBottomTemplate(button)
    end

    local slot, _, _, arrow = _G.CharacterAmmoSlot:GetRegions()
    slot:Hide()
    arrow:SetSize(7, 14)
    Base.SetTexture(arrow, "arrowLeft")
    Base.CropIcon(_G.CharacterAmmoSlotIconTexture, _G.CharacterAmmoSlot)
    _G.CharacterAmmoSlot:SetNormalTexture("")
    Base.CropIcon(_G.CharacterAmmoSlot:GetPushedTexture())
    Base.CropIcon(_G.CharacterAmmoSlot:GetHighlightTexture())
end
