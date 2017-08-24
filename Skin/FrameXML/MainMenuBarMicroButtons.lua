local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

local function SetTexture(texture, left, right, top, bottom)
    texture:SetTexCoord(left, right, top, bottom)
    texture:ClearAllPoints()
    texture:SetPoint("TOPLEFT", 1, -1)
    texture:SetPoint("BOTTOMRIGHT", -1, 1)
end
local function SetMicroButton(button, file, left, right, top, bottom)
    if file == "" then
        if not left then
            left, right, top, bottom = 0.2, 0.8, 0.5, 0.9
        end
        SetTexture(button:GetNormalTexture(), left, right, top, bottom)
        SetTexture(button:GetPushedTexture(), left, right, top, bottom)
        SetTexture(button:GetDisabledTexture(), left, right, top, bottom)
    elseif file then
        if not left then
            left, right, top, bottom = 0.2, 0.8, 0.08, 0.92
        end
        button:SetNormalTexture(file)
        SetTexture(button:GetNormalTexture(), left, right - 0.04, top + 0.04, bottom)

        button:SetPushedTexture(file)
        local pushed = button:GetPushedTexture()
        SetTexture(pushed, left + 0.04, right, top, bottom - 0.04)
        pushed:SetVertexColor(0.5, 0.5, 0.5)

        button:SetDisabledTexture(file)
        local disabled = button:GetDisabledTexture()
        SetTexture(disabled, left, right, top, bottom)
        disabled:SetDesaturated(true)
    end
end

do --[[ FrameXML\MainMenuBarMicroButtons.lua ]]
    function Hook.MoveMicroButtons(anchor, anchorTo, relAnchor, x, y, isStacked)
        _G.CharacterMicroButton:ClearAllPoints()
        if anchorTo == _G.PetBattleFrame.BottomFrame.MicroButtonFrame then
            _G.CharacterMicroButton:SetPoint(anchor, anchorTo, relAnchor, -12, 5)
        elseif anchorTo == _G.OverrideActionBar then
            _G.CharacterMicroButton:SetPoint(anchor, anchorTo, relAnchor, x, y + 4)
        else
            _G.CharacterMicroButton:SetPoint(anchor, anchorTo, relAnchor, 554, 5)
        end

        _G.LFDMicroButton:ClearAllPoints()
        if isStacked then
            _G.LFDMicroButton:SetPoint("TOPLEFT", _G.CharacterMicroButton, "BOTTOMLEFT", 0, -3)
        else
            _G.LFDMicroButton:SetPoint("BOTTOMLEFT", _G.GuildMicroButton, "BOTTOMRIGHT", 3, 0)
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
    function Skin.MainMenuBarMicroButton(button)
        button:SetSize(24, 32)
        button:SetHighlightTexture("")

        button:SetHitRectInsets(0, 1, 0, 1)

        button.Flash:SetTexCoord(0.0938, 0.4375, 0.1094, 0.5625)
        button.Flash:SetPoint("TOPLEFT")
        button.Flash:SetPoint("BOTTOMRIGHT")

        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
        Base.SetHighlight(button, "backdrop")
    end
    function Skin.MicroButtonAlertTemplate(frame)
        Skin.GlowBoxTemplate(frame)

        Skin.UIPanelCloseButton(frame.CloseButton)
        frame.CloseButton:SetPoint("TOPRIGHT", -4, -4)

        Skin.GlowBoxArrowTemplate(frame.Arrow)
        frame.Arrow:SetPoint("TOP", frame, "BOTTOM")
    end
end

function private.FrameXML.MainMenuBarMicroButtons()
    _G.hooksecurefunc("MoveMicroButtons", Hook.MoveMicroButtons)
    _G.MainMenuMicroButton:HookScript("OnUpdate", Hook.MainMenuMicroButton_OnUpdate)

    local prev
    for i, name in _G.ipairs(_G.MICRO_BUTTONS) do
        local button = _G[name]
        Skin.MainMenuBarMicroButton(button)

        if prev then
            button:SetPoint("BOTTOMLEFT", prev, "BOTTOMRIGHT", 3, 0)
        else
            button:SetPoint("BOTTOMLEFT", 554, 5)
        end
        prev = button

        local iconTexture, left, right, top, bottom
        if name == "CharacterMicroButton" then
            _G.MicroButtonPortrait:ClearAllPoints()
            _G.MicroButtonPortrait:SetPoint("TOPLEFT", 1, -1)
            _G.MicroButtonPortrait:SetPoint("BOTTOMRIGHT", -1, 1)
        elseif name == "SpellbookMicroButton" then
            iconTexture = [[Interface\Icons\INV_Misc_Book_09]]
        elseif name == "TalentMicroButton" then
            iconTexture = [[Interface\Icons\Ability_Marksmanship]]
        elseif name == "GuildMicroButton" then
            iconTexture = ""

            _G.GuildMicroButtonTabard:ClearAllPoints()
            _G.GuildMicroButtonTabard:SetPoint("TOPLEFT", 1, -1)
            _G.GuildMicroButtonTabard:SetPoint("BOTTOMRIGHT", -1, 1)

            SetTexture(_G.GuildMicroButtonTabard.background, 0.1, 0.9, 0.45, 0.9)
            _G.GuildMicroButtonTabard.emblem:SetPoint("CENTER", 0, 2)
        elseif name == "EJMicroButton" then
            iconTexture = [[Interface\EncounterJournal\UI-EJ-PortraitIcon]]
        elseif name == "CollectionsMicroButton" then
            iconTexture = [[Interface\Icons\MountJournalPortrait]]
            left, right, top, bottom = 0.3, 0.92, 0.08, 0.92
        elseif name == "MainMenuMicroButton" then
            iconTexture = [[Interface\Icons\INV_Misc_QuestionMark]]

            SetTexture(_G.MainMenuBarPerformanceBar, 0.2, 0.8, 0.08, 0.94)
            _G.MainMenuBarDownload:SetPoint("BOTTOM", 0, 4)
        elseif name == "StoreMicroButton" then
            iconTexture = [[Interface\Icons\WoW_Store]]
        else
            iconTexture = ""
        end

        SetMicroButton(button, iconTexture, left, right, top, bottom)
    end

    Skin.MicroButtonAlertTemplate(_G.TalentMicroButtonAlert)
    _G.TalentMicroButtonAlert:SetPoint("BOTTOM", _G.TalentMicroButtonAlert.MicroButton, "TOP", 0, 16)
    Skin.MicroButtonAlertTemplate(_G.CollectionsMicroButtonAlert)
    _G.CollectionsMicroButtonAlert:SetPoint("BOTTOM", _G.CollectionsMicroButtonAlert.MicroButton, "TOP", 0, 16)
    Skin.MicroButtonAlertTemplate(_G.LFDMicroButtonAlert)
    _G.LFDMicroButtonAlert:SetPoint("BOTTOM", _G.LFDMicroButtonAlert.MicroButton, "TOP", 0, 16)
    Skin.MicroButtonAlertTemplate(_G.EJMicroButtonAlert)
    _G.EJMicroButtonAlert:SetPoint("BOTTOM", _G.EJMicroButtonAlert.MicroButton, "TOP", 0, 16)
end
