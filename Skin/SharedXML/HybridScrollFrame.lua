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
    function Skin.HybridScrollBarTemplate(scrollbar)
        local name = scrollbar:GetName()

        scrollbar.trackBG:Hide()

        scrollbar.ScrollBarTop:Hide()
        scrollbar.ScrollBarMiddle:Hide()
        scrollbar.ScrollBarBottom:Hide()

        local up = _G[name.."ScrollUpButton"]
        F.ReskinArrow(up, "Up")
        up:SetSize(17, 17)
        up:SetPoint("BOTTOM", scrollbar, "TOP")

        local down = _G[name.."ScrollDownButton"]
        F.ReskinArrow(down, "Down")
        down:SetSize(17, 17)

        local thumb = scrollbar.thumbTexture
        thumb:SetAlpha(0)
        thumb:SetWidth(17)

        thumb.bg = _G.CreateFrame("Frame", nil, scrollbar)
        thumb.bg:SetPoint("TOPLEFT", thumb, 0, -2)
        thumb.bg:SetPoint("BOTTOMRIGHT", thumb, 0, 4)
        F.CreateBD(thumb.bg, 0)

        local tex = F.CreateGradient(scrollbar)
        tex:SetPoint("TOPLEFT", thumb.bg, 1, -1)
        tex:SetPoint("BOTTOMRIGHT", thumb.bg, -1, 1)
    end
end

function private.SharedXML.HybridScrollFrame()
    _G.hooksecurefunc("HybridScrollFrame_CreateButtons", Hook.HybridScrollFrame_CreateButtons)
end
