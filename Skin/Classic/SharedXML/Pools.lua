local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ SharedXML\Pools.lua ]]
    local function CheckTemplate(pool, ...)
        for i = 1, select("#", ...) do
            local template = select(i, ...)
            --print("CheckTemplate", i, template)
            if Skin[template] then
                for obj in pool:EnumerateActive() do
                    if not obj._auroraSkinned then
                        Skin[template](obj)
                        obj._auroraSkinned = true
                    end
                end
            elseif private.isDev then
                private.debug("Missing template:", template)
            end
        end
    end

    Hook.ObjectPoolMixin = {}
    function Hook.ObjectPoolMixin:Acquire()
        local template = self.frameTemplate or self.textureTemplate or self.fontStringTemplate or self.actorTemplate
        if not template then return end

        --local templates = {(", "):split(template)}
        --print("Acquire", template)
        CheckTemplate(self, (", "):split(template))
    end
end


function private.SharedXML.Pools()
    --Util.Mixin(objectPool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.ObjectPoolMixin, Hook.ObjectPoolMixin)

    Util.Mixin(_G.FramePoolMixin, Hook.ObjectPoolMixin)
    Util.Mixin(_G.TexturePoolMixin, Hook.ObjectPoolMixin)
    Util.Mixin(_G.FontStringPoolMixin, Hook.ObjectPoolMixin)
    Util.Mixin(_G.ActorPoolMixin, Hook.ObjectPoolMixin)
end
