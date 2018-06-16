local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_ChallengesUI.lua ]]
    local skinnedIndex = 1
    function Hook.ChallengesFrame_Update(self)
        for i, icon in ipairs(self.DungeonIcons) do
            if i > skinnedIndex then
                Skin.ChallengesDungeonIconFrameTemplate(icon)
                skinnedIndex = i
            end
        end
    end
    function Hook.ChallengesKeystoneFrameMixin_Reset(self)
        self.InstructionBackground:Hide()
        --self.InstructionBackground:SetAlpha(0.5)
    end
    function Hook.ChallengesKeystoneFrameAffixMixin_SetUp(self, affixInfo)
        if not self._auroraSkinned then
            Skin.ChallengesKeystoneFrameAffixTemplate(self)
            self._auroraSkinned = true
        end

        self.Portrait:SetTexture(nil)
        if self.info then
            self.Portrait:SetTexture(_G.CHALLENGE_MODE_EXTRA_AFFIX_INFO[self.info.key].texture)
        elseif self.affixID then
            local _, _, filedataid = _G.C_ChallengeMode.GetAffixInfo(self.affixID)
            self.Portrait:SetTexture(filedataid)
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

    ChallengesKeystoneFrame:GetRegions():Hide()
    Base.SetBackdrop(ChallengesKeystoneFrame)
    Skin.UIPanelCloseButton(ChallengesKeystoneFrame.CloseButton)
    Skin.UIPanelButtonTemplate(ChallengesKeystoneFrame.StartButton)
    Skin.ChallengesKeystoneFrameAffixTemplate(ChallengesKeystoneFrame.Affixes[1])

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

    Skin.ChallengesDungeonIconFrameTemplate(ChallengesFrame.DungeonIcons[1])

    local bg, inset = ChallengesFrame:GetRegions()
    bg:Hide()
    inset:Hide()

    --[[ Scale ]]--
end
