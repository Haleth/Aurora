local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next ipairs floor max

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_PetBattleUI.lua ]]
    function Hook.PetBattleUnitFrame_UpdateDisplay(self)
        local petOwner = self.petOwner
        local petIndex = self.petIndex

        if not petOwner or not petIndex then
            return
        end

        if petIndex > _G.C_PetBattles.GetNumPets(petOwner) then
            return
        end

        if self.Icon then
            if petOwner == _G.LE_BATTLE_PET_ALLY then
                self.Icon:SetTexCoord(.92, .08, .08, .92)
            else
                self.Icon:SetTexCoord(.08, .92, .08, .92)
            end
        end

        if self._auroraIconBG then
            if _G.C_PetBattles.GetHealth(petOwner, petIndex) == 0 then
                self._auroraIconBG:SetColorTexture(1, 0, 0)
            else
                local rarity = _G.C_PetBattles.GetBreedQuality(petOwner, petIndex)
                local color = _G.ITEM_QUALITY_COLORS[rarity-1]
                self._auroraIconBG:SetColorTexture(color.r, color.g, color.b)
            end
        end
    end
    function Hook.PetBattleUnitFrame_UpdateHealthInstant(self)
        local petOwner = self.petOwner
        local petIndex = self.petIndex

        local health = _G.C_PetBattles.GetHealth(petOwner, petIndex)
        local maxHealth = _G.C_PetBattles.GetMaxHealth(petOwner, petIndex)
        if ( self.ActualHealthBar ) then
            if ( health == 0 ) then
                self.ActualHealthBar:Hide()
            else
                self.ActualHealthBar:Show()
            end

            local healthWidth = self.HealthBarBG and self.HealthBarBG:GetWidth() or Scale.Value(self.healthBarWidth)
            self.ActualHealthBar:SetWidth((health / max(maxHealth, 1)) * healthWidth)
        end
    end
    function Hook.PetBattleUnitTooltip_UpdateForUnit(self)
        for i, frame in ipairs(self.Debuffs.frames) do
            if not frame._auroraSkinned then
                Skin.PetBattleUnitTooltipAuraTemplate(frame)
                frame._auroraSkinned = true
            end
        end
    end
    function Hook.PetBattleFrame_UpdateActionButtonLevel(self, actionButton)
        if actionButton.Icon and not actionButton._auroraSkinned then
            Skin.PetBattleAbilityButtonTemplate(actionButton)
            actionButton._auroraSkinned = true
        end
    end
    function Hook.PetBattleFrame_UpdateActionBarLayout(self)
        local flowFrame = self.BottomFrame.FlowFrame

        local usedX = Hook.FlowContainer_GetUsedBounds(flowFrame)
        Scale.RawSetWidth(flowFrame, usedX)
        Scale.RawSetWidth(self.BottomFrame, usedX + Scale.Value(200))

        _G.C_Timer.After(0, function()
            -- wait 1 frame to allow xpBar to update its size
            local xpBar = self.BottomFrame.xpBar
            local divWidth = xpBar:GetWidth() / 7
            local xpos = divWidth
            for i = 1, #xpBar._auroraDivs do
                Scale.RawSetPoint(xpBar._auroraDivs[i], "LEFT", floor(xpos), 0)
                xpos = xpos + divWidth
            end
        end)
    end
    function Hook.PetBattleAuraHolder_Update(self)
        if not self.petOwner or not self.petIndex then return end

        local nextFrame = 1
        for i, frame in ipairs(self.frames) do
            if not frame._auroraSkinned then
                Skin.PetBattleAuraTemplate(frame)
                frame._auroraSkinned = true
            end
            nextFrame = nextFrame + 1
        end

        if nextFrame > 1 then
            --We have at least one aura displayed
            local numRows = floor((nextFrame - 2) / self.numPerRow) + 1 -- -2, 1 for this being the "next", not "previous" frame, 1 for 0-based math.
            self:SetHeight(self.frames[1]:GetHeight() * numRows)
            self:Show()
        end
    end
end

