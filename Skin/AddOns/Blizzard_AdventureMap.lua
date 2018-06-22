local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
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
    _G.hooksecurefunc(AdventureMapQuestChoiceDialog.rewardPool, "Acquire", Hook.ObjectPoolMixin_Acquire)

    AdventureMapQuestChoiceDialog.Rewards:SetAlpha(0)
    AdventureMapQuestChoiceDialog.Background:Hide()

    Base.SetBackdrop(AdventureMapQuestChoiceDialog)

    Skin.UIPanelCloseButton(AdventureMapQuestChoiceDialog.CloseButton)
    AdventureMapQuestChoiceDialog.CloseButton:SetPoint("TOPRIGHT", -5, -5)
    Skin.UIPanelButtonTemplate(AdventureMapQuestChoiceDialog.DeclineButton)
    AdventureMapQuestChoiceDialog.DeclineButton:SetPoint("BOTTOMRIGHT", -5, 5)
    Skin.UIPanelButtonTemplate(AdventureMapQuestChoiceDialog.AcceptButton)
    AdventureMapQuestChoiceDialog.AcceptButton:SetPoint("BOTTOMLEFT", 5, 5)

    --[[ Scale ]]--


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
