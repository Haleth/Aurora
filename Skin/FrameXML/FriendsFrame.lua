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
        gameIcon._bg:SetShown(gameIcon:IsShown())
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
        travelPassButton:SetNormalTexture("")
        travelPassButton:SetPushedTexture("")
        travelPassButton:SetDisabledTexture("")
        travelPassButton:SetHighlightTexture("")

        travelPassButton._tex = travelPassButton:CreateTexture(nil, "OVERLAY", nil, 7)
        travelPassButton._tex:SetTexture([[Interface\FriendsFrame\PlusManz-PlusManz]])
        travelPassButton._tex:SetPoint("TOPRIGHT", 1, -4)
        travelPassButton._tex:SetSize(22, 22)
        travelPassButton._tex:SetAlpha(0.5)
    end
    function Skin.WhoFrameColumnHeaderTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
        Button.HighlightTexture:SetAlpha(0)
    end
    function Skin.FriendsFrameTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
end

function private.FrameXML.FriendsFrame()
    _G.hooksecurefunc("FriendsFrame_UpdateFriendButton", Hook.FriendsFrame_UpdateFriendButton)

    local FriendsFrame = _G.FriendsFrame
    Skin.ButtonFrameTemplate(FriendsFrame)
    _G.FriendsFrameIcon:Hide()

    ----------------------
    -- FriendsTabHeader --
    ----------------------
    local FriendsTabHeader = FriendsFrame.FriendsTabHeader
    local BNetFrame = _G.FriendsFrameBattlenetFrame
    BNetFrame:GetRegions():Hide() -- BattleTag background
    BNetFrame:SetWidth(245)
    BNetFrame:SetPoint("TOPLEFT", 54, -26)
    Base.SetBackdrop(BNetFrame, _G.FRIENDS_BNET_BACKGROUND_COLOR, Color.frame.a)

    do -- BNetFrame.BroadcastButton
        local Button = BNetFrame.BroadcastButton
        Button:GetNormalTexture():SetAlpha(0)
        Button:GetPushedTexture():SetAlpha(0)
        Button:SetHighlightTexture("")
        local icon = Button:CreateTexture(nil, "ARTWORK")
        icon:SetTexture([[Interface\FriendsFrame\BroadcastIcon]])
        icon:SetSize(16, 16)
        icon:SetPoint("CENTER")

        Base.SetBackdrop(Button, Color.button)
        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 5, -5)
        bg:SetPoint("BOTTOMRIGHT", -5, 5)
        Base.SetHighlight(Button, "backdrop")
    end

    Skin.UIPanelInfoButton(BNetFrame.UnavailableInfoButton)

    local BroadcastFrame = BNetFrame.BroadcastFrame
    Skin.DialogBorderOpaqueTemplate(BroadcastFrame.Border)
    BroadcastFrame:SetPoint("TOPLEFT", -55, -24)

    do -- BroadcastFrame.EditBox
        local EditBox = private.isPatch and BroadcastFrame.EditBox or BroadcastFrame.ScrollFrame
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
        Base.SetBackdrop(EditBox, Color.frame)
        EditBox:SetBackdropBorderColor(Color.button)

        local bg = EditBox:GetBackdropTexture("bg")
        bg:ClearAllPoints()
        bg:SetPoint("TOPLEFT", -3, 2)
        bg:SetPoint("BOTTOMRIGHT", 3, -2)
    end


    if private.isPatch then
        Skin.FriendsFrameButtonTemplate(BroadcastFrame.UpdateButton)
        Skin.FriendsFrameButtonTemplate(BroadcastFrame.CancelButton)
    else
        Skin.FriendsFrameButtonTemplate(BroadcastFrame.ScrollFrame.UpdateButton)
        Skin.FriendsFrameButtonTemplate(BroadcastFrame.ScrollFrame.CancelButton)
    end

    Skin.DialogBorderTemplate(BNetFrame.UnavailableInfoFrame)
    local _, blizzIcon = select(11, BNetFrame.UnavailableInfoFrame:GetRegions())
    blizzIcon:SetTexture([[Interface\Glues\MainMenu\Glues-BlizzardLogo]])

    Skin.UIDropDownMenuTemplate(_G.FriendsFrameStatusDropDown)
    _G.FriendsFrameStatusDropDown:SetPoint("TOPLEFT", -12, -27)
    if private.isPatch then
        Skin.FriendsTabTemplate(FriendsTabHeader.Tab1)
        Skin.FriendsTabTemplate(FriendsTabHeader.Tab2)
        Skin.FriendsTabTemplate(FriendsTabHeader.Tab3)
    else
        Skin.FriendsTabTemplate(_G.FriendsTabHeaderTab1)
        Skin.FriendsTabTemplate(_G.FriendsTabHeaderTab2)
        Skin.FriendsTabTemplate(_G.FriendsTabHeaderTab3)
    end


    ----------------------
    -- FriendsListFrame --
    ----------------------
    local FriendsListFrame = _G.FriendsListFrame
    Skin.FriendsFrameButtonTemplate(_G.FriendsFrameAddFriendButton)
    Skin.FriendsFrameButtonTemplate(_G.FriendsFrameSendMessageButton)
    Skin.UIDropDownMenuTemplate(FriendsListFrame.FilterDropDown)
    Skin.UIPanelButtonTemplate(FriendsListFrame.RIDWarning:GetChildren()) -- ContinueButton
    if private.isPatch then
        Skin.FriendsFrameScrollFrame(_G.FriendsListFrameScrollFrame)
        Hook.HybridScrollFrame_CreateButtons(_G.FriendsListFrameScrollFrame, "FriendsListButtonTemplate") -- Called here since the original is called OnLoad
    else
        _G.FriendsFrameFriendsScrollFrameTop:Hide()
        _G.FriendsFrameFriendsScrollFrameMiddle:Hide()
        _G.FriendsFrameFriendsScrollFrameBottom:Hide()
        Skin.UIMenuButtonStretchTemplate(_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton)
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
    if private.isPatch then
        Skin.FriendsFrameScrollFrame(_G.IgnoreListFrameScrollFrame)
    else
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
    Skin.InsetFrameTemplate(_G.WhoFrameEditBoxInset)
    if private.isPatch then
        Skin.FriendsFrameScrollFrame(_G.WhoListScrollFrame)
    else
        Skin.FauxScrollFrameTemplate(_G.WhoListScrollFrame)
    end


    ----------------------
    -- FriendsFrameMisc --
    ----------------------
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab1)
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab2)
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab3)
    if private.isPatch then
        Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab4)
    end
    Util.PositionRelative("TOPLEFT", FriendsFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.FriendsFrameTab1,
        _G.FriendsFrameTab2,
        _G.FriendsFrameTab3,
        _G.FriendsFrameTab4,
    })

    if private.isPatch then
        Skin.GlowBoxTemplate(FriendsFrame.FriendsFrameQuickJoinHelpTip)
    end
    if not private.disabled.tooltips then
        Base.SetBackdrop(_G.FriendsTooltip)
    end







    --------------------
    -- AddFriendFrame --
    --------------------
    Skin.DialogBorderTemplate(_G.AddFriendFrame.Border)
    Skin.UIPanelButtonTemplate(_G.AddFriendInfoFrameContinueButton)

    Skin.UIPanelInfoButton(_G.AddFriendEntryFrameInfoButton)
    do -- AddFriendNameEditBox
        _G.AddFriendNameEditBoxLeft:Hide()
        _G.AddFriendNameEditBoxRight:Hide()
        _G.AddFriendNameEditBoxMiddle:Hide()
        Base.SetBackdrop(_G.AddFriendNameEditBox, Color.frame)
        _G.AddFriendNameEditBox:SetBackdropBorderColor(Color.button)
    end
    Skin.UIPanelButtonTemplate(_G.AddFriendEntryFrameAcceptButton)
    Skin.UIPanelButtonTemplate(_G.AddFriendEntryFrameCancelButton)







    -------------------------
    -- FriendsFriendsFrame --
    -------------------------
    Skin.DialogBorderTemplate(_G.FriendsFriendsFrame.Border)
    Skin.UIDropDownMenuTemplate(_G.FriendsFriendsFrameDropDown)
    if private.isPatch then
        _G.FriendsFriendsFrame.ScrollFrameBorder:SetBackdrop(nil)
        Skin.FriendsFrameScrollFrame(_G.FriendsFriendsScrollFrame)
        Skin.UIPanelButtonTemplate(_G.FriendsFriendsFrame.SendRequestButton)
        Skin.UIPanelButtonTemplate(_G.FriendsFriendsFrame.CloseButton)
    else
        _G.FriendsFriendsList:SetBackdrop(nil)
        Skin.FauxScrollFrameTemplate(_G.FriendsFriendsScrollFrame)
        Skin.UIPanelButtonTemplate(_G.FriendsFriendsSendRequestButton)
        Skin.UIPanelButtonTemplate(_G.FriendsFriendsCloseButton)
    end







    --------------------------
    -- BattleTagInviteFrame --
    --------------------------
    Skin.DialogBorderTemplate(_G.BattleTagInviteFrame.Border)
    local _, send, cancel = _G.BattleTagInviteFrame:GetChildren()
    Skin.UIPanelButtonTemplate(send)
    Skin.UIPanelButtonTemplate(cancel)
end
