local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals floor max ipairs select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

local function SetTexture(texture, anchor, left, right, top, bottom)
    if left then
        texture:SetTexCoord(left, right, top, bottom)
    end
    texture:ClearAllPoints()
    texture:SetPoint("TOPLEFT", anchor, 1, -1)
    texture:SetPoint("BOTTOMRIGHT", anchor, -1, 1)
end

local microButtonPrefix = [[Interface\Buttons\UI-MicroButton-]]
local microButtonNames = {
    Quest = true,
    Socials = true,
    MainMenu = true,
}
local function SetMicroButton(button, file, left, right, top, bottom)
    local bg = button:GetBackdropTexture("bg")

    if microButtonNames[file] then
        left, right, top, bottom = 0.1875, 0.8125, 0.46875, 0.90625

        button:SetNormalTexture(microButtonPrefix..file.."-Up")
        SetTexture(button:GetNormalTexture(), bg, left, right, top, bottom)

        button:SetPushedTexture(microButtonPrefix..file.."-Down")
        SetTexture(button:GetPushedTexture(), bg, left, right, top, bottom)

        button:SetDisabledTexture(microButtonPrefix..file.."-Disabled")
        SetTexture(button:GetDisabledTexture(), bg, left, right, top, bottom)
    else
        if not left then
            left, right, top, bottom = 0.2, 0.8, 0.08, 0.92
        end

        button:SetNormalTexture(file)
        SetTexture(button:GetNormalTexture(), bg, left, right - 0.04, top + 0.04, bottom)

        button:SetPushedTexture(file)
        button:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5)
        SetTexture(button:GetPushedTexture(), bg, left + 0.04, right, top, bottom - 0.04)

        button:SetDisabledTexture(file)
        button:GetDisabledTexture():SetDesaturated(true)
        SetTexture(button:GetDisabledTexture(), bg, left, right, top, bottom)
    end
end

do --[[ FrameXML\ActionBarController.lua ]]
    do --[[ MainMenuBar.lua ]]
        function Hook.MainMenuTrackingBar_Configure(frame, isOnTop)
            if isOnTop then
                frame.StatusBar:SetHeight(7)
            else
                frame.StatusBar:SetHeight(9)
            end
        end
        function Hook.UpdateMicroButtons()
            if _G.UnitLevel("player") >= _G.SHOW_SPEC_LEVEL then
                _G.QuestLogMicroButton:SetPoint("BOTTOMLEFT", _G.TalentMicroButton, "BOTTOMRIGHT", 2, 0);
            end
        end
    end
end

