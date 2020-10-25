local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\SharedTooltipTemplates.lua ]]
    function Hook.SharedTooltip_SetBackdropStyle(self, style)
        if not self.IsEmbedded then
            Skin.FrameTypeFrame(self)
        end
    end
end

do --[[ FrameXML\SharedTooltipTemplates.xml ]]
    Skin.SharedTooltipTemplate = Base.SetBackdrop
    Skin.SharedNoHeaderTooltipTemplate = Skin.SharedTooltipTemplate
end

function private.SharedXML.SharedTooltipTemplates()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("SharedTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)
end
