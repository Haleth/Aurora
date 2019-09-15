local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Util = Aurora.Util
local Color = Aurora.Color

--do --[[ AddOns\Blizzard_TrainerUI.lua ]]
--end

do --[[ AddOns\Blizzard_TrainerUI.xml ]]
    function Skin.ClassTrainerSkillButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.button)
    end
    function Skin.ClassTrainerDetailScrollFrameTemplate(Frame)
        Skin.UIPanelScrollFrameTemplate(Frame)
        select(1, Frame:GetRegions()):Hide()
        select(2, Frame:GetRegions()):Hide()
    end
end

function private.AddOns.Blizzard_TrainerUI()
    local ClassTrainerFrame = _G.ClassTrainerFrame
    Base.SetBackdrop(ClassTrainerFrame)
    for i = 1, 5 do
        select(i, ClassTrainerFrame:GetRegions()):Hide()
    end
    Skin.UIPanelCloseButton(_G.ClassTrainerFrameCloseButton)
    _G.ClassTrainerFrameCloseButton:SetPoint("TOPRIGHT", 4, 4)

    _G.ClassTrainerFrame:DisableDrawLayer("ARTWORK")

    for i = 1, 3 do
        select(i, _G.ClassTrainerExpandButtonFrame:GetRegions()):Hide()
    end
    Skin.ClassTrainerSkillButtonTemplate(_G.ClassTrainerCollapseAllButton)

    Skin.UIDropDownMenuTemplate(_G.ClassTrainerFrameFilterDropDown)
    Skin.UIPanelButtonTemplate(_G.ClassTrainerTrainButton)
    Skin.UIPanelButtonTemplate(_G.ClassTrainerCancelButton)
    Util.PositionRelative("BOTTOMRIGHT", _G.ClassTrainerFrame, "BOTTOMRIGHT", -5, 5, 5, "Left", {
        _G.ClassTrainerCancelButton,
        _G.ClassTrainerTrainButton,
    })

    Skin.ClassTrainerDetailScrollFrameTemplate(_G.ClassTrainerListScrollFrame)
    Skin.ClassTrainerDetailScrollFrameTemplate(_G.ClassTrainerDetailScrollFrame)

    local moneyBG = _G.CreateFrame("Frame", nil, ClassTrainerFrame)
    moneyBG:SetSize(142, 18)
    moneyBG:SetPoint("BOTTOMLEFT", 8, 5)
    Base.SetBackdrop(moneyBG, Color.frame)
    moneyBG:SetBackdropBorderColor(Color.yellow)
    Skin.SmallMoneyFrameTemplate(_G.ClassTrainerMoneyFrame)
    _G.ClassTrainerMoneyFrame:ClearAllPoints()
    _G.ClassTrainerMoneyFrame:SetPoint("RIGHT", moneyBG, 11, 0)
end
