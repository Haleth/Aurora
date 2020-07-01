local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals floor max ipairs

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
local function SetMicroButton(button, file, left, right, top, bottom)
    --print("SetMicroButton", button:GetName(), file)
    if file == "" then
        if not left then
            if private.isRetail then
                left, right, top, bottom = .19, .81, .21, .82
            else
                left, right, top, bottom = 0.1875, 0.8125, 0.46875, 0.90625
            end
        end
        SetTexture(button._normal, button, left, right, top, bottom)
        SetTexture(button._pushed, button, left, right, top, bottom)
        SetTexture(button._disabled, button, left, right, top, bottom)
    elseif file then
        if not left then
            left, right, top, bottom = 0.2, 0.8, 0.08, 0.92
        end
        button._normal:SetTexture(file)
        SetTexture(button._normal, button, left, right - 0.04, top + 0.04, bottom)

        SetTexture(button._pushed, button, left + 0.04, right, top, bottom - 0.04)
        button._pushed:SetVertexColor(0.5, 0.5, 0.5)
        button._pushed:SetTexture(file)

        SetTexture(button._disabled, button, left, right, top, bottom)
        button._disabled:SetDesaturated(true)
        button._disabled:SetTexture(file)
    else
        button._normal:SetTexture("")
        button._pushed:SetTexture("")
        if button._disabled then
            button._disabled:SetTexture("")
        end
    end
end
SetTexture = Aurora.Profile.trackFunction(SetTexture, "ActionBarController.SetTexture")
SetMicroButton = Aurora.Profile.trackFunction(SetMicroButton, "ActionBarController.SetMicroButton")

