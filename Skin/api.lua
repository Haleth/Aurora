local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ Core ]]
local Aurora = private.Aurora

local highlightColor = _G.CreateColor()
private.highlightColor = highlightColor

local normalColor = _G.CreateColor(1, 1, 1, 1)
private.normalColor = normalColor

local buttonColor = _G.CreateColor(.2, .2, .2, 1)
private.buttonColor = buttonColor

local frameColor = _G.CreateColor(0, 0, 0, 0.6)
private.frameColor = frameColor


local backdrop = {
    bgFile = [[Interface\Buttons\White8x8]],
    edgeFile = [[Interface\Buttons\White8x8]],
    edgeSize = 1,
}
private.backdrop = backdrop

do -- Aurora.Base.SetHighlight
    local function OnEnter(button, isBackground)
        if button:IsEnabled() then
            if isBackground then
                Aurora.Base.SetBackdrop(button, highlightColor:GetRGBA())
            else
                for _, texture in next, button._auroraHighlight do
                    button._auroraSetColor(texture, highlightColor:GetRGBA())
                end
            end
        end
    end
    local function OnLeave(button, isBackground)
        if isBackground then
            Aurora.Base.SetBackdrop(button, buttonColor:GetRGBA())
        else
            for _, texture in next, button._auroraHighlight do
                button._auroraSetColor(texture, normalColor:GetRGBA())
            end
        end
    end
    function Aurora.Base.SetHighlight(button, highlightType)
        local setColor
        if highlightType == "color" then
            setColor = button.SetColorTexture
        elseif highlightType == "texture" then
            setColor = button.SetVertexColor
        end
        button._auroraSetColor = setColor
        button:HookScript("OnEnter", function(self)
            OnEnter(self, highlightType == "backdrop")
        end)
        button:HookScript("OnLeave", function(self)
            OnLeave(self, highlightType == "backdrop")
        end)
    end
end

do -- Aurora.Base.SetBackdrop
    function Aurora.Base.SetBackdrop(frame, r, g, b, a)
        if not frame:GetBackdrop() then
            frame:SetBackdrop(backdrop)
        end
        frame:SetBackdropColor(r * 0.6, g * 0.6, b * 0.6, a or 1)
        frame:SetBackdropBorderColor(r, g, b, 1)
    end
end
