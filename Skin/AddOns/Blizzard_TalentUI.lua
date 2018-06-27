local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_TalentUI.lua ]]
    local talentTabWidthCache = {}
    function Hook.PlayerTalentFrameSpec_OnLoad(self)
        local numSpecs = _G.GetNumSpecializations(false, self.isPet)
        local sex = self.isPet and _G.UnitSex("pet") or _G.UnitSex("player")

        for i = 1, numSpecs do
            local button = self["specButton"..i]
            local _, _, _, icon = _G.GetSpecializationInfo(i, false, self.isPet, nil, sex)
            button.specIcon:SetTexture(icon)

            local role = _G.GetSpecializationRole(i, false, self.isPet)
            Base.SetTexture(button.roleIcon, "role"..role)

            Skin.PlayerSpecButtonTemplate(button)
        end
    end
    function Hook.PlayerTalentFrame_UpdateTabs(playerLevel)
        local totalTabWidth = 0
        local selectedTab = _G.PanelTemplates_GetSelectedTab(_G.PlayerTalentFrame) or _G.SPECIALIZATION_TAB
        local tab
        playerLevel = playerLevel or _G.UnitLevel("player")

        -- setup specialization tab
        talentTabWidthCache[_G.SPECIALIZATION_TAB] = 0
        tab = _G["PlayerTalentFrameTab".._G.SPECIALIZATION_TAB]
        if tab then
            tab:Show()
            Hook.PanelTemplates_TabResize(tab, 0)
            talentTabWidthCache[_G.SPECIALIZATION_TAB] = Hook.PanelTemplates_GetTabWidth(tab)
            totalTabWidth = totalTabWidth + talentTabWidthCache[_G.SPECIALIZATION_TAB]
        end

        -- setup talents talents tab
        local meetsTalentLevel = playerLevel >= _G.SHOW_TALENT_LEVEL
        talentTabWidthCache[_G.TALENTS_TAB] = 0
        tab = _G["PlayerTalentFrameTab".._G.TALENTS_TAB]
        if tab then
            if meetsTalentLevel then
                tab:Show()
                Hook.PanelTemplates_TabResize(tab, 0)
                talentTabWidthCache[_G.TALENTS_TAB] = Hook.PanelTemplates_GetTabWidth(tab)
                totalTabWidth = totalTabWidth + talentTabWidthCache[_G.TALENTS_TAB]
            else
                tab:Hide()
            end
        end

        if not private.isPatch then
            talentTabWidthCache[_G.PVP_TALENTS_TAB] = 0
            tab = _G["PlayerTalentFrameTab".._G.PVP_TALENTS_TAB]
            if tab then
                if playerLevel >= _G.SHOW_PVP_TALENT_LEVEL then
                    tab:Show()
                    Hook.PanelTemplates_TabResize(tab, 0)
                    talentTabWidthCache[_G.PVP_TALENTS_TAB] = Hook.PanelTemplates_GetTabWidth(tab)
                    totalTabWidth = totalTabWidth + talentTabWidthCache[_G.PVP_TALENTS_TAB]
                else
                    tab:Hide()
                end
            end
        end

        if _G.PET_SPECIALIZATION_TAB then
            -- setup pet specialization tab
            talentTabWidthCache[_G.PET_SPECIALIZATION_TAB] = 0
            tab = _G["PlayerTalentFrameTab".._G.PET_SPECIALIZATION_TAB]
            if tab then
                tab:Show()
                Hook.PanelTemplates_TabResize(tab, 0)
                talentTabWidthCache[_G.PET_SPECIALIZATION_TAB] = Hook.PanelTemplates_GetTabWidth(tab)
                totalTabWidth = totalTabWidth + talentTabWidthCache[_G.PET_SPECIALIZATION_TAB]
            end
        end

        -- select the first shown tab if the selected tab does not exist for the selected spec
        tab = _G["PlayerTalentFrameTab"..selectedTab]
        if tab and not tab:IsShown() then
            return false
        end

        -- readjust tab sizes to fit
        local maxTotalTabWidth = _G.PlayerTalentFrame:GetWidth()
        while totalTabWidth >= maxTotalTabWidth do
            -- progressively shave 10 pixels off of the largest tab until they all fit within the max width
            local largestTab = 1
            for i = 2, #talentTabWidthCache do
                if talentTabWidthCache[largestTab] < talentTabWidthCache[i] then
                    largestTab = i
                end
            end
            -- shave the width
            talentTabWidthCache[largestTab] = talentTabWidthCache[largestTab] - Scale.Value(10)
            -- apply the shaved width
            tab = _G["PlayerTalentFrameTab"..largestTab]
            Hook.PanelTemplates_TabResize(tab, 0, talentTabWidthCache[largestTab])
            -- now update the total width
            totalTabWidth = totalTabWidth - Scale.Value(10)
        end

        -- Reposition the visible tabs
        local prev
        for i = 1, _G.NUM_TALENT_FRAME_TABS do
            tab = _G["PlayerTalentFrameTab"..i]
            if tab:IsShown() then
                tab:ClearAllPoints()
                if not prev then
                    tab:SetPoint("TOPLEFT", _G.PlayerTalentFrame, "BOTTOMLEFT", 20, -1)
                else
                    tab:SetPoint("TOPLEFT", prev, "TOPRIGHT", 1, 0)
                end
                prev = tab
            end
        end
    end
    function Hook.PlayerTalentFrame_CreateSpecSpellButton(self, index)
        Skin.PlayerSpecSpellTemplate(self.spellsScroll.child["abilityButton"..index])
    end
    function Hook.PlayerTalentFrame_UpdateSpecFrame(self, spec)
        local playerTalentSpec = _G.GetSpecialization(nil, self.isPet)
        local shownSpec = spec or playerTalentSpec or 1
        local sex = self.isPet and _G.UnitSex("pet") or _G.UnitSex("player")

        local scrollChild = self.spellsScroll.child
        local specID, _, _, specIcon = _G.GetSpecializationInfo(shownSpec, nil, self.isPet, nil, sex)
        scrollChild.specIcon:SetTexture(specIcon)

        local role = _G.GetSpecializationRole(shownSpec, nil, self.isPet)
        if role then
            Base.SetTexture(scrollChild.roleIcon, "role"..role)
        end

        local index = 1
        local bonuses
        local bonusesIncrement = 1
        if self.isPet then
            bonuses = {_G.GetSpecializationSpells(shownSpec, nil, self.isPet, true)}
            -- GetSpecializationSpells adds a spell level after each spell ID, but we only care about the spell ID
            bonusesIncrement = 2
        else
            if private.isPatch then
                bonuses = _G.C_SpecializationInfo.GetSpellsDisplay(specID)
            else
                bonuses = _G.SPEC_SPELLS_DISPLAY[specID]
                bonusesIncrement = 2
            end
        end

        if bonuses then
            for i = 1, #bonuses, bonusesIncrement do
                local frame = scrollChild["abilityButton"..index]

                -- First ability already has anchor set
                if index > 1 then
                    if (index % 2) == 0 then
                        frame:SetPoint("LEFT", scrollChild["abilityButton"..(index - 1)], "RIGHT", 110, 0);
                    else
                        frame:SetPoint("TOP", scrollChild["abilityButton"..(index - 2)], "BOTTOM", 0, 0);
                    end
                end

                local _, spellIcon = _G.GetSpellTexture(bonuses[i])
                frame.icon:SetTexture(spellIcon)
                index = index + 1
            end
        end
    end
