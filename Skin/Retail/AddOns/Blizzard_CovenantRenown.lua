local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_CovenantRenown.lua ]]
    local g_covenantID

    Hook.CovenantRenownMixin = {}
    function Hook.CovenantRenownMixin:SetUpCovenantData()
        local covenantID = _G.C_Covenants.GetActiveCovenantID()
        local covenantData = _G.C_Covenants.GetCovenantData(covenantID)
        if g_covenantID ~= covenantID then
            g_covenantID = covenantID

            local textureKit = covenantData.textureKit
            local _, _, _, a = self.NineSlice:GetBackdropColor()
            Base.SetBackdropColor(self.NineSlice, private.COVENANT_COLORS[textureKit], a)
            self.Divider:SetColorTexture(private.COVENANT_COLORS[textureKit]:GetRGB())
            self.Divider:SetHeight(1)
            self._anima2:SetAtlas("CovenantSanctum-Renown-Anima-"..textureKit, true)
        end
    end
end

--do --[[ AddOns\Blizzard_CovenantRenown.xml ]]
--end

function private.AddOns.Blizzard_CovenantRenown()
    local CovenantRenownFrame = _G.CovenantRenownFrame
    Util.Mixin(CovenantRenownFrame, Hook.CovenantRenownMixin)
    CovenantRenownFrame.Background:SetPoint("TOPLEFT", 1, -1)
    CovenantRenownFrame.Background:SetPoint("BOTTOMRIGHT", -1, 1)
    CovenantRenownFrame.Background:SetAlpha(0.75)
    CovenantRenownFrame.BackgroundShadow:Hide()

    CovenantRenownFrame.Divider:SetPoint("TOP", 1, -221)
    CovenantRenownFrame.Divider:SetPoint("LEFT", 1, 0)
    CovenantRenownFrame.Divider:SetPoint("RIGHT", -1, 0)
    CovenantRenownFrame.PreviewText:SetPoint("CENTER", CovenantRenownFrame.Divider, "BOTTOM", 0, -17)

    CovenantRenownFrame.Anima:SetPoint("LEFT", 1, 0)
    CovenantRenownFrame.Anima:SetPoint("RIGHT", CovenantRenownFrame, "LEFT", 183, 0)
    CovenantRenownFrame.Anima:SetTexCoord(0, 0.224, 0, 1)

    local anima2 = CovenantRenownFrame:CreateTexture(nil, "ARTWORK")
    --anima2:SetPoint("LEFT", 1, 0)
    anima2:SetPoint("LEFT", CovenantRenownFrame, "RIGHT", -184, 0)
    anima2:SetPoint("RIGHT", -1, 0)
    anima2:SetPoint("BOTTOM", 0, 99)
    anima2:SetTexCoord(0.773, 1, 0, 1)
    CovenantRenownFrame._anima2 = anima2

    Skin.NineSlicePanelTemplate(CovenantRenownFrame.NineSlice)
    CovenantRenownFrame.NineSlice:SetFrameLevel(1)

    Skin.UIPanelCloseButton(CovenantRenownFrame.CloseButton)
    -------------
    -- Section --
    -------------
end
