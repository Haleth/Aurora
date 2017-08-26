local _, private = ...

-- luacheck: globals next assert

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
local function CreateColor(r, g, b, a)
    local color = _G.CreateFromMixins(colorMeta)
    color:OnLoad(r, g, b, a)
    return color
end
Base.CreateColor = CreateColor


local highlightColor = CreateColor(0, 0, 1, 1) -- Temporary, the proper highlight color will be set later
Aurora.highlightColor = highlightColor

local buttonColor = CreateColor(.2, .2, .2, 1)
Aurora.buttonColor = buttonColor

local frameColor = CreateColor(0, 0, 0, 0.2)
Aurora.frameColor = frameColor


local backdrop = {
    edgeSize = 1,
}
private.backdrop = backdrop

do -- Base.AddSkin
    function Base.AddSkin(addonName, func)
        assert(not private.AddOns[addonName], addonName .. "already has a registered skin." )
        private.AddOns[addonName] = func
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
    local sides = {
        l = {coords = {0, 0.125, 0, 1}, tileV = true},
        r = {coords = {0.125, 0.25, 0, 1}, tileV = true},
        t = {coords = {0.25, 0.375, 0, 1}, tileH = true},
        b = {coords = {0.375, 0.5, 0, 1}, tileH = true},
    }
    local corners = {
        tl = {coords = {0.5, 0.625, 0, 1}, point = "TOPLEFT"},
        tr = {coords = {0.625, 0.75, 0, 1}, point = "TOPRIGHT"},
        bl = {coords = {0.75, 0.875, 0, 1}, point = "BOTTOMLEFT"},
        br = {coords = {0.875, 1, 0, 1}, point = "BOTTOMRIGHT"},
    }
    local old_SetBackdrop = _G.getmetatable(_G.UIParent).__index.SetBackdrop
    local function SetBackdrop(frame, options)
        if frame.settingBD then return end
        frame.settingBD = true
        old_SetBackdrop(frame, nil)
        if options then
            if not frame._auroraBackdrop then
                frame._auroraBackdrop = {
                    bg = frame:CreateTexture(nil, "BACKGROUND", nil, -8),

                    l = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                    r = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                    t = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                    b = frame:CreateTexture(nil, "BACKGROUND", nil, -7),

                    tl = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                    tr = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                    bl = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
                    br = frame:CreateTexture(nil, "BACKGROUND", nil, -7),
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
                bd.bg:SetPoint("TOPLEFT", insets.left, -insets.top)
                bd.bg:SetPoint("BOTTOMRIGHT", -insets.right, insets.bottom)
            else
                bd.bg:SetPoint("TOPLEFT")
                bd.bg:SetPoint("BOTTOMRIGHT")
            end


            if options.edgeFile then
                for side, info in next, sides do
                    bd[side]:SetTexture(options.edgeFile, "REPEAT", "REPEAT")
                    bd[side]:SetHorizTile(info.tileH)
                    bd[side]:SetVertTile(info.tileV)
                    if info.tileH then
                        bd[side]:SetTexCoord(info.coords[1], info.coords[4], info.coords[2], info.coords[4], info.coords[1], info.coords[3], info.coords[2], info.coords[3])
                    else
                        bd[side]:SetTexCoord(info.coords[1], info.coords[2], info.coords[3], info.coords[4])
                    end
                end

                for corner, info in next, corners do
                    bd[corner]:SetTexture(options.edgeFile)
                    bd[corner]:SetTexCoord(info.coords[1], info.coords[2], info.coords[3], info.coords[4])
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

            for corner, info in next, corners do
                bd[corner]:SetSize(options.edgeSize, options.edgeSize)
                bd[corner]:SetPoint(info.point)
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
        return frame._auroraBackdrop and frame._auroraBackdrop.options
    end
    local function SetBackdropColor(frame, red, green, blue, alpha)
        if frame._auroraBackdrop then
            local bd = frame._auroraBackdrop
            bd.bgRed = red
            bd.bgGreen = green
            bd.bgBlue = blue
            bd.bgAlpha = alpha
            if bd.bg:GetTexture():find("Color%-") then
                bd.bg:SetColorTexture(red, green, blue, alpha)
            else
                bd.bg:SetVertexColor(red, green, blue, alpha)
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
            local bd = frame._auroraBackdrop
            bd.borderRed = red
            bd.borderGreen = green
            bd.borderBlue = blue
            bd.borderAlpha = alpha
            if bd.t:GetTexture():find("Color%-") then
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
        end
    end
    local function GetBackdropBorderColor(frame)
        if frame._auroraBackdrop then
            local bd = frame._auroraBackdrop
            return bd.borderRed, bd.borderGreen, bd.borderBlue, bd.borderAlpha
        end
    end
    local function GetBackdropTexture(frame, texture)
        if frame._auroraBackdrop then
            return frame._auroraBackdrop[texture]
        end
    end

    function Base.SetBackdrop(frame, r, g, b, a)
        frame.SetBackdrop = SetBackdrop
        frame.GetBackdrop = GetBackdrop
        frame.SetBackdropColor = SetBackdropColor
        frame.GetBackdropColor = GetBackdropColor
        frame.SetBackdropBorderColor = SetBackdropBorderColor
        frame.GetBackdropBorderColor = GetBackdropBorderColor
        frame.GetBackdropTexture = GetBackdropTexture

        frame:SetBackdrop(backdrop)
        Base.SetBackdropColor(frame, r, g, b, a)
    end
    function Base.SetBackdropColor(frame, r, g, b, a)
        if not r then r, g, b, a = frameColor:GetRGBA() end
        frame:SetBackdropColor(r * 0.6, g * 0.6, b * 0.6, a or 1)
        frame:SetBackdropBorderColor(r, g, b, 1)
    end
end

do -- Base.SetFont
    function Base.SetFont(fontObj, fontPath, fontSize, fontStyle, fontColor, shadowColor, shadowX, shadowY)
        if _G.type(fontObj) == "string" then fontObj = _G[fontObj] end
        if not fontObj then return end

        fontObj:SetFont(fontPath, fontSize, fontStyle)
        if _G.type(fontColor) == "table" then
            fontObj:SetTextColor(fontColor[1], fontColor[2], fontColor[3], fontColor[4])
        elseif fontColor then
            fontObj:SetAlpha(fontColor)
        end

        if shadowColor then
            fontObj:SetShadowColor(shadowColor[1], shadowColor[2], shadowColor[3], shadowColor[4])
        end
        if shadowX and shadowY then
            fontObj:SetShadowOffset(shadowX, shadowY)
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
                Base.SetBackdropColor(button, highlightColor:GetRGBA())
            else
                for _, texture in next, button._auroraHighlight do
                    button._auroraSetColor(texture, highlightColor:GetRGBA())
                end
            end
        end
    end
    local function OnLeave(button, isBackground)
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

    function Base.SetTexture(texture, textureName, useTextureSize)
        local snapshot = snapshots[textureName]
        _G.assert(snapshot, textureName .. " is not a registered texture.")
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
        end
        if useTextureSize then
            texture:SetSize(snapshot.width, snapshot.height)
        end
        SnapshotFrame:ApplySnapshot(texture, snapshot.id)
        texture:SetTexCoord(0, snapshot.x, 0, snapshot.y)
    end

    function Base.RegisterTexture(textureName, createFunc)
        snapshots[textureName] = {
            create = createFunc
        }
        SnapshotFrame:SetMaxSnapshots(SnapshotFrame:GetMaxSnapshots() + 1)
    end
end
