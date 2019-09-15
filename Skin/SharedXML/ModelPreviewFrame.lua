local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\ModelPreviewFrame.lua ]]
--end

--do --[[ FrameXML\ModelPreviewFrame.xml ]]
--end

function private.SharedXML.ModelPreviewFrame()
    local ModelPreviewFrame = _G.ModelPreviewFrame

    local closeButton = ModelPreviewFrame.CloseButton
    Skin.ButtonFrameTemplate(ModelPreviewFrame)
    Skin.MagicButtonTemplate(closeButton)
    Skin.UIPanelCloseButton(_G.ModelPreviewFrameCloseButton)
    closeButton:SetPoint("BOTTOMRIGHT", -5, 5)

    ModelPreviewFrame.Display.YesMountsTex:Hide()
    ModelPreviewFrame.Display.ShadowOverlay:Hide()

    local ModelScene = ModelPreviewFrame.Display.ModelScene
    Skin.RotateOrbitCameraLeftButtonTemplate(ModelScene.RotateLeftButton)
    Skin.RotateOrbitCameraRightButtonTemplate(ModelScene.RotateRightButton)
    Skin.NavButtonPrevious(ModelScene.CarouselLeftButton)
    Skin.NavButtonNext(ModelScene.CarouselRightButton)
end
