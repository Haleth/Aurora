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

    --BlizzWTF: The close button added in this frame interferes with the one created in the template.
    local closeButton = ModelPreviewFrame.CloseButton
    if private.isRetail then
        ModelPreviewFrame.CloseButton = select(2, ModelPreviewFrame:GetChildren())
    else
        ModelPreviewFrame.CloseButton = ModelPreviewFrame:GetChildren()
    end
    Skin.ButtonFrameTemplate(ModelPreviewFrame)
    Skin.MagicButtonTemplate(closeButton)
    closeButton:SetPoint("BOTTOMRIGHT", -5, 5)

    ModelPreviewFrame.Display.YesMountsTex:Hide()
    ModelPreviewFrame.Display.ShadowOverlay:Hide()

    local ModelScene = ModelPreviewFrame.Display.ModelScene
    Skin.RotateOrbitCameraLeftButtonTemplate(ModelScene.RotateLeftButton)
    Skin.RotateOrbitCameraRightButtonTemplate(ModelScene.RotateRightButton)
    Skin.NavButtonPrevious(ModelScene.CarouselLeftButton)
    Skin.NavButtonNext(ModelScene.CarouselRightButton)
end
