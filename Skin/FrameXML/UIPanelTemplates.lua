local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\UIPanelTemplates.lua ]]
    function Hook.SquareButton_SetIcon(self, name)
        name = name:upper()
        if name == "LEFT" then
            self.icon:SetPoint("TOPLEFT", 7, -4)
            self.icon:SetPoint("BOTTOMRIGHT", -7, 4)
            Base.SetTexture(self.icon, "arrowLeft")
        elseif name == "RIGHT" then
            self.icon:SetPoint("TOPLEFT", 7, -4)
            self.icon:SetPoint("BOTTOMRIGHT", -7, 4)
            Base.SetTexture(self.icon, "arrowRight")
        elseif name == "UP" then
            self.icon:SetPoint("TOPLEFT", 4, -7)
            self.icon:SetPoint("BOTTOMRIGHT", -4, 7)
            Base.SetTexture(self.icon, "arrowUp")
        elseif name == "DOWN" then
            self.icon:SetPoint("TOPLEFT", 4, -7)
            self.icon:SetPoint("BOTTOMRIGHT", -4, 7)
            Base.SetTexture(self.icon, "arrowDown")
        end
    end
end


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
        Button:SetSize(20, 20)
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

        Base.SetBackdrop(Frame, Color.yellow:Lightness(-0.8), 0.75)
        Frame:SetBackdropBorderColor(Color.yellow)
    end
    function Skin.GlowBoxArrowTemplate(Frame, direction)
        direction = direction or "Down"
        if direction == "Left" or direction == "Right" then
            Frame:SetSize(21, 53)
        else
            Frame:SetSize(53, 21)
        end

        Base.SetTexture(Frame.Arrow, "arrow"..direction)
        Frame.Arrow:SetVertexColor(1, 1, 0)
        Frame.Glow:Hide()
    end

    --[[
        SetClampedTextureRotation(self.Arrow.Arrow, 90) -- Left
        SetClampedTextureRotation(self.Arrow.Arrow, 180) -- Up
        SetClampedTextureRotation(self.Arrow.Arrow, 270) -- Right
    ]]
    -- BlizzWTF: This should be a template
    function Skin.GlowBoxFrame(Frame, direction)
        if Frame.BigText then
            -- BlizzWTF: Why not just use GlowBoxArrowTemplate?
            local Arrow = _G.CreateFrame("Frame", nil, Frame)
            Arrow.Arrow = Frame["Arrow"..direction] or Frame["Arrow"..direction:upper()]
            Arrow.Arrow:SetParent(Arrow)
            Arrow.Glow = Frame["ArrowGlow"..direction] or Frame["ArrowGlow"..direction:upper()]
            Arrow.Glow:SetParent(Arrow)

            Frame.Arrow = Arrow
            Frame.Text = Frame.BigText
        end
        Skin.GlowBoxTemplate(Frame)
        Skin.UIPanelCloseButton(Frame.CloseButton)

        direction = direction or "Down"
        local point = direction:upper()
        if point == "UP" then
            point = "TOP"
        elseif point == "DOWN" then
            point = "BOTTOM"
        end

        Skin.GlowBoxArrowTemplate(Frame.Arrow, direction)
        Frame.Arrow:ClearAllPoints()
        Frame.Arrow:SetPoint(Util.OpposingSide[point], Frame, point)
    end

    function Skin.ThinBorderTemplate(Frame)
        local edge = private.backdrop.edgeSize
        Frame.TopLeft:SetSize(edge, edge)
        Frame.TopRight:SetSize(edge, edge)
        Frame.BottomLeft:SetSize(edge, edge)
        Frame.BottomRight:SetSize(edge, edge)

        Frame.TopLeft:SetPoint("TOPLEFT")
        Frame.TopRight:SetPoint("TOPRIGHT")
        Frame.BottomLeft:SetPoint("BOTTOMLEFT")
        Frame.BottomRight:SetPoint("BOTTOMRIGHT")
    end
    function Skin.GlowBorderTemplate(Frame)
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
    end
    function Skin.BasicFrameTemplate(Frame)
        Skin.BaseBasicFrameTemplate(Frame)

        Frame.Bg:Hide()
        Frame.TitleBg:Hide()
        Frame.TopTileStreaks:SetTexture("")
    end

    function Skin.InsetFrameTemplate2(Frame)
        Frame.TopLeftCorner:Hide()
        Frame.TopRightCorner:Hide()
        Frame.BotLeftCorner:Hide()

        Frame.BotRightCorner:Hide()
        Frame.TopBorder:Hide()
        Frame.BottomBorder:Hide()

        Frame.LeftBorder:Hide()
        Frame.RightBorder:Hide()
    end
    function Skin.InsetFrameTemplate3(Frame)
        Frame.BorderTopRight:Hide()
        Frame.BorderBottomRight:Hide()
        Frame.BorderRightMiddle:Hide()

        Frame.BorderTopLeft:Hide()
        Frame.BorderBottomLeft:Hide()
        Frame.BorderLeftMiddle:Hide()

        Frame.BorderTopMiddle:Hide()
        Frame.BorderBottomMiddle:Hide()

        Frame.Bg:Hide()
    end

    function Skin.EtherealFrameTemplate(Frame)
        Skin.PortraitFrameTemplate(Frame)

        Frame.CornerTL:Hide()
        Frame.CornerTR:Hide()
        Frame.CornerBL:Hide()
        Frame.CornerBR:Hide()

        local name = Frame:GetName()
        _G[name.."LeftEdge"]:Hide()
        _G[name.."RightEdge"]:Hide()
        _G[name.."TopEdge"]:Hide()
        _G[name.."BottomEdge"]:Hide()

        local bg = select(23, Frame:GetRegions())
        bg:ClearAllPoints()
        bg:SetPoint("TOPLEFT", -50, 25)
        bg:SetPoint("BOTTOMRIGHT")
        bg:SetTexture([[Interface\Transmogrify\EtherealLines]], true, true)
        bg:SetHorizTile(true)
        bg:SetVertTile(true)
        bg:SetAlpha(0.5)
    end
    function Skin.HorizontalBarTemplate(Frame)
        Frame:SetHeight(1)
        local name = Frame:GetName()
        _G[name.."Bg"]:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)

        _G[name.."TopLeftCorner"]:Hide()
        _G[name.."TopRightCorner"]:Hide()
        _G[name.."BotLeftCorner"]:Hide()
        _G[name.."BotRightCorner"]:Hide()
        _G[name.."TopBorder"]:Hide()
        _G[name.."BottomBorder"]:Hide()
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
        local name = Util.GetName(Frame)
        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()

        Base.SetBackdrop(Frame, Color.frame)
        Frame:SetBackdropBorderColor(Color.yellow)
    end

    function Skin.UIExpandingButtonTemplate(Button)
        Skin.UIPanelSquareButton(Button)
    end
end

function private.FrameXML.UIPanelTemplates()
    _G.hooksecurefunc("SquareButton_SetIcon", Hook.SquareButton_SetIcon)
end
