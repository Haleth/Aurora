local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\OptionsPanelTemplates.xml ]]
    function Skin.OptionsButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end
    function Skin.OptionsBaseCheckButtonTemplate(CheckButton)
        CheckButton:SetNormalTexture("")
        CheckButton:SetPushedTexture("")
        CheckButton:SetHighlightTexture("")

        local bd = _G.CreateFrame("Frame", nil, CheckButton)
        bd:SetPoint("TOPLEFT", 6, -6)
        bd:SetPoint("BOTTOMRIGHT", -6, 6)
        bd:SetFrameLevel(CheckButton:GetFrameLevel())
        Base.SetBackdrop(bd, Color.frame)
        bd:SetBackdropBorderColor(Color.button)

        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", -1, 1)
        check:SetPoint("BOTTOMRIGHT", 1, -1)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        local disabled = CheckButton:GetDisabledCheckedTexture()
        disabled:SetAllPoints(check)

        CheckButton._auroraBDFrame = bd
        Base.SetHighlight(CheckButton, "backdrop")

        --[[ Scale ]]--
        CheckButton:SetSize(CheckButton:GetSize())
    end

    function Skin.OptionsCheckButtonTemplate(CheckButton)
        Skin.OptionsBaseCheckButtonTemplate(CheckButton)
        CheckButton.Text = _G[CheckButton:GetName().."Text"]
        CheckButton.Text:SetPoint("LEFT", CheckButton, "RIGHT", 3, 0)
    end
    function Skin.OptionsSmallCheckButtonTemplate(CheckButton)
        Skin.OptionsBaseCheckButtonTemplate(CheckButton)
        CheckButton.Text = _G[CheckButton:GetName().."Text"]
        CheckButton.Text:SetPoint("LEFT", CheckButton, "RIGHT", 3, 0)
    end
    function Skin.OptionsSliderTemplate(Slider)
        Skin.HorizontalSliderTemplate(Slider)
    end
    function Skin.OptionsDropdownTemplate(Frame)
        Skin.UIDropDownMenuTemplate(Frame)
    end
    function Skin.OptionsBoxTemplate(Frame)
        Base.SetBackdrop(Frame, Color.frame)
    end
end

function private.FrameXML.OptionsPanelTemplates()
    --[[
    ]]
end
