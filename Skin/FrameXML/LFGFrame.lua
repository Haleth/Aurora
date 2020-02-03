local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals pairs hooksecurefunc

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\LFGFrame.lua ]]
    function Hook.LFG_SetRoleIconIncentive(roleButton, incentiveIndex)
        local roleIcon = roleButton:GetNormalTexture()
        if incentiveIndex then
            roleIcon._auroraBorder:SetColorTexture(Color.yellow:GetRGB())
        else
            roleIcon._auroraBorder:SetColorTexture(Color.black:GetRGB())
        end
    end
    function Hook.LFGDungeonReadyPopup_Update()
        local proposalExists, _, _, subtypeID, _, _, role, hasResponded, _, _, _, _, _, _, isSilent = _G.GetLFGProposal()
        if not proposalExists or isSilent then
            return
        end

        --When the group doesn't require a role (like scenarios and legacy raids), we get "NONE" as the role
        if role == "NONE" then
            role = "DAMAGER"
        end

        Base.SetBackdrop(_G.LFGDungeonReadyDialog, Color.frame)
        if not hasResponded then
            if subtypeID == _G.LFG_SUBTYPEID_RAID then
                _G.LFGDungeonReadyDialog:SetBackdropBorderColor(Color.yellow)
            end

            if _G.LFGDungeonReadyDialogRoleIcon:IsShown() then
                Base.SetTexture(_G.LFGDungeonReadyDialogRoleIconTexture, "icon"..role)
            end
        end
    end
    function Hook.LFGDungeonReadyStatusIndividual_UpdateIcon(button)
        local _, role = _G.GetLFGProposalMember(button:GetID())
        Base.SetTexture(button.texture, "icon"..role)

        if not button._auroraSkinned then
            Skin.LFGDungeonReadyStatusPlayerTemplate(button)
            button._auroraSkinned = true
        end
    end
    function Hook.LFGRewardsFrame_SetItemButton(parentFrame, dungeonID, index, id, name, texture, numItems, rewardType, rewardID, quality, shortageIndex, showTankIcon, showHealerIcon, showDamageIcon)
        local parentName = parentFrame:GetName()
        local frame = _G[parentName.."Item"..index]

        if not frame._auroraIconBorder then
            Skin.LFGRewardsLootTemplate(frame)
        end

        if shortageIndex then
            frame._auroraIconBorder:SetBackdropBorderColor(Color.yellow)
        end
    end
    function Hook.LFGCooldownCover_Update(self)
        local nextIndex, numPlayers, prefix = 1
        if _G.IsInRaid() then
            numPlayers = _G.GetNumGroupMembers()
            prefix = "raid"
        else
            numPlayers = _G.GetNumSubgroupMembers()
            prefix = "party"
        end

        for i = 1, numPlayers do
            if nextIndex > #self.Names then
                break
            end

            local unit = prefix..i
            if _G.UnitHasLFGDeserter(unit) or (self.showCooldown and _G.UnitHasLFGRandomCooldown(unit)) or self.showAll then
                local _, classToken = _G.UnitName(unit)
                local classColor = classToken and _G.CUSTOM_CLASS_COLORS[classToken]
                if classColor then
                    self.Names[nextIndex]:SetFormattedText("|c%s%s|r", classColor.colorStr, _G.GetUnitName(unit, true))
                end
                nextIndex = nextIndex + 1
            end
        end
    end
end

do --[[ FrameXML\LFGFrame.xml ]]
    function Skin.LFGRoleButtonTemplate(Button)
        Button.cover:SetColorTexture(0, 0, 0, 0.75)
        Base.SetTexture(Button:GetNormalTexture(), "icon"..(Button.role or "GUIDE"))
        Skin.UICheckButtonTemplate(Button.checkButton)
        Button.checkButton:SetPoint("BOTTOMLEFT", -4, -4)
    end
    function Skin.LFGRoleButtonWithBackgroundTemplate(Button)
        Skin.LFGRoleButtonTemplate(Button)
    end
    function Skin.LFGRoleButtonWithBackgroundAndRewardTemplate(Button)
        Skin.LFGRoleButtonWithBackgroundTemplate(Button)
        Button.shortageBorder:SetAlpha(0)

        local incentiveIcon = Button.incentiveIcon
        incentiveIcon:SetSize(14, 14)
        incentiveIcon:SetPoint("BOTTOMRIGHT", -1, 1)

        incentiveIcon.texture:SetAllPoints(incentiveIcon)
        Base.CropIcon(incentiveIcon.texture)

        local border = incentiveIcon.border
        border:SetDrawLayer("ARTWORK", -2)
        border:SetColorTexture(Color.yellow:GetRGB())
        border:SetPoint("TOPLEFT", incentiveIcon.texture, -1, 1)
        border:SetPoint("BOTTOMRIGHT", incentiveIcon.texture, 1, -1)
    end
    function Skin.LFGSpecificChoiceTemplate(Frame)
        Skin.UICheckButtonTemplate(Frame.enableButton)
        Skin.ExpandOrCollapse(Frame.expandOrCollapseButton)
    end
    function Skin.LFGDungeonReadyRewardTemplate(Frame)
        Base.CropIcon(Frame.texture, Frame)
        _G[Frame:GetName().."Border"]:Hide()
    end


    function Skin.LFGRewardsLootShortageTemplate(Frame)
        Base.SetTexture(Frame.texture, "icon"..(Frame.role or "GUIDE"))
    end
    function Skin.LFGRewardsLootTemplate(Button)
        Skin.LargeItemButtonTemplate(Button)
        Button.shortageBorder:SetAlpha(0)
        Button.IconBorder:SetAlpha(0)
        Skin.LFGRewardsLootShortageTemplate(Button.roleIcon1)
        Skin.LFGRewardsLootShortageTemplate(Button.roleIcon2)
    end
    function Skin.LFGRewardFrameTemplate(Frame)
        local name = Frame:GetName()
        Skin.LFGRewardsLootTemplate(_G[name.."Item1"])
        Skin.LargeItemButtonTemplate(Frame.MoneyReward)
    end


    function Skin.LFGDungeonReadyStatusPlayerTemplate(Frame)
        Frame.texture:ClearAllPoints()
        Frame.texture:SetPoint("TOPLEFT", 1, -1)
        Frame.texture:SetPoint("BOTTOMRIGHT", -1, 1)

        Frame.statusIcon:SetPoint("BOTTOMLEFT", -5, -5)
    end


    function Skin.LFGCooldownCoverTemplate(Frame)
    end
    function Skin.LFGBackfillCoverTemplate(Frame)
        local name = Frame:GetName()
        Skin.UIPanelButtonTemplate(_G[name.."BackfillButton"])
        Skin.UIPanelButtonTemplate(_G[name.."NoBackfillButton"])
    end
