local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_Communities.lua ]]
    do --[[ CommunitiesList ]]
        Hook.CommunitiesListEntryMixin = {}
        function Hook.CommunitiesListEntryMixin:SetClubInfo(clubInfo, isInvitation, isTicket, isInviteFromFinder)
            if clubInfo and self._iconBG then
                local isGuild = clubInfo.clubType == _G.Enum.ClubType.Guild
                if isGuild then
                    self.Selection:SetColorTexture(Color.green.r, Color.green.g, Color.green.b, Color.frame.a)
                else
                    self.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
                end

                self.CircleMask:Hide()
                Base.CropIcon(self.Icon)
                self.Icon:SetAllPoints(self._iconBG)
                self._iconBG:Hide()
            end
        end
        if private.isRetail then
            function Hook.CommunitiesListEntryMixin:SetFindCommunity()
                self.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)

                self.CircleMask:Hide()
                self.Icon:SetTexCoord(0, 1, 0, 1)
                self.Icon:ClearAllPoints()
                self.Icon:SetSize(34, 34)
                self.Icon:SetPoint("CENTER", self._iconBG)
                self.Name:SetPoint("LEFT", self._iconBG, "RIGHT", 11, 0)

                self._iconBG:Show()
                self._iconBG:SetColorTexture(Color.black:GetRGB())
            end
        end
        function Hook.CommunitiesListEntryMixin:SetAddCommunity()
            self.CircleMask:Hide()
            Base.CropIcon(self.Icon)
            self.Icon:ClearAllPoints()
            self.Icon:SetPoint("CENTER", self._iconBG)
            self.Name:SetPoint("LEFT", self._iconBG, "RIGHT", 11, 0)

            self._iconBG:Show()
            self._iconBG:SetColorTexture(Color.black:GetRGB())
        end
        if private.isRetail then
            function Hook.CommunitiesListEntryMixin:SetGuildFinder()
                self.Selection:SetColorTexture(Color.green.r, Color.green.g, Color.green.b, Color.frame.a)

                self.CircleMask:Hide()
                self.Icon:SetTexCoord(0, 1, 0, 1)
                self.Icon:ClearAllPoints()
                self.Icon:SetSize(40, 40)
                self.Icon:SetPoint("CENTER", self.GuildTabardBackground, 0, 4)

                self._iconBG:Hide()
            end
        end
    end
    do --[[ CommunitiesMemberList ]]
        Hook.CommunitiesMemberListEntryMixin = {}
        function Hook.CommunitiesMemberListEntryMixin:UpdatePresence()
            local memberInfo = self:GetMemberInfo();
            if memberInfo then
                if memberInfo.presence ~= _G.Enum.ClubMemberPresence.Offline then
                    if memberInfo.classID then
                        local classInfo = _G.C_CreatureInfo.GetClassInfo(memberInfo.classID);
                        local color = (classInfo and _G.CUSTOM_CLASS_COLORS[classInfo.classFile]) or _G.NORMAL_FONT_COLOR;
                        self.NameFrame.Name:SetTextColor(color.r, color.g, color.b);
                    else
                        self.NameFrame.Name:SetTextColor(_G.BATTLENET_FONT_COLOR:GetRGB());
                    end
                end
            end
        end
    end
    do --[[ CommunitiesSettings ]]
        Hook.CommunitiesSettingsDialogMixin = {}
        function Hook.CommunitiesSettingsDialogMixin:SetClubId(clubId)
            local clubInfo = _G.C_Club.GetClubInfo(clubId)
            if clubInfo then
                if clubInfo.clubType == _G.Enum.ClubType.BattleNet then
                    self._iconBorder:SetColorTexture(_G.FRIENDS_BNET_BACKGROUND_COLOR:GetRGB())
                else
                    self._iconBorder:SetColorTexture(_G.FRIENDS_WOW_BACKGROUND_COLOR:GetRGB())
                end
            end
        end
    end
    do --[[ CommunitiesTicketManagerDialog ]]
        Hook.CommunitiesTicketManagerDialogMixin = {}
        function Hook.CommunitiesTicketManagerDialogMixin:SetClubId(clubId)
            local clubInfo = _G.C_Club.GetClubInfo(clubId)
            if clubInfo then
                if clubInfo.clubType == _G.Enum.ClubType.BattleNet then
                    self._iconBorder:SetColorTexture(_G.FRIENDS_BNET_BACKGROUND_COLOR:GetRGB())
                else
                    self._iconBorder:SetColorTexture(_G.FRIENDS_WOW_BACKGROUND_COLOR:GetRGB())
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_Communities.xml ]]
    do --[[ CommunitiesList ]]
        function Skin.CommunitiesListEntryTemplate(Button)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 7,
                right = 10,
                top = 8,
                bottom = 8,
            })

            local bg = Button:GetBackdropTexture("bg")
            Button.Background:Hide()
            Button.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
            Button.Selection:SetAllPoints(bg)

            if private.isRetail then
                Button.GuildTabardBackground:SetSize(60, 60)
                Button.GuildTabardBackground:SetPoint("TOPLEFT", bg, -1, 1)
                Button.GuildTabardEmblem:SetSize(36 * 1.3, 42 * 1.3)
                Button.GuildTabardEmblem:SetPoint("CENTER", Button.GuildTabardBackground, 0, 6)
                Button.GuildTabardBorder:SetAllPoints(Button.GuildTabardBackground)
            end

            Button._iconBG = Button:CreateTexture(nil, "BACKGROUND", nil, 5)
            Button._iconBG:SetPoint("TOPLEFT", bg, 1, -1)
            Button._iconBG:SetPoint("BOTTOM", bg, 0, 1)
            Button._iconBG:SetWidth(Button._iconBG:GetHeight())

            Button.CircleMask:Hide()
            Button.IconRing:SetAlpha(0)

            if private.isRetail then
                Button.NewCommunityFlash:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
            end
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
        function Skin.CommunitiesMemberListEntryTemplate(Button)
            Util.Mixin(Button, Hook.CommunitiesMemberListEntryMixin)
        end
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
        function Skin.CommunitiesFrameMemberListDropDownMenuTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
        Skin.GuildMemberListDropDownMenuTemplate = Skin.CommunitiesFrameMemberListDropDownMenuTemplate
        Skin.CommunityMemberListDropDownMenuTemplate = Skin.CommunitiesFrameMemberListDropDownMenuTemplate
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
            Skin.FrameTypeEditBox(EditBox)
            local bg = EditBox:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", -5, -5)
            bg:SetPoint("BOTTOMRIGHT", 5, 5)

            EditBox.Left:Hide()
            EditBox.Right:Hide()
            EditBox.Mid:Hide()
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
            Base.CreateBackdrop(Frame, private.backdrop, {
                bg = Frame.BG
            })
            Skin.SelectionFrameTemplate(Frame)

            Skin.CommunitiesListDropDownMenuTemplate(Frame.CommunitiesListDropDownMenu)
            Skin.UIPanelStretchableArtScrollBarTemplate(Frame.ScrollFrame.ScrollBar)
            Skin.UICheckButtonTemplate(Frame.ScrollFrame.Child.QuickJoinButton)
            Skin.CommunitiesMassNotificationsSettingsButtonTemplate(Frame.ScrollFrame.Child.NoneButton)
            Skin.CommunitiesMassNotificationsSettingsButtonTemplate(Frame.ScrollFrame.Child.AllButton)
        end
        function Skin.AddToChatButtonTemplate(Frame)
            Skin.UIMenuButtonStretchTemplate(Frame)
            Hook.SquareButton_SetIcon(Frame, "DOWN")
        end
        function Skin.StreamDropDownMenuTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
    end
    do --[[ CommunitiesAvatarPickerDialog ]]
        function Skin.AvatarButtonTemplate(Button)
        end
    end
    do --[[ CommunitiesTabs ]]
        function Skin.CommunitiesFrameTabTemplate(CheckButton)
            Skin.SideTabTemplate(CheckButton)
            if private.isRetail then
                CheckButton.IconOverlay:Hide()
            end
        end
    end
    do --[[ ClubFinderApplicantList ]]
        function Skin.ClubFinderApplicantListFrameTemplate(CheckButton)
        end
    end
    do --[[ ClubFinder ]]
        function Skin.ClubFinderEditBoxScrollFrameTemplate(ScrollFrame)
            Skin.InputScrollFrameTemplate(ScrollFrame)
        end
        function Skin.ClubsFinderJoinClubWarningTemplate(Frame)
            Skin.DialogBorderDarkTemplate(Frame.BG)
            Skin.UIPanelButtonTemplate(Frame.Accept)
            Skin.UIPanelButtonTemplate(Frame.Cancel)
        end
        function Skin.ClubFinderInvitationsFrameTemplate(Frame)
            Skin.ClubsFinderJoinClubWarningTemplate(Frame.WarningDialog)
            Skin.UIPanelButtonTemplate(Frame.AcceptButton)
            Skin.UIPanelButtonTemplate(Frame.ApplyButton)
            Skin.UIPanelButtonTemplate(Frame.DeclineButton)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
        function Skin.ClubsRecruitmentDialogTemplate(Frame)
            Skin.DialogBorderDarkTemplate(Frame.BG)

            Skin.ClubFinderCheckboxTemplate(Frame.ShouldListClub.Button)
            Skin.ClubFinderFocusDropdownTemplate(Frame.ClubFocusDropdown)
            Skin.UIDropDownMenuTemplate(Frame.LookingForDropdown)
            Skin.UIDropDownMenuTemplate(Frame.LanguageDropdown)

            -- BlizzWTF: RecruitmentMessageFrame.RecruitmentMessageInput already has a border via InputScrollFrameTemplate
            local EditBox = Frame.RecruitmentMessageFrame
            EditBox.TopLeft:Hide()
            EditBox.TopRight:Hide()
            EditBox.Top:Hide()
            EditBox.BottomLeft:Hide()
            EditBox.BottomRight:Hide()
            EditBox.Bottom:Hide()
            EditBox.Left:Hide()
            EditBox.Right:Hide()
            EditBox.Middle:Hide()
            Skin.ClubFinderEditBoxScrollFrameTemplate(EditBox.RecruitmentMessageInput)

            Skin.ClubFinderCheckboxTemplate(Frame.MaxLevelOnly.Button)
            Skin.ClubFinderCheckboxTemplate(Frame.MinIlvlOnly.Button)
            Skin.InputBoxTemplate(Frame.MinIlvlOnly.EditBox)
            Skin.UIPanelButtonTemplate(Frame.Accept)
            Skin.UIPanelButtonTemplate(Frame.Cancel)
        end
        function Skin.ClubFinderBigSpecializationCheckBoxTemplate(Frame)
            Skin.ClubFinderCheckboxTemplate(Frame.CheckBox)
        end
        function Skin.ClubFinderLittleSpecializationCheckBoxTemplate(Frame)
            Skin.ClubFinderCheckboxTemplate(Frame.CheckBox)
        end
        function Skin.ClubFinderRequestToJoinTemplate(Frame)
            Skin.DialogBorderDarkTemplate(Frame.BG)

            -- BlizzWTF: MessageFrame.MessageScroll already has a border via InputScrollFrameTemplate
            local EditBox = Frame.MessageFrame
            EditBox.TopLeft:Hide()
            EditBox.TopRight:Hide()
            EditBox.Top:Hide()
            EditBox.BottomLeft:Hide()
            EditBox.BottomRight:Hide()
            EditBox.Bottom:Hide()
            EditBox.Left:Hide()
            EditBox.Right:Hide()
            EditBox.Middle:Hide()
            Skin.ClubFinderEditBoxScrollFrameTemplate(EditBox.MessageScroll)

            Skin.UIPanelButtonTemplate(Frame.Apply)
            Skin.UIPanelButtonTemplate(Frame.Cancel)
        end
        function Skin.ClubFinderGuildCardTemplate(Frame)
            Base.SetBackdrop(Frame, Color.frame, 0.5)
            Frame:SetBackdropBorderColor(Color.button)

            Frame.CardBackground:Hide()
            Skin.UIPanelButtonTemplate(Frame.RequestJoin)
        end
        function Skin.ClubFinderFocusDropdownTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
        function Skin.ClubFinderFilterDropdownTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
        function Skin.ClubFinderCheckboxTemplate(CheckButton)
            Skin.UICheckButtonTemplate(CheckButton) -- BlizzWTF: Doesn't use the template
        end
        function Skin.ClubFinderGuildCardsFrameTemplate(Frame)
            Skin.ClubFinderGuildCardTemplate(Frame.FirstCard)
            Skin.ClubFinderGuildCardTemplate(Frame.SecondCard)
            Skin.ClubFinderGuildCardTemplate(Frame.ThirdCard)
            Skin.NavButtonPrevious(Frame.PreviousPage)
            Skin.NavButtonNext(Frame.NextPage)
        end
        local roleIcons = {
            ["UI-Frame-TankIcon"] = "iconTANK",
            ["UI-Frame-HealerIcon"] = "iconHEALER",
            ["UI-Frame-DpsIcon"] = "iconDAMAGER",
        }
        function Skin.ClubFinderRoleTemplate(Frame)
            local atlas = Frame.Icon:GetAtlas()
            Base.SetTexture(Frame.Icon, roleIcons[atlas])
            Skin.ClubFinderCheckboxTemplate(Frame.CheckBox)
        end
        function Skin.ClubFinderCommunitiesCardTemplate(Button)
            Base.SetBackdrop(Button, Color.button, Color.frame.a)
            Button.Background:Hide()

            Button.LogoBorder:Hide()
            Base.CropIcon(Button.CommunityLogo, Button)
            Button.CircleMask:Hide()

            Button.HighlightBackground:SetAlpha(0)
            Base.SetHighlight(Button, "backdrop")
        end
        function Skin.ClubFinderCommunitiesCardFrameTemplate(Frame)
            Skin.HybridScrollBarTemplate(Frame.ListScrollFrame.scrollBar)
            Frame.ListScrollFrame.scrollBar:SetPoint("TOPLEFT", Frame.ListScrollFrame, "TOPRIGHT", -15, -15)
            Frame.ListScrollFrame.scrollBar:SetPoint("BOTTOMLEFT", Frame.ListScrollFrame, "BOTTOMRIGHT", 15, 15)
        end
        function Skin.ClubFinderOptionsTemplate(Frame)
            Skin.ClubFinderFilterDropdownTemplate(Frame.ClubFilterDropdown)
            Skin.UIDropDownMenuTemplate(Frame.ClubSizeDropdown)
            Skin.UIDropDownMenuTemplate(Frame.SortByDropdown)
            Skin.ClubFinderRoleTemplate(Frame.TankRoleFrame)
            Skin.ClubFinderRoleTemplate(Frame.HealerRoleFrame)
            Skin.ClubFinderRoleTemplate(Frame.DpsRoleFrame)
            Skin.SearchBoxTemplate(Frame.SearchBox)
            Skin.UIPanelButtonTemplate(Frame.Search)
        end
        function Skin.ClubFinderGuildAndCommunityFrameTemplate(Frame)
            Skin.ClubFinderOptionsTemplate(Frame.OptionsList)
            Skin.ClubFinderGuildCardsFrameTemplate(Frame.GuildCards)
            Skin.ClubFinderCommunitiesCardFrameTemplate(Frame.CommunityCards)
            Skin.ClubFinderGuildCardsFrameTemplate(Frame.PendingGuildCards)
            Skin.ClubFinderCommunitiesCardFrameTemplate(Frame.PendingCommunityCards)
            Skin.ClubFinderRequestToJoinTemplate(Frame.RequestToJoinFrame)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
            Skin.CommunitiesFrameTabTemplate(Frame.ClubFinderSearchTab)
            Skin.CommunitiesFrameTabTemplate(Frame.ClubFinderPendingTab)
            Util.PositionRelative("TOPLEFT", Frame, "TOPRIGHT", 10, 43, 5, "Down", {
                Frame.ClubFinderSearchTab,
                Frame.ClubFinderPendingTab,
            })
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
            Frame.ColumnDisplay.InsetBorderTopLeft:ClearAllPoints()
            Frame.ColumnDisplay.InsetBorderTopRight:ClearAllPoints()
            Frame.ColumnDisplay.InsetBorderBottomLeft:ClearAllPoints()
        end
    end
    do --[[ CommunitiesCalendar ]]
        function Skin.CommunitiesCalendarButtonTemplate(Button)
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

            Base.SetBackdrop(Frame, Color.button, Color.frame.a)
            local bg = Frame:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", 0, -3)
            bg:SetPoint("BOTTOMRIGHT", -1, 1)

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
        function Skin.CommunitiesGuildNewsCheckButtonTemplate(CheckButton)
            Skin.FrameTypeCheckButton(CheckButton)
            CheckButton:SetBackdropOption("offsets", {
                left = 5,
                right = 5,
                top = 5,
                bottom = 5,
            })

            local bg = CheckButton:GetBackdropTexture("bg")
            local check = CheckButton:GetCheckedTexture()
            check:ClearAllPoints()
            check:SetPoint("TOPLEFT", bg, -5, 5)
            check:SetPoint("BOTTOMRIGHT", bg, 5, -5)
            check:SetDesaturated(true)
            check:SetVertexColor(Color.highlight:GetRGB())

            local disabled = CheckButton:GetDisabledCheckedTexture()
            disabled:SetAllPoints(check)
        end
        function Skin.CommunitiesGuildNewsButtonTemplate(Button)
            Button.header:SetTexture("")
        end
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
            Skin.DialogBorderDarkTemplate(Frame.Border)
            Skin.UIPanelCloseButton(Frame.CloseButton)
            Skin.UIPanelButtonTemplate(Frame.RemoveButton)
            Skin.UIPanelButtonTemplate(Frame.GroupInviteButton)
            Skin.UIDropDownMenuTemplate(Frame.RankDropdown)

            Base.SetBackdrop(Frame.NoteBackground)
            Base.SetBackdrop(Frame.OfficerNoteBackground)
        end
    end
    do --[[ GuildNameChange ]]
        function Skin.CommunitiesGuildNameChangeAlertFrameTemplate(Frame)
            Skin.GlowBoxTemplate(Frame)
        end
        function Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.UIPanelCloseButton(Frame.CloseButton)
        end
        function Skin.NameChangeEditBoxTemplate(Frame)
            Skin.InputBoxTemplate(Frame)
        end
        function Skin.GuildNameChangeFrameTemplate(Frame)
            Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.NameChangeEditBoxTemplate(Frame.EditBox)
            Skin.UIPanelButtonTemplate(Frame.Button)
        end
        function Skin.CommunityNameChangeFrameTemplate(Frame)
            Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.UIPanelButtonTemplate(Frame.Button)
        end

        function Skin.GuildPostingChangeFrameTemplate(Frame)
            Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.UIPanelButtonTemplate(Frame.Button)
        end
        function Skin.CommunityPostingChangeFrameTemplate(Frame)
            Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.UIPanelButtonTemplate(Frame.Button)
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
            if private.isRetail then
                Skin.UIPanelButtonTemplate(Frame.GuildControlButton)
                Skin.UIPanelButtonTemplate(Frame.GuildRecruitmentButton)
            end
        end
        function Skin.CommunitiesFrameFriendTabTemplate(Frame)
            Skin.FriendsFrameTabTemplate(Frame)
        end
    end
