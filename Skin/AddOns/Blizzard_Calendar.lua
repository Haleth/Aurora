local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals select ipairs pairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color


-- local constants
local CALENDAR_MAX_DAYS_PER_MONTH = 42 -- 6 weeks

-- DayButton constants
local CALENDAR_DAYBUTTON_MAX_VISIBLE_EVENTS = 4

do --[[ AddOns\Blizzard_Calendar.lua ]]
    function Hook.CalendarEventInviteList_UpdateSortButtons(inviteList)
        local criterion, reverse = _G.C_Calendar.EventGetInviteSortCriterion()
        for index, button in pairs(inviteList.sortButtons) do
            local direction = _G[button:GetName().."Direction"];
            if button.criterion == criterion then
                if reverse then
                    Base.SetTexture(direction, "arrowDown")
                else
                    Base.SetTexture(direction, "arrowUp")
                end
            end
        end
    end
    function Hook.CalendarClassButtonContainer_Update()
        for i = 1, _G.MAX_CLASSES do
            local button = _G["CalendarClassButton"..i]
            local buttonIcon = button:GetNormalTexture()
            if buttonIcon:IsDesaturated() then
                buttonIcon._auroraBorder:SetColorTexture(Color.gray:GetRGB())
            else
                buttonIcon._auroraBorder:SetColorTexture(_G.CUSTOM_CLASS_COLORS[button.class]:GetRGB())
            end
        end
    end
end

do --[[ AddOns\Blizzard_Calendar.xml ]]
    -- Calendar Day Templates
    function Skin.CalendarDayButtonTemplate(Button)
        Base.SetBackdrop(Button, Color.black, 0)

        local moreEvents = _G[Button:GetName().."MoreEventsButton"]
        moreEvents:SetSize(14, 7)
        moreEvents:SetPoint("TOPRIGHT", -6, -9)
        Base.SetTexture(moreEvents:GetNormalTexture(), "arrowDown")

        Button:SetNormalTexture("")
        local highlight = Button:GetHighlightTexture()
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, 0.5)
        highlight:ClearAllPoints()
        highlight:SetPoint("TOPLEFT", 1, -1)
        highlight:SetPoint("BOTTOMRIGHT", -1, 1)
    end
    function Skin.CalendarDayEventButtonTemplate(Button)
        local black = Button.black
        black:SetColorTexture(Color.black:GetRGB())
        black:SetPoint("TOPLEFT", -2, 0)
        black:SetPoint("BOTTOMRIGHT", 2, 0)

        local highlight = Button:GetHighlightTexture()
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, 0.2)
        highlight:SetPoint("TOPLEFT", -3, 1)
        highlight:SetPoint("BOTTOMRIGHT", 3, -1)
    end

    -- Calendar Misc Templates
    function Skin.CalendarCloseButtonTemplate(Button)
        Skin.UIPanelCloseButton(Button)
        select(5, Button:GetRegions()):Hide()
    end

    -- Calendar Event Templates
    function Skin.CalendarEventButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end
    function Skin.CalendarEventCloseButtonTemplate(Button)
        Skin.CalendarCloseButtonTemplate(Button)
    end
    function Skin.CalendarEventDescriptionScrollFrame(ScrollFrame)
        Skin.UIPanelScrollFrameTemplate(ScrollFrame)
    end
    function Skin.CalendarEventInviteSortButtonTemplate(Button)
        local arrow = Button:GetRegions()
        arrow:SetSize(10, 5)
        arrow:SetPoint("RIGHT", 2, 0)
    end
    function Skin.CalendarEventInviteListTemplate(Frame)
        Frame:SetBackdrop(nil)
        local name = Frame:GetName()
        Skin.HybridScrollBarTemplate(_G[name.."ScrollFrameScrollBar"])
        Skin.CalendarEventInviteSortButtonTemplate(_G[name.."NameSortButton"])
        Skin.CalendarEventInviteSortButtonTemplate(_G[name.."ClassSortButton"])
        Skin.CalendarEventInviteSortButtonTemplate(_G[name.."StatusSortButton"])
    end

    -- Calendar View Event Templates
    function Skin.CalendarViewEventRSVPButtonTemplate(Button)
        Skin.CalendarEventButtonTemplate(Button)
    end

    -- Calendar Modal Dialog Templates
    function Skin.CalendarModalEventOverlayTemplate(Frame)
        Frame:GetRegions():SetColorTexture(0.1, 0.1, 0.1, 0.7)
    end

    -- Calendar Class Templates
    function Skin.CalendarClassButtonTemplate(Button)
        Button:GetRegions():Hide()

        local icon = Button:GetNormalTexture()
        icon:SetPoint("TOPLEFT", 1, -1)
        icon:SetPoint("BOTTOMRIGHT", -1, 1)
        Base.SetTexture(icon, "icon"..Button.class)
    end
