local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ AddOns\Blizzard_TrainerUI.lua ]]
    local iconSkinned = false
    function Hook.ClassTrainer_SetSelection(id)
        if not iconSkinned then
            Base.CropIcon(_G.ClassTrainerSkillIcon:GetNormalTexture(), _G.ClassTrainerSkillIcon)
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
    function Skin.ClassTrainerSkillButtonTemplate(Button)
        if private.isRetail then
            Skin.UIServiceButtonTemplate(Button)
        else
            Skin.ExpandOrCollapse(Button)
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
        Skin.UIDropDownMenuTemplate(_G.ClassTrainerFrameFilterDropDown)

        _G.ClassTrainerSkillHighlight:SetColorTexture(1, 1, 1, 0.5)
        for i = 1, 11 do
            Skin.ClassTrainerSkillButtonTemplate(_G["ClassTrainerSkill"..i])
        end

        Skin.ClassTrainerListScrollFrameTemplate(_G.ClassTrainerListScrollFrame)
        Skin.SmallMoneyFrameTemplate(_G.ClassTrainerMoneyFrame)
        Skin.ClassTrainerDetailScrollFrameTemplate(_G.ClassTrainerDetailScrollFrame)

        _G.ClassTrainerSkillIcon:GetRegions():Hide()
        Skin.SmallMoneyFrameTemplate(_G.ClassTrainerDetailMoneyFrame)


        Skin.UIPanelButtonTemplate(_G.ClassTrainerTrainButton)
        Skin.UIPanelButtonTemplate(_G.ClassTrainerCancelButton)
        Skin.UIPanelCloseButton(_G.ClassTrainerFrameCloseButton)
    end
end
