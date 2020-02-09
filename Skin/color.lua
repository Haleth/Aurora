local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type assert next pcall

--[[ Core ]]
local Aurora = private.Aurora
local Color = Aurora.Color

local colorSelect = _G.CreateFrame("ColorSelect")
local Clamp = _G.Clamp

--[[ Color.Hue(_color, delta_)
Create a new color where the hue is offset by a percentage from the
given color. `color` can be a ColorMixin or a table with `r`, `g`, and
`b` keys.

**Args:**
* `color` - the color to be modified _(ColorMixin)_
* `delta` - a decimal from -1 to 1 where 0 confers no change _(number)_

**Returns:**
* `color` - a new color object _(ColorMixin)_
--]]
function Color.Hue(color, delta)
    -- /dump Aurora.Color.green:Hue(-2/3)
    colorSelect:SetColorRGB(color.r, color.g, color.b)
    local h, s, v = colorSelect:GetColorHSV()

    delta = 360 * delta -- convert decimal to degrees
    local hue = h + delta
    if hue < 0 then
        colorSelect:SetColorHSV((360 + hue) % 360, s, v)
    else
        colorSelect:SetColorHSV(hue % 360, s, v)
    end

    return Color.Create(colorSelect:GetColorRGB())
end
function Color.Saturation(color, delta)
    -- /dump Aurora.Color.red:Saturation(1)
    colorSelect:SetColorRGB(color.r, color.g, color.b)
    local h, s, v = colorSelect:GetColorHSV()
    colorSelect:SetColorHSV(h, Clamp(s + s * delta, 0, 1), v)

    return Color.Create(colorSelect:GetColorRGB())
end
function Color.Lightness(color, delta)
    -- /dump Aurora.Color.red:Lightness(1)
    colorSelect:SetColorRGB(color.r, color.g, color.b)
    local h, s, v = colorSelect:GetColorHSV()
    colorSelect:SetColorHSV(h, s, Clamp(v + v * delta, 0, 1))

    return Color.Create(colorSelect:GetColorRGB())
end


local colorMeta = _G.CreateFromMixins(_G.ColorMixin)
function colorMeta:Hue(delta)
    return Color.Hue(self, delta)
end
function colorMeta:Saturation(delta)
    return Color.Saturation(self, delta)
end
function colorMeta:Lightness(delta)
    return Color.Lightness(self, delta)
