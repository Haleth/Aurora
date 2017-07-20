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
