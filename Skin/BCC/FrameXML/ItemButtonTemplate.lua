local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals tinsert

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ItemButtonTemplate.lua ]]
    function Hook.SetItemButtonQuality(button, quality, itemIDOrLink, suppressOverlays)
        local iconBorder = button._auroraIconBorder
        if iconBorder then
            if button.IconBorder then
                button.IconBorder:Hide()
            end

            local color = Color.black
            if quality and quality > private.Enum.ItemQuality.Poor then
                color = _G.BAG_ITEM_QUALITY_COLORS[quality]
            end

            if color then
                iconBorder:SetBackdropBorderColor(color.r, color.g, color.b)
            else
                iconBorder:SetBackdropBorderColor(0, 0, 0)
            end
        end
    end
end

do --[[ FrameXML\ItemButtonTemplate.xml ]]
    function Skin.FrameTypeItemButton(Button)
        Button.Count:SetPoint("BOTTOMRIGHT", -2, 2)

        Base.SetBackdrop(Button, Color.black, Color.frame.a)
        Button._auroraIconBorder = Button

        local bg = Button:GetBackdropTexture("bg")
        Base.CropIcon(Button.icon)
        Button.icon:SetPoint("TOPLEFT", bg, 1, -1)
        Button.icon:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        Button:SetNormalTexture("")
        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
    function Skin.SimplePopupButtonTemplate(CheckButton)
        local name, bg = CheckButton:GetRegions()
        name:ClearAllPoints()
        name:SetPoint("BOTTOMLEFT")
        name:SetPoint("BOTTOMRIGHT")
        bg:Hide()

        Base.CreateBackdrop(CheckButton, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = 1,
                right = 1,
                top = 1,
                bottom = 1,
            }
        })
        Base.CropIcon(CheckButton:GetBackdropTexture("bg"))
        CheckButton:SetBackdropColor(1, 1, 1, 0.75)
        CheckButton:SetBackdropBorderColor(Color.frame, 1)
    end
    function Skin.PopupButtonTemplate(CheckButton)
        Skin.SimplePopupButtonTemplate(CheckButton)

        local bg = CheckButton:GetBackdropTexture("bg")
        local icon = _G[CheckButton:GetName().."Icon"]
        icon:SetAllPoints()
        icon:SetPoint("TOPLEFT", bg, 1, -1)
        icon:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        Base.CropIcon(icon)

        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
    function Skin.LargeItemButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.black, Color.frame.a)
        Button:SetBackdropOption("offsets", {
            left = 0,
            right = 108,
            top = 0,
            bottom = 2,
        })
        Button._auroraIconBorder = Button

        local bg = Button:GetBackdropTexture("bg")
        Base.CropIcon(Button.Icon)
        Button.Icon:SetPoint("TOPLEFT", bg, 1, -1)
        Button.Icon:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        Button.NameFrame:SetAlpha(0)
        Button.NameFrame:SetTexture("")

        local nameBG = _G.CreateFrame("Frame", nil, Button)
        nameBG:SetFrameLevel(Button:GetFrameLevel())
        nameBG:SetPoint("TOPLEFT", bg, "TOPRIGHT", 1, 0)
        nameBG:SetPoint("RIGHT", -3, 0)
        nameBG:SetPoint("BOTTOM", bg)
        Base.SetBackdrop(nameBG, Color.frame)
        Button._auroraNameBG = nameBG
    end
    function Skin.SmallItemButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.black, Color.frame.a)
        Button:SetBackdropOption("offsets", {
            left = 0,
            right = 104,
            top = 0,
            bottom = 0,
        })
        Button._auroraIconBorder = Button

        local bg = Button:GetBackdropTexture("bg")
        Base.CropIcon(Button.Icon)
        Button.Icon:SetPoint("TOPLEFT", bg, 1, -1)
        Button.Icon:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        Button.NameFrame:SetAlpha(0)

        local nameBG = _G.CreateFrame("Frame", nil, Button)
        nameBG:SetFrameLevel(Button:GetFrameLevel())
        nameBG:SetPoint("TOPLEFT", bg, "TOPRIGHT", 1, 0)
        nameBG:SetPoint("RIGHT", -3, 0)
        nameBG:SetPoint("BOTTOM", bg)
        Base.SetBackdrop(nameBG, Color.frame)
        Button._auroraNameBG = nameBG
    end
end

function private.FrameXML.ItemButtonTemplate()
    _G.hooksecurefunc("SetItemButtonQuality", Hook.SetItemButtonQuality)
end
