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
end
