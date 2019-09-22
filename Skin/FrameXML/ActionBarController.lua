local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals floor

-- TODO: Reorganized the Action Bar formatting.

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

local function SetTexture(texture, anchor, left, right, top, bottom)
    if left then
        texture:SetTexCoord(left, right, top, bottom)
    end
    texture:ClearAllPoints()
    texture:SetPoint("TOPLEFT", anchor, 1, -1)
    texture:SetPoint("BOTTOMRIGHT", anchor, -1, 1)
end
local function SetMicroButton(button, file, left, right, top, bottom)
    if file == "" then
        if not left then
            left, right, top, bottom = .19, .81, .21, .82
        end
        SetTexture(button:GetNormalTexture(), button, left, right, top, bottom)
        SetTexture(button:GetPushedTexture(), button, left, right, top, bottom)
        SetTexture(button:GetDisabledTexture(), button, left, right, top, bottom)
    elseif file then
        if not left then
            left, right, top, bottom = 0.2, 0.8, 0.08, 0.92
        end
        button:SetNormalTexture(file)
        SetTexture(button:GetNormalTexture(), button, left, right - 0.04, top + 0.04, bottom)

        button:SetPushedTexture(file)
        local pushed = button:GetPushedTexture()
        SetTexture(pushed, button, left + 0.04, right, top, bottom - 0.04)
        pushed:SetVertexColor(0.5, 0.5, 0.5)

        button:SetDisabledTexture(file)
        local disabled = button:GetDisabledTexture()
        SetTexture(disabled, button, left, right, top, bottom)
        disabled:SetDesaturated(true)
    else
        button:SetNormalTexture("")
        button:SetPushedTexture("")
        button:SetDisabledTexture("")
    end
end

do --[[ FrameXML\ActionBarController.lua ]]
    do --[[ MainMenuBarMicroButtons.lua ]]
        local anchors = {
            [_G.UIParent] = 11
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
        function Hook.MainMenuMicroButton_OnUpdate(self, elapsed)
            if self.updateInterval == _G.PERFORMANCEBAR_UPDATE_INTERVAL then
                local status = _G.GetFileStreamingStatus()
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

            -- 24 x 34
            Base.SetBackdrop(Button, Color.button)

            Button:SetHighlightTexture("")
            Button.Flash:SetPoint("TOPLEFT", 1, -1)
            Button.Flash:SetPoint("BOTTOMRIGHT", -1, 1)
            Button.Flash:SetTexCoord(.1818, .7879, .175, .875)

            Base.SetHighlight(Button, "backdrop")
        end
        function Skin.MicroButtonAlertTemplate(Frame)
            Skin.GlowBoxFrame(Frame)
        end
    end
    do --[[ ActionButtonTemplate.xml ]]
        function Skin.ActionButtonTemplate(CheckButton)
            Base.CropIcon(CheckButton.icon)

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
                edgeSize = 1,
                bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                insets = {left = 1, right = 1, top = 1, bottom = 1}
            })
            CheckButton:SetBackdropColor(1, 1, 1, 0.75)
            CheckButton:SetBackdropBorderColor(Color.frame:GetRGB())
            Base.CropIcon(CheckButton:GetBackdropTexture("bg"))

            CheckButton.icon:SetPoint("TOPLEFT", 1, -1)
            CheckButton.icon:SetPoint("BOTTOMRIGHT", -1, 1)
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

            local iconTexture
            if name == "CharacterMicroButton" then
                SetTexture(_G.MicroButtonPortrait, button)
                button:SetPoint("BOTTOMLEFT", _G.UIParent, "BOTTOMLEFT", 11, 3)
            elseif name == "SpellbookMicroButton" then
                iconTexture = [[Interface\Icons\INV_Misc_Book_09]]
                button:SetPoint("BOTTOMLEFT", _G.CharacterMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "TalentMicroButton" then
                iconTexture = [[Interface\Icons\Ability_Marksmanship]]
                button:SetPoint("BOTTOMLEFT", _G.SpellbookMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "QuestLogMicroButton" then
                iconTexture = ""
                button:SetPoint("BOTTOMLEFT", _G.TalentMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "SocialsMicroButton" then
                iconTexture = ""
                button:SetPoint("BOTTOMLEFT", _G.QuestLogMicroButton, "BOTTOMRIGHT", 2, 0)
                button.NotificationOverlay.UnreadNotificationIcon:SetSize(16, 16)
            elseif name == "WorldMapMicroButton" then
                iconTexture = ""
                button:SetPoint("BOTTOMLEFT", _G.SocialsMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "MainMenuMicroButton" then
                iconTexture = [[Interface\Icons\INV_Misc_QuestionMark]]
                _G.MainMenuBarDownload:SetPoint("BOTTOM", 0, 4)
                button:SetPoint("BOTTOMLEFT", _G.WorldMapMicroButton, "BOTTOMRIGHT", 2, 0)
            elseif name == "HelpMicroButton" then
                iconTexture = ""
                button:SetPoint("BOTTOMLEFT", _G.MainMenuMicroButton, "BOTTOMRIGHT", 2, 0)
            end

            SetMicroButton(button, iconTexture)
        end
    end

    ----====####$$$$%%%%%$$$$####====----
    --           MainMenuBar           --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
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
        for i = 1, 12 do -- 8
            Skin.ActionBarButtonTemplate(_G["ActionButton"..i])
        end
    end

    ----====####$$$$%%%%%$$$$####====----
    --         MultiActionBars         --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --            StanceBar            --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --       ActionBarController       --
    ----====####$$$$%%%%%$$$$####====----
end
