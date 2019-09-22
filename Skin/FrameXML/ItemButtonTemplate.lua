local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ItemButtonTemplate.lua ]]
    function Hook.SetItemButtonQuality(button, quality, itemIDOrLink)
        if button._auroraIconBorder then
            if quality then
                local color = _G.type(quality) == "table" and quality or _G.BAG_ITEM_QUALITY_COLORS[quality]
                if color and color == quality or quality >= _G.LE_ITEM_QUALITY_COMMON then
                    button._auroraIconBorder:SetBackdropBorderColor(color.r, color.g, color.b)
                    button.IconBorder:Hide()
                else
                    button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
                end
            else
                button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
            end
        end
    end
end

do --[[ FrameXML\ItemButtonTemplate.xml ]]
    function Skin.AltItemButton(Button)
        local name = Button:GetName()
        Base.CropIcon(_G[name.."IconTexture"])

        local bg = _G.CreateFrame("Frame", nil, Button)
        bg:SetFrameLevel(Button:GetFrameLevel())
        bg:SetPoint("TOPLEFT", -1, 1)
        bg:SetPoint("BOTTOMRIGHT", 1, -1)
        Base.SetBackdrop(bg, Color.black, 0.3)
        Button._auroraIconBorder = bg

        Button:SetNormalTexture("")
        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
    function Skin.FrameTypeItemButton(Button)
        Base.CropIcon(Button.icon)

        Button.Count:SetPoint("BOTTOMRIGHT", -2, 2)

        local bg = _G.CreateFrame("Frame", nil, Button)
        bg:SetFrameLevel(Button:GetFrameLevel())
        bg:SetPoint("TOPLEFT", -1, 1)
        bg:SetPoint("BOTTOMRIGHT", 1, -1)
        Base.SetBackdrop(bg, Color.black, 0.3)
        Button._auroraIconBorder = bg

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

        local bd = _G.CreateFrame("Frame", nil, CheckButton)
        bd:SetFrameLevel(CheckButton:GetFrameLevel())
        bd:SetPoint("TOPLEFT", -1, 1)
        bd:SetPoint("BOTTOMRIGHT", 1, -1)

        Base.CreateBackdrop(bd, {
            edgeSize = 1,
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        })
        Base.CropIcon(bd:GetBackdropTexture("bg"))
        bd:SetBackdropColor(1, 1, 1, 0.75)
        bd:SetBackdropBorderColor(Color.frame, 1)
    end
    function Skin.PopupButtonTemplate(CheckButton)
        Skin.SimplePopupButtonTemplate(CheckButton)

        local icon = _G[CheckButton:GetName().."Icon"]
        icon:SetAllPoints()
        Base.CropIcon(icon)

        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
    function Skin.LargeItemButtonTemplate(Button)
        Base.CropIcon(Button.Icon)

        local iconBG = _G.CreateFrame("Frame", nil, Button)
        iconBG:SetFrameLevel(Button:GetFrameLevel())
        iconBG:SetPoint("TOPLEFT", Button.Icon, -1, 1)
        iconBG:SetPoint("BOTTOMRIGHT", Button.Icon, 1, -1)
        Base.SetBackdrop(iconBG, Color.frame)
        Button._auroraIconBorder = iconBG

        Button.NameFrame:SetAlpha(0)

        local nameBG = _G.CreateFrame("Frame", nil, Button)
        nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 1, 0)
        nameBG:SetPoint("BOTTOMRIGHT", -3, 1)
        Base.SetBackdrop(nameBG, Color.frame)
        Button._auroraNameBG = nameBG
    end
    function Skin.SmallItemButtonTemplate(Button)
        Button.Icon:SetSize(29, 29)
        Base.CropIcon(Button.Icon)

        local iconBG = _G.CreateFrame("Frame", nil, Button)
        iconBG:SetFrameLevel(Button:GetFrameLevel())
        iconBG:SetPoint("TOPLEFT", Button.Icon, -1, 1)
        iconBG:SetPoint("BOTTOMRIGHT", Button.Icon, 1, -1)
        Base.SetBackdrop(iconBG, Color.frame)
        Button._auroraIconBorder = iconBG

        Button.NameFrame:SetAlpha(0)

        local nameBG = _G.CreateFrame("Frame", nil, Button)
        nameBG:SetPoint("TOPLEFT", iconBG, "TOPRIGHT", 1, 0)
        nameBG:SetPoint("BOTTOMRIGHT", Button.NameFrame, 0, -1)
        Base.SetBackdrop(nameBG, Color.frame)
        Button._auroraNameBG = nameBG
    end
end

function private.FrameXML.ItemButtonTemplate()
    _G.hooksecurefunc("SetItemButtonQuality", Hook.SetItemButtonQuality)
end
