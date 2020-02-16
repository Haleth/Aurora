local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Color = Aurora.Color

local textures = {}
_G.C_Timer.NewTicker(0, function(...)
    --[[
        Newly created textures may not have a defined sized by the time
        they are skinned. Due to this, we add them to a queue and wait
        for them to be visible, at which point it should have proper
        dimensions.
    ]]
    for texture, name in next, textures do
        if texture:IsVisible() then
            Base.SetTexture(texture, name)
            textures[texture] = nil
        end
    end
end)

do -- arrows
    local function setup(frame, texture)
        texture:SetColorTexture(1, 1, 1)

        texture:SetVertexOffset(1, 0, 0)
        texture:SetVertexOffset(2, 0, 0)
        texture:SetVertexOffset(3, 0, 0)
        texture:SetVertexOffset(4, 0, 0)
        return texture
    end
    local function GetOffset(texture, textureType, size)
        local offset = size / 2
        if offset < 1 then
            textures[texture] = textureType
        else
            return offset
        end
    end

    Base.RegisterTexture("arrowLeft", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetOffset(texture, "arrowLeft", texture:GetHeight())
        if offset then
            texture:SetVertexOffset(1, 0, -offset)
            texture:SetVertexOffset(2, 0, offset)
        end
    end)
    Base.RegisterTexture("arrowRight", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetOffset(texture, "arrowRight", texture:GetHeight())
        if offset then
            texture:SetVertexOffset(3, 0, -offset)
            texture:SetVertexOffset(4, 0, offset)
        end
    end)
    Base.RegisterTexture("arrowUp", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetOffset(texture, "arrowUp", texture:GetWidth())
        if offset then
            texture:SetVertexOffset(1, offset, 0)
            texture:SetVertexOffset(3, -offset, 0)
        end
    end)
    Base.RegisterTexture("arrowDown", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetOffset(texture, "arrowDown", texture:GetWidth())
        if offset then
            texture:SetVertexOffset(2, offset, 0)
            texture:SetVertexOffset(4, -offset, 0)
        end
    end)
end

do -- gradients
    local min, max = 0.3, 0.7
    local hookedTexture = {}

    local function SetVertexColorMinMax(texture, r, g, b, a)
        texture:SetGradientAlpha(hookedTexture[texture], r * min, g * min, b * min, a, r * max, g * max, b * max, a)

    end
    local function SetGradientMinMax(frame, texture, direction)
        local r, g, b, a = texture:GetVertexColor()
        if r and g and b then
            texture:SetGradientAlpha(direction, r * min, g * min, b * min, a, r * max, g * max, b * max, a)
        else
            texture:SetGradient(direction, min, min, min, max, max, max)
        end

        if not hookedTexture[texture] then
            _G.hooksecurefunc(texture, "SetVertexColor", SetVertexColorMinMax)
            hookedTexture[texture] = direction
        end
    end

    local function SetVertexColorMaxMin(texture, r, g, b, a)
        texture:SetGradientAlpha(hookedTexture[texture], r * max, g * max, b * max, a, r * min, g * min, b * min, a)
    end
    local function SetGradientMaxMin(frame, texture, direction)
        local r, g, b, a = texture:GetVertexColor()
        if r and g and b then
            texture:SetGradientAlpha(direction, r * max, g * max, b * max, a, r * min, g * min, b * min, a)
        else
            texture:SetGradient(direction, max, max, max, min, min, min)
        end

        if not hookedTexture[texture] then
            _G.hooksecurefunc(texture, "SetVertexColor", SetVertexColorMaxMin)
            hookedTexture[texture] = direction
        end
    end

    Base.RegisterTexture("gradientUp", function(frame, texture)
        texture:SetTexture(private.textures.plain)
        SetGradientMinMax(frame, texture, "VERTICAL")
    end)
    Base.RegisterTexture("gradientDown", function(frame, texture)
        texture:SetTexture(private.textures.plain)
        SetGradientMaxMin(frame, texture, "VERTICAL")
    end)
    Base.RegisterTexture("gradientLeft", function(frame, texture)
        texture:SetTexture(private.textures.plain)
        SetGradientMaxMin(frame, texture, "HORIZONTAL")
    end)
    Base.RegisterTexture("gradientRight", function(frame, texture)
        texture:SetTexture(private.textures.plain)
        SetGradientMinMax(frame, texture, "HORIZONTAL")
    end)
end

