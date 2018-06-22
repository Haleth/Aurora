local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\TalentFrameTemplates.xml ]]
    function Skin.PvpTalentSlotTemplate(Button)
        Button._auroraBG = Base.CropIcon(Button.Texture, Button)
        Base.SetTexture(Button.Arrow, "arrowRight")
        Button.Arrow:SetPoint("LEFT", Button.Texture, "RIGHT", 5, 0)
        Button.Arrow:SetVertexColor(Color.yellow:GetRGB())
        Button.Arrow:SetSize(26, 13)
        Button.Border:Hide()

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
        Button.Texture:SetSize(32, 32)
        Button.TalentName:SetPoint("TOP", Button, "BOTTOM", 0, 0)
    end
    function Skin.PvpTalentTrinketSlotTemplate(Button)
        Skin.PvpTalentSlotTemplate(Button)
        Button.Texture:SetSize(48, 48)
        Button.Arrow:SetSize(26, 13)
    end
end

function private.FrameXML.TalentFrameTemplates()
    ----====####$$$$%%%%$$$$####====----
    --              TalentFrameTemplates              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------

    --[[ Scale ]]--
end
