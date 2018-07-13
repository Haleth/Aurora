-- Blizzard_Communities.toc
local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_Communities.lua ]]
    do --[[ CommunitiesList ]]
        local CommunitiesListEntryMixin = {}
        function CommunitiesListEntryMixin.SetClubInfo(self, clubInfo, isInvitation, isTicket)
            if clubInfo then
                local isGuild = clubInfo.clubType == _G.Enum.ClubType.Guild
                if isGuild then
                    self.Selection:SetColorTexture(Color.green.r, Color.green.g, Color.green.b, Color.frame.a)
                else
                    self.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
                end

                self.Name:SetPoint("LEFT", self._iconBorder, "RIGHT", 10, 0)
                self.Icon:ClearAllPoints()
                self.Icon:SetPoint("CENTER", self._iconBorder)

                if not isInvitation and not isGuild and not isTicket then
                    if clubInfo.clubType == _G.Enum.ClubType.BattleNet then
                        self._iconBorder:SetColorTexture(_G.FRIENDS_BNET_BACKGROUND_COLOR:GetRGB())
                    else
                        self._iconBorder:SetColorTexture(_G.FRIENDS_WOW_BACKGROUND_COLOR:GetRGB())
                    end
                    self._iconBorder:Show()
                else
                    self._iconBorder:Hide()
                end
            end
        end
        function CommunitiesListEntryMixin.SetAddCommunity(self)
            self.Name:SetPoint("LEFT", self._iconBorder, "RIGHT", 10, 0)
            self.Icon:ClearAllPoints()
            self.Icon:SetPoint("CENTER", self._iconBorder)
            self._iconBorder:Show()
            self._iconBorder:SetColorTexture(Color.black:GetRGB())
        end
        Hook.CommunitiesListEntryMixin = CommunitiesListEntryMixin
    end
    do --[[ CommunitiesSettings ]]
        local CommunitiesSettingsDialogMixin = {}
        function CommunitiesSettingsDialogMixin.SetClubId(self, clubId)
            local clubInfo = _G.C_Club.GetClubInfo(clubId)
            if clubInfo then
                if clubInfo.clubType == _G.Enum.ClubType.BattleNet then
                    self._iconBorder:SetColorTexture(_G.FRIENDS_BNET_BACKGROUND_COLOR:GetRGB())
                else
                    self._iconBorder:SetColorTexture(_G.FRIENDS_WOW_BACKGROUND_COLOR:GetRGB())
                end
            end
        end
        Hook.CommunitiesSettingsDialogMixin = CommunitiesSettingsDialogMixin
    end
    do --[[ CommunitiesTicketManagerDialog ]]
        local CommunitiesTicketManagerDialogMixin = {}
        function CommunitiesTicketManagerDialogMixin.SetClubId(self, clubId)
            local clubInfo = _G.C_Club.GetClubInfo(clubId)
            if clubInfo then
                if clubInfo.clubType == _G.Enum.ClubType.BattleNet then
                    self._iconBorder:SetColorTexture(_G.FRIENDS_BNET_BACKGROUND_COLOR:GetRGB())
                else
                    self._iconBorder:SetColorTexture(_G.FRIENDS_WOW_BACKGROUND_COLOR:GetRGB())
                end
            end
        end
        Hook.CommunitiesTicketManagerDialogMixin = CommunitiesTicketManagerDialogMixin
    end
end