do -- Icons
    local iconTextures = {}
    local function CreateIcon(frame, texture)
        texture:SetTexelSnappingBias(0.0)
        texture:SetSnapToPixelGrid(false)

        local layer, subLevel = texture:GetDrawLayer()
        local border = frame:CreateTexture(nil, layer, nil, subLevel - 2)
        border:SetPoint("TOPLEFT", texture, -1, 1)
        border:SetPoint("BOTTOMRIGHT", texture, 1, -1)
        texture._auroraBorder = border

        local bg = frame:CreateTexture(nil, layer, nil, subLevel - 1)
        bg:SetAllPoints(texture)
        texture._auroraBG = bg

        local mask = frame:CreateMaskTexture()
        mask:SetTexture([[Interface\CharacterFrame\TemporaryPortrait-Female-MagharOrc]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetAllPoints(texture)
        texture:AddMaskTexture(mask)
        texture._auroraMask = mask

        iconTextures[texture] = true
    end


    local map = {
        GUIDE = {color = Color.blue:Hue(-0.1):Lightness(-0.7), 0.03515625, 0.22265625, 0.03125, 0.21875},
        HEALER = {color = Color.green:Lightness(-0.7), 0.296875, 0.484375, 0.03125, 0.21875},
        --CHECK = {color = Color.black, 0.55859375, 0.74609375, 0.03125, 0.21875},
        TANK = {color = Color.blue:Lightness(-0.7), 0.03515625, 0.22265625, 0.29296875, 0.48046875},
        DAMAGER = {color = Color.red:Lightness(-0.7), 0.296875, 0.484375, 0.29296875, 0.48046875},
        --PROMPT = {color = Color.black, 0.55859375, 0.74609375, 0.29296875, 0.48046875},
        --COVER = {0.01953125, 0.24609375, 0.5234375, 0.75},
        --CROSS = {color = Color.black, 0.296875, 0.484375, 0.5546875, 0.7421875},
    }
    for name, coords in next, map do
        Base.RegisterTexture("icon"..name, function(frame, texture)
            if not iconTextures[texture] then
                CreateIcon(frame, texture)
            end

            texture:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-ROLES]])
            texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
            texture:SetAlpha(0.75)
            texture:SetBlendMode("ADD")

            texture._auroraBorder:SetColorTexture(0, 0, 0)
            texture._auroraBG:SetColorTexture(coords.color:GetRGB())
            texture._auroraMask:Show()
        end)
    end

    for name, color in next, _G.CUSTOM_CLASS_COLORS do
        Base.RegisterTexture("icon"..name, function(frame, texture)
            if not iconTextures[texture] then
                CreateIcon(frame, texture)
            end

            local coords = Aurora.classIcons[name]
            texture:SetTexture([[Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes]])
            texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
            texture:SetAlpha(1)
            texture:SetBlendMode("DISABLE")

            texture._auroraBorder:SetColorTexture(color:GetRGB())
            texture._auroraMask:Hide()
        end)
    end
end

do -- Shapes
    local shapes = {}
    Base.RegisterTexture("shapeStar", function(frame, texture)
        local texture2
        if shapes[texture] then
            texture2 = shapes[texture]
        else
            local layer, subLevel = texture:GetDrawLayer()
            texture2 = frame:CreateTexture(nil, layer, nil, subLevel)

            _G.hooksecurefunc(texture, "SetVertexColor", function(self, ...)
                texture2:SetVertexColor(...)
            end)
            _G.hooksecurefunc(texture, "SetColorTexture", function(self, ...)
                texture2:SetColorTexture(...)
            end)
            _G.hooksecurefunc(texture, "SetDesaturated", function(self, ...)
                texture2:SetDesaturated(...)
            end)
            _G.hooksecurefunc(texture, "SetAlpha", function(self, ...)
                texture2:SetAlpha(...)
            end)
            _G.hooksecurefunc(texture, "SetBlendMode", function(self, ...)
                texture2:SetBlendMode(...)
            end)
            shapes[texture] = texture2
        end

        local width, height = texture:GetSize()
        if width == 0 or height == 0 then
            textures[texture] = "shapeStar"
            return
        end

        texture:SetColorTexture(Color.yellow:GetRGB())
        texture:SetVertexOffset(1, width * 0.81, -(height * 0.95))
        texture:SetVertexOffset(2, width * 0.5, height * 0.27)
        texture:SetVertexOffset(3, -(width * 0.5), 0)
        texture:SetVertexOffset(4, -(width * 0.81), height * 0.05)

        texture2:SetColorTexture(Color.yellow:GetRGB())
        texture2:SetAllPoints(texture)
        texture2:SetVertexOffset(1, 0, -(height * 0.365))
        texture2:SetVertexOffset(2, width * 0.5, height * 0.27)
        texture2:SetVertexOffset(3, 0, -(height * 0.365))
        texture2:SetVertexOffset(4, -(width * 0.5), height * 0.27)
    end)

    Base.RegisterTexture("shapeDiamond", function(frame, texture)
        local width, height = texture:GetSize()
        if width == 0 or height == 0 then
            textures[texture] = "shapeDiamond"
            return
        end

        texture:SetColorTexture(1, 1, 1)
        texture:SetVertexOffset(1, 0, -(height / 2))
        texture:SetVertexOffset(2, width / 2, 0)
        texture:SetVertexOffset(3, -(width / 2), 0)
        texture:SetVertexOffset(4, 0, height / 2)
    end)
end

--[[
Base.RegisterTexture("test", function(frame, texture)
    texture:SetColorTexture(Color.white:GetRGB())
end)

local snapshot = _G.UIParent:CreateTexture("$parentSnapshotTest", "BACKGROUND")
snapshot:SetPoint("CENTER")
snapshot:SetSize(256, 256)
Base.SetTexture(snapshot, "test")
--Base.SetTexture(snapshot, "shapeStar")
--Base.SetTexture(snapshot, "iconDAMAGER")
--Base.SetTexture(snapshot, "gradientUp")
--Base.SetTexture(snapshot, "arrowLeft")
--Base.SetTexture(snapshot, "gradientLeft")
--local color = _G.RAID_CLASS_COLORS[private.charClass.token]
--snapshot:SetVertexColor(color.r, color.g, color.b)
]]
