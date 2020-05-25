local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next tinsert type

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do -- BlizzWTF: These are not templates, but they should be
    do -- ExpandOrCollapse
        local function Hook_SetHighlightTexture(self, texture)
            if self.settingHighlight then return end
            self.settingHighlight = true
            self:SetHighlightTexture("")
            self.settingHighlight = nil
        end
        local function Hook_SetNormalTexture(self, texture)
            if self.settingTexture then return end
            self.settingTexture = true
            self:SetNormalTexture("")

            if texture == 130838 then
                texture = "Plus"
            elseif texture == 130821 then
                texture = "Minus"
            end

            if texture and texture ~= "" then
                if texture:find("Plus") then
                    self._plus:Show()
                elseif texture:find("Minus") then
                    self._plus:Hide()
                end
                self:SetBackdrop(true)
            else
                self:SetBackdrop(false)
            end
            self.settingTexture = nil
        end
        function Skin.ExpandOrCollapse(Button)
            Skin.FrameTypeButton(Button)

            local bg = Button:GetBackdropTexture("bg")
            local minus = Button:CreateTexture(nil, "OVERLAY")
            minus:SetColorTexture(1, 1, 1)
            minus:SetSize(9, 1)
            minus:SetPoint("TOPLEFT", bg, 2, -6)
            Button._minus = minus

            local plus = Button:CreateTexture(nil, "OVERLAY")
            plus:SetColorTexture(1, 1, 1)
            plus:SetSize(1, 9)
            plus:SetPoint("TOPLEFT", bg, 6, -2)
            Button._plus = plus

            Button._auroraTextures = {
                minus,
                plus
            }
            _G.hooksecurefunc(Button, "SetNormalTexture", Hook_SetNormalTexture)
            _G.hooksecurefunc(Button, "SetHighlightTexture", Hook_SetHighlightTexture)
        end
    end

    do -- Nav buttons
        local function NavButton(Button)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 5,
                right = 5,
                top = 5,
                bottom = 5,
            })

            local bg = Button:GetBackdropTexture("bg")
            local arrow = Button:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 8, -5)
            arrow:SetPoint("BOTTOMRIGHT", bg, -8, 5)
            Button._auroraTextures = {arrow}

            return arrow
        end
        function Skin.NavButtonPrevious(Button)
            local arrow = NavButton(Button)
            Base.SetTexture(arrow, "arrowLeft")
        end
        function Skin.NavButtonNext(Button)
            local arrow = NavButton(Button)
            Base.SetTexture(arrow, "arrowRight")
        end
    end

    do -- Side Tabs
        local function Hook_SetChecked(self, isChecked)
            -- Set the selected tab
            if isChecked then
                self._auroraIconBG:SetColorTexture(Color.yellow:GetRGB())
            else
                self._auroraIconBG:SetColorTexture(Color.black:GetRGB())
            end
        end
        function Skin.SideTabTemplate(CheckButton)
            _G.hooksecurefunc(CheckButton, "SetChecked", Hook_SetChecked)
            CheckButton:GetRegions():Hide()

            local icon = CheckButton.Icon or CheckButton:GetNormalTexture()
            CheckButton._auroraIconBG = Base.CropIcon(icon, CheckButton)
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
    end

    do -- Scroll thumb
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

    do -- MinimizeButton
        function Skin.MinimizeButton(Button)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 4,
                right = 11,
                top = 10,
                bottom = 5,
            })

            local bg = Button:GetBackdropTexture("bg")
            local hline = Button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(11, 1)
            hline:SetPoint("BOTTOMLEFT", bg, 3, 3)
            Button._auroraTextures = {hline}
        end
    end
end

