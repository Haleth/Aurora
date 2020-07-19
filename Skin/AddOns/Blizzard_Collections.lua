local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

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
    do --[[ Blizzard_HeirloomCollection ]]
        local NO_CLASS_FILTER = 0
        local NO_SPEC_FILTER = 0

        Hook.HeirloomsMixin = {}
        function Hook.HeirloomsMixin:UpdateClassFilterDropDownText()
            local text
            local classFilter, specFilter = _G.C_Heirloom.GetClassAndSpecFilters()
            if classFilter == NO_CLASS_FILTER then
                text = _G.ALL_CLASSES
            else
                local classInfo = _G.C_CreatureInfo.GetClassInfo(classFilter)
                if not classInfo then
                    return
                end

                local classColorStr = _G.CUSTOM_CLASS_COLORS[classInfo.classFile].colorStr
                if specFilter == NO_SPEC_FILTER then
                    text = _G.HEIRLOOMS_CLASS_FILTER_FORMAT:format(classColorStr, classInfo.className)
                else
                    local specName = _G.GetSpecializationNameForSpecID(specFilter)
                    text = _G.HEIRLOOMS_CLASS_SPEC_FILTER_FORMAT:format(classColorStr, classInfo.className, specName)
                end
            end
            _G.UIDropDownMenu_SetText(self.classDropDown, text)
        end
        function Hook.HeirloomsMixin:UpdateButton(button)
            if not button._auroraSkinned then
                Skin.HeirloomSpellButtonTemplate(button)
                button._auroraSkinned = true
            end

            local _, _, _, _, upgradeLevel = _G.C_Heirloom.GetHeirloomInfo(button.itemID)
            if upgradeLevel == _G.C_Heirloom.GetHeirloomMaxUpgradeLevel(button.itemID) then
                button.levelBackground:SetColorTexture(1, 1, 1, .5)
            else
                button.levelBackground:SetColorTexture(0, 0, 0, .5)
            end
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
        Hook.WardrobeItemsCollectionMixin = {}
        function Hook.WardrobeItemsCollectionMixin:UpdateItems()
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

        Hook.WardrobeSetsCollectionMixin = {}
        function Hook.WardrobeSetsCollectionMixin:SetItemFrameQuality(itemFrame)
            local quality
            if itemFrame.collected then
                quality = _G.C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
            end
            Hook.SetItemButtonQuality(itemFrame, quality, itemFrame.sourceID)
        end

        Hook.WardrobeSetsTransmogMixin = {}
        function Hook.WardrobeSetsTransmogMixin:UpdateSets()
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
            Skin.FrameTypeStatusBar(StatusBar)

            StatusBar.border:Hide()
            select(3, StatusBar:GetRegions()):Hide()
        end
        function Skin.CollectionsSpellButtonTemplate(CheckButton)
            Base.CropIcon(CheckButton.iconTexture, CheckButton)
            CheckButton.iconTexture:ClearAllPoints()
            CheckButton.iconTexture:SetPoint("TOPLEFT", 4, -4)
            CheckButton.iconTexture:SetPoint("BOTTOMRIGHT", -4, 4)

            Base.CropIcon(CheckButton.iconTextureUncollected)
            CheckButton.iconTextureUncollected:SetAllPoints(CheckButton.iconTexture)
            CheckButton.slotFrameUncollectedInnerGlow:SetTexture("")

            CheckButton.slotFrameCollected:SetTexture("")
            CheckButton.slotFrameUncollected:SetTexture("")

            CheckButton.cooldown:SetAllPoints(CheckButton.iconTexture)
            CheckButton.cooldownWrapper.slotFavorite:SetPoint("TOPLEFT", -10, 8)

            CheckButton:GetPushedTexture():SetAllPoints(CheckButton.iconTexture)
            Base.CropIcon(CheckButton:GetPushedTexture())

            CheckButton:GetHighlightTexture():SetAllPoints(CheckButton.iconTexture)
            Base.CropIcon(CheckButton:GetHighlightTexture())

            CheckButton:GetCheckedTexture():SetAllPoints(CheckButton.iconTexture)
            Base.CropIcon(CheckButton:GetCheckedTexture())
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
        function Skin.MountEquipmentButtonTemplate(Button)
            Base.SetBackdrop(Button, Color.frame)
            local bg = Button:GetRegions()
            bg:SetTexCoord(0.20289855072464, 0.79710144927536, 0.20289855072464, 0.79710144927536)
            bg:SetAllPoints()

            Base.CropIcon(Button:GetPushedTexture())
            Base.CropIcon(Button:GetHighlightTexture())
        end
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
            Button.background:Hide()
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
            Skin.FrameTypeStatusBar(healthFrame.healthBar)
            local left, right, mid, bg = healthFrame.healthBar:GetRegions()
            left:Hide()
            right:Hide()
            mid:Hide()
            bg:Hide()

            Skin.CompanionLoadOutSpellTemplate(Button.spell1)
            Skin.CompanionLoadOutSpellTemplate(Button.spell2)
            Skin.CompanionLoadOutSpellTemplate(Button.spell3)

            local xpBar = Button.xpBar
            Skin.FrameTypeStatusBar(xpBar)
            local regions = {xpBar:GetRegions()}
            regions[2]:Hide() -- Left
            regions[3]:Hide() -- Right
            regions[4]:Hide() -- Middle

            for i = 5, 11 do
                Skin["ExpBar-Divider"](regions[i])
            end

            regions[12]:Hide() -- BGMiddle

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
    do --[[ Blizzard_ToyBox ]]
        function Skin.ToySpellButtonTemplate(CheckButton)
            Skin.CollectionsSpellButtonTemplate(CheckButton)
        end
    end
    do --[[ Blizzard_HeirloomCollection ]]
        function Skin.HeirloomSpellButtonTemplate(CheckButton)
            Skin.CollectionsSpellButtonTemplate(CheckButton)

            CheckButton.levelBackground:ClearAllPoints()
            CheckButton.levelBackground:SetPoint("TOPLEFT", CheckButton.iconTexture, "BOTTOMLEFT", 0, 12)
            CheckButton.levelBackground:SetPoint("BOTTOMRIGHT", CheckButton.iconTexture)
            CheckButton.levelBackground:SetColorTexture(0, 0, 0, 0.5)
            CheckButton.level:ClearAllPoints()
            CheckButton.level:SetPoint("CENTER", CheckButton.levelBackground)
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

    local BottomLeftInset = MountJournal.BottomLeftInset
    Skin.InsetFrameTemplate(BottomLeftInset)
    Skin.MountEquipmentButtonTemplate(BottomLeftInset.SlotButton)
    BottomLeftInset.SlotButton:SetPoint("LEFT", 23, 5)
    BottomLeftInset.Background:Hide()
    BottomLeftInset.BackgroundOverlay:Hide()
    select(4, BottomLeftInset:GetRegions()):Hide()

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
    Skin.UICheckButtonTemplate(MountDisplay.ModelScene.TogglePlayer)

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
    Skin.FrameTypeStatusBar(healthBar)
    local left, right, mid, bg = healthBar:GetRegions()
    left:Hide()
    right:Hide()
    mid:Hide()
    bg:Hide()

    for i = 1, 6 do
        Skin.PetCardSpellButtonTemplate(PetCard["spell"..i])
    end

    local xpBar = PetCard.xpBar
    Skin.FrameTypeStatusBar(xpBar)
    local regions = {xpBar:GetRegions()}
    regions[2]:Hide() -- Left
    regions[3]:Hide() -- Right
    regions[4]:Hide() -- Middle

    for i = 5, 11 do
        Skin["ExpBar-Divider"](regions[i])
    end

    regions[12]:Hide() -- BGMiddle


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

    Skin.CollectionsProgressBarTemplate(ToyBox.progressBar)
    Skin.SearchBoxTemplate(ToyBox.searchBox)
    Skin.UIMenuButtonStretchTemplate(_G.ToyBoxFilterButton)

    if not private.isPatch then
        Skin.GlowBoxFrame(ToyBox.favoriteHelpBox, "Up")
        Skin.GlowBoxTemplate(ToyBox.mousewheelPagingHelpBox)
        Skin.UIPanelCloseButton(ToyBox.mousewheelPagingHelpBox.CloseButton)
    end

    local iconsFrame = ToyBox.iconsFrame
    Skin.CollectionsBackgroundTemplate(iconsFrame)
    iconsFrame.watermark:SetDesaturated(true)
    iconsFrame.watermark:SetAlpha(0.5)

    for i = 1, 18 do
        Skin.ToySpellButtonTemplate(iconsFrame["spellButton"..i])
    end

    Skin.CollectionsPagingFrameTemplate(ToyBox.PagingFrame)


    ----====####$$$$%%%%%$$$$####====----
    --   Blizzard_HeirloomCollection   --
    ----====####$$$$%%%%%$$$$####====----
    local HeirloomsJournal = _G.HeirloomsJournal
    Util.Mixin(HeirloomsJournal, Hook.HeirloomsMixin)

    Skin.CollectionsProgressBarTemplate(HeirloomsJournal.progressBar)
    Skin.SearchBoxTemplate(HeirloomsJournal.SearchBox)
    Skin.UIMenuButtonStretchTemplate(_G.HeirloomsJournalFilterButton)
    Skin.UIDropDownMenuTemplate(HeirloomsJournal.classDropDown)

    Skin.CollectionsBackgroundTemplate(HeirloomsJournal.iconsFrame)
    HeirloomsJournal.iconsFrame.watermark:SetDesaturated(true)
    HeirloomsJournal.iconsFrame.watermark:SetAlpha(0.5)

    Skin.CollectionsPagingFrameTemplate(HeirloomsJournal.PagingFrame)


    ----====####$$$$%%%%%$$$$####====----
    --        Blizzard_Wardrobe        --
    ----====####$$$$%%%%%$$$$####====----

    -----------------------------
    -- WardrobeCollectionFrame --
    -----------------------------
    local WardrobeCollectionFrame = _G.WardrobeCollectionFrame
    Skin.TabButtonTemplate(WardrobeCollectionFrame.ItemsTab)
    Skin.TabButtonTemplate(WardrobeCollectionFrame.SetsTab)

    if not private.isPatch then
        Skin.GlowBoxFrame(WardrobeCollectionFrame.SetsTabHelpBox, "Up")
    end
    Skin.SearchBoxTemplate(WardrobeCollectionFrame.searchBox)
    Skin.CollectionsProgressBarTemplate(WardrobeCollectionFrame.progressBar)
    Skin.UIMenuButtonStretchTemplate(WardrobeCollectionFrame.FilterButton)

    -- Items
    local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
    Util.Mixin(ItemsCollectionFrame, Hook.WardrobeItemsCollectionMixin)

    Skin.CollectionsBackgroundTemplate(ItemsCollectionFrame)
    Skin.CollectionsPagingFrameTemplate(ItemsCollectionFrame.PagingFrame)
    Skin.UIDropDownMenuTemplate(ItemsCollectionFrame.WeaponDropDown)

    local Models = ItemsCollectionFrame.Models
    for i = 1, #Models do
        Skin.WardrobeItemsModelTemplate(Models[i])
    end

    if not private.isPatch then
        Skin.GlowBoxFrame(ItemsCollectionFrame.HelpBox, "Up")
    end


    -- Sets
    local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
    Util.Mixin(SetsCollectionFrame, Hook.WardrobeSetsCollectionMixin)
    Skin.InsetFrameTemplate(SetsCollectionFrame.LeftInset)
    Skin.CollectionsBackgroundTemplate(SetsCollectionFrame.RightInset)
    Skin.HybridScrollBarTrimTemplate(SetsCollectionFrame.ScrollFrame.scrollBar)

    local DetailsFrame = SetsCollectionFrame.DetailsFrame
    DetailsFrame.ModelFadeTexture:Hide()
    Skin.UIMenuButtonStretchTemplate(DetailsFrame.VariantSetsButton)

    local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
    Util.Mixin(SetsTransmogFrame, Hook.WardrobeSetsTransmogMixin)
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
    if not private.isPatch then
        Skin.GlowBoxFrame(WardrobeTransmogFrame.OutfitHelpBox, "Left")
    end

    local ModelScene = WardrobeTransmogFrame.ModelScene
    Skin.UIMenuButtonStretchTemplate(ModelScene.ClearAllPendingButton)
    for i = 1, #ModelScene.SlotButtons do
        if i > 13 then
            Skin.WardrobeTransmogEnchantButtonTemplate(ModelScene.SlotButtons[i])
        else
            Skin.WardrobeTransmogButtonTemplate(ModelScene.SlotButtons[i])
        end
    end

    Skin.SmallMoneyFrameTemplate(WardrobeTransmogFrame.MoneyFrame)
    Skin.UIPanelButtonTemplate(WardrobeTransmogFrame.ApplyButton)
    Skin.UIMenuButtonStretchTemplate(WardrobeTransmogFrame.SpecButton)
    if not private.isPatch then
        Skin.GlowBoxFrame(WardrobeTransmogFrame.SpecHelpBox, "Up")
    end
end
