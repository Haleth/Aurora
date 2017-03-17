local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

-- A collection of themes too small for there own file
_G.tinsert(C.themes["Aurora"], function()
    local r, g, b = C.r, C.g, C.b

    --[[ FrameXML/UIParent.lua ]]--
    function private.SkinIconArray(baseName, rowSize, numRows)
        for i = 1, rowSize * numRows do
            local bu = _G[baseName..i]
            bu:SetCheckedTexture(C.media.checked)
            select(2, bu:GetRegions()):Hide()

            F.ReskinIcon(_G[baseName..i.."Icon"])
        end
    end
    _G.hooksecurefunc("BuildIconArray", function(parent, baseName, template, rowSize, numRows, onButtonCreated)
        -- This is used to create icons for the GuildBankPopupFrame, MacroPopupFrame, and GearManagerDialogPopup
        private.SkinIconArray(baseName, rowSize, numRows)
    end)

    --[[ FrameXML/AutoComplete.lua ]]--
    F.CreateBD(_G.AutoCompleteBox)

    _G.hooksecurefunc("AutoComplete_Update", function()
        if not _G.AutoCompleteBox._skinned then
            for i = 1, 5 do
                local btn = _G["AutoCompleteButton"..i]

                local hl = btn:GetHighlightTexture()
                hl:SetPoint("TOPLEFT", 1, 0)
                hl:SetPoint("BOTTOM", 0, 0)
                hl:SetPoint("RIGHT", _G.AutoCompleteBox, -1, 0)
                hl:SetColorTexture(r, g, b, .2)
            end
            _G.AutoCompleteBox._skinned = true
        end
    end)

    --[[ FrameXML/HelpFrame.lua ]]--
    F.CreateBD(_G.TicketStatusFrameButton)

    --[[ FrameXML/ItemButtonTemplate.lua ]]--
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
                    if C.is72 then
                        tex:SetVertexOffset(vertexInfo[2], vertexInfo[3], 0)
                    end
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
