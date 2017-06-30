local _, private = ...

-- [[ Lua Globals ]]
local next, tinsert = _G.next, _G.tinsert

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.SharedXML.SharedUIPanelTemplates()
    local r, g, b = C.r, C.g, C.b

    local function colourArrow(f)
        if f:IsEnabled() then
            for _, pixel in next, f.pixels do
                pixel:SetColorTexture(r, g, b)
            end
        end
    end

    local function clearArrow(f)
        for _, pixel in next, f.pixels do
            pixel:SetColorTexture(1, 1, 1)
        end
    end

    function private.Skin.MaximizeMinimizeButtonFrameTemplate(frame)
        for _, name in next, {"MaximizeButton", "MinimizeButton"} do
            local button = frame[name]
            button:SetSize(17, 17)
            button:ClearAllPoints()
            button:SetPoint("CENTER")
            F.Reskin(button)

            button.pixels = {}

            local lineOfs = 2.5
            local line = button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(0.5)
            line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
            line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
            tinsert(button.pixels, line)

            local hline = button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(7, 1)
            tinsert(button.pixels, hline)

            local vline = button:CreateTexture()
            vline:SetColorTexture(1, 1, 1)
            vline:SetSize(1, 7)
            tinsert(button.pixels, vline)

            if name == "MaximizeButton" then
                hline:SetPoint("TOP", 1, -4)
                vline:SetPoint("RIGHT", -4, 1)
            else
                hline:SetPoint("BOTTOM", -1, 4)
                vline:SetPoint("LEFT", 4, -1)
            end

            button:SetScript("OnEnter", colourArrow)
            button:SetScript("OnLeave", clearArrow)
        end
    end
end
