local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals tinsert

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ItemButtonTemplate.lua ]]
    local size = 8
    local function CreateOverlay(Button)
        local iconBorder = Button._auroraIconBorder

        local iconOverlay = _G.CreateFrame("Frame", nil, iconBorder)
        iconOverlay:SetFrameLevel(iconBorder:GetFrameLevel())
        iconOverlay:SetAllPoints()
        iconOverlay:Hide()

        for i = 1, 4 do
            local tex = iconOverlay:CreateTexture(nil, "OVERLAY")
            tex:SetTexture([[Interface\Buttons\WHITE8x8]])
            tex:SetSize(size, size)
            tinsert(iconOverlay, tex)
        end
        iconOverlay[1]:SetPoint("TOPLEFT")
        iconOverlay[2]:SetPoint("BOTTOMLEFT")
        iconOverlay[3]:SetPoint("TOPRIGHT")
        iconOverlay[4]:SetPoint("BOTTOMRIGHT")

        function iconOverlay:SetColor(r, g, b)
            for i = 1, #self do
                self[i]:SetVertexColor(r, g, b)
            end
        end

        local function Reset(texture)
            texture:SetVertexOffset(1, 0, 0)
            texture:SetVertexOffset(2, 0, 0)
            texture:SetVertexOffset(3, 0, 0)
            texture:SetVertexOffset(4, 0, 0)
            texture:Show()
        end
        function iconOverlay:SetVisual(visType)
            for i = 1, #self do
                Reset(self[i])
            end

            if visType == "corner" then
                local offset = 6
                self[1]:SetVertexOffset(2, 0, -offset)
                self[1]:SetVertexOffset(3, offset, 0)
                self[1]:SetVertexOffset(4, -offset, offset)

                self[2]:Hide()
                self[3]:Hide()
                self[4]:Hide()
            elseif visType == "socket" then
                local offset = 3
                self[1]:SetVertexOffset(2, 0, offset)
                self[1]:SetVertexOffset(3, -offset, 0)

                self[2]:SetVertexOffset(1, 0, -offset)
                self[2]:SetVertexOffset(4, -offset, 0)

                self[3]:SetVertexOffset(1, offset, 0)
                self[3]:SetVertexOffset(4, 0, offset)

                self[4]:SetVertexOffset(2, offset, 0)
                self[4]:SetVertexOffset(3, 0, -offset)
            elseif visType == "bracket" then
                local offset = 2

                self[1]:SetVertexOffset(2, 0, -offset)
                self[1]:SetVertexOffset(3, offset, 0)
                self[1]:SetVertexOffset(4, -offset, offset)

                self[2]:SetVertexOffset(1, 0, offset)
                self[2]:SetVertexOffset(3, -offset, -offset)
                self[2]:SetVertexOffset(4, offset, 0)

                self[3]:SetVertexOffset(1, -offset, 0)
                self[3]:SetVertexOffset(2, offset, offset)
                self[3]:SetVertexOffset(4, 0, -offset)

                self[4]:SetVertexOffset(1, offset, -offset)
                self[4]:SetVertexOffset(2, -offset, 0)
                self[4]:SetVertexOffset(3, 0, offset)
            end
        end

        Button._auroraIconOverlay = iconOverlay
        return iconOverlay
    end
    function Hook.SetItemButtonQuality(button, quality, itemIDOrLink, suppressOverlays)
        local iconBorder = button._auroraIconBorder
        if iconBorder then
            if button.IconBorder then
                button.IconBorder:Hide()
            end

            local iconOverlay = button._auroraIconOverlay
            if button.IconOverlay then
                if not iconOverlay then
                    iconOverlay = CreateOverlay(button)
                end

                button.IconOverlay:Hide()
                iconOverlay:Hide()
            end

            local overlay, overlay2, visual, isRelic
            if itemIDOrLink then
                if not suppressOverlays then
                    if _G.C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemIDOrLink) then
                        overlay = private.AZERITE_COLORS[1]
                        overlay2 = private.AZERITE_COLORS[2]
                        visual = "bracket"
                    elseif private.isPatch and _G.IsCorruptedItem(itemIDOrLink) then
                        overlay = Color.orange
                        overlay2 = _G.CORRUPTION_COLOR
                        visual = "corner"
                    end
                end
                isRelic = _G.IsArtifactRelicItem(itemIDOrLink)
            end

            local color
            if quality and quality > _G.LE_ITEM_QUALITY_POOR then
                color = _G.BAG_ITEM_QUALITY_COLORS[quality]
            end

            if overlay then
                if overlay2 then
                    local r1, g1, b1 = overlay:GetRGB()
                    local r2, g2, b2 = overlay2:GetRGB()

                    local bd = iconBorder._auroraBackdrop
                    if visual == "corner" then
                        bd.tl:SetVertexColor(r1, g1, b1)
                        bd.t:SetGradient("HORIZONTAL", r1, g1, b1, r2, g2, b2)
                        bd.tr:SetVertexColor(r2, g2, b2)
                        iconOverlay[1]:SetGradient("VERTICAL", r2, g2, b2, r1, g1, b1)

                        bd.l:SetGradient("VERTICAL", r2, g2, b2, r1, g1, b1)
                        bd.r:SetVertexColor(r2, g2, b2)
                    else
                        bd.tl:SetVertexColor(r1, g1, b1)
                        bd.t:SetVertexColor(r1, g1, b1)
                        bd.tr:SetVertexColor(r1, g1, b1)
                        iconOverlay[1]:SetGradient("VERTICAL", r2, g2, b2, r1, g1, b1)
                        iconOverlay[3]:SetGradient("VERTICAL", r2, g2, b2, r1, g1, b1)

                        bd.l:SetGradient("VERTICAL", r2, g2, b2, r1, g1, b1)
                        bd.r:SetGradient("VERTICAL", r2, g2, b2, r1, g1, b1)
                    end


                    bd.bl:SetVertexColor(r2, g2, b2)
                    bd.b:SetVertexColor(r2, g2, b2)
                    bd.br:SetVertexColor(r2, g2, b2)
                    iconOverlay[2]:SetGradient("VERTICAL", r2, g2, b2, r1, g1, b1)
                    iconOverlay[4]:SetGradient("VERTICAL", r2, g2, b2, r1, g1, b1)
                else
                    iconOverlay:SetColor(overlay:GetRGB())
                    iconBorder:SetBackdropBorderColor(overlay:GetRGB())
                end

                iconOverlay:Show()
                iconOverlay:SetVisual(visual)
            else
                if color then
                    if isRelic then
                        iconOverlay:SetColor(color:GetRGB())
                        iconOverlay:SetVisual("socket")
                        iconOverlay:Show()
                    end

                    iconBorder:SetBackdropBorderColor(color:GetRGB())
                else
                    iconBorder:SetBackdropBorderColor(0, 0, 0)
                end
            end
        end
    end
