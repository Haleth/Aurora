local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util


local function SkinSearchButton(button)
    button:SetNormalTexture("")
    button:SetPushedTexture("")

    local r, g, b = Color.highlight:GetRGB()
    local highlight = button.selectedTexture or button:GetHighlightTexture()
    highlight:SetColorTexture(r, g, b, 0.2)
end

do --[[ AddOns\Blizzard_EncounterJournal.lua ]]
    do --[[ Blizzard_EncounterJournal ]]
        local numInstanceButtons = 1
        function Hook.EncounterJournal_ListInstances()
            local InstanceButtons = _G.EncounterJournal.instanceSelect.scroll.child.InstanceButtons

            local instanceButton = InstanceButtons[numInstanceButtons]
            while instanceButton do
                Skin.EncounterInstanceButtonTemplate(instanceButton)
                numInstanceButtons = numInstanceButtons + 1
                instanceButton = InstanceButtons[numInstanceButtons]
            end
        end
        local numBossButtons = 1
        function Hook.EncounterJournal_DisplayInstance(instanceID, noButton)
            local self = _G.EncounterJournal.encounter
            self.info.instanceButton.icon:SetMask("")

            local bossButton = _G["EncounterJournalBossButton"..numBossButtons]
            while bossButton do
                Skin.EncounterBossButtonTemplate(bossButton)
                numBossButtons = numBossButtons + 1
                bossButton = _G["EncounterJournalBossButton"..numBossButtons]
            end
        end
        local numcCreatureButtons = 1
        function Hook.EncounterJournal_ShowCreatures(clearDisplayInfo)
            local creatureButton = _G.EncounterJournal.encounter.info.creatureButtons[numcCreatureButtons]
            while creatureButton do
                Skin.EncounterCreatureButtonTemplate(creatureButton)
                numcCreatureButtons = numcCreatureButtons + 1
                creatureButton = _G.EncounterJournal.encounter.info.creatureButtons[numcCreatureButtons]
            end
        end
        function Hook.EncounterJournal_UpdateButtonState(self)
            if self:GetParent().expanded then
                self.expandedIcon:SetTextColor(Color.white:GetRGB())
                self.title:SetTextColor(Color.white:GetRGB())
            else
                self.expandedIcon:SetTextColor(Color.grayLight:GetRGB())
                self.title:SetTextColor(Color.grayLight:GetRGB())
            end
        end
        function Hook.EncounterJournal_SetBullets(object, description, hideBullets)
            local parent = object:GetParent()

            if parent.Bullets then
                for _, bullet in next, parent.Bullets do
                    if not bullet._auroraSkinned then
                        Skin.EncounterOverviewBulletTemplate(bullet)
                        bullet._auroraSkinned = true
                    end
                end
            end
        end
        function Hook.EncounterJournal_SetUpOverview(self, overviewSectionID, index)
            local infoHeader = self.overviews[index]
            if not infoHeader._auroraSkinned then
                Skin.EncounterInfoTemplate(infoHeader)
                infoHeader._auroraSkinned = true
            end
            infoHeader.button._abilityIconBG:Hide()
        end
        function Hook.EncounterJournal_ToggleHeaders(self, doNotShift)
            local index = 1
            local infoHeader = _G["EncounterJournalInfoHeader"..index]
            while infoHeader do
                if not infoHeader._auroraSkinned then
                    Skin.EncounterInfoTemplate(infoHeader)
                    infoHeader._auroraSkinned = true
                end
                infoHeader.button._abilityIconBG:SetShown(infoHeader.button.abilityIcon:IsShown())

                index = index + 1
                infoHeader = _G["EncounterJournalInfoHeader"..index]
            end
        end
        function Hook.EncounterJournal_UpdateFilterString()
            local classID = _G.EJ_GetLootFilter()
            if classID > 0 then
                local classInfo = _G.C_CreatureInfo.GetClassInfo(classID)
                if classInfo then
                    local filterBG = _G.EncounterJournal.encounter.info.lootScroll.classClearFilter.bg
                    filterBG:SetVertexColor(_G.CUSTOM_CLASS_COLORS[classInfo.classFile]:GetRGB())
                end
            end
        end
        function Hook.EJSuggestFrame_UpdateRewards(suggestion)
            local rewardData = suggestion.reward.data
            if rewardData then
                suggestion.reward.icon:SetMask("")
                Base.CropIcon(suggestion.reward.icon)
            end
        end
        function Hook.EJSuggestFrame_RefreshDisplay()
            local self = _G.EncounterJournal.suggestFrame
            for i = 1, _G.AJ_MAX_NUM_SUGGESTIONS do
                local suggestion = self["Suggestion"..i]
                suggestion.icon:SetMask("")
                Base.CropIcon(suggestion.icon)

                --local data = self.suggestions[i]
                --if data then
                    --suggestion.icon:SetTexture(data.iconPath)
                --end
            end
        end
    end
    do --[[ Blizzard_LootJournal ]]
        Hook.LootJournalItemSetsMixin = {}
        function Hook.LootJournalItemSetsMixin:ConfigureItemButton(button)
            if not button._auroraSkinned then
                Skin.LootJournalItemSetItemButtonTemplate(button)
                button._auroraSkinned = true
            end

            local _, _, itemQuality = _G.GetItemInfo(button.itemID)
            itemQuality = itemQuality or private.Enum.ItemQuality.Epic

            local color = _G.BAG_ITEM_QUALITY_COLORS[itemQuality]
            button._auroraIconBorder:SetBackdropBorderColor(color.r, color.g, color.b)
        end
    end
