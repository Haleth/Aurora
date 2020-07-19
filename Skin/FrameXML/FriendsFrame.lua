local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\FriendsFrame.lua ]]
    Hook.FriendsBroadcastFrameMixin = {}
    function Hook.FriendsBroadcastFrameMixin:ShowFrame()
        self.BroadcastButton:LockHighlight()
    end
    function Hook.FriendsBroadcastFrameMixin:HideFrame()
        self.BroadcastButton:UnlockHighlight()
    end

    function Hook.FriendsFrame_UpdateFriendButton(button)
        local gameIcon = button.gameIcon
        if gameIcon._bg then
            gameIcon._bg:SetShown(gameIcon:IsShown())
        end
    end
    function Hook.WhoList_Update()
        if private.isRetail then
            local buttons = _G.WhoListScrollFrame.buttons
            local numButtons = #buttons

            for i = 1, numButtons do
                local button = buttons[i]
                if button.index then
                    local info = _G.C_FriendList.GetWhoInfo(button.index)
                    if info.filename then
                        button.Class:SetTextColor(_G.CUSTOM_CLASS_COLORS[info.filename]:GetRGB())
                    end
                end
            end
        else
            local whoOffset = _G.FauxScrollFrame_GetOffset(_G.WhoListScrollFrame)
            local whoIndex
            for i = 1, _G.WHOS_TO_DISPLAY, 1 do
                whoIndex = whoOffset + i
                local info = _G.C_FriendList.GetWhoInfo(whoIndex)
                if info and info.filename then
                    _G["WhoFrameButton"..i.."Class"]:SetTextColor(_G.CUSTOM_CLASS_COLORS[info.filename]:GetRGB())
                end
            end
        end
    end
end

do --[[ FrameXML\FriendsFrame.xml ]]
    function Skin.FriendsTabTemplate(Button)
        Skin.TabButtonTemplate(Button)
    end
    function Skin.FriendsFrameSlider(Slider)
        Skin.HybridScrollBarTrimTemplate(Slider)
    end
    function Skin.FriendsFrameScrollFrame(ScrollFrame)
        Skin.FriendsFrameSlider(ScrollFrame.scrollBar)
    end
    function Skin.FriendsFrameHeaderTemplate(Frame)
    end
    function Skin.FriendsFrameButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end
    function Skin.FriendsListButtonTemplate(Button)
        local gameIcon = Button.gameIcon
        gameIcon._bg = Base.CropIcon(Button.gameIcon, Button)
        gameIcon:SetSize(22, 22)
        gameIcon:SetTexCoord(0.15625, 0.84375, 0.15625, 0.84375)
        gameIcon:SetPoint("TOPRIGHT", -21, -6)

        local travelPassButton = Button.travelPassButton
        Skin.FrameTypeButton(travelPassButton)
        travelPassButton:SetSize(20, 32)

        local texture = travelPassButton:CreateTexture(nil, "OVERLAY", nil, 7)
        texture:SetTexture([[Interface\FriendsFrame\PlusManz-PlusManz]])
        texture:SetPoint("TOPRIGHT", 1, -4)
        texture:SetSize(22, 22)
        texture:SetAlpha(0.75)
        travelPassButton._auroraTextures = {texture}
    end
    function Skin.WhoFrameColumnHeaderTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
        Button.HighlightTexture:SetAlpha(0)
    end
    function Skin.FriendsFrameGuildPlayerStatusButtonTemplate(Button)
        Button:GetHighlightTexture():SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
    end
    function Skin.FriendsFrameGuildStatusButtonTemplate(Button)
        Button:GetHighlightTexture():SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
    end
    function Skin.GuildFrameColumnHeaderTemplate(Button)
        local name = Button:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."Right"]:Hide()
    end
    function Skin.FriendsFrameTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.GuildControlPopupFrameCheckboxTemplate(CheckButton)
        Skin.UICheckButtonTemplate(CheckButton)
    end
end