do --[[ AddOns\Blizzard_PetBattleUI.xml ]]
    function Skin.PetBattleAuraTemplate(Frame)
        Base.CropIcon(Frame.Icon)
        Frame.DebuffBorder:SetDrawLayer("BORDER")
        Frame.DebuffBorder:SetColorTexture(1, 0, 0)
        Frame.DebuffBorder:ClearAllPoints()
        Frame.DebuffBorder:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
        Frame.DebuffBorder:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)

        --[[ Scale ]]--
        Frame:SetSize(60, 49)
        Frame.Icon:SetSize(30, 30)
        Frame.Duration:SetPoint("TOP", Frame.Icon, "BOTTOM", 0, -2)
    end
    function Skin.PetBattleAuraHolderTemplate(Frame)
        --[[ Scale ]]--
        Frame:SetSize(222, 1)
        Frame._auroraNoSetHeight = true
    end
    function Skin.PetBattleUnitTooltipAuraTemplate(Frame)
        Base.CropIcon(Frame.Icon)
        Frame.DebuffBorder:SetDrawLayer("BORDER")
        Frame.DebuffBorder:SetColorTexture(1, 0, 0)
        Frame.DebuffBorder:ClearAllPoints()
        Frame.DebuffBorder:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
        Frame.DebuffBorder:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)

        --[[ Scale ]]--
        Frame:SetSize(250, 32)
        Frame.Icon:SetSize(30, 30)
        Frame.Name:SetPoint("TOPLEFT", Frame.Icon, "TOPRIGHT", 5, 0)
        Frame.Name:SetPoint("BOTTOMRIGHT", Frame.Icon, 210, 12)
        Frame.Duration:SetPoint("TOPLEFT", Frame.Icon, "BOTTOMRIGHT", 5, 10)
        Frame.Duration:SetPoint("BOTTOMRIGHT", Frame.Icon, 210, 0)
    end
    function Skin.PetBattleMiniUnitFrameAlly(Button)
        Button._auroraIconBG = Base.CropIcon(Button.Icon, Button)

        Button.HealthBarBG:SetPoint("BOTTOMLEFT")
        Button.HealthBarBG:SetPoint("TOPRIGHT", Button, "BOTTOMRIGHT", 0, 7)
        Base.SetTexture(Button.ActualHealthBar, "gradientUp")

        Button.ActualHealthBar:SetPoint("BOTTOMLEFT", Button.HealthBarBG)
        Button.ActualHealthBar:SetPoint("TOPLEFT", Button.HealthBarBG)

        Button.BorderAlive:SetAlpha(0)
        Button.BorderDead:SetTexture([[Interface\PetBattles\DeadPetIcon]])
        Button.BorderDead:SetTexCoord(0, 1, 0, 1)
        Button.BorderDead:SetAllPoints()

        Button.HealthDivider:SetAlpha(0)

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end
    function Skin.PetBattleMiniUnitFrameEnemy(Button)
        Button._auroraIconBG = Base.CropIcon(Button.Icon, Button)

        Button.BorderAlive:SetAlpha(0)
        Button.BorderDead:SetTexture([[Interface\PetBattles\DeadPetIcon]])
        Button.BorderDead:SetTexCoord(0, 1, 0, 1)
        Button.BorderDead:SetAllPoints()

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end
    function Skin.PetBattleUnitTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)

        Frame._auroraIconBG = Base.CropIcon(Frame.Icon, Frame)
        Frame.HealthBorder:Hide()
        Frame.XPBorder:SetAlpha(0)

        Frame.Border:Hide()
        Base.SetTexture(Frame.ActualHealthBar, "gradientUp")
        Base.SetTexture(Frame.XPBar, "gradientUp")

        Frame.Delimiter:SetHeight(1)
        Frame.Delimiter2:SetHeight(1)


        --[[ Scale ]]--
        Frame:SetSize(260, 190)

        Frame.Icon:SetSize(38, 38)
        Frame.Icon:SetPoint("TOPLEFT", 15, -15)
        Frame.Name:SetSize(160, 33)
        Frame.Name:SetPoint("TOPLEFT", Frame.Icon, "TOPRIGHT", 7, -5)
        Frame.SpeciesName:SetPoint("TOPLEFT", Frame.Icon, "TOPRIGHT", 7, -21)
        Frame.CollectedText:SetPoint("TOPLEFT", Frame.Icon, "BOTTOMLEFT", 0, -4)

        Frame.HealthBorder:SetSize(232, 16)
        Frame.HealthBorder:SetPoint("TOPLEFT", Frame.Icon, "BOTTOMLEFT", -1, -6)
        Frame.XPBorder:SetSize(232, 16)
        Frame.XPBorder:SetPoint("TOPLEFT", Frame.HealthBorder, "BOTTOMLEFT", 0, -5)

        Frame.HealthBG:SetSize(230, 14)
        Frame.HealthBG:SetPoint("TOPLEFT", Frame.HealthBorder, 1, -1)
        Frame.XPBG:SetSize(230, 14)
        Frame.XPBG:SetPoint("TOPLEFT", Frame.XPBorder, 1, -1)

        Frame.ActualHealthBar:SetPoint("BOTTOMLEFT", Frame.HealthBG)
        Frame.XPBar:SetPoint("BOTTOMLEFT", Frame.XPBG)
        Frame.Delimiter:SetSize(250, 2)
        Frame.Delimiter:SetPoint("TOP", Frame.XPBG, "BOTTOM", 0, -15)
        Frame.StatsLabel:SetPoint("TOPLEFT", Frame.Delimiter, "BOTTOMLEFT", 15, -8)
        Frame.AbilitiesLabel:SetPoint("TOPLEFT", Frame.Delimiter, "BOTTOMLEFT", 90, -8)
        Frame.AttackIcon:SetSize(16, 16)
        Frame.AttackIcon:SetPoint("TOPLEFT", Frame.StatsLabel, "BOTTOMLEFT", 3, -7)
        Frame.AttackAmount:SetPoint("LEFT", Frame.AttackIcon, "RIGHT", 10, 0)
        Frame.SpeedIcon:SetSize(16, 16)
        Frame.SpeedIcon:SetPoint("TOPLEFT", Frame.AttackIcon, "BOTTOMLEFT", 0, -7)
        Frame.SpeedAmount:SetPoint("LEFT", Frame.SpeedIcon, "RIGHT", 10, 0)

        for i = 1, 3 do
            local icon = Frame["AbilityIcon"..i]
            icon:SetSize(20, 20)
            if i == 1 then
                icon:SetPoint("TOPLEFT", Frame.AbilitiesLabel, "BOTTOMLEFT", 3, -6)
            else
                icon:SetPoint("TOPLEFT", Frame["AbilityIcon"..i-1], "BOTTOMLEFT", 0, -7)
            end

            Frame["AbilityName"..i]:SetSize(120, 28)
            Frame["AbilityName"..i]:SetPoint("LEFT", icon, "RIGHT", 5, 0)
        end

        Frame.HealthText:SetPoint("CENTER", Frame.HealthBG)
        Frame.XPText:SetPoint("CENTER", Frame.XPBG)
        Frame.SpeedAdvantageIcon:SetSize(16, 16)
        Frame.SpeedAdvantageIcon:SetPoint("TOPLEFT", Frame.AbilityIcon3, "BOTTOMLEFT", -90, -10)
        Frame.SpeedAdvantage:SetWidth(226)
        Frame.SpeedAdvantage:SetPoint("LEFT", Frame.SpeedAdvantageIcon, "RIGHT", 2, 0)
        Frame.Delimiter2:SetSize(250, 2)
        Frame.Delimiter2:SetPoint("TOPLEFT", Frame.SpeedAdvantageIcon, "BOTTOMLEFT", -3, -15)

        Frame.PetType:SetSize(33, 33)
        Frame.PetType:SetPoint("TOPRIGHT", -5, -5)
        Frame.Debuffs:SetWidth(250)
        Frame.Debuffs:SetPoint("TOPLEFT", Frame.Delimiter2, "BOTTOMLEFT", 8, -10)
    end
    function Skin.PetBattleActionButtonTemplate(Button)
        Base.CropIcon(Button.Icon, Button)

        --Button.Count:SetPoint("TOPLEFT", -5, 5)

        --Button.Flash:SetColorTexture(1, 0, 0, 0.5)
        --Button.style:Hide()

        --Button.cooldown:SetPoint("TOPLEFT")
        --Button.cooldown:SetPoint("BOTTOMRIGHT")

        Button:SetNormalTexture("")
        Base.CropIcon(Button:GetHighlightTexture())
        Base.CropIcon(Button:GetPushedTexture())

        --[[ Scale ]]--
        Button:SetSize(52, 52)
        Button.CooldownShadow:SetSize(52, 52)
        Button.HotKey:SetSize(36, 10)
        Button.HotKey:SetPoint("TOPRIGHT", -1, -3)
        Button.SelectedHighlight:SetSize(93, 93)
        Button.Lock:SetSize(32, 32)
        Button.BetterIcon:SetSize(32, 32)
        Button.BetterIcon:SetPoint("BOTTOMRIGHT", 9, -9)
    end
    Skin.PetBattleAbilityButtonTemplate = Skin.PetBattleActionButtonTemplate
