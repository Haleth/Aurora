local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

do --[[ FrameXML\OptionsPanelTemplates.xml ]]
    function Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        checkbutton:SetSize(18, 18)

        checkbutton:SetNormalTexture("")
        checkbutton:SetPushedTexture("")
        checkbutton:SetHighlightTexture("")

        local check = checkbutton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("CENTER")
        check:SetDesaturated(true)
        check:SetVertexColor(Aurora.highlightColor:GetRGB())

        Base.SetBackdrop(checkbutton)
        Base.SetHighlight(checkbutton, "backdrop")
    end

    function Skin.OptionsCheckButtonTemplate(checkbutton)
        Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        local name = checkbutton:GetName()
        _G[name.."Text"]:SetPoint("LEFT", checkbutton, "RIGHT", 3, 0)
    end
    function Skin.OptionsSmallCheckButtonTemplate(checkbutton)
        Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        local name = checkbutton:GetName()
        _G[name.."Text"]:SetPoint("LEFT", checkbutton, "RIGHT", 3, 0)
    end
end

function private.FrameXML.OptionsPanelTemplates()
    --[[
    ]]
end