end

do --[[ FrameXML\ItemButtonTemplate.xml ]]
    function Skin.FrameTypeItemButton(Button)
        Base.CropIcon(Button.icon)

        Button.Count:SetPoint("BOTTOMRIGHT", -2, 2)

        Base.SetBackdrop(Button, Color.black, Color.frame.a)
        Button:SetBackdropOption("offsets", {
            left = -1,
            right = -1,
            top = -1,
            bottom = -1,
        })
        Button._auroraIconBorder = Button

        Button.ItemContextOverlay:SetPoint("TOPLEFT", -1, 1)
        Button.ItemContextOverlay:SetPoint("BOTTOMRIGHT", 1, -1)

        Button:SetNormalTexture("")
        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
    function Skin.CircularGiantItemButtonTemplate(Button)
        Base.CropIcon(Button.Icon)

        Base.SetBackdrop(Button, Color.black, Color.frame.a)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        })
        Button._auroraIconBorder = Button

        Button.CircleMask:Hide()
    end
    function Skin.GiantItemButtonTemplate(Button)
        Button.EmptyBackground:Hide()

        Base.CropIcon(Button.Icon)
        Base.CreateBackdrop(Button, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = 3,
                right = 4,
                top = 4,
                bottom = 3,
            }
        })
        Base.CropIcon(Button:GetBackdropTexture("bg"))
        Base.SetBackdrop(Button, Color.black, Color.frame.a)
        Button._auroraIconBorder = Button

        Button:SetBackdropColor(1, 1, 1, 0.75)
        Button:SetBackdropBorderColor(Color.frame, 1)

        Button.IconMask:Hide()

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
