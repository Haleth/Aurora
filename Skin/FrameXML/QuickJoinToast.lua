local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\QuickJoinToast.lua ]]
    function Hook.QuickJoinToastMixin_UpdateQueueIcon(self)
        self.FriendsButton:SetTexture([[Interface\FriendsFrame\UI-Toast-FriendOnlineIcon]])
        if self.QueueButton:GetAlpha() > 0 then
            self.FriendsButton:Hide()
            self.FriendCount:Hide()
        else
            self.FriendsButton:Show()
            self.FriendCount:Show()
        end
        if self.isLFGList then
            self.QueueButton:SetTexture([[Interface\FriendsFrame\UI-Toast-ChatInviteIcon]])
            self.FlashingLayer:SetTexture([[Interface\FriendsFrame\UI-Toast-ChatInviteIcon]])
        else
            self.QueueButton:SetTexture([[Interface\LFGFrame\BattlenetWorking0]])
            self.FlashingLayer:SetTexture([[Interface\LFGFrame\BattlenetWorking0]])
        end
    end
end

do --[[ FrameXML\QuickJoinToast.xml ]]
    function Skin.QuickJoinToastTemplate(Frame)
        Frame.Background:SetTexture([[Interface\SpellBook\UI-SpellbookPanel-Tab-Highlight]])
        Frame.Background:SetDesaturated(true)
        Frame.Background:SetVertexColor(Color.grayDark:GetRGB())
        Frame.Background:SetTexCoord(0.15625, 0.890625, 0.28125, 0.6875)
    end
end

-- /run QuickJoinToastButton.FriendToToastAnim:Play()
function private.FrameXML.QuickJoinToast()
    if private.disabled.chat then return end

    local QuickJoinToastButton = _G.QuickJoinToastButton
    _G.hooksecurefunc(QuickJoinToastButton, "UpdateQueueIcon", Hook.QuickJoinToastMixin_UpdateQueueIcon)

    QuickJoinToastButton:SetSize(24, 32)
    Base.SetBackdrop(QuickJoinToastButton, Color.button)

    QuickJoinToastButton.FriendsButton:SetTexture([[Interface\FriendsFrame\UI-Toast-FriendOnlineIcon]])
    QuickJoinToastButton.FriendsButton:ClearAllPoints()
    QuickJoinToastButton.FriendsButton:SetPoint("CENTER", 0, 3)
    QuickJoinToastButton.FriendsButton:SetSize(30, 30)

    QuickJoinToastButton.QueueButton:SetTexture([[Interface\FriendsFrame\UI-Toast-ChatInviteIcon]])
    QuickJoinToastButton.QueueButton:ClearAllPoints()
    QuickJoinToastButton.QueueButton:SetPoint("CENTER", 0, 3)
    QuickJoinToastButton.QueueButton:SetSize(28, 28)

    QuickJoinToastButton.FlashingLayer:SetTexture([[Interface\FriendsFrame\UI-Toast-ChatInviteIcon]])
    QuickJoinToastButton.FlashingLayer:ClearAllPoints()
    QuickJoinToastButton.FlashingLayer:SetPoint("CENTER", 0, 3)
    QuickJoinToastButton.FlashingLayer:SetSize(28, 28)

    Skin.QuickJoinToastTemplate(QuickJoinToastButton.Toast)
    Skin.QuickJoinToastTemplate(QuickJoinToastButton.Toast2)

    -------------
    -- Section --
    -------------
end
