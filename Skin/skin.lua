local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color


do -- Frame
    function Skin.FrameTypeFrame(Frame)
        Base.SetBackdrop(Frame, Color.frame)
    end
end


do -- Button
    local DISABLED_COLOR = Color.Lightness(Color.button, -0.3)
    local function Hook_Enable(self)
        Base.SetBackdropColor(self, self._enabledColor)
        if self._auroraTextures then
            for _, texture in next, self._auroraTextures do
                texture:SetVertexColor(Color.white:GetRGB())
            end
        end
    end
    local function Hook_Disable(self)
        Base.SetBackdropColor(self, self._disabledColor)
        if self._auroraTextures then
            for _, texture in next, self._auroraTextures do
                texture:SetVertexColor(Color.gray:GetRGB())
            end
        end
    end
    local function Hook_SetEnabled(self, enabledState)
        if enabledState then
            Hook_Enable(self)
        else
            Hook_Disable(self)
        end
    end
    function Skin.FrameTypeButton(Button, OnEnter, OnLeave)
        _G.hooksecurefunc(Button, "Enable", Hook_Enable)
        _G.hooksecurefunc(Button, "Disable", Hook_Disable)
        _G.hooksecurefunc(Button, "SetEnabled", Hook_SetEnabled)

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetHighlightTexture("")
        Button:SetDisabledTexture("")

        function Button:SetButtonColor(color, alpha, disabledColor)
            Base.SetBackdrop(self, color, alpha)

            local _, _, _, a = self:GetBackdropColor()
            local r, g, b = self:GetBackdropBorderColor()

            self._enabledColor = Color.Create(r, g, b, alpha or a)

            if disabledColor == false then
                self._disabledColor = self._enabledColor
            else
                if disabledColor then
                    self._disabledColor = disabledColor
                else
                    self._disabledColor = Color.Lightness(self._enabledColor, -0.3)
                end
            end

            Hook_SetEnabled(self, self:IsEnabled())
        end
        function Button:GetButtonColor()
            return self._enabledColor, self._disabledColor
        end

        Button:SetButtonColor(Color.button, nil, DISABLED_COLOR)
        Base.SetHighlight(Button, OnEnter, OnLeave)
    end
end


do -- CheckButton
    function Skin.FrameTypeCheckButton(CheckButton)
        CheckButton:SetNormalTexture("")
        CheckButton:SetPushedTexture("")
        CheckButton:SetHighlightTexture("")

        Base.SetBackdrop(CheckButton, Color.button, 0.3)
        Base.SetHighlight(CheckButton)
    end
end


do -- EditBox
    function Skin.FrameTypeEditBox(EditBox)
        Base.SetBackdrop(EditBox, Color.frame)
        EditBox:SetBackdropBorderColor(Color.button)
    end
end


do -- StatusBar
    local function Hook_SetStatusBarAtlas(self, atlas)
        local color = private.atlasColors[atlas]
        local color2 = private.atlasColors[atlas.."_2"]

        if color then
            local texture = self:GetStatusBarTexture()
            texture:SetTexture(private.textures.plain)
            if color2 then
                local r, g, b = color:GetRGB()
                local r2, g2, b2 = color2:GetRGB()
                texture:SetGradient("VERTICAL", r, g, b, r2, g2, b2)
            else
                texture:SetVertexColor(color:GetRGB())
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
