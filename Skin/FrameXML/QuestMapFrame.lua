local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\QuestMapFrame.lua ]]
    -- /dump C_CampaignInfo.GetCampaignInfo(C_CampaignInfo.GetCurrentCampaignID())
    local uiTextureKits = {
        Default = {color = Color.button, overlay = ""},
        alliance = {color = private.FACTION_COLORS.Alliance, texture = [[Interface\Timer\Alliance-Logo]]},
        horde = {color = private.FACTION_COLORS.Horde, texture = [[Interface\Timer\Horde-Logo]]},

        Kyrian = {color = private.COVENANT_COLORS.Kyrian, atlas = "ShadowlandsMissionsLandingPage-Background-Kyrian"},
        Necrolord = {color = private.COVENANT_COLORS.Necrolord, atlas = "ShadowlandsMissionsLandingPage-Background-Necrolord"},
        Fey = {color = private.COVENANT_COLORS.NightFae, atlas = "ShadowlandsMissionsLandingPage-Background-NightFae"},
        Venthyr = {color = private.COVENANT_COLORS.Venthyr, atlas = "ShadowlandsMissionsLandingPage-Background-Venthyr"},
    }

    if private.isPatch then
        uiTextureKits.Oribos = uiTextureKits[_G.UnitFactionGroup("player"):lower()]
        uiTextureKits.Bastion = uiTextureKits.Kyrian
        uiTextureKits.Maldraxxus = uiTextureKits.Necrolord
        uiTextureKits.Ardenweald = uiTextureKits.Fey
        uiTextureKits.Revendreth = uiTextureKits.Venthyr
    else
        uiTextureKits[261] = uiTextureKits.alliance
        uiTextureKits[262] = uiTextureKits.horde
    end
    function Hook.QuestLogQuests_Update(poiTable)
        if private.isPatch then
            local kit, overlay
            for campaignHeader in _G.QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
                local campaign = campaignHeader:GetCampaign()
                if campaign then
                    kit = uiTextureKits[campaign.uiTextureKit]
                    if not kit then
                        kit = uiTextureKits.Default
                        private.debug("missing campaign header", campaign.uiTextureKit)
                    end
                    campaignHeader.Background:SetTexture("")
                    campaignHeader._auroraBG:SetColorTexture(kit.color:GetRGB())

                    overlay = campaignHeader._auroraOverlay
                    overlay:SetPoint("CENTER", campaignHeader._auroraBG, "RIGHT", -50, -5)
                    if kit.texture then
                        overlay:SetTexture(kit.texture)
                        overlay:SetSize(130, 130)

                        overlay:SetBlendMode("ADD")
                        overlay:SetVertexColor(1, 1, 1)
                    else
                        overlay:SetAtlas(kit.atlas)
                        overlay:SetSize(100, 116)

                        overlay:SetBlendMode("BLEND")
                        overlay:SetVertexColor(0, 0, 0)
                    end
                    campaignHeader.HighlightTexture:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)
                end
            end
        else
            local warCampaignID = _G.C_CampaignInfo.GetCurrentCampaignID()
            if warCampaignID then
                local warCampaignInfo = _G.C_CampaignInfo.GetCampaignInfo(warCampaignID)
                if warCampaignInfo and warCampaignInfo.visibilityConditionMatched then
                    local kit = uiTextureKits[warCampaignInfo.uiTextureKitID] or uiTextureKits.Default
                    local campaignHeader = _G.QuestScrollFrame.Contents.WarCampaignHeader
                    campaignHeader.Background:SetColorTexture(kit.color:GetRGB())
                    campaignHeader._auroraOverlay:SetTexture(kit.texture)
                end
            end
        end

        local separator = _G.QuestScrollFrame.Contents.Separator
        if separator:IsShown() then
            separator.Divider:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, 0.5)
            separator.Divider:SetSize(200, 1)
        end
    end

    local sessionCommandToButtonAtlas = {
        [_G.Enum.QuestSessionCommand.Start] = "QuestSharing-DialogIcon",
        [_G.Enum.QuestSessionCommand.Stop] = "QuestSharing-Stop-DialogIcon",
    }
    Hook.QuestSessionManagementMixin = {}
    function Hook.QuestSessionManagementMixin:UpdateExecuteCommandAtlases(command)
        self.ExecuteSessionCommand:SetNormalTexture("")
        self.ExecuteSessionCommand:SetPushedTexture("")
        self.ExecuteSessionCommand:SetDisabledTexture("")

        local atlas = sessionCommandToButtonAtlas[command];
        if atlas then
            self.ExecuteSessionCommand._auroraIcon:SetAtlas(atlas)
        end
    end
