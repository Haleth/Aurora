local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ SharedXML\Pools.lua ]]
    Hook.ObjectPoolMixin = {}
    function Hook.ObjectPoolMixin:Acquire()
        local template = self.frameTemplate or self.textureTemplate or self.fontStringTemplate or self.actorTemplate
        if not template then return end

        if Skin[template] then
            for obj in self:EnumerateActive() do
                if not obj._auroraSkinned then
                    Skin[template](obj)
                    obj._auroraSkinned = true
                end
            end
        elseif private.isDev then
            _G.print("Missing template:", template)
        end
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
