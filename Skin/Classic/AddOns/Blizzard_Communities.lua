local _, private = ...
if private.isRetail then return end

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
        function Hook.CommunitiesListEntryMixin:SetAddCommunity()
            self.CircleMask:Hide()
            Base.CropIcon(self.Icon)
            self.Icon:ClearAllPoints()
            self.Icon:SetPoint("CENTER", self._iconBG)
            self.Name:SetPoint("LEFT", self._iconBG, "RIGHT", 11, 0)

            self._iconBG:Show()
            self._iconBG:SetColorTexture(Color.black:GetRGB())
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

            Button._iconBG = Button:CreateTexture(nil, "BACKGROUND", nil, 5)
            Button._iconBG:SetPoint("TOPLEFT", bg, 1, -1)
            Button._iconBG:SetPoint("BOTTOM", bg, 0, 1)
            Button._iconBG:SetWidth(Button._iconBG:GetHeight())

            Button.CircleMask:Hide()
            Button.IconRing:SetAlpha(0)
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
            EditBox:SetBackdropOption("offsets", {
                left = -5,
                right = -5,
                top = 5,
                bottom = 5,
            })

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
            Skin.FrameTypeFrame(Frame)

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
        Skin.CommunitiesFrameTabTemplate = Skin.SideTabTemplate
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
    do --[[ CommunitiesFrame ]]
        function Skin.CommunitiesControlFrameTemplate(Frame)
            Skin.CommunitiesSettingsButtonTemplate(Frame.CommunitiesSettingsButton)
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
    --       CommunitiesSettings       --
    ----====####$$$$%%%%%$$$$####====----
    local CommunitiesSettingsDialog = _G.CommunitiesSettingsDialog
    _G.hooksecurefunc(CommunitiesSettingsDialog, "SetClubId", Hook.CommunitiesSettingsDialogMixin.SetClubId)
    Skin.DialogBorderDarkTemplate(CommunitiesSettingsDialog)

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

    Skin.FrameTypeFrame(CommunitiesTicketManagerDialog)
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
    --        CommunitiesErrors        --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --      CommunitiesHyperlink      --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --        CommunitiesFrame        --
    ----====####$$$$%%%%$$$$####====----
    local CommunitiesFrame = _G.CommunitiesFrame
    Skin.ButtonFrameTemplate(CommunitiesFrame)
    CommunitiesFrame.PortraitOverlay:SetAlpha(0)

    Skin.MaximizeMinimizeButtonFrameTemplate(CommunitiesFrame.MaximizeMinimizeFrame)
    CommunitiesFrame.MaximizeMinimizeFrame:GetRegions():Hide()
    _G.hooksecurefunc(CommunitiesFrame.MaximizeMinimizeFrame, "maximizedCallback", function(...)
        CommunitiesFrame.Chat:SetPoint("BOTTOMRIGHT", CommunitiesFrame.MemberList, "BOTTOMLEFT", -32, 32)
    end)
    Skin.CommunitiesListFrameTemplate(CommunitiesFrame.CommunitiesList)

    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.ChatTab)
    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.RosterTab)
    Util.PositionRelative("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 1, -40, 5, "Down", {
        CommunitiesFrame.ChatTab,
        CommunitiesFrame.RosterTab,
    })

    Skin.StreamDropDownMenuTemplate(CommunitiesFrame.StreamDropDownMenu)
    Skin.CommunitiesListDropDownMenuTemplate(CommunitiesFrame.CommunitiesListDropDownMenu)
    Skin.CommunitiesMemberListFrameTemplate(CommunitiesFrame.MemberList)
    Skin.CommunitiesChatTemplate(CommunitiesFrame.Chat)
    Skin.CommunitiesChatEditBoxTemplate(CommunitiesFrame.ChatEditBox)

    Skin.CommunitiesInvitationFrameTemplate(CommunitiesFrame.InvitationFrame)
    Skin.CommunitiesTicketFrameTemplate(CommunitiesFrame.TicketFrame)

    Skin.CommunitiesEditStreamDialogTemplate(CommunitiesFrame.EditStreamDialog)
    Skin.CommunitiesNotificationSettingsDialogTemplate(CommunitiesFrame.NotificationSettingsDialog)
    Skin.AddToChatButtonTemplate(CommunitiesFrame.AddToChatButton)
    Skin.CommunitiesInviteButtonTemplate(CommunitiesFrame.InviteButton)
    Skin.CommunitiesControlFrameTemplate(CommunitiesFrame.CommunitiesControlFrame)

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
