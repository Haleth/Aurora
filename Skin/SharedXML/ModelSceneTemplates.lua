local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do SharedXML\ModelSceneTemplates.lua
end ]]

do --[[ SharedXML\ModelSceneTemplates.xml ]]
    function Skin.ModifyOrbitCameraBaseButtonTemplate(Button)
        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetHighlightTexture("")

        Base.SetBackdrop(Button, Color.button)
        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 5, -5)
        bg:SetPoint("BOTTOMRIGHT", -5, 5)
    end
    function Skin.RotateOrbitCameraLeftButtonTemplate(Button)
        Skin.ModifyOrbitCameraBaseButtonTemplate(Button)

        local bg = Button:GetBackdropTexture("bg")
        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", bg, 8, -5)
        arrow:SetPoint("BOTTOMRIGHT", bg, -8, 4)
        Base.SetTexture(arrow, "arrowLeft")

        Button._auroraHighlight = {arrow}
        Base.SetHighlight(Button, "texture")
    end
    function Skin.RotateOrbitCameraRightButtonTemplate(Button)
        Skin.ModifyOrbitCameraBaseButtonTemplate(Button)

        local bg = Button:GetBackdropTexture("bg")
        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", bg, 8, -5)
        arrow:SetPoint("BOTTOMRIGHT", bg, -8, 4)
        Base.SetTexture(arrow, "arrowRight")

        Button._auroraHighlight = {arrow}
        Base.SetHighlight(Button, "texture")
    end
end

function private.SharedXML.ModelSceneTemplates()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
