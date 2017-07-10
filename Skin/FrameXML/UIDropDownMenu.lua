local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)
local Skin, Hook = Aurora.Skin, Aurora.Hook

do --[[ FrameXML\UIDropDownMenu.lua ]]
    local skinnedLevels, skinnedButtons = 2, 8 -- mirrors for UIDROPDOWNMENU_MAXLEVELS and UIDROPDOWNMENU_MAXBUTTONS
    function Hook.UIDropDownMenu_CreateFrames(level, index)
        while level > skinnedLevels do
            -- New list frames have been created, skin them!
            skinnedLevels = skinnedLevels + 1
            local listFrameName = "DropDownList"..skinnedLevels
            Skin.UIDropDownListTemplate(listFrameName)
            for i = _G.UIDROPDOWNMENU_MINBUTTONS + 1, skinnedButtons do
                -- If skinnedButtons is more than the default, we need to skin those too for the new list
                Skin.UIDropDownMenuButtonTemplate(listFrameName, listFrameName.."Button"..i)
            end
        end

        while index > skinnedButtons do
            skinnedButtons = skinnedButtons + 1
            for i = 1, skinnedLevels do
                local listFrameName = "DropDownList"..i
                Skin.UIDropDownMenuButtonTemplate(listFrameName, listFrameName.."Button"..skinnedButtons)
            end
        end
    end
    function Hook.UIDropDownMenu_AddButton(info, level)
        if not level then level = 1 end

        local listFrameName = "DropDownList"..level
        local listFrame = _G[listFrameName]
        local index = listFrame.numButtons

        local menuButtonName = listFrameName.."Button"..index
        local menuButton = _G[menuButtonName]

        local checkBox = menuButton._auroraCheckBox
        if not info.notCheckable then
            local check = checkBox.check

            checkBox:Show()
            if info.isNotRadio then
                checkBox:SetSize(12, 12)
                checkBox:SetPoint("LEFT")
                check:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
                check:SetSize(20, 20)
                check:SetAlpha(1)
            else
                checkBox:SetSize(8, 8)
                checkBox:SetPoint("LEFT", 4, 0)
                check:SetTexture(C.media.backdrop)
                check:SetSize(6, 6)
                check:SetAlpha(0.6)
            end

            local checked = info.checked
            if _G.type(checked) == "function" then
                checked = checked(menuButton)
            end

            if checked then
                check:Show()
            else
                check:Hide()
            end

            _G[menuButtonName.."Check"]:Hide()
            _G[menuButtonName.."UnCheck"]:Hide()
        else
            checkBox:Hide()
        end
    end
    function Hook.UIDropDownMenu_SetIconImage(icon, texture, info)
        if texture:find("Divider") then
            icon:SetColorTexture(1, 1, 1, .2)
            icon:SetHeight(1)
        end
    end
end

do --[[ FrameXML\UIDropDownMenuTemplates.xml ]]
    function Skin.UIDropDownMenuButtonTemplate(listFrameName, menuButtonName)
        local listFrame = _G[listFrameName]
        local menuButton = _G[menuButtonName]

        local highlight = _G[menuButtonName.."Highlight"]
        highlight:ClearAllPoints()
        highlight:SetPoint("LEFT", listFrame, 1, 0)
        highlight:SetPoint("RIGHT", listFrame, -1, 0)
        highlight:SetPoint("TOP", 0, 0)
        highlight:SetPoint("BOTTOM", 0, 0)
        highlight:SetColorTexture(C.r, C.g, C.b, .2)

        local checkBox = _G.CreateFrame("Frame", nil, menuButton)
        F.CreateBD(checkBox)
        menuButton._auroraCheckBox = checkBox

        local check = checkBox:CreateTexture(nil, "ARTWORK")
        check:SetDesaturated(true)
        check:SetVertexColor(C.r, C.g, C.b)
        check:SetPoint("CENTER")
        checkBox.check = check

        local arrow = _G[menuButtonName.."ExpandArrow"]
        arrow:SetNormalTexture(C.media.arrowRight)
        arrow:SetSize(8, 8)
    end
    function Skin.UIDropDownListTemplate(listFrameName)
        F.CreateBD(_G[listFrameName.."Backdrop"])
        F.CreateBD(_G[listFrameName.."MenuBackdrop"])
        for i = 1, _G.UIDROPDOWNMENU_MINBUTTONS do
            Skin.UIDropDownMenuButtonTemplate(listFrameName, listFrameName.."Button"..i)
        end
    end
    function Skin.UIDropDownMenuTemplate(frame)
    end
end

function private.FrameXML.UIDropDownMenu()
    _G.hooksecurefunc("UIDropDownMenu_CreateFrames", Hook.UIDropDownMenu_CreateFrames)
    _G.hooksecurefunc("UIDropDownMenu_AddButton", Hook.UIDropDownMenu_AddButton)
    _G.hooksecurefunc("UIDropDownMenu_SetIconImage", Hook.UIDropDownMenu_SetIconImage)

    Skin.UIDropDownListTemplate("DropDownList1")
    Skin.UIDropDownListTemplate("DropDownList2")
end
