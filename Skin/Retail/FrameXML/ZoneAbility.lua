local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

--do --[[ FrameXML\ZoneAbility.lua ]]
--end

do --[[ FrameXML\ZoneAbility.xml ]]
    function Skin.ZoneAbilityFrameTemplate(Frame)
        Frame.Style:Hide()
        Util.Mixin(Frame.SpellButtonContainer.contentFramePool, Hook.ObjectPoolMixin)
    end
    function Skin.ZoneAbilityFrameSpellButtonTemplate(Button)
        --Button.Icon:SetTexture(private.textures.plain)
        Base.CropIcon(Button.Icon, Button)

        Button.Count:SetPoint("TOPLEFT", -5, 5)
        Button.Cooldown:SetPoint("TOPLEFT")
        Button.Cooldown:SetPoint("BOTTOMRIGHT")

        Button.NormalTexture:SetTexture("")
        Base.CropIcon(Button:GetHighlightTexture())
        --Base.CropIcon(Button:GetCheckedTexture())
    end
end

function private.FrameXML.ZoneAbility()
    Skin.ZoneAbilityFrameTemplate(_G.ZoneAbilityFrame)
end
