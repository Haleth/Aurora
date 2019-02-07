local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next assert type pcall tinsert math error

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Color, Util = Aurora.Color, Aurora.Util

Aurora.classIcons = { -- adjusted for borderless icons
    ["WARRIOR"]     = {0.01953125, 0.234375, 0.01953125, 0.234375},
    ["MAGE"]        = {0.26953125, 0.48046875, 0.01953125, 0.234375},
    ["ROGUE"]       = {0.515625, 0.7265625, 0.01953125, 0.234375},
    ["DRUID"]       = {0.76171875, 0.97265625, 0.01953125, 0.234375},
    ["HUNTER"]      = {0.01953125, 0.234375, 0.26953125, 0.484375},
    ["SHAMAN"]      = {0.26953125, 0.48046875, 0.26953125, 0.484375},
    ["PRIEST"]      = {0.515625, 0.7265625, 0.26953125, 0.484375},
    ["WARLOCK"]     = {0.76171875, 0.97265625, 0.26953125, 0.484375},
    ["PALADIN"]     = {0.01953125, 0.234375, 0.51953125, 0.734375},
    ["DEATHKNIGHT"] = {0.26953125, 0.48046875, 0.51953125, 0.734375},
    ["MONK"]        = {0.515625, 0.7265625, 0.51953125, 0.734375},
    ["DEMONHUNTER"] = {0.76171875, 0.97265625, 0.51953125, 0.734375},
}

--[[ Public-API:header
The public API is housed in the global variable `Aurora`. The tables
listed here each have a Pre and Post table that can be used to define a
function to be called before or after a particular API function.
--]]

do -- Base API
    local backdrop = {
        edgeSize = 1,
    }
    private.backdrop = backdrop

    do -- Base.AddSkin
        local skinList
