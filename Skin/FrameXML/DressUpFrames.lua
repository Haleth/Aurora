local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local F = _G.unpack(private.Aurora)
local Skin = private.Aurora.Skin

function private.FrameXML.DressUpFrames()
    -- SideDressUp
    for i = 1, 4 do
        select(i, _G.SideDressUpFrame:GetRegions()):Hide()
    end
    select(5, _G.SideDressUpModelCloseButton:GetRegions()):Hide()

    _G.SideDressUpModel:HookScript("OnShow", function(self)
        self:ClearAllPoints()
        self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
    end)

    F.Reskin(_G.SideDressUpModelResetButton)
    F.ReskinClose(_G.SideDressUpModelCloseButton)

    _G.SideDressUpModel.bg = _G.CreateFrame("Frame", nil, _G.SideDressUpModel)
    _G.SideDressUpModel.bg:SetPoint("TOPLEFT", 0, 1)
    _G.SideDressUpModel.bg:SetPoint("BOTTOMRIGHT", 1, -1)
    _G.SideDressUpModel.bg:SetFrameLevel(_G.SideDressUpModel:GetFrameLevel()-1)
    F.CreateBD(_G.SideDressUpModel.bg)


    -- Dressup Frame
    _G.DressUpFramePortrait:SetAlpha(0)
    local DressUpFrame = _G.DressUpFrame
    F.CreateBG(DressUpFrame)
    DressUpFrame:DisableDrawLayer("OVERLAY")
    for i = 2, 5 do
        select(i, DressUpFrame:GetRegions()):Hide()
    end
    F.ReskinClose(_G.DressUpFrameCloseButton)
    _G.DressUpFrameCloseButton:SetPoint("TOPRIGHT", DressUpFrame, "TOPRIGHT", 4, 5)

    Skin.RotateOrbitCameraRightButtonTemplate(_G.DressUpModelFrameRotateLeftButton)
    Skin.RotateOrbitCameraLeftButtonTemplate(_G.DressUpModelFrameRotateRightButton)

    local DressUpModelFrame = _G.DressUpModelFrame
    --DressUpModelFrame:SetDrawLayer("BACKGROUND", 3)
    DressUpModelFrame:ClearAllPoints()
    DressUpModelFrame:SetPoint("TOPLEFT")
    DressUpModelFrame:SetPoint("BOTTOMRIGHT")
    DressUpModelFrame:SetAlpha(0.6)

    F.Reskin(_G.DressUpFrameCancelButton)
    F.Reskin(_G.DressUpFrameResetButton)
    _G.DressUpFrameCancelButton:SetPoint("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -1, 0)
    _G.DressUpFrameResetButton:SetPoint("RIGHT", _G.DressUpFrameCancelButton, "LEFT", -1, 0)
end