end

do --[[ AddOns\Blizzard_TalentUI.xml ]]
    function Skin.PlayerSpecSpellTemplate(Button)
        Button.ring:Hide()
        Base.CropIcon(Button.icon, Button)

        --[[ Scale ]]--
        Button:SetSize(70, 70)
        Button.icon:SetSize(56, 56)
        Button.name:SetSize(115, 0)
        Button.name:SetPoint("LEFT", Button.icon, "RIGHT", 7, 0)
    end
    function Skin.TalentRowGlowFrameTemplate(Frame)
        Frame.TopGlowLine:SetHeight(14)
        Frame.BottomGlowLine:SetHeight(14)
    end
    function Skin.PlayerTalentButtonTemplate(Button)
        Base.CropIcon(Button.icon, Button)
        Button.Slot:Hide()
        Button.Cover:SetColorTexture(Color.white:GetRGB())
        Button.knownSelection:SetAllPoints()
        Button.knownSelection:SetDrawLayer("BACKGROUND", -2)
        Button.highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, 0.25)
        Button.highlight:SetAllPoints(Button.knownSelection)
        Skin.TalentRowGlowFrameTemplate(Button.GlowFrame)

        --[[ Scale ]]--
        Button:SetSize(190, 42)
        Button.icon:SetSize(36, 36)
    end
    function Skin.PlayerTalentRowTemplate(Frame)
        local name = Frame:GetName()
        _G[name.."Bg"]:Hide()
        _G[name.."LeftCap"]:Hide()
        _G[name.."RightCap"]:Hide()

        _G[name.."Separator1"]:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, 0.2)
        _G[name.."Separator1"]:SetSize(1, 30)
        _G[name.."Separator2"]:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, 0.2)
        _G[name.."Separator2"]:SetSize(1, 30)
        _G[name.."Separator3"]:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, 0.2)
        _G[name.."Separator3"]:SetSize(1, 30)

        Skin.PlayerTalentButtonTemplate(Frame.talent1)
        Skin.PlayerTalentButtonTemplate(Frame.talent2)
        Skin.PlayerTalentButtonTemplate(Frame.talent3)
        Skin.TalentRowGlowFrameTemplate(Frame.GlowFrame)

        --[[ Scale ]]--
        Frame:SetSize(629, 42)
        _G[name.."Separator1"]:SetPoint("CENTER", Frame, "LEFT", 57, 0)
        _G[name.."Separator2"]:SetPoint("LEFT", _G[name.."Separator1"], 190, 0)
        _G[name.."Separator3"]:SetPoint("LEFT", _G[name.."Separator2"], 190, 0)
        Frame.level:SetPoint("CENTER", Frame, "LEFT", 30, 0)
        Frame.TopLine:SetSize(629, 14)
        Frame.TopLine:SetPoint("TOP", 0, 14)
        Frame.BottomLine:SetSize(629, 14)
        Frame.BottomLine:SetPoint("BOTTOM", 0, -14)
    end
    function Skin.PlayerSpecButtonTemplate(Button)
        local bd = _G.CreateFrame("Frame", nil, Button)
        Base.SetBackdrop(bd, Color.button)
        bd:SetBackdropBorderColor(Color.frame, 1)
        bd:SetFrameLevel(Button:GetFrameLevel())
        bd:SetPoint("TOPLEFT", Button.specIcon, "TOPRIGHT", 0, 1)
        bd:SetPoint("BOTTOM", Button.specIcon, 0, -1)
        bd:SetPoint("RIGHT")

        Button.bg:Hide()
        Button.ring:Hide()
        Button.selectedTex:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.selectedTex:ClearAllPoints()
        Button.selectedTex:SetPoint("TOPLEFT", bd)
        Button.selectedTex:SetPoint("BOTTOMRIGHT", bd)
        Base.CropIcon(Button.specIcon, Button)
        Button.learnedTex:SetTexture("")

        local highlight = Button:GetHighlightTexture()
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT", bd)
        highlight:SetPoint("BOTTOMRIGHT", bd)

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
        Button.specIcon:SetSize(Button.specIcon:GetSize())
        Button.specIcon:SetPoint("LEFT", 2, -1)
        Button.specName:SetPoint("TOPLEFT", Button.specIcon, "TOPRIGHT", 13, -13)
        Button.roleIcon:SetSize(Button.roleIcon:GetSize())
        Button.roleIcon:SetPoint("TOPLEFT", Button.specName, "BOTTOMLEFT", -2, -5)
    end
    function Skin.PlayerTalentTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.SpecializationFrameTemplate(Frame)
        local leftBG, rightBG, tlCorner, topBorder, topFiligree, bottomFilligree = Frame:GetRegions()
        leftBG:Hide()
        rightBG:Hide()
        tlCorner:Hide()
        topBorder:Hide()
        topFiligree:Hide()
        bottomFilligree:Hide()

        Skin.MainHelpPlateButton(Frame.MainHelpButton)
        Frame.MainHelpButton:SetPoint("TOPLEFT", _G.PlayerTalentFrame, "TOPLEFT", -15, 15)
        Skin.MagicButtonTemplate(Frame.learnButton)
        Frame.learnButton.Flash:SetAtlas("GarrMission_FollowerListButton-Select")
        Frame.learnButton.Flash:SetAllPoints()
        Frame.learnButton.Flash:SetTexCoord(0, 0.99568965517241, 0.01785714285714, 0.96428571428571)
        select(7, Frame:GetChildren()):Hide() -- more border textures are regions on this frame

        local scrollChild = Frame.spellsScroll.child
        scrollChild.gradient:Hide()
        scrollChild.scrollwork_topleft:Hide()
        scrollChild.scrollwork_topright:Hide()
        scrollChild.scrollwork_bottomleft:Hide()
        scrollChild.scrollwork_bottomright:Hide()
        scrollChild.ring:Hide()
        Base.CropIcon(scrollChild.specIcon, scrollChild)

        scrollChild.Seperator:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, 0.5)
        Skin.PlayerSpecSpellTemplate(scrollChild.abilityButton1)

        Hook.PlayerTalentFrameSpec_OnLoad(Frame)

        --[[ Scale ]]--
        Frame.specButton2:SetPoint("TOP", Frame.specButton1, "BOTTOM", 0, -30)
        Frame.specButton3:SetPoint("TOP", Frame.specButton2, "BOTTOM", 0, -30)
        Frame.specButton4:SetPoint("TOP", Frame.specButton3, "BOTTOM", 0, -30)

        Frame.spellsScroll:SetPoint("TOPLEFT", 217, 0)
        Frame.spellsScroll:SetPoint("BOTTOMRIGHT", 0, 0)
        Scale.RawSetSize(scrollChild, Frame.spellsScroll:GetSize())
        scrollChild.specName:SetPoint("BOTTOMLEFT", scrollChild.specIcon, "RIGHT", 22, 2)
        scrollChild.roleIcon:SetSize(scrollChild.roleIcon:GetSize())
        scrollChild.roleIcon:SetPoint("TOPLEFT", scrollChild.specName, "BOTTOMLEFT", 0, -10)
        scrollChild.roleName:SetPoint("BOTTOMLEFT", scrollChild.roleIcon, "RIGHT", 3, 2)
        scrollChild.primaryStat:SetPoint("TOPLEFT", scrollChild.roleIcon, "RIGHT", 3, -3)
        scrollChild.description:SetSize(370, 0)
        scrollChild.description:SetPoint("TOPLEFT", scrollChild.specIcon, "BOTTOMLEFT", 5, -25)
        scrollChild.specIcon:SetSize(scrollChild.specIcon:GetSize())
        scrollChild.specIcon:SetPoint("TOPLEFT", 18, -18)
        scrollChild.Seperator:SetSize(360, 1)
        scrollChild.Seperator:SetPoint("TOP", 0, -165)
        scrollChild.abilityButton1:SetPoint("TOPLEFT", 25, -185)
    end
    function Skin.PvpTalentButtonTemplate(Button)
        Button:GetRegions():Hide()
        Base.CropIcon(Button.Icon, Button)
        Button.Selected:SetTexCoord(0.01360544217687, 0.98639455782313, 0.05, 0.95)
        Button:GetHighlightTexture():SetTexCoord(0.01360544217687, 0.98639455782313, 0.05, 0.95)

        --[[ Scale ]]--
        Button:SetSize(147, 40)
        Button.Icon:SetSize(36, 36)
        Button.Icon:SetPoint("LEFT", 2, 0)
        Button.Name:SetSize(100, 0)
        Button.Name:SetPoint("LEFT", Button.Icon, "RIGHT", 4, 0)
        Button.SelectedOtherCheck:SetSize(28, 26)
    end
