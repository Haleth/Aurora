local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next ipairs floor max

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Skin

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
        _G.C_Timer.After(0, function()
            -- wait 1 frame to allow xpBar to update its size
            Util.PositionBarTicks(self.BottomFrame.xpBar, 7)
        end)
    end
    function Hook.PetBattleAuraHolder_Update(self)
        if not self.petOwner or not self.petIndex then return end

        for i, frame in ipairs(self.frames) do
            if not frame._auroraSkinned then
                Skin.PetBattleAuraTemplate(frame)
                frame._auroraSkinned = true
            end
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
    end
    Skin.PetBattleAuraHolderTemplate = private.nop
    function Skin.PetBattleUnitTooltipAuraTemplate(Frame)
        Base.CropIcon(Frame.Icon)
        Frame.DebuffBorder:SetDrawLayer("BORDER")
        Frame.DebuffBorder:SetColorTexture(1, 0, 0)
        Frame.DebuffBorder:ClearAllPoints()
        Frame.DebuffBorder:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
        Frame.DebuffBorder:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
    end
    function Skin.PetBattleMiniUnitFrameAlly(Button)
        Button._auroraIconBG = Base.CropIcon(Button.Icon, Button)

        Button.HealthBarBG:SetColorTexture(Color.button.r, Color.button.g, Color.button.b, Color.frame.a)
        Button.HealthBarBG:SetPoint("BOTTOMLEFT")
        Button.HealthBarBG:SetPoint("TOPRIGHT", Button, "BOTTOMRIGHT", 0, 7)

        Base.SetTexture(Button.ActualHealthBar, "gradientUp")
        Button.ActualHealthBar:SetPoint("TOPLEFT", Button.HealthBarBG)
        Button.ActualHealthBar:SetPoint("BOTTOMLEFT", Button.HealthBarBG)

        Button.BorderAlive:SetAlpha(0)
        Button.BorderDead:SetTexture([[Interface\PetBattles\DeadPetIcon]])
        Button.BorderDead:SetTexCoord(0, 1, 0, 1)
        Button.BorderDead:SetAllPoints()

        Button.HealthDivider:SetColorTexture(Color.button:GetRGB())
        Button.HealthDivider:SetHeight(1)
    end
    function Skin.PetBattleMiniUnitFrameEnemy(Button)
        Button._auroraIconBG = Base.CropIcon(Button.Icon, Button)

        Button.BorderAlive:SetAlpha(0)
        Button.BorderDead:SetTexture([[Interface\PetBattles\DeadPetIcon]])
        Button.BorderDead:SetTexCoord(0, 1, 0, 1)
        Button.BorderDead:SetAllPoints()
    end
    function Skin.PetBattleUnitTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)

        Frame._auroraIconBG = Base.CropIcon(Frame.Icon, Frame)
        Frame.HealthBorder:Hide()
        Frame.XPBorder:SetAlpha(0)
        Frame.Border:Hide()

        Frame.HealthBG:SetAlpha(0)
        local healthBD = _G.CreateFrame("Frame", nil, Frame)
        Base.SetBackdrop(healthBD, Color.button, Color.frame.a)
        local bg = healthBD:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", Frame.HealthBG, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", Frame.HealthBG, 1, -1)

        Frame.XPBG:SetAlpha(0)
        local xpBD = _G.CreateFrame("Frame", nil, Frame)
        Base.SetBackdrop(xpBD, Color.button, Color.frame.a)
        bg = xpBD:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", Frame.XPBG, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", Frame.XPBG, 1, -1)

        Base.SetTexture(Frame.ActualHealthBar, "gradientUp")
        Base.SetTexture(Frame.XPBar, "gradientUp")

        Frame.Delimiter:SetHeight(1)
        Frame.Delimiter2:SetHeight(1)
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
        unit.HealthBarBG:SetAlpha(0)

        unit.Border2:SetAlpha(0)
        unit.BorderFlash:Hide()

        unit.LevelUnderlay:Hide()
        unit.SpeedUnderlay:SetAlpha(0)

        local healthBD = _G.CreateFrame("Frame", nil, unit)
        Base.SetBackdrop(healthBD, Color.button, Color.frame.a)
        local bg = healthBD:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", unit.HealthBarBG, 4, -4)
        bg:SetPoint("BOTTOMRIGHT", unit.HealthBarBG, -4, 4)

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
    Skin.FrameTypeStatusBar(xpBar)
    xpBar:SetHeight(10)
    xpBar:ClearAllPoints()
    xpBar:SetPoint("BOTTOMLEFT")
    xpBar:SetPoint("BOTTOMRIGHT")
    local _, xpLeft, xpRight, xpMid = xpBar:GetRegions()
    xpLeft:Hide()
    xpRight:Hide()
    xpMid:Hide()

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

    if not private.disabled.tooltips then
        Skin.PetBattleUnitTooltipTemplate(_G.PetBattlePrimaryUnitTooltip)
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.PetBattlePrimaryAbilityTooltip)
    end
end
