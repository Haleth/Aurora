local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals tinsert max

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\StaticPopup.lua ]]
    function Hook.StaticPopup_Resize(dialog, which)
        local info = _G.StaticPopupDialogs[which]
        if ( not info ) then
            return nil
        end

        local text = _G[dialog:GetName().."Text"]
        local editBox = _G[dialog:GetName().."EditBox"]
        local button1 = _G[dialog:GetName().."Button1"]

        local maxHeightSoFar, maxWidthSoFar = dialog.maxHeightSoFar or 0, dialog.maxWidthSoFar or 0
        local width = 320

        if ( info.verticalButtonLayout ) then
            width = width + 30
        else
            if ( dialog.numButtons == 4 ) then
                width = 574
            elseif ( dialog.numButtons == 3 ) then
                width = 440
            elseif (info.showAlert or info.showAlertGear or info.closeButton or info.wide) then
                -- Widen
                width = 420
            elseif ( info.editBoxWidth and info.editBoxWidth > 260 ) then
                width = width + (info.editBoxWidth - 260)
            elseif ( which == "HELP_TICKET" ) then
                width = 350
            elseif ( which == "GUILD_IMPEACH" ) then
                width = 375
            end
        end
        if ( dialog.insertedFrame ) then
            width = max(Scale.Value(width), dialog.insertedFrame:GetWidth())
        end
        if ( width > maxWidthSoFar )  then
            Scale.RawSetWidth(dialog, width)
            dialog.maxWidthSoFar = width
        end

        local height = Scale.Value(32) + text:GetHeight() + Scale.Value(2)
        if (not info.nobuttons) then
            height = height + Scale.Value(6) + button1:GetHeight()
        end
        if ( info.hasEditBox ) then
            height = height + Scale.Value(8) + editBox:GetHeight()
        elseif ( info.hasMoneyFrame ) then
            height = height + Scale.Value(16)
        elseif ( info.hasMoneyInputFrame ) then
            height = height + Scale.Value(22)
        end
        if ( dialog.insertedFrame ) then
            height = height + dialog.insertedFrame:GetHeight()
        end
        if ( info.hasItemFrame ) then
            height = height + Scale.Value(64)
        end

        if ( info.verticalButtonLayout ) then
            height = height + Scale.Value(16) + (Scale.Value(26) * (dialog.numButtons - 1))
        end

        if ( height > maxHeightSoFar ) then
            Scale.RawSetHeight(dialog, height)
            dialog.maxHeightSoFar = height
        end
    end
end

do --[[ FrameXML\StaticPopup.xml ]]
    function Skin.StaticPopupButtonTemplate(Button)
        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetDisabledTexture("")
        Button:SetHighlightTexture("")

        Base.SetBackdrop(Button, Color.button)
        Base.SetHighlight(Button, "backdrop")

        --[[ Scale ]]--
        Button:SetSize(Button:GetSize())
    end

    local function CloseButton_SetNormalTexture(Button, texture)
        if Button._setNormal then return end
        Button._setNormal = true
        Button:SetNormalTexture("")
        if texture:find("Hide") then
            Button._auroraHighlight[1]:Hide()
            Button._auroraHighlight[2]:Show()
        else
            Button._auroraHighlight[1]:Show()
            Button._auroraHighlight[2]:Hide()
        end
        Button._setNormal = nil
    end
    local function CloseButton_SetPushedTexture(Button, texture)
        if Button._setPushed then return end
        Button._setPushed = true
        Button:SetPushedTexture("")
        Button._setPushed = nil
    end
    function Skin.StaticPopupTemplate(Frame)
        local name = Frame:GetName()
        Base.SetBackdrop(Frame)

        local close = _G[name .. "CloseButton"]
        Skin.UIPanelCloseButton(close)

        local hideTex = close:CreateTexture(nil, "ARTWORK")
        hideTex:SetColorTexture(1, 1, 1)
        hideTex:SetPoint("TOPLEFT", close, "BOTTOMLEFT", 4, 5)
        hideTex:SetPoint("BOTTOMRIGHT", -4, 4)
        tinsert(close._auroraHighlight, hideTex)

        _G.hooksecurefunc(close, "SetNormalTexture", CloseButton_SetNormalTexture)
        _G.hooksecurefunc(close, "SetPushedTexture", CloseButton_SetPushedTexture)

        Skin.StaticPopupButtonTemplate(Frame.button1)
        Skin.StaticPopupButtonTemplate(Frame.button2)
        Skin.StaticPopupButtonTemplate(Frame.button3)
        Skin.StaticPopupButtonTemplate(Frame.button4)
        if private.isPatch then
            Skin.StaticPopupButtonTemplate(Frame.extraButton)
        end

        local EditBox = _G[name .. "EditBox"]
        EditBox.Left = _G[name .. "EditBoxLeft"]
        EditBox.Right = _G[name .. "EditBoxRight"]
        EditBox.Middle = _G[name .. "EditBoxMid"]
        Skin.InputBoxTemplate(EditBox) -- BlizzWTF: this should use InputBoxTemplate

        Skin.SmallMoneyFrameTemplate(Frame.moneyFrame)
        Skin.MoneyInputFrameTemplate(Frame.moneyInputFrame)
        Skin.ItemButtonTemplate(Frame.ItemFrame)

        local nameFrame = _G[Frame.ItemFrame:GetName().."NameFrame"]
        nameFrame:Hide()

        local nameBG = _G.CreateFrame("Frame", nil, Frame.ItemFrame)
        nameBG:SetPoint("TOPLEFT", Frame.ItemFrame.icon, "TOPRIGHT", 2, 1)
        nameBG:SetPoint("BOTTOMLEFT", Frame.ItemFrame.icon, "BOTTOMRIGHT", 2, -1)
        nameBG:SetPoint("RIGHT", 120, 0)
        Base.SetBackdrop(nameBG, Color.frame)

        --[[ Scale ]]--
        _G[name .. "Text"]:SetSize(290, 0)
        _G[name .. "Text"]:SetPoint("TOP", 0, -16)
        _G[name .. "AlertIcon"]:SetSize(36, 36)
        _G[name .. "AlertIcon"]:SetPoint("LEFT", 24, 0)
        Frame.editBox:SetSize(130, 32)
        Frame.editBox:SetPoint("BOTTOM", 0, 45)
        Frame.moneyFrame:SetPoint("TOP", Frame.text, "BOTTOM", 0, -5)
        Frame.moneyInputFrame:SetPoint("TOP", Frame.text, "BOTTOM", 0, -5)
        Frame.ItemFrame:SetSize(37, 37)
        Frame.ItemFrame:SetPoint("BOTTOM", Frame.button1, "TOP", 0, 8)
        Frame.ItemFrame:SetPoint("LEFT", 82, 0)

        local itemText = _G[Frame.ItemFrame:GetName().."Text"]
        itemText:ClearAllPoints()
        itemText:SetPoint("TOPLEFT", nameBG, 4, -4)
        itemText:SetPoint("BOTTOMRIGHT", nameBG, -4, 4)
    end
end

function private.FrameXML.StaticPopup()
    _G.hooksecurefunc("StaticPopup_Resize", Hook.StaticPopup_Resize)

    Skin.StaticPopupTemplate(_G.StaticPopup1)
    Skin.StaticPopupTemplate(_G.StaticPopup2)
    Skin.StaticPopupTemplate(_G.StaticPopup3)
    Skin.StaticPopupTemplate(_G.StaticPopup4)
end
