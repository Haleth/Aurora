local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_CraftUI.lua ]]
    local hadScroll = false
    function Hook.CraftFrame_Update(id)
        local hasScroll = _G.CraftListScrollFrame:IsVisible()
        local updateBackdrops = hadScroll ~= hasScroll

        for i = 1, _G.CRAFTS_DISPLAYED do
            local skillButton = _G["Craft"..i]
            local _, _, skillType = _G.GetCraftInfo(skillButton:GetID())

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
    function Hook.CraftFrame_SetSelection(id)
        if not id then return end

        local _, _, skillType = _G.GetCraftInfo(id)
        if skillType == "header" then return end

        if not skillType then
            return Hook.SetItemButtonQuality(_G.CraftIcon, 0)
        end

        local link = _G.GetCraftItemLink(id)
        if link then
            local _, _, quality = _G.GetItemInfo(link)
            Hook.SetItemButtonQuality(_G.CraftIcon, quality, link)
            Base.CropIcon(_G.CraftIcon:GetNormalTexture())

            local numReagents = _G.GetCraftNumReagents(id)
            for i = 1, numReagents do
                link = _G.GetCraftReagentItemLink(id, i)
                _, _, quality = _G.GetItemInfo(link)
                Hook.SetItemButtonQuality(_G["CraftReagent"..i], quality, link)
            end
        end
    end
end

do --[[ AddOns\Blizzard_CraftUI.xml ]]
    Skin.CraftButtonTemplate = Skin.ClassTrainerSkillButtonTemplate
    Skin.CraftItemTemplate = Skin.QuestItemTemplate
end

function private.AddOns.Blizzard_CraftUI()
    local CraftFrame = _G.CraftFrame
    _G.hooksecurefunc("CraftFrame_Update", Hook.CraftFrame_Update)
    _G.hooksecurefunc("CraftFrame_SetSelection", Hook.CraftFrame_SetSelection)

    Skin.FrameTypeFrame(CraftFrame)
    CraftFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local craftBG = CraftFrame:GetBackdropTexture("bg")
    local portrait, tl, tr, bl, br = CraftFrame:GetRegions()
    portrait:Hide()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    local titleText = _G.CraftFrameTitleText
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT", craftBG)
    titleText:SetPoint("BOTTOMRIGHT", craftBG, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    local borderLeft, borderRight = select(7, CraftFrame:GetRegions())
    borderLeft:SetAlpha(0)
    borderRight:SetAlpha(0)

    local barLeft, barRight = select(9, CraftFrame:GetRegions())
    barLeft:SetColorTexture(Color.gray:GetRGB())
    barLeft:SetPoint("TOPLEFT", craftBG, 10, -210)
    barLeft:SetPoint("BOTTOMRIGHT", craftBG, "TOPRIGHT", -10, -211)
    barRight:Hide()

    Skin.FrameTypeStatusBar(_G.CraftRankFrame)
    _G.CraftRankFrame:SetPoint("TOPLEFT", craftBG, 20, -30)
    _G.CraftRankFrame:SetPoint("TOPRIGHT", craftBG, -20, -30)
    _G.CraftRankFrameSkillName:SetPoint("LEFT", 6, 0)
    _G.CraftRankFrameBackground:Hide()
    _G.CraftRankFrameBorder:Hide()

    local left, middle, right = _G.CraftExpandButtonFrame:GetRegions()
    left:Hide()
    middle:Hide()
    right:Hide()
    Skin.ClassTrainerSkillButtonTemplate(_G.CraftCollapseAllButton)
    _G.CraftCollapseAllButton:SetBackdropOption("offsets", {
        left = 3,
        right = 24,
        top = 0,
        bottom = 9,
    })

    for i = 1, _G.CRAFTS_DISPLAYED do
        Skin.CraftButtonTemplate(_G["Craft"..i])
    end

    Skin.ClassTrainerListScrollFrameTemplate(_G.CraftListScrollFrame)
    Skin.ClassTrainerDetailScrollFrameTemplate(_G.CraftDetailScrollFrame)
    local headerLeft, headerRight = select(4, _G.CraftDetailScrollChildFrame:GetRegions())
    headerLeft:Hide()
    headerRight:Hide()

    do -- CraftIcon
        local item = _G.CraftIcon
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
    for i = 1, _G.MAX_CRAFT_REAGENTS do
        Skin.CraftItemTemplate(_G["CraftReagent"..i])
    end

    Skin.UIPanelButtonTemplate(_G.CraftCreateButton)
    Skin.UIPanelButtonTemplate(_G.CraftCancelButton)
    Util.PositionRelative("BOTTOMRIGHT", craftBG, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.CraftCancelButton,
        _G.CraftCreateButton,
    })

    Skin.UIPanelCloseButton(_G.CraftFrameCloseButton)
end
