local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\QuestMapFrame.lua ]]
    -- /dump C_CampaignInfo.GetCampaignInfo(C_CampaignInfo.GetCurrentCampaignID())
    local uiTextureKits = {
        [0] = {color = Color.button, overlay = ""},
        [261] = {color = Color.blue:Lightness(-0.3), overlay = [[Interface\Timer\Alliance-Logo]]},
        [262] = {color = Color.red:Lightness(-0.3), overlay = [[Interface\Timer\Horde-Logo]]},
    }
    function Hook.QuestLogQuests_Update(poiTable)
        local warCampaignID = _G.C_CampaignInfo.GetCurrentCampaignID()
        local warCampaignShown = false

        if warCampaignID then
            local warCampaignInfo = _G.C_CampaignInfo.GetCampaignInfo(warCampaignID)
            if warCampaignInfo and warCampaignInfo.visibilityConditionMatched then
                local kit = uiTextureKits[warCampaignInfo.uiTextureKitID] or uiTextureKits[0]
                _G.QuestScrollFrame.Contents.WarCampaignHeader.Background:SetColorTexture(kit.color:GetRGB())
                _G.QuestScrollFrame.Contents.WarCampaignHeader._auroraOverlay:SetTexture(kit.overlay)
                warCampaignShown = true
            end
        end

        if warCampaignShown then
            _G.QuestScrollFrame.Contents.Separator.Divider:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, 0.5)
            _G.QuestScrollFrame.Contents.Separator.Divider:SetSize(200, 1)
        end

        for i = 6, _G.QuestMapFrame.QuestsFrame.Contents:GetNumChildren() do
            local child = select(i, _G.QuestMapFrame.QuestsFrame.Contents:GetChildren())
            if not child._auroraSkinned then
                if child.TaskIcon then
                    Skin.QuestLogTitleTemplate(child)
                elseif child.ButtonText then
                    Skin.QuestLogHeaderTemplate(child)
                else
                    Skin.QuestLogObjectiveTemplate(child)
                end
                child._auroraSkinned = true
            end
        end
    end
end

do --[[ FrameXML\QuestMapFrame.xml ]]
    function Skin.WarCampaignTooltipTemplate(Frame)
        Base.SetBackdrop(Frame)
        Skin.InternalEmbeddedItemTooltipTemplate(Frame.ItemTooltip)
    end
    function Skin.QuestLogHeaderTemplate(Button)
        Skin.ExpandOrCollapse(Button)
    end
    function Skin.QuestLogTitleTemplate(Button)
    end
    function Skin.QuestLogObjectiveTemplate(Button)
    end
end