do --[[ FrameXML\ActionBarController.lua ]]
    do --[[ MainMenuBarMicroButtons.lua ]]
        local anchors = {
            MicroButtonAndBagsBar = 11
        }
        function Hook.MoveMicroButtons(anchor, anchorTo, relAnchor, x, y, isStacked)
            _G.CharacterMicroButton:ClearAllPoints()
            _G.CharacterMicroButton:SetPoint(anchor, anchorTo, relAnchor, _G[anchors[anchorTo]], y)
            _G.LFDMicroButton:ClearAllPoints()
            if isStacked then
                _G.LFDMicroButton:SetPoint("TOPLEFT", _G.CharacterMicroButton, "BOTTOMLEFT", 0, -1)
            else
                _G.LFDMicroButton:SetPoint("BOTTOMLEFT", _G.GuildMicroButton, "BOTTOMRIGHT", 1, 0)
            end
        end

        local status
        function Hook.MainMenuMicroButton_OnUpdate(self, elapsed)
            if self.updateInterval == _G.PERFORMANCEBAR_UPDATE_INTERVAL then
                --print("OnUpdate", self.updateInterval)
                status = _G.GetFileStreamingStatus()
                if status == 0 then
                    status = _G.GetBackgroundLoadingStatus() ~= 0 and 1 or 0
                end

                if status == 0 then
                    SetMicroButton(self, [[Interface\Icons\INV_Misc_QuestionMark]])
                else
                    SetMicroButton(self, "")
                end
            end
        end
    end
    do --[[ StatusTrackingManager.lua ]]
        Hook.StatusTrackingManagerMixin = {}
        function Hook.StatusTrackingManagerMixin:AddBarFromTemplate(frameType, template)
            Skin[template](self.bars[#self.bars])
        end
        function Hook.StatusTrackingManagerMixin:HideStatusBars()
            for i, bar in ipairs(self.bars) do
                Util.ReleaseBarTicks(bar)
            end
        end
        function Hook.StatusTrackingManagerMixin:SetDoubleBarSize(bar, width)
            local barHeight = 8
            bar.StatusBar:SetHeight(barHeight)
            bar:SetHeight(barHeight)
        end
        function Hook.StatusTrackingManagerMixin:SetSingleBarSize(bar, width)
            local barHeight = 10
            bar.StatusBar:SetHeight(barHeight)
            bar:SetHeight(barHeight)
        end
        function Hook.StatusTrackingManagerMixin:LayoutBar(bar, barWidth, isTopBar, isDouble)
            if isDouble then
                if isTopBar then
                    bar:SetPoint("BOTTOM", self:GetParent(), 0, -7)
                else
                    bar:SetPoint("BOTTOM", self:GetParent(), 0, -18)
                end
            else
                bar:SetPoint("BOTTOM", self:GetParent(), 0, -11)
            end

            Util.PositionBarTicks(bar, self.largeSize and 20 or 10, Color.frame)
        end
    end
    do --[[ ExpBar.xml ]]
        Hook.ExhaustionTickMixin = {}
        function Hook.ExhaustionTickMixin:UpdateTickPosition()
            if self:IsShown() then
                local playerCurrXP = _G.UnitXP("player")
                local playerMaxXP = _G.UnitXPMax("player")
                local exhaustionThreshold = _G.GetXPExhaustion()
                local exhaustionStateID = _G.GetRestState()

                local parent = self:GetParent()
                if exhaustionStateID and exhaustionStateID >= 3 then
                    self.Normal:SetPoint("LEFT", parent , "RIGHT", 0, 0)
                end

                if exhaustionThreshold then
                    local parentWidth = parent:GetWidth()
                    local exhaustionTickSet = max(((playerCurrXP + exhaustionThreshold) / playerMaxXP) * parentWidth, 0)
                    exhaustionTickSet = _G.Round(exhaustionTickSet - 1)
                    if exhaustionTickSet < parentWidth then
                        self.Normal:SetPoint("LEFT", parent, "LEFT", exhaustionTickSet, 0)
                    end
                end
            end
        end
    end
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
            Button:SetSize(24, 34)

            Button._normal = Button:GetNormalTexture()
            Button._pushed = Button:GetPushedTexture()
            Button._disabled = Button:GetDisabledTexture()

            -- 24 x 34
            Base.SetBackdrop(Button, Color.button)

            Button:SetHighlightTexture("")
            Button.Flash:SetPoint("TOPLEFT", 1, -1)
            Button.Flash:SetPoint("BOTTOMRIGHT", -1, 1)
            Button.Flash:SetTexCoord(.1818, .7879, .175, .875)

            Base.SetHighlight(Button, "backdrop")
        end
        function Skin.MicroButtonAlertTemplate(Frame)
            Skin.GlowBoxTemplate(Frame)
            Skin.UIPanelCloseButton(Frame.CloseButton)
            Skin.GlowBoxArrowTemplate(Frame.Arrow)
        end
        function Skin.MainMenuBarWatchBarTemplate(Frame)
            local StatusBar = Frame.StatusBar
            Skin.FrameTypeStatusBar(StatusBar)
            StatusBar:SetHeight(9)

            StatusBar.WatchBarTexture0:SetAlpha(0)
            StatusBar.WatchBarTexture1:SetAlpha(0)
            StatusBar.WatchBarTexture2:SetAlpha(0)
            StatusBar.WatchBarTexture3:SetAlpha(0)

            StatusBar.XPBarTexture0:SetAlpha(0)
            StatusBar.XPBarTexture1:SetAlpha(0)
            StatusBar.XPBarTexture2:SetAlpha(0)
            StatusBar.XPBarTexture3:SetAlpha(0)

            Util.PositionBarTicks(StatusBar, 20)
            Frame.OverlayFrame.Text:SetPoint("CENTER")
        end
    end
    do --[[ StatusTrackingBar.xml ]]
        function Skin.StatusTrackingBarManagerTemplate(Frame)
            Util.Mixin(Frame, Hook.StatusTrackingManagerMixin)
            Frame.SingleBarLarge:SetAlpha(0)
            Frame.SingleBarLargeUpper:SetAlpha(0)
            Frame.SingleBarSmall:SetAlpha(0)
            Frame.SingleBarSmallUpper:SetAlpha(0)
        end
    end
    do --[[ StatusTrackingBarTemplate.xml ]]
        function Skin.StatusTrackingBarTemplate(Frame)
            local StatusBar = Frame.StatusBar
            Skin.FrameTypeStatusBar(StatusBar)
            Base.SetBackdropColor(StatusBar, Color.frame)

            StatusBar.Background:Hide()
            StatusBar.Underlay:Hide()
            StatusBar.Overlay:Hide()
        end
    end
    do --[[ ExpBar.xml ]]
        function Skin.ExpStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
            Frame.ExhaustionLevelFillBar:SetPoint("BOTTOMLEFT")

            --[[
            ]]
            local tick = Frame.ExhaustionTick
            Util.Mixin(tick, Hook.ExhaustionTickMixin)
            local texture = tick.Normal
            texture:SetColorTexture(Color.white:GetRGB())
            texture:ClearAllPoints()
            texture:SetPoint("TOP", Frame)
            texture:SetPoint("BOTTOM", Frame)
            texture:SetWidth(2)

            local diamond = tick:CreateTexture(nil, "BORDER")
            diamond:SetPoint("BOTTOMLEFT", texture, "TOPLEFT", -3, -1)
            diamond:SetSize(9, 9)
            Base.SetTexture(diamond, "shapeDiamond")

            local highlight = tick.Highlight
            highlight:ClearAllPoints()
            highlight:SetPoint("TOPLEFT", diamond, -2, 2)
            highlight:SetPoint("BOTTOMRIGHT", diamond, 2, -2)
            Base.SetTexture(highlight, "shapeDiamond")
        end
    end
    do --[[ ReputationBar.xml ]]
        function Skin.ReputationStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
    end
    do --[[ AzeriteBar.xml ]]
        function Skin.AzeriteBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
    end
    do --[[ ArtifactBar.xml ]]
        function Skin.ArtifactStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
    end
    do --[[ HonorBar.xml ]]
        function Skin.HonorStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
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
            if private.isRetail then
                for i = 1, 6 do
                    Skin.MultiBar2ButtonNoBackgroundTemplate(_G[name..i])
                end
                for i = 7, 12 do
                    Skin.MultiBar2ButtonTemplate(_G[name..i])
                end
            else
                for i = 1, 12 do
                    Skin.MultiBar2ButtonTemplate(_G[name..i])
                end
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
    do --[[ ExtraActionBar.xml ]]
        -- /run ActionButton_StartFlash(ExtraActionButton1)
        function Skin.ExtraActionButtonTemplate(CheckButton)
            Base.CropIcon(CheckButton.icon, CheckButton)

            CheckButton.HotKey:SetPoint("TOPLEFT", 5, -5)
            CheckButton.Count:SetPoint("TOPLEFT", -5, 5)
            CheckButton.style:Hide()

            CheckButton.cooldown:SetPoint("TOPLEFT")
            CheckButton.cooldown:SetPoint("BOTTOMRIGHT")

            CheckButton:SetNormalTexture("")
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
    end
end

function private.FrameXML.ActionBarController()
    ----====####$$$$%%%%%$$$$####====----
    --     MainMenuBarMicroButtons     --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        if private.isRetail then
            _G.hooksecurefunc("MoveMicroButtons", Hook.MoveMicroButtons)
            _G.MainMenuMicroButton:HookScript("OnUpdate", Hook.MainMenuMicroButton_OnUpdate)
        else
            _G.hooksecurefunc("UpdateMicroButtons", Hook.UpdateMicroButtons)
        end

        for i, name in _G.ipairs(_G.MICRO_BUTTONS) do
            local button = _G[name]
            Skin.MainMenuBarMicroButton(button)

            -- TODO: redo this
            local iconTexture, left, right, top, bottom
            if name == "CharacterMicroButton" then
                SetTexture(_G.MicroButtonPortrait, button)
                if private.isRetail then
                    button:SetPoint("BOTTOMLEFT", _G.MicroButtonAndBagsBar, "BOTTOMLEFT", 11, 3)
                else
                    button:SetPoint("BOTTOMLEFT", _G.MainMenuBarArtFrame, "BOTTOMLEFT", 552, 5)
                end
            elseif name == "SpellbookMicroButton" then
                iconTexture = [[Interface\Icons\INV_Misc_Book_09]]
                button:SetPoint("BOTTOMLEFT", _G.CharacterMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "TalentMicroButton" then
                iconTexture = [[Interface\Icons\Ability_Marksmanship]]
                button:SetPoint("BOTTOMLEFT", _G.SpellbookMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "AchievementMicroButton" then
                iconTexture = ""
                button:SetPoint("BOTTOMLEFT", _G.TalentMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "QuestLogMicroButton" then
                iconTexture = ""
                if private.isRetail then
                    button:SetPoint("BOTTOMLEFT", _G.AchievementMicroButton, "BOTTOMRIGHT", 2, 0)
                else
                    button:SetPoint("BOTTOMLEFT", _G.TalentMicroButton, "BOTTOMRIGHT", 2, 0)
                end
            elseif name == "SocialsMicroButton" then
                iconTexture = ""
                button:SetPoint("BOTTOMLEFT", _G.QuestLogMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "GuildMicroButton" then
                iconTexture = ""
                SetTexture(_G.GuildMicroButtonTabard.background, button, 0.1428, 0.8571, 0.222, 0.889)
                button:SetPoint("BOTTOMLEFT", _G.QuestLogMicroButton, "BOTTOMRIGHT", 2, 0)

                button.NotificationOverlay.UnreadNotificationIcon:SetSize(16, 16)
            elseif name == "LFDMicroButton" then
                iconTexture = ""
                button:SetPoint("BOTTOMLEFT", _G.GuildMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "CollectionsMicroButton" then
                iconTexture = [[Interface\Icons\MountJournalPortrait]]
                left, right, top, bottom = 0.3, 0.92, 0.08, 0.92
                button:SetPoint("BOTTOMLEFT", _G.LFDMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "EJMicroButton" then
                iconTexture = [[Interface\EncounterJournal\UI-EJ-PortraitIcon]]
                button:SetPoint("BOTTOMLEFT", _G.CollectionsMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "StoreMicroButton" then
                iconTexture = [[Interface\Icons\WoW_Store]]
                button:SetPoint("BOTTOMLEFT", _G.EJMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "WorldMapMicroButton" then
                iconTexture = [[Interface\WorldMap\WorldMap-Icon]]
                left, right, top, bottom = 0.21875, 0.6875, 0.109375, 0.8125
                button:SetPoint("BOTTOMLEFT", _G.SocialsMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "MainMenuMicroButton" then
                if private.isRetail then
                    iconTexture = [[Interface\Icons\INV_Misc_QuestionMark]]
                    SetTexture(_G.MainMenuBarPerformanceBar, button, 0.2, 0.8, 0.08, 0.94)
                    _G.MainMenuBarDownload:SetPoint("BOTTOM", 0, 4)
                    button:SetPoint("BOTTOMLEFT", _G.StoreMicroButton, "BOTTOMRIGHT", 2, 0)
                else
                    iconTexture = ""
                    button:SetPoint("BOTTOMLEFT", _G.WorldMapMicroButton, "BOTTOMRIGHT", 2, 0)
                end
            elseif name == "HelpMicroButton" then
                iconTexture = [[Interface\Icons\INV_Misc_QuestionMark]]
                button:SetPoint("BOTTOMLEFT", _G.MainMenuMicroButton, "BOTTOMRIGHT", 2, 0)
            end

            SetMicroButton(button, iconTexture, left, right, top, bottom)
        end
    end

    if private.isRetail and not private.isPatch then
        Skin.MicroButtonAlertTemplate(_G.CharacterMicroButtonAlert)
        Skin.MicroButtonAlertTemplate(_G.TalentMicroButtonAlert)
        Skin.MicroButtonAlertTemplate(_G.CollectionsMicroButtonAlert)
        Skin.MicroButtonAlertTemplate(_G.LFDMicroButtonAlert)
        Skin.MicroButtonAlertTemplate(_G.EJMicroButtonAlert)
        Skin.MicroButtonAlertTemplate(_G.StoreMicroButtonAlert)
        Skin.MicroButtonAlertTemplate(_G.GuildMicroButtonAlert)
    end

    ----====####$$$$%%%%%$$$$####====----
    --    StatusTrackingBarTemplate    --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --             ExpBar             --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --          ReputationBar          --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --           ArtifactBar           --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --            HonorBar            --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --        StatusTrackingBar        --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar and private.isRetail then
        Skin.StatusTrackingBarManagerTemplate(_G.StatusTrackingBarManager)
    end

    ----====####$$$$%%%%%$$$$####====----
    --           MainMenuBar           --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        if private.isRetail then
            _G.MicroButtonAndBagsBar.MicroBagBar:Hide()
            _G.MainMenuBarArtFrameBackground.BackgroundLarge:SetAlpha(0)
            _G.MainMenuBarArtFrameBackground.BackgroundSmall:SetAlpha(0)

            _G.MainMenuBarArtFrame.LeftEndCap:Hide()
            _G.MainMenuBarArtFrame.RightEndCap:Hide()
        else
            _G.hooksecurefunc("MainMenuTrackingBar_Configure", Hook.MainMenuTrackingBar_Configure)
            Skin.FrameTypeStatusBar(_G.MainMenuExpBar)
            _G.MainMenuExpBar:SetHeight(9)
            _G.MainMenuExpBar:SetPoint("TOP", 0, 0)
            Util.PositionBarTicks(_G.MainMenuExpBar, 20)
            _G.ExhaustionLevelFillBar:SetHeight(9)

            -- MainMenuBarArtFrame
            _G.MainMenuXPBarTexture0:SetAlpha(0)
            _G.MainMenuXPBarTexture1:SetAlpha(0)
            _G.MainMenuXPBarTexture2:SetAlpha(0)
            _G.MainMenuXPBarTexture3:SetAlpha(0)

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
            if private.isRetail then
                ActionBarUpButton:ClearAllPoints()
                ActionBarUpButton:SetPoint("TOPLEFT", _G.ActionButton12, "TOPRIGHT", 6, 1)
                ActionBarUpButton:SetBackdropOption("offsets", {
                    left = 1,
                    right = 1,
                    top = 1,
                    bottom = 1,
                })
            else
                ActionBarUpButton:SetBackdropOption("offsets", {
                    left = 8,
                    right = 8,
                    top = 8,
                    bottom = 8,
                })
            end

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
            if private.isRetail then
                ActionBarDownButton:ClearAllPoints()
                ActionBarDownButton:SetPoint("BOTTOMLEFT", _G.ActionButton12, "BOTTOMRIGHT", 6, -1)
                ActionBarDownButton:SetBackdropOption("offsets", {
                    left = 1,
                    right = 1,
                    top = 1,
                    bottom = 1,
                })
            else
                ActionBarDownButton:SetBackdropOption("offsets", {
                    left = 8,
                    right = 8,
                    top = 8,
                    bottom = 8,
                })
            end

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
    --        OverrideActionBar        --
    ----====####$$$$%%%%%$$$$####====----

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

    ----====####$$$$%%%%$$$$####====----
    --         ExtraActionBar         --
    ----====####$$$$%%%%$$$$####====----
    if private.isRetail then
        Skin.ExtraActionButtonTemplate(_G.ExtraActionButton1)
    end

    ----====####$$$$%%%%$$$$####====----
    --        PossessActionBar        --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --       ActionBarController       --
    ----====####$$$$%%%%%$$$$####====----
end
