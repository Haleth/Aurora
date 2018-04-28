local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do FrameXML\ActionButton.lua
end ]]

do --[[ FrameXML\ActionBarFrame.xml ]]
    function Skin.ActionBarButtonTemplate(CheckButton)
        Skin.ActionButtonTemplate(CheckButton)

        Base.CreateBackdrop(CheckButton, {
            edgeSize = 1,
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            insets = {left = 1, right = 1, top = 1, bottom = 1}
        })
        CheckButton:SetBackdropColor(1, 1, 1, 0.75)
        CheckButton:SetBackdropBorderColor(Color.frame:GetRGB())
        Base.CropIcon(CheckButton:GetBackdropTexture("bg"))

        CheckButton.icon:SetPoint("TOPLEFT", 1, -1)
        CheckButton.icon:SetPoint("BOTTOMRIGHT", -1, 1)
    end
end

function private.FrameXML.ActionBarFrame()
    if private.disabled.mainmenubar then return end

    for i = 1, 12 do
        Skin.ActionBarButtonTemplate(_G["ActionButton"..i])
    end

    --[[ Scale ]]--
    if private.isPatch then
        _G.ActionButton1:SetPoint("BOTTOMLEFT", _G.MainMenuBarArtFrameBackground, 8, 4)
    else
        _G.ActionButton1:SetPoint("BOTTOMLEFT", 8, 4)
    end
    for i = 2, 12 do
        _G["ActionButton"..i]:SetPoint("LEFT", _G["ActionButton"..i - 1], "RIGHT", 6, 0)
    end

    if private.isPatch then
        _G.ActionBarUpButton:SetSize(21, 19)
        _G.ActionBarUpButton:SetPoint("RIGHT", _G.ActionButton12, 25, 9)
        _G.ActionBarDownButton:SetSize(21, 19)
        _G.ActionBarDownButton:SetPoint("CENTER", _G.ActionBarUpButton, "BOTTOMLEFT", 10, -10)
    else
        _G.ActionBarUpButton:SetSize(32, 32)
        _G.ActionBarUpButton:SetPoint("CENTER", _G.MainMenuBarArtFrame, "TOPLEFT", 522, -22)
        _G.ActionBarDownButton:SetSize(32, 32)
        _G.ActionBarDownButton:SetPoint("CENTER", _G.MainMenuBarArtFrame, "TOPLEFT", 522, -42)
    end
end