do --[[ AddOns\Blizzard_Communities.xml ]]
    do --[[ CommunitiesList ]]
        function Skin.CommunitiesListEntryTemplate(Button)
            local bd = _G.CreateFrame("Frame", nil, Button)
            Base.SetBackdrop(bd, Color.button)
            bd:SetBackdropBorderColor(Color.frame, 1)
            bd:SetFrameLevel(Button:GetFrameLevel())
            bd:SetPoint("TOPLEFT", 7, -16)
            bd:SetPoint("BOTTOMRIGHT", -10, 12)

            Button.Background:Hide()
            Button.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
            Button.Selection:SetAllPoints(bd)

            Button.Icon:RemoveMaskTexture(Button.CircleMask)
            Button._iconBorder = Base.CropIcon(Button.Icon, Button)
            Button._iconBorder:SetPoint("TOPLEFT", bd)
            Button._iconBorder:SetPoint("BOTTOMRIGHT", bd, "BOTTOMLEFT", 40, 0)
            Button.IconRing:SetAlpha(0)

            local highlight = Button:GetHighlightTexture()
            highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
            highlight:SetAllPoints(bd)
        end
        function Skin.CommunitiesListFrameTemplate(Frame)
            Frame.Bg:Hide()
            Frame.TopFiligree:Hide()
            Frame.BottomFiligree:Hide()

            Skin.HybridScrollBarTemplate(Frame.ListScrollFrame.ScrollBar)
            Frame.ListScrollFrame.ScrollBar.Background:Hide()
            Frame.FilligreeOverlay:Hide()
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
        function Skin.CommunitiesListDropDownMenuTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
    end
    do --[[ CommunitiesMemberList ]]
        function Skin.CommunitiesMemberListFrameTemplate(Frame)
            Skin.UICheckButtonTemplate(Frame.ShowOfflineButton)
            Skin.ColumnDisplayTemplate(Frame.ColumnDisplay)
            Frame.ColumnDisplay.InsetBorderTopLeft:Hide()
            Frame.ColumnDisplay.InsetBorderTopRight:Hide()
            Frame.ColumnDisplay.InsetBorderBottomLeft:Hide()
            Frame.ColumnDisplay.InsetBorderTop:Hide()
            Frame.ColumnDisplay.InsetBorderLeft:Hide()

            Skin.HybridScrollBarTemplate(Frame.ListScrollFrame.scrollBar)
            Frame.ListScrollFrame.scrollBar.Background:Hide()
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
        function Skin.GuildMemberListDropDownMenuTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
    end
    do --[[ CommunitiesChatFrame ]]
        function Skin.CommunitiesChatTemplate(Frame)
            local ScrollBar = Frame.MessageFrame.ScrollBar
            Skin.HybridScrollBarBackgroundTemplate(Frame.MessageFrame.ScrollBar)

            ScrollBar.ScrollUp:SetPoint("BOTTOM", ScrollBar, "TOP")
            Skin.UIPanelScrollUpButtonTemplate(ScrollBar.ScrollUp)

            ScrollBar.ScrollDown:SetPoint("TOP", ScrollBar, "BOTTOM")
            Skin.UIPanelScrollDownButtonTemplate(ScrollBar.ScrollDown)

            local _, JumpToUnreadButton = Frame:GetChildren()
            Skin.UIPanelButtonTemplate(JumpToUnreadButton)
            --Skin.UIPanelButtonTemplate(Frame.JumpToUnreadButton)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
        function Skin.CommunitiesChatEditBoxTemplate(EditBox)
            EditBox.Left:Hide()
            EditBox.Right:Hide()
            EditBox.Mid:Hide()

            local bd = _G.CreateFrame("Frame", nil, EditBox)
            bd:SetPoint("TOPLEFT", -5, -5)
            bd:SetPoint("BOTTOMRIGHT", 5, 5)
            bd:SetFrameLevel(EditBox:GetFrameLevel())
            Base.SetBackdrop(bd, Color.frame, 0.5)
        end
    end
    do --[[ CommunitiesInvitationFrame ]]
        function Skin.CommunitiesInvitationFrameTemplate(Frame)
        end
        function Skin.CommunitiesTicketFrameTemplate(Frame)
            Skin.CommunitiesInvitationFrameTemplate(Frame)
        end
        function Skin.CommunitiesInviteButtonTemplate(Frame)
            Skin.UIPanelDynamicResizeButtonTemplate(Frame)
        end
    end
    do --[[ CommunitiesGuildFinderFrame ]]
        function Skin.CommunitiesGuildFinderFrameTemplate(Frame)
            Skin.UIPanelButtonTemplate(Frame.FindAGuildButton)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
    end
    do --[[ CommunitiesStreams ]]
        function Skin.CommunitiesNotificationSettingsStreamEntryCheckButtonTemplate(CheckButton)
            Skin.UIRadioButtonTemplate(CheckButton)
        end
        function Skin.CommunitiesNotificationSettingsStreamEntryTemplate(Button)
            Skin.CommunitiesNotificationSettingsStreamEntryCheckButtonTemplate(Button.HideNotificationsButton)
            Skin.CommunitiesNotificationSettingsStreamEntryCheckButtonTemplate(Button.ShowNotificationsButton)
        end
        function Skin.CommunitiesMassNotificationsSettingsButtonTemplate(Button)
            Skin.UIMenuButtonStretchTemplate(Button)
        end
        function Skin.CommunitiesEditStreamDialogTemplate(Frame)
            Base.SetBackdrop(Frame)

            Skin.InputBoxTemplate(Frame.NameEdit)
            Skin.InputScrollFrameTemplate(Frame.Description)
            Skin.UICheckButtonTemplate(Frame.TypeCheckBox)
            Skin.UIPanelButtonTemplate(Frame.Accept)
            Skin.UIPanelButtonTemplate(Frame.Delete)
            Skin.UIPanelButtonTemplate(Frame.Cancel)
        end
        function Skin.CommunitiesNotificationSettingsDialogTemplate(Frame)
            _G.hooksecurefunc(Frame.buttonPool, "Acquire", Hook.ObjectPoolMixin_Acquire)

            Skin.SelectionFrameTemplate(Frame)
            Frame.BG:Hide()

            Skin.CommunitiesListDropDownMenuTemplate(Frame.CommunitiesListDropDownMenu)
            Skin.UIPanelStretchableArtScrollBarTemplate(Frame.ScrollFrame.ScrollBar)
            Skin.UICheckButtonTemplate(Frame.ScrollFrame.Child.QuickJoinButton)
            Skin.CommunitiesMassNotificationsSettingsButtonTemplate(Frame.ScrollFrame.Child.NoneButton)
            Skin.CommunitiesMassNotificationsSettingsButtonTemplate(Frame.ScrollFrame.Child.AllButton)
        end
        function Skin.AddToChatButtonTemplate(Frame)
            Skin.UIMenuButtonStretchTemplate(Frame)
        end
        function Skin.StreamDropDownMenuTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
    end
    do --[[ CommunitiesTabs ]]
        function Skin.CommunitiesFrameTabTemplate(CheckButton)
            CheckButton:GetRegions():Hide()
            Base.CropIcon(CheckButton.Icon, CheckButton)
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
    end
    do --[[ CommunitiesSettings ]]
        function Skin.CommunitiesSettingsButtonTemplate(Button)
            Skin.UIPanelDynamicResizeButtonTemplate(Button)
        end
    end
    do --[[ CommunitiesTicketManagerDialog ]]
        function Skin.CommunitiesTicketEntryTemplate(Button)
            Skin.UIMenuButtonStretchTemplate(Button.CopyLinkButton)
            Button.CopyLinkButton.Background:SetAllPoints()
            Button.CopyLinkButton.Background:SetAlpha(0.6)
            Skin.UIMenuButtonStretchTemplate(Button.RevokeButton)

            local highlight = Button:GetHighlightTexture()
            highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, 0.3)
        end
        function Skin.CommunitiesTicketManagerScrollFrameTemplate(Frame)
            Frame.ArtOverlay.TopLeft:ClearAllPoints()
            Frame.ArtOverlay.TopRight:ClearAllPoints()

            Frame.ListScrollFrame.Background:Hide()
            Skin.HybridScrollBarTemplate(Frame.ListScrollFrame.scrollBar)
            Frame.ListScrollFrame.scrollBar.Background:Hide()
            Skin.ColumnDisplayTemplate(Frame.ColumnDisplay)
            Hook.ObjectPoolMixin_Acquire(Frame.ColumnDisplay.columnHeaders)
            Frame.ColumnDisplay.InsetBorderTopLeft:ClearAllPoints()
            Frame.ColumnDisplay.InsetBorderTopRight:ClearAllPoints()
            Frame.ColumnDisplay.InsetBorderBottomLeft:ClearAllPoints()
        end
    end
    do --[[ GuildRewards ]]
        function Skin.GuildAchievementPointDisplayTemplate(Frame)
        end
        function Skin.GuildRewardsTutorialButtonTemplate(Button)
        end
        function Skin.CommunitiesGuildProgressBarTemplate(Frame)
            Frame.Left:Hide()
            Frame.Right:Hide()
            Frame.Middle:Hide()
            Frame.BG:Hide()

            local bg = _G.CreateFrame("Frame", nil, Frame)
            bg:SetPoint("TOPLEFT", 0, -3)
            bg:SetPoint("BOTTOMRIGHT", 0, 1)
            bg:SetFrameLevel(Frame:GetFrameLevel())
            Base.SetBackdrop(bg, Color.frame)
            bg:SetBackdropBorderColor(Color.button)

            Base.SetTexture(Frame.Progress, "gradientUp")
            Frame.Shadow:Hide()
        end
        function Skin.CommunitiesGuildRewardsButtonTemplate(Button)
            Skin.SmallMoneyFrameTemplate(Button.Money)
            Base.CropIcon(Button.Icon, Button)

            Button:SetNormalTexture("")
            Button:SetHighlightTexture("")
        end
        function Skin.CommunitiesGuildRewardsFrameTemplate(Frame)
            Frame.Bg:Hide()
            local _, scrollBar = Frame.RewardsContainer:GetChildren()
            Skin.HybridScrollBarTemplate(scrollBar)
        end
    end
    do --[[ GuildPerks ]]
        function Skin.CommunitiesGuildPerksButtonTemplate(Button)
            local left, right, mid, divider = Button:GetRegions()
            left:Hide()
            right:Hide()
            mid:Hide()
            divider:Hide()
            Base.CropIcon(Button.Icon, Button)
        end
        function Skin.CommunitiesGuildPerksFrameTemplate(Frame)
            Frame:GetRegions():Hide()
            Skin.MinimalHybridScrollFrameTemplate(Frame.Container)
        end
    end
    do --[[ GuildInfo ]]
        function Skin.CommunitiesGuildInfoFrameTemplate(Frame)
            local _, bar1, bar2, bar3, bar4, bg, header1, header2, header3, challengesBG = Frame:GetRegions()
            bar1:Hide()
            bar2:Hide()
            bar3:Hide()
            bar4:Hide()
            bg:Hide()
            header1:Hide()
            header2:Hide()
            header3:Hide()
            challengesBG:Hide()

            Frame.MOTDScrollFrame:SetWidth(246)
            Frame.MOTDScrollFrame.MOTD:SetWidth(246)
            Skin.MinimalScrollFrameTemplate(Frame.MOTDScrollFrame)
            Skin.MinimalScrollFrameTemplate(Frame.DetailsFrame)
        end
    end
    do --[[ GuildNews ]]
        function Skin.CommunitiesGuildNewsBossModelTemplate(PlayerModel)
            local modelBackground = _G.CreateFrame("Frame", nil, PlayerModel)
            modelBackground:SetPoint("TOPLEFT", -1, 1)
            modelBackground:SetPoint("BOTTOMRIGHT", 1, -2)
            modelBackground:SetFrameLevel(0)
            Base.SetBackdrop(modelBackground)

            PlayerModel.Bg:Hide()
            PlayerModel.ShadowOverlay:Hide()
            PlayerModel.TopBg:Hide()

            PlayerModel.BorderBottomLeft:Hide()
            PlayerModel.BorderBottomRight:Hide()
            PlayerModel.BorderTop:Hide()
            PlayerModel.BorderBottom:Hide()
            PlayerModel.BorderLeft:Hide()
            PlayerModel.BorderRight:Hide()

            PlayerModel.Nameplate:SetAlpha(0)
            PlayerModel.BossName:SetPoint("TOPLEFT", modelBackground, "BOTTOMLEFT")
            PlayerModel.BossName:SetPoint("BOTTOMRIGHT", PlayerModel.TextFrame, "TOPRIGHT")

            PlayerModel.CornerTopLeft:Hide()
            PlayerModel.CornerTopRight:Hide()
            PlayerModel.CornerBottomLeft:Hide()
            PlayerModel.CornerBottomRight:Hide()

            local TextFrame = PlayerModel.TextFrame
            Base.SetBackdrop(TextFrame)
            TextFrame:SetPoint("TOPLEFT", PlayerModel.Nameplate, "BOTTOMLEFT", -1, 12)
            TextFrame:SetWidth(200)
            TextFrame.TextFrameBg:Hide()

            TextFrame.BorderBottomLeft:Hide()
            TextFrame.BorderBottomRight:Hide()
            TextFrame.BorderBottom:Hide()
            TextFrame.BorderLeft:Hide()
            TextFrame.BorderRight:Hide()
        end
        function Skin.CommunitiesGuildNewsFrameTemplate(Frame)
            Frame:GetRegions():Hide()
            Frame.Header:Hide()

            Skin.HybridScrollBarTemplate(Frame.Container.ScrollBar)
            Skin.CommunitiesGuildNewsBossModelTemplate(Frame.BossModel)
        end
    end
    do --[[ GuildRoster ]]
        function Skin.CommunitiesGuildMemberDetailFrameTemplate(Frame)
            Base.SetBackdrop(Frame)
            Frame.BackBackground:Hide()
            select(12, Frame:GetRegions()):Hide()
            Frame.Corner:Hide()

            Skin.UIPanelCloseButton(Frame.CloseButton)
            Frame.CloseButton:SetPoint("TOPRIGHT", -5, -5)
            Skin.UIPanelButtonTemplate(Frame.RemoveButton)
            Skin.UIPanelButtonTemplate(Frame.GroupInviteButton)
            Skin.UIDropDownMenuTemplate(Frame.RankDropdown)

            Base.SetBackdrop(Frame.NoteBackground)
            Base.SetBackdrop(Frame.OfficerNoteBackground)
        end
    end
    do --[[ CommunitiesFrame ]]
        function Skin.GuildBenefitsFrameTemplate(Frame)
            Skin.CommunitiesGuildPerksFrameTemplate(Frame.Perks)
            Skin.CommunitiesGuildRewardsFrameTemplate(Frame.Rewards)
            Skin.GuildRewardsTutorialButtonTemplate(Frame.GuildRewardsTutorialButton)
            Skin.GuildAchievementPointDisplayTemplate(Frame.GuildAchievementPointDisplay)
            Skin.CommunitiesGuildProgressBarTemplate(Frame.FactionFrame.Bar)

            Frame.InsetBorderTopLeft:Hide()
            Frame.InsetBorderTopRight:Hide()
            Frame.InsetBorderBottomLeft:Hide()
            Frame.InsetBorderBottomRight:Hide()
            Frame.InsetBorderLeft:Hide()
            Frame.InsetBorderRight:Hide()
            Frame.InsetBorderTopLeft2:Hide()
            Frame.InsetBorderBottomLeft2:Hide()
            Frame.InsetBorderLeft2:Hide()
        end
        function Skin.GuildDetailsFrameTemplate(Frame)
            Skin.CommunitiesGuildInfoFrameTemplate(Frame.Info)
            Skin.CommunitiesGuildNewsFrameTemplate(Frame.News)

            Frame.InsetBorderTopLeft:Hide()
            Frame.InsetBorderTopRight:Hide()
            Frame.InsetBorderBottomLeft:Hide()
            Frame.InsetBorderBottomRight:Hide()
            Frame.InsetBorderLeft:Hide()
            Frame.InsetBorderRight:Hide()
            Frame.InsetBorderTopLeft2:Hide()
            Frame.InsetBorderBottomLeft2:Hide()
            Frame.InsetBorderLeft2:Hide()
        end
        function Skin.CommunitiesControlFrameTemplate(Frame)
            Skin.CommunitiesSettingsButtonTemplate(Frame.CommunitiesSettingsButton)
            Skin.UIPanelButtonTemplate(Frame.GuildControlButton)
            Skin.UIPanelButtonTemplate(Frame.GuildRecruitmentButton)
        end
    end
