local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\LootFrame.lua ]]
    function Hook.LootFrame_UpdateButton(index)
        local LootFrame = _G.LootFrame
        local numLootItems = LootFrame.numLootItems
        --Logic to determine how many items to show per page
        local numLootToShow = _G.LOOTFRAME_NUMBUTTONS
        if LootFrame.AutoLootTable then
            numLootItems = #LootFrame.AutoLootTable
        end
        if numLootItems > _G.LOOTFRAME_NUMBUTTONS then
            numLootToShow = numLootToShow - 1 -- make space for the page buttons
        end

        local button = _G["LootButton"..index]
        local slot = (numLootToShow * (LootFrame.page - 1)) + index

        if slot <= numLootItems then
            local _, isQuestItem, isActive
            if LootFrame.AutoLootTable then
                local entry = LootFrame.AutoLootTable[slot]
                if not entry.hide then
                    isQuestItem = entry.isQuestItem
                end
            else
                _, _, _, _, _, _, isQuestItem, _, isActive = _G.GetLootSlotInfo(slot)
            end

            local questTexture = button._questTexture
            if isQuestItem then
                button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)

                if private.isClassic then
                    questTexture:Show()

                    if isActive then
                        questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BANG)
                    else
                        questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BORDER)
                    end
                end
            else
                questTexture:Hide()
            end
        end
    end
    function Hook.BonusRollFrame_OnShow(self)
        self.PromptFrame.Timer:SetFrameLevel(self:GetFrameLevel())
    end
end

do --[[ FrameXML\LootFrame.xml ]]
    function Skin.LootButtonTemplate(Frame)
        Skin.FrameTypeItemButton(Frame)

        local name = Frame:GetName()
        _G[name.."NameFrame"]:Hide()
        Frame._questTexture = _G[name.."IconQuestTexture"]
        if private.isClassic then
            Frame._questTexture = Frame:CreateTexture(nil, "ARTWORK")
            Frame._questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BORDER)
        end

        Frame._questTexture:SetAllPoints(Frame)
        Base.CropIcon(Frame._questTexture)

        --local bg = F.CreateBDFrame(nameFrame, .2)
        --bg:SetPoint("TOPLEFT", Button.icon, "TOPRIGHT", 3, 1)
        --bg:SetPoint("BOTTOMRIGHT", nameFrame, -5, 11)

        local bg = Frame:GetBackdropTexture("bg")
        local nameBG = _G.CreateFrame("Frame", nil, Frame)
        nameBG:SetFrameLevel(Frame:GetFrameLevel())
        nameBG:SetPoint("TOPLEFT", bg, "TOPRIGHT", 1, 0)
        nameBG:SetPoint("RIGHT", 115, 0)
        nameBG:SetPoint("BOTTOM", bg)
        Base.SetBackdrop(nameBG, Color.frame)
        Frame._auroraNameBG = nameBG

        Frame:SetNormalTexture("")
        Frame:SetPushedTexture("")
    end
    function Skin.BonusRollFrameTemplate(Frame)
        Frame:HookScript("OnShow", Hook.BonusRollFrame_OnShow)

        Base.SetBackdrop(Frame)
        Frame:SetSize(270, 60)

        Frame.Background:SetAlpha(0)
        Frame.LootSpinnerBG:SetPoint("TOPLEFT", 4, -4)
        Frame.IconBorder:Hide()

        Base.CropIcon(Frame.SpecIcon, Frame)
        Frame.SpecIcon:SetSize(18, 18)
        Frame.SpecIcon:SetPoint("TOPLEFT", -9, 9)
        Frame.SpecRing:SetAlpha(0)

        local textFrame = _G.CreateFrame("Frame", nil, Frame)
        Base.SetBackdrop(textFrame, Color.frame)
        textFrame:SetFrameLevel(Frame:GetFrameLevel())

        local rollingFrame = Frame.RollingFrame
        rollingFrame.Label:SetAllPoints(textFrame)
        rollingFrame.LootSpinnerFinalText:SetAllPoints(textFrame)
        rollingFrame.DieIcon:SetPoint("TOPRIGHT", -40, -10)
        rollingFrame.DieIcon:SetSize(32, 32)

        local promptFrame = Frame.PromptFrame
        Base.CropIcon(promptFrame.Icon, promptFrame)
        promptFrame.Icon:SetAllPoints(Frame.LootSpinnerBG)

        promptFrame.InfoFrame:SetPoint("TOPLEFT", textFrame, 4, 0)
        promptFrame.InfoFrame:SetPoint("BOTTOMRIGHT", textFrame)

        Skin.FrameTypeStatusBar(promptFrame.Timer)
        promptFrame.Timer:SetHeight(6)
        promptFrame.Timer:SetPoint("BOTTOMLEFT", 4, 4)
        promptFrame.RollButton:SetPoint("TOPRIGHT", -40, -10)

        Frame.BlackBackgroundHoist:Hide()

        textFrame:SetPoint("TOPLEFT", promptFrame.Icon, "TOPRIGHT", 4, 1)
        textFrame:SetPoint("BOTTOMRIGHT", promptFrame.Timer, "TOPRIGHT", 1, 3)

        Frame.CurrentCountFrame:SetPoint("BOTTOMRIGHT", -2, 0)
    end
    function Skin.GroupLootFrameTemplate(Frame)
    end

    function Skin.LootNavButton(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })
    end
