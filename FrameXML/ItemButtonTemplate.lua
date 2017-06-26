local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.ItemButtonTemplate()
    function private.Skin.ItemButtonTemplate(itemButton)
        itemButton:SetNormalTexture("")
        itemButton:SetHighlightTexture("")
        itemButton:SetPushedTexture("")
        itemButton._auroraBG = F.ReskinIcon(itemButton.icon)
    end
    function private.Skin.LargeItemButtonTemplate(itemButton)
        local icon = itemButton.Icon
        itemButton._auroraBG = F.ReskinIcon(icon)

        local nameFrame = itemButton.NameFrame
        nameFrame:SetAlpha(0)

        local bg = _G.CreateFrame("Frame", nil, itemButton)
        bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 1)
        bg:SetPoint("BOTTOMRIGHT", -3, 1)
        F.CreateBD(bg, .2)
        itemButton._auroraNameBG = bg
    end
    function private.Skin.SmallItemButtonTemplate(itemButton)
        local icon = itemButton.Icon
        icon:SetSize(29, 29)
        itemButton._auroraBG = F.ReskinIcon(icon)

        local nameFrame = itemButton.NameFrame
        nameFrame:SetAlpha(0)

        local bg = _G.CreateFrame("Frame", nil, itemButton)
        bg:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 1)
        bg:SetPoint("BOTTOMRIGHT", nameFrame, 0, 0)
        F.CreateBD(bg, .2)
        itemButton._auroraNameBG = bg
    end


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
    function private.Hook.SetItemButtonQuality(button, quality, itemIDOrLink)
        if button._auroraBG then
            local isRelic = (itemIDOrLink and _G.IsArtifactRelicItem(itemIDOrLink))

            if quality then
                local color = _G.type(quality) == "table" and quality or _G.BAG_ITEM_QUALITY_COLORS[quality]
                if color and color == quality or quality >= _G.LE_ITEM_QUALITY_COMMON then
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
    end
    _G.hooksecurefunc("SetItemButtonQuality", private.Hook.SetItemButtonQuality)
end
