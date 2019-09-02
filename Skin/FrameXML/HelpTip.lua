local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\HelpTip.lua ]]
    local directions = {
        "Down",
        "Left",
        "Up",
        "Right"
    }

    Hook.HelpTipTemplateMixin = {}
    function Hook.HelpTipTemplateMixin:AnchorArrow(rotationInfo, alignment)
        local point, anchor, arrowAnchor, offsetX, offsetY = self:GetPoint()
        if rotationInfo.swapOffsets then
            offsetX = 4
        else
            offsetY = 4
        end
        self.Arrow:SetPoint(point, anchor, arrowAnchor, offsetX, offsetY)
    end
    function Hook.HelpTipTemplateMixin:RotateArrow(rotation)
        local Arrow = self.Arrow
        local direction = directions[rotation]
        if direction == "Left" or direction == "Right" then
            Arrow:SetSize(17, 41)
        else
            Arrow:SetSize(41, 17)
        end

        Base.SetTexture(Arrow.Arrow, "arrow"..direction)
    end
end

do --[[ FrameXML\HelpTip.xml ]]
    function Skin.HelpTipTemplate(Frame)
        Skin.GlowBoxTemplate(Frame)
        Skin.UIPanelCloseButton(Frame.CloseButton)
        Skin.UIPanelButtonTemplate(Frame.OkayButton)
        Skin.GlowBoxArrowTemplate(Frame.Arrow)
    end
end

function private.FrameXML.HelpTip()
    if not private.isPatch then return end
    Util.Mixin(_G.HelpTipTemplateMixin, Hook.HelpTipTemplateMixin)
    _G.hooksecurefunc(_G.HelpTip.framePool, "Acquire", Hook.ObjectPoolMixin_Acquire)
end
