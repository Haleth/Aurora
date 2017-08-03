local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base

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
        texture:SetVertexOffset(map.right[1], 0, -offset)
        texture:SetVertexOffset(map.right[2], 0, offset)
    end)
end

do -- gradients
    local min, max = 0.3, 0.7

    local function setup(frame)
        frame:SetSize(1024, 1024)

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
        {name = "GUIDE", 1, 1},
        {name = "HEALER", 2, 1},
        {name = "CHECK", 3, 1},
        {name = "TANK", 1, 2},
        {name = "DAMAGER", 2, 2},
        {name = "PROMPT", 3, 2},
        {name = "COVER", 1, 3},
        {name = "CROSS", 2, 3},
    }
    local size = 76
    for i = 1, #map do
        local info = map[i]
        Base.RegisterTexture("role"..info.name, function(frame)
            frame:SetSize(64, 64)

            local bg = frame:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints()
            bg:SetColorTexture(0, 0, 0)
            bg:Show()

            local icon = frame:CreateTexture(nil, "BORDER")
            icon:SetSize(size, size)
            icon:SetPoint("CENTER", 2, -1)
            icon:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-ROLES]])
            icon:SetTexCoord(_G.GetTexCoordsByGrid(info[1], info[2], 256, 256, 67, 67))
            icon:Show()

            local mask = frame:CreateMaskTexture(nil, "BORDER")
            mask:SetTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            mask:SetSize(size * 0.7, size * 0.7)
            mask:SetPoint("CENTER", icon, 0, 2)
            mask:Show()
            icon:AddMaskTexture(mask)
        end)
    end
end


--[[
Base.RegisterTexture("test", function(frame)
    frame:SetSize(256, 256)

    local line1 = frame:CreateLine()
    line1:SetThickness(5)
    line1:SetColorTexture(1, 1, 1)
    line1:SetStartPoint("TOPLEFT")
    line1:SetEndPoint("BOTTOMRIGHT")
    line1:Show()
end)

local snapshot = _G.UIParent:CreateTexture("$parentSnapshotTest", "BACKGROUND")
snapshot:SetPoint("CENTER")
snapshot:SetSize(16, 16)
Base.SetTexture(snapshot, "gradientLeft", true)
Base.SetTexture(snapshot, "roleDAMAGER", true)
Base.SetTexture(snapshot, "gradientUp", true)
Base.SetTexture(snapshot, "arrowLeft", true)
Base.SetTexture(snapshot, "gradientLeft", true)
--local color = _G.RAID_CLASS_COLORS[private.charClass.token]
--snapshot:SetVertexColor(color.r, color.g, color.b)
]]
