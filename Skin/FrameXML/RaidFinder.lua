local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local F = _G.unpack(Aurora)
local Skin = Aurora.Skin

function private.FrameXML.RaidFinder()
    _G.RaidFinderFrameRoleBackground:Hide()
    if not private.isPatch then
        _G.RaidFinderFrameBtnCornerRight:Hide()
        _G.RaidFinderFrameButtonBottomBorder:Hide()
    end

    Skin.InsetFrameTemplate(_G.RaidFinderFrameRoleInset)
    Skin.InsetFrameTemplate(_G.RaidFinderFrameBottomInset)

    _G.RaidFinderQueueFrameBackground:Hide()

    --[[ skinned in LFGFrame.lua
        RaidFinderQueueFrameRoleButtonTank
        RaidFinderQueueFrameRoleButtonHealer
        RaidFinderQueueFrameRoleButtonDPS
        RaidFinderQueueFrameRoleButtonLeader
    ]]

    F.ReskinDropDown(_G.RaidFinderQueueFrameSelectionDropDown)
    F.ReskinScroll(_G.RaidFinderQueueFrameScrollFrameScrollBar)
    _G.RaidFinderQueueFrameScrollFrameScrollBackground:Hide()
    _G.RaidFinderQueueFrameScrollFrameScrollBackgroundTopLeft:Hide()
    _G.RaidFinderQueueFrameScrollFrameScrollBackgroundBottomRight:Hide()


    F.Reskin(_G.RaidFinderQueueFramePartyBackfillBackfillButton)
    F.Reskin(_G.RaidFinderQueueFramePartyBackfillNoBackfillButton)
    F.Reskin(_G.RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)

    F.Reskin(_G.RaidFinderFrameFindRaidButton)
end
