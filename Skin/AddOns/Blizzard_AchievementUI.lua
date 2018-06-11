local _, private = ...

-- luacheck: globals select next
-- luacheck: globals hooksecurefunc

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

local function SkinSearchPreview(button)
    button:GetNormalTexture():SetColorTexture(0.1, 0.1, 0.1, .9)
    button:GetPushedTexture():SetColorTexture(0.1, 0.1, 0.1, .9)

    local r, g, b = Color.highlight:GetRGB()
    button.selectedTexture:SetColorTexture(r, g, b, 0.2)
end

do --[[ AddOns\Blizzard_AchievementUI.lua ]]
    local IN_GUILD_VIEW = false
    local COLOR_ALPHA = 0.8

    function Hook.AchievementFrame_UpdateTabs(clickedTab)
        for i = 1, 3 do
            _G["AchievementFrameTab"..i]:SetPoint("CENTER")
        end
    end
    function Hook.AchievementFrameBaseTab_OnClick()
        if _G.AchievementFrameGuildEmblemLeft:IsShown() then
            _G.AchievementFrameGuildEmblemLeft:SetVertexColor(1, 1, 1, 0.25)
            _G.AchievementFrameGuildEmblemRight:SetVertexColor(1, 1, 1, 0.25)
            IN_GUILD_VIEW = true
        else
            IN_GUILD_VIEW = false
        end
    end
    function Hook.AchievementButton_UpdatePlusMinusTexture(button)
        if button:IsForbidden() then return end -- twitter achievement share is protected
        if button.plusMinus:IsShown() then
            button._auroraPlusMinus:Show()
            if button.collapsed then
                button._auroraPlusMinus.plus:Show()
            else
                button._auroraPlusMinus.plus:Hide()
            end
        elseif button._auroraPlusMinus then
            button._auroraPlusMinus:Hide()
        end
    end
    function Hook.AchievementButton_Saturate(self)
        if IN_GUILD_VIEW then
            Base.SetBackdropColor(self, Color.red, COLOR_ALPHA)
        else
            if self.accountWide then
                Base.SetBackdropColor(self, Color.blue, COLOR_ALPHA)
            else
                Base.SetBackdropColor(self, Color.red, COLOR_ALPHA)
            end
        end

        if self.description then
            self.description:SetTextColor(.9, .9, .9)
            self.description:SetShadowOffset(1, -1)
        end
    end
    function Hook.AchievementButton_Desaturate(self)
        if IN_GUILD_VIEW then
            Base.SetBackdropColor(self, Color.red:Saturation(-0.3), COLOR_ALPHA)
        else
            if self.accountWide then
                Base.SetBackdropColor(self, Color.blue:Saturation(-0.3), COLOR_ALPHA)
            else
                Base.SetBackdropColor(self, Color.red:Saturation(-0.3), COLOR_ALPHA)
            end
        end
    end

    local numMini = 0
    function Hook.AchievementButton_GetMiniAchievement(index)
        if index > numMini then
            Skin.MiniAchievementTemplate(_G["AchievementFrameMiniAchievement" .. index])
            numMini = numMini + 1
        end
    end
    local numProgress = 0
    function Hook.AchievementButton_GetProgressBar(index, renderOffScreen)
        if index > numProgress then
            local offscreenName = ""
            if renderOffScreen then
                offscreenName = "OffScreen"
            end

            Skin.AchievementProgressBarTemplate(_G["AchievementFrameProgressBar" .. offscreenName .. index])
            numProgress = numProgress + 1
        end
    end
    local numMeta = 0
    function Hook.AchievementButton_GetMeta(index, renderOffScreen)
        if index > numMeta then
            local offscreenName = ""
            if renderOffScreen then
                offscreenName = "OffScreen"
            end

            Skin.MetaCriteriaTemplate(_G["AchievementFrameMeta" .. offscreenName .. index])
            numMeta = numMeta + 1
        end
    end

    function Hook.AchievementFrameStats_SetStat(button, category, index, colorIndex, isSummary)
        if not button.id then return end
        if not colorIndex then
            colorIndex = index
        end

        if (colorIndex % 2) == 1 then
            button.background:Hide()
        else
            button.background:SetColorTexture(1, 1, 1, 0.25)
        end
    end
    function Hook.AchievementFrameStats_SetHeader(button, id)
        button.background:Show()
        button.background:SetAlpha(1.0)
        button.background:SetBlendMode("DISABLE")
        button.background:SetColorTexture(Color.button:GetRGB())
    end

    local numAchievements = 0
    function Hook.AchievementFrameSummary_UpdateAchievements(...)
        for i = numAchievements + 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
            local button = _G["AchievementFrameSummaryAchievement"..i]
            if button then
                if i > 1 then
                    local anchorTo = _G["AchievementFrameSummaryAchievement"..i-1];
                    button:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", 0, -1 );
                    button:SetPoint("TOPRIGHT", anchorTo, "BOTTOMRIGHT", 0, -1 );
                end
                numAchievements = numAchievements + 1
            end
        end
    end

    Hook.AchievementFrameComparisonStats_SetStat = Hook.AchievementFrameStats_SetStat
    Hook.AchievementFrameComparisonStats_SetHeader = Hook.AchievementFrameStats_SetHeader
