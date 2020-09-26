local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.GameMenuFrame()
    local GameMenuFrame = _G.GameMenuFrame
    Skin.DialogBorderTemplate(GameMenuFrame)

    local header, text = GameMenuFrame:GetRegions()
    header:Hide()
    text:ClearAllPoints()
    text:SetPoint("TOPLEFT")
    text:SetPoint("BOTTOMRIGHT", _G.GameMenuFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    local buttons = {
        Help = true,
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
