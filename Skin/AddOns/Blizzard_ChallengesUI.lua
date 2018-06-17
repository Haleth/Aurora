local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_ChallengesUI.lua ]]
    function Hook.ChallengesFrame_Update(self)
        for i, icon in ipairs(self.DungeonIcons) do
            if i > (self._skinnedIcons or 0) then
                Skin.ChallengesDungeonIconFrameTemplate(icon)
                self._skinnedIcons = i
            end
        end
    end
    function Hook.ChallengesKeystoneFrameMixin_Reset(self)
        self:GetRegions():Hide()
        self.InstructionBackground:Hide()
    end
    function Hook.ChallengesKeystoneFrameMixin_OnKeystoneSlotted(self, affixInfo)
        for i, affix in ipairs(self.Affixes) do
            if i > (self._skinnedAffixes or 0) then
                Skin.ChallengesKeystoneFrameAffixTemplate(affix)
                self._skinnedAffixes = i
            end

            affix.Portrait:SetTexture(nil)
            if affix.info then
                affix.Portrait:SetTexture(_G.CHALLENGE_MODE_EXTRA_AFFIX_INFO[affix.info.key].texture)
            elseif affix.affixID then
                local _, _, filedataid = _G.C_ChallengeMode.GetAffixInfo(affix.affixID)
                affix.Portrait:SetTexture(filedataid)
            end
        end
    end
end

do --[[ AddOns\Blizzard_ChallengesUI.xml ]]
    function Skin.ChallengesDungeonIconFrameTemplate(Frame)
        Frame:GetRegions():Hide()
        Base.CropIcon(Frame.Icon, Frame)
    end
    function Skin.ChallengesKeystoneFrameAffixTemplate(Frame)
        Frame.Border:Hide()
        Base.CropIcon(Frame.Portrait)
    end
end

function private.AddOns.Blizzard_ChallengesUI()
    _G.hooksecurefunc("ChallengesFrame_Update", Hook.ChallengesFrame_Update)

    -----------------------------
    -- ChallengesKeystoneFrame --
    -----------------------------
    -- /run ChallengesKeystoneFrame:Show()
    local ChallengesKeystoneFrame = _G.ChallengesKeystoneFrame
    _G.hooksecurefunc(ChallengesKeystoneFrame, "Reset", Hook.ChallengesKeystoneFrameMixin_Reset)
    _G.hooksecurefunc(ChallengesKeystoneFrame, "OnKeystoneSlotted", Hook.ChallengesKeystoneFrameMixin_OnKeystoneSlotted)

    ChallengesKeystoneFrame:GetRegions():Hide()
    Base.SetBackdrop(ChallengesKeystoneFrame)
    Skin.UIPanelCloseButton(ChallengesKeystoneFrame.CloseButton)
    Skin.UIPanelButtonTemplate(ChallengesKeystoneFrame.StartButton)

    --[[ Scale ]]--


    ---------------------
    -- ChallengesFrame --
    ---------------------
    local ChallengesFrame = _G.ChallengesFrame
    Skin.InsetFrameTemplate(_G.ChallengesFrameInset)

    if private.isPatch then
        ChallengesFrame.WeeklyInfo:SetPoint("TOPLEFT")
        ChallengesFrame.WeeklyInfo:SetPoint("BOTTOMRIGHT")
        Skin.ChallengesKeystoneFrameAffixTemplate(ChallengesFrame.WeeklyInfo.Child.Affixes[1])
    else
        ChallengesFrame.WeeklyBest:SetPoint("TOPLEFT")
        ChallengesFrame.WeeklyBest:SetPoint("BOTTOMRIGHT")
        ChallengesFrame.WeeklyBest.Child.Star:SetPoint("TOPLEFT", 54, -41)

        ChallengesFrame.GuildBest.Line:SetColorTexture(0.7, 0.7, 0.7)
        ChallengesFrame.GuildBest.Line:SetPoint("TOP", 0, -24)
        ChallengesFrame.GuildBest.Line:SetHeight(1)
    end

    local bg, inset = ChallengesFrame:GetRegions()
    bg:Hide()
    inset:Hide()

    --[[ Scale ]]--
end