end

function private.AddOns.Blizzard_Calendar()
    _G.hooksecurefunc("CalendarEventInviteList_UpdateSortButtons", Hook.CalendarEventInviteList_UpdateSortButtons)
    _G.hooksecurefunc("CalendarClassButtonContainer_Update", Hook.CalendarClassButtonContainer_Update)

    -------------------
    -- CalendarFrame --
    -------------------
    Base.SetBackdrop(_G.CalendarFrame)
    local calenderBG = _G.CalendarFrame:GetBackdropTexture("bg")
    calenderBG:SetPoint("TOPLEFT", 11, 0)
    calenderBG:SetPoint("BOTTOMRIGHT", -9, 3)

    _G.CalendarFrameTopLeftTexture:Hide()
    _G.CalendarFrameTopMiddleTexture:Hide()
    _G.CalendarFrameTopRightTexture:Hide()
    _G.CalendarFrameLeftTopTexture:Hide()
    _G.CalendarFrameLeftMiddleTexture:Hide()
    _G.CalendarFrameLeftBottomTexture:Hide()
    _G.CalendarFrameRightTopTexture:Hide()
    _G.CalendarFrameRightMiddleTexture:Hide()
    _G.CalendarFrameRightBottomTexture:Hide()
    _G.CalendarFrameBottomLeftTexture:Hide()
    _G.CalendarFrameBottomMiddleTexture:Hide()
    _G.CalendarFrameBottomRightTexture:Hide()

    for i = 1, 7 do
        _G["CalendarWeekday"..i.."Background"]:SetColorTexture(Color.grayDark:GetRGB())
    end

    _G.CalendarMonthBackground:Hide()
    _G.CalendarYearBackground:Hide()

    _G.CalendarWeekdaySelectedTexture:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, 0.2)
    _G.CalendarWeekdaySelectedTexture:SetSize(91, 28)

    _G.CalendarTodayFrame:SetScript("OnUpdate", nil)
    Base.CreateBackdrop(_G.CalendarTodayFrame, {
        edgeSize = 4,
    })
    Base.SetBackdropColor(_G.CalendarTodayFrame, Color.highlight, 0)
    local todayBG = _G.CalendarTodayFrame:GetBackdropTexture("bg")
    todayBG:SetPoint("TOPLEFT", 24, -22)
    todayBG:SetPoint("BOTTOMRIGHT", -24, 21)

    _G.CalendarTodayTextureGlow:Hide()
    _G.CalendarTodayTexture:Hide()

    Skin.NavButtonPrevious(_G.CalendarPrevMonthButton)
    Skin.NavButtonNext(_G.CalendarNextMonthButton)

    do -- Filter button
        Base.SetBackdrop(_G.CalendarFilterFrame, Color.button)
        _G.CalendarFilterFrame:SetPoint("TOPRIGHT", -80, -13)

        _G.CalendarFilterFrameLeft:SetAlpha(0)
        _G.CalendarFilterFrameMiddle:SetAlpha(0)
        _G.CalendarFilterFrameRight:SetAlpha(0)

        local button = _G.CalendarFilterButton
        Skin.FrameTypeButton(button)
        button:ClearAllPoints()
        button:SetPoint("TOPRIGHT", _G.CalendarFilterFrame)

        local arrow = button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 4, -7)
        arrow:SetPoint("BOTTOMRIGHT", -4, 7)
        Base.SetTexture(arrow, "arrowDown")
    end

    Skin.UIPanelCloseButton(_G.CalendarCloseButton)
    _G.CalendarCloseButton:SetSize(32, 32)
    _G.CalendarCloseButton:SetPoint("TOPRIGHT", calenderBG, 5, 5)

    Skin.UIMenuTemplate(_G.CalendarContextMenu)
    Skin.UIMenuTemplate(_G.CalendarInviteStatusContextMenu)
    Skin.CalendarModalEventOverlayTemplate(_G.CalendarFrameModalOverlay)

    for i = 1, CALENDAR_MAX_DAYS_PER_MONTH do
        local buttonName = "CalendarDayButton"..i
        Skin.CalendarDayButtonTemplate(_G[buttonName])

        local eventButtonPrefix = buttonName.."EventButton"
        for j = 1, CALENDAR_DAYBUTTON_MAX_VISIBLE_EVENTS do
            Skin.CalendarDayEventButtonTemplate(_G[eventButtonPrefix..j])
        end
    end


    ------------------
    -- View Holiday --
    ------------------
    _G.CalendarViewHolidayInfoTexture:SetAlpha(0)
    Skin.DialogBorderDarkTemplate(_G.CalendarViewHolidayFrame.Border)
    Skin.DialogHeaderTemplate(_G.CalendarViewHolidayFrame.Header)
    Skin.UIPanelScrollFrameTemplate(_G.CalendarViewHolidayScrollFrame)
    Skin.CalendarEventCloseButtonTemplate(_G.CalendarViewHolidayCloseButton)
    Skin.CalendarModalEventOverlayTemplate(_G.CalendarViewHolidayFrameModalOverlay)


    ---------------
    -- View Raid --
    ---------------
    Skin.DialogBorderDarkTemplate(_G.CalendarViewRaidFrame.Border)
    Skin.DialogHeaderTemplate(_G.CalendarViewRaidFrame.Header)
    Skin.UIPanelScrollFrameTemplate(_G.CalendarViewRaidScrollFrame)
    Skin.CalendarEventCloseButtonTemplate(_G.CalendarViewRaidCloseButton)
    Skin.CalendarModalEventOverlayTemplate(_G.CalendarViewRaidFrameModalOverlay)


    ----------------
    -- View Event --
    ----------------
    Skin.DialogBorderDarkTemplate(_G.CalendarViewEventFrame.Border)
    Skin.DialogHeaderTemplate(_G.CalendarViewEventFrame.Header)
    _G.CalendarViewEventDescriptionContainer:SetBackdrop(nil)
    Skin.CalendarEventDescriptionScrollFrame(_G.CalendarViewEventDescriptionScrollFrame)
    _G.CalendarViewEventDivider:Hide()
    Skin.CalendarViewEventRSVPButtonTemplate(_G.CalendarViewEventAcceptButton)
    Skin.CalendarViewEventRSVPButtonTemplate(_G.CalendarViewEventTentativeButton)
    Skin.CalendarViewEventRSVPButtonTemplate(_G.CalendarViewEventDeclineButton)
    Skin.CalendarEventButtonTemplate(_G.CalendarViewEventRemoveButton)
    Skin.CalendarEventInviteListTemplate(_G.CalendarViewEventInviteList)
    Skin.CalendarEventCloseButtonTemplate(_G.CalendarViewEventCloseButton)
    Skin.CalendarModalEventOverlayTemplate(_G.CalendarViewEventFrameModalOverlay)


    -----------------------
    -- Create/Edit Event --
    -----------------------
    _G.CalendarCreateEventFrameButtonBackground:Hide()
    Skin.DialogBorderDarkTemplate(_G.CalendarCreateEventFrame.Border)
    Skin.DialogHeaderTemplate(_G.CalendarCreateEventFrame.Header)
    Skin.InputBoxTemplate(_G.CalendarCreateEventTitleEdit)
    Skin.UIDropDownMenuTemplate(_G.CalendarCreateEventTypeDropDown)
    Skin.UIDropDownMenuTemplate(_G.CalendarCreateEventHourDropDown)
    Skin.UIDropDownMenuTemplate(_G.CalendarCreateEventMinuteDropDown)
    Skin.UIDropDownMenuTemplate(_G.CalendarCreateEventAMPMDropDown)
    Skin.UIDropDownMenuTemplate(_G.CalendarCreateEventDifficultyOptionDropDown)
    Skin.UIDropDownMenuTemplate(_G.CalendarCreateEventCommunityDropDown)
    _G.CalendarCreateEventDescriptionContainer:SetBackdrop(nil)
    Skin.CalendarEventDescriptionScrollFrame(_G.CalendarCreateEventDescriptionScrollFrame)
    _G.CalendarCreateEventDivider:Hide()
    Skin.UICheckButtonTemplate(_G.CalendarCreateEventAutoApproveCheck)
    Skin.UICheckButtonTemplate(_G.CalendarCreateEventLockEventCheck)
    Skin.CalendarEventInviteListTemplate(_G.CalendarCreateEventInviteList)
    Skin.InputBoxTemplate(_G.CalendarCreateEventInviteEdit)
    Skin.UIPanelButtonTemplate(_G.CalendarCreateEventInviteButton)
    Skin.UIPanelButtonTemplate(_G.CalendarCreateEventMassInviteButton)
    _G.CalendarCreateEventMassInviteButtonBorder:Hide()
    Skin.UIPanelButtonTemplate(_G.CalendarCreateEventRaidInviteButton)
    _G.CalendarCreateEventRaidInviteButtonBorder:Hide()
    Skin.CalendarEventButtonTemplate(_G.CalendarCreateEventCreateButton)
    _G.CalendarCreateEventCreateButtonBorder:Hide()
    Skin.CalendarEventCloseButtonTemplate(_G.CalendarCreateEventCloseButton)
    Skin.CalendarModalEventOverlayTemplate(_G.CalendarCreateEventFrameModalOverlay)
    _G.CalendarCreateEventFrameModalOverlay:SetAllPoints()


    -----------------
    -- Mass Invite --
    -----------------
    _G.CalendarMassInviteFrame:SetPoint("BOTTOMRIGHT", _G.CalendarCreateEventMassInviteButton, "TOPRIGHT", 160, 4)
    Skin.DialogBorderDarkTemplate(_G.CalendarMassInviteFrame.Border)
    Skin.UIDropDownMenuTemplate(_G.CalendarMassInviteCommunityDropDown)
    Skin.DialogHeaderTemplate(_G.CalendarMassInviteFrame.Header)
    Skin.InputBoxTemplate(_G.CalendarMassInviteMinLevelEdit)
    Skin.InputBoxTemplate(_G.CalendarMassInviteMaxLevelEdit)
    Skin.UIDropDownMenuTemplate(_G.CalendarMassInviteRankMenu)
    Skin.CalendarEventButtonTemplate(_G.CalendarMassInviteAcceptButton)
    Skin.CalendarCloseButtonTemplate(_G.CalendarMassInviteCloseButton)
    Skin.CalendarModalEventOverlayTemplate(_G.CalendarMassInviteFrameModalOverlay)


    ------------------
    -- Event Picker --
    ------------------
    Skin.DialogBorderDarkTemplate(_G.CalendarEventPickerFrame.Border)
    _G.CalendarEventPickerFrameButtonBackground:Hide()
    Skin.DialogHeaderTemplate(_G.CalendarEventPickerFrame.Header)
    Skin.HybridScrollBarTemplate(_G.CalendarEventPickerScrollBar)
    Skin.CalendarEventButtonTemplate(_G.CalendarEventPickerCloseButton)
    _G.CalendarEventPickerCloseButtonBorder:Hide()


    --------------------
    -- Texture Picker --
    --------------------
    _G.CalendarTexturePickerFrame:ClearAllPoints()
    _G.CalendarTexturePickerFrame:SetPoint("TOPRIGHT", _G.CalendarCreateEventTypeDropDown, "BOTTOMRIGHT", -4, 0)
    Skin.DialogBorderDarkTemplate(_G.CalendarTexturePickerFrame.Border)
    _G.CalendarTexturePickerFrameButtonBackground:Hide()
    Skin.DialogHeaderTemplate(_G.CalendarTexturePickerFrame.Header)
    Skin.HybridScrollBarTemplate(_G.CalendarTexturePickerScrollBar)
    Skin.CalendarEventButtonTemplate(_G.CalendarTexturePickerCancelButton)
    _G.CalendarTexturePickerCancelButtonBorder:Hide()
    Skin.CalendarEventButtonTemplate(_G.CalendarTexturePickerAcceptButton)
    _G.CalendarTexturePickerAcceptButtonBorder:Hide()


    -------------------
    -- Class Buttons --
    -------------------
    for i = 1, _G.MAX_CLASSES do
        local button = _G["CalendarClassButton"..i]
        Skin.CalendarClassButtonTemplate(button)
        if i == 1 then
            button:SetPoint("TOPLEFT", 5, 0)
        else
            button:SetPoint("TOPLEFT", "CalendarClassButton"..(i-1), "BOTTOMLEFT", 0, -10)
        end
    end

    Base.SetBackdrop(_G.CalendarClassTotalsButton, Color.button)
    local classTotalBG = _G.CalendarClassTotalsButton:GetBackdropTexture("bg")
    classTotalBG:SetPoint("TOPLEFT", 0, 2)
    classTotalBG:SetPoint("BOTTOMRIGHT", 0, -2)
    _G.CalendarClassTotalsButtonBackgroundMiddle:Hide()
    _G.CalendarClassTotalsButtonBackgroundTop:Hide()
    _G.CalendarClassTotalsButtonBackgroundBottom:Hide()
    --_G.CalendarClassTotalsButton:SetPoint("TOPLEFT", "CalendarClassButton".._G.MAX_CLASSES, "BOTTOMLEFT", 0, -10)
end