--[[ Base.AddSkin(*addonName, func*)
Allows an external addon to add a skinning function for the specified
AddOn. `func` will run when the `ADDON_LOADED` event is triggered for
addonName.

* `addonName` - the name of the AddOn to be skinned _(string)_
* `func`      - used to skin the AddOn _(function)_
--]]
        function Base.AddSkin(addonName, func)
            assert(not private.AddOns[addonName], addonName .. " already has a registered skin." )
            private.AddOns[addonName] = func
            if skinList then
                tinsert(skinList, addonName)
            end
        end

        --[[ Base.GetSkinList()
        Returns an indexed list of all non-Blizzard AddOn skins.
        --]]
        function Base.GetSkinList()
            if not skinList then
                skinList = {}
                for name in next, private.AddOns do
                    if not name:find("Blizzard") and not (name == "Pre" or name == "Post") then
                        tinsert(skinList, name)
                    end
                end
            end
            return _G.CopyTable(skinList)
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

    do -- Base.SetBackdrop
        local function GetRGBA(red, green, blue, alpha)
            local a
            if type(red) == "table" then
                a = green
                red, green, blue, alpha = red:GetRGBA()
            end
            return red, green, blue, a or alpha
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
            l = {l=0, r=0.125, t=0, b=1, tileV = true},
            r = {l=0.125, r=0.25, t=0, b=1, tileV = true},
            t = {l=0.25, r=0.375, t=0, b=1, tileH = true},
            b = {l=0.375, r=0.5, t=0, b=1, tileH = true},
        }
        local corners = {
            tl = {l=0.5, r=0.625, t=0, b=1, point = "TOPLEFT"},
            tr = {l=0.625, r=0.75, t=0, b=1, point = "TOPRIGHT"},
            bl = {l=0.75, r=0.875, t=0, b=1, point = "BOTTOMLEFT"},
            br = {l=0.875, r=1, t=0, b=1, point = "BOTTOMRIGHT"},
        }
        local old_SetBackdrop = _G.getmetatable(_G.UIParent).__index.SetBackdrop
        local function SetBackdrop(frame, options, textures)
            if frame.settingBD then return end
            frame.settingBD = true
            old_SetBackdrop(frame, nil)
            if options then
                if not frame._auroraBackdrop then
                    local bd = textures or {}
                    bd.borderLayer = textures and textures.borderLayer or "BACKGROUND"
                    bd.borderSublevel = textures and textures.borderSublevel or -7

                    for name in next, bgTextures do
                        if bd[name] then
                            bd[name]:ClearAllPoints()
                            if name == "bg" then
                                bd[name]:SetDrawLayer("BACKGROUND", -8)
                            else
                                bd[name]:SetDrawLayer(bd.borderLayer, bd.borderSublevel)
                            end
                        else
                            if name == "bg" then
                                bd[name] = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
                            else
                                bd[name] = frame:CreateTexture(nil, bd.borderLayer, nil, bd.borderSublevel)
                            end
                        end

                        bd[name]:SetTexelSnappingBias(0.0)
                        bd[name]:SetSnapToPixelGrid(false)
                    end


                    frame._auroraBackdrop = bd
                end
                local bd = frame._auroraBackdrop

                --[[ The tile size is fixed at the original texture size, so this option is DOA.
                if options.tileSize then
                    bd.bg:SetSize(options.tileSize, options.tileSize)
                end]]
                options.bgFile = options.bgFile or [[Interface\Buttons\WHITE8x8]]
                if Base.IsTextureRegistered(options.bgFile) then
                    Base.SetTexture(bd.bg, options.bgFile)
                else
                    bd.bg:SetTexture(options.bgFile, "REPEAT", "REPEAT")
                    bd.bg:SetHorizTile(options.tile)
                    bd.bg:SetVertTile(options.tile)
                end

                local insets = options.insets
                if insets then
                    bd.bg:SetPoint("TOPLEFT", frame, insets.left, -insets.top)
                    bd.bg:SetPoint("BOTTOMRIGHT", frame, -insets.right, insets.bottom)
                else
                    bd.bg:SetPoint("TOPLEFT", frame)
                    bd.bg:SetPoint("BOTTOMRIGHT", frame)
                end


                options.edgeFile = options.edgeFile or [[Interface\Buttons\WHITE8x8]]
                for side, info in next, sides do
                    bd[side]:SetTexture(options.edgeFile)
                    if info.tileH then
                        bd[side]:SetTexCoord(info.l, info.b, info.r, info.b, info.l, info.t, info.r, info.t)
                    else
                        bd[side]:SetTexCoord(info.l, info.r, info.t, info.b)
                    end
                end

                for corner, info in next, corners do
                    bd[corner]:SetTexture(options.edgeFile)
                    bd[corner]:SetTexCoord(info.l, info.r, info.t, info.b)
                end

                bd.l:SetPoint("TOPLEFT", bd.tl, "BOTTOMLEFT")
                bd.l:SetPoint("BOTTOMRIGHT", bd.bl, "TOPRIGHT")

                bd.r:SetPoint("TOPLEFT", bd.tr, "BOTTOMLEFT")
                bd.r:SetPoint("BOTTOMRIGHT", bd.br, "TOPRIGHT")

                bd.t:SetPoint("TOPLEFT", bd.tl, "TOPRIGHT")
                bd.t:SetPoint("BOTTOMRIGHT", bd.tr, "BOTTOMLEFT")

                bd.b:SetPoint("TOPLEFT", bd.bl, "TOPRIGHT")
                bd.b:SetPoint("BOTTOMRIGHT", bd.br, "BOTTOMLEFT")

                if options.edgeSize then
                    for corner, info in next, corners do
                        bd[corner]:SetSize(options.edgeSize, options.edgeSize)
                        if insets then
                            if info.point == "TOPLEFT" then
                                bd[corner]:SetPoint(info.point, bd.bg, -insets.left, insets.top)
                            elseif info.point == "TOPRIGHT" then
                                bd[corner]:SetPoint(info.point, bd.bg, insets.right, insets.top)
                            elseif info.point == "BOTTOMLEFT" then
                                bd[corner]:SetPoint(info.point, bd.bg, -insets.left, -insets.bottom)
                            elseif info.point == "BOTTOMRIGHT" then
                                bd[corner]:SetPoint(info.point, bd.bg, insets.left, -insets.bottom)
                            end
                        else
                            bd[corner]:SetPoint(info.point, bd.bg)
                        end
                    end
                end

                bd.options = options
            else
                if frame._auroraBackdrop then
                    local bd = frame._auroraBackdrop
                    bd.bg:Hide()
                    for side, info in next, sides do
                        bd[side]:Hide()
                    end

                    for corner, info in next, corners do
                        bd[corner]:Hide()
                    end
                end
            end
            frame.settingBD = nil
        end
        local function GetBackdrop(frame)
            if frame._auroraBackdrop then
                local options = frame._auroraBackdrop.options
                return {
                    bgFile = options.bgFile,
                    tile = options.tile,
                    insets = options.insets,
                    edgeFile = options.edgeFile,
                    edgeSize = options.edgeSize,
                }
            end
        end
        local function SetBackdropColor(frame, red, green, blue, alpha)
            if frame._auroraBackdrop then
                red, green, blue, alpha = GetRGBA(red, green, blue, alpha)

                local bd = frame._auroraBackdrop
                bd.bgRed = red
                bd.bgGreen = green
                bd.bgBlue = blue
                bd.bgAlpha = alpha

                local tex = bd.bg:GetTexture()
                if tex then
                    bd.bg:SetVertexColor(red, green, blue, alpha)
                else
                    private.debug("SetBackdropColor no texture", frame:GetName(), tex)
                end
            end
        end
        local function GetBackdropColor(frame)
            if frame._auroraBackdrop then
                local bd = frame._auroraBackdrop
                return bd.bgRed, bd.bgGreen, bd.bgBlue, bd.bgAlpha
            end
        end
        local function SetBackdropBorderColor(frame, red, green, blue, alpha)
            if frame._auroraBackdrop then
                red, green, blue, alpha = GetRGBA(red, green, blue, alpha)

                local bd = frame._auroraBackdrop
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
                    private.debug("SetBackdropBorderColor no texture", frame:GetName(), tex)
                end
            end
        end
        local function GetBackdropBorderColor(frame)
            if frame._auroraBackdrop then
                local bd = frame._auroraBackdrop
                return bd.borderRed, bd.borderGreen, bd.borderBlue, bd.borderAlpha
            end
        end
        local function SetBackdropBorderLayer(frame, layer, sublevel)
            local bd = frame._auroraBackdrop
            bd.l:SetDrawLayer(layer, sublevel)
            bd.r:SetDrawLayer(layer, sublevel)
            bd.t:SetDrawLayer(layer, sublevel)
            bd.b:SetDrawLayer(layer, sublevel)

            bd.tl:SetDrawLayer(layer, sublevel)
            bd.tr:SetDrawLayer(layer, sublevel)
            bd.bl:SetDrawLayer(layer, sublevel)
            bd.br:SetDrawLayer(layer, sublevel)

            bd.borderLayer = layer
            bd.borderSublevel = sublevel
        end
        local function GetBackdropBorderLayer(frame)
            if frame._auroraBackdrop then
                return frame._auroraBackdrop.borderLayer, frame._auroraBackdrop.borderSublevel
            end
        end
        local function GetBackdropTexture(frame, texture)
            if frame._auroraBackdrop then
                return frame._auroraBackdrop[texture]
            end
        end

        function Base.CreateBackdrop(frame, options, textures)
            frame.SetBackdrop = SetBackdrop
            frame.GetBackdrop = GetBackdrop
            frame.SetBackdropColor = SetBackdropColor
            frame.GetBackdropColor = GetBackdropColor
            frame.SetBackdropBorderColor = SetBackdropBorderColor
            frame.GetBackdropBorderColor = GetBackdropBorderColor
            frame.SetBackdropBorderLayer = SetBackdropBorderLayer
            frame.GetBackdropBorderLayer = GetBackdropBorderLayer
            frame.GetBackdropTexture = GetBackdropTexture

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
    end

    do -- Base.SetFont
        function Base.SetFont(fontObj, fontPath, fontSize, fontStyle, fontColor, shadowColor, shadowX, shadowY)
            if _G.type(fontObj) == "string" then fontObj = _G[fontObj] end
            if not fontObj then return end

            if fontPath then
                if private.disabled.fonts then
                    fontPath = fontObj:GetFont()
                end

                fontObj:SetFont(fontPath, fontSize, fontStyle)
            end

            if fontColor then
                fontObj:SetTextColor(fontColor.r, fontColor.g, fontColor.b)
            end

            if shadowColor then
                fontObj:SetShadowColor(shadowColor.r, shadowColor.g, shadowColor.b, 0.5)
            end

            if shadowX and shadowY then
                fontObj:SetShadowOffset(shadowX, shadowY)
            end
        end
    end

    do -- Base.SetHighlight
        --[[
        local tempColor = {}
        local function GetColorTexture(string)
            _G.wipe(tempColor)
            string = string:gsub("Color%-", "")

            local prevChar, val
            string:gsub("(%x)", function(char)
                if prevChar then
                    val = _G.tonumber(prevChar..char, 16) / 255 -- convert hex to perc decimal
                    _G.tinsert(tempColor, val - (val % 0.01)) -- round val to two decimal places
                    prevChar = nil
                elseif char == "0" then
                    _G.tinsert(tempColor, 0)
                else
                    prevChar = char
                end
            end)

            return tempColor[1], tempColor[2], tempColor[3], tempColor[4]
        end
        ]]
        local function OnEnter(button, isBackground)
            if button:IsEnabled() then
                if isBackground then
                    local alpha = button._returnColor.a or Color.highlight.a
                    Base.SetBackdropColor(button._auroraBDFrame or button, Color.highlight, alpha)
                else
                    for _, texture in next, button._auroraHighlight do
                        texture:SetVertexColor(Color.highlight:GetRGBA())
                    end
                end
            end
        end
        local function OnLeave(button, isBackground)
            if isBackground then
                Base.SetBackdropColor(button._auroraBDFrame or button, button._returnColor)
            else
                for _, texture in next, button._auroraHighlight do
                    texture:SetVertexColor(button._returnColor:GetRGBA())
                end
            end
        end
        function Base.SetHighlight(button, highlightType, enter, leave)
            local isBackdrop = highlightType == "backdrop"
            local r, g, b, a

            if isBackdrop then
                local bdFrame = button._auroraBDFrame or button
                r, g, b = bdFrame:GetBackdropBorderColor()
                _, _, _, a = bdFrame:GetBackdropColor()
            else
                r, g, b, a = button._auroraHighlight[1]:GetVertexColor()
            end

            button._returnColor = Color.Create(r, g, b, a)
            button:HookScript("OnEnter", function(self)
                (enter or OnEnter)(self, isBackdrop)
            end)
            button:HookScript("OnLeave", function(self)
                (leave or OnLeave)(self, isBackdrop)
            end)
        end
    end

    do -- Base.SetTexture
        local snapshots = {}

        function Base.IsTextureRegistered(textureName)
            return not not snapshots[textureName]
        end

        function Base.SetTexture(texture, textureName)
            _G.assert(type(texture) == "table" and texture.GetObjectType, "texture widget expected, got "..type(texture))
            _G.assert(texture:GetObjectType() == "Texture", "texture widget expected, got "..texture:GetObjectType())

            local snapshot = snapshots[textureName]
            _G.assert(snapshot, textureName .. " is not a registered texture.")

            snapshot(texture:GetParent(), texture)
        end

        function Base.RegisterTexture(textureName, createFunc)
            _G.assert(not snapshots[textureName], textureName .. " is already registered.")
            private.debug("RegisterTexture", textureName)
            snapshots[textureName] = createFunc
        end
    end