end

function private.AddOns.Blizzard_PetBattleUI()
    _G.hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", Hook.PetBattleUnitFrame_UpdateDisplay)
    _G.hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit", Hook.PetBattleUnitTooltip_UpdateForUnit)
    _G.hooksecurefunc("PetBattleFrame_UpdateActionButtonLevel", Hook.PetBattleFrame_UpdateActionButtonLevel)
    _G.hooksecurefunc("PetBattleFrame_UpdateActionBarLayout", Hook.PetBattleFrame_UpdateActionBarLayout)
    _G.hooksecurefunc("PetBattleAuraHolder_Update", Hook.PetBattleAuraHolder_Update)

    local PetBattleFrame = _G.PetBattleFrame
    PetBattleFrame.TopArtLeft:Hide()
    PetBattleFrame.TopArtRight:Hide()

    PetBattleFrame.TopVersus:SetSize(155, 85)
    PetBattleFrame.TopVersus:SetTexture([[Interface\LevelUp\LevelUpTex]])
    PetBattleFrame.TopVersus:SetTexCoord(0.00195313, 0.6386719, 0.23828125, 0.03710938)

    local WeatherFrame = PetBattleFrame.WeatherFrame
    WeatherFrame:ClearAllPoints()
    WeatherFrame:SetPoint("TOP", 0, -60)

    local weatherMask = WeatherFrame:CreateMaskTexture(nil, "BORDER")
    weatherMask:SetTexture([[Interface\PetBattles\BattleBar-AbilityBadge-Neutral]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    weatherMask:SetPoint("TOP", PetBattleFrame, 0, 256)
    weatherMask:SetSize(512, 512)
    weatherMask:Show()
    WeatherFrame.BackgroundArt:ClearAllPoints()
    WeatherFrame.BackgroundArt:SetPoint("TOP", 0, 60)
    WeatherFrame.BackgroundArt:SetSize(640, 160)
    WeatherFrame.BackgroundArt:AddMaskTexture(weatherMask)

    Base.CropIcon(WeatherFrame.Icon)
    WeatherFrame.Label:SetPoint("TOPLEFT", WeatherFrame.Icon, "TOPRIGHT", 2, -2)

    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.EnemyPadBuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.EnemyPadDebuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.AllyPadBuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.AllyPadDebuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.EnemyBuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.EnemyDebuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.AllyBuffFrame)
    Skin.PetBattleAuraHolderTemplate(PetBattleFrame.AllyDebuffFrame)

    for index, unit in next, {PetBattleFrame.ActiveAlly, PetBattleFrame.ActiveEnemy} do
        unit._auroraIconBG = Base.CropIcon(unit.Icon, unit)

        unit.Border:SetAlpha(0)
        unit.HealthBarBG:SetSize(145, 37)
        unit.HealthBarBG:SetColorTexture(0, 0, 0, 0.5)

        unit.Border2:SetAlpha(0)
        unit.BorderFlash:Hide()

        unit.LevelUnderlay:Hide()
        unit.SpeedUnderlay:SetAlpha(0)
        Base.SetTexture(unit.ActualHealthBar, "gradientUp")
        unit.ActualHealthBar:SetVertexColor(0, 1, 0)

        unit.HealthBarFrame:Hide()

        local mask = unit.PetType:CreateMaskTexture(nil, "BORDER")
        mask:SetTexture([[Interface\PetBattles\BattleBar-AbilityBadge-Neutral]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetPoint("CENTER")
        mask:SetSize(32, 32)
        mask:Show()
        unit.PetType.Background:AddMaskTexture(mask)
        unit.PetType.Icon:AddMaskTexture(mask)

        if index == 1 then
            -- ActiveAlly
            unit.HealthBarBG:SetPoint("BOTTOMLEFT", unit.Icon, "BOTTOMRIGHT", 13, 5)
        else
            -- ActiveEnemy
            unit.HealthBarBG:SetPoint("BOTTOMRIGHT", unit.Icon, "BOTTOMLEFT", -13, 5)
        end


        --[[ Scale ]]--
        unit:SetSize(270, 80)
        unit.Icon:SetSize(68, 68)
        unit.LevelUnderlay:SetSize(24, 24)
        unit.SpeedUnderlay:SetSize(24, 24)
        unit.SpeedIcon:SetSize(16, 16)
        unit.ActualHealthBar:SetHeight(37)
        unit.PetType:SetSize(36, 36)
        unit.PetType.Icon:SetSize(33, 33)
        unit.PetType.ActiveStatus:SetSize(45, 45)

        if index == 1 then
            -- ActiveAlly
            unit:SetPoint("TOPLEFT", PetBattleFrame.TopArtLeft, 115, -5)
            unit.Name:SetPoint("TOPLEFT", unit.Icon, "TOPRIGHT", 13, 0)
            unit.LevelUnderlay:SetPoint("BOTTOMLEFT", unit.Icon, -3, -3)
            unit.SpeedUnderlay:SetPoint("BOTTOMRIGHT", unit.Icon, 3, -3)
            unit.ActualHealthBar:SetPoint("LEFT", unit.HealthBarBG)
            unit.PetType:SetPoint("BOTTOMRIGHT", -2, 12)
        else
            -- ActiveEnemy
            unit:SetPoint("TOPRIGHT", PetBattleFrame.TopArtRight, -115, -5)
            unit.Name:SetPoint("TOPRIGHT", unit.Icon, "TOPLEFT", -13, 0)
            unit.LevelUnderlay:SetPoint("BOTTOMRIGHT", unit.Icon, 3, -3)
            unit.SpeedUnderlay:SetPoint("BOTTOMLEFT", unit.Icon, -3, -3)
            unit.ActualHealthBar:SetPoint("RIGHT", unit.HealthBarBG)
            unit.PetType:SetPoint("BOTTOMLEFT", 2, 12)
        end
    end

    Skin.PetBattleMiniUnitFrameAlly(PetBattleFrame.Ally2)
    Skin.PetBattleMiniUnitFrameAlly(PetBattleFrame.Ally3)

    Skin.PetBattleMiniUnitFrameEnemy(PetBattleFrame.Enemy2)
    Skin.PetBattleMiniUnitFrameEnemy(PetBattleFrame.Enemy3)

    local BottomFrame = PetBattleFrame.BottomFrame
    BottomFrame:SetSize(300, 100)
    BottomFrame.RightEndCap:Hide()
    BottomFrame.LeftEndCap:Hide()
    BottomFrame.Background:Hide()

    local xpBar = BottomFrame.xpBar
    xpBar:SetHeight(10)
    xpBar:ClearAllPoints()
    xpBar:SetPoint("BOTTOMLEFT")
    xpBar:SetPoint("BOTTOMRIGHT")
    Base.SetTexture(xpBar:GetStatusBarTexture(), "gradientUp")
    local _, xpLeft, xpRight, xpMid = xpBar:GetRegions()
    xpLeft:Hide()
    xpRight:Hide()
    xpMid:Hide()

    xpBar._auroraDivs = {}
    for i = 1, 6 do
        local texture
        texture = _G["PetBattleXPBarDiv"..i]
        texture:SetColorTexture(0, 0, 0)
        texture:SetSize(1, 10)
        xpBar._auroraDivs[i] = texture
    end

    local TurnTimer = BottomFrame.TurnTimer
    TurnTimer.TimerBG:SetColorTexture(0, 0, 0, 0.5)
    TurnTimer.TimerBG:SetPoint("TOPLEFT", TurnTimer.ArtFrame)
    TurnTimer.TimerBG:SetPoint("BOTTOMRIGHT", TurnTimer.ArtFrame)
    TurnTimer.ArtFrame:SetAlpha(0)
    TurnTimer.ArtFrame2:SetAlpha(0)
    Skin.UIPanelButtonTemplate(TurnTimer.SkipButton)

    BottomFrame.FlowFrame:SetPoint("LEFT", 15, 0)
    local flowLeft, flowRight, flowMid = BottomFrame.FlowFrame:GetRegions()
    flowLeft:Hide()
    flowRight:Hide()
    flowMid:Hide()

    Base.CropIcon(BottomFrame.SwitchPetButton:GetCheckedTexture())
    BottomFrame.Delimiter:SetSize(1, 56)
    local delim = BottomFrame.Delimiter:GetRegions()
    delim:SetColorTexture(1, 1, 1, 0.5)
    delim:SetSize(1, 56)

    BottomFrame.MicroButtonFrame:SetPoint("RIGHT", -20, 0)
    local microLeft, microRight, microMid = BottomFrame.MicroButtonFrame:GetRegions()
    microLeft:Hide()
    microRight:Hide()
    microMid:Hide()

    --[[ Scale ]]--
    WeatherFrame:SetSize(170, 40)
    WeatherFrame.Icon:SetSize(32, 32)
    PetBattleFrame.TopArtLeft:SetSize(574, 118)
    PetBattleFrame.TopArtRight:SetSize(574, 118)
    PetBattleFrame.TopVersusText:SetPoint("TOP", 0, -6)

    PetBattleFrame.EnemyPadBuffFrame:SetPoint("TOPLEFT", PetBattleFrame.TopArtRight, "BOTTOMRIGHT", -400, 20)
    PetBattleFrame.AllyPadBuffFrame:SetPoint("TOPRIGHT", PetBattleFrame.TopArtLeft, "BOTTOMLEFT", 400, 20)
    PetBattleFrame.AllyBuffFrame:SetPoint("TOPLEFT", PetBattleFrame.TopArtLeft, "BOTTOMLEFT", 70, 20)
    PetBattleFrame.EnemyBuffFrame:SetPoint("TOPRIGHT", PetBattleFrame.TopArtRight, "BOTTOMRIGHT", -70, 20)

    PetBattleFrame.Ally2:SetPoint("TOPLEFT", PetBattleFrame.TopArtLeft, 65, -2)
    PetBattleFrame.Ally3:SetPoint("TOPLEFT", PetBattleFrame.Ally2, "BOTTOMLEFT", 0, -5)

    PetBattleFrame.Enemy2:SetPoint("TOPRIGHT", PetBattleFrame.TopArtRight, -65, -2)
    PetBattleFrame.Enemy3:SetPoint("TOPRIGHT", PetBattleFrame.Enemy2, "BOTTOMRIGHT", 0, -5)

    BottomFrame.FlowFrame:SetSize(1024, 56)
    delim:SetPoint("CENTER", 0, 2)
    BottomFrame.MicroButtonFrame:SetSize(140, 56)

    if not private.disabled.tooltips then
        Skin.PetBattleUnitTooltipTemplate(_G.PetBattlePrimaryUnitTooltip)
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.PetBattlePrimaryAbilityTooltip)
    end
end
