local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--[[ do FrameXML\ZoneAbility.lua
end ]]

--[[ do FrameXML\ZoneAbility.xml
end ]]

function private.FrameXML.ZoneAbility()
    local ZAFButton = _G.ZoneAbilityFrame.SpellButton
    Base.CropIcon(ZAFButton.Icon, ZAFButton)

    ZAFButton.Count:SetPoint("TOPLEFT", -5, 5)
    ZAFButton.Style:Hide()

    ZAFButton.Cooldown:SetPoint("TOPLEFT")
    ZAFButton.Cooldown:SetPoint("BOTTOMRIGHT")

    ZAFButton:SetNormalTexture("")
    Base.CropIcon(ZAFButton:GetHighlightTexture())

    Skin.MicroButtonAlertTemplate(_G.ZoneAbilityButtonAlert)
end