end

do --[[ AddOns\Blizzard_AchievementUI.xml ]]
    function Skin.AchievementSearchPreviewButton(Button)
        SkinSearchPreview(Button)

        Button.iconFrame:SetAlpha(0)
        Base.CropIcon(Button.icon, Button)
    end
    function Skin.AchievementFullSearchResultsButton(Button)
        Button.iconFrame:SetAlpha(0)
        Base.CropIcon(Button.icon, Button)

        local r, g, b = Color.highlight:GetRGB()
        Button:GetHighlightTexture():SetColorTexture(r, g, b, 0.2)
    end
    function Skin.AchievementFrameSummaryCategoryTemplate(StatusBar)
        local name = StatusBar:GetName()
        StatusBar.label:SetPoint("LEFT", 6, 0)
        StatusBar.text:SetPoint("RIGHT", -6, 0)

        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()

        local r, g, b = Color.highlight:GetRGB()
        _G[name.."ButtonHighlightLeft"]:Hide()
        _G[name.."ButtonHighlightRight"]:Hide()

        local highlight = _G[name.."ButtonHighlightMiddle"]
        highlight:SetAllPoints()
        highlight:SetColorTexture(r, g, b, 0.2)

        Base.SetTexture(_G[name.."Bar"], "gradientUp")
    end
    function Skin.AchievementCheckButtonTemplate(CheckButton)
        CheckButton:SetSize(11, 11)

        CheckButton:SetNormalTexture("")
        CheckButton:SetPushedTexture("")
        CheckButton:SetHighlightTexture("")

        _G[CheckButton:GetName().."Text"]:SetPoint("LEFT", CheckButton, "RIGHT", 2, 0)

        local check = CheckButton:GetCheckedTexture()
        check:SetSize(21, 21)
        check:ClearAllPoints()
        check:SetPoint("CENTER")
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        Base.SetBackdrop(CheckButton, Color.button, 0.3)
        Base.SetHighlight(CheckButton, "backdrop")
    end
    function Skin.AchievementFrameTabButtonTemplate(Button)
        local name = Button:GetName()
        Button:SetHeight(28)

        _G[name.."LeftDisabled"]:SetTexture("")
        _G[name.."MiddleDisabled"]:SetTexture("")
        _G[name.."RightDisabled"]:SetTexture("")
        _G[name.."Left"]:SetTexture("")
        _G[name.."Middle"]:SetTexture("")
        _G[name.."Right"]:SetTexture("")
        _G[name.."LeftHighlight"]:SetTexture("")
        _G[name.."MiddleHighlight"]:SetTexture("")
        _G[name.."RightHighlight"]:SetTexture("")

        Button.text:ClearAllPoints()
        Button.text:SetPoint("TOPLEFT")
        Button.text:SetPoint("BOTTOMRIGHT")
        --Button.text:SetPoint("CENTER")

        Base.SetBackdrop(Button)
        Base.SetHighlight(Button, "backdrop")
        Button._auroraTabResize = true
    end
    function Skin.MiniAchievementTemplate(Frame)
        Base.CropIcon(Frame.icon, Frame)
        Frame.border:Hide()
    end
    function Skin.MetaCriteriaTemplate(Button)
        Base.CropIcon(Button.icon, Button)
        Button.border:Hide()
    end
    function Skin.AchievementProgressBarTemplate(StatusBar)
        local name = StatusBar:GetName()

        _G[name.."BorderLeft"]:Hide()
        _G[name.."BorderRight"]:Hide()
        _G[name.."BorderCenter"]:Hide()

        Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")
    end
    function Skin.AchievementHeaderStatusBarTemplate(StatusBar)
        local name = StatusBar:GetName()

        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()

        Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")
    end
    function Skin.AchievementCategoryTemplate(Button)
        Base.SetBackdrop(Button, Color.button)
        Button.background:Hide()

        Button.label:SetPoint("BOTTOMLEFT", 6, 0)
        Button.label:SetPoint("TOPRIGHT")
        Button.label:SetJustifyV("MIDDLE")

        local r, g, b = Color.highlight:GetRGB()
        local highlight = Button:GetHighlightTexture()
        highlight:SetColorTexture(r, g, b, 0.5)
        highlight:SetPoint("BOTTOMRIGHT")
    end
    function Skin.AchievementIconFrameTemplate(Frame)
        Frame.bling:Hide()
        Base.CropIcon(Frame.texture, Frame)
        Frame.frame:Hide()
    end
    function Skin.AchievementTemplate(Button)
        hooksecurefunc(Button, "Saturate", Hook.AchievementButton_Saturate)
        hooksecurefunc(Button, "Desaturate", Hook.AchievementButton_Desaturate)

        Base.SetBackdrop(Button, Color.frame)
        Button.background:Hide()

        local name = Button:GetName()

        _G[name.."BottomLeftTsunami"]:Hide()
        _G[name.."BottomRightTsunami"]:Hide()
        _G[name.."TopLeftTsunami"]:Hide()
        _G[name.."TopRightTsunami"]:Hide()
        _G[name.."BottomTsunami1"]:Hide()
        _G[name.."TopTsunami1"]:Hide()

        Button.titleBar:Hide()
        Button.glow:Hide()
        Button.rewardBackground:SetAlpha(0)
        Button.guildCornerL:Hide()
        Button.guildCornerR:Hide()
        Button.plusMinus:SetAlpha(0)

        local plusMinus = _G.CreateFrame("Frame", nil, Button)
        Base.SetBackdrop(plusMinus, Color.button)
        plusMinus:SetAllPoints(Button.plusMinus)

        plusMinus.plus = plusMinus:CreateTexture(nil, "ARTWORK")
        plusMinus.plus:SetSize(1, 7)
        plusMinus.plus:SetPoint("CENTER")
        plusMinus.plus:SetColorTexture(1, 1, 1)

        plusMinus.minus = plusMinus:CreateTexture(nil, "ARTWORK")
        plusMinus.minus:SetSize(7, 1)
        plusMinus.minus:SetPoint("CENTER")
        plusMinus.minus:SetColorTexture(1, 1, 1)
        Button._auroraPlusMinus = plusMinus

        Base.SetBackdrop(Button.highlight, Color.white, 0)
        Button.highlight:DisableDrawLayer("OVERLAY")
        Button.highlight:ClearAllPoints()
        Button.highlight:SetPoint("TOPLEFT", 1, -1)
        Button.highlight:SetPoint("BOTTOMRIGHT", -1, 1)

        Skin.AchievementIconFrameTemplate(Button.icon)
        Skin.AchievementCheckButtonTemplate(Button.tracked)
    end
    function Skin.ComparisonPlayerTemplate(Frame)
        hooksecurefunc(Frame, "Saturate", Hook.AchievementButton_Saturate)
        hooksecurefunc(Frame, "Desaturate", Hook.AchievementButton_Desaturate)

        Base.SetBackdrop(Frame, Color.frame)
        Frame.background:Hide()
        Frame.titleBar:Hide()
        Frame.glow:Hide()

        Skin.AchievementIconFrameTemplate(Frame.icon)
    end
    function Skin.SummaryAchievementTemplate(Frame)
        Frame:SetHeight(44)
        Frame.icon:SetPoint("TOPLEFT", -1, -1)
        Frame.shield:SetPoint("TOPRIGHT", -5, -2)

        Skin.ComparisonPlayerTemplate(Frame)

        Base.SetBackdrop(Frame.highlight, Color.white, 0)
        Frame.highlight:DisableDrawLayer("OVERLAY")
        Frame.highlight:ClearAllPoints()
        Frame.highlight:SetPoint("TOPLEFT", 1, -1)
        Frame.highlight:SetPoint("BOTTOMRIGHT", -1, 1)
    end
    function Skin.ComparisonTemplate(Frame)
        Skin.ComparisonPlayerTemplate(Frame.player)

        hooksecurefunc(Frame.friend, "Saturate", Hook.AchievementButton_Saturate)
        hooksecurefunc(Frame.friend, "Desaturate", Hook.AchievementButton_Desaturate)

        Base.SetBackdrop(Frame.friend, Color.frame)
        Frame.friend.background:Hide()
        Frame.friend.titleBar:Hide()
        Frame.friend.glow:Hide()

        Skin.AchievementIconFrameTemplate(Frame.friend.icon)
    end
    function Skin.StatTemplate(Button)
        Button.left:SetAlpha(0)
        Button.middle:SetAlpha(0)
        Button.right:SetAlpha(0)

        local r, g, b = Color.highlight:GetRGB()
        Button:GetHighlightTexture():SetColorTexture(r, g, b, 0.2)
    end
    function Skin.ComparisonStatTemplate(Frame)
        Frame.left:SetAlpha(0)
        Frame.middle:SetAlpha(0)
        Frame.right:SetAlpha(0)

        Frame.left2:SetAlpha(0)
        Frame.middle2:SetAlpha(0)
        Frame.right2:SetAlpha(0)
    end
