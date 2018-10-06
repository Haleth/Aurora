local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do FrameXML\InterfaceOptionsFrame.lua
end ]]

--[[ do FrameXML\InterfaceOptionsFrame.xml
end ]]

function private.FrameXML.InterfaceOptionsFrame()
    Base.SetBackdrop(_G.InterfaceOptionsFrame)

    local name = _G.InterfaceOptionsFrame:GetName()
    _G[name.."Header"]:SetTexture("")
    _G[name.."HeaderText"]:SetPoint("TOP", 0, -10)

    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsFrameOkay)
    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsFrameCancel)
    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsFrameDefaults)
    Skin.OptionsFrameListTemplate(_G.InterfaceOptionsFrameCategories)
    Skin.OptionsFrameListTemplate(_G.InterfaceOptionsFrameAddOns)
    Base.SetBackdrop(_G[name.."PanelContainer"], Color.frame)

    Skin.OptionsFrameTabButtonTemplate(_G.InterfaceOptionsFrameTab1)
    if not private.isPatch then
        _G.InterfaceOptionsFrameTab1TabSpacer:SetAlpha(0)
    end

    Skin.OptionsFrameTabButtonTemplate(_G.InterfaceOptionsFrameTab2)
    if not private.isPatch then
        _G.InterfaceOptionsFrameTab2TabSpacer1:SetAlpha(0)
        _G.InterfaceOptionsFrameTab2TabSpacer2:SetAlpha(0)
    end
end
