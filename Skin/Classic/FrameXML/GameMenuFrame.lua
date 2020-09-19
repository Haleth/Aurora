local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.GameMenuFrame()
    local GameMenuFrame = _G.GameMenuFrame
    if private.isRetail then
        Skin.DialogBorderTemplate(GameMenuFrame.Border)
        Skin.DialogHeaderTemplate(GameMenuFrame.Header)
    else
        Skin.DialogBorderTemplate(GameMenuFrame)

        local header, text = GameMenuFrame:GetRegions()
        header:Hide()
        text:ClearAllPoints()
        text:SetPoint("TOPLEFT")
        text:SetPoint("BOTTOMRIGHT", _G.GameMenuFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end

    local buttons = {
        Help = true,
        WhatsNew = private.isRetail,
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
    for name, doSkin in next, buttons do
        if doSkin then
            Skin.GameMenuButtonTemplate(_G["GameMenuButton"..name])
        end
    end
end
