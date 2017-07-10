local _, private = ...

-- [[ Lua Globals ]]
local ipairs = _G.ipairs

-- [[ Core ]]
local F = _G.unpack(private.Aurora)
local skinned = {}

function private.AddOns.Blizzard_ChallengesUI()
    --[[ ChallengesKeystoneFrame ]]--
    local KeystoneFrame = _G.ChallengesKeystoneFrame
    F.CreateBD(KeystoneFrame)
    F.ReskinClose(KeystoneFrame.CloseButton)
    F.Reskin(KeystoneFrame.StartButton)

    _G.hooksecurefunc(KeystoneFrame, "Reset", function(self)
        self:GetRegions():Hide()
        KeystoneFrame.InstructionBackground:SetAlpha(0.5)
    end)
    _G.hooksecurefunc(KeystoneFrame, "OnKeystoneSlotted", function(self)
        for i, affix in ipairs(self.Affixes) do
            affix.Border:Hide()

            affix.Portrait:SetTexture(nil)
            F.ReskinIcon(affix.Portrait)
            if affix.info then
                affix.Portrait:SetTexture(_G.CHALLENGE_MODE_EXTRA_AFFIX_INFO[affix.info.key].texture)
            elseif affix.affixID then
                local _, _, filedataid = _G.C_ChallengeMode.GetAffixInfo(affix.affixID)
                affix.Portrait:SetTexture(filedataid)
            end
        end
    end)

    --[[ ChallengesFrame ]]--
    local ChallengesFrame = _G.ChallengesFrame
    ChallengesFrame:DisableDrawLayer("BACKGROUND")
    _G.ChallengesFrameInset:DisableDrawLayer("BORDER")
    _G.ChallengesFrameInsetBg:Hide()

    ChallengesFrame.WeeklyBest:SetPoint("TOPLEFT")
    ChallengesFrame.WeeklyBest:SetPoint("BOTTOMRIGHT")
    ChallengesFrame.WeeklyBest.Child.Star:SetPoint("TOPLEFT", 54, -41)

    ChallengesFrame.GuildBest.Line:SetColorTexture(0.7, 0.7, 0.7)
    ChallengesFrame.GuildBest.Line:SetPoint("TOP", 0, -24)
    ChallengesFrame.GuildBest.Line:SetHeight(1)

    _G.hooksecurefunc("ChallengesFrame_Update", function(self)
        for i, icon in ipairs(self.DungeonIcons) do
            if not skinned[icon] then
                icon:GetRegions():Hide()
                skinned[icon] = true
            end
        end
    end)
end
