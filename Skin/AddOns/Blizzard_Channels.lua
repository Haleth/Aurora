local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_Channels.lua ]]
    do --[[ ChannelButton.lua ]]
        Hook.ChannelButtonHeaderMixin = {}
        function Hook.ChannelButtonHeaderMixin:Update()
            local count = self:GetMemberCount()
            if count > 0 then
                self.Collapsed.minus:Show()
                if self:IsCollapsed() then
                    self.Collapsed.plus:Show()
                else
                    self.Collapsed.plus:Hide()
                end
            else
                self.Collapsed.minus:Hide()
                self.Collapsed.plus:Hide()
            end
        end
    end
    do --[[ RosterButton.lua ]]
        Hook.ChannelRosterButtonMixin = {}
        function Hook.ChannelRosterButtonMixin:Update()
            if self:IsConnected() ~= false and self.playerLocation then
                local _, classToken = _G.C_PlayerInfo.GetClass(self.playerLocation)
                if classToken then
                    self.Name:SetTextColor(_G.CUSTOM_CLASS_COLORS[classToken]:GetRGB())
                end
            end

        end
    end
end

do --[[ AddOns\Blizzard_Channels.xml ]]
    do --[[ ChannelButton.xml ]]
        Skin.ChannelButtonBaseTemplate = private.nop
        function Skin.ChannelButtonHeaderTemplate(Button)
            _G.hooksecurefunc(Button, "Update", Hook.ChannelButtonHeaderMixin.Update)

            Skin.ChannelButtonBaseTemplate(Button)
            Button:SetNormalTexture("")
            Button:SetHighlightTexture("")
            Base.SetBackdrop(Button, Color.button)
            Base.SetHighlight(Button, "backdrop")

            Button.Collapsed:SetAlpha(0)
            local minus = Button:CreateTexture(nil, "OVERLAY")
            minus:SetPoint("TOPLEFT", Button.Collapsed, 0, -3)
            minus:SetPoint("BOTTOMRIGHT", Button.Collapsed, 0, 3)
            minus:SetColorTexture(1, 1, 1)
            Button.Collapsed.minus = minus

            local plus = Button:CreateTexture(nil, "OVERLAY")
            plus:SetPoint("TOPLEFT", Button.Collapsed, 3, 0)
            plus:SetPoint("BOTTOMRIGHT", Button.Collapsed, -3, 0)
            plus:SetColorTexture(1, 1, 1)
            Button.Collapsed.plus = plus
        end
        function Skin.ChannelButtonTemplate(Button)
            Skin.ChannelButtonBaseTemplate(Button)
        end
        function Skin.ChannelButtonTextTemplate(Button)
            Skin.ChannelButtonTemplate(Button)
        end
        function Skin.ChannelButtonVoiceTemplate(Button)
            Skin.ChannelButtonTemplate(Button)
        end
        function Skin.ChannelButtonCommunityTemplate(Button)
            Skin.ChannelButtonTemplate(Button)
        end
    end
    do --[[ RosterButton.xml ]]
        Skin.ChannelRosterButtonTemplate = private.nop
        function Skin.ChannelRosterButtonTemplate(Button)
            Util.Mixin(Button, Hook.ChannelRosterButtonMixin)
        end
    end
    do --[[ CreateChannelPopup.xml ]]
        function Skin.CreateChannelPopupEditBoxTemplate(EditBox)
            Skin.InputBoxTemplate(EditBox)
        end
        function Skin.CreateChannelPopupButtonTemplate(Button)
            Skin.UIPanelButtonTemplate(Button)
        end
    end
    do --[[ ChannelList.xml ]]
        function Skin.ChannelListTemplate(ScrollFrame)
            Skin.UIPanelStretchableArtScrollBarTemplate(ScrollFrame.ScrollBar)
        end
    end
    do --[[ ChannelRoster.xml ]]
        function Skin.ChannelRosterTemplate(Frame)
            Skin.HybridScrollBarTemplate(Frame.ScrollFrame.scrollBar)
        end
    end
end

function private.AddOns.Blizzard_Channels()
    ----====####$$$$%%%%$$$$####====----
    --           VoiceUtils           --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------


    ----====####$$$$%%%%%$$$$####====----
    --          ChannelButton          --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --          RosterButton          --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --       CreateChannelPopup       --
    ----====####$$$$%%%%$$$$####====----
    local CreateChannelPopup = _G.CreateChannelPopup

    CreateChannelPopup.Title:ClearAllPoints()
    CreateChannelPopup.Title:SetPoint("TOPLEFT")
    CreateChannelPopup.Title:SetPoint("BOTTOMRIGHT", CreateChannelPopup, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    CreateChannelPopup.Titlebar:Hide()
    CreateChannelPopup.Corner:Hide()

    if private.isRetail then
        Skin.DialogBorderTemplate(CreateChannelPopup.BG)
    else
        Skin.DialogBorderTemplate(CreateChannelPopup)
    end
    Skin.CreateChannelPopupEditBoxTemplate(CreateChannelPopup.Name)
    Skin.CreateChannelPopupEditBoxTemplate(CreateChannelPopup.Password)
    Skin.UICheckButtonTemplate(CreateChannelPopup.UseVoiceChat)
    Skin.UIPanelCloseButton(CreateChannelPopup.CloseButton)
    Skin.CreateChannelPopupButtonTemplate(CreateChannelPopup.OKButton)
    CreateChannelPopup.OKButton:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.CreateChannelPopupButtonTemplate(CreateChannelPopup.CancelButton)
    CreateChannelPopup.CancelButton:ClearAllPoints()
    CreateChannelPopup.CancelButton:SetPoint("BOTTOMRIGHT", -5, 5)


    ----====####$$$$%%%%%$$$$####====----
    --           ChannelList           --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    --          ChannelRoster          --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    --         VoiceChatPrompt         --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --          ChannelFrame          --
    ----====####$$$$%%%%$$$$####====----
    local ChannelFrame = _G.ChannelFrame
    Skin.ButtonFrameTemplate(ChannelFrame)
    ChannelFrame.Icon:Hide()

    Skin.UIPanelButtonTemplate(ChannelFrame.NewButton)
    ChannelFrame.NewButton:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.UIPanelButtonTemplate(ChannelFrame.SettingsButton)
    ChannelFrame.SettingsButton:SetPoint("BOTTOMRIGHT", -5, 5)
    Skin.ChannelListTemplate(ChannelFrame.ChannelList)
    ChannelFrame.ChannelList:SetPoint("TOPLEFT", 7, -(private.FRAME_TITLE_HEIGHT + 20))
    Skin.InsetFrameTemplate(ChannelFrame.LeftInset)
    Skin.ChannelRosterTemplate(ChannelFrame.ChannelRoster)
    ChannelFrame.ChannelRoster:SetPoint("TOPRIGHT", -20, -(private.FRAME_TITLE_HEIGHT + 20))
    ChannelFrame.ChannelRoster:SetPoint("BOTTOMRIGHT", -20, 28)
    Skin.InsetFrameTemplate(ChannelFrame.RightInset)

    if not private.isPatch then
        Skin.GlowBoxFrame(ChannelFrame.Tutorial, "Left")
    end

    ----====####$$$$%%%%%$$$$####====----
    --    VoiceActivityNotification    --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    -- VoiceActivityNotificationParty --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    -- VoiceActivityNotificationRoster --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --      VoiceActivityManager      --
    ----====####$$$$%%%%$$$$####====----
end
