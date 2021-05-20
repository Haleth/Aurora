local _, private = ...
if not private.isClassic then return end

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
    Skin.FrameTypeFrame(StackSplitFrame)
    StackSplitFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 12,
        top = 10,
        bottom = 15,
    })

    local bg = StackSplitFrame:GetBackdropTexture("bg")
    local textBG = _G.CreateFrame("Frame", nil, StackSplitFrame)
    textBG:SetPoint("TOPLEFT", bg, 20, -10)
    textBG:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -20, -30)
    Base.SetBackdrop(textBG, Color.frame)
    textBG:SetBackdropBorderColor(Color.button)
    _G.StackSplitText:SetParent(textBG)

    Skin.UIPanelButtonTemplate(_G.StackSplitOkayButton)
    Skin.UIPanelButtonTemplate(_G.StackSplitCancelButton)
end
