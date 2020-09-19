local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\LFDFrame.lua ]]
    function Hook.LFDQueueFrameRandomCooldownFrame_Update()
        for i = 1, _G.GetNumSubgroupMembers() do
            local nameLabel = _G["LFDQueueFrameCooldownFrameName"..i]

            local _, classFilename = _G.UnitClass("party"..i)
            local classColor = classFilename and _G.CUSTOM_CLASS_COLORS[classFilename] or _G.NORMAL_FONT_COLOR
            nameLabel:SetFormattedText("|cff%.2x%.2x%.2x%s|r", classColor.r * 255, classColor.g * 255, classColor.b * 255, _G.GetUnitName("party"..i, true))
        end
    end
end

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
    _G.hooksecurefunc("LFDQueueFrameRandomCooldownFrame_Update", Hook.LFDQueueFrameRandomCooldownFrame_Update)

    -----------------------
    -- LFDRoleCheckPopup --
    -----------------------
    local LFDRoleCheckPopup = _G.LFDRoleCheckPopup
    Skin.DialogBorderTemplate(LFDRoleCheckPopup.Border)

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
    Skin.DialogBorderTemplate(LFDReadyCheckPopup.Border)
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
    _G.LFDQueueFrameRandomScrollFrame.ScrollBar:SetPoint("TOPLEFT", _G.LFDQueueFrameRandomScrollFrame, "TOPRIGHT", 2.4, -17)
    _G.LFDQueueFrameRandomScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", _G.LFDQueueFrameRandomScrollFrame, "BOTTOMRIGHT", 2.4, 17)
    _G.LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
    _G.LFDQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
    _G.LFDQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()
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
