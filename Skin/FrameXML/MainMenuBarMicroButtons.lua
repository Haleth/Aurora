local _, private = ...

-- [[ Core ]]
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

do --[[ FrameXML\MainMenuBarMicroButtons.lua ]]
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

do --[[ FrameXML\MainMenuBarMicroButtons.xml ]]
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

function private.FrameXML.MainMenuBarMicroButtons()
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

                --[[ Scale ]]--
                _G.GuildMicroButtonTabard:SetAllPoints()
                _G.GuildMicroButtonTabard.emblem:SetSize(16, 16)
                _G.GuildMicroButtonTabard.emblem:SetPoint("CENTER", 0, 3)
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

    --[[ Scale ]]--
    _G.MicroButtonAndBagsBar:SetSize(298, 88)
end
