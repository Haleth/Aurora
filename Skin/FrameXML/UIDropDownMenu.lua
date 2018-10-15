local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\UIDropDownMenu.lua ]]
    function Hook.UIDropDownMenu_RefreshDropDownSize(self)
        Scale.RawSetWidth(self, self.maxWidth + Scale.Value(25))
    end

    local skinnedLevels, skinnedButtons = 2, private.isPatch and 1 or 8 -- mirrors for UIDROPDOWNMENU_MAXLEVELS and UIDROPDOWNMENU_MAXBUTTONS
    function Hook.UIDropDownMenu_CreateFrames(level, index)
        while level > skinnedLevels do
            -- New list frames have been created, skin them!
            skinnedLevels = skinnedLevels + 1
            local listFrameName = "DropDownList"..skinnedLevels
            Skin.UIDropDownListTemplate(listFrameName)
            for i = _G.UIDROPDOWNMENU_MINBUTTONS + 1, skinnedButtons do
                -- If skinnedButtons is more than the default, we need to skin those too for the new list
                Skin.UIDropDownMenuButtonTemplate(_G[listFrameName.."Button"..i])
            end
        end

        while index > skinnedButtons do
            skinnedButtons = skinnedButtons + 1
            for i = 1, skinnedLevels do
                local listFrameName = "DropDownList"..i
                Skin.UIDropDownMenuButtonTemplate(_G[listFrameName.."Button"..skinnedButtons])
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
        if not checkBox then return end

        if not info.notCheckable then
            local check = checkBox.check
            local hasCustomIcon = false

            checkBox:Show()
            check:SetTexCoord(0, 1, 0, 1)
            check:SetDesaturated(true)
            check:SetVertexColor(Color.highlight:GetRGB())
            if info.customCheckIconAtlas or info.customCheckIconTexture then
                checkBox:Hide()
                check:SetDesaturated(false)
                check:SetVertexColor(Color.white:GetRGB())
                check:SetSize(16, 16)
                hasCustomIcon = true

                if info.customCheckIconAtlas then
                    check:SetAtlas(info.customCheckIconAtlas)
                else
                    check:SetTexture(info.customCheckIconTexture)
                end
            elseif info.isNotRadio then
                checkBox:SetSize(12, 12)
                checkBox:SetPoint("LEFT")
                check:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
                check:SetSize(20, 20)
                check:SetAlpha(1)
            else
                checkBox:SetSize(8, 8)
                checkBox:SetPoint("LEFT", 4, 0)
                check:SetTexture([[Interface\Buttons\WHITE8x8]])
                check:SetSize(6, 6)
                check:SetAlpha(0.6)
            end

            local checked = info.checked
            if _G.type(checked) == "function" then
                checked = checked(menuButton)
            end

            if checked or hasCustomIcon then
                check:Show()
            else
                check:Hide()
            end

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
    function Hook.UIDropDownMenuButton_OnClick(self)
        if self.checked then
            self._auroraCheckBox.check:Show()
        else
            self._auroraCheckBox.check:Hide()
        end

        _G[self:GetName().."UnCheck"]:Hide()
    end
end

do --[[ FrameXML\UIDropDownMenuTemplates.xml ]]
    function Skin.UIDropDownMenuButtonTemplate(Button)
        local listFrame = Button:GetParent()
        local name = Button:GetName()

        local highlight = _G[name.."Highlight"]
        highlight:ClearAllPoints()
        highlight:SetPoint("LEFT", listFrame, 1, 0)
        highlight:SetPoint("RIGHT", listFrame, -1, 0)
        highlight:SetPoint("TOP", 0, 0)
        highlight:SetPoint("BOTTOM", 0, 0)
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, .2)

        local checkBox = _G.CreateFrame("Frame", nil, Button)
        checkBox:SetFrameLevel(Button:GetFrameLevel())
        Base.SetBackdrop(checkBox, Color.button)
        Button._auroraCheckBox = checkBox

        local check = _G[name.."Check"]
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())
        check:ClearAllPoints()
        check:SetPoint("CENTER", checkBox)
        checkBox.check = check

        local arrow = _G[name.."ExpandArrow"]
        Base.SetTexture(arrow:GetNormalTexture(), "arrowRight")
        arrow:SetSize(7, 8)
        arrow:SetPoint("RIGHT", -2, 0)

        Button:HookScript("OnClick", Hook.UIDropDownMenuButton_OnClick)
    end
    function Skin.UIDropDownListTemplate(Button)
        local name = Button:GetName()
        Base.SetBackdrop(_G[name.."Backdrop"])
        Base.SetBackdrop(_G[name.."MenuBackdrop"])
        if private.isPatch then
            Skin.UIDropDownMenuButtonTemplate(_G[name.."Button1"])
        else
            for i = 1, _G.UIDROPDOWNMENU_MINBUTTONS do
                Skin.UIDropDownMenuButtonTemplate(_G[name.."Button"..i])
            end
        end
    end
    function Skin.UIDropDownMenuTemplate(Frame)
        Frame.Left:SetAlpha(0)
        Frame.Middle:SetAlpha(0)
        Frame.Right:SetAlpha(0)

        local button = Frame.Button
        button:SetSize(20, 20)
        button:ClearAllPoints()
        button:SetPoint("TOPRIGHT", Frame.Right, -19, -21)

        button.NormalTexture:SetTexture("")
        button.PushedTexture:SetTexture("")
        button.HighlightTexture:SetTexture("")

        local disabled = button.DisabledTexture
        disabled:SetAllPoints(button)
        disabled:SetColorTexture(0, 0, 0, .3)
        disabled:SetDrawLayer("OVERLAY")
        Base.SetBackdrop(button, Color.button)

        local arrow = button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 4, -7)
        arrow:SetPoint("BOTTOMRIGHT", -4, 7)
        Base.SetTexture(arrow, "arrowDown")

        button._auroraHighlight = {arrow}
        Base.SetHighlight(button, "texture")

        local bg = _G.CreateFrame("Frame", nil, Frame)
        bg:SetPoint("TOPLEFT", Frame.Left, 20, -21)
        bg:SetPoint("BOTTOMRIGHT", Frame.Right, -19, 23)
        bg:SetFrameLevel(Frame:GetFrameLevel())
        Base.SetBackdrop(bg, Color.button)


        --[[Scale]]
        if not Frame.noResize then
            Frame:SetWidth(40)
            Frame.Middle:SetWidth(115)
        end
        Frame:SetHeight(32)

        Frame.Left:SetSize(25, 64)
        Frame.Left:SetPoint("TOPLEFT", 0, 17)
        Frame.Middle:SetHeight(64)
        Frame.Right:SetSize(25, 64)

        Frame.Text:SetSize(0, 10)
        Frame.Text:SetPoint("RIGHT", Frame.Right, -43, 2)
    end
end

function private.FrameXML.UIDropDownMenu()
    _G.hooksecurefunc("UIDropDownMenu_RefreshDropDownSize", Hook.UIDropDownMenu_RefreshDropDownSize)
    _G.hooksecurefunc("UIDropDownMenu_CreateFrames", Hook.UIDropDownMenu_CreateFrames)
    _G.hooksecurefunc("UIDropDownMenu_AddButton", Hook.UIDropDownMenu_AddButton)
    _G.hooksecurefunc("UIDropDownMenu_SetIconImage", Hook.UIDropDownMenu_SetIconImage)

    Skin.UIDropDownListTemplate(_G.DropDownList1)
    Skin.UIDropDownListTemplate(_G.DropDownList2)
end