end

do --[[ FrameXML\QuestMapFrame.xml ]]
    function Skin.QuestLogHeaderTemplate(Button)
        Skin.ExpandOrCollapse(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        })
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
    if private.isPatch then
        QuestMapFrame.Background:Hide()
    end
    QuestMapFrame.VerticalSeparator:Hide()


    local QuestsFrame = QuestMapFrame.QuestsFrame
    Util.Mixin(QuestsFrame.titleFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(QuestsFrame.objectiveFramePool, Hook.ObjectPoolMixin)
    Util.Mixin(QuestsFrame.headerFramePool, Hook.ObjectPoolMixin)
    if private.isPatch then
        Util.Mixin(QuestsFrame.campaignHeaderFramePool, Hook.ObjectPoolMixin)
    end

    if private.isPatch then
        QuestsFrame.Contents.Separator:SetSize(260, 10)
        QuestsFrame.Contents.Separator.Divider:SetPoint("TOP", 0, 0)
    else
        QuestsFrame.Background:Hide()

        -- WarCampaignHeader
        local WarCampaignHeader = QuestsFrame.Contents.WarCampaignHeader

        local clipFrame = _G.CreateFrame("Frame", nil, WarCampaignHeader)
        clipFrame:SetPoint("TOPLEFT", 6, 0)
        clipFrame:SetPoint("TOPRIGHT", -5, 0)
        clipFrame:SetHeight(47)
        clipFrame:SetClipsChildren(true)

        local overlay = clipFrame:CreateTexture(nil, "OVERLAY")
        overlay:SetDesaturated(true)
        overlay:SetBlendMode("ADD")
        overlay:SetAlpha(0.3)
        overlay:ClearAllPoints()
        overlay:SetPoint("CENTER", WarCampaignHeader, "RIGHT", -50, -5)
        overlay:SetSize(130, 130)
        WarCampaignHeader._auroraOverlay = overlay

        WarCampaignHeader.Background:SetAllPoints(clipFrame)
        WarCampaignHeader.HighlightTexture:SetAllPoints(clipFrame)
        WarCampaignHeader.HighlightTexture:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)

        QuestsFrame.Contents.Separator:SetSize(260, 10)
    end

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
    local _, top, bottom, middle = QuestsFrame.ScrollBar:GetRegions()
    top:Hide()
    bottom:Hide()
    middle:Hide()
    QuestsFrame.ScrollBar:SetPoint("TOPLEFT", QuestsFrame, "TOPRIGHT", 2, -17)
    QuestsFrame.ScrollBar:SetPoint("BOTTOMLEFT", QuestsFrame, "BOTTOMRIGHT", 2, 17)

    Base.SetBackdrop(QuestsFrame.StoryTooltip)
    if not private.isPatch then
        Skin.CampaignTooltipTemplate(QuestsFrame.WarCampaignTooltip)
    end


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

    do
        local QuestSessionManagement = QuestMapFrame.QuestSessionManagement
        Util.Mixin(QuestSessionManagement, Hook.QuestSessionManagementMixin)

        local ExecuteSessionCommand = QuestSessionManagement.ExecuteSessionCommand
        Skin.FrameTypeButton(ExecuteSessionCommand)
        local icon = ExecuteSessionCommand:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", 0, 0)
        icon:SetPoint("BOTTOMRIGHT", 0, 0)
        ExecuteSessionCommand._auroraIcon = icon


        QuestSessionManagement.BG:SetColorTexture(Color.frame.r, Color.frame.g, Color.frame.b, 0.5)
    end
end
