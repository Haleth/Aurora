local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local F = _G.unpack(private.Aurora)
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

function private.FrameXML.TabardFrame()
    _G.TabardFramePortrait:SetAlpha(0)
    for i = 2, 5 do -- Bg
        select(i, _G.TabardFrame:GetRegions()):Hide()
    end
    Base.SetBackdrop(_G.TabardFrame)
    Skin.UIPanelCloseButton(_G.TabardFrameCloseButton)
    _G.TabardFrameCloseButton:SetPoint("TOPRIGHT", 4, 4)

    for i = 7, 16 do -- OuterFrame textures
        _G.select(i, _G.TabardFrame:GetRegions()):Hide()
    end
    _G.TabardFrameEmblemTopRight:SetPoint("TOPRIGHT", 15, -50)

    _G.TabardFrameNameText:ClearAllPoints()
    _G.TabardFrameNameText:SetPoint("TOPLEFT")
    _G.TabardFrameNameText:SetPoint("BOTTOMRIGHT", _G.TabardFrame, "TOPRIGHT", 0, -29)

    _G.TabardFrameGreetingText:ClearAllPoints()
    _G.TabardFrameGreetingText:SetPoint("TOPLEFT", 50, -30)
    _G.TabardFrameGreetingText:SetPoint("BOTTOMRIGHT", _G.TabardFrame, "TOPRIGHT", -50, -69)

    Skin.RotateOrbitCameraRightButtonTemplate(_G.TabardCharacterModelRotateLeftButton)
    Skin.RotateOrbitCameraLeftButtonTemplate(_G.TabardCharacterModelRotateRightButton)
    _G.TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", _G.TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

    _G.TabardFrameCostFrame:SetBackdrop(nil)

    _G.TabardFrameCustomizationBorder:Hide()
    _G.TabardFrameCustomization1:ClearAllPoints()
    _G.TabardFrameCustomization1:SetPoint("BOTTOMRIGHT", _G.TabardFrame, -3, 140)
    for i = 1, 5 do
        _G["TabardFrameCustomization"..i.."Left"]:Hide()
        _G["TabardFrameCustomization"..i.."Middle"]:Hide()
        _G["TabardFrameCustomization"..i.."Right"]:Hide()
        F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "Left")
        F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "Right")
    end

    Skin.UIPanelButtonTemplate(_G.TabardFrameAcceptButton)
    Skin.UIPanelButtonTemplate(_G.TabardFrameCancelButton)
end
