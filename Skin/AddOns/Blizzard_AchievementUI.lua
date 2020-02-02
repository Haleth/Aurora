local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

local function SkinSearchButton(button)
    button:SetNormalTexture("")
    button:SetPushedTexture("")

    local r, g, b = Color.highlight:GetRGB()
    local highlight = button.selectedTexture or button:GetHighlightTexture()
    highlight:SetColorTexture(r, g, b, 0.2)
end

do --[[ AddOns\Blizzard_AchievementUI.lua ]]
    local IN_GUILD_VIEW = false
    local red, green, blue = Color.red:Hue(0.03), Color.green:Lightness(-0.4), Color.blue:Hue(-0.05)
    local redDesat, greenDesat, blueDesat = red:Saturation(-0.4), green:Saturation(-0.4), blue:Saturation(-0.4)

    function Hook.AchievementFrame_UpdateTabs(clickedTab)
        for i = 1, 3 do
            _G["AchievementFrameTab"..i].text:SetPoint("CENTER")
        end
    end
    function Hook.AchievementFrame_ToggleView()
        IN_GUILD_VIEW = not (_G.AchievementFrameHeaderTitle:GetText() == _G.ACHIEVEMENT_TITLE)

        if IN_GUILD_VIEW then
            _G.AchievementFrameGuildEmblemLeft:SetVertexColor(1, 1, 1, 0.25)
            _G.AchievementFrameGuildEmblemRight:SetVertexColor(1, 1, 1, 0.25)
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
        Base.SetBackdropColor(self, Color.button, 1)

        if IN_GUILD_VIEW then
            self.titleBar:SetColorTexture(green:GetRGB())
        else
            if self.accountWide then
                self.titleBar:SetColorTexture(blue:GetRGB())
            else
                self.titleBar:SetColorTexture(red:GetRGB())
            end
        end

        if self.description then
            self.description:SetTextColor(.9, .9, .9)
            self.description:SetShadowOffset(1, -1)
        end
    end
    function Hook.AchievementButton_Desaturate(self)
        Base.SetBackdropColor(self, Color.button, 1)

        if IN_GUILD_VIEW then
            self.titleBar:SetColorTexture(greenDesat:GetRGB())
        else
            if self.accountWide then
                self.titleBar:SetColorTexture(blueDesat:GetRGB())
            else
                self.titleBar:SetColorTexture(redDesat:GetRGB())
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
                    local anchorTo = _G["AchievementFrameSummaryAchievement"..i-1]
                    button:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", 0, -1 )
                    button:SetPoint("TOPRIGHT", anchorTo, "BOTTOMRIGHT", 0, -1 )
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
        SkinSearchButton(Button)

        Button.iconFrame:SetAlpha(0)
        Base.CropIcon(Button.icon, Button)
    end
    function Skin.AchievementFullSearchResultsButton(Button)
        SkinSearchButton(Button)

        Button.iconFrame:SetAlpha(0)
        Base.CropIcon(Button.icon, Button)

        Button.path:SetTextColor(Color.grayLight:GetRGB())
        Button.resultType:SetTextColor(Color.grayLight:GetRGB())
    end
    function Skin.AchievementFrameSummaryCategoryTemplate(StatusBar)
        Skin.FrameTypeStatusBar(StatusBar)

        local name = StatusBar:GetName()
        StatusBar.label:SetPoint("LEFT", 6, 0)
        StatusBar.text:SetPoint("RIGHT", -6, 0)

        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."FillBar"]:Hide()

        local r, g, b = Color.highlight:GetRGB()
        _G[name.."ButtonHighlightLeft"]:Hide()
        _G[name.."ButtonHighlightRight"]:Hide()

        local highlight = _G[name.."ButtonHighlightMiddle"]
        highlight:SetAllPoints()
        highlight:SetColorTexture(r, g, b, 0.2)
    end
    function Skin.AchievementCheckButtonTemplate(CheckButton)
        Skin.FrameTypeCheckButton(CheckButton)
        CheckButton:SetBackdropOption("offsets", {
            left = 2,
            right = 2,
            top = 2,
            bottom = 2,
        })

        _G[CheckButton:GetName().."Text"]:SetPoint("LEFT", CheckButton, "RIGHT", 2, 0)


        local bg = CheckButton:GetBackdropTexture("bg")
        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bg, -6, 6)
        check:SetPoint("BOTTOMRIGHT", bg, 6, -6)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())
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
        Skin.FrameTypeStatusBar(StatusBar)

        local name = StatusBar:GetName()
        _G[name.."BG"]:Hide()
        _G[name.."BorderLeft"]:Hide()
        _G[name.."BorderRight"]:Hide()
        _G[name.."BorderCenter"]:Hide()
    end
    function Skin.AchievementHeaderStatusBarTemplate(StatusBar)
        Skin.FrameTypeStatusBar(StatusBar)

        local name = StatusBar:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."FillBar"]:Hide()
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
        _G.hooksecurefunc(Button, "Saturate", Hook.AchievementButton_Saturate)
        _G.hooksecurefunc(Button, "Desaturate", Hook.AchievementButton_Desaturate)

        Base.SetBackdrop(Button, Color.button, 1)
        Button.background:Hide()

        local name = Button:GetName()

        _G[name.."BottomLeftTsunami"]:Hide()
        _G[name.."BottomRightTsunami"]:Hide()
        _G[name.."TopLeftTsunami"]:Hide()
        _G[name.."TopRightTsunami"]:Hide()
        _G[name.."BottomTsunami1"]:Hide()
        _G[name.."TopTsunami1"]:Hide()

        local titleMask = Button:CreateMaskTexture()
        titleMask:SetTexture([[Interface\FriendsFrame\PendingFriendNameBG-New]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        titleMask:SetAllPoints(Button.titleBar)
        Button.titleBar:AddMaskTexture(titleMask)
        Button.titleBar:SetHeight(68)
        Button.titleBar:SetPoint("TOPLEFT", 10, 8)
        Button.titleBar:SetPoint("TOPRIGHT", -10, 8)

        Button.glow:Hide()
        Button.rewardBackground:SetAlpha(0)
        Button.guildCornerL:Hide()
        Button.guildCornerR:Hide()
        Button.label:SetPoint("TOP", 0, -4)

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

        Base.SetBackdrop(Button.highlight, Color.highlight, Color.frame.a)
        Button.highlight:DisableDrawLayer("OVERLAY")
        Button.highlight:ClearAllPoints()
        Button.highlight:SetPoint("TOPLEFT", 1, -1)
        Button.highlight:SetPoint("BOTTOMRIGHT", -1, 1)

        Skin.AchievementIconFrameTemplate(Button.icon)
        Skin.AchievementCheckButtonTemplate(Button.tracked)
    end
    function Skin.ComparisonPlayerTemplate(Frame)
        _G.hooksecurefunc(Frame, "Saturate", Hook.AchievementButton_Saturate)
        _G.hooksecurefunc(Frame, "Desaturate", Hook.AchievementButton_Desaturate)

        Base.SetBackdrop(Frame, Color.frame)
        Frame.background:Hide()

        local titleMask = Frame:CreateMaskTexture()
        titleMask:SetTexture([[Interface\FriendsFrame\PendingFriendNameBG-New]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        titleMask:SetPoint("TOPLEFT", Frame.titleBar, 0, 8)
        titleMask:SetPoint("BOTTOMRIGHT", Frame.titleBar, 0, -15)

        Frame.titleBar:AddMaskTexture(titleMask)
        Frame.titleBar:ClearAllPoints()
        Frame.titleBar:SetPoint("TOPLEFT", 10, -1)
        Frame.titleBar:SetPoint("BOTTOMRIGHT", -10, 1)

        Frame.glow:Hide()
        Frame.label:SetPoint("TOP", 0, -4)

        Skin.AchievementIconFrameTemplate(Frame.icon)
    end
    function Skin.SummaryAchievementTemplate(Frame)
        Frame:SetHeight(44)
        Frame.icon:SetPoint("TOPLEFT", -1, -1)
        Frame.shield:SetPoint("TOPRIGHT", -5, -2)

        Skin.ComparisonPlayerTemplate(Frame)

        Base.SetBackdrop(Frame.highlight, Color.highlight, Color.frame.a)
        Frame.highlight:DisableDrawLayer("OVERLAY")
        Frame.highlight:ClearAllPoints()
        Frame.highlight:SetPoint("TOPLEFT", 1, -1)
        Frame.highlight:SetPoint("BOTTOMRIGHT", -1, 1)
    end
    function Skin.ComparisonTemplate(Frame)
        Skin.ComparisonPlayerTemplate(Frame.player)

        _G.hooksecurefunc(Frame.friend, "Saturate", Hook.AchievementButton_Saturate)
        _G.hooksecurefunc(Frame.friend, "Desaturate", Hook.AchievementButton_Desaturate)

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
    _G.hooksecurefunc("AchievementFrame_UpdateTabs", Hook.AchievementFrame_UpdateTabs)
    _G.hooksecurefunc("AchievementFrame_ToggleView", Hook.AchievementFrame_ToggleView)
    _G.hooksecurefunc("AchievementButton_UpdatePlusMinusTexture", Hook.AchievementButton_UpdatePlusMinusTexture)
    _G.hooksecurefunc("AchievementButton_GetMiniAchievement", Hook.AchievementButton_GetMiniAchievement)
    _G.hooksecurefunc("AchievementButton_GetProgressBar", Hook.AchievementButton_GetProgressBar)
    _G.hooksecurefunc("AchievementButton_GetMeta", Hook.AchievementButton_GetMeta)
    _G.hooksecurefunc("AchievementFrameSummary_UpdateAchievements", Hook.AchievementFrameSummary_UpdateAchievements)
    _G.hooksecurefunc("AchievementFrameStats_SetStat", Hook.AchievementFrameStats_SetStat)
    _G.hooksecurefunc("AchievementFrameStats_SetHeader", Hook.AchievementFrameStats_SetHeader)
    _G.hooksecurefunc("AchievementFrameComparisonStats_SetStat", Hook.AchievementFrameComparisonStats_SetStat)
    _G.hooksecurefunc("AchievementFrameComparisonStats_SetHeader", Hook.AchievementFrameComparisonStats_SetHeader)

    _G.hooksecurefunc("AchievementComparisonPlayerButton_Saturate", function(self)
        if not self._auroraSkinned then
            Skin.SummaryAchievementTemplate(self)
            self._auroraSkinned = true
        end
        Hook.AchievementButton_Saturate(self)
    end)
    _G.hooksecurefunc("AchievementComparisonPlayerButton_Desaturate", function(self)
        if not self._auroraSkinned then
            Skin.SummaryAchievementTemplate(self)
            self._auroraSkinned = true
        end
        Hook.AchievementButton_Desaturate(self)
    end)

    ----------------------
    -- AchievementFrame --
    ----------------------
    local AchievementFrame = _G.AchievementFrame
    Base.SetBackdrop(AchievementFrame)
    local bg = AchievementFrame:GetBackdropTexture("bg")
    AchievementFrame:SetBackdropOption("offsets", {
        left = 0,
        right = 0,
        top = -10,
        bottom = 0,
    })

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



    ------------
    -- Header --
    ------------
    _G.AchievementFrameHeader:Hide()
    _G.AchievementFrameHeaderLeft:Hide()
    _G.AchievementFrameHeaderRight:Hide()

    _G.AchievementFrameHeaderPointBorder:Hide()
    _G.AchievementFrameHeaderTitle:Hide()
    _G.AchievementFrameHeaderLeftDDLInset:SetAlpha(0)
    _G.AchievementFrameHeaderRightDDLInset:SetAlpha(0)

    _G.AchievementFrameHeaderPoints:SetParent(AchievementFrame)
    _G.AchievementFrameHeaderPoints:SetPoint("TOP", bg)
    _G.AchievementFrameHeaderPoints:SetPoint("BOTTOM", bg, "TOP", 0, -private.FRAME_TITLE_HEIGHT)
    _G.AchievementFrameHeaderShield:SetParent(AchievementFrame)



    ----------------
    -- Categories --
    ----------------
    _G.AchievementFrameCategories:SetBackdrop(nil)
    Skin.HybridScrollBarTemplate(_G.AchievementFrameCategoriesContainerScrollBar)



    ------------------
    -- Achievements --
    ------------------
    _G.AchievementFrameAchievementsBackground:Hide()
    select(3, _G.AchievementFrameAchievements:GetRegions()):Hide()

    Skin.HybridScrollBarTemplate(_G.AchievementFrameAchievementsContainerScrollBar)
    select(2, _G.AchievementFrameAchievements:GetChildren()):Hide()



    -----------
    -- Stats --
    -----------
    _G.AchievementFrameStatsBG:Hide()
    Skin.HybridScrollBarTemplate(_G.AchievementFrameStatsContainerScrollBar)
    _G.AchievementFrameStatsContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameStatsContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameStatsContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameStatsContainer, "BOTTOMRIGHT", 0, 12)
    select(3, _G.AchievementFrameStats:GetChildren()):Hide()



    -------------
    -- Summary --
    -------------
    _G.AchievementFrameSummaryBackground:Hide()
    _G.AchievementFrameSummary:GetChildren():Hide()

    _G.AchievementFrameSummaryAchievementsHeaderHeader:Hide()

    _G.AchievementFrameSummaryCategoriesHeaderTexture:Hide()

    Skin.FrameTypeStatusBar(_G.AchievementFrameSummaryCategoriesStatusBar)
    _G.AchievementFrameSummaryCategoriesStatusBarTitle:SetPoint("LEFT", 6, 0)
    _G.AchievementFrameSummaryCategoriesStatusBarText:SetPoint("RIGHT", -6, 0)
    _G.AchievementFrameSummaryCategoriesStatusBarLeft:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarRight:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarMiddle:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarFillBar:Hide()
    for i = 1, 12 do
        Skin.AchievementFrameSummaryCategoryTemplate(_G["AchievementFrameSummaryCategoriesCategory"..i])
    end



    ----------------
    -- Comparison --
    ----------------
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
    _G.AchievementFrameCloseButton:SetPoint("TOPRIGHT", bg, 5.6, 5)
    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab1)
    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab2)
    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab3)
    Util.PositionRelative("TOPLEFT", AchievementFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.AchievementFrameTab1,
        _G.AchievementFrameTab2,
        _G.AchievementFrameTab3,
    })


    Base.SetBackdrop(_G.AchievementFrameFilterDropDown, Color.button)
    local filterBG = _G.AchievementFrameFilterDropDown:GetBackdropTexture("bg")

    _G.AchievementFrameFilterDropDown:SetPoint("TOPLEFT", bg, 148, -6)
    _G.AchievementFrameFilterDropDown:SetHeight(16)
    _G.AchievementFrameFilterDropDownText:SetPoint("LEFT", filterBG, 5, 0)

    Skin.FrameTypeButton(_G.AchievementFrameFilterDropDownButton)
    _G.AchievementFrameFilterDropDownButton:SetSize(16, 16)

    local filterArrow = _G.AchievementFrameFilterDropDownButton:CreateTexture(nil, "ARTWORK")
    filterArrow:SetPoint("TOPLEFT", 4, -6)
    filterArrow:SetPoint("BOTTOMRIGHT", -4, 6)
    Base.SetTexture(filterArrow, "arrowDown")

    local searchBox = AchievementFrame.searchBox
    Skin.SearchBoxTemplate(searchBox)
    searchBox:ClearAllPoints()
    searchBox:SetPoint("TOPRIGHT", bg, -148, 0)

    local prevContainer = AchievementFrame.searchPreviewContainer
    prevContainer.background:Hide()
    prevContainer.borderAnchor:Hide()
    prevContainer.botRightCorner:Hide()
    prevContainer.bottomBorder:Hide()
    prevContainer.leftBorder:Hide()
    prevContainer.rightBorder:Hide()
    prevContainer.topBorder:Hide()

    Base.SetBackdrop(prevContainer)

    for i = 1, #prevContainer.searchPreviews do
        Skin.AchievementSearchPreviewButton(prevContainer.searchPreviews[i])
    end
    SkinSearchButton(prevContainer.showAllSearchResults)

    local searchResults = AchievementFrame.searchResults
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

    searchResults.scrollFrame:ClearAllPoints()
    searchResults.scrollFrame:SetPoint("TOPLEFT", 3, -(private.FRAME_TITLE_HEIGHT + 3))
    searchResults.scrollFrame:SetPoint("BOTTOMRIGHT", -23, 3)
    Skin.UIPanelCloseButton(searchResults.closeButton)
    Skin.HybridScrollBarTrimTemplate(searchResults.scrollFrame.scrollBar)
end
