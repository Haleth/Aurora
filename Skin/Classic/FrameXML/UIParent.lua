local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\UIParent.lua ]]
    function Hook.SetPortraitToTexture(texture, path)
        texture = _G[texture] or texture
        if not texture:IsForbidden() and texture._auroraResetPortrait then
            texture:SetTexture(path)
        end
    end
    function Hook.BuildIconArray(parent, baseName, template, rowSize, numRows, onButtonCreated)
        if Skin[template] then
            for i = 1, rowSize * numRows do
                Skin[template](_G[baseName..i])
            end
        end
    end
end

function private.FrameXML.UIParent()
    _G.hooksecurefunc("SetPortraitToTexture", Hook.SetPortraitToTexture)
    _G.hooksecurefunc("BuildIconArray", Hook.BuildIconArray)

    -- Blizzard doesn't create the chat bubbles in lua, so we're calling it here
    if private.FrameXML.ChatBubbles then
        private.FrameXML.ChatBubbles()
    end
end
