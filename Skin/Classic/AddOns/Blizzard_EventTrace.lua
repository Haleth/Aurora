local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ AddOns\Blizzard_EventTrace.lua ]]
--end

do --[[ AddOns\Blizzard_EventTrace.xml ]]
    function Skin.EventTraceCheckButtonTemplate(CheckButton)
        Skin.FrameTypeCheckButton(CheckButton)
        CheckButton:SetBackdropOption("offsets", {
            left = 2,
            right = 2,
            top = 2,
            bottom = 2,
        })

        local bg = CheckButton:GetBackdropTexture("bg")
        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bg, -2, 2)
        check:SetPoint("BOTTOMRIGHT", bg, 2, -2)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        local disabled = CheckButton:GetDisabledCheckedTexture()
        disabled:SetAllPoints(check)
    end
    function Skin.EventTraceMenuButtonTemplate(Button)
        Skin.FrameTypeButton(Button)

        Button.NormalTexture:SetAlpha(0)
        Button.HighlightTexture:SetAlpha(0)
        Button.MouseoverOverlay:SetAlpha(0)
    end

    function Skin.EventTraceScrollBoxButtonTemplate(Frame)
    end
    function Skin.EventTraceLogEventButtonTemplate(Frame)
        Skin.EventTraceScrollBoxButtonTemplate(Frame)
        Skin.UIPanelCloseButton(Frame.HideButton)
        Frame.HideButton:SetPoint("TOPLEFT", 3.6, 0)
        Frame.HideButton:SetBackdropOption("offsets", {
            left = 0,
            right = 5,
            top = 3,
            bottom = 2,
        })
    end
    function Skin.EventTraceFilterButtonTemplate(Frame)
        Skin.EventTraceScrollBoxButtonTemplate(Frame)
        Skin.UIPanelCloseButton(Frame.HideButton)
        Frame.HideButton:SetPoint("TOPLEFT", 3.4, 0)
        Frame.HideButton:SetBackdropOption("offsets", {
            left = 0,
            right = 5,
            top = 3,
            bottom = 2,
        })
        Skin.EventTraceCheckButtonTemplate(Frame.CheckButton)
    end
end

function private.AddOns.Blizzard_EventTrace()
    local EventTrace = _G.EventTrace
    Skin.ButtonFrameTemplate(EventTrace)


    local SubtitleBar = EventTrace.SubtitleBar
    Skin.EventTraceMenuButtonTemplate(SubtitleBar.ViewLog)
    Skin.EventTraceMenuButtonTemplate(SubtitleBar.ViewFilter)

    Skin.UIMenuButtonStretchTemplate(SubtitleBar.OptionsDropDown)
    SubtitleBar.OptionsDropDown.Icon:SetSize(5, 10)
    Base.SetTexture(SubtitleBar.OptionsDropDown.Icon, "arrowRight")


    local Log = EventTrace.Log
    Skin.EventTraceMenuButtonTemplate(Log.Bar.MarkButton)
    Skin.EventTraceMenuButtonTemplate(Log.Bar.PlaybackButton)
    Skin.EventTraceMenuButtonTemplate(Log.Bar.DiscardAllButton)
    Skin.SearchBoxTemplate(Log.Bar.SearchBox)

    Skin.WowScrollBoxList(Log.Events.ScrollBox)
    Skin.WowTrimScrollBar(Log.Events.ScrollBar)

    Skin.WowScrollBoxList(Log.Search.ScrollBox)
    Skin.WowTrimScrollBar(Log.Search.ScrollBar)


    local Filter = EventTrace.Filter
    Skin.EventTraceMenuButtonTemplate(Filter.Bar.CheckAllButton)
    Skin.EventTraceMenuButtonTemplate(Filter.Bar.UncheckAllButton)
    Skin.EventTraceMenuButtonTemplate(Filter.Bar.DiscardAllButton)

    Skin.WowScrollBoxList(Filter.ScrollBox)
    Skin.WowTrimScrollBar(Filter.ScrollBar)
end
