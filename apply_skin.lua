local ADDON_NAME, private = ...
local F, C = _G.unpack(private.Aurora)

function private.ApplySkin()
  local red, green, blue = C.r, C.g, C.b
  local classDisplayName, class = _G.UnitClass("player")
  -- [[ Headers ]]

  local header = {"GameMenuFrame", "AudioOptionsFrame", "ColorPickerFrame"}
  for i = 1, #header do
    local title = _G[header[i].."Header"]
    if title then
      title:SetTexture("")
      title:ClearAllPoints()
      if title == _G["GameMenuFrameHeader"] then
        title:SetPoint("TOP", _G.GameMenuFrame, 0, 7)
      else
        title:SetPoint("TOP", header[i], 0, 0)
      end
    end
  end

  -- [[ Simple backdrops ]]

  local bds = {"AutoCompleteBox", "TicketStatusFrameButton", "GearManagerDialogPopup", "RaidInfoFrame", "ScrollOfResurrectionSelectionFrame", "ScrollOfResurrectionFrame", "VoiceChatTalkers", "ReportPlayerNameDialog", "ReportCheatingDialog"}

  for i = 1, #bds do
    local bd = _G[bds[i]]
    if bd then
      F.CreateBD(bd)
    else
      _G.print("Aurora: "..bds[i].." was not found.")
    end
  end

  local lightbds = {"SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4", "FriendsFriendsList", "HelpFrameGM_ResponseScrollFrame1", "HelpFrameGM_ResponseScrollFrame2", "AddFriendNoteFrame", "ScrollOfResurrectionSelectionFrameList", "HelpFrameReportBugScrollFrame", "HelpFrameSubmitSuggestionScrollFrame", "ReportPlayerNameDialogCommentFrame", "ReportCheatingDialogCommentFrame"}
  for i = 1, #lightbds do
    local bd = _G[lightbds[i]]
    if bd then
      F.CreateBD(bd, .25)
    else
      _G.print("Aurora: "..lightbds[i].." was not found.")
    end
  end

  -- [[ Scroll bars ]]

  local scrollbars = {"LFDQueueFrameSpecificListScrollFrameScrollBar", "HelpFrameKnowledgebaseScrollFrameScrollBar", "HelpFrameReportBugScrollFrameScrollBar", "HelpFrameSubmitSuggestionScrollFrameScrollBar", "PaperDollTitlesPaneScrollBar", "PaperDollEquipmentManagerPaneScrollBar", "RaidInfoScrollFrameScrollBar", "FriendsFriendsScrollFrameScrollBar", "HelpFrameGM_ResponseScrollFrame1ScrollBar", "HelpFrameGM_ResponseScrollFrame2ScrollBar", "HelpFrameKnowledgebaseScrollFrame2ScrollBar", "WhoListScrollFrameScrollBar", "GearManagerDialogPopupScrollFrameScrollBar", "LFDQueueFrameRandomScrollFrameScrollBar", "ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar", "ChannelRosterScrollFrameScrollBar"}
  for i = 1, #scrollbars do
    local scrollbar = _G[scrollbars[i]]
    if scrollbar then
      F.ReskinScroll(scrollbar)
    else
      _G.print("Aurora: "..scrollbars[i].." was not found.")
    end
  end

  -- [[ Dropdowns ]]

  for _, dropdown in pairs({"LFDQueueFrameTypeDropDown", "WhoFrameDropDown", "FriendsFriendsFrameDropDown", "RaidFinderQueueFrameSelectionDropDown", "Advanced_GraphicsAPIDropDown"}) do
    F.ReskinDropDown(_G[dropdown])
  end

  -- [[ Input frames ]]

  for _, input in pairs({"AddFriendNameEditBox", "GearManagerDialogPopupEditBox", "HelpFrameKnowledgebaseSearchBox", "ChannelFrameDaughterFrameChannelName", "ChannelFrameDaughterFrameChannelPassword", "ScrollOfResurrectionSelectionFrameTargetEditBox", "ScrollOfResurrectionFrameNoteFrame", "FriendsFrameBroadcastInput"}) do
    F.ReskinInput(_G[input])
  end

  -- [[ Arrows ]]

  F.ReskinArrow(_G.SpellBookPrevPageButton, "left")
  F.ReskinArrow(_G.SpellBookNextPageButton, "right")
  F.ReskinArrow(_G.InboxPrevPageButton, "left")
  F.ReskinArrow(_G.InboxNextPageButton, "right")
  F.ReskinArrow(_G.TabardCharacterModelRotateLeftButton, "left")
  F.ReskinArrow(_G.TabardCharacterModelRotateRightButton, "right")

  -- [[ Radio buttons ]]

  local radiobuttons = {"ReportPlayerNameDialogPlayerNameCheckButton", "ReportPlayerNameDialogGuildNameCheckButton"}
  for i = 1, #radiobuttons do
    local radiobutton = _G[radiobuttons[i]]
    if radiobutton then
      F.ReskinRadio(radiobutton)
    else
      _G.print("Aurora: "..radiobuttons[i].." was not found.")
    end
  end

  -- [[ Backdrop frames ]]

  F.SetBD(_G.HelpFrame)
  F.SetBD(_G.RaidParentFrame)

  local FrameBDs = {"GameMenuFrame", "AudioOptionsFrame", "StackSplitFrame", "AddFriendFrame", "FriendsFriendsFrame", "ColorPickerFrame", "ReadyCheckFrame", "GuildInviteFrame", "ChannelFrameDaughterFrame"}
  for i = 1, #FrameBDs do
    local FrameBD = _G[FrameBDs[i]]
    F.CreateBD(FrameBD)
  end

  -- Dropdown lists

  hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
    for i = 1, _G.UIDROPDOWNMENU_MAXLEVELS do
      local menu = _G["DropDownList"..i.."MenuBackdrop"]
      local backdrop = _G["DropDownList"..i.."Backdrop"]
      if not backdrop.reskinned then
        F.CreateBD(menu)
        F.CreateBD(backdrop)
        backdrop.reskinned = true
      end
    end
  end)

  local createBackdrop = function(parent, texture)
    local bg = parent:CreateTexture(nil, "BACKGROUND")
    bg:SetColorTexture(0, 0, 0, .5)
    bg:SetPoint("CENTER", texture)
    bg:SetSize(12, 12)
    parent.bg = bg

    local left = parent:CreateTexture(nil, "BACKGROUND")
    left:SetWidth(1)
    left:SetColorTexture(0, 0, 0)
    left:SetPoint("TOPLEFT", bg)
    left:SetPoint("BOTTOMLEFT", bg)
    parent.left = left

    local right = parent:CreateTexture(nil, "BACKGROUND")
    right:SetWidth(1)
    right:SetColorTexture(0, 0, 0)
    right:SetPoint("TOPRIGHT", bg)
    right:SetPoint("BOTTOMRIGHT", bg)
    parent.right = right

    local top = parent:CreateTexture(nil, "BACKGROUND")
    top:SetHeight(1)
    top:SetColorTexture(0, 0, 0)
    top:SetPoint("TOPLEFT", bg)
    top:SetPoint("TOPRIGHT", bg)
    parent.top = top

    local bottom = parent:CreateTexture(nil, "BACKGROUND")
    bottom:SetHeight(1)
    bottom:SetColorTexture(0, 0, 0)
    bottom:SetPoint("BOTTOMLEFT", bg)
    bottom:SetPoint("BOTTOMRIGHT", bg)
    parent.bottom = bottom
  end

  local toggleBackdrop = function(bu, show)
    if show then
      bu.bg:Show()
      bu.left:Show()
      bu.right:Show()
      bu.top:Show()
      bu.bottom:Show()
    else
      bu.bg:Hide()
      bu.left:Hide()
      bu.right:Hide()
      bu.top:Hide()
      bu.bottom:Hide()
    end
  end

  hooksecurefunc("ToggleDropDownMenu", function(level, _, dropDownFrame, anchorName)
    if not level then level = 1 end

    local uiScale = _G.UIParent:GetScale()

    local listFrame = _G["DropDownList"..level]

    if level == 1 then
      if not anchorName then
        local xOffset = dropDownFrame.xOffset and dropDownFrame.xOffset or 16
        local yOffset = dropDownFrame.yOffset and dropDownFrame.yOffset or 9
        local point = dropDownFrame.point and dropDownFrame.point or "TOPLEFT"
        local relativeTo = dropDownFrame.relativeTo and dropDownFrame.relativeTo or dropDownFrame
        local relativePoint = dropDownFrame.relativePoint and dropDownFrame.relativePoint or "BOTTOMLEFT"

        listFrame:ClearAllPoints()
        listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)

        -- make sure it doesn't go off the screen
        local offLeft = listFrame:GetLeft()/uiScale
        local offRight = (_G.GetScreenWidth() - listFrame:GetRight())/uiScale
        local offTop = (_G.GetScreenHeight() - listFrame:GetTop())/uiScale
        local offBottom = listFrame:GetBottom()/uiScale

        local xAddOffset, yAddOffset = 0, 0
        if offLeft < 0 then
          xAddOffset = -offLeft
        elseif offRight < 0 then
          xAddOffset = offRight
        end

        if offTop < 0 then
          yAddOffset = offTop
        elseif offBottom < 0 then
          yAddOffset = -offBottom
        end
        listFrame:ClearAllPoints()
        listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset)
      elseif anchorName ~= "cursor" then
        -- this part might be a bit unreliable
        local _, _, relPoint, xOff, yOff = listFrame:GetPoint()
        if relPoint == "BOTTOMLEFT" and xOff == 0 and _G.floor(yOff) == 5 then
          listFrame:SetPoint("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
        end
      end
    else
      local point, anchor, relPoint, _, y = listFrame:GetPoint()
      if point:find("RIGHT") then
        listFrame:SetPoint(point, anchor, relPoint, -14, y)
      else
        listFrame:SetPoint(point, anchor, relPoint, 9, y)
      end
    end

    for j = 1, _G.UIDROPDOWNMENU_MAXBUTTONS do
      local bu = _G["DropDownList"..level.."Button"..j]
      local _, _, _, x = bu:GetPoint()
      if bu:IsShown() and x then
        local hl = _G["DropDownList"..level.."Button"..j.."Highlight"]
        local check = _G["DropDownList"..level.."Button"..j.."Check"]

        hl:SetPoint("TOPLEFT", -x + 1, 0)
        hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - 1, 0)

        if not bu.bg then
          createBackdrop(bu, check)
          hl:SetColorTexture(red, green, blue, .2)
          _G["DropDownList"..level.."Button"..j.."UnCheck"]:SetTexture("")

          local arrow = _G["DropDownList"..level.."Button"..j.."ExpandArrow"]
          arrow:SetNormalTexture(C.media.arrowRight)
          arrow:SetSize(8, 8)
        end

        if not bu.notCheckable then
          toggleBackdrop(bu, true)

          -- only reliable way to see if button is radio or or check...
          local _, co = check:GetTexCoord()

          if co == 0 then
            check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
            check:SetVertexColor(red, green, blue, 1)
            check:SetSize(20, 20)
            check:SetDesaturated(true)
          else
            check:SetTexture(C.media.backdrop)
            check:SetVertexColor(red, green, blue, .6)
            check:SetSize(10, 10)
            check:SetDesaturated(false)
          end

          check:SetTexCoord(0, 1, 0, 1)
        else
          toggleBackdrop(bu, false)
        end
      end
    end
  end)

  hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
    if texture:find("Divider") then
      icon:SetColorTexture(1, 1, 1, .2)
      icon:SetHeight(1)
    end
  end)

  -- Tab text position

  hooksecurefunc("PanelTemplates_DeselectTab", function(tab)
    local text = tab.Text or _G[tab:GetName().."Text"]
    text:SetPoint("CENTER", tab, "CENTER")
  end)

  hooksecurefunc("PanelTemplates_SelectTab", function(tab)
    local text = tab.Text or _G[tab:GetName().."Text"]
    text:SetPoint("CENTER", tab, "CENTER")
  end)

  -- [[ Custom skins ]]

  -- Pet stuff

  if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
    if class == "HUNTER" then
      local PetStableFrame = _G.PetStableFrame
      PetStableFrame.BottomInset:DisableDrawLayer("BACKGROUND")
      PetStableFrame.BottomInset:DisableDrawLayer("BORDER")
      PetStableFrame.LeftInset:DisableDrawLayer("BACKGROUND")
      PetStableFrame.LeftInset:DisableDrawLayer("BORDER")
      _G.PetStableModelShadow:Hide()
      _G.PetStableModelRotateLeftButton:Hide()
      _G.PetStableModelRotateRightButton:Hide()
      _G.PetStableFrameModelBg:Hide()
      _G.PetStablePrevPageButtonIcon:SetTexture("")
      _G.PetStableNextPageButtonIcon:SetTexture("")

      F.ReskinPortraitFrame(PetStableFrame, true)
      F.ReskinArrow(_G.PetStablePrevPageButton, "left")
      F.ReskinArrow(_G.PetStableNextPageButton, "right")

      _G.PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
      F.CreateBG(_G.PetStableSelectedPetIcon)

      for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
        local bu = _G["PetStableActivePet"..i]

        bu.Background:Hide()
        bu.Border:Hide()

        bu:SetNormalTexture("")
        bu.Checked:SetTexture(C.media.checked)

        _G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
        F.CreateBD(bu, .25)
      end

      for i = 1, _G.NUM_PET_STABLE_SLOTS do
        local bu = _G["PetStableStabledPet"..i]
        local bd = CreateFrame("Frame", nil, bu)
        bd:SetPoint("TOPLEFT", -1, 1)
        bd:SetPoint("BOTTOMRIGHT", 1, -1)
        F.CreateBD(bd, .25)
        bu:SetNormalTexture("")
        bu:DisableDrawLayer("BACKGROUND")
        _G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
      end
    end
  end

  -- Ghost frame

  _G.GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

  local GhostBD = CreateFrame("Frame", nil, _G.GhostFrameContentsFrame)
  GhostBD:SetPoint("TOPLEFT", _G.GhostFrameContentsFrameIcon, -1, 1)
  GhostBD:SetPoint("BOTTOMRIGHT", _G.GhostFrameContentsFrameIcon, 1, -1)
  F.CreateBD(GhostBD, 0)

  -- Currency frame

  _G.TokenFramePopupCorner:Hide()
  _G.TokenFramePopup:SetPoint("TOPLEFT", _G.TokenFrame, "TOPRIGHT", 1, -28)
  F.CreateBD(_G.TokenFramePopup)
  F.ReskinClose(_G.TokenFramePopupCloseButton)
  F.ReskinCheck(_G.TokenFramePopupInactiveCheckBox)
  F.ReskinCheck(_G.TokenFramePopupBackpackCheckBox)

  local function updateButtons()
    local buttons = _G.TokenFrameContainer.buttons

    if not buttons then return end

    for i = 1, #buttons do
      local bu = buttons[i]

      if not bu.styled then
        bu.highlight:SetPoint("TOPLEFT", 1, 0)
        bu.highlight:SetPoint("BOTTOMRIGHT", -1, 0)
        bu.highlight.SetPoint = F.dummy
        bu.highlight:SetColorTexture(red, green, blue, .2)
        bu.highlight.SetTexture = F.dummy

        bu.expandIcon:SetTexture("")

        local minus = bu:CreateTexture(nil, "OVERLAY")
        minus:SetSize(7, 1)
        minus:SetPoint("LEFT", 8, 0)
        minus:SetTexture(C.media.backdrop)
        minus:SetVertexColor(1, 1, 1)
        minus:Hide()
        bu.minus = minus

        local plus = bu:CreateTexture(nil, "OVERLAY")
        plus:SetSize(1, 7)
        plus:SetPoint("LEFT", 11, 0)
        plus:SetTexture(C.media.backdrop)
        plus:SetVertexColor(1, 1, 1)
        plus:Hide()
        bu.plus = plus

        bu.categoryMiddle:SetAlpha(0)
        bu.categoryLeft:SetAlpha(0)
        bu.categoryRight:SetAlpha(0)

        bu.icon:SetTexCoord(.08, .92, .08, .92)
        bu.bg = F.CreateBG(bu.icon)

        bu.styled = true
      end

      if bu.isHeader then
        bu.bg:Hide()
        bu.minus:Show()
        bu.plus:SetShown(not bu.isExpanded)
      else
        bu.bg:Show()
        bu.plus:Hide()
        bu.minus:Hide()
      end
    end
  end

  _G.TokenFrame:HookScript("OnShow", updateButtons)
  hooksecurefunc("TokenFrame_Update", updateButtons)
  hooksecurefunc(_G.TokenFrameContainer, "update", updateButtons)

  F.ReskinScroll(_G.TokenFrameContainerScrollBar)

  -- Reputation frame

  _G.ReputationDetailCorner:Hide()
  _G.ReputationDetailDivider:Hide()
  _G.ReputationListScrollFrame:GetRegions():Hide()
  select(2, _G.ReputationListScrollFrame:GetRegions()):Hide()

  _G.ReputationDetailFrame:SetPoint("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 1, -28)

  local function UpdateFactionSkins()
    for i = 1, _G.GetNumFactions() do
      local statusbar = _G["ReputationBar"..i.."ReputationBar"]

      if statusbar then
        statusbar:SetStatusBarTexture(C.media.backdrop)

        if not statusbar.reskinned then
          F.CreateBD(statusbar, .25)
          statusbar.reskinned = true
        end

        _G["ReputationBar"..i.."Background"]:SetTexture(nil)
        _G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
        _G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)
        _G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
        _G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
        _G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
        _G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
      end
    end
  end

  _G.ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
  _G.ReputationFrame:HookScript("OnEvent", UpdateFactionSkins)

  for i = 1, _G.NUM_FACTIONS_DISPLAYED do
    local bu = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
    F.ReskinExpandOrCollapse(bu)
  end

  hooksecurefunc("ReputationFrame_Update", function()
    local numFactions = _G.GetNumFactions()
    local factionIndex, factionButton
    local factionOffset = _G.FauxScrollFrame_GetOffset(_G.ReputationListScrollFrame)

    for i = 1, _G.NUM_FACTIONS_DISPLAYED do
      factionIndex = factionOffset + i
      factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]

      if factionIndex <= numFactions then
        local _, _, _, _, _, _, _, _, _, isCollapsed = _G.GetFactionInfo(factionIndex)
        if isCollapsed then
          factionButton.plus:Show()
        else
          factionButton.plus:Hide()
        end
      end
    end
  end)

  F.CreateBD(_G.ReputationDetailFrame)
  F.ReskinClose(_G.ReputationDetailCloseButton)
  F.ReskinCheck(_G.ReputationDetailAtWarCheckBox)
  F.ReskinCheck(_G.ReputationDetailInactiveCheckBox)
  F.ReskinCheck(_G.ReputationDetailMainScreenCheckBox)
  F.ReskinCheck(_G.ReputationDetailLFGBonusReputationCheckBox)
  F.ReskinScroll(_G.ReputationListScrollFrameScrollBar)

  select(3, _G.ReputationDetailFrame:GetRegions()):Hide()

  -- Raid frame (social frame)

  F.ReskinCheck(_G.RaidFrameAllAssistCheckButton)

  -- Professions

  local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4"}

  for _, button in pairs(professions) do
    local bu = _G[button]
    bu.professionName:SetTextColor(1, 1, 1)
    bu.missingHeader:SetTextColor(1, 1, 1)
    bu.missingText:SetTextColor(1, 1, 1)

    bu.statusBar:SetHeight(13)
    bu.statusBar:SetStatusBarTexture(C.media.backdrop)
    bu.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
    bu.statusBar.rankText:SetPoint("CENTER")

    local _, p = bu.statusBar:GetPoint()
    bu.statusBar:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 1, -3)

    _G[button.."StatusBarLeft"]:Hide()
    bu.statusBar.capRight:SetAlpha(0)
    _G[button.."StatusBarBGLeft"]:Hide()
    _G[button.."StatusBarBGMiddle"]:Hide()
    _G[button.."StatusBarBGRight"]:Hide()

    local bg = CreateFrame("Frame", nil, bu.statusBar)
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", 1, -1)
    bg:SetFrameLevel(bu:GetFrameLevel()-1)
    F.CreateBD(bg, .25)
  end

  local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight", "SecondaryProfession4SpellButtonLeft", "SecondaryProfession4SpellButtonRight"}

  for _, button in pairs(professionbuttons) do
    local icon = _G[button.."IconTexture"]
    local bu = _G[button]
    _G[button.."NameFrame"]:SetAlpha(0)

    bu:SetPushedTexture("")
    bu:SetCheckedTexture(C.media.checked)
    bu:GetHighlightTexture():Hide()

    if icon then
      icon:SetTexCoord(.08, .92, .08, .92)
      icon:ClearAllPoints()
      icon:SetPoint("TOPLEFT", 2, -2)
      icon:SetPoint("BOTTOMRIGHT", -2, 2)
      F.CreateBG(icon)
    end
  end

  for i = 1, 2 do
    local bu = _G["PrimaryProfession"..i]

    _G["PrimaryProfession"..i.."IconBorder"]:Hide()

    bu.professionName:ClearAllPoints()
    bu.professionName:SetPoint("TOPLEFT", 100, -4)

    bu.icon:SetAlpha(1)
    bu.icon:SetTexCoord(.08, .92, .08, .92)
    bu.icon:SetDesaturated(false)
    F.CreateBG(bu.icon)

    local bg = CreateFrame("Frame", nil, bu)
    bg:SetPoint("TOPLEFT")
    bg:SetPoint("BOTTOMRIGHT", 0, -4)
    bg:SetFrameLevel(0)
    F.CreateBD(bg, .25)
  end

  hooksecurefunc("FormatProfession", function(frame, index)
    if index then
      local _, texture = _G.GetProfessionInfo(index)

      if frame.icon and texture then
        frame.icon:SetTexture(texture)
      end
    end
  end)

  -- Friends Frame

  _G.FriendsFrameFriendsScrollFrameTop:Hide()
  _G.FriendsFrameFriendsScrollFrameMiddle:Hide()
  _G.FriendsFrameFriendsScrollFrameBottom:Hide()
  _G.IgnoreListFrameTop:Hide()
  _G.IgnoreListFrameMiddle:Hide()
  _G.IgnoreListFrameBottom:Hide()
  if not C.is71 then
    _G.PendingListFrameTop:Hide()
    _G.PendingListFrameMiddle:Hide()
    _G.PendingListFrameBottom:Hide()
  end

  for i = 1, 4 do
    F.ReskinTab(_G["FriendsFrameTab"..i])
  end

  _G.FriendsFrameIcon:Hide()

  for i = 1, _G.FRIENDS_TO_DISPLAY do
    local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
    local ic = bu.gameIcon

    bu.background:Hide()
    bu.travelPassButton:SetAlpha(0)
    bu.travelPassButton:EnableMouse(false)

    bu:SetHighlightTexture(C.media.backdrop)
    bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

    ic:SetSize(22, 22)
    ic:SetTexCoord(.15, .85, .15, .85)

    bu.bg = CreateFrame("Frame", nil, bu)
    bu.bg:SetAllPoints(ic)
    F.CreateBD(bu.bg, 0)
  end

  local function UpdateScroll()
    for i = 1, _G.FRIENDS_TO_DISPLAY do
      local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]

      if bu.gameIcon:IsShown() then
        bu.bg:Show()
        bu.gameIcon:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -2, -2)
      else
        bu.bg:Hide()
      end
    end
  end

  local friendsBtn1 = _G.FriendsFrameFriendsScrollFrameButton1
  friendsBtn1.bg:SetPoint("BOTTOMRIGHT", friendsBtn1.gameIcon, 0, -1)

  hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
  hooksecurefunc(_G.FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

  _G.FriendsFrameStatusDropDown:ClearAllPoints()
  _G.FriendsFrameStatusDropDown:SetPoint("TOPLEFT", _G.FriendsFrame, "TOPLEFT", 10, -28)

  for _, button in pairs({_G.FriendsTabHeaderSoRButton, _G.FriendsTabHeaderRecruitAFriendButton}) do
    button:SetPushedTexture("")
    button:GetRegions():SetTexCoord(.08, .92, .08, .92)
    F.CreateBDFrame(button)
  end

  F.CreateBD(_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame)
  _G.FriendsFrameBattlenetFrame.UnavailableInfoFrame:SetPoint("TOPLEFT", _G.FriendsFrame, "TOPRIGHT", 1, -18)

  _G.FriendsFrameBattlenetFrame:GetRegions():Hide()
  F.CreateBD(_G.FriendsFrameBattlenetFrame, .25)

  _G.FriendsFrameBattlenetFrame.Tag:SetParent(_G.FriendsListFrame)
  _G.FriendsFrameBattlenetFrame.Tag:SetPoint("TOP", _G.FriendsFrame, "TOP", 0, -8)

  hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
    if _G.BNFeaturesEnabled() then
      local frame = _G.FriendsFrameBattlenetFrame

      frame.BroadcastButton:Hide()

      if _G.BNConnected() then
        frame:Hide()
        _G.FriendsFrameBroadcastInput:Show()
        _G.FriendsFrameBroadcastInput_UpdateDisplay()
      end
    end
  end)

  hooksecurefunc("FriendsFrame_Update", function()
    if _G.FriendsFrame.selectedTab == 1 and _G.FriendsTabHeader.selectedTab == 1 and _G.FriendsFrameBattlenetFrame.Tag:IsShown() then
      _G.FriendsFrameTitleText:Hide()
    else
      _G.FriendsFrameTitleText:Show()
    end
  end)

  local whoBg = CreateFrame("Frame", nil, _G.WhoFrameEditBoxInset)
  whoBg:SetPoint("TOPLEFT")
  whoBg:SetPoint("BOTTOMRIGHT", -1, 1)
  whoBg:SetFrameLevel(_G.WhoFrameEditBoxInset:GetFrameLevel()-1)
  F.CreateBD(whoBg, .25)

  F.ReskinPortraitFrame(_G.FriendsFrame, true)
  F.Reskin(_G.FriendsFrameAddFriendButton)
  F.Reskin(_G.FriendsFrameSendMessageButton)
  F.Reskin(_G.FriendsFrameIgnorePlayerButton)
  F.Reskin(_G.FriendsFrameUnsquelchButton)
  F.Reskin(_G.FriendsFrameMutePlayerButton)
  F.ReskinScroll(_G.FriendsFrameFriendsScrollFrameScrollBar)
  F.ReskinScroll(_G.FriendsFrameIgnoreScrollFrameScrollBar)
  F.ReskinDropDown(_G.FriendsFrameStatusDropDown)

  -- Battlenet toast frame

  F.CreateBD(_G.BNToastFrame)
  F.CreateBD(_G.BNToastFrame.TooltipFrame)
  _G.BNToastFrameCloseButton:SetAlpha(0)

  -- Battletag invite frame

  F.CreateBD(_G.BattleTagInviteFrame)

  local send, cancel = _G.BattleTagInviteFrame:GetChildren()
  F.Reskin(send)
  F.Reskin(cancel)

  -- Gossip Frame

  _G.GossipGreetingScrollFrameTop:Hide()
  _G.GossipGreetingScrollFrameBottom:Hide()
  _G.GossipGreetingScrollFrameMiddle:Hide()
  select(19, _G.GossipFrame:GetRegions()):Hide()

  _G.GossipGreetingText:SetTextColor(1, 1, 1)

  _G.NPCFriendshipStatusBar:GetRegions():Hide()
  _G.NPCFriendshipStatusBarNotch1:SetColorTexture(0, 0, 0)
  _G.NPCFriendshipStatusBarNotch1:SetSize(1, 16)
  _G.NPCFriendshipStatusBarNotch2:SetColorTexture(0, 0, 0)
  _G.NPCFriendshipStatusBarNotch2:SetSize(1, 16)
  _G.NPCFriendshipStatusBarNotch3:SetColorTexture(0, 0, 0)
  _G.NPCFriendshipStatusBarNotch3:SetSize(1, 16)
  _G.NPCFriendshipStatusBarNotch4:SetColorTexture(0, 0, 0)
  _G.NPCFriendshipStatusBarNotch4:SetSize(1, 16)
  select(7, _G.NPCFriendshipStatusBar:GetRegions()):Hide()

  _G.NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
  F.CreateBDFrame(_G.NPCFriendshipStatusBar, .25)

  F.ReskinPortraitFrame(_G.GossipFrame, true)
  F.Reskin(_G.GossipFrameGreetingGoodbyeButton)
  F.ReskinScroll(_G.GossipGreetingScrollFrameScrollBar)

  -- Help frame

  for i = 1, 15 do
    local bu = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
    bu:DisableDrawLayer("ARTWORK")
    F.CreateBD(bu, 0)

    F.CreateGradient(bu)
  end

  local function colourTab(f)
    f.text:SetTextColor(1, 1, 1)
  end

  local function clearTab(f)
    f.text:SetTextColor(1, .82, 0)
  end

  local function styleTab(bu)
    bu.selected:SetColorTexture(red, green, blue, 0.2)
    bu.selected:SetDrawLayer("BACKGROUND")
    bu.text:SetFont(C.media.font, 14)
    F.Reskin(bu, true)
    bu:SetScript("OnEnter", colourTab)
    bu:SetScript("OnLeave", clearTab)
  end

  for i = 1, 6 do
    styleTab(_G["HelpFrameButton"..i])
  end
  styleTab(_G.HelpFrameButton16)

  _G.HelpFrameAccountSecurityOpenTicket.text:SetFont(C.media.font, 14)
  _G.HelpFrameOpenTicketHelpOpenTicket.text:SetFont(C.media.font, 14)

  _G.HelpFrameCharacterStuckHearthstone:SetSize(56, 56)
  F.CreateBG(_G.HelpFrameCharacterStuckHearthstone)
  _G.HelpFrameCharacterStuckHearthstoneIconTexture:SetTexCoord(.08, .92, .08, .92)

  F.Reskin(_G.HelpBrowserNavHome)
  F.Reskin(_G.HelpBrowserNavReload)
  F.Reskin(_G.HelpBrowserNavStop)
  F.Reskin(_G.HelpBrowserBrowserSettings)
  F.ReskinArrow(_G.HelpBrowserNavBack, "left")
  F.ReskinArrow(_G.HelpBrowserNavForward, "right")

  _G.HelpBrowserNavHome:SetSize(18, 18)
  _G.HelpBrowserNavReload:SetSize(18, 18)
  _G.HelpBrowserNavStop:SetSize(18, 18)
  _G.HelpBrowserBrowserSettings:SetSize(18, 18)

  _G.HelpBrowserNavHome:SetPoint("BOTTOMLEFT", _G.HelpBrowser, "TOPLEFT", 2, 4)
  _G.HelpBrowserBrowserSettings:SetPoint("TOPRIGHT", _G.HelpFrameCloseButton, "BOTTOMLEFT", -4, -1)
  _G.LoadingIcon:ClearAllPoints()
  _G.LoadingIcon:SetPoint("LEFT", _G.HelpBrowserNavStop, "RIGHT")

  for i = 1, 9 do
    select(i, _G.BrowserSettingsTooltip:GetRegions()):Hide()
  end

  F.CreateBD(_G.BrowserSettingsTooltip)
  F.Reskin(_G.BrowserSettingsTooltip.CacheButton)
  F.Reskin(_G.BrowserSettingsTooltip.CookiesButton)

  -- Trade Frame

  _G.TradePlayerEnchantInset:DisableDrawLayer("BORDER")
  _G.TradePlayerItemsInset:DisableDrawLayer("BORDER")
  _G.TradeRecipientEnchantInset:DisableDrawLayer("BORDER")
  _G.TradeRecipientItemsInset:DisableDrawLayer("BORDER")
  _G.TradePlayerInputMoneyInset:DisableDrawLayer("BORDER")
  _G.TradeRecipientMoneyInset:DisableDrawLayer("BORDER")
  _G.TradeRecipientBG:Hide()
  _G.TradePlayerEnchantInsetBg:Hide()
  _G.TradePlayerItemsInsetBg:Hide()
  _G.TradePlayerInputMoneyInsetBg:Hide()
  _G.TradeRecipientEnchantInsetBg:Hide()
  _G.TradeRecipientItemsInsetBg:Hide()
  _G.TradeRecipientMoneyBg:Hide()
  _G.TradeRecipientPortraitFrame:Hide()
  _G.TradeRecipientBotLeftCorner:Hide()
  _G.TradeRecipientLeftBorder:Hide()
  select(4, _G.TradePlayerItem7:GetRegions()):Hide()
  select(4, _G.TradeRecipientItem7:GetRegions()):Hide()
  _G.TradeFramePlayerPortrait:Hide()
  _G.TradeFrameRecipientPortrait:Hide()

  F.ReskinPortraitFrame(_G.TradeFrame, true)
  F.Reskin(_G.TradeFrameTradeButton)
  F.Reskin(_G.TradeFrameCancelButton)
  F.ReskinInput(_G.TradePlayerInputMoneyFrameGold)
  F.ReskinInput(_G.TradePlayerInputMoneyFrameSilver)
  F.ReskinInput(_G.TradePlayerInputMoneyFrameCopper)

  _G.TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", _G.TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
  _G.TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", _G.TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

  for i = 1, _G.MAX_TRADE_ITEMS do
    local bu1 = _G["TradePlayerItem"..i.."ItemButton"]
    local bu2 = _G["TradeRecipientItem"..i.."ItemButton"]

    _G["TradePlayerItem"..i.."SlotTexture"]:Hide()
    _G["TradePlayerItem"..i.."NameFrame"]:Hide()
    _G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
    _G["TradeRecipientItem"..i.."NameFrame"]:Hide()

    bu1:SetNormalTexture("")
    bu1:SetPushedTexture("")
    bu1.icon:SetTexCoord(.08, .92, .08, .92)
    bu2:SetNormalTexture("")
    bu2:SetPushedTexture("")
    bu2.icon:SetTexCoord(.08, .92, .08, .92)

    local bg1 = CreateFrame("Frame", nil, bu1)
    bg1:SetPoint("TOPLEFT", -1, 1)
    bg1:SetPoint("BOTTOMRIGHT", 1, -1)
    bg1:SetFrameLevel(bu1:GetFrameLevel()-1)
    F.CreateBD(bg1, .25)

    local bg2 = CreateFrame("Frame", nil, bu2)
    bg2:SetPoint("TOPLEFT", -1, 1)
    bg2:SetPoint("BOTTOMRIGHT", 1, -1)
    bg2:SetFrameLevel(bu2:GetFrameLevel()-1)
    F.CreateBD(bg2, .25)
  end

  -- Tutorial Frame

  F.CreateBD(_G.TutorialFrame)

  _G.TutorialFrameBackground:Hide()
  _G.TutorialFrameBackground.Show = F.dummy
  _G.TutorialFrame:DisableDrawLayer("BORDER")

  local tutOkay = _G.TutorialFrameOkayButton
  local tutPrev = _G.TutorialFramePrevButton
  local tutNext = _G.TutorialFrameNextButton
  F.Reskin(tutOkay, true)
  F.ReskinClose(_G.TutorialFrameCloseButton)
  F.ReskinArrow(tutPrev, "left")
  F.ReskinArrow(tutNext, "right")

  tutOkay:ClearAllPoints()
  tutOkay:SetPoint("BOTTOMLEFT", tutNext, "BOTTOMRIGHT", 10, 0)

  -- because gradient alpha and OnUpdate doesn't work for some reason...

  if select(14, tutOkay:GetRegions()) then
    select(14, tutOkay:GetRegions()):Hide()
    select(15, tutPrev:GetRegions()):Hide()
    select(15, tutNext:GetRegions()):Hide()
    select(14, _G.TutorialFrameCloseButton:GetRegions()):Hide()
  end
  tutPrev:SetScript("OnEnter", nil)
  tutNext:SetScript("OnEnter", nil)
  tutOkay:SetBackdropColor(0, 0, 0, .25)
  tutPrev:SetBackdropColor(0, 0, 0, .25)
  tutNext:SetBackdropColor(0, 0, 0, .25)

  -- Master looter frame

  local MasterLooterFrame = _G.MasterLooterFrame
  for i = 1, 9 do
    select(i, MasterLooterFrame:GetRegions()):Hide()
  end

  MasterLooterFrame.Item.NameBorderLeft:Hide()
  MasterLooterFrame.Item.NameBorderRight:Hide()
  MasterLooterFrame.Item.NameBorderMid:Hide()
  MasterLooterFrame.Item.IconBorder:Hide()

  MasterLooterFrame.Item.Icon:SetTexCoord(.08, .92, .08, .92)
  MasterLooterFrame.Item.Icon:SetDrawLayer("ARTWORK")
  MasterLooterFrame.Item.bg = F.CreateBG(MasterLooterFrame.Item.Icon)

  MasterLooterFrame:HookScript("OnShow", function(MLFrame)
    MLFrame.Item.bg:SetVertexColor(MLFrame.Item.IconBorder:GetVertexColor())
    _G.LootFrame:SetAlpha(.4)
  end)

  MasterLooterFrame:HookScript("OnHide", function(MLFrame)
    _G.LootFrame:SetAlpha(1)
  end)

  F.CreateBD(MasterLooterFrame)
  F.ReskinClose(select(3, MasterLooterFrame:GetChildren()))

  hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
    for i = 1, _G.MAX_RAID_MEMBERS do
      local playerFrame = MasterLooterFrame["player"..i]
      if playerFrame then
        if not playerFrame.styled then
          playerFrame.Bg:SetPoint("TOPLEFT", 1, -1)
          playerFrame.Bg:SetPoint("BOTTOMRIGHT", -1, 1)
          playerFrame.Highlight:SetPoint("TOPLEFT", 1, -1)
          playerFrame.Highlight:SetPoint("BOTTOMRIGHT", -1, 1)

          playerFrame.Highlight:SetTexture(C.media.backdrop)

          F.CreateBD(playerFrame, 0)

          playerFrame.styled = true
        end
        local colour = C.classcolours[select(2, _G.UnitClass(playerFrame.Name:GetText()))]
        playerFrame.Name:SetTextColor(colour.r, colour.g, colour.b)
        playerFrame.Highlight:SetVertexColor(colour.r, colour.g, colour.b, .2)
      else
        break
      end
    end
  end)

  -- Tabard frame

  _G.TabardFrameMoneyInset:DisableDrawLayer("BORDER")
  _G.TabardFrameCustomizationBorder:Hide()
  _G.TabardFrameMoneyBg:Hide()
  _G.TabardFrameMoneyInsetBg:Hide()

  for i = 19, 28 do
    select(i, _G.TabardFrame:GetRegions()):Hide()
  end

  for i = 1, 5 do
    _G["TabardFrameCustomization"..i.."Left"]:Hide()
    _G["TabardFrameCustomization"..i.."Middle"]:Hide()
    _G["TabardFrameCustomization"..i.."Right"]:Hide()
    F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
    F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
  end

  F.ReskinPortraitFrame(_G.TabardFrame, true)
  F.CreateBD(_G.TabardFrameCostFrame, .25)
  F.Reskin(_G.TabardFrameAcceptButton)
  F.Reskin(_G.TabardFrameCancelButton)

  -- Guild registrar frame

  _G.GuildRegistrarFrameTop:Hide()
  _G.GuildRegistrarFrameBottom:Hide()
  _G.GuildRegistrarFrameMiddle:Hide()
  select(19, _G.GuildRegistrarFrame:GetRegions()):Hide()

  _G.GuildRegistrarFrameEditBox:SetHeight(20)

  F.ReskinPortraitFrame(_G.GuildRegistrarFrame, true)
  F.CreateBD(_G.GuildRegistrarFrameEditBox, .25)
  F.Reskin(_G.GuildRegistrarFrameGoodbyeButton)
  F.Reskin(_G.GuildRegistrarFramePurchaseButton)
  F.Reskin(_G.GuildRegistrarFrameCancelButton)

  --[[ Item text ]]

  select(18, _G.ItemTextFrame:GetRegions()):Hide()
  _G.ItemTextFramePageBg:SetAlpha(0)
  _G.ItemTextPrevPageButton:GetRegions():Hide()
  _G.ItemTextNextPageButton:GetRegions():Hide()
  _G.ItemTextMaterialTopLeft:SetAlpha(0)
  _G.ItemTextMaterialTopRight:SetAlpha(0)
  _G.ItemTextMaterialBotLeft:SetAlpha(0)
  _G.ItemTextMaterialBotRight:SetAlpha(0)

  F.ReskinPortraitFrame(_G.ItemTextFrame, true)
  F.ReskinScroll(_G.ItemTextScrollFrameScrollBar)
  F.ReskinArrow(_G.ItemTextPrevPageButton, "left")
  F.ReskinArrow(_G.ItemTextNextPageButton, "right")

  -- Petition frame

  select(18, _G.PetitionFrame:GetRegions()):Hide()
  select(19, _G.PetitionFrame:GetRegions()):Hide()
  select(23, _G.PetitionFrame:GetRegions()):Hide()
  select(24, _G.PetitionFrame:GetRegions()):Hide()
  _G.PetitionFrameTop:Hide()
  _G.PetitionFrameBottom:Hide()
  _G.PetitionFrameMiddle:Hide()

  F.ReskinPortraitFrame(_G.PetitionFrame, true)
  F.Reskin(_G.PetitionFrameSignButton)
  F.Reskin(_G.PetitionFrameRequestButton)
  F.Reskin(_G.PetitionFrameRenameButton)
  F.Reskin(_G.PetitionFrameCancelButton)

  -- Micro button alerts

  local microButtons = {_G.TalentMicroButtonAlert, _G.CollectionsMicroButtonAlert}
    for _, button in pairs(microButtons) do
    button:DisableDrawLayer("BACKGROUND")
    button:DisableDrawLayer("BORDER")
    button.Arrow:Hide()

    F.SetBD(button)
    F.ReskinClose(button.CloseButton)
  end

  -- Cinematic popup

  _G.CinematicFrameCloseDialog:HookScript("OnShow", function(cinemaFrame)
    cinemaFrame:SetScale(_G.UIParent:GetScale())
  end)

  F.CreateBD(_G.CinematicFrameCloseDialog)
  F.Reskin(_G.CinematicFrameCloseDialogConfirmButton)
  F.Reskin(_G.CinematicFrameCloseDialogResumeButton)

  -- Bonus roll

  local BonusRollFrame = _G.BonusRollFrame
  BonusRollFrame.Background:SetAlpha(0)
  BonusRollFrame.IconBorder:Hide()
  BonusRollFrame.BlackBackgroundHoist.Background:Hide()

  BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
  F.CreateBG(BonusRollFrame.PromptFrame.Icon)

  BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(C.media.backdrop)

  F.CreateBD(BonusRollFrame)
  F.CreateBDFrame(BonusRollFrame.PromptFrame.Timer, .25)

  -- Level up display

  _G.LevelUpDisplaySide:HookScript("OnShow", function(lvlUp)
    for i = 1, #lvlUp.unlockList do
      local f = _G["LevelUpDisplaySideUnlockFrame"..i]

      if not f.restyled then
        f.icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(f.icon)
      end
    end
  end)

  -- Movie Frame

  local MovieFrame = _G.MovieFrame
  MovieFrame.CloseDialog:HookScript("OnShow", function(mov)
    mov:SetScale(_G.UIParent:GetScale())
  end)

  F.CreateBD(MovieFrame.CloseDialog)
  F.Reskin(MovieFrame.CloseDialog.ConfirmButton)
  F.Reskin(MovieFrame.CloseDialog.ResumeButton)

  -- Pet battle queue popup

  local PetBattleQueueReadyFrame = _G.PetBattleQueueReadyFrame
  F.CreateBD(PetBattleQueueReadyFrame)
  F.CreateBG(PetBattleQueueReadyFrame.Art)
  F.Reskin(PetBattleQueueReadyFrame.AcceptButton)
  F.Reskin(PetBattleQueueReadyFrame.DeclineButton)

  -- PVP Ready Dialog

  local PVPReadyDialog = _G.PVPReadyDialog
  PVPReadyDialog.background:Hide()
  PVPReadyDialog.bottomArt:Hide()
  PVPReadyDialog.filigree:Hide()

  PVPReadyDialog.roleIcon.texture:SetTexture(C.media.roleIcons)

  do
    local left = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
    left:SetWidth(1)
    left:SetTexture(C.media.backdrop)
    left:SetVertexColor(0, 0, 0)
    left:SetPoint("TOPLEFT", 9, -7)
    left:SetPoint("BOTTOMLEFT", 9, 10)

    local right = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
    right:SetWidth(1)
    right:SetTexture(C.media.backdrop)
    right:SetVertexColor(0, 0, 0)
    right:SetPoint("TOPRIGHT", -8, -7)
    right:SetPoint("BOTTOMRIGHT", -8, 10)

    local top = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
    top:SetHeight(1)
    top:SetTexture(C.media.backdrop)
    top:SetVertexColor(0, 0, 0)
    top:SetPoint("TOPLEFT", 9, -7)
    top:SetPoint("TOPRIGHT", -8, -7)

    local bottom = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
    bottom:SetHeight(1)
    bottom:SetTexture(C.media.backdrop)
    bottom:SetVertexColor(0, 0, 0)
    bottom:SetPoint("BOTTOMLEFT", 9, 10)
    bottom:SetPoint("BOTTOMRIGHT", -8, 10)
  end

  F.CreateBD(PVPReadyDialog)
  PVPReadyDialog.SetBackdrop = F.dummy

  F.Reskin(PVPReadyDialog.enterButton)
  F.Reskin(PVPReadyDialog.leaveButton)
  F.ReskinClose(_G.PVPReadyDialogCloseButton)

  -- [[ Hide regions ]]

  local bglayers = {"WhoFrameColumnHeader1", "WhoFrameColumnHeader2", "WhoFrameColumnHeader3", "WhoFrameColumnHeader4", "RaidInfoInstanceLabel", "RaidInfoIDLabel", "HelpFrameMainInset", "HelpFrame", "HelpFrameLeftInset", "RaidParentFrame"}
  for i = 1, #bglayers do
    _G[bglayers[i]]:DisableDrawLayer("BACKGROUND")
  end
  local borderlayers = {"WhoFrameListInset", "WhoFrameEditBoxInset", "ChannelFrameLeftInset", "ChannelFrameRightInset", "HelpFrame", "HelpFrameLeftInset", "HelpFrameMainInset", "RaidParentFrame", "RaidParentFrameInset", "RaidFinderFrameRoleInset"}
  for i = 1, #borderlayers do
    _G[borderlayers[i]]:DisableDrawLayer("BORDER")
  end
  for i = 1, 6 do
    for j = 1, 3 do
      select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
      select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = F.dummy
    end
    select(i, _G.ScrollOfResurrectionFrameNoteFrame:GetRegions()):Hide()
  end
  _G.OpenStationeryBackgroundLeft:Hide()
  _G.OpenStationeryBackgroundRight:Hide()
  _G.SendStationeryBackgroundLeft:Hide()
  _G.SendStationeryBackgroundRight:Hide()
  for i = 1, 4 do
    select(i, _G.GearManagerDialogPopup:GetRegions()):Hide()
  end
  _G.StackSplitFrame:GetRegions():Hide()
  _G.RaidInfoDetailFooter:Hide()
  _G.RaidInfoDetailHeader:Hide()
  _G.RaidInfoDetailCorner:Hide()
  _G.RaidInfoFrameHeader:Hide()
  for i = 1, 9 do
    select(i, _G.AddFriendNoteFrame:GetRegions()):Hide()
    select(i, _G.ReportPlayerNameDialogCommentFrame:GetRegions()):Hide()
    select(i, _G.ReportCheatingDialogCommentFrame:GetRegions()):Hide()
  end
  _G.HelpFrameHeader:Hide()
  _G.ReadyCheckPortrait:SetAlpha(0)
  select(2, _G.ReadyCheckListenerFrame:GetRegions()):Hide()
  _G.HelpFrameLeftInsetBg:Hide()
  _G.LFDQueueFrameBackground:Hide()
  select(3, _G.HelpFrameReportBug:GetChildren()):Hide()
  select(3, _G.HelpFrameSubmitSuggestion:GetChildren()):Hide()
  _G.HelpFrameKnowledgebaseStoneTex:Hide()
  _G.GhostFrameLeft:Hide()
  _G.GhostFrameRight:Hide()
  _G.GhostFrameMiddle:Hide()
  for i = 3, 6 do
    select(i, _G.GhostFrame:GetRegions()):Hide()
  end
  _G.PaperDollSidebarTabs:GetRegions():Hide()
  select(2, _G.PaperDollSidebarTabs:GetRegions()):Hide()
  select(6, _G.PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()

  F.CreateGradient(_G.CharacterStatsPane.ItemLevelCategory)
  F.CreateBD(_G.CharacterStatsPane.ItemLevelCategory, 0)
  F.CreateGradient(_G.CharacterStatsPane.AttributesCategory)
  F.CreateBD(_G.CharacterStatsPane.AttributesCategory, 0)
  F.CreateGradient(_G.CharacterStatsPane.EnhancementsCategory)
  F.CreateBD(_G.CharacterStatsPane.EnhancementsCategory, 0)

  _G.CharacterFrame:HookScript("OnShow", function()
    for k, v in pairs ({_G.CharacterStatsPane:GetChildren()}) do
      if v.Background then
        if v.Background:GetAtlas() then
          v.Background:SetAtlas(nil)
        end
      end
    end
  end)

  select(5, _G.HelpFrameGM_Response:GetChildren()):Hide()
  select(6, _G.HelpFrameGM_Response:GetChildren()):Hide()
  _G.GearManagerDialogPopupScrollFrame:GetRegions():Hide()
  select(2, _G.GearManagerDialogPopupScrollFrame:GetRegions()):Hide()
  for i = 1, 10 do
    select(i, _G.GuildInviteFrame:GetRegions()):Hide()
  end
  _G.InboxPrevPageButton:GetRegions():Hide()
  _G.InboxNextPageButton:GetRegions():Hide()
  _G.LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
  _G.ChannelFrameDaughterFrameCorner:Hide()
  _G.LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
  _G.LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
  for i = 1, _G.MAX_DISPLAY_CHANNEL_BUTTONS do
    _G["ChannelButton"..i]:SetNormalTexture("")
  end
  _G.PaperDollTitlesPane:HookScript("OnShow", function(titles)
    for x, object in pairs(titles.buttons) do
      object:DisableDrawLayer("BACKGROUND")
      object.text:SetFont(C.media.font, 11)
    end
  end)
  _G.SendScrollBarBackgroundTop:Hide()
  _G.HelpFrameKnowledgebaseTopTileStreaks:Hide()
  _G.ChannelFrameDaughterFrameTitlebar:Hide()
  _G.OpenScrollBarBackgroundTop:Hide()
  _G.WhoListScrollFrame:GetRegions():Hide()
  select(2, _G.WhoListScrollFrame:GetRegions()):Hide()
  _G.ChannelRosterScrollFrameTop:SetAlpha(0)
  _G.ChannelRosterScrollFrameBottom:SetAlpha(0)
  _G.WhoFrameListInsetBg:Hide()
  _G.WhoFrameEditBoxInsetBg:Hide()
  _G.ChannelFrameLeftInsetBg:Hide()
  _G.ChannelFrameRightInsetBg:Hide()
  _G.RaidFinderQueueFrameBackground:Hide()
  _G.RaidParentFrameInsetBg:Hide()
  _G.RaidFinderFrameRoleInsetBg:Hide()
  _G.RaidFinderFrameRoleBackground:Hide()
  _G.RaidParentFramePortraitFrame:Hide()
  _G.RaidParentFramePortrait:Hide()
  _G.RaidParentFrameTopBorder:Hide()
  _G.RaidParentFrameTopRightCorner:Hide()
  _G.ScrollOfResurrectionSelectionFrameBackground:Hide()

  _G.ReadyCheckFrame:HookScript("OnShow", function(readyCheck)
    if _G.UnitIsUnit("player", readyCheck.initiator) then
      readyCheck:Hide()
    end
  end)

  -- [[ Text colour functions ]]
  _G.GameFontBlackMedium:SetTextColor(1, 1, 1)
  _G.QuestFont:SetTextColor(1, 1, 1)
  _G.MailFont_Large:SetTextColor(1, 1, 1)
  _G.MailFont_Large:SetShadowColor(0, 0, 0)
  _G.MailFont_Large:SetShadowOffset(1, -1)
  _G.MailTextFontNormal:SetTextColor(1, 1, 1)
  _G.MailTextFontNormal:SetShadowOffset(1, -1)
  _G.MailTextFontNormal:SetShadowColor(0, 0, 0)
  _G.InvoiceTextFontNormal:SetTextColor(1, 1, 1)
  _G.InvoiceTextFontSmall:SetTextColor(1, 1, 1)
  _G.SpellBookPageText:SetTextColor(.8, .8, .8)
  _G.AvailableServicesText:SetTextColor(1, 1, 1)
  _G.AvailableServicesText:SetShadowColor(0, 0, 0)
  _G.PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
  _G.PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
  _G.PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
  _G.PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
  _G.PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
  _G.PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
  _G.ItemTextPageText:SetTextColor(1, 1, 1)
  _G.ItemTextPageText.SetTextColor = F.dummy
  _G.CoreAbilityFont:SetTextColor(1, 1, 1)

  hooksecurefunc("UpdateProfessionButton", function(profBtn)
    profBtn.spellString:SetTextColor(1, 1, 1);
    profBtn.subSpellString:SetTextColor(1, 1, 1)
  end)

  hooksecurefunc("PaperDollFrame_SetLevel", function()
    local primaryTalentTree = _G.GetSpecialization()
    local classColor = C.classcolours[class]
    local classColorString = ("ff%.2x%.2x%.2x"):format(classColor.r * 255, classColor.g * 255, classColor.b * 255)
    local specName, _

    if primaryTalentTree then
      _, specName = _G.GetSpecializationInfo(primaryTalentTree, nil, nil, nil, _G.UnitSex("player"))
    end

    if specName and specName ~= "" then
      _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, _G.UnitLevel("player"), classColorString, specName, classDisplayName)
    else
      _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL_NO_SPEC, _G.UnitLevel("player"), classColorString, classDisplayName)
    end
  end)

  -- [[ Change positions ]]

  _G.PaperDollEquipmentManagerPaneEquipSet:SetWidth(_G.PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
  _G.PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", _G.PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
  _G.GearManagerDialogPopup:SetPoint("LEFT", _G.PaperDollFrame, "RIGHT", 1, 0)
  _G.HelpFrameReportBugScrollFrameScrollBar:SetPoint("TOPLEFT", _G.HelpFrameReportBugScrollFrame, "TOPRIGHT", 1, -16)
  _G.HelpFrameSubmitSuggestionScrollFrameScrollBar:SetPoint("TOPLEFT", _G.HelpFrameSubmitSuggestionScrollFrame, "TOPRIGHT", 1, -16)
  _G.HelpFrameGM_ResponseScrollFrame1ScrollBar:SetPoint("TOPLEFT", _G.HelpFrameGM_ResponseScrollFrame1, "TOPRIGHT", 1, -16)
  _G.HelpFrameGM_ResponseScrollFrame2ScrollBar:SetPoint("TOPLEFT", _G.HelpFrameGM_ResponseScrollFrame2, "TOPRIGHT", 1, -16)
  _G.RaidInfoFrame:SetPoint("TOPLEFT", _G.RaidFrame, "TOPRIGHT", 1, -28)
  _G.TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", _G.TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)
  _G.LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:SetPoint("TOP", _G.LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
  _G.LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:SetPoint("TOP", _G.LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
  _G.WhoFrameWhoButton:SetPoint("RIGHT", _G.WhoFrameAddFriendButton, "LEFT", -1, 0)
  _G.WhoFrameAddFriendButton:SetPoint("RIGHT", _G.WhoFrameGroupInviteButton, "LEFT", -1, 0)
  _G.FriendsFrameTitleText:SetPoint("TOP", _G.FriendsFrame, "TOP", 0, -8)

  -- [[ Buttons ]]

  local buttons = {"AudioOptionsFrameOkay", "AudioOptionsFrameCancel", "AudioOptionsFrameDefaults", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "GearManagerDialogPopupOkay", "GearManagerDialogPopupCancel", "StackSplitOkayButton", "StackSplitCancelButton", "GameMenuButtonHelp", "GameMenuButtonWhatsNew", "GameMenuButtonStore", "GameMenuButtonOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonAddons", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "LFDQueueFrameFindGroupButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton", "RaidInfoExtendButton", "RaidInfoCancelButton", "PaperDollEquipmentManagerPaneEquipSet", "PaperDollEquipmentManagerPaneSaveSet", "HelpFrameAccountSecurityOpenTicket", "HelpFrameCharacterStuckStuck", "HelpFrameOpenTicketHelpOpenTicket", "ReadyCheckFrameYesButton", "ReadyCheckFrameNoButton", "HelpFrameKnowledgebaseSearchButton", "GhostFrame", "HelpFrameGM_ResponseNeedMoreHelp", "HelpFrameGM_ResponseCancel", "AddFriendInfoFrameContinueButton", "LFDQueueFramePartyBackfillBackfillButton", "LFDQueueFramePartyBackfillNoBackfillButton", "ChannelFrameDaughterFrameOkayButton", "ChannelFrameDaughterFrameCancelButton", "PendingListInfoFrameContinueButton", "LFDQueueFrameNoLFDWhileLFRLeaveQueueButton", "RaidFinderFrameFindRaidButton", "RaidFinderQueueFrameIneligibleFrameLeaveQueueButton", "RaidFinderQueueFramePartyBackfillBackfillButton", "RaidFinderQueueFramePartyBackfillNoBackfillButton", "ScrollOfResurrectionSelectionFrameAcceptButton", "ScrollOfResurrectionSelectionFrameCancelButton", "ScrollOfResurrectionFrameAcceptButton", "ScrollOfResurrectionFrameCancelButton", "HelpFrameReportBugSubmit", "HelpFrameSubmitSuggestionSubmit", "ReportPlayerNameDialogReportButton", "ReportPlayerNameDialogCancelButton", "ReportCheatingDialogReportButton", "ReportCheatingDialogCancelButton"}
  for i = 1, #buttons do
  local reskinbutton = _G[buttons[i]]
    if reskinbutton then
      F.Reskin(reskinbutton)
    else
      _G.print("Aurora: "..buttons[i].." was not found.")
    end
  end

  local closebuttons = {"HelpFrameCloseButton", "RaidInfoCloseButton", "ItemRefCloseButton", "ChannelFrameDaughterFrameDetailCloseButton", "RaidParentFrameCloseButton"}
  for i = 1, #closebuttons do
    F.ReskinClose(_G[closebuttons[i]])
  end
end
