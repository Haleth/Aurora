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

    if private.isPatch then
        Skin.DialogBorderTemplate(_G.GameMenuFrame.Border)
    else
        F.CreateBD(_G.GameMenuFrame)
    end

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
