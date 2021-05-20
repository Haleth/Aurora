local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\SharedTooltipTemplates.lua ]]
    function Hook.SharedTooltip_SetBackdropStyle(self, style)
        if not self.IsEmbedded then
            Skin.FrameTypeFrame(self)
        end
    end
end

do --[[ FrameXML\SharedTooltipTemplates.xml ]]
    function Skin.SharedTooltipTemplate(GameTooltip)
        Skin.FrameTypeFrame(GameTooltip)
    end
    function Skin.SharedNoHeaderTooltipTemplate(GameTooltip)
        Skin.SharedTooltipTemplate(GameTooltip)
    end
end

function private.SharedXML.SharedTooltipTemplates()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("SharedTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)
end
