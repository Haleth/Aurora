local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\FloatingChatFrame.lua ]]
    function Hook.FCF_SetWindowColor(frame, r, g, b, doNotSave)
        frame:SetBackdropColor(r, g, b)
        frame:SetBackdropBorderColor(r, g, b)

        frame.buttonFrame:SetBackdropColor(r, g, b)
        frame.buttonFrame:SetBackdropBorderColor(r, g, b)
    end
    function Hook.FCF_SetButtonSide(chatFrame, buttonSide, forceUpdate)
        if buttonSide == "left" then
            chatFrame.buttonFrame:SetPoint("TOPRIGHT", chatFrame.Background, "TOPLEFT", 0, 0)
            chatFrame.buttonFrame:SetPoint("BOTTOMRIGHT", chatFrame.Background, "BOTTOMLEFT", 0, 0)
        elseif buttonSide == "right" then
            chatFrame.buttonFrame:SetPoint("TOPLEFT", chatFrame.Background, "TOPRIGHT", 0, 0)
            chatFrame.buttonFrame:SetPoint("BOTTOMLEFT", chatFrame.Background, "BOTTOMRIGHT", 0, 0)
        end
    end
    function Hook.FCF_CreateMinimizedFrame(chatFrame)
        local minFrame = _G[chatFrame:GetName().."Minimized"]
        Skin.FloatingChatFrameMinimizedTemplate(minFrame)
    end
end

do --[[ FrameXML\FloatingChatFrame.xml ]]
    function Skin.FloatingBorderedFrame(Frame)
        local bg, tl, bl, tr, br, l, r, b, t = Frame:GetRegions()
        Base.CreateBackdrop(Frame, private.backdrop, {
            bg = bg,

            l = l,
            r = r,
            t = t,
            b = b,

            tl = tl,
            tr = tr,
            bl = bl,
            br = br,

            borderLayer = "BACKGROUND",
            borderSublevel = -7,
        })
        Base.SetBackdrop(Frame)
    end
    function Skin.ChatTabArtTemplate(Button)
        Button.leftTexture:SetAlpha(0)
        Button.middleTexture:SetAlpha(0)
        Button.rightTexture:SetAlpha(0)

        Button.leftSelectedTexture:SetAlpha(0)
        Button.middleSelectedTexture:SetAlpha(0)
        Button.rightSelectedTexture:SetAlpha(0)

        Button.leftHighlightTexture:SetAlpha(0)
        Button.middleHighlightTexture:SetAlpha(0)
        Button.rightHighlightTexture:SetAlpha(0)
    end
    function Skin.ChatTabTemplate(Button)
        Skin.ChatTabArtTemplate(Button)
        Button:SetHighlightFontObject("GameFontHighlightSmall")
    end
    function Skin.FloatingChatFrameTemplate(ScrollingMessageFrame)
        Skin.FloatingBorderedFrame(ScrollingMessageFrame)
        Skin.FloatingBorderedFrame(ScrollingMessageFrame.buttonFrame)

        local minimizeButton = ScrollingMessageFrame.buttonFrame.minimizeButton
        Skin.ChatFrameButton(minimizeButton)
        minimizeButton:SetSize(23, 23)
        minimizeButton:SetPoint("TOP", ScrollingMessageFrame.buttonFrame, 0, -3)
        local line = minimizeButton:CreateTexture(nil, "ARTWORK")
        line:SetPoint("TOPLEFT", minimizeButton, "BOTTOMLEFT", 3, 6)
        line:SetPoint("BOTTOMRIGHT", -3, 3)
        line:SetColorTexture(1, 1, 1)

        local ScrollToBottomButton = ScrollingMessageFrame.ScrollToBottomButton
        ScrollToBottomButton:SetSize(17, 17)
        ScrollToBottomButton:SetPoint("BOTTOMRIGHT", ScrollingMessageFrame.ResizeButton, "TOPRIGHT", -5, 0)
        Skin.ChatFrameButton(ScrollToBottomButton)
        local arrow = ScrollToBottomButton:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 3, -3)
        arrow:SetPoint("BOTTOMRIGHT", -3, 5)
        Base.SetTexture(arrow, "arrowDown")

        local bottom = ScrollToBottomButton:CreateTexture(nil, "ARTWORK")
        bottom:SetPoint("TOPLEFT", ScrollToBottomButton, "BOTTOMLEFT", 3, 5)
        bottom:SetPoint("BOTTOMRIGHT", -3, 3)
        bottom:SetColorTexture(1, 1, 1)

        Skin.ScrollBarThumb(ScrollingMessageFrame.ScrollBar.ThumbTexture)

        Hook.FCF_SetButtonSide(ScrollingMessageFrame, _G.FCF_GetButtonSide(ScrollingMessageFrame))
        _G.FloatingChatFrame_UpdateBackgroundAnchors(ScrollingMessageFrame)

        Skin.ChatFrameEditBoxTemplate(ScrollingMessageFrame.editBox)
        ScrollingMessageFrame.editBox:SetPoint("TOPLEFT", ScrollingMessageFrame, "BOTTOMLEFT", 0, -5)
        ScrollingMessageFrame.editBox:SetPoint("RIGHT", ScrollingMessageFrame.ScrollBar)
    end
    function Skin.FloatingChatFrameMinimizedTemplate(Button)
        Button:SetSize(172, 23)
        Button.leftTexture:Hide()
        Button.rightTexture:Hide()
        Button.middleTexture:Hide()
        Button.leftHighlightTexture:Hide()
        Button.rightHighlightTexture:Hide()
        Button.middleHighlightTexture:Hide()

        Base.SetBackdrop(Button)
        Base.SetHighlight(Button, "backdrop")

        local MaximizeButton = _G[Button:GetName().."MaximizeButton"]
        MaximizeButton:SetSize(17, 17)
        Skin.ChatFrameButton(MaximizeButton)
        local box1 = MaximizeButton:CreateTexture(nil, "ARTWORK", nil, 0)
        box1:SetPoint("TOPLEFT", 6, -3)
        box1:SetPoint("BOTTOMRIGHT", -3, 6)
        box1:SetColorTexture(Color.gray:GetRGB())

        local box2 = MaximizeButton:CreateTexture(nil, "ARTWORK", nil, 2)
        box2:SetPoint("TOPLEFT", 3, -6)
        box2:SetPoint("BOTTOMRIGHT", -6, 3)
        box2:SetColorTexture(Color.white:GetRGB())
    end

    function Skin.ChatFrameButton(Button)
        Base.SetBackdrop(Button, Color.button, 0.3)
        Base.SetHighlight(Button, "backdrop")

        Button:SetNormalTexture("")
        Button:SetPushedTexture("")
        Button:SetHighlightTexture("")
        local disabled = Button:GetDisabledTexture()
        if disabled then
            disabled:SetColorTexture(0, 0, 0, .4)
            disabled:SetDrawLayer("OVERLAY")
            disabled:SetAllPoints()
        end
    end
