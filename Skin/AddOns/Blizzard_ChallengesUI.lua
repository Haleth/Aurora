local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

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
    function Skin.MythicPlusSeasonChangesNoticeTemplate(Frame)
        Frame.BottomLeftCorner:Hide()
        Frame.BottomRightCorner:Hide()
        Frame.TopLeftCorner:Hide()
        Frame.TopRightCorner:Hide()

        Frame.BottomBorder:Hide()
        Frame.TopBorder:Hide()
        Frame.LeftBorder:Hide()
        Frame.RightBorder:Hide()

        Frame.LeftHide:Hide()
        Frame.LeftHide2:Hide()
        Frame.RightHide:Hide()
        Frame.RightHide2:Hide()
        Frame.BottomHide:Hide()
        Frame.BottomHide2:Hide()

        Frame.Background:SetColorTexture(Color.black.r, Color.black.g, Color.black.b, 0.75)
        Frame.Background:SetAllPoints()

        Frame.TopLeftFiligree:Hide()
        Frame.TopRightFiligree:Hide()

        Frame.NewSeason:SetTextColor(Color.white:GetRGB())
        Frame.SeasonDescription:SetTextColor(Color.grayLight:GetRGB())
        Frame.SeasonDescription2:SetTextColor(Color.grayLight:GetRGB())
        Frame.SeasonDescription3:SetTextColor(Color.grayLight:GetRGB())

        Skin.ChallengesKeystoneFrameAffixTemplate(Frame.Affix)
        Frame.Affix.AffixBorder:Hide()
        Skin.UIPanelButtonTemplate(Frame.Leave)
    end
    function Skin.ChallengesKeystoneFrameAffixTemplate(Frame)
        Frame.Border:SetAlpha(0)
        Base.CropIcon(Frame.Portrait)
        Frame.Portrait._auroraResetPortrait = true
    end
    function Skin.ChallengesDungeonIconFrameTemplate(Frame)
        Frame:GetRegions():Hide()
        Base.CropIcon(Frame.Icon, Frame)
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


    ---------------------
    -- ChallengesFrame --
    ---------------------
    local ChallengesFrame = _G.ChallengesFrame
    Skin.InsetFrameTemplate(_G.ChallengesFrameInset)

    ChallengesFrame.WeeklyInfo:SetPoint("TOPLEFT")
    ChallengesFrame.WeeklyInfo:SetPoint("BOTTOMRIGHT")
    Skin.ChallengesKeystoneFrameAffixTemplate(ChallengesFrame.WeeklyInfo.Child.Affixes[1])
    Skin.MythicPlusSeasonChangesNoticeTemplate(ChallengesFrame.SeasonChangeNoticeFrame)
    ChallengesFrame.SeasonChangeNoticeFrame:ClearAllPoints()
    ChallengesFrame.SeasonChangeNoticeFrame:SetPoint("TOPLEFT", 0, -private.FRAME_TITLE_HEIGHT)
    ChallengesFrame.SeasonChangeNoticeFrame:SetPoint("BOTTOMRIGHT")
    ChallengesFrame.SeasonChangeNoticeFrame:SetFrameLevel(ChallengesFrame.SeasonChangeNoticeFrame:GetFrameLevel() + 2)

    local bg, inset = ChallengesFrame:GetRegions()
    bg:Hide()
    inset:Hide()
end
