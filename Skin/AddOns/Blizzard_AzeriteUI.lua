local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_AzeriteUI.lua ]]
    function Hook.AzeriteEmpoweredItemUIMixin_AdjustSizeForTiers(self, numTiers)
        self.ClipFrame.BackgroundFrame:SetPoint("TOPLEFT", 4, 0)
        if numTiers == 3 then
            self:SetSize(474, 468)
        else
            self:SetSize(615, 612)
        end
    end
end

do --[[ AddOns\Blizzard_AzeriteUI.xml ]]
    do --[[ Blizzard_AzeriteEmpoweredItemUITemplates.xml ]]
        function Skin.AzeriteEmpoweredItemUITemplate(Frame)
            _G.hooksecurefunc(Frame, "AdjustSizeForTiers", Hook.AzeriteEmpoweredItemUIMixin_AdjustSizeForTiers)

            Frame:SetClipsChildren(true)
            Skin.PortraitFrameTemplate(Frame.BorderFrame)
            Frame.BorderFrame:GetBackdropTexture("bg"):SetParent(Frame)

            --Frame.ClipFrame.BackgroundFrame:SetPoint("BOTTOMRIGHT")
            Frame.ClipFrame.BackgroundFrame.KeyOverlay.Shadow:ClearAllPoints()
            Frame.ClipFrame.BackgroundFrame.KeyOverlay.Shadow:SetPoint("TOPLEFT", -5, 0)
            Frame.ClipFrame.BackgroundFrame.KeyOverlay.Shadow:SetPoint("BOTTOMRIGHT", Frame.ClipFrame.BackgroundFrame.KeyOverlay, "TOPRIGHT", 5, -40)
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

    --[[ Scale ]]--

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
