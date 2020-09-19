local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_AzeriteUI.lua ]]
    do --[[ Blizzard_AzeriteEmpoweredItemUI.xml ]]
        Hook.AzeriteEmpoweredItemUIMixin = {}
        function Hook.AzeriteEmpoweredItemUIMixin:AdjustSizeForTiers(numTiers)
            if numTiers == 3 then
                self:SetSize(474, 460)
            elseif numTiers == 4 then
                self:SetSize(615, 601)
            elseif numTiers == 5 then
                self:SetSize(754, 740)
            end
            self.transformTree:GetRoot():SetLocalPosition(_G.CreateVector2D(self.ClipFrame.BackgroundFrame:GetWidth() * .5, self.ClipFrame.BackgroundFrame:GetHeight() * .5))
        end
    end
end

do --[[ AddOns\Blizzard_AzeriteUI.xml ]]
    do --[[ Blizzard_AzeriteEmpoweredItemUITemplates.xml ]]
        function Skin.AzeriteEmpoweredItemUITemplate(Frame)
            Util.Mixin(Frame, Hook.AzeriteEmpoweredItemUIMixin)

            Skin.PortraitFrameTemplate(Frame.BorderFrame)
            local shadow = Frame.BorderFrame:CreateTexture(nil, "ARTWORK")
            shadow:SetAllPoints(Frame.BorderFrame.TitleText)
            shadow:SetAtlas("Azerite-TopShadow")

            Frame.ClipFrame:SetPoint("TOPLEFT")
            Frame.ClipFrame:SetPoint("BOTTOMRIGHT")
        end
    end
end

function private.AddOns.Blizzard_AzeriteUI()
    ----====####$$$$%%%%$$$$####====----
    --  AzeriteEmpowedItemDataSource  --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_AzeriteEmpoweredItemUITemplates --
    ----====####$$$$%%%%%%%%%%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --     AzeritePowerLayoutInfo     --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --      AzeritePowerModelInfo      --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    -- AzeriteEmpoweredItemPowerMixin --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --  AzeriteEmpoweredItemTierMixin  --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --  AzeriteEmpoweredItemSlotMixin  --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_AzeriteEmpoweredItemUI --
    ----====####$$$$%%%%%$$$$####====----
    Skin.AzeriteEmpoweredItemUITemplate(_G.AzeriteEmpoweredItemUI)
end
