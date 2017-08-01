local ADDON_NAME, private = ...

-- [[ Lua Globals ]]
local select = _G.select
local next = _G.next

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame

-- [[ Core ]]
local Aurora = private.Aurora

-- for custom APIs (see docs online)
local LATEST_API_VERSION = "7.0"

-- see F.AddPlugin
local AURORA_LOADED = false
local AuroraConfig

local F, C = _G.unpack(Aurora)

-- [[ Constants and settings ]]

C.frames = {}
C.classicons = { -- adjusted for borderless icons
    ["WARRIOR"]     = {0.01953125, 0.234375, 0.01953125, 0.234375},
    ["MAGE"]        = {0.26953125, 0.48046875, 0.01953125, 0.234375},
    ["ROGUE"]       = {0.515625, 0.7265625, 0.01953125, 0.234375},
    ["DRUID"]       = {0.76171875, 0.97265625, 0.01953125, 0.234375},
    ["HUNTER"]      = {0.01953125, 0.234375, 0.26953125, 0.484375},
    ["SHAMAN"]      = {0.26953125, 0.48046875, 0.26953125, 0.484375},
    ["PRIEST"]      = {0.515625, 0.7265625, 0.26953125, 0.484375},
    ["WARLOCK"]     = {0.76171875, 0.97265625, 0.26953125, 0.484375},
    ["PALADIN"]     = {0.01953125, 0.234375, 0.51953125, 0.734375},
    ["DEATHKNIGHT"] = {0.26953125, 0.48046875, 0.51953125, 0.734375},
    ["MONK"]        = {0.515625, 0.7265625, 0.51953125, 0.734375},
    ["DEMONHUNTER"] = {0.76171875, 0.97265625, 0.51953125, 0.734375},
}

