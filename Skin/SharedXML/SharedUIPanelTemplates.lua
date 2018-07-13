local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next tinsert

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do -- BlizzWTF: These are not templates, but they should be
    -- ExpandOrCollapse
    local function Hook_SetNormalTexture(self, texture)
        if self.settingTexture then return end
        self.settingTexture = true
        self:SetNormalTexture("")

        if texture and texture ~= "" then
            if texture:find("Plus") then
                self._auroraBG.plus:Show()
            elseif texture:find("Minus") then
                self._auroraBG.plus:Hide()
            end
            self._auroraBG:Show()
        else
            self._auroraBG:Hide()
        end
        self.settingTexture = nil
    end
    function Skin.ExpandOrCollapse(Button)
        Button:SetHighlightTexture("")
        Button:SetPushedTexture("")

        local bg = _G.CreateFrame("Frame", nil, Button)
        bg:SetSize(13, 13)
        bg:SetPoint("TOPLEFT", Button:GetNormalTexture(), 0, -2)
        Base.SetBackdrop(bg, Color.button)
        Button._auroraBG = bg

        Button._auroraHighlight = {}
        bg.minus = bg:CreateTexture(nil, "OVERLAY")
        bg.minus:SetPoint("TOPLEFT", 2, -6)
        bg.minus:SetPoint("BOTTOMRIGHT", -2, 6)
        bg.minus:SetColorTexture(1, 1, 1)
        _G.tinsert(Button._auroraHighlight, bg.minus)

        bg.plus = bg:CreateTexture(nil, "OVERLAY")
        bg.plus:SetPoint("TOPLEFT", 6, -2)
        bg.plus:SetPoint("BOTTOMRIGHT", -6, 2)
        bg.plus:SetColorTexture(1, 1, 1)
        _G.tinsert(Button._auroraHighlight, bg.plus)

        Base.SetHighlight(Button, "color")
        _G.hooksecurefunc(Button, "SetNormalTexture", Hook_SetNormalTexture)
    end

    -- Nav buttons
    local function NavButton(Button)
        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetHighlightTexture("")

        local bg = _G.CreateFrame("Frame", nil, Button)
        bg:SetPoint("TOPLEFT", 4, -5)
        bg:SetPoint("BOTTOMRIGHT", -5, 5)
        bg:SetFrameLevel(Button:GetFrameLevel())
        Base.SetBackdrop(bg, Color.button)
        Button._auroraBG = bg

        local disabled = Button:GetDisabledTexture()
        disabled:SetColorTexture(0, 0, 0, .3)
        disabled:SetDrawLayer("OVERLAY")
        disabled:SetAllPoints(bg)

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end
    function Skin.NavButtonPrevious(Button)
        NavButton(Button)

        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", Button._auroraBG, 7, -5)
        arrow:SetPoint("BOTTOMRIGHT", Button._auroraBG, -9, 4)
        Base.SetTexture(arrow, "arrowLeft")

        Button._auroraHighlight = {arrow}
        Base.SetHighlight(Button, "texture")
    end
    function Skin.NavButtonNext(Button)
        NavButton(Button)

        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", Button._auroraBG, 8, -5)
        arrow:SetPoint("BOTTOMRIGHT", Button._auroraBG, -8, 4)
        Base.SetTexture(arrow, "arrowRight")

        Button._auroraHighlight = {arrow}
        Base.SetHighlight(Button, "texture")
    end

    -- Scroll thumb
    local function Hook_Hide(self)
        self._auroraThumb:Hide()
    end
    local function Hook_Show(self)
        self._auroraThumb:Show()
    end
    function Skin.ScrollBarThumb(Texture)
        Texture:SetAlpha(0)
        Texture:SetSize(17, 24)
        _G.hooksecurefunc(Texture, "Hide", Hook_Hide)
        _G.hooksecurefunc(Texture, "Show", Hook_Show)

        local thumb = _G.CreateFrame("Frame", nil, Texture:GetParent())
        thumb:SetPoint("TOPLEFT", Texture, 0, -2)
        thumb:SetPoint("BOTTOMRIGHT", Texture, 0, 2)
        thumb:SetShown(Texture:IsShown())
        Base.SetBackdrop(thumb, Color.button)
        Texture._auroraThumb = thumb
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.lua ]]
    function Hook.PanelTemplates_GetTabWidth(tab)
        return tab:GetTextWidth() + Scale.Value(20)
    end
    function Hook.PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
        if not tab._auroraTabResize then return end
        local sideWidths = Scale.Value(20)
        local tabText = tab.Text or _G[tab:GetName().."Text"]

        local width, tabWidth
        local textWidth
        if absoluteTextSize then
            textWidth = absoluteTextSize
        else
            tabText:SetWidth(0)
            textWidth = tabText:GetStringWidth()
        end
        -- If there's an absolute size specified then use it
        if absoluteSize then
            if absoluteSize < sideWidths then
                width = Scale.Value(1)
                tabWidth = sideWidths
            else
                width = absoluteSize - sideWidths
                tabWidth = absoluteSize
            end
            Scale.RawSetWidth(tabText, width)
        else
            -- Otherwise try to use padding
            if padding then
                width = textWidth + Scale.Value(padding)
            else
                width = textWidth + Scale.Value(24)
            end
            -- If greater than the maxWidth then cap it
            if maxWidth and width > maxWidth then
                if padding then
                    width = maxWidth + Scale.Value(padding)
                else
                    width = maxWidth + Scale.Value(24)
                end
                Scale.RawSetWidth(tabText, width)
            else
                tabText:SetWidth(0)
            end
            if (minWidth and width < minWidth) then
                width = minWidth
            end
            tabWidth = width + sideWidths
        end

        Scale.RawSetWidth(tab, tabWidth)
    end
    function Hook.PanelTemplates_DeselectTab(tab)
        local text = tab.Text or _G[tab:GetName().."Text"]
        text:SetPoint("CENTER", tab, "CENTER")
    end
    function Hook.PanelTemplates_SelectTab(tab)
        local text = tab.Text or _G[tab:GetName().."Text"]
        text:SetPoint("CENTER", tab, "CENTER")
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.xml ]]
    function Skin.UIPanelCloseButton(Button)
        Button:SetSize(17, 17)
        Button:SetNormalTexture("")
        Button:SetHighlightTexture("")
        Button:SetPushedTexture("")

        local dis = Button:GetDisabledTexture()
        if dis then
            dis:SetColorTexture(0, 0, 0, .4)
            dis:SetDrawLayer("OVERLAY")
            dis:SetAllPoints()
        end

        Base.SetBackdrop(Button, Color.button)

        local cross = Button:CreateTexture(nil, "ARTWORK")
        cross:SetPoint("TOPLEFT", 4, -4)
        cross:SetPoint("BOTTOMRIGHT", -4, 4)
        Base.SetTexture(cross, "lineCross")

        Button._auroraHighlight = {cross}
        Base.SetHighlight(Button, "texture")
    end
    function Skin.UIPanelButtonTemplate(Button)
        Button.Left:SetAlpha(0)
        Button.Right:SetAlpha(0)
        Button.Middle:SetAlpha(0)
        Button:SetHighlightTexture("")

        Base.SetBackdrop(Button, Color.button)
        Base.SetHighlight(Button, "backdrop")

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end
    function Skin.UIPanelDynamicResizeButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end

    function Skin.UIRadioButtonTemplate(CheckButton)
        local bd = _G.CreateFrame("Frame", nil, CheckButton)
        bd:SetPoint("TOPLEFT", 4, -4)
        bd:SetPoint("BOTTOMRIGHT", -4, 4)
        bd:SetFrameLevel(CheckButton:GetFrameLevel())
        Base.SetBackdrop(bd, Color.button, 0.3)

        CheckButton:SetNormalTexture("")
        CheckButton:SetPushedTexture("")
        CheckButton:SetHighlightTexture("")

        local check = CheckButton:GetCheckedTexture()
        check:SetColorTexture(Color.highlight:GetRGB())
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bd, 1, -1)
        check:SetPoint("BOTTOMRIGHT", bd, -1, 1)

        CheckButton._auroraBDFrame = bd
        Base.SetHighlight(CheckButton, "backdrop")

        --[[ Scale ]]--
        CheckButton:SetSize(CheckButton:GetSize())
    end
    function Skin.UICheckButtonTemplate(CheckButton)
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

    function Skin.PortraitFrameTemplateNoCloseButton(Frame)
        local name = Util.GetName(Frame)

        Frame.Bg:Hide()
        if private.isPatch then
            Frame.TitleBg:Hide()
        else
            _G[name.."TitleBg"]:Hide()
        end
        Frame.portrait:SetAlpha(0)
        if private.isPatch then
            Frame.PortraitFrame:SetTexture("")
            Frame.TopRightCorner:Hide()
            Frame.TopLeftCorner:SetTexture("")
            Frame.TopBorder:SetTexture("")
        else
            Frame.portraitFrame:SetTexture("")
            _G[name.."TopRightCorner"]:Hide()
            Frame.topLeftCorner:Hide()
            Frame.topBorderBar:SetTexture("")
        end

        local titleText = Frame.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT")
        titleText:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Frame.TopTileStreaks:SetTexture("")
        if private.isPatch then
            Frame.BotLeftCorner:Hide()
            Frame.BotRightCorner:Hide()
            Frame.BottomBorder:Hide()
            Frame.LeftBorder:Hide()
            Frame.RightBorder:Hide()
        else
            _G[name.."BotLeftCorner"]:Hide()
            _G[name.."BotRightCorner"]:Hide()
            _G[name.."BottomBorder"]:Hide()
            Frame.leftBorderBar:Hide()
            _G[name.."RightBorder"]:Hide()
        end

        Base.SetBackdrop(Frame)

        --[[ Scale ]]--
        Frame:SetSize(Frame:GetSize())
    end
    function Skin.PortraitFrameTemplate(Frame)
        Skin.PortraitFrameTemplateNoCloseButton(Frame)
        Skin.UIPanelCloseButton(Frame.CloseButton)
        Frame.CloseButton:SetPoint("TOPRIGHT", -5, -5)
    end
    function Skin.InsetFrameTemplate(Frame)
        Frame.Bg:Hide()

        Frame.InsetBorderTopLeft:Hide()
        Frame.InsetBorderTopRight:Hide()

        Frame.InsetBorderBottomLeft:Hide()
        Frame.InsetBorderBottomRight:Hide()

        Frame.InsetBorderTop:Hide()
        Frame.InsetBorderBottom:Hide()
        Frame.InsetBorderLeft:Hide()
        Frame.InsetBorderRight:Hide()
    end
    function Skin.ButtonFrameTemplate(Frame)
        Skin.PortraitFrameTemplate(Frame)
        local name = Frame:GetName()

        _G[name.."BtnCornerLeft"]:SetTexture("")
        _G[name.."BtnCornerRight"]:SetTexture("")
        _G[name.."ButtonBottomBorder"]:SetTexture("")
        Skin.InsetFrameTemplate(Frame.Inset)

        --[[ Scale ]]--
        Frame.Inset:SetPoint("TOPLEFT", 4, -60)
        Frame.Inset:SetPoint("BOTTOMRIGHT", -6, 26)
    end

    function Skin.MagicButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)

        if Button.LeftSeparator then
            Button.LeftSeparator:Hide()
        end
        if Button.RightSeparator then
            Button.RightSeparator:Hide()
        end
    end

    function Skin.TooltipBorderedFrameTemplate(Frame)
        Frame.BorderTopLeft:Hide()
        Frame.BorderTopRight:Hide()

        Frame.BorderBottomLeft:Hide()
        Frame.BorderBottomRight:Hide()

        Frame.BorderTop:Hide()
        Frame.BorderBottom:Hide()
        Frame.BorderLeft:Hide()
        Frame.BorderRight:Hide()

        Frame.Background:Hide()
        Base.SetBackdrop(Frame)
    end

    function Skin.UIMenuButtonStretchTemplate(Button)
        Button:SetSize(Button:GetSize())

        Button.TopLeft:Hide()
        Button.TopRight:Hide()
        Button.BottomLeft:Hide()
        Button.BottomRight:Hide()
        Button.TopMiddle:Hide()
        Button.MiddleLeft:Hide()
        Button.MiddleRight:Hide()
        Button.BottomMiddle:Hide()
        Button.MiddleMiddle:Hide()
        Button:SetHighlightTexture("")

        local bd = _G.CreateFrame("Frame", nil, Button)
        bd:SetPoint("TOPLEFT", 1, -1)
        bd:SetPoint("BOTTOMRIGHT", -1, 1)
        bd:SetFrameLevel(Button:GetFrameLevel())
        Base.SetBackdrop(bd, Color.button, 0.3)

        Button._auroraBDFrame = bd
        Base.SetHighlight(Button, "backdrop")
    end

    function Skin.HorizontalSliderTemplate(Slider)
        Slider:SetBackdrop(nil)

        local bg = _G.CreateFrame("Frame", nil, Slider)
        bg:SetPoint("TOPLEFT", Slider, 5, -5)
        bg:SetPoint("BOTTOMRIGHT", Slider, -5, 5)
        bg:SetFrameLevel(Slider:GetFrameLevel())
        Base.SetBackdrop(bg, Color.button, 0.3)

        local thumbTexture = Slider:GetThumbTexture()
        thumbTexture:SetAlpha(0)
        thumbTexture:SetSize(8, 16)

        local thumb = _G.CreateFrame("Frame", nil, bg)
        thumb:SetPoint("TOPLEFT", thumbTexture, 0, 0)
        thumb:SetPoint("BOTTOMRIGHT", thumbTexture, 0, 0)
        Base.SetBackdrop(thumb, Color.button)
        Slider._auroraThumb = thumb

        --[[ Scale ]]--
        Slider:SetSize(Slider:GetSize())
    end

    function Skin.UIPanelStretchableArtScrollBarTemplate(Slider)
        Skin.UIPanelScrollBarTemplate(Slider)

        Slider.Top:Hide()
        Slider.Bottom:Hide()
        Slider.Middle:Hide()

        Slider.Background:Hide()
    end
    function Skin.UIPanelScrollBarTemplateLightBorder(Slider)
        local name = Slider:GetName()

        Skin.UIPanelScrollUpButtonTemplate(_G[name.."ScrollUpButton"])
        Skin.UIPanelScrollDownButtonTemplate(_G[name.."ScrollDownButton"])
        _G[name.."Border"]:SetBackdrop(nil)

        Skin.ScrollBarThumb(Slider:GetThumbTexture())

        --[[ Scale ]]--
        Slider:SetWidth(Slider:GetWidth())
    end
    function Skin.MinimalScrollBarTemplate(Slider)
        Slider.trackBG:Hide()
        if private.isPatch then
            Skin.UIPanelScrollUpButtonTemplate(Slider.ScrollUpButton)
            Skin.UIPanelScrollDownButtonTemplate(Slider.ScrollDownButton)
        else
            Skin.UIPanelScrollUpButtonTemplate(_G[Slider:GetName().."ScrollUpButton"])
            Skin.UIPanelScrollDownButtonTemplate(_G[Slider:GetName().."ScrollDownButton"])
        end

        Skin.ScrollBarThumb(Slider:GetThumbTexture())
    end
    function Skin.MinimalScrollFrameTemplate(ScrollFrame)
        Skin.MinimalScrollBarTemplate(ScrollFrame.ScrollBar)
    end
    function Skin.FauxScrollFrameTemplateLight(ScrollFrame)
        local name = ScrollFrame:GetName()

        local scrollBar = _G[name.."ScrollBar"]
        Skin.UIPanelScrollBarTemplateLightBorder(scrollBar)
        scrollBar:SetPoint("TOPLEFT", ScrollFrame, "TOPRIGHT", 2, -17)
        scrollBar:SetPoint("BOTTOMLEFT", ScrollFrame, "BOTTOMRIGHT", 2, 17)
    end
    function Skin.NumericInputSpinnerTemplate(EditBox)
        Skin.InputBoxTemplate(EditBox)
        EditBox:DisableDrawLayer("BACKGROUND")
        -- BlizzWTF: You use the template, but still create three new textures for the input border?

        Skin.NavButtonNext(EditBox.IncrementButton)
        EditBox.IncrementButton:SetPoint("LEFT", EditBox._auroraBG, "RIGHT", 3, 0)

        Skin.NavButtonPrevious(EditBox.DecrementButton)
        EditBox.DecrementButton:SetPoint("RIGHT", EditBox._auroraBG, "LEFT", -3, 0)
    end
    function Skin.InputBoxInstructionsTemplate(EditBox)
        Skin.InputBoxTemplate(EditBox)
    end
    function Skin.TabButtonTemplate(Button)
        Button.LeftDisabled:SetAlpha(0)
        Button.MiddleDisabled:SetAlpha(0)
        Button.RightDisabled:SetAlpha(0)
        Button.Left:SetAlpha(0)
        Button.Middle:SetAlpha(0)
        Button.Right:SetAlpha(0)

        Button.HighlightTexture:SetTexture("")
        Button._auroraTabResize = true
    end

    function Skin.MaximizeMinimizeButtonFrameTemplate(Frame)
        Frame:SetSize(17, 17)
        for _, name in next, {"MaximizeButton", "MinimizeButton"} do
            local Button = Frame[name]
            Button:SetSize(17, 17)
            Button:SetNormalTexture("")
            Button:SetPushedTexture("")
            Button:SetHighlightTexture("")
            Button:SetHitRectInsets(0, 0, 0, 0)

            Base.SetBackdrop(Button, Color.button)

            Button:ClearAllPoints()
            Button:SetPoint("CENTER")

            Button._auroraHighlight = {}

            local lineOfs = 4
            local line = Button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(0.5)
            line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
            line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
            tinsert(Button._auroraHighlight, line)

            local hline = Button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(7, 1)
            tinsert(Button._auroraHighlight, hline)

            local vline = Button:CreateTexture()
            vline:SetColorTexture(1, 1, 1)
            vline:SetSize(1, 7)
            tinsert(Button._auroraHighlight, vline)

            if name == "MaximizeButton" then
                hline:SetPoint("TOP", 1, -4)
                vline:SetPoint("RIGHT", -4, 1)
            else
                hline:SetPoint("BOTTOM", -1, 4)
                vline:SetPoint("LEFT", 4, -1)
            end

            Base.SetHighlight(Button, "color")
        end
    end
    function Skin.ColumnDisplayTemplate(Frame)
        _G.hooksecurefunc(Frame.columnHeaders, "Acquire", Hook.ObjectPoolMixin_Acquire)

        Frame.Background:Hide()
        Frame.TopTileStreaks:Hide()
    end
    function Skin.ColumnDisplayButtonTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
    end
end

function private.SharedXML.SharedUIPanelTemplates()
    _G.hooksecurefunc("PanelTemplates_TabResize", Hook.PanelTemplates_TabResize)
    _G.hooksecurefunc("PanelTemplates_DeselectTab", Hook.PanelTemplates_DeselectTab)
    _G.hooksecurefunc("PanelTemplates_SelectTab", Hook.PanelTemplates_SelectTab)
end
