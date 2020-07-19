local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

local keyColor = Color.Create(0.7254, 0.5490, 0.2235, 0.75)
do --[[ FrameXML\ContainerFrame.lua ]]
    local BAG_FILTER_ICONS = {
        ["bags-icon-equipment"] = [[Interface\Icons\INV_Chest_Chain]],
        ["bags-icon-consumables"] = [[Interface\Icons\INV_Potion_93]],
        ["bags-icon-tradegoods"] = [[Interface\Icons\INV_Fabric_Silk_02]],
    }
    function Hook.ContainerFrameFilterIcon_SetAtlas(self, atlas)
        self:SetTexture(BAG_FILTER_ICONS[atlas])
    end
    function Hook.ContainerFrame_GenerateFrame(frame, size, id)
        if id > _G.NUM_BAG_FRAMES then
            -- bank bags
            local _, _, _, a = frame:GetBackdropColor()
            Base.SetBackdropColor(frame, Color.grayLight, a)
        elseif id == _G.KEYRING_CONTAINER then
            -- key ring
            local _, _, _, a = frame:GetBackdropColor()
            Base.SetBackdropColor(frame, keyColor, a)
        end
    end
    function Hook.ContainerFrame_Update(self)
        local bagID = self:GetID()
        local name = self:GetName()

        if private.isRetail and bagID == 0 then
            _G.BagItemSearchBox:ClearAllPoints()
            _G.BagItemSearchBox:SetPoint("TOPLEFT", self, 20, -35)
            _G.BagItemAutoSortButton:ClearAllPoints()
            _G.BagItemAutoSortButton:SetPoint("TOPRIGHT", self, -16, -31)
        end

        for i = 1, self.size do
            local itemButton = _G[name.."Item"..i]
            local slotID = itemButton:GetID()
            local _, _, _, quality, _, _, link = _G.GetContainerItemInfo(bagID, slotID)

            if not itemButton._auroraIconBorder then
                itemButton._isKey = bagID == _G.KEYRING_CONTAINER
                Skin.ContainerFrameItemButtonTemplate(itemButton)

                Hook.SetItemButtonQuality(itemButton, quality, link)
            end

            if link then
                local _, _, _, _, _, _, _, _, _, _, _, itemClassID = _G.GetItemInfo(link)
                if itemClassID == _G.LE_ITEM_CLASS_QUESTITEM then
                    itemButton._questTexture:Show()
                    itemButton._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
                end
            end
        end
    end
end

