local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\StackSplitFrame.lua ]]
--end

--do --[[ FrameXML\StackSplitFrame.xml ]]
--end

function private.FrameXML.StackSplitFrame()
    local StackSplitFrame = _G.StackSplitFrame
    if private.isRetail then
        Base.SetBackdrop(StackSplitFrame)
        local bg = StackSplitFrame:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 14, -9)
        bg:SetPoint("BOTTOMRIGHT", StackSplitFrame.CancelButton, 5, -5)

        StackSplitFrame.SingleItemSplitBackground:SetAlpha(0)
        StackSplitFrame.MultiItemSplitBackground:SetAlpha(0)

        local textBG = _G.CreateFrame("Frame", nil, StackSplitFrame)
        textBG:SetPoint("TOPLEFT", bg, 20, -10)
        textBG:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -20, -30)
        Base.SetBackdrop(textBG, Color.frame, 0.4)
        StackSplitFrame.StackSplitText:SetParent(textBG)

        Skin.UIPanelButtonTemplate(StackSplitFrame.OkayButton)
        Skin.UIPanelButtonTemplate(StackSplitFrame.CancelButton)
    else
        Base.SetBackdrop(StackSplitFrame)
        local bg = StackSplitFrame:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 14, -9)
        bg:SetPoint("BOTTOMRIGHT", _G.StackSplitCancelButton, 5, -5)

        local textBG = _G.CreateFrame("Frame", nil, StackSplitFrame)
        textBG:SetPoint("TOPLEFT", bg, 20, -10)
        textBG:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -20, -30)
        Base.SetBackdrop(textBG, Color.frame, 0.4)
        _G.StackSplitText:SetParent(textBG)

        Skin.UIPanelButtonTemplate(_G.StackSplitOkayButton)
        Skin.UIPanelButtonTemplate(_G.StackSplitCancelButton)
    end
end
