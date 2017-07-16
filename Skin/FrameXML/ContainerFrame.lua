local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.ContainerFrame()
    if not _G.AuroraConfig.bags then return end

    local BAG_FILTER_ICONS = {
        ["bags-icon-equipment"] = [[Interface\Icons\INV_Chest_Chain]],
        ["bags-icon-consumables"] = [[Interface\Icons\INV_Potion_93]],
        ["bags-icon-tradegoods"] = [[Interface\Icons\INV_Fabric_Silk_02]],
    }

    local containerTextures = {
        "BackgroundTop",
        "BackgroundMiddle1",
        "BackgroundMiddle2",
        "BackgroundBottom",
        "Background1Slot",
    }

    for i = 1, 12 do
        local frameName = "ContainerFrame"..i
        local container = _G[frameName]
        local name = _G[frameName.."Name"]

        container.Portrait:Hide()
        for j = 1, #containerTextures do
            _G[frameName..containerTextures[j]]:SetAlpha(0)
        end

        name:ClearAllPoints()
        name:SetPoint("TOP", 0, -10)

        container.PortraitButton:Hide()
        container.FilterIcon:ClearAllPoints()
        container.FilterIcon:SetPoint("TOPLEFT", 11, -7)
        container.FilterIcon:SetSize(17, 17)
        container.FilterIcon.Icon:SetAllPoints()
        F.ReskinIcon(container.FilterIcon.Icon)
        _G.hooksecurefunc(container.FilterIcon.Icon, "SetAtlas", function(self, atlas)
            self:SetTexture(BAG_FILTER_ICONS[atlas])
        end)

        for k = 1, _G.MAX_CONTAINER_ITEMS do
            local item = "ContainerFrame"..i.."Item"..k
            local button = _G[item]
            local searchOverlay = button.searchOverlay
            local questTexture = _G[item.."IconQuestTexture"]
            local newItemTexture = button.NewItemTexture

            questTexture:SetTexCoord(.08, .92, .08, .92)

            button:SetNormalTexture("")
            button:SetPushedTexture("")
            button:SetHighlightTexture("")

            F.ReskinIcon(button.icon)
            button.icon:SetTexCoord(.08, .92, .08, .92)
            button._auroraIconBorder = F.CreateBDFrame(button, 0)

            -- easiest way to 'hide' it without breaking stuff
            newItemTexture:SetDrawLayer("BACKGROUND")
            newItemTexture:SetSize(1, 1)

            searchOverlay:SetPoint("TOPLEFT", -1, 1)
            searchOverlay:SetPoint("BOTTOMRIGHT", 1, -1)
        end

        local f = _G.CreateFrame("Frame", nil, container)
        f:SetPoint("TOPLEFT", 8, -4)
        f:SetPoint("BOTTOMRIGHT", -4, 3)
        f:SetFrameLevel(container:GetFrameLevel()-1)
        F.CreateBD(f)

        F.ReskinClose(_G[frameName.."CloseButton"])
    end

    _G.hooksecurefunc("ContainerFrame_Update", function(frame)
        local id = frame:GetID()
        local name = frame:GetName()

        if id == 0 then
            _G.BagItemSearchBox:ClearAllPoints()
            _G.BagItemSearchBox:SetPoint("TOPLEFT", frame, 18, -35)
            _G.BagItemAutoSortButton:ClearAllPoints()
            _G.BagItemAutoSortButton:SetPoint("TOPRIGHT", frame, -16, -31)
        end

        for i = 1, frame.size do
            local itemButton = _G[name.."Item"..i]

            local questTexture = _G[name.."Item"..i.."IconQuestTexture"]
            if questTexture:IsShown() then
                itemButton._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
            end
        end
    end)

    F.ReskinInput(_G.BagItemSearchBox)
    _G.BagItemSearchBox:SetWidth(120)

    _G.BagItemAutoSortButton:SetSize(26, 26)
    _G.BagItemAutoSortButton:SetNormalTexture([[Interface\Icons\INV_Pet_Broom]])
    _G.BagItemAutoSortButton:GetNormalTexture():SetTexCoord(.13, .92, .13, .92)

    _G.BagItemAutoSortButton:SetPushedTexture([[Interface\Icons\INV_Pet_Broom]])
    _G.BagItemAutoSortButton:GetPushedTexture():SetTexCoord(.08, .87, .08, .87)
    F.CreateBG(_G.BagItemAutoSortButton)
end
