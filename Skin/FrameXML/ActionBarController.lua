local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals floor

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
            left, right, top, bottom = .19, .81, .21, .82
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
            [_G.MicroButtonAndBagsBar] = 11
        }
        function Hook.MoveMicroButtons(anchor, anchorTo, relAnchor, x, y, isStacked)
            _G.CharacterMicroButton:ClearAllPoints()
            _G.CharacterMicroButton:SetPoint(anchor, anchorTo, relAnchor, anchors[anchorTo], y)
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
            self._auroraTickPool:ReleaseAll()
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
                    bar:SetPoint("BOTTOM", self:GetParent(), 0, -7);
                else
                    bar:SetPoint("BOTTOM", self:GetParent(), 0, -18);
                end
            else
                bar:SetPoint("BOTTOM", self:GetParent(), 0, -11);
            end

            local numTicks = self.largeSize and 20 or 10
            local divWidth = bar:GetWidth() / numTicks
            local xpos = divWidth
            for i = 1, numTicks - 1 do
                local tick = self._auroraTickPool:Acquire()
                tick:SetPoint("TOPLEFT", bar, floor(xpos), 0)
                tick:SetPoint("BOTTOMLEFT", bar, floor(xpos), 0)
                tick:Show()
                xpos = xpos + divWidth
            end
        end
    end
    do --[[ MainMenuBar.lua ]]
        function Hook.MainMenuTrackingBar_Configure(frame, isOnTop)
            local statusBar = frame.StatusBar
            statusBar:SetHeight(11)
            frame:ClearAllPoints()
            if isOnTop then
                frame:SetPoint("BOTTOM", _G.MainMenuBar, "TOP", 0, 1)
            else
                frame:SetPoint("TOP", _G.MainMenuBar)
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
    end
    do --[[ StatusTrackingBarTemplate.xml ]]
        function Skin.StatusTrackingBarManagerTemplate(Frame)
            Util.Mixin(Frame, Hook.StatusTrackingManagerMixin)
            Frame.SingleBarLarge:SetAlpha(0)
            Frame.SingleBarLargeUpper:SetAlpha(0)
            Frame.SingleBarSmall:SetAlpha(0)
            Frame.SingleBarSmallUpper:SetAlpha(0)

            local tickPool = _G.CreateObjectPool(function(pool)
                local tick = Frame:CreateTexture(nil, "ARTWORK")
                tick:SetColorTexture(Color.button:GetRGB())
                tick:SetSize(1, Frame:GetInitialBarHeight())
                return tick
            end, function(pool, tick)
                tick:ClearAllPoints()
                tick:Hide()
            end)
            Frame._auroraTickPool = tickPool
        end
    end
    do --[[ StatusTrackingBarTemplate.xml ]]
        function Skin.StatusTrackingBarTemplate(Frame)
            local StatusBar = Frame.StatusBar
            Skin.FrameTypeStatusBar(StatusBar)

            StatusBar.Background:Hide()
            StatusBar.Underlay:Hide()
            StatusBar.Overlay:Hide()
        end
        function Skin.ReputationStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
        function Skin.HonorStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
        function Skin.ArtifactStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
        function Skin.ExpStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
        function Skin.AzeriteBarTemplate(Frame)
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
        _G.hooksecurefunc("MoveMicroButtons", Hook.MoveMicroButtons)
        _G.MainMenuMicroButton:HookScript("OnUpdate", Hook.MainMenuMicroButton_OnUpdate)

        for i, name in _G.ipairs(_G.MICRO_BUTTONS) do
            local button = _G[name]
            Skin.MainMenuBarMicroButton(button)

            local iconTexture, left, right, top, bottom
            if name == "CharacterMicroButton" then
                SetTexture(_G.MicroButtonPortrait, button)
                button:SetPoint("BOTTOMLEFT", _G.MicroButtonAndBagsBar, "BOTTOMLEFT", 11, 3)
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
                button:SetPoint("BOTTOMLEFT", _G.AchievementMicroButton, "BOTTOMRIGHT", 2, 0)
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
            elseif name == "MainMenuMicroButton" then
                iconTexture = [[Interface\Icons\INV_Misc_QuestionMark]]

                SetTexture(_G.MainMenuBarPerformanceBar, button, 0.2, 0.8, 0.08, 0.94)
                _G.MainMenuBarDownload:SetPoint("BOTTOM", 0, 4)
                button:SetPoint("BOTTOMLEFT", _G.StoreMicroButton, "BOTTOMRIGHT", 2, 0)
            end

            SetMicroButton(button, iconTexture, left, right, top, bottom)
        end
    end

    Skin.MicroButtonAlertTemplate(_G.CharacterMicroButtonAlert)
    Skin.MicroButtonAlertTemplate(_G.TalentMicroButtonAlert)
    Skin.MicroButtonAlertTemplate(_G.CollectionsMicroButtonAlert)
    Skin.MicroButtonAlertTemplate(_G.LFDMicroButtonAlert)
    Skin.MicroButtonAlertTemplate(_G.EJMicroButtonAlert)
    Skin.MicroButtonAlertTemplate(_G.StoreMicroButtonAlert)
    if private.isPatch then
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
    Skin.StatusTrackingBarManagerTemplate(_G.StatusTrackingBarManager)

    ----====####$$$$%%%%%$$$$####====----
    --           MainMenuBar           --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        _G.MicroButtonAndBagsBar.MicroBagBar:Hide()
        _G.MainMenuBarArtFrameBackground.BackgroundLarge:SetAlpha(0)
        _G.MainMenuBarArtFrameBackground.BackgroundSmall:SetAlpha(0)

        _G.MainMenuBarArtFrame.LeftEndCap:Hide()
        _G.MainMenuBarArtFrame.RightEndCap:Hide()
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
    end

    ----====####$$$$%%%%%$$$$####====----
    --         MultiActionBars         --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --        OverrideActionBar        --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --            StanceBar            --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --         ExtraActionBar         --
    ----====####$$$$%%%%$$$$####====----
    Skin.ExtraActionButtonTemplate(_G.ExtraActionButton1)

    ----====####$$$$%%%%$$$$####====----
    --        PossessActionBar        --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --       ActionBarController       --
    ----====####$$$$%%%%%$$$$####====----
end
