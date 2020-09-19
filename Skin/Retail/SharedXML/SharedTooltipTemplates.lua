local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\SharedTooltipTemplates.lua ]]
    function Hook.SharedTooltip_SetBackdropStyle(self, style)
        if not self.IsEmbedded then
            Base.SetBackdrop(self, Color.frame)
        end
    end
end

do --[[ FrameXML\SharedTooltipTemplates.xml ]]
    function Skin.SharedTooltipTemplate(GameTooltip)
        Base.SetBackdrop(GameTooltip)
    end
    Skin.SharedNoHeaderTooltipTemplate = Skin.SharedTooltipTemplate
end

function private.SharedXML.SharedTooltipTemplates()
    if private.disabled.tooltips then return end

    if private.isPatch then
        _G.hooksecurefunc("SharedTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)
    else
        _G.hooksecurefunc("GameTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)
    end
end
