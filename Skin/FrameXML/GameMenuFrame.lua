local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F = _G.unpack(Aurora)

function private.FrameXML.GameMenuFrame()
    local header = _G.GameMenuFrameHeader
    header:SetTexture("")
    header:ClearAllPoints()
    header:SetPoint("TOP", _G.GameMenuFrame, 0, 7)

    Skin.DialogBorderTemplate(_G.GameMenuFrame.Border)

    local buttons = {
        "Help",
        "WhatsNew",
        "Store",

        "Options",
        "UIOptions",
        "Keybindings",
        "Macros",
        "Addons",

        "Logout",
        "Quit",

        "Continue"
    }
    for i = 1, #buttons do
        F.Reskin(_G["GameMenuButton"..buttons[i]])
    end
end
