local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

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
    do --[[ ChannelRoster.lua ]]
        Hook.ChannelRosterMixin = {}
        function Hook.ChannelRosterMixin:UpdateRosterWidth()
            local rosterLeftEdge = self:GetChannelFrame().LeftInset:GetRight();
            local rosterRightEdge = self.ScrollFrame.scrollBar:GetLeft();

            if self:GetChannelFrame():GetList().ScrollBar:IsShown() then
                rosterLeftEdge = self:GetChannelFrame():GetList().ScrollBar:GetRight();
            end

            -- Add some padding for the inset and scrollbar textures.
            local rosterWidth = rosterRightEdge - rosterLeftEdge;
            Scale.RawSetWidth(self, rosterWidth);
            Scale.RawSetWidth(self.ScrollFrame.scrollChild, rosterWidth - Scale.Value(9)); -- Sizing hack, pull the edge of the scroll child inside the right scrollbar.
        end
    end
end

do --[[ AddOns\Blizzard_Channels.xml ]]
    do --[[ ChannelButton.xml ]]
        function Skin.ChannelButtonBaseTemplate(Button)
            --[[ Scale ]]--
            Button:SetSize(Button:GetSize())
            Button.Text:SetHeight(0)
            Button.Text:SetPoint("LEFT", 6, 0)
            Button.Text:SetPoint("RIGHT", -6, 0)
        end
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

            --[[ Scale ]]--
            Button.Collapsed:SetSize(7, 7)
            Button.Collapsed:SetPoint("TOPRIGHT", -8, -6)
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
        function Skin.ChannelRosterButtonTemplate(Button)
            --[[ Scale ]]--
            Button:SetSize(Button:GetSize())
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
            _G.hooksecurefunc(ScrollFrame.headerButtonPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
            _G.hooksecurefunc(ScrollFrame.textChannelButtonPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
            _G.hooksecurefunc(ScrollFrame.voiceChannelButtonPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
            _G.hooksecurefunc(ScrollFrame.communityChannelButtonPool, "Acquire", Hook.ObjectPoolMixin_Acquire)

            Skin.UIPanelStretchableArtScrollBarTemplate(ScrollFrame.ScrollBar)
        end
    end
    do --[[ ChannelRoster.xml ]]
        function Skin.ChannelRosterTemplate(Frame)
            _G.hooksecurefunc(Frame, "UpdateRosterWidth", Hook.ChannelRosterMixin.UpdateRosterWidth)

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

    --[[ Scale ]]--



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
    Base.SetBackdrop(CreateChannelPopup)

    CreateChannelPopup.Title:ClearAllPoints()
    CreateChannelPopup.Title:SetPoint("TOPLEFT")
    CreateChannelPopup.Title:SetPoint("BOTTOMRIGHT", CreateChannelPopup, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    CreateChannelPopup.Titlebar:Hide()
    CreateChannelPopup.Corner:Hide()

    Skin.CreateChannelPopupEditBoxTemplate(CreateChannelPopup.Name)
    Skin.CreateChannelPopupEditBoxTemplate(CreateChannelPopup.Password)
    Skin.UICheckButtonTemplate(CreateChannelPopup.UseVoiceChat)
    Skin.UIPanelCloseButton(CreateChannelPopup.CloseButton)
    CreateChannelPopup.CloseButton:SetPoint("TOPRIGHT", -5, -5)
    Skin.CreateChannelPopupButtonTemplate(CreateChannelPopup.OKButton)
    CreateChannelPopup.OKButton:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.CreateChannelPopupButtonTemplate(CreateChannelPopup.CancelButton)
    CreateChannelPopup.CancelButton:ClearAllPoints()
    CreateChannelPopup.CancelButton:SetPoint("BOTTOMRIGHT", -5, 5)

    --[[ Scale ]]--
    CreateChannelPopup:SetSize(212, 200)
    CreateChannelPopup.Name:SetPoint("TOPLEFT", 23, -60)
    CreateChannelPopup.Name.Label:SetPoint("BOTTOMLEFT", CreateChannelPopup.Name, "TOPLEFT", 0, 5)
    CreateChannelPopup.Password:SetPoint("TOPLEFT", CreateChannelPopup.Name, "BOTTOMLEFT", 0, -30)
    CreateChannelPopup.Password.Label:SetPoint("BOTTOMLEFT", CreateChannelPopup.Password, "TOPLEFT", 0, 5)
    CreateChannelPopup.UseVoiceChat:SetPoint("TOPLEFT", CreateChannelPopup.Password, "BOTTOMLEFT", -7, -14)


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

    Skin.GlowBoxFrame(ChannelFrame.Tutorial, "Left")

    --[[ Scale ]]--
    ChannelFrame.ChannelList:SetWidth(178)

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
