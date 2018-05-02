local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\UIPanelTemplates.xml ]]
    function Skin.SearchBoxTemplate(EditBox)
        Skin.InputBoxInstructionsTemplate(EditBox)
    end
    function Skin.BagSearchBoxTemplate(EditBox)
        Skin.SearchBoxTemplate(EditBox)
    end
    function Skin.UIServiceButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.button)
        Skin.SmallMoneyFrameTemplate(Button.money)
        Base.CropIcon(Button.icon, Button)

        Button.selectedTex:SetTexCoord(0.005859375, 0.5703125, 0.853515625, 0.9375)
        Button.disabledBG:SetAllPoints()

        Button:SetNormalTexture("")
        Button:GetHighlightTexture():SetTexCoord(0.005859375, 0.5703125, 0.7578125, 0.841796875)

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
        Button.money:SetPoint("TOPRIGHT", 5, -7)
        Button.icon:SetSize(36, 36)
        Button.icon:SetPoint("LEFT", 6, 0)
        Button.name:SetPoint("TOPLEFT", Button.icon, "TOPRIGHT", 6, -1)
        Button.name:SetPoint("RIGHT", Button.money, "LEFT", -2, 0)
        Button.subText:SetSize(240, 30)
        Button.subText:SetPoint("LEFT", Button.name, 0, -19)
    end
    function Skin.UIPanelInfoButton(Button)
        Button:SetSize(16, 16)
        Button.texture:SetTexture([[Interface\Common\help-i]])
        Button.texture:SetTexCoord(0.234375, 0.765625, 0.234375, 0.765625)
        Button.texture:SetSize(16, 16)

        local highlight = Button:GetHighlightTexture()
        highlight:SetTexture([[Interface\Common\help-i]])
        highlight:SetTexCoord(0.234375, 0.765625, 0.234375, 0.765625)
        highlight:SetSize(16, 16)
    end
    function Skin.UIPanelSquareButton(Button)
        Button:SetSize(19.5, 19.5)
        Button:SetNormalTexture("")
        Button:SetHighlightTexture("")
        Button:SetPushedTexture("")
        Base.SetBackdrop(Button, Color.button)
    end
    function Skin.UIPanelLargeSilverButton(Button)
        local buttonName = Button:GetName()
        _G[buttonName.."Left"]:Hide()
        _G[buttonName.."Right"]:Hide()
        _G[buttonName.."Middle"]:Hide()
        for i = 3, 6 do
            _G.select(i, Button:GetRegions()):Hide()
        end
        Base.SetBackdrop(Button, Color.button)
        Base.SetHighlight(Button, "backdrop")
    end
    function Skin.GlowBoxTemplate(Frame)
        Frame.BG:Hide()

        Frame.GlowTopLeft:Hide()
        Frame.GlowTopRight:Hide()
        Frame.GlowBottomLeft:Hide()
        Frame.GlowBottomRight:Hide()

        Frame.GlowTop:Hide()
        Frame.GlowBottom:Hide()
        Frame.GlowLeft:Hide()
        Frame.GlowRight:Hide()

        Frame.ShadowTopLeft:Hide()
        Frame.ShadowTopRight:Hide()
        Frame.ShadowBottomLeft:Hide()
        Frame.ShadowBottomRight:Hide()

        Frame.ShadowTop:Hide()
        Frame.ShadowBottom:Hide()
        Frame.ShadowLeft:Hide()
        Frame.ShadowRight:Hide()
        Base.SetBackdrop(Frame, Color.yellow, 0.75)
    end
    function Skin.GlowBoxArrowTemplate(Frame, direction)
        if direction and direction == "Left" or direction == "Right" then
            Frame:SetSize(21, 53)
        end
        Base.SetTexture(Frame.Arrow, direction and "arrow"..direction or "arrowDown")
        Frame.Arrow:SetVertexColor(1, 1, 0)
        Frame.Glow:Hide()
    end
    function Skin.BaseBasicFrameTemplate(Frame)
        Frame.TopLeftCorner:Hide()
        Frame.TopRightCorner:Hide()
        Frame.TopBorder:SetTexture("")

        local titleText = Frame.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT")
        titleText:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Frame.BotLeftCorner:Hide()
        Frame.BotRightCorner:Hide()
        Frame.BottomBorder:Hide()
        Frame.LeftBorder:Hide()
        Frame.RightBorder:Hide()
        Base.SetBackdrop(Frame)

        Skin.UIPanelCloseButton(Frame.CloseButton)
        Frame.CloseButton:SetPoint("TOPRIGHT", -3, -3)
    end
    function Skin.BasicFrameTemplate(Frame)
        Skin.BaseBasicFrameTemplate(Frame)

        Frame.Bg:Hide()
        Frame.TitleBg:Hide()
        Frame.TopTileStreaks:SetTexture("")
    end
    function Skin.TranslucentFrameTemplate(Frame)
        Frame.Bg:Hide()

        Frame.TopLeftCorner:Hide()
        Frame.TopRightCorner:Hide()
        Frame.BottomLeftCorner:Hide()
        Frame.BottomRightCorner:Hide()

        Frame.TopBorder:Hide()
        Frame.BottomBorder:Hide()
        Frame.LeftBorder:Hide()
        Frame.RightBorder:Hide()
        Base.SetBackdrop(Frame)
    end
    function Skin.ThinGoldEdgeTemplate(Frame)
        local name = Frame:GetName()
        if not name then
            -- BlizzWTF: the BMAH Frame does not provide this template with a name
            local left, right, mid = Frame:GetRegions()
            left:Hide()
            right:Hide()
            mid:Hide()
        else
            _G[name.."Left"]:Hide()
            _G[name.."Right"]:Hide()
            _G[name.."Middle"]:Hide()
        end

        Base.SetBackdrop(Frame, Color.frame)
        Frame:SetBackdropBorderColor(Color.yellow)
    end
    function Skin.MainHelpPlateButton(Frame)
        Frame.Ring:Hide()

        local highlight = Frame:GetHighlightTexture()
        highlight:SetPoint("CENTER")
        highlight:SetSize(38, 38)
    end
end

function private.FrameXML.UIPanelTemplates()
end
