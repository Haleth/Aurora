local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\StackSplitFrame.lua ]]
    Hook.StackSplitMixin = {}
    function Hook.StackSplitMixin:ChooseFrameType(splitAmount)
        if self.isMultiStack then
            self:SetBackdropOption("offsets", {
                left = 14,
                right = 12,
                top = 10,
                bottom = 23,
            })
        else
            self:SetBackdropOption("offsets", {
                left = 14,
                right = 12,
                top = 10,
                bottom = 15,
            })
        end
    end
end

--do --[[ FrameXML\StackSplitFrame.xml ]]
--end

function private.FrameXML.StackSplitFrame()
    local StackSplitFrame = _G.StackSplitFrame
    if private.isRetail then
        Util.Mixin(StackSplitFrame, Hook.StackSplitMixin)
        Base.SetBackdrop(StackSplitFrame)

        local bg = StackSplitFrame:GetBackdropTexture("bg")
        StackSplitFrame.SingleItemSplitBackground:SetAlpha(0)
        StackSplitFrame.MultiItemSplitBackground:SetAlpha(0)

        local textBG = _G.CreateFrame("Frame", nil, StackSplitFrame)
        textBG:SetPoint("TOPLEFT", bg, 20, -10)
        textBG:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -20, -30)
        Base.SetBackdrop(textBG, Color.frame)
        textBG:SetBackdropBorderColor(Color.button)
        StackSplitFrame.StackSplitText:SetParent(textBG)

        Skin.UIPanelButtonTemplate(StackSplitFrame.OkayButton)
        Skin.UIPanelButtonTemplate(StackSplitFrame.CancelButton)
    else
        Base.SetBackdrop(StackSplitFrame)
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
end
