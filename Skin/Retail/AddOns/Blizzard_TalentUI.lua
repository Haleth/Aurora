local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_TalentUI.lua ]]
    function Hook.PlayerTalentFrameSpec_OnLoad(self)
        local numSpecs = _G.GetNumSpecializations(false, self.isPet)
        local sex = self.isPet and _G.UnitSex("pet") or _G.UnitSex("player")

        for i = 1, numSpecs do
            local button = self["specButton"..i]
            local _, _, _, icon = _G.GetSpecializationInfo(i, false, self.isPet, nil, sex)
            button.specIcon:SetTexture(icon)

            local role = _G.GetSpecializationRole(i, false, self.isPet)
            Base.SetTexture(button.roleIcon, "icon"..role)

            Skin.PlayerSpecButtonTemplate(button)
        end
    end
    function Hook.PlayerTalentFrame_UpdateTabs(playerLevel)
        local prev
        for i = 1, _G.NUM_TALENT_FRAME_TABS do
            local tab = _G["PlayerTalentFrameTab"..i]
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

        local petNotActive = self.isPet and not _G.IsPetActive()
        local sex = self.isPet and _G.UnitSex("pet") or _G.UnitSex("player")

        local scrollChild = self.spellsScroll.child
        local specID, _, _, specIcon = _G.GetSpecializationInfo(shownSpec, nil, self.isPet, nil, sex)
        scrollChild.specIcon:SetTexture(specIcon)

        local role = _G.GetSpecializationRole(shownSpec, nil, self.isPet)
        if role then
            Base.SetTexture(scrollChild.roleIcon, "icon"..role)
        end

        local disable = (playerTalentSpec and shownSpec ~= playerTalentSpec) or petNotActive

        local index = 1
        local bonuses
        local bonusesIncrement = 1
        if self.isPet then
            bonuses = {_G.GetSpecializationSpells(shownSpec, nil, self.isPet, true)}
            -- GetSpecializationSpells adds a spell level after each spell ID, but we only care about the spell ID
            bonusesIncrement = 2
        else
            bonuses = _G.C_SpecializationInfo.GetSpellsDisplay(specID)
        end

        if bonuses then
            for i = 1, #bonuses, bonusesIncrement do
                local frame = scrollChild["abilityButton"..index]

                -- First ability already has anchor set
                if index > 1 then
                    if (index % 2) == 0 then
                        frame:SetPoint("LEFT", scrollChild["abilityButton"..(index - 1)], "RIGHT", 110, 0)
                    else
                        frame:SetPoint("TOP", scrollChild["abilityButton"..(index - 2)], "BOTTOM", 0, 0)
                    end
                end

                local _, spellIcon = _G.GetSpellTexture(bonuses[i])
                frame.icon:SetTexture(spellIcon)

                local isKnown = _G.IsSpellKnownOrOverridesKnown(bonuses[i])
                if ( not isKnown and _G.IsCharacterNewlyBoosted() and not disable ) then
                    frame.subText:SetTextColor(Color.grayLight:GetRGB())
                else
                    if disable then
                        frame.subText:SetTextColor(Color.gray:GetRGB())
                    else
                        frame.subText:SetTextColor(Color.grayLight:GetRGB())
                    end
                end
                index = index + 1
            end
        end
    end
end

do --[[ AddOns\Blizzard_TalentUI.xml ]]
    function Skin.PlayerSpecSpellTemplate(Button)
        Button.ring:Hide()
        Base.CropIcon(Button.icon, Button)
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
    end
    function Skin.PlayerSpecButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 2,
            right = 0,
            top = -3,
            bottom = -5,
        })

        local bg = Button:GetBackdropTexture("bg")
        Button.bg:Hide()
        Button.ring:Hide()
        Button.selectedTex:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.selectedTex:ClearAllPoints()
        Button.selectedTex:SetPoint("TOPLEFT", bg)
        Button.selectedTex:SetPoint("BOTTOMRIGHT", bg)
        Base.CropIcon(Button.specIcon)
        Button.learnedTex:SetTexture("")
    end
    function Skin.PlayerTalentTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
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
        select(8, Frame:GetChildren()):Hide() -- more border textures are regions on this frame

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
    end
    function Skin.PvpTalentButtonTemplate(Button)
        Button:GetRegions():Hide()
        Base.CropIcon(Button.Icon, Button)
        Button.Selected:SetTexCoord(0.01360544217687, 0.98639455782313, 0.05, 0.95)
        Button:GetHighlightTexture():SetTexCoord(0.01360544217687, 0.98639455782313, 0.05, 0.95)
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

    Skin.SpecializationFrameTemplate(_G.PlayerTalentFrameSpecialization)
    Skin.SpecializationFrameTemplate(_G.PlayerTalentFramePetSpecialization)

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

    Skin.UIExpandingButtonTemplate(PlayerTalentFrameTalents.PvpTalentButton)

    --------------------
    -- PvpTalentFrame --
    --------------------
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

    if not private.isPatch then
        Skin.PvpTalentTrinketSlotTemplate(PvpTalentFrame.TrinketSlot)
    end
    Skin.PvpTalentSlotTemplate(PvpTalentFrame.TalentSlot1)
    Skin.PvpTalentSlotTemplate(PvpTalentFrame.TalentSlot2)
    Skin.PvpTalentSlotTemplate(PvpTalentFrame.TalentSlot3)

    PvpTalentFrame.TalentList:SetPoint("BOTTOMLEFT", _G.PlayerTalentFrame, "BOTTOMRIGHT", 5, 26)
    Skin.SimplePanelTemplate(PvpTalentFrame.TalentList)
    Skin.BasicHybridScrollFrameTemplate(PvpTalentFrame.TalentList.ScrollFrame)
    Skin.MagicButtonTemplate(select(4, PvpTalentFrame.TalentList:GetChildren()))

    PvpTalentFrame.OrbModelScene:SetAlpha(0)

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
end