do --[[ FrameXML\ActionBarController.xml ]]
    do --[[ MainMenuBarMicroButtons.xml ]]
        function Skin.MainMenuBarMicroButton(Button)
            Button:SetHitRectInsets(0, 5, 24, 0)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 0,
                right = 5,
                top = 24,
                bottom = 0,
            })

            local bg = Button:GetBackdropTexture("bg")
            Button.Flash:SetPoint("TOPLEFT", bg, 1, -1)
            Button.Flash:SetPoint("BOTTOMRIGHT", bg, -1, 1)
            Button.Flash:SetTexCoord(.1818, .7879, .175, .875)
        end
        function Skin.MainMenuBarWatchBarTemplate(Frame)
            local StatusBar = Frame.StatusBar
            Skin.FrameTypeStatusBar(StatusBar)
            Base.SetBackdropColor(StatusBar, Color.frame)
            StatusBar:SetHeight(9)

            StatusBar.WatchBarTexture0:SetAlpha(0)
            StatusBar.WatchBarTexture1:SetAlpha(0)
            StatusBar.WatchBarTexture2:SetAlpha(0)
            StatusBar.WatchBarTexture3:SetAlpha(0)

            StatusBar.XPBarTexture0:SetAlpha(0)
            StatusBar.XPBarTexture1:SetAlpha(0)
            StatusBar.XPBarTexture2:SetAlpha(0)
            StatusBar.XPBarTexture3:SetAlpha(0)

            StatusBar.Background:Hide()

            Util.PositionBarTicks(StatusBar, 20, Color.frame)
            Frame.OverlayFrame.Text:SetPoint("CENTER")
        end
    end
    do --[[ ActionButtonTemplate.xml ]]
        function Skin.ActionButtonTemplate(CheckButton)
            Base.CropIcon(CheckButton.icon)

            CheckButton.Flash:SetColorTexture(1, 0, 0, 0.5)
            CheckButton.NewActionTexture:SetAllPoints()
            CheckButton.NewActionTexture:SetTexCoord(0.15, 0.85, 0.15, 0.85)
            CheckButton.SpellHighlightTexture:SetAllPoints()
            CheckButton.SpellHighlightTexture:SetTexCoord(0.15, 0.85, 0.15, 0.85)
            CheckButton.AutoCastable:SetAllPoints()
            CheckButton.AutoCastable:SetTexCoord(0.21875, 0.765625, 0.21875, 0.765625)
            CheckButton.AutoCastShine:ClearAllPoints()
            CheckButton.AutoCastShine:SetPoint("TOPLEFT", 2, -2)
            CheckButton.AutoCastShine:SetPoint("BOTTOMRIGHT", -2, 2)

            CheckButton:SetNormalTexture("")
            Base.CropIcon(CheckButton:GetPushedTexture())
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
    end
    do --[[ ActionBarFrame.xml ]]
        function Skin.ActionBarButtonTemplate(CheckButton)
            Skin.ActionButtonTemplate(CheckButton)

            Base.CreateBackdrop(CheckButton, {
                bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                tile = false,
                offsets = {
                    left = -1,
                    right = -1,
                    top = -1,
                    bottom = -1,
                }
            })
            CheckButton:SetBackdropColor(1, 1, 1, 0.75)
            CheckButton:SetBackdropBorderColor(Color.frame:GetRGB())
            Base.CropIcon(CheckButton:GetBackdropTexture("bg"))
        end
    end
    do --[[ MultiActionBars.xml ]]
        function Skin.MultiBarButtonTemplate(CheckButton)
            Skin.ActionButtonTemplate(CheckButton)
            Base.SetBackdrop(CheckButton, Color.frame, 0.2)
            CheckButton:SetBackdropOption("offsets", {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            })

            _G[CheckButton:GetName().."FloatingBG"]:SetTexture("")
        end
        Skin.MultiBar1ButtonTemplate = Skin.MultiBarButtonTemplate
        Skin.MultiBar2ButtonTemplate = Skin.MultiBarButtonTemplate
        function Skin.MultiBar2ButtonNoBackgroundTemplate(CheckButton)
            Skin.ActionButtonTemplate(CheckButton)

            Base.CreateBackdrop(CheckButton, {
                bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                tile = false,
                offsets = {
                    left = -1,
                    right = -1,
                    top = -1,
                    bottom = -1,
                }
            })
            CheckButton:SetBackdropColor(1, 1, 1, 0.75)
            CheckButton:SetBackdropBorderColor(Color.frame:GetRGB())
            Base.CropIcon(CheckButton:GetBackdropTexture("bg"))
        end
        Skin.MultiBar3ButtonTemplate = Skin.MultiBarButtonTemplate
        Skin.MultiBar4ButtonTemplate = Skin.MultiBarButtonTemplate

        function Skin.HorizontalMultiBar1(Frame)
            local name = Frame:GetName().."Button"
            for i = 1, 12 do
                Skin.MultiBar1ButtonTemplate(_G[name..i])
            end
        end
        function Skin.HorizontalMultiBar2(Frame)
            local name = Frame:GetName().."Button"
            for i = 1, 12 do
                Skin.MultiBar2ButtonTemplate(_G[name..i])
            end
        end
        function Skin.VerticalMultiBar3(Frame)
            local name = Frame:GetName().."Button"
            for i = 1, 12 do
                Skin.MultiBar3ButtonTemplate(_G[name..i])
            end
        end
        function Skin.VerticalMultiBar4(Frame)
            local name = Frame:GetName().."Button"
            for i = 1, 12 do
                Skin.MultiBar4ButtonTemplate(_G[name..i])
            end
        end
    end
    do --[[ StanceBar.xml ]]
        function Skin.StanceButtonTemplate(CheckButton)
            Skin.ActionButtonTemplate(CheckButton)

            Base.CreateBackdrop(CheckButton, {
                bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                tile = false,
                offsets = {
                    left = -1,
                    right = -1,
                    top = -1,
                    bottom = -1,
                }
            })
            CheckButton:SetBackdropColor(1, 1, 1, 0.75)
            CheckButton:SetBackdropBorderColor(Color.frame:GetRGB())
            Base.CropIcon(CheckButton:GetBackdropTexture("bg"))

            local name = CheckButton:GetName()
            _G[name.."NormalTexture2"]:Hide()
        end
    end
