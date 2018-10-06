local _, private = ...

-- [[ Lua Globals ]]
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)

function private.AddOns.Blizzard_PVPUI()
    local r, g, b = C.r, C.g, C.b

    local PVPQueueFrame = _G.PVPQueueFrame
    local HonorFrame = _G.HonorFrame
    local ConquestFrame = _G.ConquestFrame

    -- Category buttons
    for i = 1, 3 do
        local bu = PVPQueueFrame["CategoryButton"..i]
        local icon = bu.Icon
        local cu = bu.CurrencyDisplay

        bu.Ring:Hide()

        F.Reskin(bu, true)

        bu.Background:SetAllPoints()
        bu.Background:SetColorTexture(r, g, b, .2)
        bu.Background:Hide()

        icon:SetTexCoord(.08, .92, .08, .92)
        icon:SetPoint("LEFT", bu, "LEFT")
        icon:SetDrawLayer("OVERLAY")
        icon.bg = F.CreateBG(icon)
        icon.bg:SetDrawLayer("ARTWORK")

        if cu then
            local ic = cu.Icon

            ic:SetSize(16, 16)
            ic:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
            cu.Amount:SetPoint("LEFT", ic, "RIGHT", 4, 0)

            ic:SetTexCoord(.08, .92, .08, .92)
            ic.bg = F.CreateBG(ic)
            ic.bg:SetDrawLayer("BACKGROUND", 1)
        end
    end

    PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
    PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
    PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

    hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
        local self = PVPQueueFrame
        for i = 1, 3 do
            local bu = self["CategoryButton"..i]
            if i == index then
                bu.Background:Show()
            else
                bu.Background:Hide()
            end
        end
    end)

    PVPQueueFrame.CategoryButton1.Background:Show()

    -- Casual - HonorFrame

    local Inset = HonorFrame.Inset
    local BonusFrame = HonorFrame.BonusFrame

    for i = 1, 9 do
        select(i, Inset:GetRegions()):Hide()
    end
    BonusFrame.WorldBattlesTexture:Hide()
    BonusFrame.ShadowOverlay:Hide()

    for _, bonusButton in pairs({"RandomBGButton", "RandomEpicBGButton", "Arena1Button", "BrawlButton"}) do
        local bu = BonusFrame[bonusButton]
        local reward = bu.Reward

        F.Reskin(bu)

        bu.SelectedTexture:SetDrawLayer("BACKGROUND")
        bu.SelectedTexture:SetColorTexture(r, g, b, .2)
        bu.SelectedTexture:SetAllPoints()

        if reward then
            reward.Border:Hide()
            F.ReskinIcon(reward.Icon)
        end
    end

    -- Honor frame specific

    for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
        bu.Bg:Hide()
        bu.Border:Hide()

        bu:SetNormalTexture("")
        bu:SetHighlightTexture("")

        local bg = CreateFrame("Frame", nil, bu)
        bg:SetPoint("TOPLEFT", 2, 0)
        bg:SetPoint("BOTTOMRIGHT", -1, 2)
        F.CreateBD(bg, 0)
        bg:SetFrameLevel(bu:GetFrameLevel()-1)

        bu.tex = F.CreateGradient(bu)
        bu.tex:SetDrawLayer("BACKGROUND")
        bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
        bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        bu.SelectedTexture:SetDrawLayer("BACKGROUND")
        bu.SelectedTexture:SetColorTexture(r, g, b, .2)
        bu.SelectedTexture:SetAllPoints(bu.tex)

        bu.Icon:SetTexCoord(.08, .92, .08, .92)
        bu.Icon.bg = F.CreateBG(bu.Icon)
        bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
        bu.Icon:SetPoint("TOPLEFT", 5, -3)
    end

    -- Rated - ConquestFrame

    Inset = ConquestFrame.Inset

    for i = 1, 9 do
        select(i, Inset:GetRegions()):Hide()
    end
    ConquestFrame.RatedBGTexture:Hide()
    ConquestFrame.ShadowOverlay:Hide()

    F.CreateBD(_G.ConquestTooltip)
    local ConquestFrameButton_OnEnter = function(self)
        if private.isPatch then
            _G.ConquestTooltip:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 1, 0)
        else
            _G.ConquestTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, 0)
        end
    end

    ConquestFrame.Arena2v2:HookScript("OnEnter", ConquestFrameButton_OnEnter)
    ConquestFrame.Arena3v3:HookScript("OnEnter", ConquestFrameButton_OnEnter)
    ConquestFrame.RatedBG:HookScript("OnEnter", ConquestFrameButton_OnEnter)

    for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.RatedBG}) do
        F.Reskin(bu)
        local reward = bu.Reward

        bu.SelectedTexture:SetDrawLayer("BACKGROUND")
        bu.SelectedTexture:SetColorTexture(r, g, b, .2)
        bu.SelectedTexture:SetAllPoints()

        if reward then
            reward.Border:Hide()
            F.ReskinIcon(reward.Icon)
        end
    end

    ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)

    -- Main style

    F.Reskin(HonorFrame.QueueButton)
    F.Reskin(ConquestFrame.JoinButton)
    F.ReskinDropDown(_G.HonorFrameTypeDropDown)
    F.ReskinScroll(_G.HonorFrameSpecificFrameScrollBar)
end
