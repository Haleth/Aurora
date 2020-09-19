local _, private = ...
if private.isClassic then return end

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\RaidFinder.lua ]]
    function Hook.RaidFinderQueueFrameCooldownFrame_Update()
        local numPlayers, prefix
        if _G.IsInRaid() then
            numPlayers = _G.GetNumGroupMembers()
            prefix = "raid"
        else
            numPlayers = _G.GetNumSubgroupMembers()
            prefix = "party"
        end

        local cooldowns = 0
        for i = 1, numPlayers do
            local unit = prefix .. i
            if _G.UnitHasLFGDeserter(unit) and not _G.UnitIsUnit(unit, "player") then
                cooldowns = cooldowns + 1
                if cooldowns <= _G.MAX_RAID_FINDER_COOLDOWN_NAMES then
                    local _, classToken = _G.UnitClass(unit)
                    local classColor = classToken and _G.CUSTOM_CLASS_COLORS[classToken]
                    if classColor then
                        _G["RaidFinderQueueFrameCooldownFrameName" .. cooldowns]:SetFormattedText("|c%s%s|r", classColor.colorStr, _G.UnitName(unit))
                    end
                end
            end
        end
    end
end

do --[[ FrameXML\RaidFinder.xml ]]
    function Skin.RaidFinderRoleButtonTemplate(Button)
        Skin.LFGRoleButtonWithBackgroundAndRewardTemplate(Button)
    end
end

function private.FrameXML.RaidFinder()
    _G.hooksecurefunc("RaidFinderQueueFrameCooldownFrame_Update", Hook.RaidFinderQueueFrameCooldownFrame_Update)

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
