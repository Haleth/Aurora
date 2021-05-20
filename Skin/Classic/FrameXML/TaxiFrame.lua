local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.TaxiFrame()
    local TaxiFrame = _G.TaxiFrame
    Skin.FrameTypeFrame(TaxiFrame)
    TaxiFrame:SetBackdropOption("offsets", {
        left = 20,
        right = 46,
        top = 74,
        bottom = 84,
    })

    local portrait, tl, tr, bl, br = TaxiFrame:GetRegions()
    portrait:Hide()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    local bg = TaxiFrame:GetBackdropTexture("bg")
    _G.TaxiMerchant:ClearAllPoints()
    _G.TaxiMerchant:SetPoint("TOPLEFT", bg)
    _G.TaxiMerchant:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    _G.TaxiMerchant:SetDrawLayer("OVERLAY", 5)

    Skin.UIPanelCloseButton(_G.TaxiCloseButton)
    _G.TaxiCloseButton:SetPoint("TOPRIGHT", bg, 5.6, 5)
end