function private.FrameXML.FriendsFrame()
    _G.hooksecurefunc("FriendsFrame_UpdateFriendButton", Hook.FriendsFrame_UpdateFriendButton)
    _G.hooksecurefunc("WhoList_Update", Hook.WhoList_Update)

    local FriendsFrame = _G.FriendsFrame
    Skin.ButtonFrameTemplate(FriendsFrame)
    _G.FriendsFrameIcon:Hide()

    ----------------------
    -- FriendsTabHeader --
    ----------------------
    local BNetFrame = _G.FriendsFrameBattlenetFrame
    BNetFrame:GetRegions():Hide() -- BattleTag background
    BNetFrame:SetWidth(245)
    BNetFrame:SetPoint("TOPLEFT", 54, -26)
    Base.SetBackdrop(BNetFrame, _G.FRIENDS_BNET_BACKGROUND_COLOR, Color.frame.a)

    do -- BNetFrame.BroadcastButton
        local Button = BNetFrame.BroadcastButton
        Skin.FrameTypeButton(Button)
        Button:GetNormalTexture():SetAlpha(0)
        Button:GetPushedTexture():SetAlpha(0)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })

        local icon = Button:CreateTexture(nil, "ARTWORK")
        icon:SetTexture([[Interface\FriendsFrame\BroadcastIcon]])
        icon:SetSize(16, 16)
        icon:SetPoint("CENTER")
    end

    Skin.UIPanelInfoButton(BNetFrame.UnavailableInfoButton)

    local BroadcastFrame = BNetFrame.BroadcastFrame
    BroadcastFrame:SetPoint("TOPLEFT", -55, -24)

    if private.isRetail then
        Util.Mixin(BroadcastFrame, Hook.FriendsBroadcastFrameMixin)
        Skin.DialogBorderOpaqueTemplate(BroadcastFrame.Border)

        local EditBox = BroadcastFrame.EditBox
        Base.CreateBackdrop(EditBox, private.backdrop, {
            tl = EditBox.TopLeftBorder,
            tr = EditBox.TopRightBorder,
            t = EditBox.TopBorder,

            bl = EditBox.BottomLeftBorder,
            br = EditBox.BottomRightBorder,
            b = EditBox.BottomBorder,

            l = EditBox.LeftBorder,
            r = EditBox.RightBorder,

            bg = EditBox.MiddleBorder
        })
        Skin.FrameTypeEditBox(EditBox)
        EditBox:SetBackdropOption("offsets", {
            left = -7,
            right = -5,
            top = 0,
            bottom = 0,
        })

        Skin.FriendsFrameButtonTemplate(BroadcastFrame.UpdateButton)
        Skin.FriendsFrameButtonTemplate(BroadcastFrame.CancelButton)
    else
        Skin.DialogBorderOpaqueTemplate(BroadcastFrame)

        local ScrollFrame = BroadcastFrame.ScrollFrame
        Base.CreateBackdrop(ScrollFrame, private.backdrop, {
            tl = ScrollFrame.TopLeftBorder,
            tr = ScrollFrame.TopRightBorder,
            t = ScrollFrame.TopBorder,

            bl = ScrollFrame.BottomLeftBorder,
            br = ScrollFrame.BottomRightBorder,
            b = ScrollFrame.BottomBorder,

            l = ScrollFrame.LeftBorder,
            r = ScrollFrame.RightBorder,

            bg = ScrollFrame.MiddleBorder
        })
        Skin.FrameTypeEditBox(ScrollFrame)
        ScrollFrame:SetBackdropOption("offsets", {
            left = -3,
            right = -3,
            top = -2,
            bottom = -2,
        })

        Skin.FriendsFrameButtonTemplate(ScrollFrame.UpdateButton)
        Skin.FriendsFrameButtonTemplate(ScrollFrame.CancelButton)
    end

    Skin.DialogBorderTemplate(BNetFrame.UnavailableInfoFrame)
    local _, blizzIcon = select(11, BNetFrame.UnavailableInfoFrame:GetRegions())
    blizzIcon:SetTexture([[Interface\Glues\MainMenu\Glues-BlizzardLogo]])

    Skin.UIDropDownMenuTemplate(_G.FriendsFrameStatusDropDown)
    _G.FriendsFrameStatusDropDown:SetPoint("TOPLEFT", -12, -27)
    if private.isRetail then
        local FriendsTabHeader = FriendsFrame.FriendsTabHeader
        Skin.FriendsTabTemplate(FriendsTabHeader.Tab1)
        Skin.FriendsTabTemplate(FriendsTabHeader.Tab2)
        Skin.FriendsTabTemplate(FriendsTabHeader.Tab3)
    else
        Skin.FriendsTabTemplate(_G.FriendsTabHeaderTab1)
        Skin.FriendsTabTemplate(_G.FriendsTabHeaderTab2)
    end


    ----------------------
    -- FriendsListFrame --
    ----------------------
    local FriendsListFrame = _G.FriendsListFrame
    Skin.FriendsFrameButtonTemplate(_G.FriendsFrameAddFriendButton)
    Skin.FriendsFrameButtonTemplate(_G.FriendsFrameSendMessageButton)
    Skin.UIDropDownMenuTemplate(FriendsListFrame.FilterDropDown)
    Skin.UIPanelButtonTemplate(FriendsListFrame.RIDWarning:GetChildren()) -- ContinueButton
    if private.isRetail then
        Skin.FriendsFrameScrollFrame(_G.FriendsListFrameScrollFrame)
        Hook.HybridScrollFrame_CreateButtons(_G.FriendsListFrameScrollFrame, "FriendsListButtonTemplate") -- Called here since the original is called OnLoad
    else
        _G.FriendsFrameFriendsScrollFrameTop:Hide()
        _G.FriendsFrameFriendsScrollFrameMiddle:Hide()
        _G.FriendsFrameFriendsScrollFrameBottom:Hide()
        --Skin.UIMenuButtonStretchTemplate(_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton)
        Skin.MinimalHybridScrollBarTemplate(_G.FriendsFrameFriendsScrollFrame.scrollBar)
        _G.FriendsFrameFriendsScrollFrame.scrollBar:ClearAllPoints()
        _G.FriendsFrameFriendsScrollFrame.scrollBar:SetPoint("TOPRIGHT", 23, -18)
        _G.FriendsFrameFriendsScrollFrame.scrollBar:SetPoint("BOTTOMRIGHT", 23, 17)
        Hook.HybridScrollFrame_CreateButtons(_G.FriendsFrameFriendsScrollFrame, "FriendsListButtonTemplate") -- Called here since the original is called OnLoad
    end


    ----------------------
    -- IgnoreListFrame --
    ----------------------
    Skin.FriendsFrameButtonTemplate(_G.FriendsFrameIgnorePlayerButton)
    Skin.FriendsFrameButtonTemplate(_G.FriendsFrameUnsquelchButton)
    Skin.FriendsFrameHeaderTemplate(_G.FriendsFrameIgnoredHeader)
    Skin.FriendsFrameHeaderTemplate(_G.FriendsFrameBlockedInviteHeader)
    if private.isRetail then
        Skin.FriendsFrameScrollFrame(_G.IgnoreListFrameScrollFrame)
    else
        _G.IgnoreListFrameTop:Hide()
        _G.IgnoreListFrameBottom:Hide()
        _G.IgnoreListFrameMiddle:Hide()

        Skin.FauxScrollFrameTemplate(_G.FriendsFrameIgnoreScrollFrame)
    end


    --------------
    -- WhoFrame --
    --------------
    Skin.InsetFrameTemplate(_G.WhoFrameListInset)
    Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader1)
    Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader2)
    Skin.UIDropDownMenuTemplate(_G.WhoFrameDropDown)
    _G.WhoFrameDropDownHighlightTexture:SetAlpha(0)
    Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader3)
    Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader4)

    Skin.FriendsFrameButtonTemplate(_G.WhoFrameGroupInviteButton)
    Skin.UIPanelButtonTemplate(_G.WhoFrameAddFriendButton)
    Skin.UIPanelButtonTemplate(_G.WhoFrameWhoButton)

    _G.WhoFrameGroupInviteButton:SetPoint("BOTTOMRIGHT", -5, 5)
    _G.WhoFrameWhoButton:ClearAllPoints()
    _G.WhoFrameWhoButton:SetPoint("BOTTOMLEFT", 5, 5)
    _G.WhoFrameAddFriendButton:ClearAllPoints()
    _G.WhoFrameAddFriendButton:SetPoint("BOTTOMLEFT", _G.WhoFrameWhoButton, "BOTTOMRIGHT", 1, 0)
    _G.WhoFrameAddFriendButton:SetPoint("BOTTOMRIGHT", _G.WhoFrameGroupInviteButton, "BOTTOMLEFT", -1, 0)

    Skin.InsetFrameTemplate(_G.WhoFrameEditBoxInset)
    Skin.FrameTypeEditBox(_G.WhoFrameEditBox)
    _G.WhoFrameEditBox:ClearAllPoints()
    _G.WhoFrameEditBox:SetPoint("BOTTOMLEFT", _G.WhoFrameWhoButton, "TOPLEFT", 2, -2)
    _G.WhoFrameEditBox:SetPoint("BOTTOMRIGHT", _G.WhoFrameGroupInviteButton, "TOPRIGHT", -2, -2)
    _G.WhoFrameEditBox:SetBackdropOption("offsets", {
        left = -2,
        right = -2,
        top = 7,
        bottom = 7,
    })

    if private.isRetail then
        Skin.FriendsFrameScrollFrame(_G.WhoListScrollFrame)
    else
        Skin.FauxScrollFrameTemplate(_G.WhoListScrollFrame)
        local top, bottom = _G.WhoListScrollFrame:GetRegions()
        top:Hide()
        bottom:Hide()
    end


    if private.isClassic then
        local friendsBG = FriendsFrame:GetBackdropTexture("bg")

        ----------------
        -- GuildFrame --
        ----------------
        local _, _, _, _, barLeft, barRight = _G.GuildFrame:GetRegions()
        barLeft:ClearAllPoints()
        barLeft:SetPoint("TOPLEFT", friendsBG, 10, -325)
        barLeft:SetPoint("BOTTOMRIGHT", friendsBG, "TOPRIGHT", -10, -326)
        barLeft:SetColorTexture(Color.gray:GetRGB())
        barRight:Hide()

        _G.GuildFrameLFGFrameRight:Hide()
        _G.GuildFrameLFGFrameMiddle:Hide()
        _G.GuildFrameLFGFrameLeft:Hide()
        Skin.UICheckButtonTemplate(_G.GuildFrameLFGButton)

        Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader1)
        Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader2)
        Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader3)
        Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameColumnHeader4)

        for i = 1, _G.GUILDMEMBERS_TO_DISPLAY do
            Skin.FriendsFrameGuildPlayerStatusButtonTemplate(_G["GuildFrameButton"..i])
            Skin.FriendsFrameGuildStatusButtonTemplate(_G["GuildFrameGuildStatusButton"..i])
        end

        Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameGuildStatusColumnHeader1)
        Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameGuildStatusColumnHeader2)
        Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameGuildStatusColumnHeader3)
        Skin.GuildFrameColumnHeaderTemplate(_G.GuildFrameGuildStatusColumnHeader4)

        Skin.FauxScrollFrameTemplate(_G.GuildListScrollFrame)
        local top, bottom = _G.GuildListScrollFrame:GetRegions()
        top:Hide()
        bottom:Hide()

        Skin.NavButtonNext(_G.GuildFrameGuildListToggleButton)
        Skin.UIPanelButtonTemplate(_G.GuildFrameControlButton)
        Skin.UIPanelButtonTemplate(_G.GuildFrameAddMemberButton)
        Skin.UIPanelButtonTemplate(_G.GuildFrameGuildInformationButton)


        ------------------
        -- GuildControl --
        ------------------
        -- /run GuildControlPopupFrame:Show()
        local GuildControlPopupFrame = _G.GuildControlPopupFrame
        Base.SetBackdrop(GuildControlPopupFrame)
        local TopLeft, TopRight, BotLeft, BotRight = _G.GuildControlPopupFrame:GetRegions()
        TopLeft:Hide()
        TopRight:Hide()
        BotLeft:Hide()
        BotRight:Hide()

        Skin.UIDropDownMenuTemplate(_G.GuildControlPopupFrameDropDown)
        do -- Add rank
            local Button = _G.GuildControlPopupFrameAddRankButton
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 0,
                right = 3,
                top = 0,
                bottom = 3,
            })

            local bg = Button:GetBackdropTexture("bg")
            local minus = Button:CreateTexture(nil, "OVERLAY")
            minus:SetPoint("TOPLEFT", bg, 2, -6)
            minus:SetPoint("BOTTOMRIGHT", bg, -2, 6)
            minus:SetColorTexture(1, 1, 1)

            local plus = Button:CreateTexture(nil, "OVERLAY")
            plus:SetPoint("TOPLEFT", bg, 6, -2)
            plus:SetPoint("BOTTOMRIGHT", bg, -6, 2)
            plus:SetColorTexture(1, 1, 1)
        end
        do -- Remove rank
            local Button = _G.GuildControlPopupFrameRemoveRankButton
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 0,
                right = 3,
                top = 0,
                bottom = 3,
            })

            local bg = Button:GetBackdropTexture("bg")
            local minus = Button:CreateTexture(nil, "OVERLAY")
            minus:SetPoint("TOPLEFT", bg, 2, -6)
            minus:SetPoint("BOTTOMRIGHT", bg, -2, 6)
            minus:SetColorTexture(1, 1, 1)
        end

        for i = 1, 13 do
            Skin.GuildControlPopupFrameCheckboxTemplate(_G["GuildControlPopupFrameCheckbox"..i])
        end
        Skin.UIPanelButtonTemplate(_G.GuildControlPopupFrameCancelButton)
        Skin.UIPanelButtonTemplate(_G.GuildControlPopupAcceptButton)
        do
            local EditBox = _G.GuildControlPopupFrameEditBox
            Skin.FrameTypeEditBox(EditBox)

            local _, _, left, right = EditBox:GetRegions()
            left:Hide()
            right:Hide()
        end


        ---------------
        -- GuildMisc --
        ---------------
        local GuildInfoFrame = _G.GuildInfoFrame
        Base.SetBackdrop(GuildInfoFrame)
        local patch, _, corner = GuildInfoFrame:GetRegions()
        patch:SetAlpha(0)
        corner:SetAlpha(0)

        _G.GuildInfoTextBackground:SetBackdrop(nil)

        Skin.UIPanelScrollFrameTemplate(_G.GuildInfoFrameScrollFrame)
        Skin.UIPanelCloseButton(_G.GuildInfoCloseButton)
        Skin.UIPanelButtonTemplate(_G.GuildInfoSaveButton)
        Skin.UIPanelButtonTemplate(_G.GuildInfoCancelButton)


        local GuildMemberDetailFrame = _G.GuildMemberDetailFrame
        Base.SetBackdrop(GuildMemberDetailFrame)

        patch, corner = select(11, GuildMemberDetailFrame:GetRegions())
        patch:SetAlpha(0)
        corner:SetAlpha(0)

        Skin.UIPanelCloseButton(_G.GuildMemberDetailCloseButton)
        Skin.UIPanelButtonTemplate(_G.GuildMemberRemoveButton)
        Skin.UIPanelButtonTemplate(_G.GuildMemberGroupInviteButton)

        Skin.UIPanelScrollUpButtonTemplate(_G.GuildFramePromoteButton)
        Skin.UIPanelScrollDownButtonTemplate(_G.GuildFrameDemoteButton)

        Skin.FrameTypeEditBox(_G.GuildMemberNoteBackground)
        Skin.FrameTypeEditBox(_G.GuildMemberOfficerNoteBackground)
    end



    ----------------------
    -- FriendsFrameMisc --
    ----------------------
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab1)
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab2)
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab3)
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab4)
    if private.isClassic then
        Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab5)
    end
    Util.PositionRelative("TOPLEFT", FriendsFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.FriendsFrameTab1,
        _G.FriendsFrameTab2,
        _G.FriendsFrameTab3,
        _G.FriendsFrameTab4,
        private.isClassic and _G.FriendsFrameTab5 or nil,
    })

    if private.isRetail and not private.isPatch then
        Skin.GlowBoxTemplate(FriendsFrame.FriendsFrameQuickJoinHelpTip)
    end
    if not private.disabled.tooltips then
        Base.SetBackdrop(_G.FriendsTooltip)
    end







    --------------------
    -- AddFriendFrame --
    --------------------
    if private.isRetail then
        Skin.DialogBorderTemplate(_G.AddFriendFrame.Border)
    else
        Skin.DialogBorderTemplate(_G.AddFriendFrame)
    end
    Skin.UIPanelButtonTemplate(_G.AddFriendInfoFrameContinueButton)

    Skin.UIPanelInfoButton(_G.AddFriendEntryFrameInfoButton)
    do -- AddFriendNameEditBox
        Skin.FrameTypeEditBox(_G.AddFriendNameEditBox)
        _G.AddFriendNameEditBoxLeft:Hide()
        _G.AddFriendNameEditBoxRight:Hide()
        _G.AddFriendNameEditBoxMiddle:Hide()
    end
    Skin.UIPanelButtonTemplate(_G.AddFriendEntryFrameAcceptButton)
    Skin.UIPanelButtonTemplate(_G.AddFriendEntryFrameCancelButton)







    -------------------------
    -- FriendsFriendsFrame --
    -------------------------
    if private.isRetail then
        Skin.DialogBorderTemplate(_G.FriendsFriendsFrame.Border)

        Skin.UIDropDownMenuTemplate(_G.FriendsFriendsFrameDropDown)
        _G.FriendsFriendsFrame.ScrollFrameBorder:SetBackdrop(nil)
        Skin.FriendsFrameScrollFrame(_G.FriendsFriendsScrollFrame)
        Skin.UIPanelButtonTemplate(_G.FriendsFriendsFrame.SendRequestButton)
        Skin.UIPanelButtonTemplate(_G.FriendsFriendsFrame.CloseButton)
    else
        Skin.DialogBorderTemplate(_G.FriendsFriendsFrame)
        Skin.UIDropDownMenuTemplate(_G.FriendsFriendsFrameDropDown)

        _G.FriendsFriendsList:SetBackdrop(nil)
        Skin.FauxScrollFrameTemplate(_G.FriendsFriendsScrollFrame)
        Skin.UIPanelButtonTemplate(_G.FriendsFriendsSendRequestButton)
        Skin.UIPanelButtonTemplate(_G.FriendsFriendsCloseButton)
    end







    --------------------------
    -- BattleTagInviteFrame --
    --------------------------
    if private.isRetail then
        Skin.DialogBorderTemplate(_G.BattleTagInviteFrame.Border)

        local _, send, cancel = _G.BattleTagInviteFrame:GetChildren()
        Skin.UIPanelButtonTemplate(send)
        Skin.UIPanelButtonTemplate(cancel)
    else
        Skin.DialogBorderTemplate(_G.BattleTagInviteFrame)

        local send, cancel = _G.BattleTagInviteFrame:GetChildren()
        Skin.UIPanelButtonTemplate(send)
        Skin.UIPanelButtonTemplate(cancel)
    end
end
