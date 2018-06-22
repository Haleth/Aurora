local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\SplashFrame.lua
end ]]

do --[[ FrameXML\SplashFrame.xml ]]
    function Skin.SplashFeatureFrameTemplate(Frame)
        --[[ Scale ]]--
        Frame:SetSize(286, 177)
        Frame.Description:SetSize(250, 0)
        Frame.Description:SetPoint("BOTTOM", 0, 20)
        Frame.Title:SetSize(250, 0)
        Frame.Title:SetPoint("BOTTOM", Frame.Description, "TOP", 0, 6)
    end
end

function private.FrameXML.SplashFrame()
    local SplashFrame = _G.SplashFrame
    Skin.UIPanelButtonTemplate(SplashFrame.BottomCloseButton)

    Skin.UIPanelCloseButton(SplashFrame.TopCloseButton)
    SplashFrame.TopCloseButton:SetPoint("TOPRIGHT", -22, -18)

    Skin.SplashFeatureFrameTemplate(SplashFrame.Feature1)
    Skin.SplashFeatureFrameTemplate(SplashFrame.Feature2)

    --[[ Scale ]]--
    SplashFrame:SetSize(882, 584)
    SplashFrame:SetPoint("CENTER", 0, 60)

    local splashInfo = _G.SPLASH_SCREENS[_G.BASE_SPLASH_TAG]
    local _, width, height = _G.GetAtlasInfo(splashInfo.leftTex)
    SplashFrame.LeftTexture:SetSize(width, height)

    _, width, height = _G.GetAtlasInfo(splashInfo.rightTex)
    SplashFrame.RightTexture:SetSize(width, height)
    SplashFrame.RightTexture:SetPoint("TOPLEFT", SplashFrame.LeftTexture, "TOPRIGHT", 0, -1)

    _, width, height = _G.GetAtlasInfo(splashInfo.bottomTex)
    SplashFrame.BottomTexture:SetSize(height, width)

    _, width, height = _G.GetAtlasInfo(SplashFrame.BottomLine:GetAtlas())
    SplashFrame.BottomLine:SetSize(width, height)
    SplashFrame.BottomLine:SetPoint("TOPLEFT", SplashFrame.BottomTexture, "BOTTOMLEFT", 3, 0)


    SplashFrame.Header:SetPoint("TOP", -9, -16)
    SplashFrame.Label:SetPoint("LEFT", 61, 211)
    SplashFrame.RightDescription:SetSize(300, 0)
    SplashFrame.RightDescription:SetPoint("BOTTOM", 164, 183)
    SplashFrame.RightDescriptionSubtext:SetSize(234, 0)
    SplashFrame.RightDescriptionSubtext:SetPoint("TOP", SplashFrame.RightDescription, "BOTTOM", 0, -5)
    SplashFrame.RightTitle:SetPoint("BOTTOM", SplashFrame.RightDescription, "TOP", 0, 10)


    SplashFrame.StartButton:SetSize(320, 60)
    SplashFrame.StartButton:SetPoint("BOTTOMRIGHT", -119, 91)
    _, width, height = _G.GetAtlasInfo(SplashFrame.StartButton.Texture:GetAtlas())
    SplashFrame.StartButton.Texture:SetSize(width, height)
    SplashFrame.StartButton.Texture:SetPoint("CENTER", -4, 0)
    SplashFrame.StartButton.Text:SetPoint("CENTER", 20, 0)

    local highlight = SplashFrame.StartButton:GetHighlightTexture()
    _, width, height = _G.GetAtlasInfo(highlight:GetAtlas())
    highlight:SetSize(width, height)
    highlight:SetPoint("CENTER", -4, 0)

    SplashFrame.BottomCloseButton:SetPoint("BOTTOM", 0, 34)
    SplashFrame.Feature1:SetPoint("TOPLEFT", 67, -122)
    SplashFrame.Feature2:SetPoint("TOPLEFT", 67, -326)
end
