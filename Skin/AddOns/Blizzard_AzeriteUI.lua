local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_AzeriteUI.lua ]]
    function Hook.AzeriteEmpoweredItemUIMixin_AdjustSizeForTiers(self, numTiers)
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

do --[[ AddOns\Blizzard_AzeriteUI.xml ]]
    do --[[ Blizzard_AzeriteEmpoweredItemUITemplates.xml ]]
        function Skin.AzeriteEmpoweredItemUITemplate(Frame)
            _G.hooksecurefunc(Frame, "AdjustSizeForTiers", Hook.AzeriteEmpoweredItemUIMixin_AdjustSizeForTiers)

            Skin.PortraitFrameTemplate(Frame.BorderFrame)
            local shadow = Frame.BorderFrame:CreateTexture(nil, "ARTWORK")
            shadow:SetAllPoints(Frame.BorderFrame.TitleText)
            shadow:SetAtlas("Azerite-TopShadow")

            Frame.ClipFrame:SetPoint("TOPLEFT")
            Frame.ClipFrame:SetPoint("BOTTOMRIGHT")

            Skin.GlowBoxFrame(Frame.FirstPowerLockedInHelpBox, "Left")
        end
    end
end

function private.AddOns.Blizzard_AzeriteUI()
    ----====####$$$$%%%%$$$$####====----
    --  AzeriteEmpowedItemDataSource  --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------


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
