local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\NavigationBar.lua ]]
    function Hook.NavBar_Initialize(self, template, homeData, homeButton, overflowButton)
        Skin.NavBarTemplate(self)
        Scale.RawSetWidth(homeButton, homeButton.text:GetStringWidth() + 20)
    end
    function Hook.NavBar_AddButton(self, buttonData)
        local navButton = self.navList[#self.navList]

        if not navButton._auroraSkinned then
            Skin.NavButtonTemplate(navButton)
            navButton._auroraSkinned = true
        end
    end
end

do --[[ FrameXML\NavigationBar.xml ]]
    function Skin.NavButtonTemplate(Button)
        Button.arrowUp:SetAlpha(0)
        Button.arrowDown:SetAlpha(0)
        Button.selected:SetColorTexture(Color.red.r, Color.red.g, Color.red.b, 0.3)

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetHighlightTexture("")
        Base.SetBackdrop(Button, Color.button)
        Base.SetHighlight(Button, "backdrop")

        local arrowButton = Button.MenuArrowButton
        Base.SetTexture(arrowButton.Art, "arrowDown")
        arrowButton.Art:SetSize(13, 6)
        arrowButton.NormalTexture:SetTexture("")
        arrowButton.PushedTexture:SetTexture("")
        arrowButton:SetHighlightTexture("")

        arrowButton._auroraHighlight = {arrowButton.Art}
        Base.SetHighlight(arrowButton, "texture")
    end
    function Skin.NavBarTemplate(Frame)
        Frame:GetRegions():Hide()
        Frame.overlay:Hide()

        Frame.overflow:SetWidth(28)
        Frame.overflow:SetPushedTexture("")
        Frame.overflow:SetHighlightTexture("")
        Base.SetBackdrop(Frame.overflow, Color.grayLight)

        local tex = Frame.overflow:GetNormalTexture()
        Base.SetTexture(tex, "arrowLeft")
        tex:SetPoint("TOPLEFT", 10, -5)
        tex:SetPoint("BOTTOMRIGHT", -10, 5)

        Frame.home:GetRegions():Hide()
        Frame.home:SetNormalTexture("")
        Frame.home:SetPushedTexture("")
        Frame.home:SetHighlightTexture("")
        Frame.home.text:SetPoint("RIGHT", -10, 0)

        Base.SetBackdrop(Frame.home, Color.red:Lightness(-.5))
        Base.SetHighlight(Frame.home, "backdrop")
    end
end

function private.FrameXML.NavigationBar()
    _G.hooksecurefunc("NavBar_Initialize", Hook.NavBar_Initialize)
    _G.hooksecurefunc("NavBar_AddButton", Hook.NavBar_AddButton)
end
