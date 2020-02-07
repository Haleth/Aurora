local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

do --[[ FrameXML\CharacterFrameTemplates.xml ]]
    function Skin.CharacterFrameTabButtonTemplate(Button)
        local name = Button:GetName()
        Button:SetHeight(28)

        _G[name.."LeftDisabled"]:SetTexture("")
        _G[name.."MiddleDisabled"]:SetTexture("")
        _G[name.."RightDisabled"]:SetTexture("")
        _G[name.."Left"]:SetTexture("")
        _G[name.."Middle"]:SetTexture("")
        _G[name.."Right"]:SetTexture("")
        _G[name.."Text"]:SetPoint("CENTER", Button, "CENTER")

        Button:SetHighlightTexture("")

        Base.SetBackdrop(Button)
        Base.SetHighlight(Button, "backdrop")
        Button._auroraTabResize = true
    end
end

--function private.FrameXML.CharacterFrameTemplates()
--end