C.media = {
    ["arrowUp"] = "Interface\\AddOns\\Aurora\\media\\arrow-up-active",
    ["arrowDown"] = "Interface\\AddOns\\Aurora\\media\\arrow-down-active",
    ["arrowLeft"] = "Interface\\AddOns\\Aurora\\media\\arrow-left-active",
    ["arrowRight"] = "Interface\\AddOns\\Aurora\\media\\arrow-right-active",
    ["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
    ["checked"] = "Interface\\AddOns\\Aurora\\media\\CheckButtonHilight",
    ["font"] = "Interface\\AddOns\\Aurora\\media\\font.ttf",
    ["gradient"] = "Interface\\AddOns\\Aurora\\media\\gradient",
    ["roleIcons"] = "Interface\\Addons\\Aurora\\media\\UI-LFG-ICON-ROLES",
}

C.defaults = {
    ["acknowledgedSplashScreen"] = false,

    ["alpha"] = 0.5,
    ["bags"] = true,
    ["buttonsHaveGradient"] = true,
    ["chatBubbles"] = true,
        ["chatBubbleNames"] = true,
    ["enableFont"] = true,
    ["loot"] = true,
    ["useCustomColour"] = false,
        ["customColour"] = {r = 1, g = 1, b = 1},
    ["customClassColors"] = false,
    ["tooltips"] = true,
}

-- [[ Cached variables ]]

local buttonsHaveGradient
local _, class = _G.UnitClass("player")
local red, green, blue

-- [[ Variable and module handling ]]

C.themes = {}
C.themes["Aurora"] = {}

-- use of this function ensures that Aurora and custom style (if used) are properly initialised
-- prior to loading third party plugins
F.AddPlugin = function(func)
    if AURORA_LOADED then
        func()
    else
        _G.tinsert(C.themes["Aurora"], func)
    end
end

-- [[ Initialize addon ]]

local SetSkin = CreateFrame("Frame", nil, _G.UIParent)
SetSkin:RegisterEvent("ADDON_LOADED")
SetSkin:SetScript("OnEvent", function(self, event, addon)
    if addon == ADDON_NAME then
        -- [[ Load Variables ]]
        _G.AuroraConfig = _G.AuroraConfig or {}
        AuroraConfig = _G.AuroraConfig

        if AuroraConfig.useButtonGradientColour ~= nil then
            AuroraConfig.buttonsHaveGradient = AuroraConfig.useButtonGradientColour
        end

        -- remove deprecated or corrupt variables
        for key, value in next, AuroraConfig do
            if C.defaults[key] == nil then
                AuroraConfig[key] = nil
            end
        end

        -- load or init variables
        for key, value in next, C.defaults do
            if AuroraConfig[key] == nil then
                if _G.type(value) == "table" then
                    AuroraConfig[key] = {}
                    for k, v in next, value do
                        AuroraConfig[key][k] = value[k]
                    end
                else
                    AuroraConfig[key] = value
                end
            end
        end

        -- init class colors
        if not AuroraConfig.customClassColors or not AuroraConfig.customClassColors[class].colorStr then
            local customClassColors = {}
            private.classColorsReset(customClassColors, true)
            AuroraConfig.customClassColors = customClassColors
        end

        -- [[ Custom style support ]]
        local customStyle = _G.AURORA_CUSTOM_STYLE
        if customStyle and customStyle.apiVersion ~= nil and customStyle.apiVersion == LATEST_API_VERSION then
            local protectedFunctions = {
                ["AddPlugin"] = true,
            }

            -- override settings
            if customStyle.defaults then
                for setting, value in next, customStyle.defaults do
                    AuroraConfig[setting] = value
                end
            end

            -- replace functions
            if customStyle.functions then
                for funcName, func in next, customStyle.functions do
                    if F[funcName] and not protectedFunctions[funcName] then
                        F[funcName] = func
                    end
                end
            end

            -- replace classcolors
            if customStyle.classcolors then
                for classToken, color in next, customStyle.classcolors do
                    AuroraConfig.customClassColors[classToken]:SetRGB(color.r, color.g, color.b)
                end
            end
        end

        -- setup class colours
        function private.updateHighlightColor()
            if AuroraConfig.useCustomColour then
                private.highlightColor:SetRGB(AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b)
            else
                private.highlightColor:SetRGB(_G.CUSTOM_CLASS_COLORS[class]:GetRGB())
            end
        end

        _G.CUSTOM_CLASS_COLORS:RegisterCallback(function()
            for classToken, color in next, _G.CUSTOM_CLASS_COLORS do
                local ccc = AuroraConfig.customClassColors[classToken]
                ccc.r = color.r
                ccc.g = color.g
                ccc.b = color.b
                ccc.colorStr = color.colorStr
            end

            _G.AuroraOptions.refresh()
            private.updateHighlightColor()
        end)

        function private.classColorsInit()
            for classToken, color in next, AuroraConfig.customClassColors do
                _G.CUSTOM_CLASS_COLORS[classToken]:SetRGB(color.r, color.g, color.b)
            end

            private.updateHighlightColor()
            red, green, blue = private.highlightColor:GetRGB()
            C.r, C.g, C.b = red, green, blue
        end
        function private.classColorsHaveChanged()
            for i = 1, #_G.CLASS_SORT_ORDER do
                local classToken = _G.CLASS_SORT_ORDER[i]
                local color = _G.CUSTOM_CLASS_COLORS[classToken]
                local cache = AuroraConfig.customClassColors[classToken]

                if not color:IsEqualTo(cache) then
                    --print("Change found in", classToken)
                    color:SetRGB(cache.r, cache.g, cache.b)
                    return true
                end
            end
        end

        buttonsHaveGradient = AuroraConfig.buttonsHaveGradient

        if buttonsHaveGradient then
            private.buttonColor:SetRGBA(.3, .3, .3, 0.7)
        end
        private.frameColor:SetRGBA(0, 0, 0, AuroraConfig.alpha)

        -- [[ Splash screen for first time users ]]

        if not AuroraConfig.acknowledgedSplashScreen then
            _G.AuroraSplashScreen:Show()
        end

        function Aurora.Base.Post.SetBackdrop(frame, r, g, b, a)
            if buttonsHaveGradient and private.buttonColor:IsEqualTo(r, g, b, a) then
                Aurora.Base.SetTexture(frame:GetBackdropTexture("bg"), "gradientUp")
                Aurora.Base.SetBackdropColor(frame, r, g, b, a)
            elseif not a then
                _G.tinsert(C.frames, frame)
            end
        end

        function private.FrameXML.Post.CharacterFrame()
            _G.CharacterStatsPane.ItemLevelFrame:SetPoint("TOP", 0, -12)
            _G.CharacterStatsPane.ItemLevelFrame.Background:Hide()
            _G.CharacterStatsPane.ItemLevelFrame.Value:SetFontObject("SystemFont_Outline_WTF2")

            _G.hooksecurefunc("PaperDollFrame_UpdateStats", function()
                if ( _G.UnitLevel("player") >= _G.MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY ) then
                    _G.CharacterStatsPane.ItemLevelCategory:Hide()
                    _G.CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -40)
                end
            end)
        end


        -- [[ Load FrameXML ]]
        for i = 1, #private.FrameXML do
            local file, isShared = _G.strsplit(".", private.FrameXML[i])
            local fileList = private.FrameXML
            if isShared then
                file = isShared
                fileList = private.SharedXML
            end
            if fileList[file] then
                fileList[file]()
            end
        end

        -- [[ Load AddOns - some may have loaded before Aurora ]]
        for addonName, func in next, private.AddOns do
            local loaded = _G.IsAddOnLoaded(addonName)
            if loaded then
                func()
            end
        end

        -- from this point, plugins added with F.AddPlugin are executed directly instead of cached
        AURORA_LOADED = true
    end

    -- [[ Load modules ]]

    -- check if the addon loaded is supported by Aurora, and if it is, execute its module
    local addonModule = private.AddOns[addon] or C.themes[addon]
    if addonModule then
        if _G.type(addonModule) == "function" then
            addonModule()
        else
            for _, moduleFunc in next, addonModule do
                moduleFunc()
            end
        end
    end

    -- all this should be moved out of the main file when I have time
    if addon == "Aurora" then

        -- Petition frame

        select(18, _G.PetitionFrame:GetRegions()):Hide()
        select(19, _G.PetitionFrame:GetRegions()):Hide()
        select(23, _G.PetitionFrame:GetRegions()):Hide()
        select(24, _G.PetitionFrame:GetRegions()):Hide()
        _G.PetitionFrameTop:Hide()
        _G.PetitionFrameBottom:Hide()
        _G.PetitionFrameMiddle:Hide()

        F.ReskinPortraitFrame(_G.PetitionFrame, true)
        F.Reskin(_G.PetitionFrameSignButton)
        F.Reskin(_G.PetitionFrameRequestButton)
        F.Reskin(_G.PetitionFrameRenameButton)
        F.Reskin(_G.PetitionFrameCancelButton)

        -- Micro button alerts

        local microButtons = {_G.TalentMicroButtonAlert, _G.CollectionsMicroButtonAlert}
            for _, button in next, microButtons do
            button:DisableDrawLayer("BACKGROUND")
            button:DisableDrawLayer("BORDER")
            button.Arrow:Hide()

            F.SetBD(button)
            F.ReskinClose(button.CloseButton)
        end

        -- Cinematic popup

        _G.CinematicFrameCloseDialog:HookScript("OnShow", function(cinemaFrame)
            cinemaFrame:SetScale(_G.UIParent:GetScale())
        end)

        F.CreateBD(_G.CinematicFrameCloseDialog)
        F.Reskin(_G.CinematicFrameCloseDialogConfirmButton)
        F.Reskin(_G.CinematicFrameCloseDialogResumeButton)

        -- Bonus roll

        local BonusRollFrame = _G.BonusRollFrame
        BonusRollFrame.Background:SetAlpha(0)
        BonusRollFrame.IconBorder:Hide()
        BonusRollFrame.BlackBackgroundHoist.Background:Hide()

        BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(BonusRollFrame.PromptFrame.Icon)

        BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(C.media.backdrop)

        F.CreateBD(BonusRollFrame)
        F.CreateBDFrame(BonusRollFrame.PromptFrame.Timer, .25)

        -- Level up display

        _G.LevelUpDisplaySide:HookScript("OnShow", function(lvlUp)
            for i = 1, #lvlUp.unlockList do
                local f = _G["LevelUpDisplaySideUnlockFrame"..i]

                if not f.restyled then
                    f.icon:SetTexCoord(.08, .92, .08, .92)
                    F.CreateBG(f.icon)
                end
            end
        end)

        -- Movie Frame

        local MovieFrame = _G.MovieFrame
        MovieFrame.CloseDialog:HookScript("OnShow", function(mov)
            mov:SetScale(_G.UIParent:GetScale())
        end)

        F.CreateBD(MovieFrame.CloseDialog)
        F.Reskin(MovieFrame.CloseDialog.ConfirmButton)
        F.Reskin(MovieFrame.CloseDialog.ResumeButton)

        -- Pet battle queue popup

        local PetBattleQueueReadyFrame = _G.PetBattleQueueReadyFrame
        F.CreateBD(PetBattleQueueReadyFrame)
        F.CreateBG(PetBattleQueueReadyFrame.Art)
        F.Reskin(PetBattleQueueReadyFrame.AcceptButton)
        F.Reskin(PetBattleQueueReadyFrame.DeclineButton)

        -- PVP Ready Dialog

        local PVPReadyDialog = _G.PVPReadyDialog
        PVPReadyDialog.background:Hide()
        PVPReadyDialog.bottomArt:Hide()
        PVPReadyDialog.filigree:Hide()

        PVPReadyDialog.roleIcon.texture:SetTexture(C.media.roleIcons)

        do
            local left = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
            left:SetWidth(1)
            left:SetTexture(C.media.backdrop)
            left:SetVertexColor(0, 0, 0)
            left:SetPoint("TOPLEFT", 9, -7)
            left:SetPoint("BOTTOMLEFT", 9, 10)

            local right = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
            right:SetWidth(1)
            right:SetTexture(C.media.backdrop)
            right:SetVertexColor(0, 0, 0)
            right:SetPoint("TOPRIGHT", -8, -7)
            right:SetPoint("BOTTOMRIGHT", -8, 10)

            local top = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
            top:SetHeight(1)
            top:SetTexture(C.media.backdrop)
            top:SetVertexColor(0, 0, 0)
            top:SetPoint("TOPLEFT", 9, -7)
            top:SetPoint("TOPRIGHT", -8, -7)

            local bottom = PVPReadyDialog.roleIcon:CreateTexture(nil, "OVERLAY")
            bottom:SetHeight(1)
            bottom:SetTexture(C.media.backdrop)
            bottom:SetVertexColor(0, 0, 0)
            bottom:SetPoint("BOTTOMLEFT", 9, 10)
            bottom:SetPoint("BOTTOMRIGHT", -8, 10)
        end

        F.CreateBD(PVPReadyDialog)
        PVPReadyDialog.SetBackdrop = F.dummy

        F.Reskin(PVPReadyDialog.enterButton)
        F.Reskin(PVPReadyDialog.leaveButton)
        F.ReskinClose(_G.PVPReadyDialogCloseButton)

        -- [[ Text colour functions ]]
        _G.GameFontBlackMedium:SetTextColor(1, 1, 1)
        _G.QuestFont:SetTextColor(1, 1, 1)
        _G.MailFont_Large:SetTextColor(1, 1, 1)
        _G.MailFont_Large:SetShadowColor(0, 0, 0)
        _G.MailFont_Large:SetShadowOffset(1, -1)
        _G.AvailableServicesText:SetTextColor(1, 1, 1)
        _G.AvailableServicesText:SetShadowColor(0, 0, 0)
        _G.PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
        _G.PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
        _G.PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
        _G.PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
        _G.PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
        _G.PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
        _G.CoreAbilityFont:SetTextColor(1, 1, 1)

        -- [[ Change positions ]]

        _G.TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", _G.TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

        -- [[ Buttons ]]

        F.ReskinClose(_G.ItemRefCloseButton)
    end
end)
