local _, private = ...
if private.isClassic then return end

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
        Button.Arrow:SetVertexColor(Color.yellow:GetRGB())
        Button.Arrow:SetPoint("LEFT", Button.Texture, "RIGHT", 5, 0)
        Button.Arrow:SetSize(26, 13)
        Base.SetTexture(Button.Arrow, "arrowRight")
        Button.Border:Hide()
    end
    function Skin.PvpTalentTrinketSlotTemplate(Button)
        Skin.PvpTalentSlotTemplate(Button)
        Button.Texture:SetSize(48, 48)
    end
end

--function private.FrameXML.TalentFrameTemplates()
--end
