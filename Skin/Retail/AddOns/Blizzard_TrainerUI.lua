local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ AddOns\Blizzard_TrainerUI.lua ]]
--end

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
end