end

function private.AddOns.Blizzard_AchievementUI()
    hooksecurefunc("AchievementFrame_UpdateTabs", Hook.AchievementFrame_UpdateTabs)
    hooksecurefunc("AchievementFrameBaseTab_OnClick", Hook.AchievementFrameBaseTab_OnClick)
    hooksecurefunc("AchievementButton_UpdatePlusMinusTexture", Hook.AchievementButton_UpdatePlusMinusTexture)
    hooksecurefunc("AchievementButton_GetMiniAchievement", Hook.AchievementButton_GetMiniAchievement)
    hooksecurefunc("AchievementButton_GetProgressBar", Hook.AchievementButton_GetProgressBar)
    hooksecurefunc("AchievementButton_GetMeta", Hook.AchievementButton_GetMeta)
    hooksecurefunc("AchievementFrameSummary_UpdateAchievements", Hook.AchievementFrameSummary_UpdateAchievements)
    hooksecurefunc("AchievementFrameStats_SetStat", Hook.AchievementFrameStats_SetStat)
    hooksecurefunc("AchievementFrameStats_SetHeader", Hook.AchievementFrameStats_SetHeader)
    hooksecurefunc("AchievementFrameComparisonStats_SetStat", Hook.AchievementFrameComparisonStats_SetStat)
    hooksecurefunc("AchievementFrameComparisonStats_SetHeader", Hook.AchievementFrameComparisonStats_SetHeader)

    hooksecurefunc("AchievementComparisonPlayerButton_Saturate", function(self)
        if not self._auroraSkinned then
            Skin.SummaryAchievementTemplate(self)
            self._auroraSkinned = true
        end
        Hook.AchievementButton_Saturate(self)
    end)
    hooksecurefunc("AchievementComparisonPlayerButton_Desaturate", function(self)
        if not self._auroraSkinned then
            Skin.SummaryAchievementTemplate(self)
            self._auroraSkinned = true
        end
        Hook.AchievementButton_Desaturate(self)
    end)

    ----------------------
    -- AchievementFrame --
    ----------------------
    Base.SetBackdrop(_G.AchievementFrame)

    _G.AchievementFrameBackground:Hide()

    _G.AchievementFrameMetalBorderLeft:Hide()
    _G.AchievementFrameMetalBorderRight:Hide()
    _G.AchievementFrameMetalBorderBottom:Hide()
    _G.AchievementFrameMetalBorderTop:Hide()
    _G.AchievementFrameCategoriesBG:Hide()

    _G.AchievementFrameWaterMark:SetDesaturated(true)
    _G.AchievementFrameWaterMark:SetAlpha(0.5)

    _G.AchievementFrameGuildEmblemLeft:SetAlpha(0.5)
    _G.AchievementFrameGuildEmblemRight:SetAlpha(0.5)

    _G.AchievementFrameMetalBorderTopLeft:Hide()
    _G.AchievementFrameMetalBorderTopRight:Hide()
    _G.AchievementFrameMetalBorderBottomLeft:Hide()
    _G.AchievementFrameMetalBorderBottomRight:Hide()
    _G.AchievementFrameWoodBorderTopLeft:Hide()
    _G.AchievementFrameWoodBorderTopRight:Hide()
    _G.AchievementFrameWoodBorderBottomLeft:Hide()
    _G.AchievementFrameWoodBorderBottomRight:Hide()



    _G.AchievementFrameHeaderLeft:Hide()
    _G.AchievementFrameHeaderRight:Hide()

    _G.AchievementFrameHeaderPointBorder:Hide()
    _G.AchievementFrameHeaderTitle:Hide()
    _G.AchievementFrameHeaderLeftDDLInset:SetAlpha(0)
    _G.AchievementFrameHeaderRightDDLInset:SetAlpha(0)

    _G.AchievementFrameHeaderPoints:SetPoint("TOP", _G.AchievementFrame)
    _G.AchievementFrameHeaderPoints:SetPoint("BOTTOM", _G.AchievementFrame, "TOP", 0, -private.FRAME_TITLE_HEIGHT)



    Base.SetBackdrop(_G.AchievementFrameCategories, Color.frame)
    Skin.HybridScrollBarTemplate(_G.AchievementFrameCategoriesContainerScrollBar)
    _G.AchievementFrameCategoriesContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameCategoriesContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameCategoriesContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameCategoriesContainer, "BOTTOMRIGHT", 0, 12)



    Base.SetBackdrop(_G.AchievementFrameAchievements, Color.frame)
    _G.AchievementFrameAchievementsBackground:Hide()
    select(3, _G.AchievementFrameAchievements:GetRegions()):Hide()

    Skin.HybridScrollBarTemplate(_G.AchievementFrameAchievementsContainerScrollBar)
    _G.AchievementFrameAchievementsContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameAchievementsContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameAchievementsContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameAchievementsContainer, "BOTTOMRIGHT", 0, 12)
    select(2, _G.AchievementFrameAchievements:GetChildren()):Hide()



    Base.SetBackdrop(_G.AchievementFrameStats, Color.frame)
    _G.AchievementFrameStatsBG:Hide()
    Skin.HybridScrollBarTemplate(_G.AchievementFrameStatsContainerScrollBar)
    _G.AchievementFrameStatsContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameStatsContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameStatsContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameStatsContainer, "BOTTOMRIGHT", 0, 12)
    select(3, _G.AchievementFrameStats:GetChildren()):Hide()



    Base.SetBackdrop(_G.AchievementFrameSummary, Color.frame)
    _G.AchievementFrameSummaryBackground:Hide()
    _G.AchievementFrameSummary:GetChildren():Hide()

    _G.AchievementFrameSummaryAchievementsHeaderHeader:Hide()

    _G.AchievementFrameSummaryCategoriesHeaderTexture:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarTitle:SetPoint("LEFT", 6, 0)
    _G.AchievementFrameSummaryCategoriesStatusBarText:SetPoint("RIGHT", -6, 0)
    _G.AchievementFrameSummaryCategoriesStatusBarLeft:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarRight:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarMiddle:Hide()
    Base.SetTexture(_G.AchievementFrameSummaryCategoriesStatusBarBar, "gradientUp")
    for i = 1, 12 do
        Skin.AchievementFrameSummaryCategoryTemplate(_G["AchievementFrameSummaryCategoriesCategory"..i])
    end



    Base.SetBackdrop(_G.AchievementFrameComparison, Color.frame)
    _G.AchievementFrameComparisonHeader:SetPoint("BOTTOMLEFT", _G.AchievementFrameComparisonSummaryFriend, "TOPLEFT")
    _G.AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", _G.AchievementFrameComparisonSummaryFriend, "TOPRIGHT")
    _G.AchievementFrameComparisonHeader:SetHeight(private.FRAME_TITLE_HEIGHT * 2)
    _G.AchievementFrameComparisonHeaderBG:Hide()
    _G.AchievementFrameComparisonHeaderPortrait:Hide()
    _G.AchievementFrameComparisonHeaderPortraitBg:Hide()
    _G.AchievementFrameComparisonHeaderName:ClearAllPoints()
    _G.AchievementFrameComparisonHeaderName:SetPoint("TOP")
    _G.AchievementFrameComparisonHeaderName:SetHeight(private.FRAME_TITLE_HEIGHT)
    _G.AchievementFrameComparisonHeaderPoints:ClearAllPoints()
    _G.AchievementFrameComparisonHeaderPoints:SetPoint("TOP", "$parentName", "BOTTOM", 0, 0)
    _G.AchievementFrameComparisonHeaderPoints:SetHeight(private.FRAME_TITLE_HEIGHT)

    _G.AchievementFrameComparisonSummary:SetHeight(24)

    for _, unit in next, {"Player", "Friend"} do
        local summery = _G["AchievementFrameComparisonSummary"..unit]
        summery:SetHeight(24)
        summery:SetBackdrop(nil)
        _G["AchievementFrameComparisonSummary"..unit.."Background"]:Hide()
        Skin.AchievementHeaderStatusBarTemplate(summery.statusBar)
        summery.statusBar:ClearAllPoints()
        summery.statusBar:SetPoint("TOPLEFT")
        summery.statusBar:SetPoint("BOTTOMRIGHT")
    end

    Skin.HybridScrollBarTemplate(_G.AchievementFrameComparisonContainerScrollBar)
    _G.AchievementFrameComparisonContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameComparisonContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameComparisonContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameComparisonContainer, "BOTTOMRIGHT", 0, 12)

    Skin.HybridScrollBarTemplate(_G.AchievementFrameComparisonStatsContainerScrollBar)
    _G.AchievementFrameComparisonStatsContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameComparisonStatsContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameComparisonStatsContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameComparisonStatsContainer, "BOTTOMRIGHT", 0, 12)

    select(5, _G.AchievementFrameComparison:GetChildren()):Hide()

    _G.AchievementFrameComparisonBackground:Hide()
    _G.AchievementFrameComparisonDark:SetAlpha(0)
    _G.AchievementFrameComparisonWatermark:SetAlpha(0)



    Skin.UIPanelCloseButton(_G.AchievementFrameCloseButton)
    _G.AchievementFrameCloseButton:SetPoint("TOPRIGHT", -3, -3)

    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab1)
    _G.AchievementFrameTab1:ClearAllPoints()
    _G.AchievementFrameTab1:SetPoint("TOPLEFT", _G.AchievementFrame, "BOTTOMLEFT", 20, -1)
    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab2)
    _G.AchievementFrameTab2:ClearAllPoints()
    _G.AchievementFrameTab2:SetPoint("TOPLEFT", _G.AchievementFrameTab1, "TOPRIGHT", 1, 0)
    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab3)
    _G.AchievementFrameTab3:ClearAllPoints()
    _G.AchievementFrameTab3:SetPoint("TOPLEFT", _G.AchievementFrameTab2, "TOPRIGHT", 1, 0)


    _G.AchievementFrameFilterDropDown:SetPoint("TOPLEFT", 148, 4)
    _G.AchievementFrameFilterDropDown:SetHeight(16)

    local filterBG = _G.CreateFrame("Frame", nil, _G.AchievementFrameFilterDropDown)
    filterBG:SetPoint("TOPLEFT", 0, -6)
    filterBG:SetPoint("BOTTOMRIGHT", _G.AchievementFrameFilterDropDownButton, "BOTTOMLEFT", 1, 0)
    filterBG:SetFrameLevel(_G.AchievementFrameFilterDropDown:GetFrameLevel()-1)
    Base.SetBackdrop(filterBG, Color.frame)

    _G.AchievementFrameFilterDropDownText:SetPoint("LEFT", filterBG, 5, 0)

    Base.SetBackdrop(_G.AchievementFrameFilterDropDownButton, Color.button)
    _G.AchievementFrameFilterDropDownButton:SetPoint("TOPRIGHT", 0, -6)
    _G.AchievementFrameFilterDropDownButton:SetSize(16, 16)
    _G.AchievementFrameFilterDropDownButton:SetNormalTexture("")
    _G.AchievementFrameFilterDropDownButton:SetHighlightTexture("")
    _G.AchievementFrameFilterDropDownButton:SetPushedTexture("")

    local filterArrow = _G.AchievementFrameFilterDropDownButton:CreateTexture(nil, "ARTWORK")
    filterArrow:SetPoint("TOPLEFT", 4, -6)
    filterArrow:SetPoint("BOTTOMRIGHT", -5, 7)
    Base.SetTexture(filterArrow, "arrowDown")

    _G.AchievementFrameFilterDropDownButton._auroraHighlight = {filterArrow}
    Base.SetHighlight(_G.AchievementFrameFilterDropDownButton, "texture")

    Skin.SearchBoxTemplate(_G.AchievementFrame.searchBox)
    _G.AchievementFrame.searchBox:ClearAllPoints()
    _G.AchievementFrame.searchBox:SetPoint("TOPRIGHT", -148, 5)

    local prevContainer = _G.AchievementFrame.searchPreviewContainer
    prevContainer:DisableDrawLayer("OVERLAY")
    local prevContainerBG = _G.CreateFrame("Frame", nil, prevContainer)
    prevContainerBG:SetPoint("TOPRIGHT", 1, 1)
    prevContainerBG:SetPoint("BOTTOMLEFT", prevContainer.borderAnchor, 6, 4)
    prevContainerBG:SetFrameLevel(prevContainer:GetFrameLevel() - 1)
    Base.SetBackdrop(prevContainerBG, Color.frame)

    for i = 1, #_G.AchievementFrame.searchPreview do
        Skin.AchievementSearchPreviewButton(_G.AchievementFrame.searchPreview[i])
    end
    SkinSearchPreview(_G.AchievementFrame.showAllSearchResults)

    local searchResults = _G.AchievementFrame.searchResults
    Base.SetBackdrop(searchResults)
    searchResults:GetRegions():Hide() -- background

    local titleText = searchResults.titleText
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT")
    titleText:SetPoint("BOTTOMRIGHT", searchResults, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    searchResults.topLeftCorner:Hide()
    searchResults.topRightCorner:Hide()
    searchResults.topBorder:Hide()
    searchResults.bottomLeftCorner:Hide()
    searchResults.bottomRightCorner:Hide()
    searchResults.bottomBorder:Hide()
    searchResults.leftBorder:Hide()
    searchResults.rightBorder:Hide()
    searchResults.topTileStreaks:Hide()
    searchResults.topLeftCorner2:Hide()
    searchResults.topRightCorner2:Hide()
    searchResults.topBorder2:Hide()

    Skin.UIPanelCloseButton(searchResults.closeButton)
    searchResults.closeButton:SetPoint("TOPRIGHT", -3, -3)
    Skin.HybridScrollBarTrimTemplate(searchResults.scrollFrame.scrollBar)
end
