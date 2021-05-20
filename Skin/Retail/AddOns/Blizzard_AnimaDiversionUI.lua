local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_AnimaDiversionUI.lua ]]
--end

--do --[[ AddOns\Blizzard_AnimaDiversionUI.xml ]]
--end

function private.AddOns.Blizzard_AnimaDiversionUI()
    local AnimaDiversionFrame = _G.AnimaDiversionFrame

    Skin.MapCanvasFrameTemplate(AnimaDiversionFrame)
    Skin.NineSlicePanelTemplate(AnimaDiversionFrame.NineSlice)
    AnimaDiversionFrame.NineSlice:SetFrameLevel(1)
    AnimaDiversionFrame.NineSlice:SetPoint("TOPLEFT", 2, -19)
    AnimaDiversionFrame.NineSlice:SetPoint("BOTTOMRIGHT", 1, 0)

    AnimaDiversionFrame.BorderFrame:Hide()

    Skin.UIPanelCloseButton(AnimaDiversionFrame.CloseButton)
    AnimaDiversionFrame.CloseButton:SetPoint("TOPRIGHT", AnimaDiversionFrame.NineSlice, 5.6, 5)
    AnimaDiversionFrame.AnimaDiversionCurrencyFrame:SetPoint("TOP", AnimaDiversionFrame.NineSlice, 0, 0)
    AnimaDiversionFrame.ReinforceProgressFrame:SetPoint("BOTTOM", AnimaDiversionFrame.NineSlice, 0, 1)
end
