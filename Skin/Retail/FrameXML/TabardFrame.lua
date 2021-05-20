local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ FrameXML\TabardFrame.lua ]]
--end

do --[[ FrameXML\TabardFrame.xml ]]
    function Skin.TabardFrameCustomizeTemplate(Frame)
        local name = Frame:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."Right"]:Hide()
        Skin.NavButtonPrevious(_G[name.."LeftButton"])
        Skin.NavButtonNext(_G[name.."RightButton"])
    end
end

function private.FrameXML.TabardFrame()
    local TabardFrame = _G.TabardFrame
    Skin.ButtonFrameTemplate(TabardFrame)

    for i = 7, 16 do -- OuterFrame textures
        _G.select(i, TabardFrame:GetRegions()):Hide()
    end

    _G.TabardFrameEmblemTopRight:SetPoint("TOPRIGHT", 15, -50)

    _G.TabardFrameNameText:ClearAllPoints()
    _G.TabardFrameNameText:SetPoint("TOPLEFT")
    _G.TabardFrameNameText:SetPoint("BOTTOMRIGHT", TabardFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    _G.TabardFrameGreetingText:ClearAllPoints()
    _G.TabardFrameGreetingText:SetPoint("TOPLEFT", 50, -private.FRAME_TITLE_HEIGHT)
    _G.TabardFrameGreetingText:SetPoint("BOTTOMRIGHT", TabardFrame, "TOPRIGHT", -50, -(private.FRAME_TITLE_HEIGHT + 40))

    Skin.NavButtonPrevious(_G.TabardCharacterModelRotateLeftButton)
    Skin.NavButtonNext(_G.TabardCharacterModelRotateRightButton)
    _G.TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", _G.TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

    _G.TabardFrameCostFrame:SetBackdrop(nil)
    Skin.SmallMoneyFrameTemplate(_G.TabardFrameCostMoneyFrame)

    _G.TabardFrameCustomizationBorder:Hide()
    _G.TabardFrameCustomization1:ClearAllPoints()
    _G.TabardFrameCustomization1:SetPoint("BOTTOMRIGHT", TabardFrame, -3, 140)
    for i = 1, 5 do
        Skin.TabardFrameCustomizeTemplate(_G["TabardFrameCustomization"..i])
    end

    Skin.InsetFrameTemplate(_G.TabardFrameMoneyInset)
    Skin.ThinGoldEdgeTemplate(_G.TabardFrameMoneyBg)

    Skin.UIPanelButtonTemplate(_G.TabardFrameAcceptButton)
    Skin.UIPanelButtonTemplate(_G.TabardFrameCancelButton)
    Util.PositionRelative("BOTTOMRIGHT", TabardFrame, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.TabardFrameAcceptButton,
        _G.TabardFrameCancelButton,
    })
end
