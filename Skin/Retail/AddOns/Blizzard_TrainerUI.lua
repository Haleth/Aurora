local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_TrainerUI.lua ]]
    function Hook.ClassTrainerFrame_Update(id)
        for i = 1, _G.CLASS_TRAINER_SKILLS_DISPLAYED do
            local skillButton = _G["ClassTrainerSkill"..i]
            local _, _, serviceType = _G.GetTrainerServiceInfo(skillButton:GetID())

            if serviceType == "header" then
                skillButton._minus:Show()
                skillButton:GetHighlightTexture():SetTexture("")
            else
                skillButton._minus:Hide()
                skillButton._plus:Hide()
            end
        end
    end
    function Hook.ClassTrainer_SetSelection(id)
        if not id then return end

        local link = _G.GetTrainerServiceItemLink(id)
        if link then
            local _, _, quality = _G.GetItemInfo(link)
            Hook.SetItemButtonQuality(_G.ClassTrainerSkillIcon, quality, link)
        end
    end
    function Hook.ClassTrainer_SetToTradeSkillTrainer(id)
        local bg = _G.ClassTrainerFrame:GetBackdropTexture("bg")
        _G.ClassTrainerHorizontalBarLeft:SetPoint("TOPLEFT", bg, 10, -254)
        _G.ClassTrainerHorizontalBarLeft:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -10, -255)
    end
    function Hook.ClassTrainer_SetToClassTrainer(id)
        local bg = _G.ClassTrainerFrame:GetBackdropTexture("bg")
        _G.ClassTrainerHorizontalBarLeft:SetPoint("TOPLEFT", bg, 10, -270)
        _G.ClassTrainerHorizontalBarLeft:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -10, -271)
    end
end

do --[[ AddOns\Blizzard_TrainerUI.xml ]]
    if private.isRetail then
        function Skin.ClassTrainerSkillButtonTemplate(Button)
            Skin.UIServiceButtonTemplate(Button)
        end
    end
end

