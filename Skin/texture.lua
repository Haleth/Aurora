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
Base.SetTexture(snapshot, "lfgIcons", true)
Base.SetTexture(snapshot, "gradientUp", true)
Base.SetTexture(snapshot, "arrowLeft", true)
Base.SetTexture(snapshot, "gradientLeft", true)
--local color = _G.RAID_CLASS_COLORS[private.charClass.token]
--snapshot:SetVertexColor(color.r, color.g, color.b)
]]
