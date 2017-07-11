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
    function Base.SetHighlight(button, highlightType)
        local setColor
        if highlightType == "color" then
            setColor = button._auroraHighlight[1].SetColorTexture
        elseif highlightType == "texture" then
            setColor = button._auroraHighlight[1].SetVertexColor
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

do -- Base.SetBackdrop
    function Base.SetBackdrop(frame, r, g, b, a)
        if not r then r, g, b, a = frameColor:GetRGBA() end
        frame:SetBackdrop(backdrop)
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
        end
    end
end
