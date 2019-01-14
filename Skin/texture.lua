local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Color = Aurora.Color

do -- arrows
    local function setup(frame, texture)
        texture:SetColorTexture(1, 1, 1)

        texture:SetVertexOffset(1, 0, 0)
        texture:SetVertexOffset(2, 0, 0)
        texture:SetVertexOffset(3, 0, 0)
        texture:SetVertexOffset(4, 0, 0)
        return texture
    end
    local function GetVertOffset(frame, texture)
        return texture:GetHeight() / 2
    end
    local function GetHorizOffset(frame, texture)
        return texture:GetWidth() / 2
    end

    Base.RegisterTexture("arrowLeft", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetVertOffset(frame, texture)
        if offset < 1 then
            _G.C_Timer.After(0, function(...)
                Base.SetTexture(texture, "arrowLeft")
            end)
        else
            texture:SetVertexOffset(1, 0, -offset)
            texture:SetVertexOffset(2, 0, offset)
        end
    end)
    Base.RegisterTexture("arrowRight", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetVertOffset(frame, texture)
        if offset < 1 then
            _G.C_Timer.After(0, function(...)
                Base.SetTexture(texture, "arrowRight")
            end)
        else
            texture:SetVertexOffset(3, 0, -offset)
            texture:SetVertexOffset(4, 0, offset)
        end
    end)
    Base.RegisterTexture("arrowUp", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetHorizOffset(frame, texture)
        if offset < 1 then
            _G.C_Timer.After(0, function(...)
                Base.SetTexture(texture, "arrowUp")
            end)
        else
            texture:SetVertexOffset(1, offset, 0)
            texture:SetVertexOffset(3, -offset, 0)
        end
    end)
    Base.RegisterTexture("arrowDown", function(frame, texture)
        texture = setup(frame, texture)

        local offset = GetHorizOffset(frame, texture)
        if offset < 1 then
            _G.C_Timer.After(0, function(...)
                Base.SetTexture(texture, "arrowDown")
            end)
        else
            texture:SetVertexOffset(2, offset, 0)
            texture:SetVertexOffset(4, -offset, 0)
        end
    end)
end

do -- gradients
    local min, max = 0.3, 0.7
    local hookedStatusBar, hookedBackdrop = {}, {}
    local function SetGradientMinMax(frame, texture, direction)
        if frame.SetStatusBarColor then
            local red, green, blue = frame:GetStatusBarColor()
            texture:SetGradient(direction, red * min, green * min, blue * min, red * max, green * max, blue * max)

            if not hookedStatusBar[frame] then
                _G.hooksecurefunc(frame, "SetStatusBarColor", function(self, r, g, b)
                    texture:SetGradient(direction, r * min, g * min, b * min, r * max, g * max, b * max)
                end)
                hookedStatusBar[frame] = true
            end
        elseif frame.SetBackdropColor and frame._auroraBackdrop then
            local red, green, blue = frame:GetBackdropColor()
            if red then
                texture:SetGradient(direction, red * min, green * min, blue * min, red * max, green * max, blue * max)
            end

            if not hookedBackdrop[frame] then
                _G.hooksecurefunc(frame, "SetBackdropColor", function(self)
                    local r, g, b = frame:GetBackdropColor()
                    texture:SetGradient(direction, r * min, g * min, b * min, r * max, g * max, b * max)
                end)
                hookedBackdrop[frame] = true
            end
        else
            texture:SetGradient(direction, min, min, min, max, max, max)
        end
    end
    local function SetGradientMaxMin(frame, texture, direction)
        if frame.SetStatusBarColor then
            local red, green, blue = frame:GetStatusBarColor()
            texture:SetGradient(direction, red * max, green * max, blue * max, red * min, green * min, blue * min)

            if not hookedStatusBar[frame] then
                _G.hooksecurefunc(frame, "SetStatusBarColor", function(self, r, g, b)
                    texture:SetGradient(direction, r * max, g * max, b * max, r * min, g * min, b * min)
                end)
                hookedStatusBar[frame] = true
            end
        elseif frame.SetBackdropColor and frame._auroraBackdrop then
            local red, green, blue = frame:GetBackdropColor()
            if red then
                texture:SetGradient(direction, red * max, green * max, blue * max, red * min, green * min, blue * min)
            end

            if not hookedBackdrop[frame] then
                _G.hooksecurefunc(frame, "SetBackdropColor", function(self, r, g, b)
                    texture:SetGradient(direction, r * max, g * max, b * max, r * min, g * min, b * min)
                end)
                hookedBackdrop[frame] = true
            end
        else
            texture:SetGradient(direction, max, max, max, min, min, min)
        end
    end

    Base.RegisterTexture("gradientUp", function(frame, texture)
        texture:SetColorTexture(1, 1, 1)
        SetGradientMinMax(frame, texture, "VERTICAL")
    end)
    Base.RegisterTexture("gradientDown", function(frame, texture)
        texture:SetColorTexture(1, 1, 1)
        SetGradientMaxMin(frame, texture, "VERTICAL")
    end)
    Base.RegisterTexture("gradientLeft", function(frame, texture)
        texture:SetColorTexture(1, 1, 1)
        SetGradientMaxMin(frame, texture, "HORIZONTAL")
    end)
    Base.RegisterTexture("gradientRight", function(frame, texture)
        texture:SetColorTexture(1, 1, 1)
        SetGradientMinMax(frame, texture, "HORIZONTAL")
    end)