end

function private.FrameXML.LootFrame()
    _G.hooksecurefunc("LootFrame_UpdateButton", Hook.LootFrame_UpdateButton)

    ---------------
    -- LootFrame --
    ---------------
    local LootFrame = _G.LootFrame
    Skin.ButtonFrameTemplate(LootFrame)
    _G.LootFramePortraitOverlay:Hide()

    if private.isRetail then
        select(7, _G.LootFrame:GetRegions()):SetPoint("TOP", _G.LootFrame, "TOP", 0, -7)
    else
        select(19, LootFrame:GetRegions()):SetAllPoints(LootFrame.TitleText) -- Items text
    end

    for index = 1, 4 do
        Skin.LootButtonTemplate(_G["LootButton"..index])
    end
    Util.PositionRelative("TOPLEFT", LootFrame, "TOPLEFT", 9, -(private.FRAME_TITLE_HEIGHT + 5), 17, "Down", {
        _G.LootButton1,
        _G.LootButton2,
        _G.LootButton3,
        _G.LootButton4,
    })

    do -- LootFrameUpButton
        Skin.LootNavButton(_G.LootFrameUpButton)
        _G.LootFrameUpButton:SetPoint("BOTTOMLEFT", 10, 10)

        local bg = _G.LootFrameUpButton:GetBackdropTexture("bg")
        local arrow = _G.LootFrameUpButton:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", bg, 5, -8)
        arrow:SetPoint("BOTTOMRIGHT", bg, -5, 8)
        Base.SetTexture(arrow, "arrowUp")
        _G.LootFramePrev:ClearAllPoints()
        _G.LootFramePrev:SetPoint("LEFT", _G.LootFrameUpButton, "RIGHT", 4, 0)
    end
    do -- LootFrameDownButton
        Skin.LootNavButton(_G.LootFrameDownButton)
        _G.LootFrameDownButton:ClearAllPoints()
        _G.LootFrameDownButton:SetPoint("BOTTOMRIGHT", -10, 10)

        local bg = _G.LootFrameDownButton:GetBackdropTexture("bg")
        local arrow = _G.LootFrameDownButton:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", bg, 5, -8)
        arrow:SetPoint("BOTTOMRIGHT", bg, -5, 8)
        Base.SetTexture(arrow, "arrowDown")
        _G.LootFrameNext:ClearAllPoints()
        _G.LootFrameNext:SetPoint("RIGHT", _G.LootFrameDownButton, "LEFT", -4, 0)
    end


    --------------------
    -- BonusRollFrame --
    --------------------
    if private.isRetail then
        Skin.BonusRollFrameTemplate(_G.BonusRollFrame)
    end


    ---------------
    -- GroupLoot --
    ---------------
    Skin.GroupLootFrameTemplate(_G.GroupLootFrame1)
    Skin.GroupLootFrameTemplate(_G.GroupLootFrame2)
    Skin.GroupLootFrameTemplate(_G.GroupLootFrame3)
    Skin.GroupLootFrameTemplate(_G.GroupLootFrame4)


    -----------------------
    -- MasterLooterFrame --
    -----------------------
    if private.isClassic then
        local MasterLooterFrame = _G.MasterLooterFrame
        for i = 1, 9 do
            select(i, MasterLooterFrame:GetRegions()):Hide()
        end
        F.CreateBD(MasterLooterFrame)
        F.ReskinClose(select(3, MasterLooterFrame:GetChildren()))

        local item = MasterLooterFrame.Item
        item.NameBorderLeft:Hide()
        item.NameBorderRight:Hide()
        item.NameBorderMid:Hide()
        item._auroraIconBorder = F.ReskinIcon(item.Icon)

        MasterLooterFrame:HookScript("OnShow", function(MLFrame)
            _G.LootFrame:SetAlpha(.4)
        end)

        MasterLooterFrame:HookScript("OnHide", function(MLFrame)
            _G.LootFrame:SetAlpha(1)
        end)

        _G.hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
            for i = 1, _G.MAX_RAID_MEMBERS do
                local playerFrame = MasterLooterFrame["player"..i]
                if playerFrame then
                    if not playerFrame.styled then
                        playerFrame.Bg:SetPoint("TOPLEFT", 1, -1)
                        playerFrame.Bg:SetPoint("BOTTOMRIGHT", -1, 1)
                        playerFrame.Highlight:SetPoint("TOPLEFT", 1, -1)
                        playerFrame.Highlight:SetPoint("BOTTOMRIGHT", -1, 1)

                        playerFrame.Highlight:SetTexture(C.media.backdrop)

                        F.CreateBD(playerFrame, 0)

                        playerFrame.styled = true
                    end
                    local colour = _G.CUSTOM_CLASS_COLORS[select(2, _G.UnitClass(playerFrame.Name:GetText()))]
                    playerFrame.Name:SetTextColor(colour.r, colour.g, colour.b)
                    playerFrame.Highlight:SetVertexColor(colour.r, colour.g, colour.b, .2)
                else
                    break
                end
            end
        end)
    end
end
