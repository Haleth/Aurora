local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals ipairs type select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ChatConfigFrame.lua ]]
    function Hook.ChatConfig_CreateCheckboxes(frame, checkBoxTable, checkBoxTemplate, title)
        local checkBoxNameString = frame:GetName().."CheckBox"

        for index, value in ipairs(checkBoxTable) do
            local checkBoxName = checkBoxNameString..index
            if not _G[checkBoxName]._auroraSkinned then
                Skin[checkBoxTemplate](_G[checkBoxName])
                _G[checkBoxName]._auroraSkinned = true
            end
        end
    end
    function Hook.ChatConfig_CreateTieredCheckboxes(frame, checkBoxTable, checkBoxTemplate, subCheckBoxTemplate, columns, spacing)
        local checkBoxNameString = frame:GetName().."CheckBox"

        for index, value in ipairs(checkBoxTable) do
            local checkBoxName = checkBoxNameString..index
            Skin[checkBoxTemplate](_G[checkBoxName])

            if value.subTypes then
                local subCheckBoxNameString = checkBoxName.."_"
                for i, v in ipairs(value.subTypes) do
                    Skin[subCheckBoxTemplate](_G[subCheckBoxNameString..i])
                end
            end
        end
    end
    function Hook.ChatConfig_CreateColorSwatches(frame, swatchTable, swatchTemplate, title)
        local nameString = frame:GetName().."Swatch"

        for index, value in ipairs(swatchTable) do
            local swatchName = nameString..index
            Skin[swatchTemplate](_G[swatchName])
        end
    end
    function Hook.ChatConfig_UpdateCheckboxes(frame)
        -- List of message types in current chat frame
        if not _G.FCF_GetCurrentChatFrame() then
            return
        end
        local height
        local checkBoxTable = frame.checkBoxTable
        local checkBoxNameString = frame:GetName().."CheckBox"
        local checkBox, baseName
        local topnum, padding = 0, Scale.Value(8)
        for index, value in ipairs(checkBoxTable) do
            baseName = checkBoxNameString..index
            checkBox = _G[baseName.."Check"]
            if checkBox then
                if not height then
                    height = checkBox:GetParent():GetHeight()
                end
                if type(value.hidden) == "function" then
                    if not value.hidden() then
                        topnum = index
                    end
                else
                    if not value.hidden then
                        topnum = index
                    end
                end
            end
            Scale.RawSetHeight(frame, topnum * height + padding)
        end
    end
end