end

function private.AddOns.Blizzard_Communities()
    ----====####$$$$%%%%%$$$$####====----
    --         CommunitiesList         --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc(_G.CommunitiesListEntryMixin, "SetClubInfo", Hook.CommunitiesListEntryMixin.SetClubInfo)
    _G.hooksecurefunc(_G.CommunitiesListEntryMixin, "SetAddCommunity", Hook.CommunitiesListEntryMixin.SetAddCommunity)

    ----====####$$$$%%%%%$$$$####====----
    --      CommunitiesMemberList      --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --      CommunitiesChatFrame      --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --   CommunitiesInvitationFrame   --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --   CommunitiesGuildFinderFrame   --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --       CommunitiesStreams       --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --  CommunitiesAvatarPickerDialog  --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --  CommunitiesAddDialogInsecure  --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --      CommunitiesAddDialog      --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --  CommunitiesAddDialogOutbound  --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --         CommunitiesTabs         --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --       CommunitiesSettings       --
    ----====####$$$$%%%%%$$$$####====----
    local CommunitiesSettingsDialog = _G.CommunitiesSettingsDialog
    _G.hooksecurefunc(CommunitiesSettingsDialog, "SetClubId", Hook.CommunitiesSettingsDialogMixin.SetClubId)

    Base.SetBackdrop(CommunitiesSettingsDialog)

    CommunitiesSettingsDialog.IconPreview:RemoveMaskTexture(CommunitiesSettingsDialog.CircleMask)
    CommunitiesSettingsDialog._iconBorder = Base.CropIcon(CommunitiesSettingsDialog.IconPreview, CommunitiesSettingsDialog)
    CommunitiesSettingsDialog.IconPreviewRing:SetAlpha(0)

    Skin.InputBoxTemplate(CommunitiesSettingsDialog.NameEdit)
    Skin.InputBoxTemplate(CommunitiesSettingsDialog.ShortNameEdit)
    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.ChangeAvatarButton)
    Skin.InputScrollFrameTemplate(CommunitiesSettingsDialog.MessageOfTheDay)
    Skin.InputScrollFrameTemplate(CommunitiesSettingsDialog.Description)
    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.Delete)
    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.Accept)
    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.Cancel)

    ----====####$$$$%%%%$$$$####====----
    -- CommunitiesTicketManagerDialog --
    ----====####$$$$%%%%$$$$####====----
    local CommunitiesTicketManagerDialog = _G.CommunitiesTicketManagerDialog
    _G.hooksecurefunc(CommunitiesTicketManagerDialog, "SetClubId", Hook.CommunitiesTicketManagerDialogMixin.SetClubId)

    CommunitiesTicketManagerDialog.Icon:RemoveMaskTexture(CommunitiesTicketManagerDialog.CircleMask)
    CommunitiesTicketManagerDialog._iconBorder = Base.CropIcon(CommunitiesTicketManagerDialog.Icon, CommunitiesTicketManagerDialog)
    CommunitiesTicketManagerDialog.IconRing:SetAlpha(0)

    Base.SetBackdrop(CommunitiesTicketManagerDialog)
    CommunitiesTicketManagerDialog.TopLeft:ClearAllPoints()
    CommunitiesTicketManagerDialog.TopRight:ClearAllPoints()
    CommunitiesTicketManagerDialog.BottomLeft:ClearAllPoints()
    CommunitiesTicketManagerDialog.BottomRight:ClearAllPoints()
    CommunitiesTicketManagerDialog.Background:Hide()

    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.LinkToChat)
    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.Copy)
    Skin.UIDropDownMenuTemplate(CommunitiesTicketManagerDialog.ExpiresDropDownMenu)
    Skin.UIDropDownMenuTemplate(CommunitiesTicketManagerDialog.UsesDropDownMenu)
    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.GenerateLinkButton)
    Skin.UIPanelSquareButton(CommunitiesTicketManagerDialog.MaximizeButton)
    Skin.CommunitiesTicketManagerScrollFrameTemplate(CommunitiesTicketManagerDialog.InviteManager)
    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.Close)

    ----====####$$$$%%%%$$$$####====----
    --          GuildRewards          --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --           GuildPerks           --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --            GuildInfo            --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --            GuildNews            --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --           GuildRoster           --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --        CommunitiesFrame        --
    ----====####$$$$%%%%$$$$####====----
    local CommunitiesFrame = _G.CommunitiesFrame
    Skin.ButtonFrameTemplate(CommunitiesFrame)
    CommunitiesFrame.PortraitOverlay:SetAlpha(0)

    Skin.MaximizeMinimizeButtonFrameTemplate(CommunitiesFrame.MaximizeMinimizeFrame)
    CommunitiesFrame.MaximizeMinimizeFrame:GetRegions():Hide()
    CommunitiesFrame.MaximizeMinimizeFrame:SetPoint("RIGHT", CommunitiesFrame.CloseButton, "LEFT", -5, 0)
    Skin.CommunitiesListFrameTemplate(CommunitiesFrame.CommunitiesList)

    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.ChatTab)
    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.RosterTab)
    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.GuildBenefitsTab)
    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.GuildInfoTab)
    Util.PositionRelative("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 1, -40, 5, "Down", {
        CommunitiesFrame.ChatTab,
        CommunitiesFrame.RosterTab,
        CommunitiesFrame.GuildBenefitsTab,
        CommunitiesFrame.GuildInfoTab,
    })

    Skin.StreamDropDownMenuTemplate(CommunitiesFrame.StreamDropDownMenu)
    Skin.GuildMemberListDropDownMenuTemplate(CommunitiesFrame.GuildMemberListDropDownMenu)
    Skin.CommunitiesListDropDownMenuTemplate(CommunitiesFrame.CommunitiesListDropDownMenu)
    Skin.CommunitiesMemberListFrameTemplate(CommunitiesFrame.MemberList)
    Skin.CommunitiesChatTemplate(CommunitiesFrame.Chat)
    Skin.CommunitiesChatEditBoxTemplate(CommunitiesFrame.ChatEditBox)

    Skin.CommunitiesInvitationFrameTemplate(CommunitiesFrame.InvitationFrame)
    Skin.CommunitiesTicketFrameTemplate(CommunitiesFrame.TicketFrame)
    Skin.CommunitiesGuildFinderFrameTemplate(CommunitiesFrame.GuildFinderFrame)
    Skin.GuildBenefitsFrameTemplate(CommunitiesFrame.GuildBenefitsFrame)
    Skin.GuildDetailsFrameTemplate(CommunitiesFrame.GuildDetailsFrame)

    Skin.CommunitiesEditStreamDialogTemplate(CommunitiesFrame.EditStreamDialog)
    Skin.CommunitiesNotificationSettingsDialogTemplate(CommunitiesFrame.NotificationSettingsDialog)
    Skin.AddToChatButtonTemplate(CommunitiesFrame.AddToChatButton)
    Skin.CommunitiesInviteButtonTemplate(CommunitiesFrame.InviteButton)
    Skin.CommunitiesControlFrameTemplate(CommunitiesFrame.CommunitiesControlFrame)
    Skin.UIPanelButtonTemplate(CommunitiesFrame.GuildLogButton)
    Skin.CommunitiesGuildMemberDetailFrameTemplate(CommunitiesFrame.GuildMemberDetailFrame)

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
