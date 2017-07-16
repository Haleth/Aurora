local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base

local colorMeta = _G.Mixin({}, _G.ColorMixin)
function colorMeta:SetRGBA(r, g, b, a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a
    self.colorStr = self:GenerateHexColor()
end
local function CreateColor(r, g, b, a)
    local color = _G.CreateFromMixins(colorMeta)
    color:OnLoad(r, g, b, a)
    return color
end
Base.CreateColor = CreateColor


local highlightColor = CreateColor(0, 0, 1, 1) -- Temporary, the proper highlight color will be set later
private.highlightColor = highlightColor

local normalColor = CreateColor(1, 1, 1, 1)
private.normalColor = normalColor

local buttonColor = CreateColor(.2, .2, .2, 1)
private.buttonColor = buttonColor

local frameColor = CreateColor(0, 0, 0, 0.6)
private.frameColor = frameColor


local backdrop = {
    bgFile = [[Interface\Buttons\White8x8]],
    edgeFile = [[Interface\Buttons\White8x8]],
    edgeSize = 1,
}
private.backdrop = backdrop

do -- Base.SetHighlight
    local function GetColorTexture(string)
        string = string:gsub("Color%-", "")
        if string == "000ff" then
            return 0, 0, 0, 1
        else
            local r = string:sub(1, 2)
            local g = string:sub(3, 4)
            local b = string:sub(5, 6)
            local a = string:sub(7, 8)

            r = _G.tonumber(r, 16) / 255
            g = _G.tonumber(g, 16) / 255
            b = _G.tonumber(b, 16) / 255
            a = _G.tonumber(a, 16) / 255

            return r, g, b, a
        end
    end
    local function OnEnter(button, isBackground)
        if button:IsEnabled() then
            --print("OnEnter", isBackground)
            if isBackground then
                Base.SetBackdropColor(button, highlightColor:GetRGBA())
            else
                for _, texture in next, button._auroraHighlight do
                    button._auroraSetColor(texture, highlightColor:GetRGBA())
                end
            end
        end
    end
    local function OnLeave(button, isBackground)
        --print("OnLeave", isBackground)
        if isBackground then
            Base.SetBackdropColor(button, button._returnColor:GetRGBA())
        else
            for _, texture in next, button._auroraHighlight do
                button._auroraSetColor(texture, button._returnColor:GetRGBA())
            end
        end
    end
    function Base.SetHighlight(button, highlightType, enter, leave)
        local setColor, r, g, b, a
        if highlightType == "color" then
            r, g, b, a = GetColorTexture(button._auroraHighlight[1]:GetTexture())
            setColor = button._auroraHighlight[1].SetColorTexture
        elseif highlightType == "texture" then
            r, g, b, a = button._auroraHighlight[1]:GetVertexColor()
            setColor = button._auroraHighlight[1].SetVertexColor
        elseif highlightType == "backdrop" then
            r, g, b = button:GetBackdropBorderColor()
            _, _, _, a = button:GetBackdropColor()
        end
        button._returnColor = CreateColor(r, g, b, a)
        button._auroraSetColor = setColor
        button:HookScript("OnEnter", function(self)
            (enter or OnEnter)(self, highlightType == "backdrop")
        end)
        button:HookScript("OnLeave", function(self)
            (leave or OnLeave)(self, highlightType == "backdrop")
        end)
    end
end

do -- Base.SetBackdrop
    function Base.SetBackdrop(frame, r, g, b, a)
        frame:SetBackdrop(backdrop)
        Base.SetBackdropColor(frame, r, g, b, a)
    end
    function Base.SetBackdropColor(frame, r, g, b, a)
        if not r then r, g, b, a = frameColor:GetRGBA() end
        frame:SetBackdropColor(r * 0.6, g * 0.6, b * 0.6, a or 1)
        frame:SetBackdropBorderColor(r, g, b, 1)
    end
end

do -- Base.CropIcon
    function Base.CropIcon(texture, parent)
        texture:SetTexCoord(.08, .92, .08, .92)
        if parent then
            local layer, subLevel = texture:GetDrawLayer()
            local iconBorder = parent:CreateTexture(nil, layer, nil, subLevel - 1)
            iconBorder:SetPoint("TOPLEFT", texture, -1, 1)
            iconBorder:SetPoint("BOTTOMRIGHT", texture, 1, -1)
            iconBorder:SetColorTexture(0, 0, 0)
            return iconBorder
        end
    end
end
