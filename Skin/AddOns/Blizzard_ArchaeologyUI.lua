local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select floor

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

local r, g, b = Color.grayLight:GetRGB()

do --[[ AddOns\Blizzard_ArchaeologyUI.lua ]]
    function Hook.RaceFilter_OnHide(self)
        _G.ArchaeologyFrame.rankBar:SetPoint("TOP", 0, -60)
    end
    function Hook.ArcheologyDigsiteProgressBar_OnEvent(self, event, ...)
        if event == "ARCHAEOLOGY_SURVEY_CAST" then
            local _, totalFinds = ...
            Util.PositionBarTicks(self.FillBar, totalFinds)
        end
    end
end

do --[[ AddOns\Blizzard_ArchaeologyUI.xml ]]
    function Skin.ArchaeologyRaceTemplate(Button)
        Button.raceName:SetTextColor(r, g, b)
    end
    function Skin.ArchaeologyArtifactTemplate(Button)
        Button.border:Hide()
        Base.CropIcon(Button.icon, Button)

        Button.artifactName:SetTextColor(r, g, b)
        Button.artifactName:ClearAllPoints()
        Button.artifactName:SetPoint("TOPLEFT", Button.icon, "TOPRIGHT", 5, -5)
        Button.artifactName:SetPoint("BOTTOMRIGHT", Button, "RIGHT", -5, 0)

        Button.artifactSubText:SetTextColor(Color.grayDark:GetRGB())
        Button.artifactSubText:SetPoint("TOPLEFT", Button.artifactName, "BOTTOMLEFT", 0, 0)
        Button.artifactSubText:SetPoint("BOTTOMRIGHT", -5, 5)
    end
    function Skin.KeystoneTemplate(Button)
    end
end

