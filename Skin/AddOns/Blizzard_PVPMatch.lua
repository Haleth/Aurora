local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ AddOns\Blizzard_PVPMatch.lua ]]
--end

do --[[ AddOns\Blizzard_PVPMatch.xml ]]
    do --[[ PVPMatchTable.xml ]]
        function Skin.PVPTableRowTemplate(Frame)
            Frame.backgroundLeft:ClearAllPoints()
            Frame.backgroundLeft:SetPoint("TOPLEFT")
            Frame.backgroundLeft:SetTexture(private.textures.plain)
            Frame.backgroundLeft:SetHeight(15)
            Frame.backgroundLeft:SetAlpha(0.5)

            Frame.backgroundRight:ClearAllPoints()
            Frame.backgroundRight:SetPoint("TOPRIGHT")
            Frame.backgroundRight:SetTexture(private.textures.plain)
            Frame.backgroundRight:SetHeight(15)
            Frame.backgroundRight:SetAlpha(0.5)

            Frame.backgroundCenter:SetTexture(private.textures.plain)
            Frame.backgroundCenter:SetHeight(15)
            Frame.backgroundCenter:SetAlpha(0.5)
        end
    end
end

function private.AddOns.Blizzard_PVPMatch()
    ----====####$$$$%%%%%$$$$####====----
    --         PVPMatchResults         --
    ----====####$$$$%%%%%$$$$####====----
    local PVPMatchResults = _G.PVPMatchResults
    Skin.UIPanelCloseButton(PVPMatchResults.CloseButton)
    PVPMatchResults.CloseButton.Border:Hide()

    local resultsContent = PVPMatchResults.content
    resultsContent.background:Hide()
    resultsContent.InsetBorderTopLeft:Hide()
    resultsContent.InsetBorderTopRight:Hide()
    resultsContent.InsetBorderBottomLeft:Hide()
    resultsContent.InsetBorderBottomRight:Hide()
    resultsContent.InsetBorderTop:Hide()
    resultsContent.InsetBorderBottom:Hide()
    resultsContent.InsetBorderLeft:Hide()
    resultsContent.InsetBorderRight:Hide()

    Skin.HybridScrollBarTemplate(resultsContent.scrollFrame.scrollBar)

    local tabContainer = resultsContent.tabContainer
    tabContainer.InsetBorderTop:Hide()
    tabContainer.InsetBorderBottom:Hide()
    Skin.CharacterFrameTabButtonTemplate(tabContainer.tabGroup.tab1)
    Skin.CharacterFrameTabButtonTemplate(tabContainer.tabGroup.tab2)
    Skin.CharacterFrameTabButtonTemplate(tabContainer.tabGroup.tab3)
    Util.PositionRelative("TOPLEFT", tabContainer.tabGroup, "BOTTOMLEFT", 20, 49, 1, "Right", {
        tabContainer.tabGroup.tab1,
        tabContainer.tabGroup.tab2,
        tabContainer.tabGroup.tab3,
    })

    Skin.UIPanelButtonTemplate(PVPMatchResults.buttonContainer.requeueButton)
    Skin.UIPanelButtonTemplate(PVPMatchResults.buttonContainer.leaveButton)

    PVPMatchResults:GetRegions():Hide() -- groupfinder-background


    ----====####$$$$%%%%$$$$####====----
    --       PVPMatchScoreboard       --
    ----====####$$$$%%%%$$$$####====----
    local PVPMatchScoreboard = _G.PVPMatchScoreboard
    Skin.UIPanelCloseButton(PVPMatchScoreboard.CloseButton)

    local scoreContent = PVPMatchScoreboard.Content
    scoreContent.Background:Hide()
    scoreContent.InsetBorderTopLeft:Hide()
    scoreContent.InsetBorderTopRight:Hide()
    scoreContent.InsetBorderBottomLeft:Hide()
    scoreContent.InsetBorderBottomRight:Hide()
    scoreContent.InsetBorderTop:Hide()
    scoreContent.InsetBorderBottom:Hide()
    scoreContent.InsetBorderLeft:Hide()
    scoreContent.InsetBorderRight:Hide()

    Skin.HybridScrollBarTemplate(scoreContent.ScrollFrame.ScrollBar)

    local scoreTabContainer = scoreContent.TabContainer
    scoreTabContainer.InsetBorderTop:Hide()
    Skin.CharacterFrameTabButtonTemplate(scoreTabContainer.TabGroup.Tab1)
    Skin.CharacterFrameTabButtonTemplate(scoreTabContainer.TabGroup.Tab2)
    Skin.CharacterFrameTabButtonTemplate(scoreTabContainer.TabGroup.Tab3)
    Util.PositionRelative("TOPLEFT", scoreTabContainer.TabGroup, "BOTTOMLEFT", 20, 49, 1, "Right", {
        scoreTabContainer.TabGroup.Tab1,
        scoreTabContainer.TabGroup.Tab2,
        scoreTabContainer.TabGroup.Tab3,
    })

    PVPMatchScoreboard:GetRegions():Hide() -- groupfinder-background
end
