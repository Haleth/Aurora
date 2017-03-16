local _, private = ...

-- [[ Lua Globals ]]
local select, next = _G.select, _G.next

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    _G.ColorPickerFrameHeader:Hide()
    local header = select(3, _G.ColorPickerFrame:GetRegions())
    header:SetPoint("TOP", _G.ColorPickerFrame, 0, -4)

    F.CreateBD(_G.ColorPickerFrame)
    for name, side in next, {ColorPickerOkayButton = "LEFT", ColorPickerCancelButton = "RIGHT"} do
        local btn = _G[name]
        local point = "BOTTOM"..side
        local offSet = side == "LEFT" and 5 or -5

        F.Reskin(btn)
        btn:ClearAllPoints()
        btn:SetPoint(point, offSet, 5)
        btn:SetWidth(100)
    end

    _G.OpacitySliderFrame:ClearAllPoints()
    _G.OpacitySliderFrame:SetPoint("TOPRIGHT", -30, -30)
    F.ReskinSlider(_G.OpacitySliderFrame, true)

    _G.ColorPickerWheel:SetPoint("TOPLEFT", 10, -30)

    local ColorValue = _G.ColorPickerFrame:GetColorValueTexture()
    ColorValue:SetPoint("LEFT", _G.ColorPickerWheel, "RIGHT", 13, 0)

    _G.ColorSwatch:SetPoint("TOPLEFT", 205, -30)

    _G.ColorPickerFrame:HookScript("OnShow", function(self)
        if self.hasOpacity then
            self:SetSize(300, 200)
        else
            self:SetSize(255, 200)
        end
    end)
end)