do -- Basic frame type skins
    do -- Button
        local disabledColor = Color.Lightness(Color.button, -0.3)
        local function Hook_Enable(self)
            Base.SetBackdropColor(self, self._enabledColor or Color.button)
            if self._auroraTextures then
                for _, texture in next, self._auroraTextures do
                    texture:SetVertexColor(Color.white:GetRGB())
                end
            end
        end
        local function Hook_Disable(self)
            Base.SetBackdropColor(self, self._disabledColor or disabledColor)
            if self._auroraTextures then
                for _, texture in next, self._auroraTextures do
                    texture:SetVertexColor(Color.gray:GetRGB())
                end
            end
        end
        function Skin.FrameTypeButton(Button, OnEnter, OnLeave)
            _G.hooksecurefunc(Button, "Enable", Hook_Enable)
            _G.hooksecurefunc(Button, "Disable", Hook_Disable)

            Button:SetNormalTexture("")
            Button:SetPushedTexture("")
            Button:SetHighlightTexture("")
            Button:SetDisabledTexture("")

            function Button:SetButtonColor(color)
                self._enabledColor = color
                self._disabledColor = Color.Lightness(color, -0.3)

                if self:IsEnabled() then
                    Base.SetBackdropColor(self, color)
                else
                    Base.SetBackdropColor(self, self._disabledColor)
                end
            end
            function Button:GetButtonColor()
                return self._enabledColor or Color.button, self._disabledColor or disabledColor
            end

            Base.SetBackdrop(Button, Color.button)
            Base.SetHighlight(Button, "backdrop", OnEnter, OnLeave)
        end
    end
    do -- CheckButton
        function Skin.FrameTypeCheckButton(CheckButton)
            CheckButton:SetNormalTexture("")
            CheckButton:SetPushedTexture("")
            CheckButton:SetHighlightTexture("")

            Base.SetBackdrop(CheckButton, Color.button, 0.3)
            Base.SetHighlight(CheckButton, "backdrop")
        end
    end
    do -- EditBox
        function Skin.FrameTypeEditBox(EditBox)
            Base.SetBackdrop(EditBox, Color.frame)
            EditBox:SetBackdropBorderColor(Color.button)
        end
    end
    do -- StatusBar
        local atlasColors = {
            ["_honorsystem-bar-fill"] = Color.Create(1.0, 0.24, 0),
            ["_islands-queue-progressbar-fill"] = private.AZERITE_COLORS[2],
            ["_islands-queue-progressbar-fill_2"] = private.AZERITE_COLORS[1],
            ["_pvpqueue-conquestbar-fill-yellow"] = Color.Create(.9529, 0.7569, 0.1804),
            ["ChallengeMode-TimerFill"] = Color.Create(0.1490, 0.6196, 1.0),
            ["objectivewidget-bar-fill-left"] = Color.Create(0.1176, 0.2823, 0.7176),
            ["objectivewidget-bar-fill-neutral"] = Color.Create(0.3608, 0.2980, 0.0),
            ["objectivewidget-bar-fill-right"] = Color.Create(0.5765, 0.0, 0.0),
            ["UI-Frame-Bar-Fill-Green"] = Color.Create(0.0941, 0.7647, 0.0157),
            ["UI-Frame-Bar-Fill-Red"] = Color.Create(0.7725, 0.0, 0.0),
            ["UI-Frame-Bar-Fill-Yellow"] = Color.Create(0.9608, 0.6314, 0.0),
            ["UI-Frame-Bar-Fill-Blue"] = Color.Create(0.0667, 0.4470, 0.8745),
        }
        local function Hook_SetStatusBarAtlas(self, atlas)
            if atlasColors[atlas] then
                local texture = self:GetStatusBarTexture()
                texture:SetTexture(private.textures.plain)
                if atlasColors[atlas.."_2"] then
                    local r, g, b = atlasColors[atlas]:GetRGB()
                    local r2, g2, b2 = atlasColors[atlas.."_2"]:GetRGB()
                    texture:SetGradient("VERTICAL", r, g, b, r2, g2, b2)
                else
                    texture:SetVertexColor(atlasColors[atlas]:GetRGB())
                end
            else
                private.debug("SetStatusBarAtlas missing atlas", atlas)
            end
        end
        local function Hook_SetStatusBarColor(self, r, g, b)
            self:GetStatusBarTexture():SetVertexColor(r, g, b)
        end
        function Skin.FrameTypeStatusBar(StatusBar)
            _G.hooksecurefunc(StatusBar, "SetStatusBarAtlas", Hook_SetStatusBarAtlas)
            _G.hooksecurefunc(StatusBar, "SetStatusBarColor", Hook_SetStatusBarColor)

            Base.SetBackdrop(StatusBar, Color.button, Color.frame.a)
            StatusBar:SetBackdropOption("offsets", {
                left = -1,
                right = -2,
                top = -1,
                bottom = -1,
            })

            local atlas = StatusBar:GetStatusBarAtlas()
            local red, green, blue = StatusBar:GetStatusBarColor()

            if not StatusBar:GetStatusBarTexture() then
                StatusBar:SetStatusBarTexture(private.textures.plain)
            end
            Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")

            if atlas then
                Hook_SetStatusBarAtlas(StatusBar, atlas)
            else
                Hook_SetStatusBarColor(StatusBar, red, green, blue)
            end
        end
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.lua ]]
    do --[[ PortraitFrame ]]
        Hook.PortraitFrameMixin = {}
        function Hook.PortraitFrameMixin:SetBorder(layoutName)
            if not self.NineSlice._auroraBackdrop then return end
            self.NineSlice:SetBackdrop(private.backdrop)
        end
    end
    do --[[ SharedUIPanelTemplates ]]
        function Hook.UIPanelCloseButton_SetBorderAtlas(self, atlas, xOffset, yOffset, textureKit)
            self.Border:SetAlpha(0)
        end

        local resizing = false
        function Hook.PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
            if not tab._auroraTabResize or resizing then return end

            resizing = true
            local left = tab.Left or tab.leftTexture or _G[tab:GetName().."Left"]
            left:SetWidth(10)
            _G.PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
            resizing = false
        end
        function Hook.PanelTemplates_DeselectTab(tab)
            local text = tab.Text or _G[tab:GetName().."Text"]
            text:SetPoint("CENTER", tab, "CENTER")
        end
        function Hook.PanelTemplates_SelectTab(tab)
            local text = tab.Text or _G[tab:GetName().."Text"]
            text:SetPoint("CENTER", tab, "CENTER")
            if tab._returnColor then
                Base.SetBackdropColor(tab, tab._returnColor)
            end
        end

        Hook.SquareIconButtonMixin = {}
        function Hook.SquareIconButtonMixin:OnMouseDown()
            if self:IsEnabled() then
                self.Icon:SetPoint("CENTER", -1, -1)
            end
        end
        function Hook.SquareIconButtonMixin:OnMouseUp()
            self.Icon:SetPoint("CENTER", 0, 0)
        end

        Hook.ThreeSliceButtonMixin = {}
        function Hook.ThreeSliceButtonMixin:UpdateButton(buttonState)
            self.Left:SetTexture("")
            self.Center:SetTexture("")
            self.Right:SetTexture("")
        end
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.xml ]]
    function Skin.UIPanelCloseButton(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 4,
            right = 11,
            top = 10,
            bottom = 5,
        })

        local bg = Button:GetBackdropTexture("bg")
        local cross = {}
        for i = 1, 2 do
            local line = Button:CreateLine(nil, "ARTWORK")
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(1.2)
            line:Show()
            if i == 1 then
                line:SetStartPoint("TOPLEFT", bg, 3.6, -3)
                line:SetEndPoint("BOTTOMRIGHT", bg, -3, 3)
            else
                line:SetStartPoint("TOPRIGHT", bg, -3, -3)
                line:SetEndPoint("BOTTOMLEFT", bg, 3.6, 3)
            end
            tinsert(cross, line)
        end

        Button._auroraTextures = cross
    end
    function Skin.UIPanelGoldButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 15,
            right = 18,
            top = 1,
            bottom = 5,
        })
        Button:SetBackdropBorderColor(Color.yellow)

        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
    end
    function Skin.UIPanelButtonTemplate(Button)
        Skin.UIPanelButtonNoTooltipTemplate(Button)
    end
    function Skin.UIPanelDynamicResizeButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end

    function Skin.UIRadioButtonTemplate(CheckButton)
        Skin.FrameTypeCheckButton(CheckButton)
        CheckButton:SetBackdropOption("offsets", {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4,
        })

        local bg = CheckButton:GetBackdropTexture("bg")
        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bg, 1, -1)
        check:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        check:SetColorTexture(Color.highlight:GetRGB())
    end
    function Skin.UICheckButtonTemplate(CheckButton)
        Skin.FrameTypeCheckButton(CheckButton)
        CheckButton:SetBackdropOption("offsets", {
            left = 6,
            right = 6,
            top = 6,
            bottom = 6,
        })

        local bg = CheckButton:GetBackdropTexture("bg")
        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bg, -6, 6)
        check:SetPoint("BOTTOMRIGHT", bg, 6, -6)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        local disabled = CheckButton:GetDisabledCheckedTexture()
        disabled:SetAllPoints(check)
    end

    function Skin.NineSlicePanelTemplate(Frame)
        Frame._auroraNineSlice = true
        local layout = _G.NineSliceUtil.GetLayout(Frame:GetFrameLayoutType())
        if layout then
            Hook.NineSliceUtil.ApplyLayout(Frame, layout)
        end
    end
    function Skin.InsetFrameTemplate(Frame)
        if private.isRetail then
            Frame.NineSlice.Center = Frame.Bg
            Skin.NineSlicePanelTemplate(Frame.NineSlice)
        else
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
    end
    function Skin.DialogBorderNoCenterTemplate(Frame)
        Skin.NineSlicePanelTemplate(Frame)
        Frame:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, 0)
    end
    function Skin.DialogBorderTemplate(Frame)
        if private.isRetail then
            Frame.Center = Frame.Bg
            Skin.DialogBorderNoCenterTemplate(Frame)
        end

        Base.SetBackdrop(Frame)
    end
    function Skin.DialogBorderDarkTemplate(Frame)
        if private.isRetail then
            Frame.Center = Frame.Bg
            Skin.DialogBorderNoCenterTemplate(Frame)
        else
            Base.SetBackdrop(Frame)
        end

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, 0.87)
    end
    function Skin.DialogBorderTranslucentTemplate(Frame)
        if private.isRetail then
            Frame.Center = Frame.Bg
            Skin.DialogBorderNoCenterTemplate(Frame)
        else
            Base.SetBackdrop(Frame)
        end

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, 0.8)
    end
    function Skin.DialogBorderOpaqueTemplate(Frame)
        if private.isRetail then
            Frame.Center = Frame.Bg
            Skin.DialogBorderNoCenterTemplate(Frame)
        else
            Base.SetBackdrop(Frame)
        end

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, 1)
    end

    function Skin.DialogHeaderTemplate(Frame)
        Frame.LeftBG:Hide()
        Frame.RightBG:Hide()
        Frame.CenterBG:Hide()

        Frame.Text:SetPoint("TOP", 0, -17)
        Frame.Text:SetPoint("BOTTOM", Frame, "TOP", 0, -(private.FRAME_TITLE_HEIGHT + 17))
    end

    function Skin.SimplePanelTemplate(Frame)
        Skin.InsetFrameTemplate(Frame.Inset)
        Frame.NineSlice.Center = Frame.Bg
        Skin.NineSlicePanelTemplate(Frame.NineSlice)
    end

    function Skin.PortraitFrameTemplateNoCloseButton(Frame)
        if private.isRetail then
            Util.Mixin(Frame, Hook.PortraitFrameMixin)

            Frame.TitleBg:SetAlpha(0)
            Frame.portrait:SetAlpha(0)

            local titleText = Frame.TitleText
            titleText:ClearAllPoints()
            titleText:SetPoint("TOPLEFT", Frame.Bg)
            titleText:SetPoint("BOTTOMRIGHT", Frame.Bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

            Frame.TopTileStreaks:SetTexture("")

            Frame.NineSlice.Center = Frame.Bg
            Skin.NineSlicePanelTemplate(Frame.NineSlice)
        else
            Frame.Bg:Hide()

            Frame.TitleBg:Hide()
            Frame.portrait:SetAlpha(0)
            Frame.PortraitFrame:SetTexture("")
            Frame.TopRightCorner:Hide()
            Frame.TopLeftCorner:SetTexture("")
            Frame.TopBorder:SetTexture("")

            local titleText = Frame.TitleText
            titleText:ClearAllPoints()
            titleText:SetPoint("TOPLEFT")
            titleText:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

            Frame.TopTileStreaks:SetTexture("")
            Frame.BotLeftCorner:Hide()
            Frame.BotRightCorner:Hide()
            Frame.BottomBorder:Hide()
            Frame.LeftBorder:Hide()
            Frame.RightBorder:Hide()

            Base.SetBackdrop(Frame)
        end
    end
    function Skin.PortraitFrameTemplate(Frame)
        Skin.PortraitFrameTemplateNoCloseButton(Frame)
        Skin.UIPanelCloseButton(Frame.CloseButton)

        if private.isRetail then
            Frame.CloseButton:SetPoint("TOPRIGHT", Frame.Bg, 5.6, 5)
        else
            local bg = Frame:GetBackdropTexture("bg")
            Frame.CloseButton:SetPoint("TOPRIGHT", bg, 5.6, 5)
        end
    end
    function Skin.ButtonFrameTemplate(Frame)
        Skin.PortraitFrameTemplate(Frame)

        if private.isClassic then
            local name = Frame:GetName()
            _G[name.."BtnCornerLeft"]:SetAlpha(0)
            _G[name.."BtnCornerRight"]:SetAlpha(0)
            _G[name.."ButtonBottomBorder"]:SetAlpha(0)
        end

        Skin.InsetFrameTemplate(Frame.Inset)
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
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 2,
            right = 2,
            top = 2,
            bottom = 2,
        })

        Button.TopLeft:Hide()
        Button.TopRight:Hide()
        Button.BottomLeft:Hide()
        Button.BottomRight:Hide()
        Button.TopMiddle:Hide()
        Button.MiddleLeft:Hide()
        Button.MiddleRight:Hide()
        Button.BottomMiddle:Hide()
        Button.MiddleMiddle:Hide()

        local bg = Button:GetBackdropTexture("bg")
        Button.Text:SetPoint("CENTER", bg, 0, 0)
    end

    function Skin.HorizontalSliderTemplate(Slider)
        Base.SetBackdrop(Slider, Color.frame)
        Slider:SetBackdropBorderColor(Color.button)
        Slider:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })

        local thumbTexture = Slider:GetThumbTexture()
        thumbTexture:SetAlpha(0)
        thumbTexture:SetSize(8, 16)

        local thumb = _G.CreateFrame("Frame", nil, Slider)
        thumb:SetPoint("TOPLEFT", thumbTexture, 0, 0)
        thumb:SetPoint("BOTTOMRIGHT", thumbTexture, 0, 0)
        Base.SetBackdrop(thumb, Color.button)
        Slider._auroraThumb = thumb
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
    end
    function Skin.UIPanelScrollFrameTemplate2(Slider)
        Skin.UIPanelScrollFrameTemplate(Slider)

        local name = Slider:GetName()
        _G[name.."Top"]:SetAlpha(0)
        _G[name.."Bottom"]:SetAlpha(0)
    end
    function Skin.MinimalScrollBarTemplate(Slider)
        Slider.trackBG:Hide()
        Skin.UIPanelScrollUpButtonTemplate(Slider.ScrollUpButton)
        Skin.UIPanelScrollDownButtonTemplate(Slider.ScrollDownButton)

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

    function Skin.SpinnerButton(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        })
        local buttonBG = Button:GetBackdropTexture("bg")
        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", buttonBG, 6, -3)
        arrow:SetPoint("BOTTOMRIGHT", buttonBG, -6, 3)
        Button._auroraTextures = {arrow}
    end
    function Skin.NumericInputSpinnerTemplate(EditBox)
        Skin.InputBoxTemplate(EditBox)

        -- BlizzWTF: You use the template, but still create three new textures for the input border?
        local _, _, left, right, mid = EditBox:GetRegions()
        left:Hide()
        right:Hide()
        mid:Hide()

        local bg = EditBox:GetBackdropTexture("bg")
        Skin.SpinnerButton(EditBox.DecrementButton)
        Base.SetTexture(EditBox.DecrementButton._auroraTextures[1], "arrowLeft")
        EditBox.DecrementButton:ClearAllPoints()
        EditBox.DecrementButton:SetPoint("RIGHT", bg, "LEFT", 0, 0)

        Skin.SpinnerButton(EditBox.IncrementButton)
        Base.SetTexture(EditBox.IncrementButton._auroraTextures[1], "arrowRight")
        EditBox.IncrementButton:ClearAllPoints()
        EditBox.IncrementButton:SetPoint("LEFT", bg, "RIGHT", 0, 0)
    end
    function Skin.InputBoxInstructionsTemplate(EditBox)
        Skin.InputBoxTemplate(EditBox)
    end
    function Skin.SearchBoxTemplate(EditBox)
        Skin.InputBoxInstructionsTemplate(EditBox)
        EditBox.searchIcon:SetPoint("LEFT", 3, -1)
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
        for _, name in next, {"MaximizeButton", "MinimizeButton"} do
            local Button = Frame[name]
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 4,
                right = 11,
                top = 10,
                bottom = 5,
            })


            local bg = Button:GetBackdropTexture("bg")
            local line = Button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(1.2)
            line:SetStartPoint("TOPRIGHT", bg, -3, -3)
            line:SetEndPoint("BOTTOMLEFT", bg, 3.6, 3)

            local hline = Button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(7, 1)

            local vline = Button:CreateTexture()
            vline:SetColorTexture(1, 1, 1)
            vline:SetSize(1, 7)

            if name == "MaximizeButton" then
                hline:SetPoint("TOP", bg, 1, -3)
                vline:SetPoint("RIGHT", bg, -3, 1)
            else
                hline:SetPoint("BOTTOM", bg, -1, 3)
                vline:SetPoint("LEFT", bg, 3, -1)
            end

            Button._auroraTextures = {
                line,
                hline,
                vline,
            }
        end
    end
    function Skin.ColumnDisplayTemplate(Frame)
        Frame.Background:Hide()
        Frame.TopTileStreaks:Hide()
    end
    function Skin.ColumnDisplayButtonShortTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
    end
    function Skin.ColumnDisplayButtonNoScriptsTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
    end
    function Skin.ColumnDisplayButtonTemplate(Button)
        Skin.ColumnDisplayButtonNoScriptsTemplate(Button)
    end
    function Skin.SquareIconButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })

        Button.Icon:SetPoint("CENTER", 0, 0)
    end
    function Skin.RefreshButtonTemplate(Button)
        Skin.SquareIconButtonTemplate(Button)
    end

    function Skin.ThreeSliceButtonTemplate(Button)
        Util.Mixin(Button, Hook.ThreeSliceButtonMixin)
        Button:HookScript("OnShow", function()
            -- Textures re-appear when "OnShow" fires, so wait a frame after to hide them again
            _G.C_Timer.After(0, function()
                Hook.ThreeSliceButtonMixin.UpdateButton(Button, "OnShow")
            end)
        end)
        Skin.FrameTypeButton(Button)
    end
    function Skin.BigRedThreeSliceButtonTemplate(Button)
        Skin.ThreeSliceButtonTemplate(Button)
    end
    function Skin.SharedButtonTemplate(Button)
        Skin.BigRedThreeSliceButtonTemplate(Button)
    end
    function Skin.SharedButtonSmallTemplate(Button)
        Skin.BigRedThreeSliceButtonTemplate(Button)
    end
end

function private.SharedXML.SharedUIPanelTemplates()
    if private.isRetail then
        _G.hooksecurefunc("UIPanelCloseButton_SetBorderAtlas", Hook.UIPanelCloseButton_SetBorderAtlas)

        Util.Mixin(_G.SquareIconButtonMixin, Hook.SquareIconButtonMixin)
    end

    _G.hooksecurefunc("PanelTemplates_TabResize", Hook.PanelTemplates_TabResize)
    _G.hooksecurefunc("PanelTemplates_DeselectTab", Hook.PanelTemplates_DeselectTab)
    _G.hooksecurefunc("PanelTemplates_SelectTab", Hook.PanelTemplates_SelectTab)
end