end

function private.FrameXML.ActionBarController()
    ----====####$$$$%%%%%$$$$####====----
    --     MainMenuBarMicroButtons     --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        _G.hooksecurefunc("UpdateMicroButtons", Hook.UpdateMicroButtons)

        for i, name in _G.ipairs(_G.MICRO_BUTTONS) do
            local button = _G[name]
            Skin.MainMenuBarMicroButton(button)
        end

        SetTexture(_G.MicroButtonPortrait, _G.CharacterMicroButton:GetBackdropTexture("bg"))
        SetMicroButton(_G.SpellbookMicroButton, [[Interface\Icons\INV_Misc_Book_09]])
        SetMicroButton(_G.TalentMicroButton, [[Interface\Icons\Ability_Marksmanship]])
        SetMicroButton(_G.QuestLogMicroButton, "Quest")
        SetMicroButton(_G.SocialsMicroButton, "Socials")
        SetMicroButton(_G.WorldMapMicroButton, [[Interface\WorldMap\WorldMap-Icon]], 0.21875, 0.6875, 0.109375, 0.8125)
        SetMicroButton(_G.MainMenuMicroButton, "MainMenu")
        SetMicroButton(_G.HelpMicroButton, [[Interface\Icons\INV_Misc_QuestionMark]])

        Util.PositionRelative("BOTTOMLEFT", _G.MainMenuBarArtFrame, "BOTTOMLEFT", 552, 5, -2, "Right", {
            _G.CharacterMicroButton,
            _G.SpellbookMicroButton,
            _G.TalentMicroButton,
            _G.QuestLogMicroButton,
            _G.SocialsMicroButton,
            _G.WorldMapMicroButton,
            _G.MainMenuMicroButton,
            _G.HelpMicroButton,
        })
    end

    ----====####$$$$%%%%%$$$$####====----
    --           MainMenuBar           --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        _G.hooksecurefunc("MainMenuTrackingBar_Configure", Hook.MainMenuTrackingBar_Configure)

        -- MainMenuExpBar
        Skin.FrameTypeStatusBar(_G.MainMenuExpBar)
        Base.SetBackdropColor(_G.MainMenuExpBar, Color.frame)
        Util.PositionBarTicks(_G.MainMenuExpBar, 20, Color.frame)
        _G.MainMenuExpBar:SetHeight(9)
        _G.MainMenuExpBar:SetPoint("TOP", 0.4, 0)
        _G.ExhaustionLevelFillBar:SetHeight(9)

        _G.MainMenuXPBarTexture0:SetAlpha(0)
        _G.MainMenuXPBarTexture1:SetAlpha(0)
        _G.MainMenuXPBarTexture2:SetAlpha(0)
        _G.MainMenuXPBarTexture3:SetAlpha(0)
        select(6, _G.MainMenuExpBar:GetRegions()):Hide()

        -- MainMenuBarArtFrame
        _G.MainMenuBarTexture0:SetAlpha(0)
        _G.MainMenuBarTexture1:SetAlpha(0)
        _G.MainMenuBarTexture2:SetAlpha(0)
        _G.MainMenuBarTexture3:SetAlpha(0)

        _G.MainMenuBarLeftEndCap:Hide()
        _G.MainMenuBarRightEndCap:Hide()

        -- MainMenuBarPerformanceBarFrame
        local PerformanceBarFrame = _G.MainMenuBarPerformanceBarFrame
        Base.SetBackdrop(PerformanceBarFrame, Color.button, Color.frame.a)
        PerformanceBarFrame:SetBackdropOption("offsets", {
            left = 1,
            right = 6,
            top = 13,
            bottom = 11,
        })

        local bg = PerformanceBarFrame:GetBackdropTexture("bg")
        local PerformanceBar = _G.MainMenuBarPerformanceBar
        Base.SetTexture(PerformanceBar, "gradientRight")
        PerformanceBar:ClearAllPoints()
        PerformanceBar:SetPoint("TOPLEFT", bg, 1, -1)
        PerformanceBar:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        do -- Vertical status bar
            local divHeight = PerformanceBar:GetHeight() / 3
            local ypos = divHeight
            for i = 1, 2 do
                local texture = PerformanceBarFrame:CreateTexture(nil, "ARTWORK")
                texture:SetColorTexture(Color.button:GetRGB())
                texture:SetSize(1, 1)

                texture:SetPoint("BOTTOMLEFT", bg, 0, floor(ypos))
                texture:SetPoint("BOTTOMRIGHT", bg, 0, floor(ypos))
                ypos = ypos + divHeight
            end
        end
    end

    ----====####$$$$%%%%$$$$####====----
    --      ActionButtonTemplate      --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --         ActionBarFrame         --
    ----====####$$$$%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        for i = 1, 12 do
            Skin.ActionBarButtonTemplate(_G["ActionButton"..i])
        end

        do -- ActionBarUpButton
            local ActionBarUpButton = _G.ActionBarUpButton
            Skin.FrameTypeButton(ActionBarUpButton)
            ActionBarUpButton:SetBackdropOption("offsets", {
                left = 8,
                right = 8,
                top = 8,
                bottom = 8,
            })

            local bg = ActionBarUpButton:GetBackdropTexture("bg")
            local arrow = ActionBarUpButton:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 3, -5)
            arrow:SetPoint("BOTTOMRIGHT", bg, -3, 5)
            Base.SetTexture(arrow, "arrowUp")
            ActionBarUpButton._auroraTextures = {arrow}
        end

        do -- ActionBarDownButton
            local ActionBarDownButton = _G.ActionBarDownButton
            Skin.FrameTypeButton(ActionBarDownButton)
            ActionBarDownButton:SetBackdropOption("offsets", {
                left = 8,
                right = 8,
                top = 8,
                bottom = 8,
            })

            local bg = ActionBarDownButton:GetBackdropTexture("bg")
            local arrow = ActionBarDownButton:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 3, -5)
            arrow:SetPoint("BOTTOMRIGHT", bg, -3, 5)
            Base.SetTexture(arrow, "arrowDown")
            ActionBarDownButton._auroraTextures = {arrow}
        end
    end

    ----====####$$$$%%%%%$$$$####====----
    --         MultiActionBars         --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        Skin.HorizontalMultiBar1(_G.MultiBarBottomLeft)
        Skin.HorizontalMultiBar2(_G.MultiBarBottomRight)
        Skin.VerticalMultiBar3(_G.MultiBarRight)
        Skin.VerticalMultiBar4(_G.MultiBarLeft)
    end

    ----====####$$$$%%%%%$$$$####====----
    --            StanceBar            --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        _G.StanceBarLeft:SetAlpha(0)
        _G.StanceBarMiddle:SetAlpha(0)
        _G.StanceBarRight:SetAlpha(0)

        for i = 1, _G.NUM_STANCE_SLOTS do
            Skin.StanceButtonTemplate(_G["StanceButton"..i])
        end
    end

    ----====####$$$$%%%%%$$$$####====----
    --       ActionBarController       --
    ----====####$$$$%%%%%$$$$####====----
end
