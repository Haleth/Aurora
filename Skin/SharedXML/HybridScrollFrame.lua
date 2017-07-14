local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local F = _G.unpack(Aurora)
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ SharedXML\HybridScrollFrame.lua ]]
    function Hook.HybridScrollFrame_CreateButtons(self, buttonTemplate, initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)
        --print("Hook.HybridScrollFrame_CreateButtons", buttonTemplate)
        if Skin[buttonTemplate] then
            local numButtons = #self.buttons
            local numSkinned = self._auroraNumSkinned or 0

            for i = numSkinned + 1, numButtons do
                Skin[buttonTemplate](self.buttons[i])
            end
            self._auroraNumSkinned = numButtons
        end
    end
end

do --[[ SharedXML\HybridScrollFrame.xml ]]
    function Skin.HybridScrollBarTemplate(slider)
        local name = slider:GetName()

        local parent = slider:GetParent()
        slider:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, -17)
        slider:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 0, 17)

        slider.trackBG:Hide()

        slider.ScrollBarTop:Hide()
        slider.ScrollBarMiddle:Hide()
        slider.ScrollBarBottom:Hide()

        local upButton = _G[name.."ScrollUpButton"]
        upButton:SetPoint("BOTTOM", slider, "TOP")
        Skin.UIPanelScrollUpButtonTemplate(upButton)

        local downButton = _G[name.."ScrollDownButton"]
        downButton:SetPoint("TOP", slider, "BOTTOM")
        Skin.UIPanelScrollDownButtonTemplate(downButton)

        local thumb = slider.thumbTexture
        thumb:SetAlpha(0)
        thumb:SetWidth(17)

        thumb.bg = _G.CreateFrame("Frame", nil, slider)
        thumb.bg:SetPoint("TOPLEFT", thumb, 0, -2)
        thumb.bg:SetPoint("BOTTOMRIGHT", thumb, 0, 2)
        F.CreateBD(thumb.bg, 0)

        local tex = F.CreateGradient(slider)
        tex:SetPoint("TOPLEFT", thumb.bg, 1, -1)
        tex:SetPoint("BOTTOMRIGHT", thumb.bg, -1, 1)
    end
    function Skin.BasicHybridScrollFrameTemplate(scrollframe)
        local name = scrollframe:GetName()
        Skin.HybridScrollBarTemplate(_G[name.."ScrollBar"])
    end
end

function private.SharedXML.HybridScrollFrame()
    _G.hooksecurefunc("HybridScrollFrame_CreateButtons", Hook.HybridScrollFrame_CreateButtons)
end
