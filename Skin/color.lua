local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type assert next pcall

--[[ Core ]]
local Aurora = private.Aurora
local Color = Aurora.Color

local colorSelect = _G.CreateFrame("ColorSelect")
local Clamp = _G.Clamp

--[=[ ColorMixin:header
This is an extension of Blizzard's own [ColorMixin]. Created using
[Color.Create].

[ColorMixin]: https://github.com/Gethe/wow-ui-source/blob/live/SharedXML/Util.lua#L683
[Color.Create]: https://github.com/Haleth/Aurora/wiki/Color#colorcreater-g-b-a
--]=]
local colorMeta = _G.CreateFromMixins(_G.ColorMixin)

--[[ ColorMixin:SetRGBA(_r, g, b, a_)
This extends the original method by adding two additional properties,
`self.colorStr` and `self.isAchromatic`.

* `colorStr` - the hex representation of the color _(string)_
* `isAchromatic` - weather or not the color is gray-scale _(boolean)_
--]]
function colorMeta:SetRGBA(r, g, b, a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a
    self.colorStr = self:GenerateHexColor()

    self.isAchromatic = (r == g) and (g == b)
end

--[[ ColorMixin:IsEqualTo(_otherColor_ or _r, g, b, a_)
This extends the original method by adding support for non-object colors.
--]]
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

--[[ ColorMixin:Hue(_delta_)
See Color.Hue
--]]
function colorMeta:Hue(delta)
    return Color.Hue(self, delta)
end
--[[ ColorMixin:Saturation(_delta_)
See Color.Saturation
--]]
function colorMeta:Saturation(delta)
    return Color.Saturation(self, delta)
end
--[[ ColorMixin:Lightness(_delta_)
See Color.Lightness
--]]
function colorMeta:Lightness(delta)
    return Color.Lightness(self, delta)
end


--[=[ Color:header
A rainbow of predefined colors as well as a few color modification
functions. These all use a custom [[ColorMixin]] when manipulating
colors. Contains predefined colors as well as a few methods to create
or modify colors.

Aurora also provides an implementation of [[CUSTOM_CLASS_COLORS]].
--]=]

--[[ Color.Create(_r, g, b[, a]_)
Create a new color with the given color values. If `a` is not provided,
it defaults to `1`.

**Args:**
* `r` - red value between 0 and 1 _(number)_
* `g` - green value between 0 and 1 _(number)_
* `b` - blue value between 0 and 1 _(number)_
* `a` - _optional_ alpha value between 0 and 1 _(number)_

**Returns:**
* `color` - a new color object _(ColorMixin)_
--]]
function Color.Create(r, g, b, a)
    local color = _G.CreateFromMixins(colorMeta)
    color:OnLoad(r, g, b, a)
    return color
end

--[[ Color.Hue(_color, delta_)
Create a new color where its hue is offset by a percentage from the hue
of the given color. `color` can be a ColorMixin or a table with `r`,
`g`, and `b` keys.

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

--[[ Color.Saturation(_color, delta_)
Create a new color where its saturation is offset by a percentage from
the saturation of the given color. `color` can be a ColorMixin or a
table with `r`, `g`, and `b` keys.

**Args:**
* `color` - the color to be modified _(ColorMixin)_
* `delta` - a decimal from -1 to 1 where 0 confers no change _(number)_

**Returns:**
* `color` - a new color object _(ColorMixin)_
--]]
function Color.Saturation(color, delta)
    -- /dump Aurora.Color.red:Saturation(1)
    colorSelect:SetColorRGB(color.r, color.g, color.b)
    local h, s, v = colorSelect:GetColorHSV()
    colorSelect:SetColorHSV(h, Clamp(s + s * delta, 0, 1), v)

    return Color.Create(colorSelect:GetColorRGB())
end

--[[ Color.Lightness(_color, delta_)
Create a new color where its lightness is offset by a percentage from
the lightness of the given color. `color` can be a ColorMixin or a
table with `r`, `g`, and `b` keys.

**Args:**
* `color` - the color to be modified _(ColorMixin)_
* `delta` - a decimal from -1 to 1 where 0 confers no change _(number)_

**Returns:**
* `color` - a new color object _(ColorMixin)_
--]]
function Color.Lightness(color, delta)
    -- /dump Aurora.Color.red:Lightness(1)
    colorSelect:SetColorRGB(color.r, color.g, color.b)
    local h, s, v = colorSelect:GetColorHSV()
    colorSelect:SetColorHSV(h, s, Clamp(v + v * delta, 0, 1))

    return Color.Create(colorSelect:GetColorRGB())
end


--[[ Color.color
A range of predetermined colors are also available. The values listed
are in red, green, blue order.

* `Color.red` - 0.8, 0.2, 0.2
* `Color.orange` - 0.8, 0.5, 0.2
* `Color.yellow` - 0.8, 0.8, 0.2
* `Color.lime` - 0.5, 0.8, 0.2
* `Color.green` - 0.2, 0.8, 0.2
* `Color.jade` - 0.2, 0.8, 0.5
* `Color.cyan` - 0.2, 0.8, 0.8
* `Color.marine` - 0.2, 0.5, 0.8
* `Color.blue` - 0.2, 0.2, 0.8
* `Color.violet` - 0.5, 0.2, 0.8
* `Color.magenta` - 0.8, 0.2, 0.8
* `Color.ruby` - 0.8, 0.2, 0.5

* `Color.black` - 0, 0, 0
* `Color.grayDark` - 0.25, 0.25, 0.25
* `Color.gray` - 0.5, 0.5, 0.5
* `Color.grayLight` - 0.75, 0.75, 0.75
* `Color.white` - 1, 1, 1


These colors are used extensively in the UI skins.

* `Color.highlight` - defaults to the player's class color
* `Color.button` - defaults to `Color.grayDark`
* `Color.frame` - defaults to `Color.black`
--]]
Color.red = Color.Create(0.8, 0.2, 0.2) -- CC3333
Color.orange = Color.Create(0.8, 0.5, 0.2) -- CC8033
Color.yellow = Color.Create(0.8, 0.8, 0.2) -- CCCC33
Color.lime = Color.Create(0.5, 0.8, 0.2) -- 80CC33
Color.green = Color.Create(0.2, 0.8, 0.2) -- 33CC33
Color.jade = Color.Create(0.2, 0.8, 0.5) -- 33CC80
Color.cyan = Color.Create(0.2, 0.8, 0.8) -- 33CCCC
Color.marine = Color.Create(0.2, 0.5, 0.8) -- 3380CC
Color.blue = Color.Create(0.2, 0.2, 0.8) -- 3333CC
Color.violet = Color.Create(0.5, 0.2, 0.8) -- 8033CC
Color.magenta = Color.Create(0.8, 0.2, 0.8) -- CC33CC
Color.ruby = Color.Create(0.8, 0.2, 0.5) -- CC3380

Color.black = Color.Create(0, 0, 0) -- 000000
Color.grayDark = Color.Create(0.25, 0.25, 0.25) -- 404040
Color.gray = Color.Create(0.5, 0.5, 0.5) -- 808080
Color.grayLight = Color.Create(0.75, 0.75, 0.75) -- BFBFBF
Color.white = Color.Create(1, 1, 1) -- FFFFFF

Color.highlight = Color.Create(0.243, 0.570, 1) -- HIGHLIGHT_LIGHT_BLUE
Color.button = Color.Create(Color.grayDark.r, Color.grayDark.g, Color.grayDark.b)
Color.frame = Color.Create(Color.black.r, Color.black.g, Color.black.b, 0.2)


if _G.CUSTOM_CLASS_COLORS then return end
--[[ CUSTOM_CLASS_COLORS:header
This is a community developed standard, and is intended to be a drop-in
replacement for Blizzard's RAID_CLASS_COLORS. It's purpose is to allow
the user to change the in-game class colors without tainting the
default UI. [ClassColors], created by Phanx, was the original
implementation of this idea.

[ClassColors]: https://github.com/phanx-wow/ClassColors
--]]

local meta = {}

--[[ CUSTOM_CLASS_COLORS:RegisterCallback(_handler_ or _method, handler_)
Registers a function to be called when values in `CUSTOM_CLASS_COLORS`
are changed.

**Args:**
* `handler` - the function to be called _(function)_

or

**Args:**
* `method` - the name of a method _(string)_
* `handler` - the method handler _(table or Frame)_
--]]
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

--[[ CUSTOM_CLASS_COLORS:UnregisterCallback(_handler_ or _method, handler_)
Removes a function from the callback registry, so it will no longer be
called when class colors are changed.

**Args:**
* `handler` - a function previously registered _(function)_

or

**Args:**
* `method` - the name of a registered method _(string)_
* `handler` - the method handler _(table or Frame)_
--]]
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


--[[ CUSTOM_CLASS_COLORS:NotifyChanges()
Notifies other addons that class colors have changed.
--]]
local colorCache
function meta:NotifyChanges()
    --print("CUSTOM_CLASS_COLORS:NotifyChanges", colorCache)
    local hasChanged = false
    if colorCache then
        for i = 1, #_G.CLASS_SORT_ORDER do
            local classToken = _G.CLASS_SORT_ORDER[i]
            local color = self[classToken]
            local cache = colorCache[classToken]

            if not color:IsEqualTo(cache) then
                --print("Change found in", classToken)
                cache.r = color.r
                cache.g = color.g
                cache.b = color.b
                cache.colorStr = color.colorStr

                hasChanged = true
            end
        end
    end

    if hasChanged then
        DispatchCallbacks()
    end
end

local classTokens = {}
for classToken, className in next, _G.LOCALIZED_CLASS_NAMES_MALE do
    classTokens[className] = classToken
end
for classToken, className in next, _G.LOCALIZED_CLASS_NAMES_FEMALE do
    classTokens[className] = classToken
end

--[[ CUSTOM_CLASS_COLORS:GetClassToken(_className_)
Returns the locale-independent token (eg. "WARLOCK") for the specified
localized class name (eg. "Warlock" or "Hexenmeister").
--]]
function meta:GetClassToken(className)
    return className and classTokens[className]
end


function private.setColorCache(newCache)
    if colorCache then return end
    --print("setColorCache", newCache)

    colorCache = newCache
    private.classColorsReset(_G.CUSTOM_CLASS_COLORS, newCache)
end
function private.classColorsReset(oldColors, newColors)
    local classToken, oldColor, newColor

    local isCCC
    if oldColors == _G.CUSTOM_CLASS_COLORS then
        isCCC = true
    end

    --print("classColorsReset", oldColors, newColors, isCCC)
    for i = 1, #_G.CLASS_SORT_ORDER do
        classToken = _G.CLASS_SORT_ORDER[i]
        newColor = newColors[classToken]
        oldColor = oldColors[classToken]

        if oldColor then
            if isCCC then
                oldColor:SetRGB(newColor.r, newColor.g, newColor.b)
            else
                oldColor.r = newColor.r
                oldColor.g = newColor.g
                oldColor.b = newColor.b
                oldColor.colorStr = newColor.colorStr
            end
        else
            if isCCC then
                oldColors[classToken] = Color.Create(newColor.r, newColor.g, newColor.b)
            else
                oldColors[classToken] = {
                    r = newColor.r,
                    g = newColor.g,
                    b = newColor.b,
                    colorStr = newColor.colorStr
                }
            end
        end
    end

    if isCCC then
        DispatchCallbacks()
    else
        _G.CUSTOM_CLASS_COLORS:NotifyChanges()
    end
end
function private.updateHighlightColor()
    --print("updateHighlightColor")
    Color.highlight:SetRGB(_G.CUSTOM_CLASS_COLORS[private.charClass.token]:GetRGB())
end


_G.CUSTOM_CLASS_COLORS = {}
private.classColorsReset(_G.CUSTOM_CLASS_COLORS, _G.RAID_CLASS_COLORS)
_G.setmetatable(_G.CUSTOM_CLASS_COLORS, {__index = meta})

_G.CUSTOM_CLASS_COLORS:RegisterCallback(function()
    private.updateHighlightColor()
end)
