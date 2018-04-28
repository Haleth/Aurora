local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

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
    function Skin.HybridScrollBarTemplate(Slider)
        local name = Slider:GetName()

        local parent = Slider:GetParent()
        Slider:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, -17)
        Slider:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 0, 17)

        Slider.trackBG:SetAlpha(0)

        Slider.ScrollBarTop:Hide()
        Slider.ScrollBarMiddle:Hide()
        Slider.ScrollBarBottom:Hide()

        local upButton = _G[name.."ScrollUpButton"]
        upButton:SetPoint("BOTTOM", Slider, "TOP")
        Skin.UIPanelScrollUpButtonTemplate(upButton)

        local downButton = _G[name.."ScrollDownButton"]
        downButton:SetPoint("TOP", Slider, "BOTTOM")
        Skin.UIPanelScrollDownButtonTemplate(downButton)

        Slider.thumbTexture:SetAlpha(0)
        Slider.thumbTexture:SetSize(17, 24)

        local thumb = _G.CreateFrame("Frame", nil, Slider)
        thumb:SetPoint("TOPLEFT", Slider.thumbTexture, 0, -2)
        thumb:SetPoint("BOTTOMRIGHT", Slider.thumbTexture, 0, 2)
        Base.SetBackdrop(thumb, Color.button)
        Slider._auroraThumb = thumb

        --[[ Scale ]]--
        Slider:SetSize(Slider:GetSize())
    end
    function Skin.HybridScrollBarTrimTemplate(Slider)
        local parent = Slider:GetParent()
        Slider:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, -17)
        Slider:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 0, 17)

        Slider.trackBG:SetAlpha(0)

        Slider.Top:Hide()
        Slider.Bottom:Hide()
        Slider.Middle:Hide()

        local upButton = Slider.UpButton
        upButton:SetPoint("BOTTOM", Slider, "TOP")
        Skin.UIPanelScrollUpButtonTemplate(upButton)

        local downButton = Slider.DownButton
        downButton:SetPoint("TOP", Slider, "BOTTOM")
        Skin.UIPanelScrollDownButtonTemplate(downButton)

        Slider.thumbTexture:SetAlpha(0)
        Slider.thumbTexture:SetWidth(17)

        local thumb = _G.CreateFrame("Frame", nil, Slider)
        thumb:SetPoint("TOPLEFT", Slider.thumbTexture, 0, -2)
        thumb:SetPoint("BOTTOMRIGHT", Slider.thumbTexture, 0, 2)
        Base.SetBackdrop(thumb, Color.button)
        Slider._auroraThumb = thumb
    end
    function Skin.BasicHybridScrollFrameTemplate(ScrollFrame)
        local name = ScrollFrame:GetName()
        Skin.HybridScrollBarTemplate(_G[name.."ScrollBar"])
    end
end

function private.SharedXML.HybridScrollFrame()
    _G.hooksecurefunc("HybridScrollFrame_CreateButtons", Hook.HybridScrollFrame_CreateButtons)
end
