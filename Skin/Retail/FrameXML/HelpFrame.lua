local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\HelpFrame.lua ]]
    local selected
    function Hook.HelpFrame_SetSelectedButton(button)
        if selected and selected ~= button then
            selected:UnlockHighlight()
            selected:Enable()
        end

        button:LockHighlight()
        selected = button
    end
end

do --[[ FrameXML\HelpFrame.xml ]]
    function Skin.HelpFrameContainerFrameTemplate(Frame)
        Skin.TooltipBackdropTemplate(Frame)
    end
    function Skin.BrowserTemplate(Browser)
        Browser.BrowserInset:Hide()
        --Skin.InsetFrameTemplate(Browser.BrowserInset)
    end
end

function private.FrameXML.HelpFrame()
    ---------------
    -- HelpFrame --
    ---------------
    local HelpFrame = _G.HelpFrame
    Skin.ButtonFrameTemplate(HelpFrame)

    Skin.BrowserTemplate(HelpFrame.Browser)
    HelpFrame.Browser:SetPoint("TOPLEFT", 1, -private.FRAME_TITLE_HEIGHT)
    HelpFrame.Browser:SetPoint("BOTTOMRIGHT", -1, 1)


    ----------------------------
    -- BrowserSettingsTooltip --
    ----------------------------
    local BrowserSettingsTooltip = _G.BrowserSettingsTooltip
    Skin.HelpFrameContainerFrameTemplate(BrowserSettingsTooltip)
    Skin.UIPanelButtonTemplate(BrowserSettingsTooltip.CookiesButton)


    -----------------------
    -- TicketStatusFrame --
    -----------------------
    Skin.FrameTypeFrame(_G.TicketStatusFrameButton)


    --------------------------
    -- ReportCheatingDialog --
    --------------------------
    local ReportCheatingDialog = _G.ReportCheatingDialog
    Skin.DialogBorderTemplate(ReportCheatingDialog.Border)
    Base.CreateBackdrop(ReportCheatingDialog.CommentFrame, private.backdrop, {
        bg = _G.ReportCheatingDialogCommentFrameMiddle,

        l = _G.ReportCheatingDialogCommentFrameLeft,
        r = _G.ReportCheatingDialogCommentFrameRight,
        t = _G.ReportCheatingDialogCommentFrameTop,
        b = _G.ReportCheatingDialogCommentFrameBottom,

        tl = _G.ReportCheatingDialogCommentFrameTopLeft,
        tr = _G.ReportCheatingDialogCommentFrameTopRight,
        bl = _G.ReportCheatingDialogCommentFrameBottomLeft,
        br = _G.ReportCheatingDialogCommentFrameBottomRight,

        borderLayer = "BACKGROUND",
        borderSublevel = -7,
    })
    Base.SetBackdrop(ReportCheatingDialog.CommentFrame, Color.frame)
    ReportCheatingDialog.CommentFrame:SetBackdropBorderColor(Color.button)
    Skin.UIPanelButtonTemplate(ReportCheatingDialog.reportButton)
    Skin.UIPanelButtonTemplate(_G.ReportCheatingDialogCancelButton)
end
