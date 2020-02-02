local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_LookingForGuildUI.lua ]]
    function Hook.LookingForGuildFrame_CreateUIElements()
        Skin.ButtonFrameTemplate(_G.LookingForGuildFrame)
        Skin.LookingForGuildFrameTemplate(_G.LookingForGuildFrame)

        Skin.LookingForGuildStartFrameTemplate(_G.LookingForGuildStartFrame)
        Skin.LookingForGuildBrowseFrameTemplate(_G.LookingForGuildBrowseFrame)
        Skin.LookingForGuildAppsFrameTemplate(_G.LookingForGuildAppsFrame)
    end
end

do --[[ FrameXML\Blizzard_LookingForGuildUI.xml ]]
    Skin.LookingForGuildCheckButtonTemplate = Skin.UICheckButtonTemplate
    function Skin.LookingForGuildSectionTemplate(Frame)
    end
    local paramToRole = {
        [8] = "iconTANK",
        [9] = "iconHEALER",
        [10] = "iconDAMAGER",
    }
    function Skin.LookingForGuildRoleTemplate(Button)
        Button.cover:SetColorTexture(0, 0, 0)
        Base.SetTexture(Button:GetNormalTexture(), paramToRole[Button.param])
        Skin.UICheckButtonTemplate(Button.checkButton)
        Button.checkButton:SetPoint("BOTTOMLEFT", -4, -4)
    end
    function Skin.LookingForGuildGuildTemplate(Button)
        local name = Button:GetName()

        Base.SetBackdrop(Button, Color.button)
        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 0, -1)
        bg:SetPoint("BOTTOMRIGHT", 0, 1)

        Button.selectedTex:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)
        Button.border:SetSize(38, 38)
        Button.border:SetPoint("TOPLEFT", Button.tabard)
        _G[name.."Ring"]:Hide()

        Button.pendingFrame.pendingTex:SetAllPoints()

        _G[name.."Highlight"]:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
    end
    function Skin.LookingForGuildAppTemplate(Button)
        Base.SetBackdrop(Button, Color.button)
        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 0, -1)
        bg:SetPoint("BOTTOMRIGHT", 0, 1)

        Button:GetHighlightTexture():SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
    end

    function Skin.LookingForGuildFrameTemplate(Frame)
        _G.LookingForGuildFrameTabardBackground:Hide()
        _G.LookingForGuildFrameTabardEmblem:Hide()
        _G.LookingForGuildFrameTabardBorder:Hide()

        Skin.TabButtonTemplate(_G.LookingForGuildFrameTab1)
        Skin.TabButtonTemplate(_G.LookingForGuildFrameTab2)
        Skin.TabButtonTemplate(_G.LookingForGuildFrameTab3)
    end
    function Skin.LookingForGuildStartFrameTemplate(Frame)
        Skin.LookingForGuildSectionTemplate(_G.LookingForGuildInterestFrame)
        Skin.LookingForGuildCheckButtonTemplate(_G.LookingForGuildQuestButton)
        Skin.LookingForGuildCheckButtonTemplate(_G.LookingForGuildRaidButton)
        Skin.LookingForGuildCheckButtonTemplate(_G.LookingForGuildDungeonButton)
        Skin.LookingForGuildCheckButtonTemplate(_G.LookingForGuildPvPButton)
        Skin.LookingForGuildCheckButtonTemplate(_G.LookingForGuildRPButton)

        Skin.LookingForGuildSectionTemplate(_G.LookingForGuildAvailabilityFrame)
        Skin.LookingForGuildCheckButtonTemplate(_G.LookingForGuildWeekdaysButton)
        Skin.LookingForGuildCheckButtonTemplate(_G.LookingForGuildWeekendsButton)

        Skin.LookingForGuildSectionTemplate(_G.LookingForGuildRolesFrame)
        Skin.LookingForGuildRoleTemplate(_G.LookingForGuildTankButton)
        Skin.LookingForGuildRoleTemplate(_G.LookingForGuildHealerButton)
        Skin.LookingForGuildRoleTemplate(_G.LookingForGuildDamagerButton)

        Skin.LookingForGuildSectionTemplate(_G.LookingForGuildCommentFrame)
        Base.SetBackdrop(_G.LookingForGuildCommentInputFrame)
        for i = 1, 9 do
            select(i, _G.LookingForGuildCommentInputFrame:GetRegions()):Hide()
        end

        Skin.MagicButtonTemplate(_G.LookingForGuildBrowseButton)
    end
    function Skin.LookingForGuildBrowseFrameTemplate(Frame)
        Skin.HybridScrollBarTemplate(_G.LookingForGuildBrowseFrameContainerScrollBar)
        Skin.MagicButtonTemplate(_G.LookingForGuildRequestButton)
    end
    function Skin.LookingForGuildAppsFrameTemplate(Frame)
        Skin.MagicButtonTemplate(_G.LookingForGuildBrowseButton)
    end
end

function private.AddOns.Blizzard_LookingForGuildUI()
    _G.hooksecurefunc("LookingForGuildFrame_CreateUIElements", Hook.LookingForGuildFrame_CreateUIElements)
end
