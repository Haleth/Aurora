local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ Core ]]
local Aurora = private.Aurora

local highlightColor = _G.CreateColor()
private.highlightColor = highlightColor

local function OnEnter(button)
    if button:IsEnabled() then
        for _, texture in next, button._auroraHighlight do
            texture:SetColorTexture(highlightColor:GetRGB())
        end
    end
end
local function OnLeave(button)
    for _, texture in next, button._auroraHighlight do
        texture:SetColorTexture(1, 1, 1)
    end
end
function Aurora.SetHighlight(button)
    button:HookScript("OnEnter", OnEnter)
    button:HookScript("OnLeave", OnLeave)
end