function private.AddOns.Blizzard_ArchaeologyUI()
    ----====####$$$$%%%%$$$$####====----
    --     Blizzard_ArchaeologyUI     --
    ----====####$$$$%%%%$$$$####====----
    local ArchaeologyFrame = _G.ArchaeologyFrame
    Skin.ButtonFrameTemplate(ArchaeologyFrame)

    ArchaeologyFrame.factionIcon:SetAlpha(0)
    ArchaeologyFrame.bgLeft:Hide()
    ArchaeologyFrame.bgRight:Hide()

    Skin.UIDropDownMenuTemplate(ArchaeologyFrame.raceFilterDropDown)
    ArchaeologyFrame.raceFilterDropDown:HookScript("OnHide", Hook.RaceFilter_OnHide)
    ArchaeologyFrame.raceFilterDropDown:SetPoint("TOPRIGHT", -30, -52)

    Skin.FrameTypeStatusBar(ArchaeologyFrame.rankBar)
    ArchaeologyFrame.rankBar:SetPoint("TOP", 0, -60)
    _G.ArchaeologyFrameRankBarBorder:Hide()
    _G.ArchaeologyFrameRankBarBackground:Hide()


    -----------------
    -- SummaryPage --
    -----------------
    local summaryPage = ArchaeologyFrame.summaryPage
    summaryPage:SetPoint("TOPLEFT", ArchaeologyFrame.Inset, 2, -15)

    local title, left, right = summaryPage:GetRegions()
    title:SetTextColor(r, g, b)
    left:Hide()
    right:Hide()
    summaryPage.pageText:SetTextColor(r, g, b)

    -- xOffset = (ArchaeologyFrameSummaryPage:GetWidth() - (ArchaeologyFrameSummaryPageRace1:GetWidth() * 4 + 30 * 3)) / 2
    summaryPage.race1:SetPoint("TOPLEFT", 60, -75)
    local previousButton = summaryPage.race1
    local cornerButton = previousButton
    for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
        local raceButton = summaryPage["race"..i]
        Skin.ArchaeologyRaceTemplate(raceButton)
        if i > 1 then
            if i % 4 == 1 then
                raceButton:SetPoint("TOPLEFT", cornerButton, "BOTTOMLEFT", 0, -35)
                cornerButton = raceButton
            else
                raceButton:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", 30, 0)
            end

            previousButton = raceButton
        end
    end

    Skin.UIPanelSquareButton(summaryPage.prevPageButton, "LEFT")
    Skin.UIPanelSquareButton(summaryPage.nextPageButton, "RIGHT")


    -------------------
    -- CompletedPage --
    -------------------
    local completedPage = ArchaeologyFrame.completedPage
    completedPage:SetPoint("TOPLEFT", ArchaeologyFrame.Inset, 2, -15)

    completedPage.titleBig:SetTextColor(r, g, b)
    completedPage.titleBigLeft:SetAlpha(0)
    completedPage.titleBigRight:SetAlpha(0)

    completedPage.titleTop:SetTextColor(r, g, b)
    completedPage.titleTopLeft:SetAlpha(0)
    completedPage.titleTopRight:SetAlpha(0)

    completedPage.titleMid:SetTextColor(r, g, b)
    completedPage.titleMidLeft:SetAlpha(0)
    completedPage.titleMidRight:SetAlpha(0)

    completedPage.pageText:SetTextColor(r, g, b)

    -- xOffset = (ArchaeologyFrameCompletedPage:GetWidth() - (ArchaeologyFrameCompletedPageArtifact1:GetWidth() * 2 + 20)) / 2
    completedPage.artifact1:SetPoint("TOPLEFT", 60, -90)
    previousButton = completedPage.artifact1
    cornerButton = previousButton
    for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
        local artifactButton = completedPage["artifact"..i]
        Skin.ArchaeologyArtifactTemplate(artifactButton)
        if i > 1 then
            if i % 2 == 1 then
                artifactButton:SetPoint("TOPLEFT", cornerButton, "BOTTOMLEFT", 0, -15)
                cornerButton = artifactButton
            else
                artifactButton:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", 20, 0)
            end

            previousButton = artifactButton
        end
    end

    Skin.UIPanelSquareButton(completedPage.prevPageButton, "LEFT")
    Skin.UIPanelSquareButton(completedPage.nextPageButton, "RIGHT")


    ------------------
    -- ArtifactPage --
    ------------------
    local artifactPage = ArchaeologyFrame.artifactPage
    artifactPage:SetPoint("TOPLEFT", ArchaeologyFrame.Inset, 2, -15)

    title, left, right = artifactPage:GetRegions()
    title:SetTextColor(r, g, b)
    left:Hide()
    right:Hide()

    Base.CropIcon(artifactPage.icon, artifactPage)

    artifactPage.raceBG:SetDesaturated(true)
    artifactPage.raceBG:SetAlpha(0.25)
    artifactPage.artifactBG:SetDesaturated(true)
    artifactPage.artifactBG:SetAlpha(0.5)

    local solveFrame = artifactPage.solveFrame
    Skin.KeystoneTemplate(solveFrame.keystone1)
    Skin.KeystoneTemplate(solveFrame.keystone2)
    Skin.KeystoneTemplate(solveFrame.keystone3)
    Skin.KeystoneTemplate(solveFrame.keystone4)
    Skin.UIPanelButtonTemplate(solveFrame.solveButton)
    Skin.FrameTypeStatusBar(solveFrame.statusBar)
    solveFrame.statusBar:SetStatusBarColor(0.6784, 0.2705, 0.0)
    _G.ArchaeologyFrameArtifactPageSolveFrameStatusBarBarBG:Hide()

    Skin.UIPanelButtonTemplate(artifactPage.backButton)
    Skin.MinimalScrollFrameTemplate(artifactPage.historyScroll)
    artifactPage.historyScroll.child.text:SetTextColor(r, g, b)


    --------------
    -- HelpPage --
    --------------
    Skin.UIPanelInfoButton(ArchaeologyFrame.infoButton)
    ArchaeologyFrame.infoButton:SetPoint("TOPLEFT", 3, -3)

    local helpPage = ArchaeologyFrame.helpPage
    helpPage:SetPoint("TOPLEFT", ArchaeologyFrame.Inset, 2, -15)

    title, left, right = helpPage:GetRegions()
    title:SetTextColor(r, g, b)
    left:Hide()
    right:Hide()

    _G.ArchaeologyFrameHelpPageDigTex:SetSize(410, 190)
    _G.ArchaeologyFrameHelpPageDigTex:SetPoint("BOTTOM", 0, 49)
    _G.ArchaeologyFrameHelpPageDigTex:SetTexCoord(0.056640625, 0.857421875, 0.171875, 0.90234375)
    _G.ArchaeologyFrameHelpPageDigTitle:SetTextColor(r, g, b)
    _G.ArchaeologyFrameHelpPageDigTitle:SetPoint("TOP", _G.ArchaeologyFrameHelpPageDigTex, 0, 19)
    Skin.MinimalScrollFrameTemplate(_G.ArchaeologyFrameHelpPageHelpScroll)
    _G.ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(r, g, b)



    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_ArchaeologyProgressBar --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("ArcheologyDigsiteProgressBar_OnEvent", Hook.ArcheologyDigsiteProgressBar_OnEvent)

    local ArcheologyDigsiteProgressBar = _G.ArcheologyDigsiteProgressBar
    ArcheologyDigsiteProgressBar:HookScript("OnEvent", Hook.ArcheologyDigsiteProgressBar_OnEvent)
    ArcheologyDigsiteProgressBar.Shadow:Hide()
    ArcheologyDigsiteProgressBar.BarBackground:Hide()
    ArcheologyDigsiteProgressBar.BarBorderAndOverlay:Hide()

    local FillBar = ArcheologyDigsiteProgressBar.FillBar
    Skin.FrameTypeStatusBar(FillBar)
    FillBar:ClearAllPoints()
    FillBar:SetPoint("BOTTOM", 0, 7)
    FillBar:SetStatusBarColor(Color.yellow:Hue(-0.08):GetRGB())
end
