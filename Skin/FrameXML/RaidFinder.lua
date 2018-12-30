local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\RaidFinder.lua ]]
--end

do --[[ FrameXML\RaidFinder.xml ]]
    function Skin.RaidFinderRoleButtonTemplate(Button)
        Skin.LFGRoleButtonWithBackgroundAndRewardTemplate(Button)
    end
end

function private.FrameXML.RaidFinder()
    local RaidFinderFrame = _G.RaidFinderFrame
    _G.RaidFinderFrameRoleBackground:Hide()

    RaidFinderFrame.NoRaidsCover:SetPoint("TOPRIGHT", 0, -25)
    RaidFinderFrame.NoRaidsCover:SetPoint("BOTTOMLEFT", 0, 0)

    Skin.InsetFrameTemplate(_G.RaidFinderFrameRoleInset)
    Skin.InsetFrameTemplate(_G.RaidFinderFrameBottomInset)

    --------------------------
    -- RaidFinderQueueFrame --
    --------------------------
    _G.RaidFinderQueueFrameBackground:Hide()

    Skin.RaidFinderRoleButtonTemplate(_G.RaidFinderQueueFrameRoleButtonTank)
    Skin.RaidFinderRoleButtonTemplate(_G.RaidFinderQueueFrameRoleButtonHealer)
    Skin.RaidFinderRoleButtonTemplate(_G.RaidFinderQueueFrameRoleButtonDPS)
    Skin.LFGRoleButtonTemplate(_G.RaidFinderQueueFrameRoleButtonLeader)
    Skin.UIDropDownMenuTemplate(_G.RaidFinderQueueFrameSelectionDropDown)

    Skin.UIPanelScrollFrameTemplate(_G.RaidFinderQueueFrameScrollFrame)
    _G.RaidFinderQueueFrameScrollFrameScrollBackground:Hide()
    _G.RaidFinderQueueFrameScrollFrameScrollBackgroundTopLeft:Hide()
    _G.RaidFinderQueueFrameScrollFrameScrollBackgroundBottomRight:Hide()
    Skin.LFGRewardFrameTemplate(_G.RaidFinderQueueFrameScrollFrameChildFrame)

    Skin.LFGBackfillCoverTemplate(_G.RaidFinderQueueFramePartyBackfill)
    Skin.LFGCooldownCoverTemplate(_G.RaidFinderQueueFrame.CooldownFrame)
    Skin.UIPanelButtonTemplate(_G.RaidFinderQueueFrameIneligibleFrame.leaveQueueButton)

    Skin.MagicButtonTemplate(_G.RaidFinderFrameFindRaidButton)
end
