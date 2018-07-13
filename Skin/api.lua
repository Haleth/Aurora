local _, private = ...

-- luacheck: globals next assert type pcall tinsert math error

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
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

do -- Base API
    local backdrop = {
        edgeSize = 1,
    }
    private.backdrop = backdrop

    do -- Base.AddSkin
        local skinList
        function Base.AddSkin(addonName, func)
            assert(not private.AddOns[addonName], addonName .. " already has a registered skin." )
            private.AddOns[addonName] = func
            if skinList then
                tinsert(skinList, addonName)
            end
        end

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
        local function SetBackdrop(frame, options, bgTextures)
            if frame.settingBD then return end
            frame.settingBD = true
            old_SetBackdrop(frame, nil)
            if options then
                if not frame._auroraBackdrop then
                    if bgTextures then
                        bgTextures.bg:ClearAllPoints()
                        bgTextures.l:ClearAllPoints()
                        bgTextures.r:ClearAllPoints()
                        bgTextures.t:ClearAllPoints()
                        bgTextures.b:ClearAllPoints()
                        bgTextures.tl:ClearAllPoints()
                        bgTextures.tr:ClearAllPoints()
                        bgTextures.bl:ClearAllPoints()
                        bgTextures.br:ClearAllPoints()
                    end

                    frame._auroraBackdrop = bgTextures or {
                        bg = frame:CreateTexture(nil, "BACKGROUND", nil, -8),

                        l = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                        r = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                        t = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                        b = frame:CreateTexture(nil, "BACKGROUND", nil, -7),

                        tl = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                        tr = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                        bl = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                        br = frame:CreateTexture(nil, "BACKGROUND", nil, -7),

                        borderLayer = "BACKGROUND",
                        borderSublevel = -7,
                    }
                end
                local bd = frame._auroraBackdrop
                bd.options = options

                if options.bgFile then
                    --[[ The tile size is fixed at the original texture size, so this option is DOA.
                    if options.tileSize then
                        bd.bg:SetSize(options.tileSize, options.tileSize)
                    end]]
                    if Base.IsTextureRegistered(options.bgFile) then
                        Base.SetTexture(bd.bg, options.bgFile)
                    else
                        bd.bg:SetTexture(options.bgFile, "REPEAT", "REPEAT")
                        bd.bg:SetHorizTile(options.tile)
                        bd.bg:SetVertTile(options.tile)
                    end
                else
                    bd.bg:SetColorTexture(0, 0, 1)
                end

                local insets = options.insets
                if insets then
                    bd.bg:SetPoint("TOPLEFT", frame, insets.left, -insets.top)
                    bd.bg:SetPoint("BOTTOMRIGHT", frame, -insets.right, insets.bottom)
                else
                    bd.bg:SetPoint("TOPLEFT", frame)
                    bd.bg:SetPoint("BOTTOMRIGHT", frame)
                end


                if options.edgeFile then
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
                else
                    for side, info in next, sides do
                        bd[side]:SetColorTexture(1, 0, 0)
                        bd[side]:SetTexCoord(0, 1, 0, 1)
                    end

                    for corner, info in next, corners do
                        bd[corner]:SetColorTexture(0, 1, 0)
                        bd[corner]:SetTexCoord(0, 1, 0, 1)
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

                if options.edgeSize then
                    for corner, info in next, corners do
                        bd[corner]:SetSize(options.edgeSize, options.edgeSize)
                        bd[corner]:SetPoint(info.point, frame)
                    end
                end
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
                    bgFile = options.bgFile or [[Interface\Buttons\WHITE8x8]],
                    tile = options.tile,
                    insets = options.insets,
                    edgeFile = options.edgeFile or [[Interface\Buttons\WHITE8x8]],
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
                    if tex:find("Color%-") then
                        bd.bg:SetColorTexture(red, green, blue, alpha)
                    else
                        bd.bg:SetVertexColor(red, green, blue, alpha)
                    end
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
                    if tex:find("Color%-") then
                        for side, info in next, sides do
                            bd[side]:SetColorTexture(red, green, blue, alpha)
                        end

                        for corner, info in next, corners do
                            bd[corner]:SetColorTexture(red, green, blue, alpha)
                        end
                    else
                        for side, info in next, sides do
                            bd[side]:SetVertexColor(red, green, blue, alpha)
                        end

                        for corner, info in next, corners do
                            bd[corner]:SetVertexColor(red, green, blue, alpha)
                        end
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

        function Base.CreateBackdrop(frame, options, bgTextures)
            frame.SetBackdrop = SetBackdrop
            frame.GetBackdrop = GetBackdrop
            frame.SetBackdropColor = SetBackdropColor
            frame.GetBackdropColor = GetBackdropColor
            frame.SetBackdropBorderColor = SetBackdropBorderColor
            frame.GetBackdropBorderColor = GetBackdropBorderColor
            frame.SetBackdropBorderLayer = SetBackdropBorderLayer
            frame.GetBackdropBorderLayer = GetBackdropBorderLayer
            frame.GetBackdropTexture = GetBackdropTexture

            frame:SetBackdrop(options, bgTextures)
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

                fontObj:SetFont(fontPath, Scale.Value(fontSize), fontStyle)
            end

            if fontColor then
                fontObj:SetTextColor(fontColor.r, fontColor.g, fontColor.b)
            end

            if shadowColor then
                fontObj:SetShadowColor(shadowColor.r, shadowColor.g, shadowColor.b, 0.5)
            end

            if shadowX and shadowY then
                fontObj:SetShadowOffset(Scale.Value(shadowX), Scale.Value(shadowY))
            end
        end
    end

    do -- Base.SetHighlight
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
        local function OnEnter(button, isBackground)
            if button:IsEnabled() then
                if isBackground then
                    local alpha = button._returnColor.a or Color.highlight.a
                    Base.SetBackdropColor(button._auroraBDFrame or button, Color.highlight, alpha)
                else
                    for _, texture in next, button._auroraHighlight do
                        button._auroraSetColor(texture, Color.highlight:GetRGB())
                    end
                end
            end
        end
        local function OnLeave(button, isBackground)
            if isBackground then
                Base.SetBackdropColor(button._auroraBDFrame or button, button._returnColor)
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
                local bdFrame = button._auroraBDFrame or button
                r, g, b = bdFrame:GetBackdropBorderColor()
                _, _, _, a = bdFrame:GetBackdropColor()
            end
            button._returnColor = Color.Create(r, g, b, a)
            button._auroraSetColor = setColor
            button:HookScript("OnEnter", function(self)
                (enter or OnEnter)(self, highlightType == "backdrop")
            end)
            button:HookScript("OnLeave", function(self)
                (leave or OnLeave)(self, highlightType == "backdrop")
            end)
        end
    end

    do -- Base.SetTexture
        --[[ OffScreenFrame
            TakeSnapshot - Generates a texture from the contents of the frame
            ApplySnapshot(texture, snapshotID) - Similar to SetTexture, applies a given snapshot to a specified texture
            Flush - Clears all snapshots out of memory
            SetMaxSnapshots - Sets the number of snapshots the frame will keep in memory
            GetMaxSnapshots
            IsSnapshotValid(snapshotID) - Returns whether the snapshot id still exists, errors on "nil"
            UsesNPOT - "Uses non-power of two", returns if GPU supports snapshots that don't use dimensions that are powers of 2
        --]]

        local SnapshotFrame = _G.CreateFrame("OffScreenFrame")
        SnapshotFrame:Hide() -- Keep hidden unless taking a shot, even though it's invisible it still intercepts the mouse
        SnapshotFrame:SetSize(1024, 1024) -- This is required, we can't just call "SetAllPoints" without setting its size first
        SnapshotFrame:SetPoint("CENTER")
        --if SnapshotFrame.UsesNPOT() then -- If frame is not covering the entire screen fonts aren't scaled correctly
            --SnapshotFrame:SetAllPoints()
        --end

        local textureFrame do
            textureFrame = _G.CreateFrame("Frame", nil, SnapshotFrame)
            textureFrame:SetPoint("TOPLEFT")
            local function reset(self, region)
                region:Hide()
                region:SetGradient("HORIZONTAL", 1, 1, 1, 1, 1, 1)
                region:SetTexture("")
                if self.type ~= "line" then
                    region:ClearAllPoints()
                    region:SetVertexOffset(1, 0, 0)
                    region:SetVertexOffset(2, 0, 0)
                    region:SetVertexOffset(3, 0, 0)
                    region:SetVertexOffset(4, 0, 0)
                end
                if self.type == "texture" then
                    if region.masks then
                        region:RemoveMaskTexture()
                    end
                end
            end

            local function AddMaskTexture(self, mask)
                if not self.masks then
                    self.masks = {}
                end
                _G.tinsert(self.masks, mask)
            end
            local function RemoveMaskTexture(self, mask)
                if not mask and self.masks then
                    for i = #self.masks, 1, -1 do
                        local m = _G.tremove(self.masks, i)
                        self:RemoveMaskTexture(m)
                    end
                end
            end

            local CreateTexture = textureFrame.CreateTexture
            local function TextureFactory(texturePool)
                local texture = CreateTexture(textureFrame)
                _G.hooksecurefunc(texture, "AddMaskTexture", AddMaskTexture)
                _G.hooksecurefunc(texture, "RemoveMaskTexture", RemoveMaskTexture)
                return texture
            end
            local texturePool = _G.CreateObjectPool(TextureFactory, reset)
            texturePool.type = "texture"
            function textureFrame:CreateTexture(name, layer, template, sublayer)
                local texture = texturePool:Acquire()
                texture:SetDrawLayer(layer or "ARTWORK", sublayer or 0)
                return texture
            end


            local CreateLine = textureFrame.CreateLine
            local function LineFactory(linePool)
                return CreateLine(textureFrame)
            end
            local linePool = _G.CreateObjectPool(LineFactory, reset)
            linePool.type = "line"
            function textureFrame:CreateLine(name, layer, template, sublayer)
                local line = linePool:Acquire()
                line:SetDrawLayer(layer or "ARTWORK", sublayer or 0)
                return line
            end


            local CreateMaskTexture = textureFrame.CreateMaskTexture
            local function MaskTextureFactory(maskPool)
                return CreateMaskTexture(textureFrame)
            end
            local maskPool = _G.CreateObjectPool(MaskTextureFactory, reset)
            maskPool.type = "mask"
            function textureFrame:CreateMaskTexture(name, layer, template, sublayer)
                local mask = maskPool:Acquire()
                mask:SetDrawLayer(layer or "ARTWORK", sublayer or 0)
                return mask
            end

            function textureFrame:ReleaseAll()
                texturePool:ReleaseAll()
                linePool:ReleaseAll()
                maskPool:ReleaseAll()
            end
        end

        local snapshots = {}

        function Base.IsTextureRegistered(textureName)
            return not not snapshots[textureName]
        end

        local useSnapshots = true
        function Base.SetTexture(texture, textureName, useTextureSize)
            _G.assert(type(texture) == "table" and texture.GetObjectType, "texture widget expected, got "..type(texture))
            _G.assert(texture:GetObjectType() == "Texture", "texture widget expected, got "..texture:GetObjectType())

            local snapshot = snapshots[textureName]
            _G.assert(snapshot, textureName .. " is not a registered texture.")

            if useSnapshots then
                if not snapshot.id or not SnapshotFrame:IsSnapshotValid(snapshot.id) then
                    snapshot.create(textureFrame)
                    local width, height = textureFrame:GetSize()

                    SnapshotFrame:Show()
                    local id = SnapshotFrame:TakeSnapshot()
                    SnapshotFrame:Hide()
                    textureFrame:ReleaseAll()

                    local snapshotWidth, snapshotHeight = SnapshotFrame:GetSize()

                    snapshot.id = id
                    snapshot.width = width
                    snapshot.height = height
                    snapshot.x = width / snapshotWidth
                    snapshot.y = height / snapshotHeight

                    if not snapshot.id then
                        private.debug("No snapshots")
                        useSnapshots = false
                        return snapshot.create(texture:GetParent(), texture)
                    end
                end
                if useTextureSize then
                    texture:SetSize(snapshot.width, snapshot.height)
                end
                SnapshotFrame:ApplySnapshot(texture, snapshot.id)
                texture:SetTexCoord(0, snapshot.x, 0, snapshot.y)
            else
                snapshot.create(texture:GetParent(), texture)
            end
        end

        function Base.RegisterTexture(textureName, createFunc)
            snapshots[textureName] = {
                create = createFunc
            }
            SnapshotFrame:SetMaxSnapshots(SnapshotFrame:GetMaxSnapshots() + 1)
        end
    end