do --[[ FrameXML\ContainerFrame.xml ]]
    function Skin.ContainerFrameHelpBoxTemplate(Frame)
        Skin.GlowBoxFrame(Frame, "Right")
    end

    function Skin.ContainerFrameItemButtonTemplate(ItemButton)
        local name = ItemButton:GetName()

        Base.CreateBackdrop(ItemButton, {
            bgFile = ItemButton._isKey and [[Interface\ContainerFrame\KeyRing-Bag-Icon]] or [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false
        })
        Skin.FrameTypeItemButton(ItemButton)
        local bg = ItemButton:GetBackdropTexture("bg")
        Base.CropIcon(bg)

        if ItemButton._isKey then
            bg:SetDesaturated(true)
            ItemButton:SetBackdropColor(keyColor:GetRGBA())
        else
            ItemButton:SetBackdropColor(1, 1, 1, 0.75)
        end

        ItemButton._questTexture = _G[name.."IconQuestTexture"]
        if private.isClassic then
            ItemButton._questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BORDER)
        end
        Base.CropIcon(ItemButton._questTexture)
        Base.CropIcon(ItemButton.NewItemTexture)
        ItemButton.BattlepayItemTexture:SetTexCoord(0.203125, 0.78125, 0.203125, 0.78125)
        ItemButton.BattlepayItemTexture:SetAllPoints()
    end
    function Skin.ContainerFrameTemplate(Frame)
        if private.isRetail then
            _G.hooksecurefunc(Frame.FilterIcon.Icon, "SetAtlas", Hook.ContainerFrameFilterIcon_SetAtlas)
        end

        Base.SetBackdrop(Frame)
        Frame:SetBackdropOption("offsets", {
            left = 11,
            right = 6,
            top = 0,
            bottom = 3,
        })

        local name = Frame:GetName()
        Frame.Portrait:Hide()
        _G[name.."BackgroundTop"]:SetAlpha(0)
        _G[name.."BackgroundMiddle1"]:SetAlpha(0)
        _G[name.."BackgroundMiddle2"]:SetAlpha(0)
        _G[name.."BackgroundBottom"]:SetAlpha(0)
        _G[name.."Background1Slot"]:SetAlpha(0)

        local nameText = _G[name.."Name"]
        nameText:ClearAllPoints()
        nameText:SetPoint("TOPLEFT", Frame.ClickableTitleFrame, 19, 0)
        nameText:SetPoint("BOTTOMRIGHT", Frame.ClickableTitleFrame, -19, 0)

        local bg = Frame:GetBackdropTexture("bg")
        local moneyBG = _G.CreateFrame("Frame", nil, _G[name.."MoneyFrame"])
        Base.SetBackdrop(moneyBG, Color.frame)
        moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
        local moneyFrame = _G[name.."MoneyFrame"]
        if private.isRetail then
            moneyBG:SetPoint("TOP", moneyFrame, 0, 2)
            moneyBG:SetPoint("BOTTOM", moneyFrame, 0, -2)
            moneyBG:SetPoint("LEFT", bg, 3, 0)
            moneyBG:SetPoint("RIGHT", bg, -3, 0)
        else
            moneyBG:SetPoint("BOTTOMLEFT", bg, 5, 5)
            moneyBG:SetPoint("TOPRIGHT", bg, "BOTTOMRIGHT", -5, 23)
            moneyFrame:SetPoint("BOTTOMRIGHT", moneyBG, 7, 3)
        end

        Frame.PortraitButton:Hide()
        if private.isRetail then
            Frame.FilterIcon:ClearAllPoints()
            Frame.FilterIcon:SetPoint("TOPLEFT", bg, 5, -5)
            Frame.FilterIcon:SetSize(17, 17)
            Frame.FilterIcon.Icon:SetAllPoints()

            Base.CropIcon(Frame.FilterIcon.Icon, Frame.FilterIcon)

            if not private.isPatch then -- ExtraBagSlotsHelpBox
                -- BlizzWTF: Why not just use GlowBoxArrowTemplate?
                local HelpBox = Frame.ExtraBagSlotsHelpBox

                local Arrow = _G.CreateFrame("Frame", nil, HelpBox)
                Arrow.Arrow = HelpBox.Arrow
                Arrow.Arrow:SetParent(Arrow)
                Arrow.Glow = HelpBox.ArrowGlow
                Arrow.Glow:SetParent(Arrow)
                HelpBox.Arrow = Arrow

                Skin.GlowBoxFrame(HelpBox, "Right")
            end
        end
        Skin.UIPanelCloseButton(_G[name.."CloseButton"])
        _G[name.."CloseButton"]:SetPoint("TOPRIGHT", bg, 6, 5)

        Frame.ClickableTitleFrame:ClearAllPoints()
        Frame.ClickableTitleFrame:SetPoint("TOPLEFT", bg)
        Frame.ClickableTitleFrame:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end
end

function private.FrameXML.ContainerFrame()
    if private.disabled.bags then return end
    _G.hooksecurefunc("ContainerFrame_GenerateFrame", Hook.ContainerFrame_GenerateFrame)
    _G.hooksecurefunc("ContainerFrame_Update", Hook.ContainerFrame_Update)

    if not private.isPatch then
        Skin.ContainerFrameHelpBoxTemplate(_G.ArtifactRelicHelpBox)
        Skin.ContainerFrameHelpBoxTemplate(_G.AzeriteItemInBagHelpBox)
    end

    for i = 1, 12 do
        Skin.ContainerFrameTemplate(_G["ContainerFrame"..i])
    end

    if private.isRetail then
        Skin.BagSearchBoxTemplate(_G.BagItemSearchBox)
        _G.BagItemSearchBox:SetWidth(120)

        local autoSort = _G.BagItemAutoSortButton
        autoSort:SetSize(26, 26)
        autoSort:SetNormalTexture([[Interface\Icons\INV_Pet_Broom]])
        autoSort:GetNormalTexture():SetTexCoord(.13, .92, .13, .92)

        autoSort:SetPushedTexture([[Interface\Icons\INV_Pet_Broom]])
        autoSort:GetPushedTexture():SetTexCoord(.08, .87, .08, .87)

        local iconBorder = autoSort:CreateTexture(nil, "BACKGROUND")
        iconBorder:SetPoint("TOPLEFT", autoSort, -1, 1)
        iconBorder:SetPoint("BOTTOMRIGHT", autoSort, 1, -1)
        iconBorder:SetColorTexture(0, 0, 0)
    end

    if not private.isPatch then
        Skin.GlowBoxFrame(_G.BagHelpBox, "Right")
    end
end