end

function private.FrameXML.FloatingChatFrame()
    if private.disabled.chat then return end

    _G.hooksecurefunc("FCF_SetWindowColor", Hook.FCF_SetWindowColor)
    _G.hooksecurefunc("FCF_SetButtonSide", Hook.FCF_SetButtonSide)
    _G.hooksecurefunc("FCF_CreateMinimizedFrame", Hook.FCF_CreateMinimizedFrame)

    for i = 1, 10 do
        local name = "ChatFrame"..i
        Skin.ChatTabTemplate(_G[name.."Tab"])
        Skin.FloatingChatFrameTemplate(_G[name])
    end

    Skin.ChatFrameButton(_G.ChatFrameMenuButton)
    _G.ChatFrameMenuButton:SetSize(23, 23)
    _G.ChatFrameMenuButton:SetPoint("BOTTOM", _G.ChatFrame1ButtonFrame, 0, 3)
    local chatIcon = _G.ChatFrameMenuButton:CreateTexture(nil, "ARTWORK")
    chatIcon:SetPoint("TOPLEFT", _G.ChatFrameMenuButton, 3, -3)
    chatIcon:SetPoint("BOTTOMRIGHT", _G.ChatFrameMenuButton, -3, 3)
    chatIcon:SetTexture([[Interface\GossipFrame\ChatBubbleGossipIcon]])

    Skin.VoiceToggleButtonTemplate(_G.ChatFrameChannelButton)
    _G.ChatFrameChannelButton:SetPoint("TOP", _G.ChatFrame1ButtonFrame, 0, -3)
    Skin.ToggleVoiceDeafenButtonTemplate(_G.ChatFrameToggleVoiceDeafenButton)
    Skin.ToggleVoiceMuteButtonTemplate(_G.ChatFrameToggleVoiceMuteButton)

    Skin.UIMenuTemplate(_G.ChatMenu)
    Skin.UIMenuTemplate(_G.EmoteMenu)
    Skin.UIMenuTemplate(_G.LanguageMenu)
    Skin.UIMenuTemplate(_G.VoiceMacroMenu)
end
