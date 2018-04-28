local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

--[[ do FrameXML\ExtraActionBar.lua
end ]]

do --[[ FrameXML\ExtraActionBar.xml ]]
    -- /run ActionButton_StartFlash(ExtraActionButton1)
    function Skin.ExtraActionButtonTemplate(CheckButton)
        Base.CropIcon(CheckButton.icon, CheckButton)

        CheckButton.HotKey:SetPoint("TOPLEFT", 5, -5)
        CheckButton.Count:SetPoint("TOPLEFT", -5, 5)

        CheckButton.Flash:SetColorTexture(1, 0, 0, 0.5)
        CheckButton.style:Hide()

        CheckButton.cooldown:SetPoint("TOPLEFT")
        CheckButton.cooldown:SetPoint("BOTTOMRIGHT")

        CheckButton:SetNormalTexture("")
        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
end

function private.FrameXML.ExtraActionBar()
    Skin.ExtraActionButtonTemplate(_G.ExtraActionButton1)
end
