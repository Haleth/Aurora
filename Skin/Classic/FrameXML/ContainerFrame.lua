local _, private = ...
if not private.isClassic then return end

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
    function Skin.ContainerFrameItemButtonTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        ItemButton:SetBackdropColor(1, 1, 1, 0.75)
        ItemButton:SetBackdropOptions({
            bgFile = ItemButton._isKey and [[Interface\ContainerFrame\KeyRing-Bag-Icon]] or [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false
        })
        local bg = ItemButton:GetBackdropTexture("bg")
        bg:SetDesaturated(ItemButton._isKey)
        Base.CropIcon(bg)

        local name = ItemButton:GetName()
        ItemButton._questTexture = _G[name.."IconQuestTexture"]
        ItemButton._questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BORDER)
        Base.CropIcon(ItemButton._questTexture)
        Base.CropIcon(ItemButton.NewItemTexture)
        ItemButton.BattlepayItemTexture:SetTexCoord(0.203125, 0.78125, 0.203125, 0.78125)
        ItemButton.BattlepayItemTexture:SetAllPoints()
    end
    function Skin.ContainerFrameTemplate(Frame)
        Skin.FrameTypeFrame(Frame)
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
        moneyBG:SetPoint("BOTTOMLEFT", bg, 5, 5)
        moneyBG:SetPoint("TOPRIGHT", bg, "BOTTOMRIGHT", -5, 23)
        moneyFrame:SetPoint("BOTTOMRIGHT", moneyBG, 7, 3)

        Frame.PortraitButton:Hide()
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

    for i = 1, 12 do
        Skin.ContainerFrameTemplate(_G["ContainerFrame"..i])
    end
end