function private.AddOns.Blizzard_TrainerUI()
    local ClassTrainerFrame = _G.ClassTrainerFrame
    if private.isRetail then
        Skin.ButtonFrameTemplate(ClassTrainerFrame)

        _G.ClassTrainerFrameMoneyBg:Hide()
        ClassTrainerFrame.BG:Hide()

        Skin.FrameTypeStatusBar(_G.ClassTrainerStatusBar)
        _G.ClassTrainerStatusBarLeft:Hide()
        _G.ClassTrainerStatusBarRight:Hide()
        _G.ClassTrainerStatusBarMiddle:Hide()
        _G.ClassTrainerStatusBarBackground:Hide()
        _G.ClassTrainerStatusBar:SetPoint("TOPLEFT", 8, -35)
        _G.ClassTrainerStatusBar:SetSize(192, 18)

        Skin.UIDropDownMenuTemplate(_G.ClassTrainerFrameFilterDropDown)
        Skin.MagicButtonTemplate(_G.ClassTrainerTrainButton)

        local moneyBG = _G.CreateFrame("Frame", nil, ClassTrainerFrame)
        moneyBG:SetSize(142, 18)
        moneyBG:SetPoint("BOTTOMLEFT", 8, 5)
        Base.SetBackdrop(moneyBG, Color.frame)
        moneyBG:SetBackdropBorderColor(Color.yellow)
        Skin.SmallMoneyFrameTemplate(_G.ClassTrainerFrameMoneyFrame)
        _G.ClassTrainerFrameMoneyFrame:SetPoint("RIGHT", moneyBG, 11, 0)

        Skin.ClassTrainerSkillButtonTemplate(ClassTrainerFrame.skillStepButton)
        Skin.HybridScrollBarTemplate(_G.ClassTrainerScrollFrameScrollBar)
        Skin.InsetFrameTemplate(ClassTrainerFrame.bottomInset)
    else
        _G.hooksecurefunc("ClassTrainerFrame_Update", Hook.ClassTrainerFrame_Update)
        _G.hooksecurefunc("ClassTrainer_SetSelection", Hook.ClassTrainer_SetSelection)
        _G.hooksecurefunc("ClassTrainer_SetToTradeSkillTrainer", Hook.ClassTrainer_SetToTradeSkillTrainer)
        _G.hooksecurefunc("ClassTrainer_SetToClassTrainer", Hook.ClassTrainer_SetToClassTrainer)

        Base.SetBackdrop(ClassTrainerFrame)
        ClassTrainerFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local portrait, tl, tr, bl, br = ClassTrainerFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()

        local bg = ClassTrainerFrame:GetBackdropTexture("bg")
        _G.ClassTrainerNameText:ClearAllPoints()
        _G.ClassTrainerNameText:SetPoint("TOPLEFT", bg)
        _G.ClassTrainerNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        local barLeft, barRight = select(8, ClassTrainerFrame:GetRegions())
        barLeft:SetColorTexture(Color.gray:GetRGB())
        barLeft:SetPoint("TOPLEFT", bg, 10, -270)
        barLeft:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -10, -271)
        barRight:Hide()

        _G.ClassTrainerGreetingText:SetPoint("TOPLEFT", _G.ClassTrainerNameText, "BOTTOMLEFT", 30, 0)
        _G.ClassTrainerGreetingText:SetPoint("TOPRIGHT", _G.ClassTrainerNameText, "BOTTOMRIGHT", -30, 0)

        local left, middle, right = _G.ClassTrainerExpandButtonFrame:GetRegions()
        left:Hide()
        middle:Hide()
        right:Hide()

        Skin.ClassTrainerSkillButtonTemplate(_G.ClassTrainerCollapseAllButton)
        _G.ClassTrainerCollapseAllButton:SetBackdropOption("offsets", {
            left = 3,
            right = 24,
            top = 2,
            bottom = 7,
        })
        Skin.UIDropDownMenuTemplate(_G.ClassTrainerFrameFilterDropDown)

        _G.ClassTrainerSkillHighlight:SetColorTexture(1, 1, 1, 0.5)
        for i = 1, 11 do
            Skin.ClassTrainerSkillButtonTemplate(_G["ClassTrainerSkill"..i])
        end

        Skin.ClassTrainerListScrollFrameTemplate(_G.ClassTrainerListScrollFrame)

        local moneyBG = _G.CreateFrame("Frame", nil, ClassTrainerFrame)
        Base.SetBackdrop(moneyBG, Color.frame)
        moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
        moneyBG:SetPoint("BOTTOMLEFT", bg, 5, 5)
        moneyBG:SetPoint("TOPRIGHT", bg, "BOTTOMLEFT", 165, 27)
        Skin.SmallMoneyFrameTemplate(_G.ClassTrainerMoneyFrame)
        _G.ClassTrainerMoneyFrame:SetPoint("BOTTOMRIGHT", moneyBG, 7, 5)

        Skin.ClassTrainerDetailScrollFrameTemplate(_G.ClassTrainerDetailScrollFrame)

        _G.ClassTrainerSkillIcon:GetRegions():Hide()
        _G.ClassTrainerSkillIcon:SetNormalTexture(private.textures.plain)
        Base.CropIcon(_G.ClassTrainerSkillIcon:GetNormalTexture(), _G.ClassTrainerSkillIcon)
        Skin.SmallMoneyFrameTemplate(_G.ClassTrainerDetailMoneyFrame)

        Skin.UIPanelButtonTemplate(_G.ClassTrainerTrainButton)
        Skin.UIPanelButtonTemplate(_G.ClassTrainerCancelButton)
        Util.PositionRelative("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -5, 5, 1, "Left", {
            _G.ClassTrainerCancelButton,
            _G.ClassTrainerTrainButton,
        })

        Skin.UIPanelCloseButton(_G.ClassTrainerFrameCloseButton)
    end
end
