local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select xpcall

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ SharedXML\TemplatedList.lua ]]
    local function CheckTemplate(list, ...)
        local obj
        for i = 1, select("#", ...) do
            local template = select(i, ...)
            if Skin[template] then
                -- Not sure why, but might sometimes get called before element frames are created
                local isOK, numFrames = Util.SafeCall(list.GetNumElementFrames, list)
                if isOK then
                    for j = 1, numFrames do
                        obj = list:GetElementFrame(j)
                        if not obj._auroraSkinned then
                            Skin[template](obj)
                            obj._auroraSkinned = true
                        end
                    end
                end
            elseif private.isDev then
                private.debug("Missing template for TemplatedListMixin:", template)
            end
        end
    end

    Hook.TemplatedListMixin = {}
    function Hook.TemplatedListMixin:RefreshListDisplay()
        if not self.elementTemplate then return end

        CheckTemplate(self, self.elementTemplate)
    end
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
    Util.Mixin(_G.TemplatedListMixin, Hook.TemplatedListMixin)
end
