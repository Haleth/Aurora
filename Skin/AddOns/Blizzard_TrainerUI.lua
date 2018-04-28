local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do AddOns\Blizzard_TrainerUI.lua
end ]]

do --[[ AddOns\Blizzard_TrainerUI.xml ]]
    function Skin.ClassTrainerSkillButtonTemplate(Button)
        Skin.UIServiceButtonTemplate(Button)
    end
end

function private.AddOns.Blizzard_TrainerUI()
    local ClassTrainerFrame = _G.ClassTrainerFrame
    Skin.ButtonFrameTemplate(ClassTrainerFrame)

    _G.ClassTrainerFrameMoneyBg:Hide()
    ClassTrainerFrame.BG:Hide()

    _G.ClassTrainerStatusBarLeft:Hide()
    _G.ClassTrainerStatusBarRight:Hide()
    _G.ClassTrainerStatusBarMiddle:Hide()
    local bd = _G.CreateFrame("Frame", nil, _G.ClassTrainerStatusBar)
    bd:SetPoint("TOPLEFT", -1, 1)
    bd:SetPoint("BOTTOMRIGHT", 1, -1)
    bd:SetFrameLevel(_G.ClassTrainerStatusBar:GetFrameLevel())
    Base.SetBackdrop(bd, Color.button)
    Base.SetTexture(_G.ClassTrainerStatusBarBar, "gradientUp")
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

    --[[ Scale ]]--
    _G.ClassTrainerFrameFilterDropDown:SetPoint("TOPRIGHT", 6, -30)
    ClassTrainerFrame.skillStepButton:SetPoint("TOPLEFT", ClassTrainerFrame.Inset, 6, -5)
    ClassTrainerFrame.scrollFrame:SetSize(304, 330)
    ClassTrainerFrame.scrollFrame:SetPoint("TOPRIGHT", ClassTrainerFrame.Inset, -5, -5)
end