end

function private.AddOns.Blizzard_Communities()
    ----====####$$$$%%%%%$$$$####====----
    --         CommunitiesList         --
    ----====####$$$$%%%%%$$$$####====----
    Util.Mixin(_G.CommunitiesListEntryMixin, Hook.CommunitiesListEntryMixin)

    ----====####$$$$%%%%%$$$$####====----
    --      CommunitiesMemberList      --
    ----====####$$$$%%%%%$$$$####====----
    Util.Mixin(_G.CommunitiesMemberListEntryMixin, Hook.CommunitiesMemberListEntryMixin)

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
    local CommunitiesAvatarPickerDialog = _G.CommunitiesAvatarPickerDialog
    Base.CreateBackdrop(CommunitiesAvatarPickerDialog, private.backdrop, {
        bg = select(9, CommunitiesAvatarPickerDialog:GetRegions())
    })
    Skin.SelectionFrameTemplate(CommunitiesAvatarPickerDialog)
    Skin.ListScrollFrameTemplate(CommunitiesAvatarPickerDialog.ScrollFrame)

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
    --     ClubFinderApplicantList     --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --           ClubFinder           --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --       CommunitiesSettings       --
    ----====####$$$$%%%%%$$$$####====----
    local CommunitiesSettingsDialog = _G.CommunitiesSettingsDialog
    _G.hooksecurefunc(CommunitiesSettingsDialog, "SetClubId", Hook.CommunitiesSettingsDialogMixin.SetClubId)
    if private.isRetail then
        Skin.DialogBorderDarkTemplate(CommunitiesSettingsDialog.BG)
    else
        Skin.DialogBorderDarkTemplate(CommunitiesSettingsDialog)
    end

    CommunitiesSettingsDialog.IconPreview:RemoveMaskTexture(CommunitiesSettingsDialog.CircleMask)
    CommunitiesSettingsDialog._iconBorder = Base.CropIcon(CommunitiesSettingsDialog.IconPreview, CommunitiesSettingsDialog)
    CommunitiesSettingsDialog.IconPreviewRing:SetAlpha(0)

    Skin.InputBoxTemplate(CommunitiesSettingsDialog.NameEdit)
    Skin.InputBoxTemplate(CommunitiesSettingsDialog.ShortNameEdit)
    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.ChangeAvatarButton)
    Skin.InputScrollFrameTemplate(CommunitiesSettingsDialog.MessageOfTheDay)

    Skin.ClubFinderCheckboxTemplate(CommunitiesSettingsDialog.ShouldListClub.Button)
    Skin.ClubFinderCheckboxTemplate(CommunitiesSettingsDialog.AutoAcceptApplications.Button)
    Skin.ClubFinderCheckboxTemplate(CommunitiesSettingsDialog.MaxLevelOnly.Button)
    Skin.ClubFinderCheckboxTemplate(CommunitiesSettingsDialog.MinIlvlOnly.Button)
    Skin.InputBoxTemplate(CommunitiesSettingsDialog.MinIlvlOnly.EditBox)

    Skin.ClubFinderFocusDropdownTemplate(CommunitiesSettingsDialog.ClubFocusDropdown)
    Skin.UIDropDownMenuTemplate(CommunitiesSettingsDialog.LookingForDropdown)
    Skin.UIDropDownMenuTemplate(CommunitiesSettingsDialog.LanguageDropdown)

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
    Skin.UIPanelSquareButton(CommunitiesTicketManagerDialog.MaximizeButton, "DOWN")
    Skin.CommunitiesTicketManagerScrollFrameTemplate(CommunitiesTicketManagerDialog.InviteManager)
    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.Close)

    ----====####$$$$%%%%%$$$$####====----
    --       CommunitiesCalendar       --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --          GuildRewards          --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --           GuildPerks           --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --            GuildInfo            --
    ----====####$$$$%%%%%$$$$####====----
    if private.isRetail then
        Skin.TranslucentFrameTemplate(_G.CommunitiesGuildLogFrame)
        local close1, container, close2 = _G.CommunitiesGuildLogFrame:GetChildren()
        Skin.UIPanelCloseButton(close1) -- BlizzWTF: close1 and close2 have the same global name
        container:SetBackdrop(nil)
        Skin.MinimalScrollFrameTemplate(container.ScrollFrame)
        Skin.UIPanelButtonTemplate(close2)
    end

    ----====####$$$$%%%%%$$$$####====----
    --            GuildNews            --
    ----====####$$$$%%%%%$$$$####====----
    if private.isRetail then
        local CommunitiesGuildNewsFiltersFrame = _G.CommunitiesGuildNewsFiltersFrame
        Skin.TranslucentFrameTemplate(CommunitiesGuildNewsFiltersFrame)
        Skin.UIPanelCloseButton(CommunitiesGuildNewsFiltersFrame.CloseButton)
        for i, CheckButton in next, CommunitiesGuildNewsFiltersFrame.GuildNewsFilterButtons do
            Skin.CommunitiesGuildNewsCheckButtonTemplate(CheckButton)
        end
    end

    ----====####$$$$%%%%%$$$$####====----
    --           GuildRoster           --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --         GuildNameChange         --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --        CommunitiesFrame        --
    ----====####$$$$%%%%$$$$####====----
    local CommunitiesFrame = _G.CommunitiesFrame
    Skin.ButtonFrameTemplate(CommunitiesFrame)
    CommunitiesFrame.PortraitOverlay:SetAlpha(0)

    Skin.MaximizeMinimizeButtonFrameTemplate(CommunitiesFrame.MaximizeMinimizeFrame)
    if private.isClassic then
        CommunitiesFrame.MaximizeMinimizeFrame:GetRegions():Hide()
    end
    _G.hooksecurefunc(CommunitiesFrame.MaximizeMinimizeFrame, "maximizedCallback", function(...)
        CommunitiesFrame.Chat:SetPoint("BOTTOMRIGHT", CommunitiesFrame.MemberList, "BOTTOMLEFT", -32, 32)
    end)
    Skin.CommunitiesListFrameTemplate(CommunitiesFrame.CommunitiesList)

    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.ChatTab)
    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.RosterTab)
    if private.isRetail then
        Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.GuildBenefitsTab)
        Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.GuildInfoTab)
    end
    Util.PositionRelative("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 1, -40, 5, "Down", {
        CommunitiesFrame.ChatTab,
        CommunitiesFrame.RosterTab,
        private.isRetail and CommunitiesFrame.GuildBenefitsTab or nil,
        private.isRetail and CommunitiesFrame.GuildInfoTab or nil,
    })

    Skin.StreamDropDownMenuTemplate(CommunitiesFrame.StreamDropDownMenu)
    if private.isRetail then
        Skin.GuildMemberListDropDownMenuTemplate(CommunitiesFrame.GuildMemberListDropDownMenu)
        Skin.CommunityMemberListDropDownMenuTemplate(CommunitiesFrame.CommunityMemberListDropDownMenu)
    end
    Skin.CommunitiesListDropDownMenuTemplate(CommunitiesFrame.CommunitiesListDropDownMenu)
    Skin.CommunitiesCalendarButtonTemplate(CommunitiesFrame.CommunitiesCalendarButton)
    Skin.CommunitiesMemberListFrameTemplate(CommunitiesFrame.MemberList)
    if private.isRetail then
        Skin.ClubFinderApplicantListFrameTemplate(CommunitiesFrame.ApplicantList)
        Skin.ClubFinderGuildAndCommunityFrameTemplate(CommunitiesFrame.GuildFinderFrame)
        Skin.ClubFinderGuildAndCommunityFrameTemplate(CommunitiesFrame.CommunityFinderFrame)
    end
    Skin.CommunitiesChatTemplate(CommunitiesFrame.Chat)
    Skin.CommunitiesChatEditBoxTemplate(CommunitiesFrame.ChatEditBox)

    Skin.CommunitiesInvitationFrameTemplate(CommunitiesFrame.InvitationFrame)
    if private.isRetail then
        Skin.ClubFinderInvitationsFrameTemplate(CommunitiesFrame.ClubFinderInvitationFrame)
    end
    Skin.CommunitiesTicketFrameTemplate(CommunitiesFrame.TicketFrame)
    if private.isRetail then
        Skin.GuildBenefitsFrameTemplate(CommunitiesFrame.GuildBenefitsFrame)
        Skin.GuildDetailsFrameTemplate(CommunitiesFrame.GuildDetailsFrame)
        Skin.GuildNameChangeFrameTemplate(CommunitiesFrame.GuildNameChangeFrame)
        Skin.CommunityNameChangeFrameTemplate(CommunitiesFrame.CommunityNameChangeFrame)
        Skin.GuildPostingChangeFrameTemplate(CommunitiesFrame.GuildPostingChangeFrame)
        Skin.CommunityPostingChangeFrameTemplate(CommunitiesFrame.CommunityPostingChangeFrame)
    end

    Skin.CommunitiesEditStreamDialogTemplate(CommunitiesFrame.EditStreamDialog)
    Skin.CommunitiesNotificationSettingsDialogTemplate(CommunitiesFrame.NotificationSettingsDialog)
    if private.isRetail then
        Skin.ClubsRecruitmentDialogTemplate(CommunitiesFrame.RecruitmentDialog)
    end
    Skin.AddToChatButtonTemplate(CommunitiesFrame.AddToChatButton)
    Skin.CommunitiesInviteButtonTemplate(CommunitiesFrame.InviteButton)
    Skin.CommunitiesControlFrameTemplate(CommunitiesFrame.CommunitiesControlFrame)
    if private.isRetail then
        Skin.UIPanelButtonTemplate(CommunitiesFrame.GuildLogButton)
        Skin.CommunitiesGuildMemberDetailFrameTemplate(CommunitiesFrame.GuildMemberDetailFrame)
    end

    if private.isClassic then
        Skin.CommunitiesFrameFriendTabTemplate(_G.CommunitiesFrameTab1)
        Skin.CommunitiesFrameFriendTabTemplate(_G.CommunitiesFrameTab2)
        Skin.CommunitiesFrameFriendTabTemplate(_G.CommunitiesFrameTab3)
        Skin.CommunitiesFrameFriendTabTemplate(_G.CommunitiesFrameTab4)
        Skin.CommunitiesFrameFriendTabTemplate(_G.CommunitiesFrameTab5)
        Util.PositionRelative("TOPLEFT", CommunitiesFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
            _G.CommunitiesFrameTab1,
            _G.CommunitiesFrameTab2,
            _G.CommunitiesFrameTab3,
            _G.CommunitiesFrameTab4,
            _G.CommunitiesFrameTab5,
        })
    end
end
