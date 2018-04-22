local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\OptionsPanelTemplates.xml ]]
    function Skin.OptionsButtonTemplate(button)
        Skin.UIPanelButtonTemplate(button)
    end
    function Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        checkbutton:SetNormalTexture("")
        checkbutton:SetPushedTexture("")
        checkbutton:SetHighlightTexture("")

        local bd = _G.CreateFrame("Frame", nil, checkbutton)
        bd:SetPoint("TOPLEFT", 4, -4)
        bd:SetPoint("BOTTOMRIGHT", -4, 4)
        bd:SetFrameLevel(checkbutton:GetFrameLevel())
        Base.SetBackdrop(bd, Color.button, 0.3)

        local check = checkbutton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bd, -7, 7)
        check:SetPoint("BOTTOMRIGHT", bd, 7, -7)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        local disabled = checkbutton:GetDisabledCheckedTexture()
        disabled:ClearAllPoints()
        disabled:SetPoint("TOPLEFT", -7, 7)
        disabled:SetPoint("BOTTOMRIGHT", 7, -7)

        checkbutton._auroraBDFrame = bd
        Base.SetHighlight(checkbutton, "backdrop")

        checkbutton:SetSize(checkbutton:GetSize())
    end

    function Skin.OptionsCheckButtonTemplate(checkbutton)
        Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        checkbutton.Text = _G[checkbutton:GetName().."Text"]
        checkbutton.Text:SetPoint("LEFT", checkbutton, "RIGHT", 3, 0)
    end
    function Skin.OptionsSmallCheckButtonTemplate(checkbutton)
        Skin.OptionsBaseCheckButtonTemplate(checkbutton)
        checkbutton.Text = _G[checkbutton:GetName().."Text"]
        checkbutton.Text:SetPoint("LEFT", checkbutton, "RIGHT", 3, 0)
    end
    function Skin.OptionsSliderTemplate(slider)
        Skin.HorizontalSliderTemplate(slider)

        --[[ Scale ]]--
        slider:SetSize(slider:GetSize())
    end
    function Skin.OptionsDropdownTemplate(frame)
        Skin.UIDropDownMenuTemplate(frame)
    end
    function Skin.OptionsBoxTemplate(frame)
        Base.SetBackdrop(frame, Color.frame)
    end
end

function private.FrameXML.OptionsPanelTemplates()
    --[[
    ]]
end