function private.FrameXML.QuestMapFrame()
    ------------------------------
    -- QuestLogPopupDetailFrame --
    ------------------------------
    local QuestLogPopupDetailFrame = _G.QuestLogPopupDetailFrame
    Skin.ButtonFrameTemplate(QuestLogPopupDetailFrame)
    Skin.QuestFramePanelTemplate(QuestLogPopupDetailFrame)
    select(12, QuestLogPopupDetailFrame:GetRegions()):Hide() -- Portrait

    Skin.UIPanelScrollFrameTemplate(QuestLogPopupDetailFrame.ScrollFrame)
    QuestLogPopupDetailFrame.ScrollFrame:SetPoint("TOPLEFT", 5, -(private.FRAME_TITLE_HEIGHT + 2))
    QuestLogPopupDetailFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", -23, 32)

    local scrollName = QuestLogPopupDetailFrame.ScrollFrame:GetName()
    _G[scrollName.."Top"]:Hide()
    _G[scrollName.."Bottom"]:Hide()
    _G[scrollName.."Middle"]:Hide()

    local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton
    ShowMapButton.Texture:Hide()
    ShowMapButton.Highlight:SetTexture("")
    ShowMapButton.Highlight:SetTexture("")

    ShowMapButton.Text:ClearAllPoints()
    ShowMapButton.Text:SetPoint("CENTER", 1, 0)
    ShowMapButton:SetFontString(ShowMapButton.Text)
    ShowMapButton:SetNormalFontObject("GameFontNormal")
    ShowMapButton:SetHighlightFontObject("GameFontHighlight")
    ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)

    ShowMapButton:ClearAllPoints()
    ShowMapButton:SetPoint("TOPRIGHT", -30, -5)
    Base.SetBackdrop(ShowMapButton, Color.button)
    Base.SetHighlight(ShowMapButton, "backdrop")

    Skin.UIPanelButtonTemplate(QuestLogPopupDetailFrame.AbandonButton)
    QuestLogPopupDetailFrame.AbandonButton:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.UIPanelButtonTemplate(QuestLogPopupDetailFrame.TrackButton)
    QuestLogPopupDetailFrame.TrackButton:SetPoint("BOTTOMRIGHT", -5, 5)
    Skin.UIPanelButtonTemplate(QuestLogPopupDetailFrame.ShareButton)
    QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
    QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)


    -------------------
    -- QuestMapFrame --
    -------------------
    _G.hooksecurefunc("QuestLogQuests_Update", Hook.QuestLogQuests_Update)

    local QuestMapFrame = _G.QuestMapFrame
    QuestMapFrame.VerticalSeparator:Hide()

    local QuestsFrame = QuestMapFrame.QuestsFrame
    QuestsFrame.Background:Hide()

    do -- WarCampaignHeader
        local WarCampaignHeader = QuestsFrame.Contents.WarCampaignHeader

        local clipFrame = _G.CreateFrame("Frame", nil, WarCampaignHeader)
        clipFrame:SetPoint("TOPLEFT")
        clipFrame:SetPoint("BOTTOMRIGHT", 0, 9)
        clipFrame:SetClipsChildren(true)

        local overlay = clipFrame:CreateTexture(nil, "OVERLAY")
        overlay:SetSize(142, 142)
        overlay:SetPoint("TOPRIGHT", 16, 38)
        overlay:SetAlpha(0.2)
        overlay:SetDesaturated(true)
        WarCampaignHeader._auroraOverlay = overlay

        WarCampaignHeader.Background:SetAllPoints(clipFrame)
        WarCampaignHeader.HighlightTexture:SetAllPoints(clipFrame)
        WarCampaignHeader.HighlightTexture:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)
    end

    QuestsFrame.Contents.Separator:SetSize(260, 10)

    do -- StoryHeader
        local StoryHeader = QuestsFrame.Contents.StoryHeader
        StoryHeader.Text:SetPoint("TOPLEFT", 18, -25)

        local mask = StoryHeader:CreateMaskTexture(nil, "BACKGROUND")
        mask:SetTexture([[Interface/SpellBook/UI-SpellbookPanel-Tab-Highlight]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetPoint("LEFT", -54, 0)
        mask:SetPoint("RIGHT", 38, 0)
        mask:SetPoint("TOP", StoryHeader.Text, 0, 52)
        mask:SetPoint("BOTTOM", StoryHeader.Progress, 0, -58)

        StoryHeader.Background:AddMaskTexture(mask)
        StoryHeader.Background:SetColorTexture(Color.button:GetRGB())

        StoryHeader.HighlightTexture:AddMaskTexture(mask)
        StoryHeader.HighlightTexture:SetAllPoints(StoryHeader.Background)
        StoryHeader.HighlightTexture:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)
    end

    QuestsFrame.DetailFrame.BottomDetail:Hide()
    QuestsFrame.DetailFrame.TopDetail:Hide()

    Skin.UIPanelScrollBarTemplate(QuestsFrame.ScrollBar)
    scrollName = QuestsFrame.ScrollBar:GetName()
    _G[scrollName.."Top"]:Hide()
    _G[scrollName.."Bottom"]:Hide()
    _G[scrollName.."Middle"]:Hide()
    QuestsFrame.ScrollBar:SetPoint("TOPLEFT", QuestsFrame, "TOPRIGHT", 2, -17)
    QuestsFrame.ScrollBar:SetPoint("BOTTOMLEFT", QuestsFrame, "BOTTOMRIGHT", 2, 17)

    Base.SetBackdrop(QuestsFrame.StoryTooltip)
    Skin.WarCampaignTooltipTemplate(QuestsFrame.WarCampaignTooltip)


    local DetailsFrame = QuestMapFrame.DetailsFrame
    local bg, overlay, _, tile = DetailsFrame:GetRegions()
    bg:Hide()
    overlay:Hide()
    tile:Hide()

    Skin.UIPanelButtonTemplate(DetailsFrame.BackButton)

    DetailsFrame.RewardsFrame.Background:Hide()
    select(2, DetailsFrame.RewardsFrame:GetRegions()):Hide()

    Skin.MinimalScrollBarTemplate(DetailsFrame.ScrollFrame.ScrollBar)

    bg, tile = DetailsFrame.CompleteQuestFrame:GetRegions()
    bg:Hide()
    tile:Hide()
    Skin.UIPanelButtonTemplate(DetailsFrame.CompleteQuestFrame.CompleteButton)
    local left, right = select(6, DetailsFrame.CompleteQuestFrame.CompleteButton:GetRegions())
    left:Hide()
    right:Hide()

    Skin.UIPanelButtonTemplate(DetailsFrame.AbandonButton)
    Skin.UIPanelButtonTemplate(DetailsFrame.ShareButton)
    left, right = select(6, DetailsFrame.ShareButton:GetRegions())
    left:Hide()
    right:Hide()
    Skin.UIPanelButtonTemplate(DetailsFrame.TrackButton)
end
