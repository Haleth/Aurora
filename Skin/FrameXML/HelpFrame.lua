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

    Skin.DialogHeaderTemplate(HelpFrame.Header)
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

--[[
function private.FrameXML.HelpFrame()
    local r, g, b = C.r, C.g, C.b

    local HelpFrame = _G.HelpFrame
    HelpFrame:DisableDrawLayer("BACKGROUND")
    HelpFrame:DisableDrawLayer("BORDER")
    F.CreateBDFrame(HelpFrame)

    if private.isPatch then
        Skin.DialogHeaderTemplate(HelpFrame.Header)
    else
        HelpFrame.header:Hide()
    end
    F.ReskinClose(_G.HelpFrameCloseButton)

    HelpFrame.leftInset:DisableDrawLayer("BACKGROUND")
    HelpFrame.leftInset:DisableDrawLayer("BORDER")

    HelpFrame.mainInset:DisableDrawLayer("BACKGROUND")
    HelpFrame.mainInset:DisableDrawLayer("BORDER")

    local function styleButton(button)
        F.Reskin(button)
        button.selected:SetTexCoord(0.01953125, 0.65625, 0.67578125, 0.84765625)
        button.selected:SetDesaturated(true)
        button.selected:SetVertexColor(r, g, b)
    end

    for i = 1, 6 do
        styleButton(_G["HelpFrameButton"..i])
    end
    styleButton(_G.HelpFrameButton16)

    -- AccountSecurity
    F.Reskin(HelpFrame.asec.ticketButton)
    F.Reskin(_G.HelpFrameCharacterStuckStuck)

    -- CharacterStuck
    F.Reskin(_G.HelpFrameCharacterStuckStuck)
    _G.HelpFrameCharacterStuckHearthstone:SetSize(56, 56)
    F.ReskinIcon(_G.HelpFrameCharacterStuckHearthstoneIconTexture)

    -- ReportBug
    F.Reskin(HelpFrame.bug.submitButton)
    select(3, HelpFrame.bug:GetChildren()):Hide()

    local bugScrollFrame = _G.HelpFrameReportBugScrollFrame
    F.CreateBD(bugScrollFrame, .25)
    F.ReskinScroll(bugScrollFrame.ScrollBar)
    bugScrollFrame.ScrollBar:SetPoint("TOPLEFT", bugScrollFrame, "TOPRIGHT", -17, -17)
    bugScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", bugScrollFrame, "BOTTOMRIGHT", -17, 17)

    -- SubmitSuggestion
    F.Reskin(HelpFrame.suggestion.submitButton)
    select(3, HelpFrame.suggestion:GetChildren()):Hide()

    local suggestionScrollFrame = _G.HelpFrameSubmitSuggestionScrollFrame
    F.CreateBD(suggestionScrollFrame, .25)
    F.ReskinScroll(suggestionScrollFrame.ScrollBar)
    suggestionScrollFrame.ScrollBar:SetPoint("TOPLEFT", suggestionScrollFrame, "TOPRIGHT", -17, -17)
    suggestionScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", suggestionScrollFrame, "BOTTOMRIGHT", -17, 17)


    -- HelpBrowser
    local HelpBrowser = _G.HelpBrowser
    HelpBrowser.BrowserInset:Hide()
    F.CreateBDFrame(HelpBrowser)

    for key, arrow in next, {settings=false, home=false, back = "Left", forward = "Right", reload=false, stop=false} do
        if arrow then
            F.ReskinArrow(HelpBrowser[key], arrow)
        else
            F.Reskin(HelpBrowser[key])
            HelpBrowser[key].Icon:SetDesaturated(true)
        end
        HelpBrowser[key]:SetSize(20, 20)
    end
    HelpBrowser.settings:SetPoint("TOPRIGHT", HelpBrowser, "TOPLEFT", 19, 22)
    HelpBrowser.home:SetPoint("BOTTOMLEFT", HelpBrowser.settings, "BOTTOMRIGHT", 3, 0)
    HelpBrowser.loading:SetPoint("TOPLEFT", HelpBrowser.stop, "TOPRIGHT", -8, 10)

    for i = 1, 9 do
        select(i, _G.BrowserSettingsTooltip:GetRegions()):Hide()
    end

    F.CreateBD(_G.BrowserSettingsTooltip)
    F.Reskin(_G.BrowserSettingsTooltip.CookiesButton)

    -- TicketStatusFrame
    F.CreateBD(_G.TicketStatusFrameButton)
    _G.TicketStatusFrameIcon:SetTexCoord(.08, .92, .08, .92)

    -- ReportCheatingDialog
    local ReportCheatingDialog = _G.ReportCheatingDialog
    Skin.DialogBorderTemplate(ReportCheatingDialog.Border)
    F.CreateBD(ReportCheatingDialog.CommentFrame, .25)
    for i = 1, 9 do
        select(i, ReportCheatingDialog.CommentFrame:GetRegions()):Hide()
    end
    F.Reskin(ReportCheatingDialog.reportButton)
    F.Reskin(_G.ReportCheatingDialogCancelButton)
end
]]
