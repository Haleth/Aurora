local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--[[ do FrameXML\OptionsFrameTemplates.lua
end ]]

do --[[ FrameXML\OptionsFrameTemplates.xml ]]
    function Skin.OptionsFrameTabButtonTemplate(Button)
        local name = Button:GetName()
        Button:SetHighlightTexture("")

        _G[name.."LeftDisabled"]:SetAlpha(0)
        _G[name.."MiddleDisabled"]:SetAlpha(0)
        _G[name.."RightDisabled"]:SetAlpha(0)
        _G[name.."Left"]:SetAlpha(0)
        _G[name.."Middle"]:SetAlpha(0)
        _G[name.."Right"]:SetAlpha(0)
    end
    function Skin.OptionsFrameListTemplate(Frame)
        local name = Frame:GetName()
        _G[name.."TopLeft"]:Hide()
        _G[name.."BottomLeft"]:Hide()
        _G[name.."BottomRight"]:Hide()
        _G[name.."TopRight"]:Hide()
        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Bottom"]:Hide()
        _G[name.."Top"]:Hide()

        Base.SetBackdrop(Frame, Color.frame)
        Base.SetBackdrop(_G[name.."List"], Color.frame)
        Skin.UIPanelScrollBarTemplate(_G[name.."ListScrollBar"])
    end
    function Skin.OptionsListButtonTemplate(Button)
        Skin.ExpandOrCollapse(Button.toggle)
    end
    function Skin.OptionsFrameTemplate(Frame)
        Base.SetBackdrop(Frame)

        local name = Frame:GetName()
        _G[name.."Header"]:SetTexture("")
        _G[name.."HeaderText"]:SetPoint("TOP", 0, -10)

        Skin.OptionsFrameListTemplate(_G[name.."CategoryFrame"])
        Base.SetBackdrop(_G[name.."PanelContainer"], Color.frame)
    end
end

function private.FrameXML.OptionsFrameTemplates()
    --[[
    ]]
end