end

do -- LFG Icons
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
    local roleTextures = {}
    for name, coords in next, map do
        Base.RegisterTexture("role"..name, function(frame, texture)
            if not roleTextures[texture] then
                local layer, subLevel = texture:GetDrawLayer()
                local border = frame:CreateTexture(nil, layer, nil, subLevel - 2)
                border:SetColorTexture(0, 0, 0)
                border:SetAllPoints(texture)
                texture._auroraBorder = border

                local bg = frame:CreateTexture(nil, layer, nil, subLevel - 1)
                bg:SetPoint("TOPLEFT", border, 1, -1)
                bg:SetPoint("BOTTOMRIGHT", border, -1, 1)
                texture._auroraBG = bg

                local mask = frame:CreateMaskTexture()
                mask:SetTexture([[Interface\CharacterFrame\TemporaryPortrait-Female-MagharOrc]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
                mask:SetAllPoints(texture)
                texture:AddMaskTexture(mask)

                roleTextures[texture] = true
            end

            texture:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-ROLES]])
            texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
            texture:SetBlendMode("ADD")

            texture._auroraBG:SetColorTexture(coords.color:GetRGB())
        end)
    end
end


--[[
Base.RegisterTexture("test", function(frame, texture)
    frame:SetSize(256, 256)

    for i = 1, 2 do
        local line = frame:CreateLine(nil, "BACKGROUND")
        line:SetColorTexture(1, 1, 1)
        line:SetThickness(10)
        line:Show(1)
        if i == 1 then
            line:SetStartPoint("TOPLEFT")
            line:SetEndPoint("BOTTOMRIGHT")
        else
            line:SetStartPoint("TOPRIGHT")
            line:SetEndPoint("BOTTOMLEFT")
        end
    end
end)

local snapshot = _G.UIParent:CreateTexture("$parentSnapshotTest", "BACKGROUND")
snapshot:SetPoint("CENTER")
snapshot:SetSize(64, 64)
Base.SetTexture(snapshot, "test")
Base.SetTexture(snapshot, "roleDAMAGER")
Base.SetTexture(snapshot, "gradientUp")
Base.SetTexture(snapshot, "arrowLeft")
Base.SetTexture(snapshot, "gradientLeft")
--local color = _G.RAID_CLASS_COLORS[private.charClass.token]
--snapshot:SetVertexColor(color.r, color.g, color.b)
]]
