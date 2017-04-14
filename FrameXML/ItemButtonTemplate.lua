local _, private = ...

-- [[ Core ]]
local _, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    local size = 6
    local vertexOffsets = {
        {"TOPLEFT", 4, -size},
        {"BOTTOMLEFT", 3, -size},
        {"TOPRIGHT", 2, size},
        {"BOTTOMRIGHT", 1, size},
    }
    local function SetRelic(button, isRelic, color)
        if isRelic then
            if not button._auroraRelicTex then
                local relic = _G.CreateFrame("Frame", nil, button)
                relic:SetAllPoints()

                for i = 1, 4 do
                    local tex = relic:CreateTexture("OVERLAY")
                    tex:SetSize(size, size)

                    local vertexInfo = vertexOffsets[i]
                    tex:SetPoint(vertexInfo[1])
                    tex:SetVertexOffset(vertexInfo[2], vertexInfo[3], 0)
                    relic[i] = tex
                end

                button._auroraRelicTex = relic
            end

            for i = 1, #button._auroraRelicTex do
                local tex = button._auroraRelicTex[i]
                tex:SetColorTexture(color.r, color.g, color.b)
            end
            button._auroraRelicTex:Show()
        elseif button._auroraRelicTex then
            button._auroraRelicTex:Hide()
        end
    end
    _G.hooksecurefunc("SetItemButtonQuality", function(button, quality, itemIDOrLink)
        if button._auroraBG then
            local isRelic = (itemIDOrLink and _G.IsArtifactRelicItem(itemIDOrLink))

            if quality then
                local color = _G.BAG_ITEM_QUALITY_COLORS[quality]
                if quality >= _G.LE_ITEM_QUALITY_COMMON and color then
                    SetRelic(button, isRelic, color)
                    button._auroraBG:SetBackdropBorderColor(color.r, color.g, color.b)
                    button.IconBorder:Hide()
                else
                    SetRelic(button, false)
                    button._auroraBG:SetBackdropBorderColor(0, 0, 0)
                end
            else
                SetRelic(button, false)
                button._auroraBG:SetBackdropBorderColor(0, 0, 0)
            end
        end
    end)
end)