do --[[ FrameXML\ChatConfigFrame.xml ]]
    function Skin.ConfigCategoryButtonTemplate(Button)
        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end
    function Skin.ConfigFilterButtonTemplate(Button)
        Skin.ConfigCategoryButtonTemplate(Button)
    end
    function Skin.ChatConfigBoxTemplate(Frame)
        Frame:SetBackdrop(nil)

        --[[ Scale ]]--
        Frame:SetSize(Frame:GetSize())
    end
    function Skin.ChatConfigBoxWithHeaderTemplate(Frame)
        Skin.ChatConfigBoxTemplate(Frame)

        --[[ Scale ]]--
        Frame.header:SetPoint("BOTTOMLEFT", Frame, "TOPLEFT", 0, 2)
    end
    function Skin.WideChatConfigBoxWithHeaderAndClassColorsTemplate(Frame)
        Skin.ChatConfigBoxWithHeaderTemplate(Frame)

        --[[ Scale ]]--
        _G[Frame:GetName().."ColorHeader"]:SetPoint("BOTTOM", Frame, "TOPLEFT", 361, 2)
    end

    function Skin.ChatConfigBaseCheckButtonTemplate(CheckButton)
        CheckButton:SetNormalTexture("")
        CheckButton:SetPushedTexture("")
        CheckButton:SetHighlightTexture("")

        local bd = _G.CreateFrame("Frame", nil, CheckButton)
        bd:SetPoint("TOPLEFT", 6, -6)
        bd:SetPoint("BOTTOMRIGHT", -6, 6)
        bd:SetFrameLevel(CheckButton:GetFrameLevel())
        Base.SetBackdrop(bd, Color.frame)
        bd:SetBackdropBorderColor(Color.button)

        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", -1, 1)
        check:SetPoint("BOTTOMRIGHT", 1, -1)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        local disabled = CheckButton:GetDisabledCheckedTexture()
        disabled:SetAllPoints(check)

        CheckButton._auroraBDFrame = bd
        Base.SetHighlight(CheckButton, "backdrop")

        --[[ Scale ]]--
        CheckButton:SetSize(CheckButton:GetSize())
    end
    function Skin.ChatConfigCheckButtonTemplate(CheckButton)
        Skin.ChatConfigBaseCheckButtonTemplate(CheckButton)
    end
    function Skin.ChatConfigSmallCheckButtonTemplate(CheckButton)
        Skin.ChatConfigBaseCheckButtonTemplate(CheckButton)
    end
    function Skin.ChatConfigCheckBoxTemplate(Frame)
        Base.SetBackdrop(Frame, Color.frame)
        Frame:SetBackdropBorderColor(Color.button)
        if private.isPatch then
            Skin.ChatConfigCheckButtonTemplate(Frame.CheckButton)
        else
            Skin.ChatConfigCheckButtonTemplate(_G[Frame:GetName().."Check"])
        end

        --[[ Scale ]]--
        Frame:SetSize(Frame:GetSize())
    end
    function Skin.ChatConfigCheckBoxWithSwatchTemplate(Frame)
        Skin.ChatConfigCheckBoxTemplate(Frame)
        if not private.isPatch then
            Frame.ColorSwatch = _G[Frame:GetName().."ColorSwatch"]
        end

        Skin.ColorSwatch(Frame.ColorSwatch)

        --[[ Scale ]]--
        Frame.ColorSwatch:SetPoint("LEFT", 178, 0)
    end
    function Skin.ChatConfigWideCheckBoxWithSwatchTemplate(Frame)
        Skin.ChatConfigCheckBoxWithSwatchTemplate(Frame)

        --[[ Scale ]]--
        Frame.ColorSwatch:SetPoint("LEFT", 350, 0)
    end
    function Skin.ChatConfigCheckBoxWithSwatchAndClassColorTemplate(Frame) -- not isPatch
        Skin.ChatConfigCheckBoxWithSwatchTemplate(Frame)
        Skin.ChatConfigBaseCheckButtonTemplate(_G[Frame:GetName().."ColorClasses"])
    end
    function Skin.MovableChatConfigWideCheckBoxWithSwatchTemplate(Frame)
        Skin.ChatConfigWideCheckBoxWithSwatchTemplate(Frame)
        Frame.ArtOverlay.GrayedOut:SetPoint("TOPLEFT")

        --[[ Scale ]]--
        Frame.CloseChannel:SetSize(Frame.CloseChannel:GetSize())
        Frame.CloseChannel:SetPoint("RIGHT", -8, 0)
    end
    function Skin.ChatConfigSwatchTemplate(Frame)
        Base.SetBackdrop(Frame, Color.frame)
        Frame:SetBackdropBorderColor(Color.button)
        Skin.ColorSwatch(_G[Frame:GetName().."ColorSwatch"])

        --[[ Scale ]]--
        Frame:SetSize(Frame:GetSize())
    end
    function Skin.ChatConfigTabTemplate(Button)
        local name = Button:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."Right"]:Hide()

        _G[name.."Text"]:SetHeight(0)
        _G[name.."Text"]:SetPoint("LEFT", 0, -5)
        _G[name.."Text"]:SetPoint("RIGHT", 0, -5)
        Button:GetHighlightTexture():Hide()

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end
    function Skin.ChatWindowTab(Button)
        Skin.ChatTabArtTemplate(Button)
    end


    -- not a template
    function Skin.ChatConfigMoveFilter(Button, direction)
        local bg = _G.CreateFrame("Frame", nil, Button)
        bg:SetPoint("TOPLEFT", 6, -7)
        bg:SetPoint("BOTTOMRIGHT", -6, 7)
        bg:SetFrameLevel(Button:GetFrameLevel())
        Base.SetBackdrop(bg, Color.button)

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetHighlightTexture("")

        local disabled = Button:GetDisabledTexture()
        disabled:SetVertexColor(0, 0, 0, .3)
        disabled:SetDrawLayer("OVERLAY")
        disabled:SetAllPoints(bg)

        local arrow = Button:CreateTexture(nil, "ARTWORK")
        if direction == "Up" then
            arrow:SetPoint("TOPLEFT", bg, 2, -5)
            arrow:SetPoint("BOTTOMRIGHT", bg, -3, 4)
        else
            arrow:SetPoint("TOPLEFT", bg, 4, -4)
            arrow:SetPoint("BOTTOMRIGHT", bg, -4, 5)
        end
        Base.SetTexture(arrow, "arrow"..direction)

        Button._auroraHighlight = {arrow}
        Base.SetHighlight(Button, "texture")

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end
    function Skin.ColorSwatch(Button)
        local bg = _G[Button:GetName().."SwatchBg"]
        bg:SetColorTexture(0, 0, 0)
        bg:SetPoint("TOPLEFT")
        bg:SetPoint("BOTTOMRIGHT")

        local texture = Button:GetNormalTexture()
        texture:SetColorTexture(1, 1, 1)
        texture:SetPoint("TOPLEFT", bg, 1, -1)
        texture:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end