end

do --[[ AddOns\Blizzard_EncounterJournal.xml ]]
    do --[[ Blizzard_EncounterJournal ]]
        function Skin.EJButtonTemplate(Button)
            Base.SetBackdrop(Button, Color.button)
            Base.SetHighlight(Button, "backdrop")

            Button.UpLeft:SetTexture("")
            Button.UpRight:SetTexture("")
            Button.DownLeft:SetTexture("")
            Button.DownRight:SetTexture("")
            Button.HighLeft:SetTexture("")
            Button.HighRight:SetTexture("")

            Button:SetNormalTexture("")
            Button:SetPushedTexture("")
            Button:SetHighlightTexture("")
        end
        function Skin.EncounterInstanceButtonTemplate(Button)
            Base.SetBackdrop(Button, Color.button)
            Base.SetHighlight(Button, "backdrop")

            Button.bgImage:SetAlpha(0.6)
            Button.bgImage:SetTexCoord(0.01953125, 0.66015625, 0.0390625, 0.7109375)
            Button.bgImage:SetPoint("TOPLEFT", 1, -1)
            Button.bgImage:SetPoint("BOTTOMRIGHT", -1, 1)

            Button.name:SetPoint("TOPLEFT", 4, -4)
            Button.name:SetPoint("BOTTOMRIGHT", -4, 4)

            Button:SetNormalTexture("")
            Button:SetPushedTexture("")
            Button:SetHighlightTexture("")
        end
        function Skin.EncounterSearchSMTemplate(Button)
            SkinSearchButton(Button)

            local name = Button:GetName()
            _G[name.."IconFrame"]:SetAlpha(0)
            Base.CropIcon(Button.icon, Button)
        end
        function Skin.EncounterSearchLGTemplate(Button)
            SkinSearchButton(Button)

            local name = Button:GetName()
            _G[name.."IconFrame"]:SetAlpha(0)
            Base.CropIcon(Button.icon, Button)

            Button.path:SetTextColor(Color.grayLight:GetRGB())
            Button.resultType:SetTextColor(Color.grayLight:GetRGB())
        end
        function Skin.EncounterCreatureButtonTemplate(Button)
            Button:SetNormalTexture("")
            Button:SetHighlightTexture("")
        end
        function Skin.EncounterBossButtonTemplate(Button)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 0,
                right = 0,
                top = 5,
                bottom = 5,
            })
        end
        function Skin.EncounterTabTemplate(Button)
            -- BlizzWTF: this doesn't use CheckButton like other side tabs, so we have to do custom.
            Button:SetSize(34, 34)
            Button:SetPushedTexture("")
            Button:SetDisabledTexture("")

            local normal = Button:GetNormalTexture()
            Base.CropIcon(normal, Button)
            normal:SetTexture(Button.selected:GetTexture())
            normal:SetTexCoord(Button.selected:GetTexCoord())
            normal:SetAllPoints()

            local highlight = Button:GetHighlightTexture()
            highlight:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
            Base.CropIcon(highlight)

            local selected = Button.selected
            selected:SetTexture([[Interface\Buttons\CheckButtonHilight]])
            selected:SetBlendMode("ADD")
            selected:SetAllPoints()
            Base.CropIcon(selected)

            Button.unselected:SetAllPoints()
        end
        function Skin.EncounterOverviewBulletTemplate(Frame)
            Frame.Text:SetTextColor(Color.grayLight:GetRGB())
        end
        function Skin.EncounterDescriptionTemplate(Frame)
            Frame.Text:SetTextColor(Color.grayLight:GetRGB())
        end
        function Skin.EncounterInfoTemplate(Frame)
            local button = Frame.button
            Base.SetBackdrop(button, Color.button)
            Base.SetHighlight(button, "backdrop")
            button._abilityIconBG = Base.CropIcon(button.abilityIcon, button)

            button.eLeftUp:SetTexture("")
            button.eRightUp:SetTexture("")
            button.eLeftDown:SetTexture("")
            button.eRightDown:SetTexture("")
            button.cLeftUp:SetTexture("")
            button.cRightUp:SetTexture("")
            button.cLeftDown:SetTexture("")
            button.cRightDown:SetTexture("")

            button.eMidUp:SetTexture("")
            button.eMidDown:SetTexture("")
            button.cMidUp:SetTexture("")
            button.cMidDown:SetTexture("")

            local name = button:GetName()
            _G[name.."HighlightLeft"]:SetTexture("")
            _G[name.."HighlightRight"]:SetTexture("")
            _G[name.."HighlightMid"]:SetTexture("")

            Skin.EncounterDescriptionTemplate(Frame.overviewDescription)
            Frame.description:SetTextColor(Color.grayLight:GetRGB())
            Frame.descriptionBG:SetTexture("")
            Frame.descriptionBGBottom:SetTexture("")
        end
        function Skin.AdventureJournal_SecondaryTemplate(Frame)
            Base.SetBackdrop(Frame, Color.frame, Color.frame.a)
            local bg = Frame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", 0, -12)
            bg:SetPoint("BOTTOMRIGHT", 0, 0)

            Frame.bg:Hide()
            Base.CropIcon(Frame.icon, Frame)
            Frame.iconRing:SetAlpha(0)

            Frame.centerDisplay.title.text:SetTextColor(Color.white:GetRGB())
            Frame.centerDisplay.description.text:SetTextColor(Color.grayLight:GetRGB())
            Skin.UIPanelButtonTemplate(Frame.centerDisplay.button)

            Frame.reward:SetPoint("BOTTOMRIGHT", Frame.icon, 9, -9)
            Frame.reward.icon:SetMask("")
            Base.CropIcon(Frame.reward.icon, Frame.reward)
            Frame.reward.iconRing:SetAlpha(0)
            Frame.reward.iconRingHighlight:SetAlpha(0)
        end
        function Skin.EncounterItemTemplate(Button)
            Base.CropIcon(Button.icon)
            local bg = _G.CreateFrame("Frame", nil, Button)
            bg:SetPoint("TOPLEFT", Button.icon, -1, 1)
            bg:SetPoint("BOTTOMRIGHT", Button.icon, 1, -1)
            Base.SetBackdrop(bg, Color.black, 0)
            Button._auroraIconBorder = bg

            Button.armorType:SetTextColor(Color.gray:GetRGB())
            Button.slot:SetTextColor(Color.gray:GetRGB())
            Button.boss:SetTextColor(Color.gray:GetRGB())

            Button.bossTexture:SetTexture("")
            Button.bosslessTexture:SetTexture("")
        end
        function Skin.EncounterTierTabTemplate(Button)
            Button.mid:Hide()
            Button.left:Hide()
            Button.right:Hide()

            Button.midSelect:SetAlpha(0)
            Button.leftSelect:SetAlpha(0)
            Button.rightSelect:SetAlpha(0)

            Button.midHighlight:Hide()
            Button.leftHighlight:Hide()
            Button.rightHighlight:Hide()
        end
    end
    do --[[ Blizzard_LootJournal ]]
        function Skin.LootJournalItemSetItemButtonTemplate(Button)
            Base.CropIcon(Button.Icon)
            Button.Icon:SetAllPoints()

            Base.SetBackdrop(Button, Color.black, Color.frame.a)
            local bg = Button:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", -1, 1)
            bg:SetPoint("BOTTOMRIGHT", 1, -1)
            Button._auroraIconBorder = Button

            Button.Border:Hide()
        end
        function Skin.LootJournalItemSetButtonTemplate(Button)
            Button.Background:SetDesaturated(true)
            Button.Background:SetAlpha(0.5)
            Button.Background:SetTexCoord(0, 1, 0.04878048780488, 0.92682926829268)
            Button.ItemLevel:SetTextColor(Color.grayLight:GetRGB())
        end
    end
