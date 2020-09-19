local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\NavigationBar.lua ]]
    function Hook.NavBar_Initialize(self, template, homeData, homeButton, overflowButton)
        Skin.NavBarTemplate(self)
    end
    function Hook.NavBar_CheckLength(self)
        for i = #self.navList, 1, -1 do
            local navButton = self.navList[i]
            if i < #self.navList then
                if navButton.selected then
                    navButton:UnlockHighlight()
                end
            else
                if navButton.selected then
                    if not navButton._auroraSkinned then
                        Skin.NavButtonTemplate(navButton)
                        navButton._auroraSkinned = true
                    end

                    navButton:Enable()
                    navButton:LockHighlight()
                end
            end
        end
    end
end

do --[[ FrameXML\NavigationBar.xml ]]
    function Skin.NavButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = -1,
            right = 0,
            top = 0,
            bottom = 0,
        })
        Button.arrowUp:SetAlpha(0)
        Button.arrowDown:SetAlpha(0)
        Button.selected:SetAlpha(0)

        local arrowButton = Button.MenuArrowButton
        Skin.FrameTypeButton(arrowButton, nil, function(button, isBackdrop)
            button:SetBackdropBorderColor(Color.button, 0)
            button:SetBackdropColor(Color.button, 0)
        end)
        arrowButton:SetBackdropBorderColor(Color.button, 0)
        arrowButton:SetBackdropColor(Color.button, 0)
        arrowButton:SetBackdropOption("offsets", {
            left = 2,
            right = 2,
            top = 5,
            bottom = 4,
        })

        local bg = arrowButton:GetBackdropTexture("bg")
        arrowButton.Art:ClearAllPoints()
        arrowButton.Art:SetSize(10, 5)
        arrowButton.Art:SetPoint("TOPLEFT", bg, 7, -9)
        Base.SetTexture(arrowButton.Art, "arrowDown")
        arrowButton._auroraTextures = {arrowButton.Art}
    end
    function Skin.NavBarTemplate(Frame)
        Frame:GetRegions():Hide()
        Frame.overlay:Hide()

        local overflow = Frame.overflow
        Skin.FrameTypeButton(overflow)
        overflow:SetButtonColor(Color.grayLight)
        overflow:SetWidth(28)

        local tex = overflow:GetNormalTexture()
        tex:SetPoint("TOPLEFT", 10, -5)
        tex:SetPoint("BOTTOMRIGHT", -10, 5)
        Base.SetTexture(tex, "arrowLeft")

        local home = Frame.home
        Skin.FrameTypeButton(home)
        home:SetButtonColor(Color.red:Lightness(-.3))
        home:SetBackdropOption("offsets", {
            left = 0,
            right = 9,
            top = 0,
            bottom = 0,
        })
        home:GetRegions():Hide()
        home.text:SetPoint("RIGHT", -10, 0)
    end
end

function private.FrameXML.NavigationBar()
    _G.hooksecurefunc("NavBar_Initialize", Hook.NavBar_Initialize)
    _G.hooksecurefunc("NavBar_CheckLength", Hook.NavBar_CheckLength)
end
