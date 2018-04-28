local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\EquipmentFlyout.lua ]]
    function Hook.EquipmentFlyout_CreateButton()
        Skin.EquipmentFlyoutButtonTemplate(_G.EquipmentFlyoutFrame.buttons[#_G.EquipmentFlyoutFrame.buttons])
    end
    function Hook.EquipmentFlyoutPopoutButton_SetReversed(self, isReversed)
        if self:GetParent().verticalFlyout then
            if isReversed then
                Base.SetTexture(self._auroraArrow, "arrowUp")
            else
                Base.SetTexture(self._auroraArrow, "arrowDown")
            end
        else
            if isReversed then
                Base.SetTexture(self._auroraArrow, "arrowLeft")
            else
                Base.SetTexture(self._auroraArrow, "arrowRight")
            end
        end
    end
end

do --[[ FrameXML\EquipmentFlyout.xml ]]
    function Skin.EquipmentFlyoutButtonTemplate(Button)
        Skin.ItemButtonTemplate(Button)
    end
    function Skin.EquipmentFlyoutPopoutButtonTemplate(Button)
        local tex = Button:GetNormalTexture()
        Base.SetTexture(tex, "arrowRight")
        tex:SetVertexColor(Color.highlight:GetRGB())
        Button._auroraArrow = tex

        Button:SetHighlightTexture("")
    end
end

function private.FrameXML.EquipmentFlyout()
    _G.hooksecurefunc("EquipmentFlyout_CreateButton", Hook.EquipmentFlyout_CreateButton)
    _G.hooksecurefunc("EquipmentFlyoutPopoutButton_SetReversed", Hook.EquipmentFlyoutPopoutButton_SetReversed)

    _G.EquipmentFlyoutFrameHighlight:SetTexCoord(0.125, 0.65625, 0.125, 0.65625)
    _G.EquipmentFlyoutFrameHighlight:ClearAllPoints()
    _G.EquipmentFlyoutFrameHighlight:SetPoint("TOPLEFT", 3, -3)
    _G.EquipmentFlyoutFrameHighlight:SetPoint("BOTTOMRIGHT", -3, 3)

    local buttonFrame = _G.EquipmentFlyoutFrame.buttonFrame
    buttonFrame.bg1:SetAlpha(0)
    buttonFrame:DisableDrawLayer("ARTWORK")

    local bd = _G.CreateFrame("Frame", nil, buttonFrame)
    bd:SetPoint("TOPLEFT")
    bd:SetPoint("BOTTOMRIGHT", 3, -1)
    bd:SetFrameLevel(buttonFrame:GetFrameLevel())
    Base.SetBackdrop(bd)

    local NavigationFrame = _G.EquipmentFlyoutFrame.NavigationFrame
    Base.SetBackdrop(NavigationFrame)
    NavigationFrame:SetPoint("TOPLEFT", bd, "BOTTOMLEFT", 0, 1)
    NavigationFrame:SetPoint("TOPRIGHT", bd, "BOTTOMRIGHT", 0, 1)
    _G.Test2:Hide() -- BlizzWTF: seriously? This is not a test, it's the BG texture
    Skin.NavButtonPrevious(NavigationFrame.PrevButton)
    Skin.NavButtonNext(NavigationFrame.NextButton)

    --[[ Scale ]]--
    _G.EquipmentFlyoutFrame:SetSize(43, 43)
end
