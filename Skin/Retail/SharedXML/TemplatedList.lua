local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ SharedXML\TemplatedList.lua ]]
    Hook.TemplatedListMixin = {}
    function Hook.TemplatedListMixin:UpdatedSelectedHighlight()
        local selectedHighlight = self:GetSelectedHighlight()
        if selectedHighlight:IsShown() then
            local _, button = selectedHighlight:GetPoint()
            selectedHighlight:ClearAllPoints()
            selectedHighlight:SetAllPoints(button)
        end
    end
end

do --[[ SharedXML\TemplatedList.xml ]]
    function Skin.TemplatedListTemplate(Frame)
        local selectedHighlight = Frame:GetSelectedHighlight()
        selectedHighlight:SetColorTexture(Color.highlight:GetRGB())
        selectedHighlight:SetAlpha(0.5)
    end
end

function private.SharedXML.TemplatedList()
    if private.isPatch then
        Util.Mixin(_G.TemplatedListMixin, Hook.TemplatedListMixin)
    end
end
