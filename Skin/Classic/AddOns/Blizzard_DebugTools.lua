local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_DebugTools.lua ]]
    local numButtonsSkinned = 0
    function Hook.EventTraceFrame_OnSizeChanged(self, width, height)
        if numButtonsSkinned < #self.buttons then
            for i = numButtonsSkinned + 1, #self.buttons do
                Skin.EventTraceEventTemplate(self.buttons[i])
            end
            numButtonsSkinned = #self.buttons
        end
    end
end

do --[[ AddOns\Blizzard_DebugTools.xml ]]
    function Skin.EventTraceEventTemplate(Button)
        Skin.UIPanelCloseButton(Button.HideButton)
        Button.HideButton:ClearAllPoints()
        Button.HideButton:SetPoint("TOPLEFT", -5, 2)
        Button.HideButton:SetBackdropOption("offsets", {
            left = 3,
            right = 4,
            top = 4,
            bottom = 4,
        })
    end
end

function private.AddOns.Blizzard_DebugTools()
    --[[ EventTrace ]]--
    _G.EventTraceFrame:HookScript("OnSizeChanged", Hook.EventTraceFrame_OnSizeChanged)
    Base.CreateBackdrop(_G.EventTraceFrame, private.backdrop, {
        bg = _G.EventTraceFrameDialogBG,

        l = _G.EventTraceFrameLeft,
        r = _G.EventTraceFrameRight,
        t = _G.EventTraceFrameTop,
        b = _G.EventTraceFrameBottom,

        tl = _G.EventTraceFrameTopLeft,
        tr = _G.EventTraceFrameTopRight,
        bl = _G.EventTraceFrameBottomLeft,
        br = _G.EventTraceFrameBottomRight,
    })
    Skin.FrameTypeFrame(_G.EventTraceFrame)

    _G.EventTraceFrameTitleBG:Hide()
    _G.EventTraceFrameTitle:ClearAllPoints()
    _G.EventTraceFrameTitle:SetPoint("TOPLEFT")
    _G.EventTraceFrameTitle:SetPoint("BOTTOMRIGHT", _G.EventTraceFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelCloseButton(_G.EventTraceFrameCloseButton)
    Skin.ScrollBarThumb(_G.EventTraceFrameScroll.thumb)

    Hook.EventTraceFrame_OnSizeChanged(_G.EventTraceFrame) -- Skin the buttons

    if not private.disabled.tooltips then
        Skin.GameTooltipTemplate(_G.FrameStackTooltip)
        Skin.GameTooltipTemplate(_G.EventTraceTooltip)
    end
end
