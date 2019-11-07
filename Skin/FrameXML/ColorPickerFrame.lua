local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(Aurora)

function private.FrameXML.ColorPickerFrame()

    Skin.DialogBorderTemplate(_G.ColorPickerFrame.Border)
    if private.isPatch then
        Skin.DialogHeaderTemplate(_G.ColorPickerFrame.Header)
    else
        _G.ColorPickerFrameHeader:Hide()
        local header = select(3, _G.ColorPickerFrame:GetRegions())
        header:SetPoint("TOP", _G.ColorPickerFrame, 0, -4)
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

    local ColorValue = _G.ColorPickerFrame:GetColorValueTexture()
    ColorValue:SetPoint("LEFT", _G.ColorPickerWheel, "RIGHT", 13, 0)

    _G.ColorSwatch:SetPoint("TOPLEFT", 205, -30)

    _G.ColorPickerFrame:HookScript("OnShow", function(self)
        if self.hasOpacity then
            self:SetWidth(300)
        else
            self:SetWidth(255)
        end
    end)

    Skin.DialogBorderTemplate(_G.OpacityFrame.Border)
    F.ReskinSlider(_G.OpacityFrameSlider, true)
end
