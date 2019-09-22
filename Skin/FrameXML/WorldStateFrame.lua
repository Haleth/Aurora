local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\MainHelpPlateButton.lua ]]
    function Hook.CaptureBar_Create(id)
        Skin.WorldStateCaptureBarTemplate(_G["WorldStateCaptureBar"..id])
     end
    function Hook.CaptureBar_Update(id, value, neutralPercent)
        local bar = _G["WorldStateCaptureBar"..id]
        if bar.style == "LFD_BATTLEFIELD" then
            bar._auroraLeftFaction:SetTexture([[Interface\WorldStateFrame\ColumnIcon-FlagCapture2]])

            bar._auroraRightFaction:SetTexture([[Interface\WorldStateFrame\ColumnIcon-FlagCapture2]])
            bar._auroraRightFaction:SetDesaturated(true)
            bar._auroraRightFaction:SetVertexColor(0.75, 0.5, 1)
        else
            bar._auroraLeftFaction:SetTexture([[Interface\WorldStateFrame\AllianceFlag]])

            bar._auroraRightFaction:SetTexture([[Interface\WorldStateFrame\HordeFlag]])
            bar._auroraRightFaction:SetDesaturated(false)
            bar._auroraRightFaction:SetVertexColor(1, 1, 1)
        end
     end
end

do --[[ FrameXML\WorldStateFrame.xml ]]
    function Skin.WorldStateScoreTemplate(Frame)
        Frame.factionLeft:ClearAllPoints()
        Frame.factionLeft:SetPoint("TOPLEFT", 20, -1)
        Frame.factionLeft:SetPoint("BOTTOMRIGHT", Frame, "BOTTOM", 0, 1)
        Frame.factionLeft:SetTexture([[Interface\Buttons\WHITE8x8]])
        Frame.factionLeft:SetBlendMode("ADD")
        Frame.factionLeft:SetAlpha(0.8)

        Frame.factionRight:ClearAllPoints()
        Frame.factionRight:SetPoint("TOPLEFT", Frame.factionLeft, "TOPRIGHT", 0, 0)
        Frame.factionRight:SetPoint("BOTTOMRIGHT", 0, 1)
        Frame.factionRight:SetTexture([[Interface\Buttons\WHITE8x8]])
        Frame.factionRight:SetBlendMode("ADD")
        Frame.factionRight:SetAlpha(0.8)
    end
    function Skin.WorldStateCaptureBarTemplate(Frame)
        Frame.BarBackground:Hide()

        local bg = _G.CreateFrame("Frame", nil, Frame)
        bg:SetFrameLevel(Frame:GetFrameLevel())
        bg:SetPoint("TOPLEFT", 25, -7)
        bg:SetPoint("BOTTOMRIGHT", -25, 8)
        Base.SetBackdrop(bg)

        local leftFaction = Frame:CreateTexture()
        leftFaction:SetTexture([[Interface\WorldStateFrame\AllianceFlag]])
        leftFaction:SetPoint("LEFT", -5, 0)
        leftFaction:SetSize(32, 32)
        Frame._auroraLeftFaction = leftFaction

        local rightFaction = Frame:CreateTexture()
        rightFaction:SetTexture([[Interface\WorldStateFrame\HordeFlag]])
        rightFaction:SetPoint("RIGHT", 5, 0)
        rightFaction:SetSize(32, 32)
        Frame._auroraRightFaction = rightFaction

        Frame.RightLine:SetColorTexture(0, 0, 0)
        Frame.RightLine:SetSize(2, 9)
        Frame.LeftLine:SetColorTexture(0, 0, 0)
        Frame.LeftLine:SetSize(2, 9)

        Frame.LeftIconHighlight:SetTexture([[Interface\WorldStateFrame\HordeFlagFlash]])
        Frame.LeftIconHighlight:SetAllPoints(leftFaction)
        Frame.RightIconHighlight:SetTexture([[Interface\WorldStateFrame\HordeFlagFlash]])
        Frame.RightIconHighlight:SetAllPoints(rightFaction)
    end
end

function private.FrameXML.WorldStateFrame()
    local MAX_SCORE_BUTTONS = 22

    for i = 1, 6 do
        select(i, _G.WorldStateScoreFrame:GetRegions()):Hide()
    end
    select(8, _G.WorldStateScoreFrame:GetRegions()):Hide()
    Base.SetBackdrop(_G.WorldStateScoreFrame)
    Skin.UIPanelCloseButton(_G.WorldStateScoreFrameCloseButton)
    _G.WorldStateScoreFrameCloseButton:SetPoint("TOPRIGHT", 4, 4)
    _G.WorldStateScoreFrameLabel:SetPoint("TOP", 0, -10)

    for i = 1, MAX_SCORE_BUTTONS do
        Skin.WorldStateScoreTemplate(_G["WorldStateScoreButton" .. i])
    end

    Skin.FauxScrollFrameTemplate(_G.WorldStateScoreScrollFrame)
    local top, mid, bottom = _G.WorldStateScoreScrollFrame:GetRegions()
    top:Hide()
    mid:Hide()
    bottom:Hide()

    Skin.CharacterFrameTabButtonTemplate(_G.WorldStateScoreFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.WorldStateScoreFrameTab2)
    Skin.CharacterFrameTabButtonTemplate(_G.WorldStateScoreFrameTab3)
    Util.PositionRelative("TOPLEFT", _G.WorldStateScoreFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.WorldStateScoreFrameTab1,
        _G.WorldStateScoreFrameTab2,
        _G.WorldStateScoreFrameTab3,
    })

    Skin.UIPanelButtonTemplate(_G.WorldStateScoreFrameLeaveButton)

    _G.WorldStateScoreWinnerFrameLeft:SetTexture([[Interface\Buttons\WHITE8x8]])
    _G.WorldStateScoreWinnerFrameRight:SetTexture([[Interface\Buttons\WHITE8x8]])
end
