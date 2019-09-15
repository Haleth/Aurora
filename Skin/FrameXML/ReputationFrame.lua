local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select next type

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ReputationFrame.lua ]]
    function Hook.ReputationFrame_OnShow(self)
        -- The TOPRIGHT anchor for ReputationBar1 is set in C code
        _G.ReputationBar1:SetPoint("TOPRIGHT", -34, -49)
    end
    function Hook.ReputationFrame_Update(self)
        for i = 1, _G.NUM_FACTIONS_DISPLAYED do
            local factionRow = _G["ReputationBar"..i]
            if not factionRow.index then return end

            local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(factionRow.index)
            if atWarWith then
                Base.SetBackdropColor(factionRow, Color.red)
            else
                Base.SetBackdropColor(factionRow, Color.button)
            end

            if factionRow.index == _G.GetSelectedFaction() then
                if _G.ReputationDetailFrame:IsShown() then
                    factionRow:SetBackdropBorderColor(Color.highlight)
                end
            end
        end
    end
end

do --[[ FrameXML\ReputationFrame.xml ]]
    local function OnEnter(button)
        button:SetBackdropBorderColor(Color.highlight)
    end
    local function OnLeave(button)
        if (_G.GetSelectedFaction() ~= button.index) or (not _G.ReputationDetailFrame:IsShown()) then
            local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(button.index)
            if atWarWith then
                button:SetBackdropBorderColor(Color.red)
            else
                button:SetBackdropBorderColor(Color.button)
            end
        end
    end

    function Skin.ReputationBarTemplate(Frame)
        local factionRowName = Frame:GetName()

        Base.SetBackdrop(Frame, Color.button)
        Base.SetHighlight(Frame, "backdrop", OnEnter, OnLeave)

        _G[factionRowName.."ReputationBarLeft"]:Hide()
        _G[factionRowName.."ReputationBarRight"]:Hide()
        _G[factionRowName.."Highlight2"]:SetAlpha(0)
        _G[factionRowName.."Highlight1"]:SetAlpha(0)
    end
end

function private.FrameXML.ReputationFrame()
    _G.ReputationFrame:HookScript("OnShow", Hook.ReputationFrame_OnShow)
    _G.hooksecurefunc("ReputationFrame_Update", Hook.ReputationFrame_Update)

    ---------------------
    -- ReputationFrame --
    ---------------------
    -- Hide BG
    for i = 1, 4 do
        select(i, _G.ReputationFrame:GetRegions()):Hide()
    end
    Skin.ReputationBarTemplate(_G.ReputationBar1)
    for i = 2, _G.NUM_FACTIONS_DISPLAYED do
        local factionRow = _G["ReputationBar"..i]
        factionRow:SetPoint("TOPRIGHT", _G["ReputationBar"..i - 1], "BOTTOMRIGHT", 0, -4)
        Skin.ReputationBarTemplate(factionRow)
    end
    _G.ReputationFrameFactionLabel:SetPoint("TOPLEFT", 75, -32)
    _G.ReputationFrameStandingLabel:ClearAllPoints()
    _G.ReputationFrameStandingLabel:SetPoint("TOPRIGHT", -75, -32)

    _G.ReputationListScrollFrame:SetPoint("TOPLEFT", _G.CharacterFrame.Inset, 4, -4)
    _G.ReputationListScrollFrame:SetPoint("BOTTOMRIGHT", _G.CharacterFrame.Inset, -23, 4)

    Skin.FauxScrollFrameTemplate(_G.ReputationListScrollFrame)
    local top, bottom = _G.ReputationListScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()


    ---------------------------
    -- ReputationDetailFrame --
    ---------------------------
    _G.ReputationDetailFrame:SetPoint("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 1, -28)
    Base.SetBackdrop(_G.ReputationDetailFrame, Color.frame)

    _G.ReputationDetailFactionName:SetPoint("TOPLEFT", 10, -10)
    _G.ReputationDetailFactionName:SetPoint("TOPRIGHT", -10, -10)
    _G.ReputationDetailFactionDescription:SetPoint("TOPLEFT", _G.ReputationDetailFactionName, "BOTTOMLEFT", 0, -5)
    _G.ReputationDetailFactionDescription:SetPoint("TOPRIGHT", _G.ReputationDetailFactionName, "BOTTOMRIGHT", 0, -5)

    local detailBG = _G.select(3, _G.ReputationDetailFrame:GetRegions())
    detailBG:SetPoint("TOPLEFT", 1, -1)
    detailBG:SetPoint("BOTTOMRIGHT", _G.ReputationDetailFrame, "TOPRIGHT", -1, -142)
    detailBG:SetColorTexture(Color.button:GetRGB())
    _G.ReputationDetailCorner:Hide()

    _G.ReputationDetailDivider:SetColorTexture(Color.frame:GetRGB())
    _G.ReputationDetailDivider:ClearAllPoints()
    _G.ReputationDetailDivider:SetPoint("BOTTOMLEFT", detailBG)
    _G.ReputationDetailDivider:SetPoint("BOTTOMRIGHT", detailBG)
    _G.ReputationDetailDivider:SetHeight(1)

    Skin.UIPanelCloseButton(_G.ReputationDetailCloseButton)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailAtWarCheckBox) -- BlizzWTF: doesn't use the template, but it should
    _G.ReputationDetailAtWarCheckBox:SetPoint("TOPLEFT", detailBG, "BOTTOMLEFT", 10, -6)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailInactiveCheckBox)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailMainScreenCheckBox)
end
