local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Scale = Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

if not private.disableUIScale then
    local function SetSize(self, ...)
        if self:IsForbidden() or self._settingSize then return end
        self._settingSize = true
        Scale.Size(self, ...)
        self._settingSize = nil
    end
    local function SetHeight(self, ...)
        if self:IsForbidden() or self._settingHeight then return end
        self._settingHeight = true
        Scale.Height(self, ...)
        self._settingHeight = nil
    end
    local function SetWidth(self, ...)
        if self:IsForbidden() or self._settingWidth then return end
        self._settingWidth = true
        Scale.Width(self, ...)
        self._settingWidth = nil
    end
    local function SetThickness(self, ...)
        if self:IsForbidden() or self._settingThickness then return end
        self._settingThickness = true
        Scale.Thickness(self, ...)
        self._settingThickness = nil
    end
    local function SetPoint(self, ...)
        if self:IsForbidden() or self._settingPoint then return end
        self._settingPoint = true
        Scale.Point(self, ...)
        self._settingPoint = nil
    end
    local function SetEndPoint(self, ...)
        if self:IsForbidden() or self._settingEndPoint then return end
        self._settingEndPoint = true
        Scale.EndPoint(self, ...)
        self._settingEndPoint = nil
    end
    local function SetStartPoint(self, ...)
        if self:IsForbidden() or self._settingStartPoint then return end
        self._settingStartPoint = true
        Scale.StartPoint(self, ...)
        self._settingStartPoint = nil
    end

    local widgets = {
        Frame = {
            Texture = false,
            Line = false,
            MaskTexture = false,
            FontString = false,
        },
        Button = false,
        Cooldown = false,
        ColorSelect = false,
        --EditBox = false,
        GameTooltip = false,
        MessageFrame = false,
        Model = false,
        ScrollFrame = false,
        ScrollingMessageFrame = false,
        SimpleHTML = false,
        Slider = false,
        StatusBar = false,
    }

    local function HookSetters(widget)
        local mt = _G.getmetatable(widget).__index
        if widget.SetEndPoint then
            _G.hooksecurefunc(mt, "SetEndPoint", SetEndPoint)
            _G.hooksecurefunc(mt, "SetStartPoint", SetStartPoint)
            _G.hooksecurefunc(mt, "SetThickness", SetThickness)
        else
            _G.hooksecurefunc(mt, "SetSize", SetSize)
            _G.hooksecurefunc(mt, "SetHeight", SetHeight)
            _G.hooksecurefunc(mt, "SetWidth", SetWidth)
            _G.hooksecurefunc(mt, "SetPoint", SetPoint)
        end
    end

    for widgetType, children in _G.next, widgets do
        local widget = _G.CreateFrame(widgetType, nil, _G.UIParent)
        HookSetters(widget)
        if children then
            for childType, hasChildren in _G.next, children do
                local child = widget["Create"..childType](widget)
                HookSetters(child)
            end
        end
    end
    HookSetters(_G.Minimap)
end

do --[[ FrameXML\UIParent.lua ]]
    function Hook.BuildIconArray(parent, baseName, template, rowSize, numRows, onButtonCreated)
        if Skin[template] then
            for i = 1, rowSize * numRows do
                Skin[template](_G[baseName..i])
            end
        end
    end
end

function private.FrameXML.UIParent()
    _G.hooksecurefunc("BuildIconArray", Hook.BuildIconArray)

    -- Blizzard doesn't create the chat bubbles in lua, so we're calling it here
    if private.FrameXML.ChatBubbles then
        private.FrameXML.ChatBubbles()
    end
end
