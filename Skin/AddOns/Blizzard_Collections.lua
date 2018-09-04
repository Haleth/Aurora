local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util
local F, C = _G.unpack(private.Aurora)

do --[[ AddOns\Blizzard_Collections.lua ]]
    do --[[ Blizzard_MountCollection ]]
        function Hook.MountJournal_UpdateMountList()
            local scrollFrame = _G.MountJournal.ListScrollFrame
            local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
            local buttons = scrollFrame.buttons

            local showMounts = _G.C_MountJournal.GetNumMounts() > 0

            local numDisplayedMounts = _G.C_MountJournal.GetNumDisplayedMounts()
            for i=1, #buttons do
                local button = buttons[i]
                local displayIndex = i + offset
                if not (displayIndex <= numDisplayedMounts and showMounts) then
                    button.icon:SetTexture([[Interface\Icons\MountJournalPortrait]])
                end
            end
        end
    end
    do --[[ Blizzard_PetCollection ]]
        local MAX_ACTIVE_PETS = 3

        function Hook.PetJournal_UpdatePetLoadOut()
            for i = 1, MAX_ACTIVE_PETS do
                local loadoutPlate = _G.PetJournal.Loadout["Pet"..i]
                local petID = _G.C_PetJournal.GetPetLoadOutInfo(i)

                if loadoutPlate.iconBorder:IsShown() then
                    local _, _, _, _, rarity = _G.C_PetJournal.GetPetStats(petID)
                    local color = _G.ITEM_QUALITY_COLORS[rarity-1]
                    loadoutPlate._auroraIconBorder:SetColorTexture(color.r, color.g, color.b)
                else
                    loadoutPlate._auroraIconBorder:SetColorTexture(Color.black:GetRGB())
                end
            end
        end
        function Hook.PetJournal_UpdatePetList()
            local scrollFrame = _G.PetJournal.listScroll
            local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
            local petButtons = scrollFrame.buttons

            local numPets = _G.C_PetJournal.GetNumPets()
            for i = 1, #petButtons do
                local pet = petButtons[i]
                local index = i + offset
                if index <= numPets then
                    if pet.iconBorder:IsShown() then
                        local _, _, _, _, rarity = _G.C_PetJournal.GetPetStats(pet.petID)
                        local color = _G.ITEM_QUALITY_COLORS[rarity-1]
                        pet._auroraIconBorder:SetColorTexture(color.r, color.g, color.b)
                    else
                        pet._auroraIconBorder:SetColorTexture(Color.black:GetRGB())
                    end
                end
            end
        end
        function Hook.PetJournal_UpdatePetCard(self, forceSceneChange)
            if not self.petID and not self.speciesID then
                self.PetInfo._auroraIconBorder:SetColorTexture(Color.black:GetRGB())
                return
            end

            local _, petType
            if self.petID then
                _, _, _, _, _, _, _, _, _, petType = _G.C_PetJournal.GetPetInfoByPetID(self.petID)
            else
                _, _, petType = _G.C_PetJournal.GetPetInfoBySpeciesID(self.speciesID)
            end

            if self.PetInfo.qualityBorder:IsShown() then
                local _, _, _, _, rarity = _G.C_PetJournal.GetPetStats(self.petID)
                local color = _G.ITEM_QUALITY_COLORS[rarity-1]
                self.PetInfo._auroraIconBorder:SetColorTexture(color.r, color.g, color.b)
            else
                self.PetInfo._auroraIconBorder:SetColorTexture(Color.black:GetRGB())
            end

            self.TypeInfo.typeIcon:SetTexture([[Interface\Icons\Icon_PetFamily_]].._G.PET_TYPE_SUFFIX[petType])
        end
    end
    do --[[ Blizzard_Wardrobe ]]
        local lightValues = {
            enabled=true, omni=false,
            dirX=-1, dirY=1, dirZ=-1,
            ambIntensity=1.05, ambR=1, ambG=1, ambB=1,
            dirIntensity=0, dirR=1, dirG=1, dirB=1
        }
        local notCollected = {
            ambIntensity=1, ambR=0.4, ambG=0.4, ambB=0.4,
            dirIntensity=0.5, dirR=0.5, dirG=0.5, dirB=0.5
        }
        local notUsable = {
            ambIntensity=1, ambR=0.8, ambG=0.4, ambB=0.4,
            dirIntensity=0.5, dirR=1, dirG=0, dirB=0
        }
        function Hook.WardrobeItemsCollectionMixin_UpdateItems(self)
            for i = 1, self.PAGE_SIZE do
                local model = self.Models[i]
                local visualInfo = model.visualInfo
                if visualInfo then
                    local borderColor
                    if model.TransmogStateTexture:IsShown() then
                        local xmogState = model.TransmogStateTexture:GetAtlas()
                        if xmogState:find("transmogged") then
                            borderColor = _G.TRANSMOGRIFY_FONT_COLOR
                        elseif xmogState:find("current") then
                            borderColor = _G.YELLOW_FONT_COLOR
                        elseif xmogState:find("selected") then
                            borderColor = _G.TRANSMOGRIFY_FONT_COLOR
                        end
                        model.TransmogStateTexture:Hide()

                        self.PendingTransmogFrame:SetPoint("TOPLEFT", model, 2, -3)
                        self.PendingTransmogFrame:SetPoint("BOTTOMRIGHT", model, -1, 2)
                        self.PendingTransmogFrame.TransmogSelectedAnim2:Stop()
                    end

                    if not visualInfo.isCollected then
                        Base.SetBackdropColor(model._auroraBD, Color.frame, 0.3)
                        model:SetLight(lightValues.enabled, lightValues.omni,
                            lightValues.dirX, lightValues.dirY, lightValues.dirZ,
                            notCollected.ambIntensity, notCollected.ambR, notCollected.ambG, notCollected.ambB,
                            notCollected.dirIntensity, notCollected.dirR, notCollected.dirG, notCollected.dirB)
                    elseif not visualInfo.isUsable then
                        Base.SetBackdropColor(model._auroraBD, Color.red, 0.3)
                        model:SetLight(lightValues.enabled, lightValues.omni,
                            lightValues.dirX, lightValues.dirY, lightValues.dirZ,
                            notUsable.ambIntensity, notUsable.ambR, notUsable.ambG, notUsable.ambB,
                            notUsable.dirIntensity, notUsable.dirR, notUsable.dirG, notUsable.dirB)
                    else
                        Base.SetBackdropColor(model._auroraBD, Color.button, 0.3)
                        model:SetLight(lightValues.enabled, lightValues.omni,
                            lightValues.dirX, lightValues.dirY, lightValues.dirZ,
                            lightValues.ambIntensity, lightValues.ambR, lightValues.ambG, lightValues.ambB,
                            lightValues.dirIntensity, lightValues.dirR, lightValues.dirG, lightValues.dirB)
                    end

                    if borderColor then
                        model._auroraBD:SetBackdropBorderColor(borderColor)
                    end
                end
            end
        end
        function Hook.WardrobeSetsCollectionMixin_SetItemFrameQuality(self, itemFrame)
            local quality
            if itemFrame.collected then
                quality = _G.C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
            end
            Hook.SetItemButtonQuality(itemFrame, quality, itemFrame.sourceID)
        end
        function Hook.WardrobeSetsTransmogMixin_UpdateSets(self)
            for i = 1, self.PAGE_SIZE do
                local model = self.Models[i]
                if model.setID then
                    local borderColor
                    if model.TransmogStateTexture:IsShown() then
                        borderColor = _G.TRANSMOGRIFY_FONT_COLOR
                        model.TransmogStateTexture:Hide()

                        self.PendingTransmogFrame:SetPoint("TOPLEFT", model, 2, -3)
                        self.PendingTransmogFrame:SetPoint("BOTTOMRIGHT", model, -1, 2)
                        self.PendingTransmogFrame.TransmogSelectedAnim2:Stop()
                    end

                    if borderColor then
                        model._auroraBD:SetBackdropBorderColor(borderColor)
                    else
                        model._auroraBD:SetBackdropBorderColor(Color.button)
                    end
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_Collections.xml ]]
    do --[[ Blizzard_CollectionTemplates ]]
        function Skin.CollectionsProgressBarTemplate(StatusBar)
            StatusBar.border:Hide()
            Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")

            local bg = select(3, StatusBar:GetRegions())
            bg:SetPoint("TOPLEFT", -1, 1)
            bg:SetPoint("BOTTOMRIGHT", 1, -1)
        end
        function Skin.CollectionsBackgroundTemplate(Frame)
            Skin.InsetFrameTemplate(Frame)

            Frame.BackgroundTile:Hide()

            Frame.ShadowCornerTopLeft:Hide()
            Frame.ShadowCornerTopRight:Hide()
            Frame.ShadowCornerBottomLeft:Hide()
            Frame.ShadowCornerBottomRight:Hide()
            Frame.ShadowCornerTop:Hide()
            Frame.ShadowCornerLeft:Hide()
            Frame.ShadowCornerRight:Hide()
            Frame.ShadowCornerBottom:Hide()

            Frame.OverlayShadowTopLeft:Hide()
            Frame.OverlayShadowTopRight:Hide()
            Frame.OverlayShadowBottomLeft:Hide()
            Frame.OverlayShadowBottomRight:Hide()
            Frame.OverlayShadowTop:Hide()
            Frame.OverlayShadowLeft:Hide()
            Frame.OverlayShadowRight:Hide()
            Frame.OverlayShadowBottom:Hide()

            Frame.BGCornerFilagreeBottomLeft:Hide()
            Frame.BGCornerFilagreeBottomRight:Hide()
            Frame.BGCornerTopLeft:SetAlpha(0)
            Frame.BGCornerTopRight:SetAlpha(0)
            Frame.BGCornerBottomLeft:Hide()
            Frame.BGCornerBottomRight:Hide()
            Frame.ShadowLineTop:Hide()
            Frame.ShadowLineBottom:Hide()
        end
        function Skin.CollectionsPrevPageButton(Button)
            Skin.NavButtonPrevious(Button)
        end
        function Skin.CollectionsNextPageButton(Button)
            Skin.NavButtonNext(Button)
        end
        function Skin.CollectionsPagingFrameTemplate(Frame)
            Skin.CollectionsPrevPageButton(Frame.PrevPageButton)
            Skin.CollectionsNextPageButton(Frame.NextPageButton)
        end
    end
    do --[[ Blizzard_Collections ]]
        function Skin.CollectionsJournalTab(Button)
            Skin.CharacterFrameTabButtonTemplate(Button)
        end
    end
    do --[[ Blizzard_MountCollection ]]
        function Skin.MountListButtonTemplate(Button)
            Button.background:Hide()
            Base.SetBackdrop(Button, Color.frame)
            local bg = Button:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", 0, -1)
            bg:SetPoint("BOTTOMRIGHT", 0, 1)

            Base.CropIcon(Button.icon, Button)
            Button.iconBorder:Hide()

            Button.selectedTexture:SetTexCoord(0.00956937799043, 0.99043062200957, 0.04347826086957, 0.95652173913043)
            Button.selectedTexture:SetPoint("TOPLEFT", bg, 1, -1)
            Button.selectedTexture:SetPoint("BOTTOMRIGHT", bg, -1, 1)

            Base.CropIcon(Button.DragButton.ActiveTexture)
            Base.CropIcon(Button.DragButton:GetHighlightTexture())

            local highlight = Button:GetHighlightTexture()
            highlight:SetTexCoord(0.00956937799043, 0.99043062200957, 0.04347826086957, 0.95652173913043)
            highlight:SetPoint("TOPLEFT", bg, 1, -1)
            highlight:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        end
    end
    do --[[ Blizzard_PetCollection ]]
        Skin["ExpBar-Divider"] = function(Texture)
            Texture:SetColorTexture(Color.button:GetRGB())
            Texture:SetSize(1, 11)
        end
        function Skin.CompanionListButtonTemplate(Button)
            Button:GetRegions():Hide()
            Base.SetBackdrop(Button, Color.frame)
            local bg = Button:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", 0, -1)
            bg:SetPoint("BOTTOMRIGHT", 0, 1)

            Button._auroraIconBorder = Base.CropIcon(Button.icon, Button)
            Button.iconBorder:SetAlpha(0)

            Button.selectedTexture:SetTexCoord(0.00956937799043, 0.99043062200957, 0.04347826086957, 0.95652173913043)
            Button.selectedTexture:SetPoint("TOPLEFT", bg, 1, -1)
            Button.selectedTexture:SetPoint("BOTTOMRIGHT", bg, -1, 1)

            local dragButton = Button.dragButton
            Base.CropIcon(dragButton.ActiveTexture)
            dragButton.levelBG:SetColorTexture(0, 0, 0, 0.5)
            dragButton.levelBG:SetPoint("TOPLEFT", dragButton, "BOTTOMLEFT", 1, 13)
            dragButton.levelBG:SetPoint("BOTTOMRIGHT", -1, 1)
            dragButton.level:SetPoint("CENTER", dragButton.levelBG)
            Base.CropIcon(dragButton:GetHighlightTexture())

            local highlight = Button:GetHighlightTexture()
            highlight:SetTexCoord(0.00956937799043, 0.99043062200957, 0.04347826086957, 0.95652173913043)
            highlight:SetPoint("TOPLEFT", bg, 1, -1)
            highlight:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        end
        function Skin.CompanionLoadOutSpellTemplate(CheckButton)
            CheckButton:GetRegions():Hide()
            Base.CropIcon(CheckButton.icon, CheckButton)
            Base.CropIcon(CheckButton.selected)
            Base.CropIcon(CheckButton:GetPushedTexture())
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
        function Skin.CompanionLoadOutTemplate(Button)
            Button:GetRegions():Hide()

            Button._auroraIconBorder = Base.CropIcon(Button.icon, Button)
            Button.iconBorder:SetAlpha(0)
            Button.qualityBorder:SetAlpha(0)

            Button.levelBG:SetColorTexture(0, 0, 0, 0.5)
            Button.levelBG:SetPoint("TOPLEFT", Button.icon, "BOTTOMLEFT", 0, 12)
            Button.levelBG:SetPoint("BOTTOMRIGHT", Button.icon)
            Button.level:SetPoint("CENTER", Button.levelBG)

            local healthFrame = Button.healthFrame
            local left, right, mid, bg = healthFrame.healthBar:GetRegions()
            left:Hide()
            right:Hide()
            mid:Hide()
            bg:Hide()
            Base.SetTexture(healthFrame.healthBar:GetStatusBarTexture(), "gradientUp")

            Base.SetBackdrop(healthFrame.healthBar, Color.button, 0.3)
            local healthBarBG = healthFrame.healthBar:GetBackdropTexture("bg")
            healthBarBG:SetPoint("TOPLEFT", -1, 1)
            healthBarBG:SetPoint("BOTTOMRIGHT", 1, -1)

            Skin.CompanionLoadOutSpellTemplate(Button.spell1)
            Skin.CompanionLoadOutSpellTemplate(Button.spell2)
            Skin.CompanionLoadOutSpellTemplate(Button.spell3)

            local xpBar = Button.xpBar
            local regions = {xpBar:GetRegions()}
            regions[2]:Hide() -- Left
            regions[3]:Hide() -- Right
            regions[4]:Hide() -- Middle

            for i = 5, 11 do
                Skin["ExpBar-Divider"](regions[i])
            end

            regions[12]:Hide() -- BGMiddle
            Base.SetTexture(xpBar:GetStatusBarTexture(), "gradientUp")

            Base.SetBackdrop(xpBar, Color.button, 0.3)
            local xpBarBG = xpBar:GetBackdropTexture("bg")
            xpBarBG:SetPoint("TOPLEFT", -1, 1)
            xpBarBG:SetPoint("BOTTOMRIGHT", 1, -1)

            local setHighlight = Button.setButton:GetRegions()
            Base.CropIcon(setHighlight)
            setHighlight:SetAllPoints(Button.icon)

            Base.CropIcon(Button.dragButton:GetHighlightTexture())
        end
        function Skin.PetCardSpellButtonTemplate(Button)
            Base.CropIcon(Button.icon, Button)
        end
        function Skin.PetSpellSelectButtonTemplate(CheckButton)
            Base.CropIcon(CheckButton.icon, CheckButton)
            Base.CropIcon(CheckButton:GetPushedTexture())
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
    end
    do --[[ Blizzard_Wardrobe ]]
        function Skin.WardrobeItemsModelTemplate(DressUpModel)
            local bg, _, _, _, _, highlight = DressUpModel:GetRegions()
            bg:Hide()
            DressUpModel.Border:Hide()

            local bd = _G.CreateFrame("Frame", nil, DressUpModel)
            bd:SetPoint("TOPLEFT")
            bd:SetPoint("BOTTOMRIGHT", 2, -2)
            Base.SetBackdrop(bd, Color.button, 0.3)
            DressUpModel._auroraBD = bd

            highlight:SetTexCoord(.03, .97, .03, .97)
            highlight:SetPoint("TOPLEFT", 0, 0)
            highlight:SetPoint("BOTTOMRIGHT", 1, -1)
        end
        function Skin.WardrobeSetsTransmogModelTemplate(DressUpModel)
            local bg, _, _, highlight = DressUpModel:GetRegions()
            bg:Hide()
            DressUpModel.Border:Hide()

            local bd = _G.CreateFrame("Frame", nil, DressUpModel)
            bd:SetPoint("TOPLEFT")
            bd:SetPoint("BOTTOMRIGHT", 2, -2)
            Base.SetBackdrop(bd, Color.button, 0.3)
            DressUpModel._auroraBD = bd

            highlight:SetTexCoord(0.02272727272727, 0.97727272727273, 0.01595744680851, 0.98404255319149)
            highlight:SetPoint("TOPLEFT", 0, 0)
            highlight:SetPoint("BOTTOMRIGHT", 1, -1)
        end
        function Skin.WardrobeSetsScrollFrameButtonTemplate(Frame)
            Frame.Background:Hide()
            Base.SetBackdrop(Frame, Color.frame)
            local bg = Frame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", 0, -1)
            bg:SetPoint("BOTTOMRIGHT", 0, 1)

            Base.CropIcon(Frame.Icon, Frame)

            Frame.SelectedTexture:SetTexCoord(0.00956937799043, 0.99043062200957, 0.04347826086957, 0.95652173913043)
            Frame.SelectedTexture:SetPoint("TOPLEFT", bg, 1, -1)
            Frame.SelectedTexture:SetPoint("BOTTOMRIGHT", bg, -1, 1)

            Frame.HighlightTexture:SetTexCoord(0.00956937799043, 0.99043062200957, 0.04347826086957, 0.95652173913043)
            Frame.HighlightTexture:SetPoint("TOPLEFT", bg, 1, -1)
            Frame.HighlightTexture:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        end
        function Skin.WardrobeSetsDetailsItemFrameTemplate(Frame)
            Base.CropIcon(Frame.Icon)

            local bg = _G.CreateFrame("Frame", nil, Frame)
            bg:SetFrameLevel(Frame:GetFrameLevel() - 1)
            bg:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
            bg:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
            Base.SetBackdrop(bg, Color.black, 0.3)
            Frame._auroraIconBorder = bg

            --[[ Scale ]]--
            Frame:SetSize(Frame:GetSize())
        end
        function Skin.WardrobeTransmogButtonTemplate(Button)
            Base.CropIcon(Button.Icon, Button)
            Button.Border:Hide()

            local highlight = Button:GetHighlightTexture()
            Base.CropIcon(highlight)
            highlight:SetAllPoints(Button.Icon)
        end
        function Skin.WardrobeTransmogEnchantButtonTemplate(Button)
            Base.CropIcon(Button.Icon, Button)
            Button.Border:Hide()

            local highlight = Button:GetHighlightTexture()
            Base.CropIcon(highlight)
            highlight:SetAllPoints(Button.Icon)
        end
    end