end

function private.FrameXML.LFGFrame()
    _G.hooksecurefunc("LFG_SetRoleIconIncentive", Hook.LFG_SetRoleIconIncentive)
    _G.hooksecurefunc("LFGDungeonReadyPopup_Update", Hook.LFGDungeonReadyPopup_Update)
    _G.hooksecurefunc("LFGDungeonReadyStatusIndividual_UpdateIcon", Hook.LFGDungeonReadyStatusIndividual_UpdateIcon)
    _G.hooksecurefunc("LFGRewardsFrame_SetItemButton", Hook.LFGRewardsFrame_SetItemButton)
    _G.hooksecurefunc("LFGCooldownCover_Update", Hook.LFGCooldownCover_Update)


    --------------------------
    -- LFGDungeonReadyPopup --
    --------------------------
    Skin.DialogBorderTemplate(_G.LFGDungeonReadyStatus.Border)
    Skin.MinimizeButton(_G.LFGDungeonReadyStatusCloseButton)

    local LFGDungeonReadyDialog = _G.LFGDungeonReadyDialog
    Skin.DialogBorderTemplate(LFGDungeonReadyDialog.Border)

    LFGDungeonReadyDialog.background:ClearAllPoints()
    LFGDungeonReadyDialog.background:SetPoint("TOPLEFT", 1, -1)
    LFGDungeonReadyDialog.background:SetPoint("BOTTOMRIGHT", -1, 64)

    LFGDungeonReadyDialog.filigree:Hide()
    LFGDungeonReadyDialog.bottomArt:Hide()

    Skin.MinimizeButton(_G.LFGDungeonReadyDialogCloseButton)
    Skin.UIPanelButtonTemplate(LFGDungeonReadyDialog.enterButton)
    Skin.UIPanelButtonTemplate(LFGDungeonReadyDialog.leaveButton)

    _G.LFGDungeonReadyDialogRoleIcon:SetSize(64, 64)
    _G.LFGDungeonReadyDialogRoleIcon:ClearAllPoints()
    _G.LFGDungeonReadyDialogRoleIcon:SetPoint("BOTTOMLEFT", 121, 57)
    _G.LFGDungeonReadyDialogRoleIconLeaderIcon:SetPoint("TOPLEFT")
    Base.SetTexture(_G.LFGDungeonReadyDialogRoleIconLeaderIcon, "iconGUIDE")

    Skin.LFGDungeonReadyRewardTemplate(_G.LFGDungeonReadyDialogRewardsFrame.Rewards[1])
    Skin.LFGDungeonReadyRewardTemplate(_G.LFGDungeonReadyDialogRewardsFrame.Rewards[2])


    --------------------
    -- LFGInvitePopup --
    --------------------
    local LFGInvitePopup = _G.LFGInvitePopup
    Skin.DialogBorderTemplate(LFGInvitePopup.Border)

    LFGInvitePopup.RoleButtons[1]:SetPoint("TOPLEFT", 35, -35)
    for i = 1, #LFGInvitePopup.RoleButtons do
        Skin.LFGRoleButtonTemplate(LFGInvitePopup.RoleButtons[i])
    end
    Skin.UIPanelButtonTemplate(_G.LFGInvitePopupAcceptButton)
    Skin.UIPanelButtonTemplate(_G.LFGInvitePopupDeclineButton)
    Util.PositionRelative("BOTTOMLEFT", LFGInvitePopup, "BOTTOMLEFT", 37, 25, 5, "Right", {
        _G.LFGInvitePopupAcceptButton,
        _G.LFGInvitePopupDeclineButton,
    })
end
