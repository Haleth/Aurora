local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\OptionsFrameTemplates.lua ]]
--end

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
        if private.isClassic then
            Base.CreateBackdrop(Frame, private.backdrop, {
                tl = _G[name.."TopLeft"],
                bl = _G[name.."BottomLeft"],
                br = _G[name.."BottomRight"],
                tr = _G[name.."TopRight"],

                l = _G[name.."Left"],
                r = _G[name.."Right"],
                b = _G[name.."Bottom"],
            })
            _G[name.."Top"]:Hide()
        end
        Base.SetBackdrop(Frame, Color.frame)
        Skin.UIPanelScrollBarTemplate(_G[name.."ListScrollBar"])
    end
    function Skin.OptionsListButtonTemplate(Button)
        Skin.ExpandOrCollapse(Button.toggle)
    end
    function Skin.OptionsFrameTemplate(Frame)
        local name = Frame:GetName()

        if private.isRetail then
            Skin.DialogBorderTemplate(Frame.Border)
            Skin.DialogHeaderTemplate(Frame.Header)
        else
            Skin.DialogBorderTemplate(Frame)

            local header, text = Frame:GetRegions()
            header:Hide()
            text:ClearAllPoints()
            text:SetPoint("TOPLEFT")
            text:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
        end

        Skin.OptionsFrameListTemplate(_G[name.."CategoryFrame"])
        Base.SetBackdrop(_G[name.."PanelContainer"], Color.frame)
    end
end

--function private.FrameXML.OptionsFrameTemplates()
--end
