local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\RecruitAFriendFrame.lua ]]
    Hook.RecruitAFriendRewardButtonWithCheckMixin = {}
    function Hook.RecruitAFriendRewardButtonWithCheckMixin:Setup(rewardInfo, tooltipRightAligned)
        if not rewardInfo.claimed and not rewardInfo.canClaim then
            self._auroraBorder:SetColorTexture(_G.SEPIA_COLOR:GetRGBA())
        else
            if rewardInfo.rewardType == _G.Enum.RafRewardType.GameTime then
                self._auroraBorder:SetColorTexture(_G.HEIRLOOM_BLUE_COLOR:GetRGBA())
            else
                self._auroraBorder:SetColorTexture(_G.EPIC_PURPLE_COLOR:GetRGBA())
            end
        end
    end

    Hook.RecruitAFriendRewardButtonWithFanfareMixin = {}
    function Hook.RecruitAFriendRewardButtonWithFanfareMixin:Setup(rewardInfo, tooltipRightAligned)
        if not rewardInfo.claimed and not rewardInfo.canClaim then
            self.IconBorder:SetAtlas("RecruitAFriend_ClaimPane_SepiaRing", true)
        else
            self.IconBorder:SetAtlas("RecruitAFriend_ClaimPane_GoldRing", true)
        end
    end
end

do --[[ FrameXML\RecruitAFriendFrame.xml ]]
    function Skin.RecruitAFriendRewardButtonTemplate(Button)
        Button._auroraBorder = Base.CropIcon(Button.Icon, Button)
        if Button.IconBorder then
            Button.IconBorder:Hide()
            Button._auroraBorder:SetColorTexture(_G.SEPIA_COLOR:GetRGBA())
        end
    end
    function Skin.RecruitAFriendRewardTemplate(Frame)
        Util.Mixin(Frame.Button, Hook.RecruitAFriendRewardButtonWithCheckMixin)
        Skin.RecruitAFriendRewardButtonTemplate(Frame.Button)
        Base.CropIcon(Frame.Button:GetHighlightTexture())
    end
end

function private.FrameXML.RecruitAFriendFrame()
    --------------------------------
    -- RecruitAFriendRewardsFrame --
    --------------------------------
    local RecruitAFriendRewardsFrame = _G.RecruitAFriendRewardsFrame
    RecruitAFriendRewardsFrame.Background:Hide()
    RecruitAFriendRewardsFrame.Bracket_TopLeft:Hide()
    RecruitAFriendRewardsFrame.Bracket_TopRight:Hide()
    RecruitAFriendRewardsFrame.Bracket_BottomRight:Hide()
    RecruitAFriendRewardsFrame.Bracket_BottomLeft:Hide()

    Util.Mixin(RecruitAFriendRewardsFrame.rewardPool, Hook.ObjectPoolMixin)
    Hook.ObjectPoolMixin.Acquire(RecruitAFriendRewardsFrame.rewardPool)

    Skin.DialogBorderTranslucentTemplate(RecruitAFriendRewardsFrame.Border)
    RecruitAFriendRewardsFrame.Border:SetBackdropOption("offsets", {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
    })
    Skin.UIPanelCloseButton(RecruitAFriendRewardsFrame.CloseButton)


    ------------------------------------
    -- RecruitAFriendRecruitmentFrame --
    ------------------------------------
    local RecruitAFriendRecruitmentFrame = _G.RecruitAFriendRecruitmentFrame
    Skin.DialogBorderTranslucentTemplate(RecruitAFriendRecruitmentFrame.Border)
    Skin.UIPanelCloseButton(RecruitAFriendRecruitmentFrame.CloseButton)
    Skin.FriendsFrameButtonTemplate(RecruitAFriendRecruitmentFrame.GenerateOrCopyLinkButton)
    Skin.InputBoxTemplate(RecruitAFriendRecruitmentFrame.EditBox)


    -------------------------
    -- RecruitAFriendFrame --
    -------------------------
    local RecruitAFriendFrame =_G.RecruitAFriendFrame

    local RewardClaiming = RecruitAFriendFrame.RewardClaiming
    RewardClaiming.Background:Hide()
    RewardClaiming.Bracket_TopLeft:Hide()
    RewardClaiming.Bracket_TopRight:Hide()
    RewardClaiming.Bracket_BottomRight:Hide()
    RewardClaiming.Bracket_BottomLeft:Hide()

    local NextRewardButton = RewardClaiming.NextRewardButton
    Skin.RecruitAFriendRewardButtonTemplate(NextRewardButton)
    Util.Mixin(NextRewardButton, Hook.RecruitAFriendRewardButtonWithFanfareMixin)
    NextRewardButton:ClearAllPoints()
    NextRewardButton:SetPoint("TOPLEFT", 21, -25)
    NextRewardButton.CircleMask:Hide()
    NextRewardButton.IconBorder:Hide()

    Skin.InsetFrameTemplate(RewardClaiming.Inset)
    Skin.FriendsFrameButtonTemplate(RewardClaiming.ClaimOrViewRewardButton)

    Skin.FriendsFrameButtonTemplate(RecruitAFriendFrame.RecruitmentButton)
    Skin.UIDropDownMenuTemplate(RecruitAFriendFrame.DropDown)

    local RecruitList = RecruitAFriendFrame.RecruitList
    RecruitList.Header.Background:Hide()
    Skin.InsetFrameTemplate(RecruitList.ScrollFrameInset)
    Skin.FriendsFrameScrollFrame(RecruitList.ScrollFrame)

    -- /run RecruitAFriendFrame:ShowSplashScreen()
    local SplashFrame = RecruitAFriendFrame.SplashFrame
    Skin.FriendsFrameButtonTemplate(SplashFrame.OKButton)
    SplashFrame.Background:SetColorTexture(Color.frame.r, Color.frame.g, Color.frame.b, 0.9)
    SplashFrame.PictureFrame:Hide()

    SplashFrame.Bracket_TopLeft:Hide()
    SplashFrame.Bracket_TopRight:Hide()
    SplashFrame.Bracket_BottomRight:Hide()
    SplashFrame.Bracket_BottomLeft:Hide()
    SplashFrame.PictureFrame_Bracket_TopLeft:Hide()
    SplashFrame.PictureFrame_Bracket_TopRight:Hide()
    SplashFrame.PictureFrame_Bracket_BottomRight:Hide()
    SplashFrame.PictureFrame_Bracket_BottomLeft:Hide()
end
