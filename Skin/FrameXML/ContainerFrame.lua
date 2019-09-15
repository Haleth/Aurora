local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ContainerFrame.lua ]]
    function Hook.ContainerFrame_GenerateFrame(frame, size, id)
        if id > _G.NUM_BAG_FRAMES then
            -- bank bags
            local _, _, _, a = frame:GetBackdropColor()
            Base.SetBackdropColor(frame, Color.button, a)
        end
    end
    function Hook.ContainerFrame_Update(self)
        local name = self:GetName()

        for i = 1, self.size do
            local itemButton = _G[name.."Item"..i]
            if not itemButton._auroraIconBorder then
                local container = itemButton:GetParent():GetID()
                local buttonID = itemButton:GetID()

                Skin.ContainerFrameItemButtonTemplate(itemButton)

                local _, _, _, quality, _, _, _, _, _, itemID = _G.GetContainerItemInfo(container, buttonID)
                Hook.SetItemButtonQuality(itemButton, quality, itemID)
            end

            local questTexture = _G[name.."Item"..i.."IconQuestTexture"]
            if questTexture:IsShown() then
                itemButton._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
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

        Skin.FrameTypeItemButton(ItemButton)
        local bd = ItemButton._auroraIconBorder:GetBackdropTexture("bg")
        bd:SetTexture([[Interface\PaperDoll\UI-Backpack-EmptySlot]])
        bd:SetVertexColor(1, 1, 1, 0.75)
        Base.CropIcon(bd)
        Base.CropIcon(_G[name.."IconQuestTexture"])
        Base.CropIcon(ItemButton.NewItemTexture)
    end
    function Skin.ContainerFrameTemplate(Frame)
        Base.SetBackdrop(Frame)
        local bg = Frame:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 11, 0)
        bg:SetPoint("BOTTOMRIGHT", -6, 3)

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


        local moneyFrame = _G[name.."MoneyFrame"]
        local moneyBG = _G.CreateFrame("Frame", nil, _G[name.."MoneyFrame"])
        Base.SetBackdrop(moneyBG, Color.frame)
        moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
        moneyBG:SetPoint("TOP", moneyFrame, 0, 2)
        moneyBG:SetPoint("BOTTOM", moneyFrame, 0, -2)
        moneyBG:SetPoint("LEFT", bg, 3, 0)
        moneyBG:SetPoint("RIGHT", bg, -3, 0)

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

    Skin.GlowBoxFrame(_G.BagHelpBox, "Right")
end
