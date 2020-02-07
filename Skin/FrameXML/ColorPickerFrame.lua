local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(Aurora)

function private.FrameXML.ColorPickerFrame()
    local ColorPickerFrame = _G.ColorPickerFrame

    if private.isRetail then
        Skin.DialogBorderTemplate(ColorPickerFrame.Border)
        Skin.DialogHeaderTemplate(ColorPickerFrame.Header)
    else
        Skin.DialogBorderTemplate(ColorPickerFrame)

        local _, header, text = ColorPickerFrame:GetRegions()
        header:Hide()
        text:ClearAllPoints()
        text:SetPoint("TOPLEFT")
        text:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end

    F.Reskin(_G.ColorPickerCancelButton)
    _G.ColorPickerCancelButton:SetWidth(100)

    F.Reskin(_G.ColorPickerOkayButton)
    _G.ColorPickerOkayButton:SetWidth(100)
    _G.ColorPickerOkayButton:SetPoint("RIGHT", _G.ColorPickerCancelButton, "LEFT", -5, 0)

    _G.OpacitySliderFrame:ClearAllPoints()
    _G.OpacitySliderFrame:SetPoint("TOPRIGHT", -30, -30)
    F.ReskinSlider(_G.OpacitySliderFrame, true)

    _G.ColorPickerWheel:SetPoint("TOPLEFT", 10, -30)

    local ColorValue = ColorPickerFrame:GetColorValueTexture()
    ColorValue:SetPoint("LEFT", _G.ColorPickerWheel, "RIGHT", 13, 0)

    _G.ColorSwatch:SetPoint("TOPLEFT", 205, -30)

    ColorPickerFrame:HookScript("OnShow", function(self)
        if self.hasOpacity then
            self:SetWidth(300)
        else
            self:SetWidth(255)
        end
    end)

    if private.isRetail then
        Skin.DialogBorderTemplate(_G.OpacityFrame.Border)
    else
        Skin.DialogBorderTemplate(_G.OpacityFrame)
    end
    F.ReskinSlider(_G.OpacityFrameSlider, true)
end
