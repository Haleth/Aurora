local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ FrameXML\LFDFrame.lua ]]
--end

do --[[ FrameXML\LFDFrame.xml ]]
    function Skin.LFDRoleButtonTemplate(Button)
        Skin.LFGRoleButtonWithBackgroundAndRewardTemplate(Button)
    end
    function Skin.LFDRoleCheckPopupButtonTemplate(Button)
        Skin.LFGRoleButtonTemplate(Button)
    end
    function Skin.LFDFrameDungeonChoiceTemplate(Button)
        Skin.LFGSpecificChoiceTemplate(Button)
    end
end

function private.FrameXML.LFDFrame()
    -----------------------
    -- LFDRoleCheckPopup --
    -----------------------
    local LFDRoleCheckPopup = _G.LFDRoleCheckPopup
    Base.SetBackdrop(LFDRoleCheckPopup)

    _G.LFDRoleCheckPopupRoleButtonTank:SetPoint("LEFT", 33, 0)
    Skin.LFDRoleCheckPopupButtonTemplate(_G.LFDRoleCheckPopupRoleButtonTank)
    Skin.LFDRoleCheckPopupButtonTemplate(_G.LFDRoleCheckPopupRoleButtonHealer)
    Skin.LFDRoleCheckPopupButtonTemplate(_G.LFDRoleCheckPopupRoleButtonDPS)

    Skin.UIPanelButtonTemplate(_G.LFDRoleCheckPopupAcceptButton)
    Skin.UIPanelButtonTemplate(_G.LFDRoleCheckPopupDeclineButton)
    Util.PositionRelative("BOTTOMLEFT", LFDRoleCheckPopup, "BOTTOMLEFT", 36, 15, 5, "Right", {
        _G.LFDRoleCheckPopupAcceptButton,
        _G.LFDRoleCheckPopupDeclineButton,
    })


    ------------------------
    -- LFDReadyCheckPopup --
    ------------------------
    local LFDReadyCheckPopup = _G.LFDReadyCheckPopup
    Base.SetBackdrop(LFDReadyCheckPopup)
    Skin.UIPanelButtonTemplate(LFDReadyCheckPopup.YesButton)
    Skin.UIPanelButtonTemplate(LFDReadyCheckPopup.NoButton)
    Util.PositionRelative("BOTTOMLEFT", LFDReadyCheckPopup, "BOTTOMLEFT", 32, 15, 5, "Right", {
        LFDReadyCheckPopup.YesButton,
        LFDReadyCheckPopup.NoButton,
    })


    --------------------
    -- LFDParentFrame --
    --------------------
    local LFDParentFrame = _G.LFDParentFrame
    _G.LFDParentFrameRoleBackground:Hide()
    LFDParentFrame.TopTileStreaks:Hide()

    Skin.InsetFrameTemplate(LFDParentFrame.Inset)

    -- LFDQueueFrame --
    local LFDQueueFrame = _G.LFDQueueFrame
    _G.LFDQueueFrameBackground:Hide()

    Skin.LFDRoleButtonTemplate(_G.LFDQueueFrameRoleButtonTank)
    Skin.LFDRoleButtonTemplate(_G.LFDQueueFrameRoleButtonHealer)
    Skin.LFDRoleButtonTemplate(_G.LFDQueueFrameRoleButtonDPS)
    Skin.LFGRoleButtonTemplate(_G.LFDQueueFrameRoleButtonLeader)
    Skin.UIDropDownMenuTemplate(_G.LFDQueueFrameTypeDropDown)

    Skin.UIPanelScrollFrameTemplate(_G.LFDQueueFrameRandomScrollFrame)
    Skin.LFGRewardFrameTemplate(_G.LFDQueueFrameRandomScrollFrameChildFrame)

    for i = 1, _G.NUM_LFD_CHOICE_BUTTONS do
        Skin.LFDFrameDungeonChoiceTemplate(_G["LFDQueueFrameSpecificListButton"..i])
    end
    Skin.FauxScrollFrameTemplate(_G.LFDQueueFrameSpecificListScrollFrame)
    _G.LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
    _G.LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()

    Skin.MagicButtonTemplate(_G.LFDQueueFrameFindGroupButton)
    Skin.LFGBackfillCoverTemplate(LFDQueueFrame.PartyBackfill)
    Skin.LFGCooldownCoverTemplate(LFDQueueFrame.CooldownFrame)
end
