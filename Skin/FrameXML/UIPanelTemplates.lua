local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local F = _G.unpack(Aurora)
local Skin = Aurora.Skin

do --[[ FrameXML\UIPanelTemplates.xml ]]
    function Skin.UIPanelSquareButton(button)
        button:SetSize(19.5, 19.5)
        button:SetNormalTexture("")
        button:SetHighlightTexture("")
        button:SetPushedTexture("")
        F.CreateBD(button, 0)
        F.CreateGradient(button)
    end
    function Skin.UIPanelLargeSilverButton(button)
        local buttonName = button:GetName()
        _G[buttonName.."Left"]:Hide()
        _G[buttonName.."Right"]:Hide()
        _G[buttonName.."Middle"]:Hide()
        for i = 3, 6 do
            _G.select(i, button:GetRegions()):Hide()
        end
        Aurora.SetBackdrop(button, private.buttonColor:GetRGBA())
        Aurora.SetHighlight(button, "backdrop")
    end
    function Skin.TranslucentFrameTemplate(frame)
        frame.Bg:Hide()

        frame.TopLeftCorner:Hide()
        frame.TopRightCorner:Hide()
        frame.BottomLeftCorner:Hide()
        frame.BottomRightCorner:Hide()

        frame.TopBorder:Hide()
        frame.BottomBorder:Hide()
        frame.LeftBorder:Hide()
        frame.RightBorder:Hide()
        F.CreateBD(frame)
    end
end

function private.FrameXML.UIPanelTemplates()
end
