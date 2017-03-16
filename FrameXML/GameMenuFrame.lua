local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
    local header = _G.GameMenuFrameHeader
    header:SetTexture("")
    header:ClearAllPoints()
    header:SetPoint("TOP", _G.GameMenuFrame, 0, 7)

    F.CreateBD(_G.GameMenuFrame)

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
end)