end

function private.AddOns.Blizzard_Collections()
    --local r, g, b = C.r, C.g, C.b

    ----====####$$$$%%%%$$$$####====----
    --  Blizzard_CollectionTemplates  --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --      Blizzard_Collections      --
    ----====####$$$$%%%%$$$$####====----
    local CollectionsJournal = _G.CollectionsJournal
    Skin.PortraitFrameTemplate(CollectionsJournal)

    Skin.CollectionsJournalTab(_G.CollectionsJournalTab1)
    Skin.CollectionsJournalTab(_G.CollectionsJournalTab2)
    Skin.CollectionsJournalTab(_G.CollectionsJournalTab3)
    Skin.CollectionsJournalTab(_G.CollectionsJournalTab4)
    Skin.CollectionsJournalTab(_G.CollectionsJournalTab5)
    Util.PositionRelative("TOPLEFT", CollectionsJournal, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.CollectionsJournalTab1,
        _G.CollectionsJournalTab2,
        _G.CollectionsJournalTab3,
        _G.CollectionsJournalTab4,
        _G.CollectionsJournalTab5,
    })

    Skin.GlowBoxFrame(CollectionsJournal.HeirloomTabHelpBox)
    Skin.GlowBoxFrame(CollectionsJournal.WardrobeTabHelpBox)


    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_MountCollection    --
    ----====####$$$$%%%%$$$$####====----
    local MountJournal = _G.MountJournal
    _G.hooksecurefunc("MountJournal_UpdateMountList", Hook.MountJournal_UpdateMountList)

    Base.CropIcon(MountJournal.SummonRandomFavoriteButton.texture, MountJournal.SummonRandomFavoriteButton)
    Base.CropIcon(MountJournal.SummonRandomFavoriteButton:GetPushedTexture())
    Base.CropIcon(MountJournal.SummonRandomFavoriteButton:GetHighlightTexture())
    _G.MountJournalSummonRandomFavoriteButtonBorder:Hide()

    Skin.InsetFrameTemplate(MountJournal.LeftInset)
    Skin.InsetFrameTemplate(MountJournal.RightInset)
    Skin.SearchBoxTemplate(MountJournal.searchBox)
    Skin.UIMenuButtonStretchTemplate(_G.MountJournalFilterButton)
    --Skin.UIDropDownMenuTemplate(_G.MountJournalFilterDropDown)
    Skin.InsetFrameTemplate3(MountJournal.MountCount)

    local MountDisplay = MountJournal.MountDisplay
    MountDisplay.YesMountsTex:SetAlpha(0)
    MountDisplay.NoMountsTex:SetAlpha(0)
    MountDisplay.ShadowOverlay:Hide()
    Base.CropIcon(MountDisplay.InfoButton.Icon, MountDisplay.InfoButton)
    Skin.RotateOrbitCameraLeftButtonTemplate(MountDisplay.ModelScene.RotateLeftButton)
    Skin.RotateOrbitCameraRightButtonTemplate(MountDisplay.ModelScene.RotateRightButton)

    Skin.HybridScrollBarTrimTemplate(MountJournal.ListScrollFrame.scrollBar)
    Skin.MagicButtonTemplate(MountJournal.MountButton)


    ----====####$$$$%%%%$$$$####====----
    --     Blizzard_PetCollection     --
    ----====####$$$$%%%%$$$$####====----
    local PetJournal = _G.PetJournal
    _G.hooksecurefunc("PetJournal_UpdatePetLoadOut", Hook.PetJournal_UpdatePetLoadOut)
    _G.hooksecurefunc("PetJournal_UpdatePetList", Hook.PetJournal_UpdatePetList)
    _G.hooksecurefunc(PetJournal.listScroll, "update", Hook.PetJournal_UpdatePetList)
    _G.hooksecurefunc("PetJournal_UpdatePetCard", Hook.PetJournal_UpdatePetCard)

    Skin.InsetFrameTemplate3(PetJournal.PetCount)
    Skin.MainHelpPlateButton(PetJournal.MainHelpButton)
    PetJournal.MainHelpButton:SetPoint("TOPLEFT", PetJournal, "TOPLEFT", -15, 15)

    Base.CropIcon(PetJournal.HealPetButton.texture, PetJournal.HealPetButton)
    Base.CropIcon(PetJournal.HealPetButton:GetPushedTexture())
    Base.CropIcon(PetJournal.HealPetButton:GetHighlightTexture())
    _G.PetJournalHealPetButtonBorder:Hide()

    Base.CropIcon(PetJournal.SummonRandomFavoritePetButton.texture, PetJournal.SummonRandomFavoritePetButton)
    Base.CropIcon(PetJournal.SummonRandomFavoritePetButton:GetPushedTexture())
    Base.CropIcon(PetJournal.SummonRandomFavoritePetButton:GetHighlightTexture())
    _G.PetJournalSummonRandomFavoritePetButtonBorder:Hide()

    Skin.InsetFrameTemplate(PetJournal.LeftInset)
    Skin.InsetFrameTemplate(PetJournal.PetCardInset)
    Skin.InsetFrameTemplate(PetJournal.RightInset)
    Skin.SearchBoxTemplate(PetJournal.searchBox)
    Skin.UIMenuButtonStretchTemplate(_G.PetJournalFilterButton)
    Skin.HybridScrollBarTrimTemplate(PetJournal.listScroll.scrollBar)

    PetJournal.loadoutBorder:DisableDrawLayer("ARTWORK")
    _G.PetJournalLoadoutBorderSlotHeaderBG:Hide()
    _G.PetJournalLoadoutBorderSlotHeaderF:Hide()
    _G.PetJournalLoadoutBorderSlotHeaderLeft:Hide()
    _G.PetJournalLoadoutBorderSlotHeaderRight:Hide()

    Skin.CompanionLoadOutTemplate(PetJournal.Loadout.Pet1)
    Skin.CompanionLoadOutTemplate(PetJournal.Loadout.Pet2)
    Skin.CompanionLoadOutTemplate(PetJournal.Loadout.Pet3)

    local PetCard = PetJournal.PetCard
    _G.PetJournalPetCardBG:Hide()
    PetCard.AbilitiesBG1:SetAlpha(0)
    PetCard.AbilitiesBG2:SetAlpha(0)
    PetCard.AbilitiesBG3:SetAlpha(0)

    local PetInfo = PetCard.PetInfo
    PetInfo._auroraIconBorder = Base.CropIcon(PetInfo.icon, PetInfo)
    PetInfo.qualityBorder:SetAlpha(0)

    PetInfo.levelBG:SetColorTexture(0, 0, 0, 0.5)
    PetInfo.levelBG:SetPoint("TOPLEFT", PetInfo.icon, "BOTTOMLEFT", 0, 12)
    PetInfo.levelBG:SetPoint("BOTTOMRIGHT", PetInfo.icon)

    Base.CropIcon(PetCard.TypeInfo.typeIcon, PetCard.TypeInfo)

    local healthBar = PetCard.HealthFrame.healthBar
    local left, right, mid, bg = healthBar:GetRegions()
    left:Hide()
    right:Hide()
    mid:Hide()
    bg:Hide()
    Base.SetTexture(healthBar:GetStatusBarTexture(), "gradientUp")

    Base.SetBackdrop(healthBar, Color.button, 0.3)
    local healthBarBG = healthBar:GetBackdropTexture("bg")
    healthBarBG:SetPoint("TOPLEFT", -1, 1)
    healthBarBG:SetPoint("BOTTOMRIGHT", 1, -1)

    for i = 1, 6 do
        Skin.PetCardSpellButtonTemplate(PetCard["spell"..i])
    end

    local xpBar = PetCard.xpBar
    local regions = {xpBar:GetRegions()}
    regions[2]:Hide() -- Left
    regions[3]:Hide() -- Right
    regions[4]:Hide() -- Middle

    for i = 5, 11 do
        Skin["ExpBar-Divider"](regions[i])
    end

    regions[12]:Hide() -- BGMiddle
    Base.SetTexture(xpBar:GetStatusBarTexture(), "gradientUp")

    Base.SetBackdrop(xpBar, Color.button, 0.3)
    local xpBarBG = xpBar:GetBackdropTexture("bg")
    xpBarBG:SetPoint("TOPLEFT", -1, 1)
    xpBarBG:SetPoint("BOTTOMRIGHT", 1, -1)


    Skin.MagicButtonTemplate(PetJournal.FindBattleButton)
    Skin.MagicButtonTemplate(PetJournal.SummonButton)

    local spellSelect = PetJournal.SpellSelect
    spellSelect.BgEnd:Hide()
    spellSelect.BgTiled:Hide()
    Base.SetBackdrop(spellSelect)
    local spellSelectBG = spellSelect:GetBackdropTexture("bg")
    spellSelectBG:SetPoint("TOPLEFT", -3, -1)
    spellSelectBG:SetPoint("BOTTOMRIGHT", 3, 1)
    Skin.PetSpellSelectButtonTemplate(spellSelect.Spell1)
    Skin.PetSpellSelectButtonTemplate(spellSelect.Spell2)

    if not private.disabled.tooltips then
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.PetJournalPrimaryAbilityTooltip)
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.PetJournalSecondaryAbilityTooltip)
    end


    ----====####$$$$%%%%%$$$$####====----
    --         Blizzard_ToyBox         --
    ----====####$$$$%%%%%$$$$####====----
    local ToyBox = _G.ToyBox

    local toyIcons = ToyBox.iconsFrame
    toyIcons.Bg:Hide()
    toyIcons.BackgroundTile:Hide()
    toyIcons:DisableDrawLayer("BORDER")
    toyIcons:DisableDrawLayer("ARTWORK")
    toyIcons:DisableDrawLayer("OVERLAY")

    F.ReskinInput(ToyBox.searchBox)
    F.ReskinFilterButton(_G.ToyBoxFilterButton)
    F.ReskinArrow(ToyBox.PagingFrame.PrevPageButton, "Left")
    F.ReskinArrow(ToyBox.PagingFrame.NextPageButton, "Right")

    -- Progress bar

    local toyProgress = ToyBox.progressBar
    toyProgress.border:Hide()
    toyProgress:DisableDrawLayer("BACKGROUND")

    toyProgress.text:SetPoint("CENTER", 0, 1)
    toyProgress:SetStatusBarTexture(C.media.backdrop)

    F.CreateBDFrame(toyProgress, .25)

    -- Toys!

    local shouldChangeTextColor = true
    local function changeTextColor(toyString)
        if shouldChangeTextColor then
            shouldChangeTextColor = false

            local self = toyString:GetParent()

            if _G.PlayerHasToy(self.itemID) then
                local _, _, quality = _G.GetItemInfo(self.itemID)
                if quality then
                    toyString:SetTextColor(_G.GetItemQualityColor(quality))
                else
                    toyString:SetTextColor(1, 1, 1)
                end
            else
                toyString:SetTextColor(.5, .5, .5)
            end

            shouldChangeTextColor = true
        end
    end

    local iconsFrame = ToyBox.iconsFrame
    for i = 1, 18 do
        local button = iconsFrame["spellButton"..i]
        button:SetPushedTexture("")
        button:SetHighlightTexture("")

        button.bg = F.CreateBG(button)
        button.bg:SetPoint("TOPLEFT", button, 3, -2)
        button.bg:SetPoint("BOTTOMRIGHT", button, -3, 4)

        button.iconTexture:SetTexCoord(.08, .92, .08, .92)

        button.iconTextureUncollected:SetTexCoord(.08, .92, .08, .92)
        button.iconTextureUncollected:SetPoint("CENTER", 0, 1)
        button.iconTextureUncollected:SetHeight(42)

        button.slotFrameCollected:SetTexture("")
        button.slotFrameUncollected:SetTexture("")

        --button.cooldown:SetAllPoints(icon)

        _G.hooksecurefunc(button.name, "SetTextColor", changeTextColor)
    end


    ----====####$$$$%%%%%$$$$####====----
    --   Blizzard_HeirloomCollection   --
    ----====####$$$$%%%%%$$$$####====----
    local HeirloomsJournal = _G.HeirloomsJournal

    local heirloomIcons = HeirloomsJournal.iconsFrame
    heirloomIcons.Bg:Hide()
    heirloomIcons.BackgroundTile:Hide()
    heirloomIcons:DisableDrawLayer("BORDER")
    heirloomIcons:DisableDrawLayer("ARTWORK")
    heirloomIcons:DisableDrawLayer("OVERLAY")

    F.ReskinInput(_G.HeirloomsJournalSearchBox)
    F.ReskinDropDown(_G.HeirloomsJournalClassDropDown)
    F.ReskinFilterButton(_G.HeirloomsJournalFilterButton)
    F.ReskinArrow(HeirloomsJournal.PagingFrame.PrevPageButton, "Left")
    F.ReskinArrow(HeirloomsJournal.PagingFrame.NextPageButton, "Right")

    -- Progress bar

    local heirloomProgress = HeirloomsJournal.progressBar
    heirloomProgress.border:Hide()
    heirloomProgress:DisableDrawLayer("BACKGROUND")

    heirloomProgress.text:SetPoint("CENTER", 0, 1)
    heirloomProgress:SetStatusBarTexture(C.media.backdrop)

    F.CreateBDFrame(heirloomProgress, .25)

    -- Buttons

    local heirloomColor = _G.BAG_ITEM_QUALITY_COLORS[_G.LE_ITEM_QUALITY_HEIRLOOM]
    _G.hooksecurefunc(HeirloomsJournal, "UpdateButton", function(self, button)
        if not button.styled then
            button:SetPushedTexture("")
            button:SetHighlightTexture("")

            button.bg = F.CreateBG(button)
            button.bg:SetPoint("TOPLEFT", button, 3, -2)
            button.bg:SetPoint("BOTTOMRIGHT", button, -3, 4)

            button.iconTexture:SetTexCoord(.08, .92, .08, .92)

            button.iconTextureUncollected:SetTexCoord(.08, .92, .08, .92)
            button.iconTextureUncollected:SetPoint("CENTER", 0, 1)
            button.iconTextureUncollected:SetHeight(42)

            button.slotFrameCollected:SetTexture("")
            button.slotFrameUncollected:SetTexture("")

            button.levelBackground:SetAlpha(0)

            button.level:ClearAllPoints()
            button.level:SetPoint("BOTTOM", 0, 1)

            local auroraLevelBG = button:CreateTexture(nil, "OVERLAY")
            auroraLevelBG:SetColorTexture(0, 0, 0, .5)
            auroraLevelBG:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 4, 5)
            auroraLevelBG:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 5)
            auroraLevelBG:SetHeight(11)
            button.auroraLevelBG = auroraLevelBG

            button.styled = true
        end

        if button.iconTexture:IsShown() then
            button.name:SetTextColor(1, 1, 1)
            button.bg:SetVertexColor(heirloomColor.r, heirloomColor.g, heirloomColor.b)
            button.auroraLevelBG:Show()
            if button.levelBackground:GetAtlas() == "collections-levelplate-gold" then
                button.auroraLevelBG:SetColorTexture(1, 1, 1, .5)
            else
                button.auroraLevelBG:SetColorTexture(0, 0, 0, .5)
            end
        else
            button.name:SetTextColor(.5, .5, .5)
            button.bg:SetVertexColor(0, 0, 0)
            button.auroraLevelBG:Hide()
        end
    end)

    _G.hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function(self)
        for i = 1, #self.heirloomHeaderFrames do
            local header = self.heirloomHeaderFrames[i]
            if not header.styled then
                header.text:SetTextColor(1, 1, 1)
                header.text:SetFont(C.media.font, 16)

                header.styled = true
            end
        end
    end)


    ----====####$$$$%%%%%$$$$####====----
    --        Blizzard_Wardrobe        --
    ----====####$$$$%%%%%$$$$####====----

    -----------------------------
    -- WardrobeCollectionFrame --
    -----------------------------
    local WardrobeCollectionFrame = _G.WardrobeCollectionFrame
    Skin.TabButtonTemplate(WardrobeCollectionFrame.ItemsTab)
    Skin.TabButtonTemplate(WardrobeCollectionFrame.SetsTab)

    local SetsTabHelpBox = WardrobeCollectionFrame.SetsTabHelpBox
    local Arrow = _G.CreateFrame("Frame", nil, SetsTabHelpBox)
    Arrow.Arrow = SetsTabHelpBox.ArrowUp
    Arrow.Arrow:SetParent(Arrow)
    Arrow.Glow = SetsTabHelpBox.ArrowGlowUp
    Arrow.Glow:SetParent(Arrow)
    SetsTabHelpBox.Arrow = Arrow
    SetsTabHelpBox.Text = SetsTabHelpBox.BigText
    Skin.GlowBoxFrame(SetsTabHelpBox, "Up")

    Skin.SearchBoxTemplate(WardrobeCollectionFrame.searchBox)
    Skin.CollectionsProgressBarTemplate(WardrobeCollectionFrame.progressBar)
    Skin.UIMenuButtonStretchTemplate(WardrobeCollectionFrame.FilterButton)

    -- Items
    local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
    _G.hooksecurefunc(ItemsCollectionFrame, "UpdateItems", Hook.WardrobeItemsCollectionMixin_UpdateItems)

    Skin.CollectionsBackgroundTemplate(ItemsCollectionFrame)
    Skin.CollectionsPagingFrameTemplate(ItemsCollectionFrame.PagingFrame)
    Skin.UIDropDownMenuTemplate(ItemsCollectionFrame.WeaponDropDown)

    local Models = ItemsCollectionFrame.Models
    for i = 1, #Models do
        Skin.WardrobeItemsModelTemplate(Models[i])
    end

    Skin.GlowBoxFrame(ItemsCollectionFrame.HelpBox, "Up")


    -- Sets
    local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
    _G.hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", Hook.WardrobeSetsCollectionMixin_SetItemFrameQuality)
    Skin.InsetFrameTemplate(SetsCollectionFrame.LeftInset)
    Skin.CollectionsBackgroundTemplate(SetsCollectionFrame.RightInset)
    Skin.HybridScrollBarTrimTemplate(SetsCollectionFrame.ScrollFrame.scrollBar)

    local DetailsFrame = SetsCollectionFrame.DetailsFrame
    _G.hooksecurefunc(DetailsFrame.itemFramesPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
    DetailsFrame.ModelFadeTexture:Hide()
    Skin.UIMenuButtonStretchTemplate(DetailsFrame.VariantSetsButton)

    local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
    _G.hooksecurefunc(SetsTransmogFrame, "UpdateSets", Hook.WardrobeSetsTransmogMixin_UpdateSets)
    Skin.CollectionsBackgroundTemplate(SetsTransmogFrame)
    Skin.CollectionsPagingFrameTemplate(SetsTransmogFrame.PagingFrame)
    for i = 1, #SetsTransmogFrame.Models do
        Skin.WardrobeSetsTransmogModelTemplate(SetsTransmogFrame.Models[i])
    end

    -------------------
    -- WardrobeFrame --
    -------------------
    local WardrobeFrame = _G.WardrobeFrame
    Skin.PortraitFrameTemplate(WardrobeFrame)

    local WardrobeTransmogFrame = _G.WardrobeTransmogFrame
    WardrobeTransmogFrame.MoneyLeft:Hide()
    WardrobeTransmogFrame.MoneyMiddle:Hide()
    WardrobeTransmogFrame.MoneyRight:Hide()

    Skin.InsetFrameTemplate(WardrobeTransmogFrame.Inset)
    WardrobeTransmogFrame.Inset.BG:Hide()
    Skin.WardrobeOutfitDropDownTemplate(WardrobeTransmogFrame.OutfitDropDown)
    Skin.GlowBoxFrame(WardrobeTransmogFrame.OutfitHelpBox, "Left")

    Skin.UIMenuButtonStretchTemplate(WardrobeTransmogFrame.Model.ClearAllPendingButton)
    for i = 1, #WardrobeTransmogFrame.Model.SlotButtons do
        if i > 13 then
            Skin.WardrobeTransmogEnchantButtonTemplate(WardrobeTransmogFrame.Model.SlotButtons[i])
        else
            Skin.WardrobeTransmogButtonTemplate(WardrobeTransmogFrame.Model.SlotButtons[i])
        end
    end

    Skin.SmallMoneyFrameTemplate(WardrobeTransmogFrame.MoneyFrame)
    Skin.UIPanelButtonTemplate(WardrobeTransmogFrame.ApplyButton)
    Skin.UIMenuButtonStretchTemplate(WardrobeTransmogFrame.SpecButton)
    Skin.GlowBoxFrame(WardrobeTransmogFrame.SpecHelpBox, "Up")
end