end

do -- Scale API
    local floor = _G.math.floor

    local uiScaleChanging = false
    local uiMod, pixelScale
    function private.UpdateUIScale()
        if uiScaleChanging then return end
        local pysWidth, pysHeight = _G.GetPhysicalScreenSize()

        if not private.disabled.uiScale then
            -- Set UI scale modifier
            uiMod = (pysHeight / 768) * (private.uiScale or 1)
            private.debug("physical size", pysWidth, pysHeight)
            private.debug("uiMod", uiMod)
        end

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

    function Scale.GetUIScale()
        return uiMod or 1
    end

    function Scale.Value(value, getFloat)
        local mult = getFloat and 100 or 1
        return floor((value * uiMod) * mult + 0.5) / mult
    end

    function Scale.Size(self, width, height)
        if not (width and height) then
            width, height = self:GetSize()
        end
        return self:SetSize(Scale.Value(width), Scale.Value(height))
    end

    function Scale.Height(self, height)
        if not (height) then
            height = self:GetHeight()
        end
        return self:SetHeight(Scale.Value(height))
    end

    function Scale.Width(self, width)
        if not (width) then
            width = self:GetWidth()
        end
        return self:SetWidth(Scale.Value(width))
    end

    function Scale.Thickness(self, thickness)
        if not (thickness) then
            thickness = self:GetThickness()
        end
        return self:SetThickness(Scale.Value(thickness))
    end

    function Scale.Atlas(self, atlas, useAtlasSize)
        if useAtlasSize then
            private.debug("SetAtlas", self:GetDebugName(), atlas, self:GetAtlas())
            atlas = atlas or self:GetAtlas()
            if atlas then
                local _, x, y = _G.GetAtlasInfo(atlas)
                self:SetSize(x, y)
            end
        end
    end

    local ScaleArgs do
        local function pack(t, ...)
            for i = 1, _G.select("#", ...) do
                t[i] = _G.select(i, ...)
            end
        end

        local args = {}
        function ScaleArgs(self, method, ...)
            if self.debug then
                private.debug("raw args", method, ...)
            end
            _G.wipe(args)
            --[[ This function gets called A LOT, so we recycle this table
                to reduce needless garbage creation.]]
            if ... then
                pack(args, ...)
            else
                pack(args, self["Get"..method](self))
            end

            for i = 1, #args do
                if _G.type(args[i]) == "number" then
                    args[i] = Scale.Value(args[i])
                end
            end
            if self.debug then
                private.debug("final args", method, _G.unpack(args))
            end
            return _G.unpack(args)
        end
    end

    function Scale.Point(self, ...)
        self:SetPoint(ScaleArgs(self, "Point", ...))
    end

    function Scale.EndPoint(self, ...)
        self:SetEndPoint(ScaleArgs(self, "EndPoint", ...))
    end
    function Scale.StartPoint(self, ...)
        self:SetStartPoint(ScaleArgs(self, "StartPoint", ...))
    end


    -- Widget Hooks --
    local function doSet(self, method)
        if (self:IsForbidden() or _G.InCombatLockdown()) or self["_setting"..method] then
            return false
        end
        return not self["_auroraNoSet"..method]
    end
    local positionMethods = {
        "Size",
        "Height",
        "Width",
        "Point",
        "StartPoint",
        "EndPoint",
        "Thickness",
        "Atlas",
    }

    local widgets = {
        Frame = {
            Texture = false,
            Line = false,
            MaskTexture = false,
            FontString = false,
        },
        Button = false,
        CheckButton = false,
        Cooldown = false,
        ColorSelect = false,
        EditBox = false,
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
        for _, method in next, positionMethods do
            local methodName = "Set" .. method
            if widget[methodName] then
                Scale["Raw"..methodName] = mt[methodName]
                if not private.disabled.uiScale then
                    local methodCheck = "_setting"..method
                    _G.hooksecurefunc(mt, methodName, function(self, ...)
                        if not doSet(self, method) then return end
                        self[methodCheck] = true
                        Scale[method](self, ...)
                        self[methodCheck] = nil
                    end)
                end
            end
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
        widget:Hide()
    end
    HookSetters(_G.Minimap)
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
        local function HueToRBG(p, q, t)
            if t < 0   then t = t + 1 end
            if t > 1   then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end
        local function HSLToRGB(h, s, l)
            local r, g, b

            if s <= 0 then
                return l, l, l -- achromatic
            else
                local q
                if l <= 0.5 then
                    q = l * (s + 1)
                else
                    q = l + s - l * s
                end

                local p = l * 2 - q

                r = HueToRBG(p, q, h + 1/3)
                g = HueToRBG(p, q, h)
                b = HueToRBG(p, q, h - 1/3)
            end

            return r, g, b
        end

        local min, max = math.min, math.max
        local function RGBToHSL(r, g, b)
            local minVal, maxVal = min(r, g, b), max(r, g, b)
            local delta = maxVal - minVal

            local h, s, l = 0, 0, (maxVal + minVal) / 2

            if l > 0 and l < 0.5 then s = delta / (maxVal + minVal) end
            if l >= 0.5 and l < 1 then s = delta / (2 - maxVal - minVal) end

            if delta > 0 then
                if maxVal == r and maxVal ~= g then
                    h = h + (g - b) / delta
                end

                if maxVal == g and maxVal ~= b then
                    h = h + 2 + (b - r) / delta
                end

                if maxVal == b and maxVal ~= r then
                    h = h + 4 + (r - g) / delta
                end

                h = h / 6
            end
            return h, s, l
        end

        local Clamp = _G.Clamp
        function Color.Hue(color, delta)
            local h, s, l = RGBToHSL(color.r, color.g, color.b)
            return Color.Create(HSLToRGB(h + delta, s, l))
        end
        function Color.Saturation(color, delta)
            local h, s, l = RGBToHSL(color.r, color.g, color.b)
            return Color.Create(HSLToRGB(h, Clamp(s + s * delta, 0, 1), l))
        end
        function Color.Lightness(color, delta)
            local h, s, l = RGBToHSL(color.r, color.g, color.b)
            return Color.Create(HSLToRGB(h, s, Clamp(l + l * delta, 0, 1)))
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
        local color = _G.Mixin({}, _G.ColorMixin, colorMeta)
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

    do -- CUSTOM_CLASS_COLORS
        local classColors = {}

        local callbacks, numCallbacks = {}, 0
        function classColors:RegisterCallback(method, handler)
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
        function classColors:UnregisterCallback(method, handler)
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

        function classColors:NotifyChanges()
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
        function classColors:GetClassToken(className)
            return className and classTokens[className]
        end

        function private.classColorsReset(colors, noMeta)
            local colorTable = colors or _G.CUSTOM_CLASS_COLORS
            for class, color in next, _G.RAID_CLASS_COLORS do
                if noMeta then
                    if colorTable[class] then
                        colorTable[class].r = color.r
                        colorTable[class].g = color.g
                        colorTable[class].b = color.b
                        colorTable[class].colorStr = color.colorStr
                    else
                        colorTable[class] = {
                            r = color.r,
                            g = color.g,
                            b = color.b,
                            colorStr = color.colorStr
                        }
                    end
                else
                    if colorTable[class] and colorTable[class].SetRGB then
                        colorTable[class]:SetRGB(color.r, color.g, color.b)
                    else
                        colorTable[class] = _G.setmetatable({}, {
                            __index = Color.Create(color.r, color.g, color.b)
                        })
                    end
                end
            end

            if colors then
                classColors:NotifyChanges()
            else
                DispatchCallbacks()
            end
        end
        function private.updateHighlightColor()
            Color.highlight:SetRGB(_G.CUSTOM_CLASS_COLORS[private.charClass.token]:GetRGB())
        end

        _G.CUSTOM_CLASS_COLORS = {}
        private.classColorsReset()

        _G.setmetatable(_G.CUSTOM_CLASS_COLORS, {__index = classColors})
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
    function Util.TestHook(table, func, name)
        _G.hooksecurefunc(table, func, function(...)
            _G.print("Test", name, ...)
        end)
    end

    Util.OpposingSide = {
        LEFT = "RIGHT",
        RIGHT = "LEFT",
        TOP = "BOTTOM",
        BOTTOM = "TOP"
    }
end
