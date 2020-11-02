local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.GameMenuFrame()
    local GameMenuFrame = _G.GameMenuFrame
    Skin.DialogBorderTemplate(GameMenuFrame.Border)
    Skin.DialogHeaderTemplate(GameMenuFrame.Header)

    Skin.GameMenuButtonTemplate(_G.GameMenuButtonHelp)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonStore)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonWhatsNew)

    Skin.GameMenuButtonTemplate(_G.GameMenuButtonOptions)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonUIOptions)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonKeybindings)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonMacros)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonAddons)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonRatings) -- Used in Korean locale

    Skin.GameMenuButtonTemplate(_G.GameMenuButtonLogout)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonQuit)

    Skin.GameMenuButtonTemplate(_G.GameMenuButtonContinue)
end
