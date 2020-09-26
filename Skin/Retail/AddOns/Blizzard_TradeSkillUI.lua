local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals pcall ipairs select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_TradeSkillUI.lua ]]
    do --[[ Blizzard_TradeSkillRecipeButton ]]
        Hook.TradeSkillRecipeButtonMixin = {}
        function Hook.TradeSkillRecipeButtonMixin:SetUp(tradeSkillInfo)
            if tradeSkillInfo.type == "header" or tradeSkillInfo.type == "subheader" then
                self._minus:Show()
                self:SetBackdrop(true)

                if tradeSkillInfo.numIndents > 0 then
                    self:SetBackdropOption("offsets", {
                        left = 24,
                        right = 263,
                        top = 0,
                        bottom = 3,
                    })
                else
                    self:SetBackdropOption("offsets", {
                        left = 4,
                        right = 283,
                        top = 0,
                        bottom = 3,
                    })
                end

                -- Blizz doesn't call SetHighlightTexture, so we have to fix it here.
                self.Highlight:SetTexture("")
            else
                self._minus:Hide()
                self._plus:Hide()
                self:SetBackdrop(false)
            end
        end
    end
    do --[[ Blizzard_TradeSkillDetails ]]
        Hook.TradeSkillDetailsMixin = {}
        function Hook.TradeSkillDetailsMixin:RefreshDisplay()
            local recipeInfo = self.selectedRecipeID and _G.C_TradeSkillUI.GetRecipeInfo(self.selectedRecipeID)
            if recipeInfo then
                local numReagents = _G.C_TradeSkillUI.GetRecipeNumReagents(self.selectedRecipeID)
                for reagentIndex = 1, numReagents do
                    local link = _G.C_TradeSkillUI.GetRecipeReagentItemLink(self.selectedRecipeID, reagentIndex)
                    Hook.SetItemButtonQuality(self.Contents.Reagents[reagentIndex], _G.C_Item.GetItemQualityByID(link), link)
                end

                if private.isPatch then
                    local optionalReagentSlots, _, _, _, playerReagentCount = _G.C_TradeSkillUI.GetOptionalReagentInfo(self.selectedRecipeID)
                    for optionalReagentIndex = 1, #optionalReagentSlots do
                        local reagentButton = self.Contents.OptionalReagents[optionalReagentIndex]
                        local reagentName = self:GetOptionalReagent(optionalReagentIndex)

                        local hasReagent = reagentName ~= nil;
                        if playerReagentCount == 0 then
                            hasReagent = false;
                        end

                        if hasReagent then
                            Base.SetBackdrop(reagentButton, Color.black, Color.frame.a)
                            Base.CropIcon(reagentButton.Icon)
                        else
                            reagentButton:SetBackdrop(nil)
                            reagentButton.Icon:SetTexCoord(0, 1, 0, 1)
                        end
                    end
                end
            end
        end
        Hook.TradeSkillGuildListingMixin = {}
        function Hook.TradeSkillGuildListingMixin:Refresh()
            local offset = _G.HybridScrollFrame_GetOffset(self.Container.ScrollFrame)

            for i, craftersButton in ipairs(self.Container.ScrollFrame.buttons) do
                if craftersButton:IsShown() then
                    local dataIndex = offset + i
                    local displayName, fullName, classFileName, online = _G.GetGuildRecipeMember(dataIndex)
                    craftersButton:SetText(displayName)
                    if online then
                        craftersButton:Enable()
                        craftersButton.fullName = fullName
                        local classColor = _G.CUSTOM_CLASS_COLORS[classFileName]
                        if classColor then
                            craftersButton.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
                        end
                    end
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_TradeSkillUI.xml ]]
    do --[[ Blizzard_TradeSkillTemplates ]]
        Skin.OptionalReagentButtonTemplate = Skin.LargeItemButtonTemplate
    end
    do --[[ Blizzard_TradeSkillRecipeButton ]]
        function Skin.TradeSkillRowButtonTemplate(Button)
            Util.Mixin(Button, Hook.TradeSkillRecipeButtonMixin)
            Skin.ExpandOrCollapse(Button)

            Skin.FrameTypeStatusBar(Button.SubSkillRankBar)
            Button.SubSkillRankBar.BorderLeft:Hide()
            Button.SubSkillRankBar.BorderRight:Hide()
            Button.SubSkillRankBar.BorderMid:Hide()
        end
    end
    do --[[ Blizzard_TradeSkillDetails ]]
        Skin.TradeSkillReagentTemplate = Skin.LargeItemButtonTemplate
        Skin.TradeSkillOptionalReagentTemplate = Skin.OptionalReagentButtonTemplate
        function Skin.TradeSkillDetailsFrameTemplate(ScrollFrame)
            Util.Mixin(ScrollFrame, Hook.TradeSkillDetailsMixin)
            ScrollFrame.Background:Hide()

            Skin.UIPanelStretchableArtScrollBarTemplate(ScrollFrame.ScrollBar)
            Skin.MagicButtonTemplate(ScrollFrame.CreateAllButton)
            ScrollFrame.CreateAllButton:SetPoint("TOPLEFT", ScrollFrame, "BOTTOMLEFT", 1, -1)
            Skin.MagicButtonTemplate(ScrollFrame.ViewGuildCraftersButton)
            ScrollFrame.ViewGuildCraftersButton:SetPoint("TOPLEFT", ScrollFrame, "BOTTOMLEFT", 0, -1)
            Skin.MagicButtonTemplate(ScrollFrame.ExitButton)
            Skin.MagicButtonTemplate(ScrollFrame.CreateButton)

            Util.PositionRelative("TOPRIGHT", ScrollFrame, "BOTTOMRIGHT", 27, -1, 5, "Left", {
                ScrollFrame.ExitButton,
                ScrollFrame.CreateButton,
            })

            Skin.NumericInputSpinnerTemplate(ScrollFrame.CreateMultipleInputBox)
            ScrollFrame.CreateMultipleInputBox:ClearAllPoints()
            ScrollFrame.CreateMultipleInputBox:SetPoint("TOPLEFT", ScrollFrame.CreateAllButton, "TOPRIGHT", 25, -1)

            local GuildFrame = ScrollFrame.GuildFrame
            GuildFrame:SetPoint("BOTTOMLEFT", ScrollFrame, "BOTTOMRIGHT", 33, 19)
            Util.Mixin(GuildFrame, Hook.TradeSkillGuildListingMixin)
            Skin.TranslucentFrameTemplate(GuildFrame)
            Skin.UIPanelCloseButton(GuildFrame.CloseButton)
            GuildFrame.Container:SetBackdrop(nil)
            Skin.HybridScrollBarTemplate(GuildFrame.Container.ScrollFrame.scrollBar)

            local Contents = ScrollFrame.Contents
            do -- ResultIcon
                local Button = Contents.ResultIcon
                Base.SetBackdrop(Button, Color.black, Color.frame.a)
                Button:SetBackdropOption("offsets", {
                    left = -1,
                    right = -1,
                    top = -1,
                    bottom = -1,
                })
                Button._auroraIconBorder = Button

                Button.ResultBorder:SetAlpha(0)
                Button.Count:SetPoint("BOTTOMRIGHT", -2, 2)

                Button:SetNormalTexture([[Interface\GuildFrame\GuildEmblemsLG_01]])
                Base.CropIcon(Button:GetNormalTexture())
            end

            for i = 1, #Contents.Reagents do
                Skin.TradeSkillReagentTemplate(Contents.Reagents[i])
            end

            if private.isPatch then
                for i = 1, #Contents.OptionalReagents do
                    Skin.TradeSkillOptionalReagentTemplate(Contents.OptionalReagents[i])
                end
            end
        end
    end
    do --[[ Blizzard_TradeSkillRecipeList ]]
        function Skin.TradeSkillRecipeListTemplate(ScrollFrame)
            Skin.TabButtonTemplate(ScrollFrame.LearnedTab)
            Skin.TabButtonTemplate(ScrollFrame.UnlearnedTab)

            local _, _, _, scrollBar = ScrollFrame:GetChildren()
            Skin.HybridScrollBarTemplate(scrollBar)

            --Skin.UIDropDownMenuTemplate(ScrollFrame.RecipeOptionsMenu)
        end
    end
    do --[[ Blizzard_TradeSkillOptionalReagentList ]]
        function Skin.OptionalReagentListLineTemplate(Frame)
            Skin.ScrollListLineTemplate(Frame)
            Skin.OptionalReagentButtonTemplate(Frame)
        end
        function Skin.OptionalReagentListTemplate(Frame)
            Skin.SimplePanelTemplate(Frame)
            Skin.UICheckButtonTemplate(Frame.HideUnownedButton)
            Skin.UIPanelButtonTemplate(Frame.CloseButton)
            Skin.ScrollListTemplate(Frame.ScrollList)
        end
    end
