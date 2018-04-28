local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

do --[[ FrameXML\ActionButtonTemplate.xml ]]
    function Skin.ActionButtonTemplate(CheckButton)
        Base.CropIcon(CheckButton.icon)

        CheckButton.Flash:SetColorTexture(1, 0, 0, 0.5)
        CheckButton.NewActionTexture:SetAllPoints()
        CheckButton.NewActionTexture:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        CheckButton.SpellHighlightTexture:SetAllPoints()
        CheckButton.SpellHighlightTexture:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        CheckButton.AutoCastable:SetAllPoints()
        CheckButton.AutoCastable:SetTexCoord(0.21875, 0.765625, 0.21875, 0.765625)
        CheckButton.AutoCastShine:ClearAllPoints()
        CheckButton.AutoCastShine:SetPoint("TOPLEFT", 2, -2)
        CheckButton.AutoCastShine:SetPoint("BOTTOMRIGHT", -2, 2)

        CheckButton:SetNormalTexture("")
        Base.CropIcon(CheckButton:GetPushedTexture())
        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())

        --[[ Scale ]]--
        CheckButton:SetSize(36, 36)
        CheckButton.HotKey:SetPoint("TOPLEFT", 1, -3)
        CheckButton.HotKey:SetPoint("BOTTOMRIGHT", CheckButton, "TOPRIGHT", -1, -13)
        CheckButton.Count:SetPoint("BOTTOMRIGHT", -2, 2)

        CheckButton.Name:ClearAllPoints()
        CheckButton.Name:SetPoint("TOPLEFT", CheckButton, "BOTTOMLEFT", 0, 12)
        CheckButton.Name:SetPoint("BOTTOMRIGHT", 0, 2)

        CheckButton.cooldown:SetPoint("TOPLEFT")
        CheckButton.cooldown:SetPoint("BOTTOMRIGHT")
    end
end

function private.FrameXML.ActionButtonTemplate()
    --[[
    ]]
end
