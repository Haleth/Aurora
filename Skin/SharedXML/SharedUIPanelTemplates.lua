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

            Base.SetHighlight(Button, "texture")
            _G.hooksecurefunc(Button, "SetNormalTexture", Hook_SetNormalTexture)
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
end

do -- Basic frame type skins
    do -- Button
        local disabledColor = Color.Lightness(Color.button, -0.3)
        local function Hook_Enable(self)
            Base.SetBackdrop(self, Color.button)
        end
        local function Hook_Disable(self)
            Base.SetBackdrop(self, disabledColor)
        end
        function Skin.FrameTypeButton(Button)
            _G.hooksecurefunc(Button, "Enable", Hook_Enable)
            _G.hooksecurefunc(Button, "Disable", Hook_Disable)

            Button:SetNormalTexture("")
            Button:SetPushedTexture("")
            Button:SetHighlightTexture("")
            Button:SetDisabledTexture("")

            Base.SetBackdrop(Button, Color.button)
            Base.SetHighlight(Button, "backdrop")
        end
    end
    do -- StatusBar
        local atlasColors = {
            ["_honorsystem-bar-fill"] = Color.Create(1.0, 0.24, 0),
            ["_islands-queue-progressbar-fill"] = Color.Create(0.7098, 0.5019, 0.1725),
            ["_islands-queue-progressbar-fill_2"] = Color.Create(0.3765, 0.8157, 0.9098),
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
                texture:SetTexture([[Interface\Buttons\WHITE8x8]])
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
            local bg = StatusBar:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", -1, 1)
            bg:SetPoint("BOTTOMRIGHT", 1, -1)

            local atlas = StatusBar:GetStatusBarAtlas()
            local red, green, blue = StatusBar:GetStatusBarColor()

            if not StatusBar:GetStatusBarTexture() then
                StatusBar:SetStatusBarTexture([[Interface\Buttons\WHITE8x8]])
            end
            Base.SetTexture(StatusBar:GetStatusBarTexture(), "gradientUp")

            if atlas then
                Hook_SetStatusBarAtlas(StatusBar, atlas)
            else
                Hook_SetStatusBarColor(StatusBar, red, green, blue)
            end
        end
    end
    do -- EditBox
        function Skin.FrameTypeEditBox(EditBox)
            Base.SetBackdrop(EditBox, Color.frame)
            EditBox:SetBackdropBorderColor(Color.button)
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
        local resizing = false
        function Hook.PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
            if not tab._auroraTabResize or resizing then return end

            resizing = true
            local left = tab.Left or tab.leftTexture or _G[tab:GetName().."Left"];
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
        end
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.xml ]]
    function Skin.UIPanelCloseButton(Button)
        Base.SetBackdrop(Button, Color.button)
        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 3, -10)
        bg:SetPoint("BOTTOMRIGHT", -11, 4)

        Button:SetNormalTexture("")
        Button:SetHighlightTexture("")
        Button:SetPushedTexture("")

        local dis = Button:GetDisabledTexture()
        if dis then
            dis:SetColorTexture(0, 0, 0, .4)
            dis:SetDrawLayer("OVERLAY")
            dis:SetAllPoints(bg)
        end

        local cross = {}
        for i = 1, 2 do
            local line = Button:CreateLine(nil, "ARTWORK")
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(1.2)
            line:Show()
            if i == 1 then
                line:SetStartPoint("TOPLEFT", bg, 4.6, -4)
                line:SetEndPoint("BOTTOMRIGHT", bg, -4, 4)
            else
                line:SetStartPoint("TOPRIGHT", bg, -4, -4)
                line:SetEndPoint("BOTTOMLEFT", bg, 4.6, 4)
            end
            tinsert(cross, line)
        end

        Button._auroraHighlight = cross
        Base.SetHighlight(Button, "texture")
    end
    function Skin.UIPanelButtonTemplate(Button)
        Skin.UIPanelButtonNoTooltipTemplate(Button)
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
    end
    function Skin.UICheckButtonTemplate(CheckButton)
        CheckButton:SetNormalTexture("")
        CheckButton:SetPushedTexture("")
        CheckButton:SetHighlightTexture("")

        Base.SetBackdrop(CheckButton, Color.frame)
        CheckButton:SetBackdropBorderColor(Color.button)
        local bg = CheckButton:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 6, -6)
        bg:SetPoint("BOTTOMRIGHT", -6, 6)

        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", -1, 1)
        check:SetPoint("BOTTOMRIGHT", 1, -1)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        local disabled = CheckButton:GetDisabledCheckedTexture()
        disabled:SetAllPoints(check)

        Base.SetHighlight(CheckButton, "backdrop")
    end

    function Skin.NineSlicePanelTemplate(Frame)
        Base.CreateBackdrop(Frame, private.backdrop, {
            tl = Frame.TopLeftCorner,
            tr = Frame.TopRightCorner,
            bl = Frame.BottomLeftCorner,
            br = Frame.BottomRightCorner,

            t = Frame.TopEdge,
            b = Frame.BottomEdge,
            l = Frame.LeftEdge,
            r = Frame.RightEdge,

            bg = Frame.Center,
        })
    end
    function Skin.InsetFrameTemplate(Frame)
        Frame.Bg:Hide()
        for _, tex in next, Frame.NineSlice do
            if type(tex) == "table" then
                tex:Hide()
            end
        end
    end
    function Skin.DialogBorderNoCenterTemplate(Frame)
        Base.CreateBackdrop(Frame, private.backdrop, {
            tl = Frame.TopLeftCorner,
            tr = Frame.TopRightCorner,
            bl = Frame.BottomLeftCorner,
            br = Frame.BottomRightCorner,

            t = Frame.TopEdge,
            b = Frame.BottomEdge,
            l = Frame.LeftEdge,
            r = Frame.RightEdge,

            bg = Frame.Bg
        })

        Base.SetBackdrop(Frame, Color.frame, 0)
    end
    function Skin.DialogBorderTemplate(Frame)
        Skin.DialogBorderNoCenterTemplate(Frame)
        Base.SetBackdrop(Frame)
    end
    function Skin.DialogBorderDarkTemplate(Frame)
        Skin.DialogBorderNoCenterTemplate(Frame)
        Frame:GetBackdropTexture("bg"):SetAlpha(0.87)
    end
    function Skin.DialogBorderTranslucentTemplate(Frame)
        Skin.DialogBorderNoCenterTemplate(Frame)
        Frame:GetBackdropTexture("bg"):SetAlpha(0.8)
    end
    function Skin.DialogBorderOpaqueTemplate(Frame)
        Skin.DialogBorderNoCenterTemplate(Frame)
        Frame:GetBackdropTexture("bg"):SetAlpha(1)
    end

    function Skin.SimplePanelTemplate(Frame)
        Skin.InsetFrameTemplate(Frame.Inset)
        Frame.NineSlice.Center = Frame.Bg
        Skin.NineSlicePanelTemplate(Frame.NineSlice)
        Base.SetBackdrop(Frame.NineSlice)
    end

    function Skin.PortraitFrameTemplateNoCloseButton(Frame)
        Util.Mixin(Frame, Hook.PortraitFrameMixin)

        Frame.TitleBg:Hide()
        Frame.portrait:SetAlpha(0)

        local titleText = Frame.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT")
        titleText:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Frame.TopTileStreaks:SetTexture("")
        Frame.NineSlice.Center = Frame.Bg
        Skin.NineSlicePanelTemplate(Frame.NineSlice)
        Base.SetBackdrop(Frame.NineSlice)
    end
    function Skin.PortraitFrameTemplate(Frame)
        Skin.PortraitFrameTemplateNoCloseButton(Frame)
        Skin.UIPanelCloseButton(Frame.CloseButton)
    end
    function Skin.ButtonFrameTemplate(Frame)
        Skin.PortraitFrameTemplate(Frame)
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

        Base.SetBackdrop(Button, Color.button)
        local bg = Button:GetBackdropTexture("bg")
        bg:SetPoint("TOPLEFT", 1, -1)
        bg:SetPoint("BOTTOMRIGHT", -1, 1)
        Base.SetBackdrop(Button, Color.button, 0.3)
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
        for _, name in next, {"MaximizeButton", "MinimizeButton"} do
            local Button = Frame[name]

            Base.SetBackdrop(Button, Color.button)
            local bg = Button:GetBackdropTexture("bg")
            bg:SetPoint("TOPLEFT", 3, -10)
            bg:SetPoint("BOTTOMRIGHT", -11, 4)
            --bg:SetPoint("TOPLEFT", 17, -10)
            --bg:SetPoint("BOTTOMRIGHT", 3, 4)

            Button:SetNormalTexture("")
            Button:SetPushedTexture("")
            Button:SetHighlightTexture("")

            local dis = Button:GetDisabledTexture()
            dis:SetColorTexture(0, 0, 0, .4)
            dis:SetDrawLayer("OVERLAY")
            dis:SetAllPoints(bg)

            Button._auroraHighlight = {}

            local line = Button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(1.2)
            line:SetStartPoint("TOPRIGHT", bg, -4, -4)
            line:SetEndPoint("BOTTOMLEFT", bg, 4.6, 4)
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
                hline:SetPoint("TOP", bg, 1, -4)
                vline:SetPoint("RIGHT", bg, -4, 1)
            else
                hline:SetPoint("BOTTOM", bg, -1, 4)
                vline:SetPoint("LEFT", bg, 4, -1)
            end

            Base.SetHighlight(Button, "texture")
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
