local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals pcall ipairs select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_TradeSkillUI.lua ]]
    local hadScroll = false
    function Hook.TradeSkillFrame_Update(id)
        local hasScroll = _G.TradeSkillListScrollFrame:IsVisible()
        local updateBackdrops = hadScroll ~= hasScroll

        for i = 1, _G.TRADE_SKILLS_DISPLAYED do
            local skillButton = _G["TradeSkillSkill"..i]
            local _, skillType = _G.GetTradeSkillInfo(skillButton:GetID())

            if skillType == "header" then
                skillButton._minus:Show()
                skillButton:GetHighlightTexture():SetTexture("")
            else
                skillButton._minus:Hide()
                skillButton._plus:Hide()
            end

            if updateBackdrops then
                if hasScroll then
                    skillButton:SetBackdropOption("offsets", {
                        left = 3,
                        right = 277,
                        top = 0,
                        bottom = 3,
                    })
                else
                    skillButton:SetBackdropOption("offsets", {
                        left = 3,
                        right = 307,
                        top = 0,
                        bottom = 3,
                    })
                end
            end
        end
        hadScroll = hasScroll
    end
    function Hook.TradeSkillFrame_SetSelection(id)
        local _, skillType = _G.GetTradeSkillInfo(id)
        if skillType == "header" then return end

        if not skillType then
            return Hook.SetItemButtonQuality(_G.TradeSkillSkillIcon, 0)
        end

        local link = _G.GetTradeSkillItemLink(id)
        local _, _, quality = _G.GetItemInfo(link)
        Hook.SetItemButtonQuality(_G.TradeSkillSkillIcon, quality, link)
        Base.CropIcon(_G.TradeSkillSkillIcon:GetNormalTexture())

        local numReagents = _G.GetTradeSkillNumReagents(id)
        for i = 1, numReagents do
            link = _G.GetTradeSkillReagentItemLink(id, i)
            _, _, quality = _G.GetItemInfo(link)
            Hook.SetItemButtonQuality(_G["TradeSkillReagent"..i], quality, link)
        end
    end
end

do --[[ AddOns\Blizzard_TradeSkillUI.xml ]]
    Skin.TradeSkillSkillButtonTemplate = Skin.ClassTrainerSkillButtonTemplate
    Skin.TradeSkillItemTemplate = Skin.QuestItemTemplate
end

function private.AddOns.Blizzard_TradeSkillUI()
    local TradeSkillFrame = _G.TradeSkillFrame
    _G.hooksecurefunc("TradeSkillFrame_Update", Hook.TradeSkillFrame_Update)
    _G.hooksecurefunc("TradeSkillFrame_SetSelection", Hook.TradeSkillFrame_SetSelection)

    Skin.FrameTypeFrame(TradeSkillFrame)
    TradeSkillFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local tradeSkillBG = TradeSkillFrame:GetBackdropTexture("bg")
    local portrait, tl, tr, bl, br = TradeSkillFrame:GetRegions()
    portrait:Hide()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    local titleText = _G.TradeSkillFrameTitleText
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT", tradeSkillBG)
    titleText:SetPoint("BOTTOMRIGHT", tradeSkillBG, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    local borderLeft, borderRight = select(7, TradeSkillFrame:GetRegions())
    borderLeft:Hide()
    borderRight:Hide()

    local barLeft, barRight = select(9, TradeSkillFrame:GetRegions())
    barLeft:SetColorTexture(Color.gray:GetRGB())
    barLeft:SetPoint("TOPLEFT", tradeSkillBG, 10, -210)
    barLeft:SetPoint("BOTTOMRIGHT", tradeSkillBG, "TOPRIGHT", -10, -211)
    barRight:Hide()

    Skin.FrameTypeStatusBar(_G.TradeSkillRankFrame)
    _G.TradeSkillRankFrame:SetPoint("TOPLEFT", tradeSkillBG, 20, -30)
    _G.TradeSkillRankFrame:SetPoint("TOPRIGHT", tradeSkillBG, -20, -30)
    _G.TradeSkillRankFrameSkillName:SetPoint("LEFT", 6, 0)
    _G.TradeSkillRankFrameBackground:Hide()
    _G.TradeSkillRankFrameBorder:Hide()

    local left, middle, right = _G.TradeSkillExpandButtonFrame:GetRegions()
    left:Hide()
    middle:Hide()
    right:Hide()
    Skin.ClassTrainerSkillButtonTemplate(_G.TradeSkillCollapseAllButton)
    _G.TradeSkillCollapseAllButton:SetBackdropOption("offsets", {
        left = 3,
        right = 24,
        top = 0,
        bottom = 9,
    })

    Skin.UIDropDownMenuTemplate(_G.TradeSkillInvSlotDropDown)
    Skin.UIDropDownMenuTemplate(_G.TradeSkillSubClassDropDown)

    for i = 1, _G.TRADE_SKILLS_DISPLAYED do
        Skin.TradeSkillSkillButtonTemplate(_G["TradeSkillSkill"..i])
    end

    Skin.ClassTrainerListScrollFrameTemplate(_G.TradeSkillListScrollFrame)
    Skin.ClassTrainerDetailScrollFrameTemplate(_G.TradeSkillDetailScrollFrame)
    local headerLeft, headerRight = select(5, _G.TradeSkillDetailScrollChildFrame:GetRegions())
    headerLeft:Hide()
    headerRight:Hide()

    do -- TradeSkillSkillIcon
        local item = _G.TradeSkillSkillIcon
        Base.CreateBackdrop(item, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        Base.CropIcon(item:GetBackdropTexture("bg"))
        Base.SetBackdrop(item, Color.black, Color.frame.a)
        item._auroraIconBorder = item

        item:SetBackdropColor(1, 1, 1, 0.75)
        item:SetBackdropBorderColor(Color.frame, 1)
    end
    for i = 1, _G.MAX_TRADE_SKILL_REAGENTS do
        Skin.TradeSkillItemTemplate(_G["TradeSkillReagent"..i])
    end

    Skin.UIPanelButtonTemplate(_G.TradeSkillCreateButton)
    Skin.UIPanelButtonTemplate(_G.TradeSkillCancelButton)
    Util.PositionRelative("BOTTOMRIGHT", tradeSkillBG, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.TradeSkillCancelButton,
        _G.TradeSkillCreateButton,
    })
    Skin.UIPanelButtonTemplate(_G.TradeSkillCreateAllButton)
    _G.TradeSkillCreateAllButton:ClearAllPoints()
    _G.TradeSkillCreateAllButton:SetPoint("BOTTOMLEFT", tradeSkillBG, 5, 5)

    do -- NumericInputSpinner
        Skin.FrameTypeEditBox(_G.TradeSkillInputBox)
        _G.TradeSkillInputBoxLeft:Hide()
        _G.TradeSkillInputBoxRight:Hide()
        _G.TradeSkillInputBoxMiddle:Hide()
        _G.TradeSkillInputBox:SetBackdropOption("offsets", {
            left = -4,
            right = 1,
            top = 0,
            bottom = 0,
        })

        Skin.SpinnerButton(_G.TradeSkillDecrementButton)
        Base.SetTexture(_G.TradeSkillDecrementButton._auroraTextures[1], "arrowLeft")

        Skin.SpinnerButton(_G.TradeSkillIncrementButton)
        Base.SetTexture(_G.TradeSkillIncrementButton._auroraTextures[1], "arrowRight")
    end

    Skin.UIPanelCloseButton(_G.TradeSkillFrameCloseButton)
end