end

function private.AddOns.Blizzard_TradeSkillUI()
    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_TradeSkillUtils    --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --  Blizzard_TradeSkillTemplates  --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_TradeSkillRecipeButton --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --   Blizzard_TradeSkillDetails   --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --  Blizzard_TradeSkillRecipeList  --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%%%%%%%%$$$$####====----
    -- Blizzard_TradeSkillOptionalReagentList --
    ----====####$$$$%%%%%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --      Blizzard_TradeSkillUI      --
    ----====####$$$$%%%%%$$$$####====----
    local TradeSkillFrame = _G.TradeSkillFrame
    Skin.PortraitFrameTemplate(TradeSkillFrame)

    TradeSkillFrame.TabardBackground:SetPoint("TOPLEFT", 0, 0)
    TradeSkillFrame.TabardBackground:SetTexCoord(0, 1, 0, 1)
    TradeSkillFrame.TabardBackground:SetAtlas("communities-guildbanner-background", true)
    TradeSkillFrame.TabardEmblem:SetSize(56 * 1.2, 64 * 1.2)
    TradeSkillFrame.TabardEmblem:SetPoint("CENTER", TradeSkillFrame.TabardBackground, 0, 8)
    TradeSkillFrame.TabardBorder:SetPoint("TOPLEFT", 0, 0)
    TradeSkillFrame.TabardBorder:SetTexCoord(0, 1, 0, 1)
    TradeSkillFrame.TabardBorder:SetAtlas("communities-guildbanner-border", true)

    Skin.InsetFrameTemplate(TradeSkillFrame.RecipeInset)
    Skin.InsetFrameTemplate(TradeSkillFrame.DetailsInset)
    Skin.TradeSkillRecipeListTemplate(TradeSkillFrame.RecipeList)
    Skin.TradeSkillDetailsFrameTemplate(TradeSkillFrame.DetailsFrame)

    local RankFrame = TradeSkillFrame.RankFrame
    Skin.FrameTypeStatusBar(RankFrame)
    RankFrame.BorderLeft:Hide()
    RankFrame.BorderRight:Hide()
    RankFrame.BorderMid:Hide()
    RankFrame.Background:Hide()

    Skin.SearchBoxTemplate(TradeSkillFrame.SearchBox)
    Skin.UIMenuButtonStretchTemplate(TradeSkillFrame.FilterButton)
    TradeSkillFrame.FilterButton.Icon:SetSize(5, 10)
    Base.SetTexture(TradeSkillFrame.FilterButton.Icon, "arrowRight")

    do -- LinkToButton
        local LinkToButton = TradeSkillFrame.LinkToButton
        Skin.FrameTypeButton(LinkToButton)
        LinkToButton:SetBackdropOption("offsets", {
            left = 4,
            right = 5,
            top = 8,
            bottom = 5,
        })

        local bg = LinkToButton:GetBackdropTexture("bg")
        local chatIcon = LinkToButton:CreateTexture(nil, "ARTWORK", nil, 1)
        chatIcon:SetAtlas("transmog-icon-chat")
        chatIcon:SetPoint("CENTER", bg, -2, -1)
        chatIcon:SetSize(11, 11)

        local arrow = LinkToButton:CreateTexture(nil, "ARTWORK", nil, 5)
        arrow:SetPoint("TOPRIGHT", bg, -2, -4)
        arrow:SetSize(5, 10)
        Base.SetTexture(arrow, "arrowRight")
    end

    if private.isPatch then
        Skin.OptionalReagentListTemplate(TradeSkillFrame.OptionalReagentList)
    end
end
