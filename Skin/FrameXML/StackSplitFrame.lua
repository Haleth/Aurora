local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\StackSplitFrame.lua ]]
--end

--do --[[ FrameXML\StackSplitFrame.xml ]]
--end

function private.FrameXML.StackSplitFrame()
    local StackSplitFrame = _G.StackSplitFrame
    Base.SetBackdrop(StackSplitFrame)
    local bg = StackSplitFrame:GetBackdropTexture("bg")
    bg:SetPoint("TOPLEFT", 14, -9)
    bg:SetPoint("BOTTOMRIGHT", _G.StackSplitCancelButton, 5, -5)
    select(1, StackSplitFrame:GetRegions()):Hide()

    Skin.UIPanelButtonTemplate(_G.StackSplitOkayButton)
    Skin.UIPanelButtonTemplate(_G.StackSplitCancelButton)
end
