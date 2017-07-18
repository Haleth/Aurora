local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base

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
        if layer then
            texture:SetDrawLayer(layer, sublayer)
        end
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
        if layer then
            line:SetDrawLayer(layer, sublayer)
        end
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
        if layer then
            mask:SetDrawLayer(layer, sublayer)
        end
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


do -- arrows
    local size = 64
    local offset = size / 2
    local map = {
        up = {1, 3},
        down = {2, 4},
        left = {1, 2},
        right = {3, 4},
    }

    local function setup(frame)
        frame:SetSize(size, size)

        local texture = frame:CreateTexture(nil, "BACKGROUND")
        texture:SetColorTexture(1, 1, 1)
        texture:SetAllPoints()
        texture:Show()
        return texture
    end

    Base.RegisterTexture("arrowUp", function(frame)
        local texture = setup(frame)
        texture:SetVertexOffset(map.up[1], offset, 0)
        texture:SetVertexOffset(map.up[2], -offset, 0)
    end)
    Base.RegisterTexture("arrowDown", function(frame)
        local texture = setup(frame)
        texture:SetVertexOffset(map.down[1], offset, 0)
        texture:SetVertexOffset(map.down[2], -offset, 0)
    end)
    Base.RegisterTexture("arrowLeft", function(frame)
        local texture = setup(frame)
        texture:SetVertexOffset(map.left[1], 0, -offset)
        texture:SetVertexOffset(map.left[2], 0, offset)
    end)
    Base.RegisterTexture("arrowRight", function(frame)
        local texture = setup(frame)
        texture:SetVertexOffset(map.left[1], 0, -offset)
        texture:SetVertexOffset(map.left[2], 0, offset)
    end)
end

do -- gradients
    local min, max = 0.3, 0.7

    local function setup(frame)
        frame:SetAllPoints() --Size(256, 256)

        local texture = frame:CreateTexture(nil, "BACKGROUND")
        texture:SetColorTexture(1, 1, 1)
        texture:SetAllPoints()
        texture:Show()
        return texture
    end

    Base.RegisterTexture("gradientUp", function(frame)
        local texture = setup(frame)
        texture:SetGradient("VERTICAL", min, min, min, max, max, max)
    end)
    Base.RegisterTexture("gradientDown", function(frame)
        local texture = setup(frame)
        texture:SetGradient("VERTICAL", max, max, max, min, min, min)
    end)
    Base.RegisterTexture("gradientLeft", function(frame)
        local texture = setup(frame)
        texture:SetGradient("HORIZONTAL", max, max, max, min, min, min)
    end)
    Base.RegisterTexture("gradientRight", function(frame)
        local texture = setup(frame)
        texture:SetGradient("HORIZONTAL", min, min, min, max, max, max)
    end)
end

do -- LFG Icons
    local map = {
        {1, 1},
        {2, 1},
        {3, 1},
        {1, 2},
        {2, 2},
        {3, 2},
        {1, 3},
        {2, 3},
    }
    local function CreateIcon(frame, i)
        local info = map[i]
        local icon = frame:CreateTexture(nil, "BORDER")
        icon:SetSize(67, 67)
        icon:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-ROLES]])
        icon:SetTexCoord(_G.GetTexCoordsByGrid(info[1], info[2], 256, 256, 67, 67))
        icon:Show()

        local mask = frame:CreateMaskTexture(nil, "BORDER")
        mask:SetTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetSize(47, 47)
        mask:SetPoint("TOPLEFT", icon, 10, -8)
        mask:Show()
        icon:AddMaskTexture(mask)
        return icon
    end
    Base.RegisterTexture("lfgIcons", function(frame)
        frame:SetSize(256, 256)

        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0, 0, 0)
        bg:Show()

        local prevIcon = CreateIcon(frame, 1)
        local cornerIcon = prevIcon
        prevIcon:SetPoint("TOPLEFT", frame)

        for i = 2, #map do
            local icon = CreateIcon(frame, i)
            if i % 3 == 1 then
                icon:SetPoint("TOPLEFT", cornerIcon, "BOTTOMLEFT")
                cornerIcon = icon
            else
                icon:SetPoint("TOPLEFT", prevIcon, "TOPRIGHT")
            end
            prevIcon = icon
        end
    end)
end


--[[
Base.RegisterTexture("test", function(frame)
    frame:SetSize(256, 256)

    local prevIcon = CreateIcon(frame, 1)
    local cornerIcon = prevIcon
    prevIcon:SetPoint("TOPLEFT", frame)

    for i = 2, #map do
        local icon = CreateIcon(frame, i)
        if i % 3 == 1 then
            icon:SetPoint("TOPLEFT", cornerIcon, "BOTTOMLEFT")
            cornerIcon = icon
        else
            icon:SetPoint("TOPLEFT", prevIcon, "TOPRIGHT")
        end
        prevIcon = icon
    end
end)

local snapshot = _G.UIParent:CreateTexture("$parentSnapshotTest", "BACKGROUND")
snapshot:SetPoint("CENTER")
snapshot:SetSize(16, 8)
Base.SetTexture(snapshot, "gradientLeft", true)
Base.SetTexture(snapshot, "lfgIcons", true)
Base.SetTexture(snapshot, "gradientUp", true)
Base.SetTexture(snapshot, "arrowLeft", true)
Base.SetTexture(snapshot, "gradientLeft", true)
--local color = _G.RAID_CLASS_COLORS[private.charClass.token]
--snapshot:SetVertexColor(color.r, color.g, color.b)
]]