end
function colorMeta:SetRGBA(r, g, b, a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a
    self.colorStr = self:GenerateHexColor()

    self.isAchromatic = (r == g) and (g == b)
end
function colorMeta:IsEqualTo(r, g, b, a)
    if type(r) == "table" then
        return self.r == r.r
            and self.g == r.g
            and self.b == r.b
            and self.a == r.a
    else
        return self.r == r
            and self.g == g
            and self.b == b
            and self.a == a
    end
end


function Color.Create(r, g, b, a)
    local color = _G.CreateFromMixins(colorMeta)
    color:OnLoad(r, g, b, a)
    return color
end

Color.red = Color.Create(0.8, 0.2, 0.2)
Color.orange = Color.Create(0.8, 0.5, 0.2)
Color.yellow = Color.Create(0.8, 0.8, 0.2)
Color.lime = Color.Create(0.5, 0.8, 0.2)
Color.green = Color.Create(0.2, 0.8, 0.2)
Color.jade = Color.Create(0.2, 0.8, 0.5)
Color.cyan = Color.Create(0.2, 0.8, 0.8)
Color.marine = Color.Create(0.2, 0.5, 0.8)
Color.blue = Color.Create(0.2, 0.2, 0.8)
Color.violet = Color.Create(0.5, 0.2, 0.8)
Color.magenta = Color.Create(0.8, 0.2, 0.8)
Color.ruby = Color.Create(0.8, 0.2, 0.5)

Color.black = Color.Create(0, 0, 0)
Color.grayDark = Color.Create(0.25, 0.25, 0.25)
Color.gray = Color.Create(0.5, 0.5, 0.5)
Color.grayLight = Color.Create(0.75, 0.75, 0.75)
Color.white = Color.Create(1, 1, 1)

if not _G.CUSTOM_CLASS_COLORS then
    -- https://github.com/phanx-wow/ClassColors/wiki
    local meta = {}

    local callbacks, numCallbacks = {}, 0
    function meta:RegisterCallback(method, handler)
        --print("CUSTOM_CLASS_COLORS:RegisterCallback", method, handler)
        assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
        if type(method) == "string" then
            assert(type(handler) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
            assert(type(handler[method]) == "function", "Bad argument #1 to :RegisterCallback (method \"" .. method .. "\" not found)")
            method = handler[method]
        end
        -- assert(not callbacks[method] "Callback already registered!")
        callbacks[method] = handler or true
        numCallbacks = numCallbacks + 1
    end
    function meta:UnregisterCallback(method, handler)
        --print("CUSTOM_CLASS_COLORS:UnregisterCallback", method, handler)
        assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
        if type(method) == "string" then
            assert(type(handler) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
            assert(type(handler[method]) == "function", "Bad argument #1 to :UnregisterCallback (method \"" .. method .. "\" not found)")
            method = handler[method]
        end
        -- assert(callbacks[method], "Callback not registered!")
        callbacks[method] = nil
        numCallbacks = numCallbacks - 1
    end
    local function DispatchCallbacks()
        if numCallbacks < 1 then return end
        --print("CUSTOM_CLASS_COLORS:DispatchCallbacks")
        for method, handler in next, callbacks do
            local ok, err = pcall(method, handler ~= true and handler or nil)
            if not ok then
                _G.print("ERROR:", err)
            end
        end
    end

    local colorCache
    function meta:NotifyChanges()
        --print("CUSTOM_CLASS_COLORS:NotifyChanges", colorCache)
        local hasChanged = false
        if colorCache then
            for i = 1, #_G.CLASS_SORT_ORDER do
                local classToken = _G.CLASS_SORT_ORDER[i]
                local color = _G.CUSTOM_CLASS_COLORS[classToken]
                local cache = colorCache[classToken]

                if not color:IsEqualTo(cache) then
                    --print("Change found in", classToken)
                    color:SetRGB(cache.r, cache.g, cache.b)
                    hasChanged = true
                end
            end
        end

        if hasChanged then
            private.updateHighlightColor()

            DispatchCallbacks()
        end
    end

    local classTokens = {}
    for token, class in next, _G.LOCALIZED_CLASS_NAMES_MALE do
        classTokens[class] = token
    end
    for token, class in next, _G.LOCALIZED_CLASS_NAMES_FEMALE do
        classTokens[class] = token
    end
    function meta:GetClassToken(className)
        return className and classTokens[className]
    end

    function private.setColorCache(cache)
        colorCache = cache
    end
    function private.classColorsReset(colors, noMeta)
        local colorTable = colors or _G.CUSTOM_CLASS_COLORS
        for class, color in next, _G.RAID_CLASS_COLORS do
            if colorTable[class] then
                if noMeta then
                    colorTable[class].r = color.r
                    colorTable[class].g = color.g
                    colorTable[class].b = color.b
                    colorTable[class].colorStr = color.colorStr
                else
                    colorTable[class]:SetRGB(color.r, color.g, color.b)
                end
            else
                colorTable[class] = {
                    r = color.r,
                    g = color.g,
                    b = color.b,
                    colorStr = color.colorStr
                }
                if not noMeta then
                    colorTable[class] = _G.setmetatable(colorTable[class], {
                        __index = _G.CreateFromMixins(_G.ColorMixin, colorMeta)
                    })
                end
            end
        end

        if colors then
            meta:NotifyChanges()
        else
            DispatchCallbacks()
        end
    end
    function private.updateHighlightColor()
        Color.highlight:SetRGB(_G.CUSTOM_CLASS_COLORS[private.charClass.token]:GetRGB())
    end

    _G.CUSTOM_CLASS_COLORS = {}
    private.classColorsReset()

    _G.setmetatable(_G.CUSTOM_CLASS_COLORS, {__index = meta})
end

local color = _G.CUSTOM_CLASS_COLORS[private.charClass.token]
Color.highlight = Color.Create(color.r, color.g, color.b)
Color.button = Color.Create(Color.grayDark.r, Color.grayDark.g, Color.grayDark.b)
Color.frame = Color.Create(Color.black.r, Color.black.g, Color.black.b, 0.2)