end

function private.AddOns.Blizzard_TalentUI()
    -----------------------
    -- PlayerTalentFrame --
    -----------------------
    _G.hooksecurefunc("PlayerTalentFrame_UpdateTabs", Hook.PlayerTalentFrame_UpdateTabs)
    _G.hooksecurefunc("PlayerTalentFrame_CreateSpecSpellButton", Hook.PlayerTalentFrame_CreateSpecSpellButton)
    _G.hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", Hook.PlayerTalentFrame_UpdateSpecFrame)

    Skin.ButtonFrameTemplate(_G.PlayerTalentFrame)
    Skin.PlayerTalentTabTemplate(_G.PlayerTalentFrameTab1)
    Skin.PlayerTalentTabTemplate(_G.PlayerTalentFrameTab2)
    Skin.PlayerTalentTabTemplate(_G.PlayerTalentFrameTab3)
    if not private.isPatch then
        Skin.PlayerTalentTabTemplate(_G.PlayerTalentFrameTab4)
    end

    Skin.SpecializationFrameTemplate(_G.PlayerTalentFrameSpecialization)
    Skin.SpecializationFrameTemplate(_G.PlayerTalentFramePetSpecialization)

    --[[ Scale ]]--

    ------------------------------
    -- PlayerTalentFrameTalents --
    ------------------------------
    local PlayerTalentFrameTalents = _G.PlayerTalentFrameTalents
    PlayerTalentFrameTalents:SetPoint("TOPLEFT", 5, -(private.FRAME_TITLE_HEIGHT + 25))
    PlayerTalentFrameTalents:SetPoint("BOTTOMRIGHT", -5, 5)
    PlayerTalentFrameTalents.bg:Hide()
    _G.PlayerTalentFrameTalentsTLCorner:Hide()
    _G.PlayerTalentFrameTalentsTRCorner:Hide()
    _G.PlayerTalentFrameTalentsBLCorner:Hide()
    _G.PlayerTalentFrameTalentsBRCorner:Hide()
    local topTile, bottomTile = select(6, PlayerTalentFrameTalents:GetRegions())
    topTile:Hide()
    bottomTile:Hide()

    Skin.MainHelpPlateButton(PlayerTalentFrameTalents.MainHelpButton)
    PlayerTalentFrameTalents.MainHelpButton:SetPoint("TOPLEFT", _G.PlayerTalentFrame, "TOPLEFT", -15, 15)

    for tier = 1, _G.MAX_TALENT_TIERS do
        local talentRow = PlayerTalentFrameTalents["tier"..tier]
        Skin.PlayerTalentRowTemplate(talentRow)
        if tier == 1 then
            talentRow:SetPoint("TOPLEFT")
        else
            talentRow:SetPoint("TOPLEFT", PlayerTalentFrameTalents["tier"..tier - 1], "BOTTOMLEFT", 0, -18)
        end
    end

    if private.isPatch then
        Skin.UIExpandingButtonTemplate(PlayerTalentFrameTalents.PvpTalentButton)
        PlayerTalentFrameTalents.PvpTalentButton:ClearAllPoints()
        PlayerTalentFrameTalents.PvpTalentButton:SetPoint("TOPRIGHT", _G.PlayerTalentFrame.CloseButton, "BOTTOMRIGHT", 0, -5)
    end

    --[[ Scale ]]--
    PlayerTalentFrameTalents.unspentText:SetPoint("BOTTOM", PlayerTalentFrameTalents.tier1, "TOP", 0, 10)

    --------------------
    -- PvpTalentFrame --
    --------------------
    if private.isPatch then
        local PvpTalentFrame = PlayerTalentFrameTalents.PvpTalentFrame
        local bg, vertbar = PvpTalentFrame:GetRegions()
        bg:Hide()
        vertbar:Hide()
        _G.PlayerTalentFrameTalentsPvpTalentFrameTLCorner:Hide()
        _G.PlayerTalentFrameTalentsPvpTalentFrameTRCorner:Hide()
        _G.PlayerTalentFrameTalentsPvpTalentFrameBLCorner:Hide()
        _G.PlayerTalentFrameTalentsPvpTalentFrameBRCorner:Hide()
        topTile, bottomTile = select(7, PvpTalentFrame:GetRegions())
        topTile:Hide()
        bottomTile:Hide()

        PvpTalentFrame.Swords:SetSize(72, 67)
        PvpTalentFrame.Orb:Hide()
        PvpTalentFrame.Ring:Hide()
        select(13, PvpTalentFrame:GetRegions()):Hide() -- firecover

        Skin.GlowBoxFrame(PvpTalentFrame.WarmodeTutorialBox, "Left")
        Skin.PvpTalentTrinketSlotTemplate(PvpTalentFrame.TrinketSlot)
        Skin.GlowBoxFrame(PvpTalentFrame.TrinketSlot.HelpBox, "Left")

        Skin.PvpTalentSlotTemplate(PvpTalentFrame.TalentSlot1)
        Skin.PvpTalentSlotTemplate(PvpTalentFrame.TalentSlot2)
        Skin.PvpTalentSlotTemplate(PvpTalentFrame.TalentSlot3)

        PvpTalentFrame.TalentList:SetPoint("BOTTOMLEFT", _G.PlayerTalentFrame, "BOTTOMRIGHT", 5, 26)
        Skin.ButtonFrameTemplate(PvpTalentFrame.TalentList)
        PvpTalentFrame.TalentList.MyTopLeftCorner:Hide()
        PvpTalentFrame.TalentList.MyTopRightCorner:Hide()
        PvpTalentFrame.TalentList.MyTopBorder:Hide()

        PvpTalentFrame.TalentList.ScrollFrame:SetPoint("TOPLEFT", 5, -5)
        PvpTalentFrame.TalentList.ScrollFrame:SetPoint("BOTTOMRIGHT", -21, 32)
        Skin.HybridScrollBarTemplate(PvpTalentFrame.TalentList.ScrollFrame.ScrollBar)
        Skin.MagicButtonTemplate(select(4, PvpTalentFrame.TalentList:GetChildren()))

        PvpTalentFrame.OrbModelScene:SetAlpha(0)

        --[[ Scale ]]--
        PvpTalentFrame:SetSize(131, 379)
        PvpTalentFrame:SetPoint("LEFT", PlayerTalentFrameTalents, "RIGHT", -135, 0)
        PvpTalentFrame.Swords:SetPoint("BOTTOM", 0, 30)
        PvpTalentFrame.Label:SetPoint("BOTTOM", 0, 104)
        PvpTalentFrame.InvisibleWarmodeButton:SetAllPoints(PvpTalentFrame.Swords)

        PvpTalentFrame.TrinketSlot:SetPoint("TOP", 0, -16)
        PvpTalentFrame.TalentSlot1:SetPoint("TOP", PvpTalentFrame.TrinketSlot, "BOTTOM", 0, -16)
        PvpTalentFrame.TalentSlot2:SetPoint("TOP", PvpTalentFrame.TalentSlot1, "BOTTOM", 0, -10)
        PvpTalentFrame.TalentSlot3:SetPoint("TOP", PvpTalentFrame.TalentSlot2, "BOTTOM", 0, -10)
        PvpTalentFrame.FireModelScene:SetScale(Scale.GetUIScale())
    else
        local PlayerTalentFramePVPTalents = _G.PlayerTalentFramePVPTalents
        PlayerTalentFramePVPTalents:SetPoint("TOPLEFT", 5, -(private.FRAME_TITLE_HEIGHT + 25))
        PlayerTalentFramePVPTalents:SetPoint("BOTTOMRIGHT", -5, 5)
        Skin.PVPHonorSystemLargeXPBar(PlayerTalentFramePVPTalents.XPBar)

        local Talents = PlayerTalentFramePVPTalents.Talents
        Talents:SetPoint("TOPLEFT", 0, -50)
        _G.PlayerTalentFramePVPTalentsBg:Hide()
        _G.PlayerTalentFramePVPTalentsTLCorner:Hide()
        _G.PlayerTalentFramePVPTalentsTRCorner:Hide()
        _G.PlayerTalentFramePVPTalentsBLCorner:Hide()
        _G.PlayerTalentFramePVPTalentsBRCorner:Hide()
        topTile, bottomTile = select(6, Talents:GetRegions())
        topTile:Hide()
        bottomTile:Hide()

        for tier = 1, _G.MAX_PVP_TALENT_TIERS do
            local talentRow = Talents["Tier"..tier]
            --Skin.PlayerTalentRowTemplate(talentRow)
            if tier == 1 then
                talentRow:SetPoint("TOPLEFT")
            else
                talentRow:SetPoint("TOPLEFT", Talents["Tier"..tier - 1], "BOTTOMLEFT", 0, -18)
            end
        end
    end

    -------------------------------
    -- PlayerTalentFrameLockInfo --
    -------------------------------
    _G.PlayerTalentFrameLockInfoBottomLeftInner:Hide()
    _G.PlayerTalentFrameLockInfoBottomRightInner:Hide()
    _G.PlayerTalentFrameLockInfoTopRightInner:Hide()
    _G.PlayerTalentFrameLockInfoTopLeftInner:Hide()
    _G.PlayerTalentFrameLockInfoLeftInner:Hide()
    _G.PlayerTalentFrameLockInfoRightInner:Hide()
    _G.PlayerTalentFrameLockInfoTopInner:Hide()
    _G.PlayerTalentFrameLockInfoBottomInner:Hide()
    _G.PlayerTalentFrameLockInfo.Portrait:Hide()
    _G.PlayerTalentFrameLockInfo.PortraitFrame:Hide()

    _G.PlayerTalentFrameLockInfoBlackBG:SetPoint("TOPLEFT")
    _G.PlayerTalentFrameLockInfoBlackBG:SetPoint("BOTTOMRIGHT")

    --[[ Scale ]]--
end
