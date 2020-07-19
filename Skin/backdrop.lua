local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type next error

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Color = Aurora.Color

local backdrop = {
    -- Blizzard options
    bgFile = private.textures.plain,
    tile = true,
    insets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    edgeFile = private.textures.plain,
    edgeSize = 1,

    -- Custom options
    offsets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
private.backdrop = backdrop

local function GetRGBA(red, green, blue, alpha)
    local a
    if type(red) == "table" then
        a = green
        red, green, blue, alpha = red:GetRGBA()
    end
    return red, green, blue, a or alpha
end
local function CopyBackdrop(bdOptions)
    return {
        bgFile = bdOptions.bgFile,
        tile = bdOptions.tile,
        insets = {
            left = bdOptions.insets.left,
            right = bdOptions.insets.right,
            top = bdOptions.insets.top,
            bottom = bdOptions.insets.bottom,
        },
        edgeFile = bdOptions.edgeFile,
        edgeSize = bdOptions.edgeSize,

        offsets = {
            left = bdOptions.offsets.left,
            right = bdOptions.offsets.right,
            top = bdOptions.offsets.top,
            bottom = bdOptions.offsets.bottom,
        },
    }
end

local function SanitizeTable(optionDB, parentDB)
    for option, value in next, parentDB do
        if type(value) == "table" then
            optionDB[option] = SanitizeTable(optionDB[option] or {}, value)
        else
            if optionDB[option] == nil then
                optionDB[option] = parentDB[option]
            end
        end
    end

    return optionDB
end

local bgTextures = {
    bg = true,

    l = true,
    r = true,
    t = true,
    b = true,

    tl = true,
    tr = true,
    bl = true,
    br = true,
}
local sides = {
    l = {l=0, r=0.125, t=0, b=1, tileV = true, left="tl", right="bl"},
    r = {l=0.125, r=0.25, t=0, b=1, tileV = true, left="tr", right="br"},
    t = {l=0.25, r=0.375, t=0, b=1, tileH = true, left="tl", right="tr"},
    b = {l=0.375, r=0.5, t=0, b=1, tileH = true, left="bl", right="br"},
}
local corners = {
    tl = {l=0.5, r=0.625, t=0, b=1, point = "TOPLEFT", x="left", y="top"},
    tr = {l=0.625, r=0.75, t=0, b=1, point = "TOPRIGHT", x="right", y="top"},
    bl = {l=0.75, r=0.875, t=0, b=1, point = "BOTTOMLEFT", x="left", y="bottom"},
    br = {l=0.875, r=1, t=0, b=1, point = "BOTTOMRIGHT", x="right", y="bottom"},
}

local old_SetBackdrop = _G.getmetatable(_G.UIParent).__index.SetBackdrop
local function ClearBackdrop(frame)
    if private.isPatch then
        if frame.ClearBackdrop then
            frame:ClearBackdrop()
        end
    else
        old_SetBackdrop(frame, nil)
    end
end

-- Blizzard methods
local BackdropMixin = {}
function BackdropMixin:SetBackdrop(options, textures)
    if self.settingBD then return end
    self.settingBD = true
    ClearBackdrop(self)
    if options then
        if not self._auroraBackdrop then
            local bd = textures or {}
            bd.layer = textures and textures.layer or "BACKGROUND"
            bd.sublevel = textures and textures.sublevel or -8

            for name in next, bgTextures do
                if bd[name] then
                    bd[name]:ClearAllPoints()
                    if name == "bg" then
                        bd[name]:SetDrawLayer(bd.layer, bd.sublevel)
                    else
                        bd[name]:SetDrawLayer(bd.layer, bd.sublevel + 1)
                    end
                else
                    if name == "bg" then
                        bd[name] = self:CreateTexture(nil, bd.layer, nil, bd.sublevel)
                    else
                        bd[name] = self:CreateTexture(nil, bd.layer, nil, bd.sublevel + 1)
                    end
                end

                bd[name]:SetTexelSnappingBias(0.0)
                bd[name]:SetSnapToPixelGrid(false)
            end

            self._auroraBackdrop = bd
        end
        local bd = self._auroraBackdrop
        options = SanitizeTable(bd.options or options, backdrop)

        --[[ The tile size is fixed at the original texture size, so this option is DOA.
        if options.tileSize then
            bd.bg:SetSize(options.tileSize, options.tileSize)
        end]]
        bd.bg:Show()
        if Base.IsTextureRegistered(options.bgFile) then
            Base.SetTexture(bd.bg, options.bgFile)
            if bd.bgRed then
                bd.bg:SetVertexColor(bd.bgRed, bd.bgGreen, bd.bgBlue, bd.bgAlpha)
            end
        else
            bd.bg:SetTexture(options.bgFile, options.tile, options.tile)
            bd.bg:SetHorizTile(options.tile)
            bd.bg:SetVertTile(options.tile)
        end


        local insets = options.insets
        local offsets = options.offsets
        bd.bg:SetPoint("TOPLEFT", self, (insets.left + offsets.left), -(insets.top + offsets.top))
        bd.bg:SetPoint("BOTTOMRIGHT", self, -(insets.right + offsets.right), (insets.bottom + offsets.bottom))


        local corner, side
        for tag, info in next, corners do
            corner = bd[tag]
            corner:Show()
            corner:SetTexture(options.edgeFile)
            corner:SetTexCoord(info.l, info.r, info.t, info.b)
            corner:SetSize(options.edgeSize, options.edgeSize)
            corner:SetPoint(info.point, bd.bg, -insets[info.x], insets[info.y])
        end


        for tag, info in next, sides do
            side = bd[tag]
            side:Show()
            side:SetTexture(options.edgeFile)
            if info.tileH then
                side:SetTexCoord(info.l, info.b, info.r, info.b, info.l, info.t, info.r, info.t)
                side:SetPoint("TOPLEFT", bd[info.left], "TOPRIGHT")
                side:SetPoint("BOTTOMRIGHT", bd[info.right], "BOTTOMLEFT")
            else
                side:SetTexCoord(info.l, info.r, info.t, info.b)
                side:SetPoint("TOPLEFT", bd[info.left], "BOTTOMLEFT")
                side:SetPoint("BOTTOMRIGHT", bd[info.right], "TOPRIGHT")
            end

        end

        bd.l:SetPoint("TOPLEFT", bd.tl, "BOTTOMLEFT")
        bd.l:SetPoint("BOTTOMRIGHT", bd.bl, "TOPRIGHT")

        bd.r:SetPoint("TOPLEFT", bd.tr, "BOTTOMLEFT")
        bd.r:SetPoint("BOTTOMRIGHT", bd.br, "TOPRIGHT")

        bd.t:SetPoint("TOPLEFT", bd.tl, "TOPRIGHT")
        bd.t:SetPoint("BOTTOMRIGHT", bd.tr, "BOTTOMLEFT")

        bd.b:SetPoint("TOPLEFT", bd.bl, "TOPRIGHT")
        bd.b:SetPoint("BOTTOMRIGHT", bd.br, "BOTTOMLEFT")


        if not bd.options then
            bd.options = CopyBackdrop(options)
        end
    else
        if self._auroraBackdrop then
            local bd = self._auroraBackdrop
            bd.bg:Hide()
            for side, info in next, sides do
                bd[side]:Hide()
            end

            for corner, info in next, corners do
                bd[corner]:Hide()
            end
        end
    end
    self.settingBD = nil
end
function BackdropMixin:GetBackdrop()
    if self._auroraBackdrop then
        local options = self._auroraBackdrop.options
        return CopyBackdrop(options)
    end
end
function BackdropMixin:SetBackdropColor(red, green, blue, alpha)
    if self._auroraBackdrop then
        red, green, blue, alpha = GetRGBA(red, green, blue, alpha)

        local bd = self._auroraBackdrop
        bd.bgRed = red
        bd.bgGreen = green
        bd.bgBlue = blue
        bd.bgAlpha = alpha

        bd.bg:SetVertexColor(red, green, blue, alpha)
    end
end
function BackdropMixin:GetBackdropColor()
    if self._auroraBackdrop then
        local bd = self._auroraBackdrop
        return bd.bgRed, bd.bgGreen, bd.bgBlue, bd.bgAlpha
    end
end
function BackdropMixin:SetBackdropBorderColor(red, green, blue, alpha)
    if self._auroraBackdrop then
        red, green, blue, alpha = GetRGBA(red, green, blue, alpha)

        local bd = self._auroraBackdrop
        bd.borderRed = red
        bd.borderGreen = green
        bd.borderBlue = blue
        bd.borderAlpha = alpha

        local tex = bd.t:GetTexture()
        if tex then
            for side, info in next, sides do
                bd[side]:SetVertexColor(red, green, blue, alpha)
            end

            for corner, info in next, corners do
                bd[corner]:SetVertexColor(red, green, blue, alpha)
            end
        else
            private.debug("SetBackdropBorderColor no texture", self:GetName(), tex)
        end
    end
end
function BackdropMixin:GetBackdropBorderColor()
    if self._auroraBackdrop then
        local bd = self._auroraBackdrop
        return bd.borderRed, bd.borderGreen, bd.borderBlue, bd.borderAlpha
    end
end

-- Custom Methods
function BackdropMixin:SetBackdropLayer(layer, sublevel)
    local bd = self._auroraBackdrop
    bd.bg:SetDrawLayer(layer, sublevel)

    sublevel = sublevel + 1
    bd.l:SetDrawLayer(layer, sublevel)
    bd.r:SetDrawLayer(layer, sublevel)
    bd.t:SetDrawLayer(layer, sublevel)
    bd.b:SetDrawLayer(layer, sublevel)

    bd.tl:SetDrawLayer(layer, sublevel)
    bd.tr:SetDrawLayer(layer, sublevel)
    bd.bl:SetDrawLayer(layer, sublevel)
    bd.br:SetDrawLayer(layer, sublevel)

    bd.layer = layer
    bd.sublevel = sublevel
end
function BackdropMixin:GetBackdropLayer()
    if self._auroraBackdrop then
        return self._auroraBackdrop.layer, self._auroraBackdrop.sublevel
    end
end
function BackdropMixin:GetBackdropTexture(texture)
    if self._auroraBackdrop then
        return self._auroraBackdrop[texture]
    end
end
function BackdropMixin:SetBackdropOption(optionKey, optionValue)
    if self._auroraBackdrop then
        local options = self._auroraBackdrop.options
        if options[optionKey] ~= optionValue then
            options[optionKey] = optionValue
            self:SetBackdrop(options)
        end
    end
end
function BackdropMixin:GetBackdropOption(optionKey)
    if self._auroraBackdrop then
        local options = self._auroraBackdrop.options
        return options[optionKey]
    end
end

function Base.CreateBackdrop(frame, options, textures)
    for name, func in next, BackdropMixin do
        frame[name] = func
    end

    frame:SetBackdrop(options, textures)
end

function Base.SetBackdrop(frame, color, alpha)
    Base.CreateBackdrop(frame, backdrop)
    Base.SetBackdropColor(frame, color, alpha)
end
function Base.SetBackdropColor(frame, color, alpha)
    if not color then color = Color.frame end
    if type(color) ~= "table" then error("`color` must be a Color object. See Color.Create") end

    frame:SetBackdropColor(Color.Lightness(color, -0.3), alpha or color.a)
    frame:SetBackdropBorderColor(color, 1)
end