end

function private.FrameXML.ChatConfigFrame()
    _G.hooksecurefunc("ChatConfig_CreateCheckboxes", Hook.ChatConfig_CreateCheckboxes)
    _G.hooksecurefunc("ChatConfig_CreateTieredCheckboxes", Hook.ChatConfig_CreateTieredCheckboxes)
    _G.hooksecurefunc("ChatConfig_CreateColorSwatches", Hook.ChatConfig_CreateColorSwatches)
    _G.hooksecurefunc("ChatConfig_UpdateCheckboxes", Hook.ChatConfig_UpdateCheckboxes)

    local ChatConfigFrame = _G.ChatConfigFrame
    Base.SetBackdrop(ChatConfigFrame)

    _G.ChatConfigFrameHeader:Hide()
    _G.ChatConfigFrameHeaderText:ClearAllPoints()
    _G.ChatConfigFrameHeaderText:SetPoint("TOPLEFT")
    _G.ChatConfigFrameHeaderText:SetPoint("BOTTOMRIGHT", _G.ChatConfigFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.ChatConfigBoxTemplate(_G.ChatConfigCategoryFrame)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton1)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton2)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton3)
    Skin.ConfigCategoryButtonTemplate(_G.ChatConfigCategoryFrameButton4)
    if private.isPatch then
        _G.hooksecurefunc(ChatConfigFrame.ChatTabManager.tabPool, "Acquire", Hook.ObjectPoolMixin_Acquire)
    end
    Skin.ChatConfigBoxTemplate(_G.ChatConfigBackgroundFrame)

    local divider = _G.ChatConfigFrame:CreateTexture()
    divider:SetPoint("TOPLEFT", _G.ChatConfigCategoryFrame, "TOPRIGHT")
    divider:SetPoint("BOTTOMRIGHT", _G.ChatConfigBackgroundFrame, "BOTTOMLEFT", 0, 60)
    divider:SetColorTexture(1, 1, 1, .2)

    Skin.WideChatConfigBoxWithHeaderAndClassColorsTemplate(_G.ChatConfigChatSettingsLeft)
    if not private.isPatch then
        Skin.ChatConfigBoxTemplate(_G.ChatConfigChatSettingsClassColorLegend)
    end
    Skin.WideChatConfigBoxWithHeaderAndClassColorsTemplate(_G.ChatConfigChannelSettingsLeft)
    if not private.isPatch then
        Skin.ChatConfigBoxTemplate(_G.ChatConfigChannelSettingsClassColorLegend)
    end
    Skin.ChatConfigBoxWithHeaderTemplate(_G.ChatConfigOtherSettingsCombat)
    Skin.ChatConfigBoxWithHeaderTemplate(_G.ChatConfigOtherSettingsPVP)
    Skin.ChatConfigBoxWithHeaderTemplate(_G.ChatConfigOtherSettingsSystem)
    Skin.ChatConfigBoxWithHeaderTemplate(_G.ChatConfigOtherSettingsCreature)

    Skin.UIPanelButtonTemplate(ChatConfigFrame.DefaultButton)
    ChatConfigFrame.DefaultButton:SetPoint("BOTTOMLEFT", 10, 10)
    Skin.UIPanelButtonTemplate(ChatConfigFrame.RedockButton)
    ChatConfigFrame.RedockButton:SetPoint("BOTTOMLEFT", ChatConfigFrame.DefaultButton, "BOTTOMRIGHT", 5, 0)
    Skin.UIPanelButtonTemplate(_G.CombatLogDefaultButton)
    --Skin.UIPanelButtonTemplate(_G.ChatConfigFrameCancelButton) -- BlizzWTF: Not used?
    Skin.UIPanelButtonTemplate(_G.ChatConfigFrameOkayButton)
    _G.ChatConfigFrameOkayButton:ClearAllPoints()
    _G.ChatConfigFrameOkayButton:SetPoint("BOTTOMRIGHT", -10, 10)

    --[[ Scale ]]--
    ChatConfigFrame:SetSize(745, 605)
    _G.ChatConfigCategoryFrame:SetPoint("TOPLEFT", 12, -57)
    _G.ChatConfigCategoryFrame:SetPoint("BOTTOMRIGHT", ChatConfigFrame, "BOTTOMLEFT", 137, 35)
    _G.ChatConfigCategoryFrameButton1:SetPoint("TOPLEFT", 5, -7)
    _G.ChatConfigCategoryFrameButton1:SetPoint("TOPRIGHT", -5, -7)
    _G.ChatConfigCategoryFrameButton2:SetPoint("TOPLEFT", _G.ChatConfigCategoryFrameButton1, "BOTTOMLEFT", 0, -1)
    _G.ChatConfigCategoryFrameButton2:SetPoint("TOPRIGHT", _G.ChatConfigCategoryFrameButton1, "BOTTOMRIGHT", 0, -1)
    _G.ChatConfigCategoryFrameButton3:SetPoint("TOPLEFT", _G.ChatConfigCategoryFrameButton2, "BOTTOMLEFT", 0, -1)
    _G.ChatConfigCategoryFrameButton3:SetPoint("TOPRIGHT", _G.ChatConfigCategoryFrameButton2, "BOTTOMRIGHT", 0, -1)
    _G.ChatConfigCategoryFrameButton4:SetPoint("TOPLEFT", _G.ChatConfigCategoryFrameButton3, "BOTTOMLEFT", 0, -1)
    _G.ChatConfigCategoryFrameButton4:SetPoint("TOPRIGHT", _G.ChatConfigCategoryFrameButton3, "BOTTOMRIGHT", 0, -1)

    _G.ChatConfigBackgroundFrame:SetPoint("TOPLEFT", _G.ChatConfigCategoryFrame, "TOPRIGHT", 1, 0)
    _G.ChatConfigBackgroundFrame:SetPoint("BOTTOMRIGHT", -12, 35)

    _G.ChatConfigChatSettingsLeft:SetPoint("TOPLEFT", 13, -30)
    _G.ChatConfigChannelSettingsLeft:SetPoint("TOPLEFT", 13, -30)
    _G.ChatConfigOtherSettingsCombat:SetPoint("TOPLEFT", 13, -30)
    _G.ChatConfigOtherSettingsPVP:SetPoint("TOPLEFT", _G.ChatConfigOtherSettingsCombat, "BOTTOMLEFT", 0, -25)
    _G.ChatConfigOtherSettingsSystem:SetPoint("TOPLEFT", _G.ChatConfigOtherSettingsCombat, "TOPRIGHT", 50, 0)
    _G.ChatConfigOtherSettingsCreature:SetPoint("TOPLEFT", _G.ChatConfigOtherSettingsSystem, "BOTTOMLEFT", 0, -25)

    -------------------------
    -- Combat Log Settings --
    -------------------------
    Skin.ChatConfigBoxTemplate(_G.ChatConfigCombatSettingsFilters)
    Skin.FauxScrollFrameTemplateLight(_G.ChatConfigCombatSettingsFiltersScrollFrame)
    _G.ChatConfigCombatSettingsFiltersScrollFrame:SetPoint("TOPLEFT", 5, -5)
    _G.ChatConfigCombatSettingsFiltersScrollFrame:SetPoint("BOTTOMRIGHT", -19, 5)
    Skin.ConfigFilterButtonTemplate(_G.ChatConfigCombatSettingsFiltersButton1)
    Skin.ConfigFilterButtonTemplate(_G.ChatConfigCombatSettingsFiltersButton2)
    Skin.ConfigFilterButtonTemplate(_G.ChatConfigCombatSettingsFiltersButton3)
    Skin.ConfigFilterButtonTemplate(_G.ChatConfigCombatSettingsFiltersButton4)
    Skin.UIPanelButtonTemplate(_G.ChatConfigCombatSettingsFiltersDeleteButton)
    Skin.UIPanelButtonTemplate(_G.ChatConfigCombatSettingsFiltersAddFilterButton)
    _G.ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", _G.ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -5, 0)
    Skin.UIPanelButtonTemplate(_G.ChatConfigCombatSettingsFiltersCopyFilterButton)
    _G.ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", _G.ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -5, 0)
    Skin.ChatConfigMoveFilter(_G.ChatConfigMoveFilterUpButton, "Up")
    Skin.ChatConfigMoveFilter(_G.ChatConfigMoveFilterDownButton, "Down")
    _G.ChatConfigMoveFilterDownButton:SetPoint("LEFT", _G.ChatConfigMoveFilterUpButton, "RIGHT", -5, 0)

    Skin.ChatConfigBoxWithHeaderTemplate(_G.CombatConfigMessageSourcesDoneBy)
    Skin.ChatConfigBoxWithHeaderTemplate(_G.CombatConfigMessageSourcesDoneTo)

    Skin.ChatConfigBoxWithHeaderTemplate(_G.CombatConfigColorsUnitColors)
    _G.CombatConfigColorsHighlighting:SetBackdrop(nil)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsHighlightingLine)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsHighlightingAbility)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsHighlightingDamage)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsHighlightingSchool)

    _G.CombatConfigColorsColorizeUnitName:SetBackdrop(nil)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeUnitNameCheck)
    _G.CombatConfigColorsColorizeSpellNames:SetBackdrop(nil)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeSpellNamesCheck)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsColorizeSpellNamesSchoolColoring)
    Skin.ColorSwatch(_G.CombatConfigColorsColorizeSpellNamesColorSwatch)
    _G.CombatConfigColorsColorizeDamageNumber:SetBackdrop(nil)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeDamageNumberCheck)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigColorsColorizeDamageNumberSchoolColoring)
    Skin.ColorSwatch(_G.CombatConfigColorsColorizeDamageNumberColorSwatch)
    _G.CombatConfigColorsColorizeDamageSchool:SetBackdrop(nil)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeDamageSchoolCheck)
    _G.CombatConfigColorsColorizeEntireLine:SetBackdrop(nil)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigColorsColorizeEntireLineCheck)
    Skin.UIRadioButtonTemplate(_G.CombatConfigColorsColorizeEntireLineBySource)
    Skin.UIRadioButtonTemplate(_G.CombatConfigColorsColorizeEntireLineByTarget)

    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigFormattingShowTimeStamp)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigFormattingShowBraces)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigFormattingUnitNames)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigFormattingSpellNames)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigFormattingItemNames)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigFormattingFullText)

    Skin.InputBoxTemplate(_G.CombatConfigSettingsNameEditBox)
    Skin.UIPanelButtonTemplate(_G.CombatConfigSettingsSaveButton)
    Skin.ChatConfigCheckButtonTemplate(_G.CombatConfigSettingsShowQuickButton)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigSettingsSolo)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigSettingsParty)
    Skin.ChatConfigSmallCheckButtonTemplate(_G.CombatConfigSettingsRaid)

    for index, value in ipairs(_G.COMBAT_CONFIG_TABS) do
        Skin.ChatConfigTabTemplate(_G[_G.CHAT_CONFIG_COMBAT_TAB_NAME..index])
    end

    --[[ Scale ]]--
    _G.ChatConfigCombatSettings:SetPoint("TOPLEFT", _G.ChatConfigCategoryFrame, "TOPRIGHT", 1, 0)
    _G.ChatConfigCombatSettings:SetPoint("BOTTOMRIGHT", -12, 35)
    for index, value in ipairs(_G.COMBAT_CONFIG_TABS) do
        local tab = _G[_G.CHAT_CONFIG_COMBAT_TAB_NAME..index]
        if index > 1 then
            tab:SetPoint("BOTTOMLEFT", _G[_G.CHAT_CONFIG_COMBAT_TAB_NAME..(index - 1)], "BOTTOMRIGHT", -1, 0);
        else
            tab:SetPoint("BOTTOMLEFT", _G.ChatConfigBackgroundFrame, "TOPLEFT", 2, -1);
        end
    end

    _G.ChatConfigCombatSettingsFilters:SetPoint("BOTTOMRIGHT", _G.ChatConfigCombatSettings, "TOPRIGHT", 0, -85)
    _G.ChatConfigCombatSettingsFiltersButton1:SetPoint("TOPLEFT", 5, -7)
    _G.ChatConfigCombatSettingsFiltersButton1:SetPoint("TOPRIGHT", -5, -7)
    _G.ChatConfigCombatSettingsFiltersButton2:SetPoint("TOPLEFT", _G.ChatConfigCombatSettingsFiltersButton1, "BOTTOMLEFT", 0, -2)
    _G.ChatConfigCombatSettingsFiltersButton2:SetPoint("TOPRIGHT", _G.ChatConfigCombatSettingsFiltersButton1, "BOTTOMRIGHT", 0, -2)
    _G.ChatConfigCombatSettingsFiltersButton3:SetPoint("TOPLEFT", _G.ChatConfigCombatSettingsFiltersButton2, "BOTTOMLEFT", 0, -2)
    _G.ChatConfigCombatSettingsFiltersButton3:SetPoint("TOPRIGHT", _G.ChatConfigCombatSettingsFiltersButton2, "BOTTOMRIGHT", 0, -2)
    _G.ChatConfigCombatSettingsFiltersButton4:SetPoint("TOPLEFT", _G.ChatConfigCombatSettingsFiltersButton3, "BOTTOMLEFT", 0, -2)
    _G.ChatConfigCombatSettingsFiltersButton4:SetPoint("TOPRIGHT", _G.ChatConfigCombatSettingsFiltersButton3, "BOTTOMRIGHT", 0, -2)

    _G.CombatConfigMessageSourcesDoneBy:SetPoint("TOPLEFT", 13, -25)
    _G.CombatConfigMessageSourcesDoneTo:SetPoint("TOPLEFT", _G.CombatConfigMessageSourcesDoneBy, "TOPRIGHT", 50, 0)

    _G.CombatConfigMessageTypesLeft:SetPoint("TOPLEFT", 11, -10)
    _G.CombatConfigMessageTypesRight:SetPoint("TOPLEFT", _G.CombatConfigMessageTypesLeft, "TOPRIGHT", 230, 0)
    _G.CombatConfigMessageTypesMisc:SetPoint("TOPLEFT", _G.CombatConfigMessageTypesRight, "BOTTOMLEFT", 0, -20)

    _G.CombatConfigColorsExampleString1:SetSize(450, 0)
    _G.CombatConfigColorsExampleString1:SetPoint("TOPLEFT", 25, -27)
    _G.CombatConfigColorsExampleString2:SetSize(450, 0)
    _G.CombatConfigColorsExampleTitle:SetSize(0, 13)
    _G.CombatConfigColorsExampleTitle:SetPoint("BOTTOM", _G.CombatConfigColorsExampleString1, "TOP", 0, 3)
    _G.CombatConfigColorsUnitColors:SetPoint("BOTTOMLEFT", _G.ChatConfigBackgroundFrame, 13, 89)
    _G.CombatConfigColorsHighlighting:SetPoint("TOPLEFT", _G.CombatConfigColorsUnitColors, "BOTTOMLEFT", 0, -25)
    _G.CombatConfigColorsHighlightingTitle:SetPoint("BOTTOMLEFT", _G.CombatConfigColorsHighlighting, "TOPLEFT", 0, 2)
    _G.CombatConfigColorsHighlightingLine:SetPoint("TOPLEFT", 6, -4)
    _G.CombatConfigColorsHighlightingAbility:SetPoint("LEFT", _G.CombatConfigColorsHighlightingLine, "RIGHT", 60, 0)
    _G.CombatConfigColorsHighlightingDamage:SetPoint("TOPLEFT", _G.CombatConfigColorsHighlightingLine, "BOTTOMLEFT", 0, 3)
    _G.CombatConfigColorsHighlightingSchool:SetPoint("LEFT", _G.CombatConfigColorsHighlightingDamage, "RIGHT", 60, 0)
    _G.CombatConfigColorsColorize:SetPoint("TOPLEFT", _G.CombatConfigColorsUnitColors, "TOPRIGHT", 50, 0)
    _G.CombatConfigColorsColorizeUnitName:SetSize(200, 32)
    _G.CombatConfigColorsColorizeUnitNameCheck:SetPoint("LEFT", 7, 0)
    _G.CombatConfigColorsColorizeSpellNames:SetSize(200, 52)
    _G.CombatConfigColorsColorizeSpellNamesCheck:SetPoint("TOPLEFT", 7, -4)
    _G.CombatConfigColorsColorizeSpellNamesSchoolColoring:SetPoint("TOPLEFT", _G.CombatConfigColorsColorizeSpellNamesCheck, "BOTTOMLEFT", 10, 0)
    _G.CombatConfigColorsColorizeSpellNamesColorSwatch:SetPoint("TOPRIGHT", -8, -8)
    _G.CombatConfigColorsColorizeDamageNumber:SetSize(200, 52)
    _G.CombatConfigColorsColorizeDamageNumberCheck:SetPoint("TOPLEFT", 7, -4)
    _G.CombatConfigColorsColorizeDamageNumberSchoolColoring:SetPoint("TOPLEFT", _G.CombatConfigColorsColorizeDamageNumberCheck, "BOTTOMLEFT", 10, 0)
    _G.CombatConfigColorsColorizeDamageNumberColorSwatch:SetPoint("TOPRIGHT", -8, -8)
    _G.CombatConfigColorsColorizeDamageSchool:SetSize(200, 32)
    _G.CombatConfigColorsColorizeDamageSchoolCheck:SetPoint("LEFT", 7, 0)
    _G.CombatConfigColorsColorizeEntireLine:SetSize(200, 52)
    _G.CombatConfigColorsColorizeEntireLineCheck:SetPoint("TOPLEFT", 7, -4)
    _G.CombatConfigColorsColorizeEntireLineBySource:SetPoint("TOPLEFT", _G.CombatConfigColorsColorizeEntireLineCheck, "BOTTOMLEFT", 10, 0)
    _G.CombatConfigColorsColorizeEntireLineByTarget:SetPoint("LEFT", _G.CombatConfigColorsColorizeEntireLineBySourceText, "RIGHT", 10, 0)

    _G.CombatConfigFormatting:SetPoint("TOPLEFT", _G.ChatConfigBackgroundFrame, 10, 0)
    _G.CombatConfigFormattingExampleString1:SetSize(450, 0)
    _G.CombatConfigFormattingExampleString1:SetPoint("TOPLEFT", 15, -27)
    _G.CombatConfigFormattingExampleString2:SetSize(450, 0)
    _G.CombatConfigFormattingExampleTitle:SetSize(0, 13)
    _G.CombatConfigFormattingExampleTitle:SetPoint("BOTTOM", _G.CombatConfigFormattingExampleString1, "TOP", 0, 3)
    _G.CombatConfigFormattingShowTimeStamp:SetPoint("TOPLEFT", _G.CombatConfigFormattingExampleString2, "BOTTOMLEFT", 0, -20)
    _G.CombatConfigFormattingShowBraces:SetPoint("TOPLEFT", _G.CombatConfigFormattingShowTimeStamp, "BOTTOMLEFT", 0, -15)
    _G.CombatConfigFormattingUnitNames:SetPoint("TOPLEFT", _G.CombatConfigFormattingShowBraces, "BOTTOMLEFT", 10, 0)
    _G.CombatConfigFormattingSpellNames:SetPoint("TOPLEFT", _G.CombatConfigFormattingUnitNames, "BOTTOMLEFT", 0, -2)
    _G.CombatConfigFormattingItemNames:SetPoint("TOPLEFT", _G.CombatConfigFormattingSpellNames, "BOTTOMLEFT", 0, -2)
    _G.CombatConfigFormattingFullText:SetPoint("TOPLEFT", _G.CombatConfigFormattingItemNames, "BOTTOMLEFT", -10, -13)

    _G.CombatConfigSettings:SetPoint("TOPLEFT", 13, -25)
    _G.CombatConfigSettingsNameEditBox:SetPoint("TOPLEFT", _G.CombatConfigFormatting, 27, -26)
    select(4, _G.CombatConfigSettingsNameEditBox:GetRegions()):SetPoint("BOTTOMLEFT", _G.CombatConfigSettingsNameEditBox, "TOPLEFT", 27, -26)
    _G.CombatConfigSettingsSaveButton:SetPoint("LEFT", _G.CombatConfigSettingsNameEditBox, "RIGHT", 8, 0)
    _G.CombatConfigSettingsShowQuickButton:SetPoint("TOPLEFT", _G.CombatConfigSettingsNameEditBox, "BOTTOMLEFT", -6, -19)
    _G.CombatConfigSettingsSolo:SetPoint("TOPLEFT", _G.CombatConfigSettingsShowQuickButton, "BOTTOMLEFT", 20, 0)
    _G.CombatConfigSettingsParty:SetPoint("LEFT", _G.CombatConfigSettingsSolo, "RIGHT", 60, 0)
    _G.CombatConfigSettingsRaid:SetPoint("LEFT", _G.CombatConfigSettingsParty, "RIGHT", 60, 0)
end
