local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do AddOns\Blizzard_AdventureMap.lua
end ]]

do --[[ AddOns\Blizzard_AdventureMap.xml ]]
    function Skin.AdventureMapQuestRewardTemplate(Button)
        Base.CropIcon(Button.Icon, Button)

        Button.ItemNameBG:SetAlpha(0)
        local nameBG = _G.CreateFrame("Frame", nil, Button)
        nameBG:SetPoint("TOPLEFT", Button.Icon, "TOPRIGHT", 2, 1)
        nameBG:SetPoint("BOTTOMRIGHT")
        Base.SetBackdrop(nameBG, Color.frame)
    end
end

function private.AddOns.Blizzard_AdventureMap()
    ----====####$$$$%%%%$$$$####====----
    --   Blizzard_AdventureMapUtils   --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --   AM_ZoneSummaryDataProvider   --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --         AM_QuestDialog         --
    ----====####$$$$%%%%$$$$####====----
    local AdventureMapQuestChoiceDialog = _G.AdventureMapQuestChoiceDialog

    AdventureMapQuestChoiceDialog.Rewards:SetAlpha(0)
    AdventureMapQuestChoiceDialog.Background:Hide()

    Base.SetBackdrop(AdventureMapQuestChoiceDialog)
    local bg = AdventureMapQuestChoiceDialog:GetBackdropTexture("bg")
    bg:SetPoint("TOPLEFT", 3, -14)
    bg:SetPoint("BOTTOMRIGHT", -3, -1)

    Skin.UIPanelCloseButton(AdventureMapQuestChoiceDialog.CloseButton)

    local ScrollBar = AdventureMapQuestChoiceDialog.Details.ScrollBar
    Skin.UIPanelScrollUpButtonTemplate(ScrollBar.ScrollUpButton)
    Skin.UIPanelScrollUpButtonTemplate(ScrollBar.ScrollDownButton)
    Skin.ScrollBarThumb(ScrollBar.ThumbTexture)
    ScrollBar.Top:Hide()
    ScrollBar.Bottom:Hide()
    ScrollBar.Middle:Hide()
    ScrollBar.Background:Hide()

    Skin.UIPanelButtonTemplate(AdventureMapQuestChoiceDialog.DeclineButton)
    Skin.UIPanelButtonTemplate(AdventureMapQuestChoiceDialog.AcceptButton)


    ----====####$$$$%%%%$$$$####====----
    --   AM_QuestChoiceDataProvider   --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    --    AM_QuestOfferDataProvider    --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --     AM_MissionDataProvider     --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --   Blizzard_AdventureMapInset   --
    ----====####$$$$%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    --      Blizzard_AdventureMap      --
    ----====####$$$$%%%%%$$$$####====----

end
