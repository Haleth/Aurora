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

    local buttons = {
        Help = true,
        WhatsNew = true,
        Store = true,

        Options = true,
        UIOptions = true,
        Keybindings = true,
        Macros = true,
        Addons = true,

        Logout = true,
        Quit = true,

        Continue = true,
    }
    for name in next, buttons do
        Skin.GameMenuButtonTemplate(_G["GameMenuButton"..name])
    end
end