end

do -- Scale API
    local floor = _G.math.floor

    local pixelScale, uiScaleChanging = false
    function private.UpdateUIScale()
        if uiScaleChanging then return end
        local _, pysHeight = _G.GetPhysicalScreenSize()

        if not private.disabled.pixelScale then
            -- Calculate current UI scale
            pixelScale = 768 / pysHeight
            local cvarScale, parentScale = _G.tonumber(_G.GetCVar("uiscale")), floor(_G.UIParent:GetScale() * 100 + 0.5) / 100
            private.debug("scale", pixelScale, cvarScale, parentScale)

            uiScaleChanging = true
            -- Set Scale (WoW CVar can't go below .64)
            if cvarScale ~= pixelScale then
                --[[ Setting the `uiScale` cvar will taint the ObjectiveTracker, and by extention the
                    WorldMap and map action button. As such, we only use that if we absolutly have to.]]
                _G.SetCVar("uiScale", _G.max(pixelScale, 0.64))
            end
            if parentScale ~= pixelScale then
                _G.UIParent:SetScale(pixelScale)
            end
            uiScaleChanging = false
        end
    end
    private.UpdateUIScale()
end

do -- Color API
    local colorMeta = {}
    function colorMeta:SetRGBA(r, g, b, a)
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        self.colorStr = self:GenerateHexColor()

        self.isAchromatic = (r == g) and (g == b)
    end
    function colorMeta:IsEqualTo(r, g, b, a)
        if _G.type(r) == "table" then
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

    do -- Color modification
        local colorSelect = _G.CreateFrame("ColorSelect")
        local Clamp = _G.Clamp
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

        function colorMeta:Hue(delta)
            return Color.Hue(self, delta)
        end
        function colorMeta:Saturation(delta)
            return Color.Saturation(self, delta)
        end
        function colorMeta:Lightness(delta)
            return Color.Lightness(self, delta)
        end
    end

    function Color.Create(r, g, b, a)
        local color = _G.CreateFromMixins(_G.ColorMixin, colorMeta)
        color:OnLoad(r, g, b, a)
        return color
    end

    Color.red = Color.Create(0.8, 0.2, 0.2)
    Color.yellow = Color.Create(0.8, 0.8, 0.2)
    Color.green = Color.Create(0.2, 0.8, 0.2)
    Color.cyan = Color.Create(0.2, 0.8, 0.8)
    Color.blue = Color.Create(0.2, 0.2, 0.8)
    Color.violet = Color.Create(0.8, 0.2, 0.8)

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

        function meta:NotifyChanges()
            --print("CUSTOM_CLASS_COLORS:NotifyChanges", private.classColorsHaveChanged)
            if not private.classColorsHaveChanged then
                -- We can't determine if the colors have changed, dispatch just in case.
                DispatchCallbacks()
            elseif private.classColorsHaveChanged() then
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
end

do -- Util API
    --[[ This is to fish for names because some templates require a name, but
        some frames that inherit those templates don't have one. ]]
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
    function Util.Mixin(table, hook)
        for name, func in next, hook do
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

    Util.OpposingSide = {
        LEFT = "RIGHT",
        RIGHT = "LEFT",
        TOP = "BOTTOM",
        BOTTOM = "TOP"
    }
end
