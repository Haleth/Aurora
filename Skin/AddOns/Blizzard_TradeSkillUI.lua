local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin, Util = Aurora.Base, Aurora.Skin, Aurora.Util
local Color = Aurora.Color

do --[[ AddOns/Blizzard_TradeSkillUI/Blizzard_TradeSkillUI.xml ]]
    function Skin.TradeSkillSkillButtonTemplate(Frame)
        Skin.ClassTrainerSkillButtonTemplate(Frame)
    end
    function Skin.TradeSkillItemTemplate(Frame)
        Skin.QuestItemTemplate(Frame)
    end
end

function private.AddOns.Blizzard_TradeSkillUI()
    local TradeSkillFrame = _G.TradeSkillFrame
    Base.SetBackdrop(TradeSkillFrame)
    Skin.UIPanelCloseButton(_G.TradeSkillFrameCloseButton)
    _G.TradeSkillFrameCloseButton:SetPoint("TOPRIGHT", 4, 5)
    _G.TradeSkillFramePortrait:SetAlpha(0)
    for i = 2, 5 do
        select(i, TradeSkillFrame:GetRegions()):Hide()
    end
    for i = 7, 10 do
        select(i, TradeSkillFrame:GetRegions()):Hide()
    end

    local rankFrame = _G.TradeSkillRankFrame
    _G.TradeSkillRankFrameBorder:Hide()
    _G.TradeSkillRankFrameBackground:SetColorTexture(0.1, 0.1, 0.75, 0.25)
    rankFrame:SetStatusBarTexture([[Interface\ChatFrame\ChatFrameBackground]])
    rankFrame.SetStatusBarColor = function() end
    rankFrame:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)
    Base.SetBackdrop(rankFrame)

    Skin.ClassTrainerSkillButtonTemplate(_G.TradeSkillCollapseAllButton)

    Skin.UIDropDownMenuTemplate(_G.TradeSkillInvSlotDropDown)
    Skin.UIDropDownMenuTemplate(_G.TradeSkillSubClassDropDown)

    Skin.ClassTrainerDetailScrollFrameTemplate(_G.TradeSkillListScrollFrame)
    Skin.ClassTrainerDetailScrollFrameTemplate(_G.TradeSkillDetailScrollFrame)
    for i = 1, 8 do
        Skin.TradeSkillSkillButtonTemplate(_G["TradeSkillSkill"..i])
        Skin.TradeSkillItemTemplate(_G["TradeSkillReagent"..i])
    end

    Skin.UIPanelButtonTemplate(_G.TradeSkillCancelButton)
    Skin.UIPanelButtonTemplate(_G.TradeSkillCreateButton)
    Skin.UIPanelButtonTemplate(_G.TradeSkillCreateAllButton)
    Util.PositionRelative("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.TradeSkillCancelButton,
        _G.TradeSkillCreateButton,
    })
    _G.TradeSkillCreateAllButton:ClearAllPoints()
    _G.TradeSkillCreateAllButton:SetPoint("BOTTOMLEFT", 15, 15)

    local tradeSkillInputBox = _G.TradeSkillInputBox
    _G.TradeSkillInputBoxLeft:Hide()
    _G.TradeSkillInputBoxRight:Hide()
    _G.TradeSkillInputBoxMiddle:Hide()
    local bg = _G.CreateFrame("Frame", nil, tradeSkillInputBox)
    bg:SetHeight(20)
    bg:SetPoint("LEFT", -5, 0)
    bg:SetPoint("RIGHT", 0, 0)
    bg:SetFrameLevel(tradeSkillInputBox:GetFrameLevel())
    Base.SetBackdrop(bg, Color.frame)
    tradeSkillInputBox._auroraBG = bg
    tradeSkillInputBox:DisableDrawLayer("BACKGROUND")
    tradeSkillInputBox:ClearAllPoints()

    Skin.NavButtonNext(_G.TradeSkillIncrementButton)
    _G.TradeSkillIncrementButton:ClearAllPoints()
    _G.TradeSkillIncrementButton:SetPoint("LEFT", tradeSkillInputBox._auroraBG, "RIGHT", 3, 0)

    Skin.NavButtonPrevious(_G.TradeSkillDecrementButton)
    _G.TradeSkillDecrementButton:ClearAllPoints()
    _G.TradeSkillDecrementButton:SetPoint("RIGHT", tradeSkillInputBox._auroraBG, "LEFT", -3, 0)
end
