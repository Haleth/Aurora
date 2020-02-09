local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals wipe select next type

--[[ Core ]]
local Aurora = private.Aurora
local Util = Aurora.Util

--[[ **Util.GetName(_widget_)**
Iterates through the widget hierarchy, starting with the given widget,
until a viable global name is found. This is primarily useful when the
template for a widget that assumes it has a global name, when it
actually doesn't due to modern naming practices.

**Args:**
* `widget` - the widget to fine a name for _(Widget)_

**Returns:**
* `widgetName` - the name of the given widget _(string)_
--]]
function Util.GetName(widget)
    local name = widget:GetName()

    while not name do
        widget = widget:GetParent()
        name = widget:GetName()
    end

    return name
end
function Util.PositionRelative(point, anchor, relPoint, x, y, gap, direction, widgets)
    widgets[1]:ClearAllPoints()
    widgets[1]:SetPoint(point, anchor, relPoint, x, y)

    if direction == "Left" then
        point = "TOPRIGHT"
        relPoint = "TOPLEFT"
        x, y = -gap, 0
    elseif direction == "Right" then
        point = "TOPLEFT"
        relPoint = "TOPRIGHT"
        x, y = gap, 0
    elseif direction == "Up" then
        point = "BOTTOMLEFT"
        relPoint = "TOPLEFT"
        x, y = 0, gap
    elseif direction == "Down" then
        point = "TOPLEFT"
        relPoint = "BOTTOMLEFT"
        x, y = 0, -gap
    end

    for i = 2, #widgets do
        widgets[i]:ClearAllPoints()
        widgets[i]:SetPoint(point, widgets[i - 1], relPoint, x, y)
    end
end

function Util.FindUsage(table, func)
    _G.hooksecurefunc(table, func, function()
        _G.error("Found usage")
    end)
end

local tempMixin = {}
function Util.Mixin(table, ...)
    wipe(tempMixin)
    for i = 1, select("#", ...) do
        local hook = select(i, ...)
        for name, func in next, hook do
            tempMixin[name] = func
        end
    end

    for name, func in next, tempMixin do
        _G.hooksecurefunc(table, name, func)
    end
end

function Util.TestHook(table, func, name)
    _G.hooksecurefunc(table, func, function(...)
        _G.print("Test", name, ...)
    end)
end

local debugTools
function Util.TableInspect(focusedTable)
    if not debugTools then
        debugTools = _G.UIParentLoadAddOn("Blizzard_DebugTools")
    end
    _G.DisplayTableInspectorWindow(focusedTable)
end
function Util.Dump(value)
    if not debugTools then
        debugTools = _G.UIParentLoadAddOn("Blizzard_DebugTools")
    end

    if type(value) ~= "function" then
        local v = value
        value = function(...)
            return v
        end
    end

    _G.DevTools_Dump({value()}, "value")
end

Util.OpposingSide = {
    LEFT = "RIGHT",
    RIGHT = "LEFT",
    TOP = "BOTTOM",
    BOTTOM = "TOP"
}
