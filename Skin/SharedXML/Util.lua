local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook
local Color = Aurora.Color

do --[[ SharedXML\Util.lua ]]
    function Hook.TriStateCheckbox_SetState(checked, checkButton)
        local checkedTexture = _G[checkButton:GetName().."CheckedTexture"]
        if not checked or checked == 0 then
            -- nil or 0 means not checked
            checkButton:SetChecked(false)
        else
            checkedTexture:SetDesaturated(true)
            checkButton:SetChecked(true)

            local red, green, blue = Color.highlight:GetRGB()
            if checked == 2 then
                -- 2 is a normal check
                checkedTexture:SetVertexColor(red, green, blue)
            else
                -- 1 is a dark check
                checkedTexture:SetVertexColor(red * 0.5, green * 0.5, blue * 0.5)
            end
        end
    end
end

function private.SharedXML.Util()
    _G.hooksecurefunc("TriStateCheckbox_SetState", Hook.TriStateCheckbox_SetState)

    if private.classColorsInit then
        private.classColorsInit()
    end
end