end

function private.AddOns.Blizzard_EncounterJournal()
    ----====####$$$$%%%%%$$$$####====----
    --    Blizzard_EncounterJournal    --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("EncounterJournal_ListInstances", Hook.EncounterJournal_ListInstances)
    _G.hooksecurefunc("EncounterJournal_DisplayInstance", Hook.EncounterJournal_DisplayInstance)
    _G.hooksecurefunc("EncounterJournal_ShowCreatures", Hook.EncounterJournal_ShowCreatures)
    _G.hooksecurefunc("EncounterJournal_UpdateButtonState", Hook.EncounterJournal_UpdateButtonState)
    _G.hooksecurefunc("EncounterJournal_SetBullets", Hook.EncounterJournal_SetBullets)
    _G.hooksecurefunc("EncounterJournal_SetUpOverview", Hook.EncounterJournal_SetUpOverview)
    _G.hooksecurefunc("EncounterJournal_ToggleHeaders", Hook.EncounterJournal_ToggleHeaders)
    _G.hooksecurefunc("EncounterJournal_UpdateFilterString", Hook.EncounterJournal_UpdateFilterString)
    _G.hooksecurefunc("EJSuggestFrame_UpdateRewards", Hook.EJSuggestFrame_UpdateRewards)
    _G.hooksecurefunc("EJSuggestFrame_RefreshDisplay", Hook.EJSuggestFrame_RefreshDisplay)

    local EncounterJournal = _G.EncounterJournal
    Skin.PortraitFrameTemplate(EncounterJournal)


    ------------
    -- Search --
    ------------
    local searchBox = EncounterJournal.searchBox
    Skin.SearchBoxTemplate(searchBox)

    local searchPreview = searchBox.searchPreviewContainer
    searchPreview:DisableDrawLayer("ARTWORK")
    Base.SetBackdrop(searchPreview)
    local searchPreviewBG = searchPreview:GetBackdropTexture("bg")
    searchPreviewBG:SetPoint("BOTTOMRIGHT", searchBox.showAllResults, 0, 0)

    for i = 1, #searchBox.searchPreview do
        Skin.EncounterSearchSMTemplate(searchBox.searchPreview[i])
    end
    SkinSearchButton(searchBox.showAllResults)

    local searchResults = EncounterJournal.searchResults
    Base.SetBackdrop(searchResults)

    local titleText = searchResults.TitleText
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT")
    titleText:SetPoint("BOTTOMRIGHT", searchResults, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    _G.EncounterJournalSearchResultsBg:Hide()
    _G.EncounterJournalSearchResultsTopLeftCorner:Hide()
    _G.EncounterJournalSearchResultsTopRightCorner:Hide()
    _G.EncounterJournalSearchResultsTopBorder:Hide()
    searchResults.leftBorderBar:Hide()
    _G.EncounterJournalSearchResultsRightBorder:Hide()
    _G.EncounterJournalSearchResultsTopTileStreaks:Hide()
    _G.EncounterJournalSearchResultsTopLeftCorner2:Hide()
    _G.EncounterJournalSearchResultsTopRightCorner2:Hide()
    _G.EncounterJournalSearchResultsTopBorder2:Hide()

    searchResults.scrollFrame:ClearAllPoints()
    searchResults.scrollFrame:SetPoint("TOPLEFT", 3, -(private.FRAME_TITLE_HEIGHT + 3))
    searchResults.scrollFrame:SetPoint("BOTTOMRIGHT", -23, 3)
    Skin.UIPanelCloseButton(_G.EncounterJournalSearchResultsCloseButton)
    Skin.HybridScrollBarTrimTemplate(searchResults.scrollFrame.scrollBar)

    --------------------
    -- InstanceSelect --
    --------------------
    local navBar = EncounterJournal.navBar
    -- Skin.NavBarTemplate(navBar) -- this is skinned from hooks in NavigationBar.lua
    navBar:SetPoint("TOPLEFT", 10, -private.FRAME_TITLE_HEIGHT)
    navBar:SetPoint("RIGHT", EncounterJournal.searchBox, "LEFT", -10, 0)
    navBar.InsetBorderBottomLeft:Hide()
    navBar.InsetBorderBottomRight:Hide()
    navBar.InsetBorderBottom:Hide()
    navBar.InsetBorderLeft:Hide()
    navBar.InsetBorderRight:Hide()

    Skin.InsetFrameTemplate(EncounterJournal.inset)

    local instanceSelect = EncounterJournal.instanceSelect
    instanceSelect.bg:Hide()
    Skin.EncounterTierTabTemplate(instanceSelect.suggestTab)
    Skin.EncounterTierTabTemplate(instanceSelect.dungeonsTab)
    Skin.EncounterTierTabTemplate(instanceSelect.raidsTab)
    if not private.isPatch then
        Skin.EncounterTierTabTemplate(instanceSelect.LootJournalTab)
    end
    Skin.UIDropDownMenuTemplate(instanceSelect.tierDropDown)
    Skin.MinimalScrollBarTemplate(instanceSelect.scroll.ScrollBar)

    Skin.EncounterInstanceButtonTemplate(instanceSelect.scroll.child.instance1)


    --------------------
    -- EncounterFrame --
    --------------------
    local encounter = EncounterJournal.encounter

    local instance = encounter.instance
    instance.loreBG:SetTexCoord(0.05859375, 0.703125, 0.08203125, 0.576171875)
    instance.loreBG:SetSize(330, 253)
    instance.loreBG:SetPoint("TOP", 3, -51)
    instance.loreBG:SetAlpha(0.8)

    instance.title:SetPoint("TOP", instance.loreBG, 0, -25)

    instance.titleBG:ClearAllPoints()
    instance.titleBG:SetPoint("BOTTOM", instance.title, 0, -29)

    instance.mapButton:SetPoint("BOTTOMLEFT", 36, 125)
    instance.mapButton:GetRegions():SetTexCoord(0.013671875, 0.3359375, 0.8525390625, 0.8955078125)

    Skin.MinimalScrollBarTemplate(instance.loreScroll.ScrollBar)
    instance.loreScroll.child.lore:SetTextColor(Color.grayLight:GetRGB())

    local info = encounter.info
    info:GetRegions():Hide()

    info.leftShadow:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
    info.leftShadow:SetTexCoord(0, 0.6640625, 0, 0.3125)
    info.rightShadow:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
    info.rightShadow:SetTexCoord(0, 0.6640625, 0, 0.3125)

    info.encounterTitle:SetTextColor(Color.white:GetRGB())
    info.instanceTitle:SetTextColor(Color.white:GetRGB())

    Base.CropIcon(info.instanceButton.icon, info.instanceButton)
    info.instanceButton:SetNormalTexture("")
    info.instanceButton:SetHighlightTexture("")

    Skin.EncounterTabTemplate(info.overviewTab)
    Skin.EncounterTabTemplate(info.lootTab)
    Skin.EncounterTabTemplate(info.bossTab)
    Skin.EncounterTabTemplate(info.modelTab)
    Util.PositionRelative("TOPLEFT", info, "TOPRIGHT", 10, -40, 5, "Down", {
        info.overviewTab,
        info.lootTab,
        info.bossTab,
        info.modelTab,
    })

    Skin.MinimalScrollBarTemplate(info.bossesScroll.ScrollBar)
    Skin.EJButtonTemplate(info.difficulty)

    Base.SetBackdrop(info.reset, Color.button)
    Base.SetHighlight(info.reset, "backdrop")
    info.reset:SetNormalTexture("")
    info.reset:SetPushedTexture("")
    info.reset:SetHighlightTexture("")

    Skin.MinimalScrollBarTemplate(info.detailsScroll.ScrollBar)
    info.detailsScroll.child.description:SetTextColor(Color.grayLight:GetRGB())

    local overviewScroll = info.overviewScroll
    Skin.MinimalScrollBarTemplate(overviewScroll.ScrollBar)
    overviewScroll.child.loreDescription:SetTextColor(Color.grayLight:GetRGB())
    overviewScroll.child.header:SetDesaturated(true)
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(Color.white:GetRGB())
    Skin.EncounterDescriptionTemplate(overviewScroll.child.overviewDescription)

    local lootScroll = info.lootScroll
    local classFilterBG = lootScroll.classClearFilter:GetRegions()
    classFilterBG:SetDesaturated(true)
    lootScroll.classClearFilter.bg = classFilterBG

    Skin.EJButtonTemplate(lootScroll.filter)
    Skin.EJButtonTemplate(lootScroll.slotFilter)
    Skin.MinimalHybridScrollBarTemplate(lootScroll.scrollBar)

    local model = info.model
    model.dungeonBG:Hide()
    _G.EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
    _G.EncounterJournalEncounterFrameInfoModelFrameTitleBG:Hide()


    ------------------
    -- SuggestFrame --
    ------------------
    local suggestFrame = EncounterJournal.suggestFrame

    local Suggestion1 = suggestFrame.Suggestion1
    Suggestion1.bg:Hide()
    Base.SetBackdrop(Suggestion1, Color.frame, Color.frame.a)
    local suggestion1BG = Suggestion1:GetBackdropTexture("bg")
    suggestion1BG:SetPoint("TOPLEFT", 0, -12)
    suggestion1BG:SetPoint("BOTTOMRIGHT", 0, 0)

    Suggestion1.icon:SetMask("")
    Base.CropIcon(Suggestion1.icon, Suggestion1)
    Suggestion1.iconRing:SetAlpha(0)

    Suggestion1.centerDisplay.title.text:SetTextColor(Color.white:GetRGB())
    Suggestion1.centerDisplay.description.text:SetTextColor(Color.grayLight:GetRGB())

    Skin.UIPanelButtonTemplate(Suggestion1.button)

    Suggestion1.reward.icon:SetMask("")
    Base.CropIcon(Suggestion1.reward.icon, Suggestion1.reward)
    Suggestion1.reward.text:SetTextColor(Color.grayLight:GetRGB())
    Suggestion1.reward.iconRing:SetAlpha(0)
    Suggestion1.reward.iconRingHighlight:SetAlpha(0)

    Skin.NavButtonPrevious(Suggestion1.prevButton)
    Skin.NavButtonNext(Suggestion1.nextButton)

    Skin.AdventureJournal_SecondaryTemplate(suggestFrame.Suggestion2)
    Skin.AdventureJournal_SecondaryTemplate(suggestFrame.Suggestion3)


    -----------------------------
    -- EncounterJournalTooltip --
    -----------------------------
    if not private.disabled.tooltips then
        local tooltip = _G.EncounterJournalTooltip
        Base.SetBackdrop(tooltip)

        Base.CropIcon(tooltip.Item1.icon)
        Base.SetBackdrop(tooltip.Item1, Color.black, Color.frame.a)
        local bg = tooltip.Item1:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", tooltip.Item1.icon, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", tooltip.Item1.icon, 1, -1)
        tooltip.Item1._auroraIconBorder = tooltip.Item1

        Base.CropIcon(tooltip.Item2.icon)
        Base.SetBackdrop(tooltip.Item2, Color.black, Color.frame.a)
        bg = tooltip.Item2:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", tooltip.Item2.icon, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", tooltip.Item2.icon, 1, -1)
        tooltip.Item2._auroraIconBorder = tooltip.Item2
    end




    ----====####$$$$%%%%$$$$####====----
    --      Blizzard_LootJournal      --
    ----====####$$$$%%%%$$$$####====----
    if not private.isPatch then
        local LootJournal = EncounterJournal.LootJournal

        LootJournal:GetRegions():Hide()

        Util.Mixin(LootJournal.ItemSetsFrame, Hook.LootJournalItemSetsMixin)
        Skin.MinimalHybridScrollFrameTemplate(LootJournal.ItemSetsFrame)
        Skin.EJButtonTemplate(LootJournal.ItemSetsFrame.ClassButton)
    end
end
