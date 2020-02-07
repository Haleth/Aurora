local _, private = ...

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
    function Skin.HelpFrameButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button.selected:SetTexture("")
    end
    function Skin.BrowserButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })
    end
    function Skin.BrowserTemplate(Browser)
        Skin.InsetFrameTemplate(Browser.BrowserInset)
        Skin.BrowserButtonTemplate(Browser.settings)
        Skin.BrowserButtonTemplate(Browser.home)
        Skin.NavButtonPrevious(Browser.back)
        Skin.NavButtonNext(Browser.forward)
        Skin.BrowserButtonTemplate(Browser.reload)
        Skin.BrowserButtonTemplate(Browser.stop)
    end
end

function private.FrameXML.HelpFrame()
    _G.hooksecurefunc("HelpFrame_SetSelectedButton", Hook.HelpFrame_SetSelectedButton)


    ---------------
    -- HelpFrame --
    ---------------
    local HelpFrame = _G.HelpFrame
    Skin.TranslucentFrameTemplate(HelpFrame)

    local streaks, buttonDiv, vertDivTop, vertDivBottom, vertDivMiddle = select(10, HelpFrame:GetRegions())
    streaks:Hide()

    if private.isRetail then
        Skin.DialogHeaderTemplate(HelpFrame.Header)
    else
        local header = HelpFrame.header
        header:SetAlpha(0)

        local text = header:GetRegions()
        text:SetParent(HelpFrame)
        text:ClearAllPoints()
        text:SetPoint("TOPLEFT")
        text:SetPoint("BOTTOMRIGHT", HelpFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end

    Skin.UIPanelCloseButton(_G.HelpFrameCloseButton)

    Skin.InsetFrameTemplate(HelpFrame.leftInset)
    local LeftShadow, RightShadow, TopShadow, BottomShadow = select(2, HelpFrame.leftInset:GetRegions())
    LeftShadow:Hide()
    RightShadow:Hide()
    TopShadow:Hide()
    BottomShadow:Hide()

    Skin.InsetFrameTemplate(HelpFrame.mainInset)

    Skin.HelpFrameButtonTemplate(HelpFrame.button1)
    Hook.HelpFrame_SetSelectedButton(HelpFrame.button1)
    Skin.HelpFrameButtonTemplate(HelpFrame.button2)
    Skin.HelpFrameButtonTemplate(HelpFrame.button5)
    Skin.HelpFrameButtonTemplate(HelpFrame.button3)
    Skin.HelpFrameButtonTemplate(HelpFrame.button4)
    Skin.HelpFrameButtonTemplate(HelpFrame.button16)
    Skin.HelpFrameButtonTemplate(HelpFrame.button6)

    Skin.HelpFrameButtonTemplate(HelpFrame.asec.ticketButton)
    Skin.UIPanelButtonTemplate(_G.HelpFrameCharacterStuckStuck)
    Base.CropIcon(_G.HelpFrameCharacterStuckHearthstone.IconTexture, HelpFrame.stuck)
    Base.CropIcon(_G.HelpFrameCharacterStuckHearthstone:GetPushedTexture())
    Base.CropIcon(_G.HelpFrameCharacterStuckHearthstone:GetHighlightTexture())

    Skin.GameMenuButtonTemplate(HelpFrame.bug.submitButton)
    _G.HelpFrameReportBugScrollFrame:ClearAllPoints()
    _G.HelpFrameReportBugScrollFrame:SetPoint("BOTTOMLEFT", 154, 70)
    Skin.UIPanelScrollBarTemplate(_G.HelpFrameReportBugScrollFrame.ScrollBar)
    local bugEditBorder = select(3, HelpFrame.bug:GetChildren())
    Base.SetBackdrop(bugEditBorder, Color.frame)
    bugEditBorder:SetBackdropBorderColor(Color.button)

    Skin.GameMenuButtonTemplate(HelpFrame.suggestion.submitButton)
    _G.HelpFrameSubmitSuggestionScrollFrame:ClearAllPoints()
    _G.HelpFrameSubmitSuggestionScrollFrame:SetPoint("BOTTOMLEFT", 154, 130)
    Skin.UIPanelScrollBarTemplate(_G.HelpFrameSubmitSuggestionScrollFrame.ScrollBar)
    local suggestionEditBorder = select(3, HelpFrame.suggestion:GetChildren())
    Base.SetBackdrop(suggestionEditBorder, Color.frame)
    suggestionEditBorder:SetBackdropBorderColor(Color.button)

    Skin.BrowserTemplate(_G.HelpBrowser)

    buttonDiv:SetColorTexture(1, 1, 1, 0.5)
    buttonDiv:SetSize(150, 1)
    buttonDiv:SetPoint("TOP", HelpFrame.button5, "BOTTOM", -1, -14)

    vertDivTop:Hide()
    vertDivBottom:Hide()
    vertDivMiddle:Hide()


    ----------------------------
    -- BrowserSettingsTooltip --
    ----------------------------
    local BrowserSettingsTooltip = _G.BrowserSettingsTooltip
    Skin.TooltipBorderedFrameTemplate(BrowserSettingsTooltip)
    Skin.UIPanelButtonTemplate(BrowserSettingsTooltip.CookiesButton)


    -----------------------
    -- TicketStatusFrame --
    -----------------------
    Base.SetBackdrop(_G.TicketStatusFrameButton)


    --------------------------
    -- ReportCheatingDialog --
    --------------------------
    local ReportCheatingDialog = _G.ReportCheatingDialog
    if private.isRetail then
        Skin.DialogBorderTemplate(ReportCheatingDialog.Border)
    else
        Skin.DialogBorderTemplate(ReportCheatingDialog)
    end
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
